from flask_cors import CORS
from flask import Flask, request, jsonify, render_template, send_from_directory, send_file
from werkzeug.utils import secure_filename
from utils.analyzer import process_medical_report
import os
import cv2
import numpy as np
import tensorflow as tf
import time
import base64
import uuid
from services.pose_prediction import predict_pose_service
from models.load_model import model
# from pose_list import pose_classes
import mediapipe as mp
from tensorflow.keras.preprocessing.image import img_to_array

UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'outputs'
ALLOWED_EXTENSIONS = {'pdf', 'png', 'jpg', 'jpeg'}

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['OUTPUT_FOLDER'] = OUTPUT_FOLDER
app.secret_key = 'secret!'


os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs(app.config['OUTPUT_FOLDER'], exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def extract_pose_name(filename):
    name_part = filename.rsplit('.', 1)[0] 
    return name_part.replace('_', ' ').strip()

@app.route('/predict_pose', methods=['POST'])
def predict_pose():
    data = request.get_json()
    frame_data = data.get('frame')
    target_pose = data.get('target_pose')

    if not frame_data or not target_pose:
        return jsonify({"error": "Invalid input data"}), 400

    response = predict_pose_service(frame_data, target_pose)
    return jsonify(response)

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({"error": "Image is required"}), 400

    file = request.files['image']

    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if not allowed_file(file.filename):
        return jsonify({"error": "Invalid file type"}), 400

    target_pose = extract_pose_name(file.filename)

    filename = secure_filename(file.filename)
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)

    with open(filepath, 'rb') as image_file:
        frame_data = base64.b64encode(image_file.read()).decode('utf-8')

    response = predict_pose_service(frame_data, target_pose)

    response['image_path'] = f'/static/uploads/{filename}'

    return jsonify(response)

@app.route('/analyze', methods=['POST'])
def analyze():
    try:
        files = request.files.getlist('files')
        print("heyy", files);
        if not files:
            return jsonify({'error': 'No files uploaded'}), 400

        saved_paths = []
        for file in files:
            if allowed_file(file.filename):
                filename = f"{uuid.uuid4().hex}_{secure_filename(file.filename)}"
                file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(file_path)
                saved_paths.append(file_path)
            else:
                return jsonify({'error': f'Invalid file type: {file.filename}'}), 400

        output_file = os.path.join(app.config['OUTPUT_FOLDER'], f"{uuid.uuid4().hex}_summary.pdf")
        success, error = process_medical_report(saved_paths, output_file)

        if not success:
            return jsonify({'error': error}), 500

        return jsonify({'message': 'Analysis complete', 'output_pdf': os.path.basename(output_file)})

    except Exception as e:
        print("Exception occurred:", str(e))
        return jsonify({'error': 'Internal server error', 'details': str(e)}), 500

@app.route('/download/<filename>', methods=['GET'])
def download(filename):
    return send_from_directory(app.config['OUTPUT_FOLDER'], filename, as_attachment=True)

@app.route('/')
def index():
    return render_template('index.html')



with open("pose_classes.txt", "r") as f:
    pose_classes = sorted([line.strip() for line in f.readlines()])

mp_pose = mp.solutions.pose
pose = mp_pose.Pose(static_image_mode=False, min_detection_confidence=0.5, min_tracking_confidence=0.5)

def preprocess_image(image, img_height=160, img_width=160):
    image = cv2.resize(image, (img_width, img_height))
    image = img_to_array(image)
    image = np.expand_dims(image, axis=0)
    image = tf.keras.applications.efficientnet.preprocess_input(image)
    return image

def check_pose(frame, target_pose):
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = pose.process(frame_rgb)

    if results.pose_landmarks:
        mp.solutions.drawing_utils.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)
        height, width, _ = frame.shape
        landmarks = results.pose_landmarks.landmark
        x_min = max(0, int(min([lm.x for lm in landmarks]) * width))
        y_min = max(0, int(min([lm.y for lm in landmarks]) * height))
        x_max = min(width, int(max([lm.x for lm in landmarks]) * width))
        y_max = min(height, int(max([lm.y for lm in landmarks]) * height))

        roi = frame[y_min:y_max, x_min:x_max]
        if roi.size == 0:
            return False, 0, "No ROI"

        processed_image = preprocess_image(roi)
        predictions = model.predict(processed_image, verbose=0)
        predicted_class = np.argmax(predictions)
        predicted_pose = pose_classes[predicted_class]
        confidence = predictions[0][predicted_class]
        is_correct = predicted_pose == target_pose
        return is_correct, confidence, predicted_pose
    return False, 0, "No Pose Detected"

@app.route('/video', methods=['POST'])
def video():
    if 'video' not in request.files or 'pose' not in request.form:
        return jsonify({"error": "Video and pose are required"}), 400

    file = request.files['video']
    target_pose = request.form['pose']

    if target_pose not in pose_classes:
        return jsonify({"error": f"Invalid pose: {target_pose}"}), 400

    filename = secure_filename(file.filename)
    input_path = os.path.join(UPLOAD_FOLDER, filename)
    output_path = os.path.join(OUTPUT_FOLDER, f"output_{filename}")
    file.save(input_path)

    cap = cv2.VideoCapture(input_path)
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    fps = int(cap.get(cv2.CAP_PROP_FPS))
    frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    out = cv2.VideoWriter(output_path, fourcc, fps, (frame_width, frame_height))

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        is_correct, confidence, predicted_pose = check_pose(frame, target_pose)
        frame_display = frame.copy()
        if predicted_pose != "No Pose Detected":
            cv2.putText(frame_display, f"Pose: {predicted_pose}", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2)
            if is_correct:
                cv2.putText(frame_display, f"Correct - Confidence: {confidence:.2f}", (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
                height, width, _ = frame_display.shape
                cv2.rectangle(frame_display, (50, 150), (width - 50, height - 50), (0, 255, 0), 2)
            else:
                cv2.putText(frame_display, f"Incorrect - Confidence: {confidence:.2f}", (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)

        out.write(frame_display)

    cap.release()
    out.release()

    return send_file(output_path, mimetype='video/mp4')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)