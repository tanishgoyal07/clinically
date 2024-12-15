# from flask import Flask, request, jsonify
# from services.pose_prediction import predict_pose_service
# from pose_list import pose_classes

# app = Flask(__name__)

# @app.route('/predict_pose', methods=['POST'])
# def predict_pose():
#     data = request.get_json()
#     frame_data = data.get('frame')
#     target_pose = data.get('target_pose')

#     if not frame_data or not target_pose:
#         return jsonify({"error": "Invalid input data"}), 400
    
#     response = predict_pose_service(frame_data, target_pose)
#     return jsonify(response)

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)

from flask import Flask, request, jsonify, render_template
from flask_socketio import SocketIO, emit
from werkzeug.utils import secure_filename
import os
import time
import base64
from services.pose_prediction import predict_pose_service
from pose_list import pose_classes

UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'secret!'
socketio = SocketIO(app)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def extract_pose_name(filename):
    name_part = filename.rsplit('.', 1)[0] 
    return name_part.replace('_', ' ').strip()

@app.route('/')
def index():
    return render_template('index.html')

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

    # if target_pose not in pose_classes:
    #     return jsonify({"error": "Invalid pose name extracted from file name"}), 400

    filename = secure_filename(file.filename)
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)

    socketio.emit('progress', {'progress': 0})
    for i in range(1, 6):
        time.sleep(1)
        socketio.emit('progress', {'progress': i * 20})

    with open(filepath, 'rb') as image_file:
        frame_data = base64.b64encode(image_file.read()).decode('utf-8')

    response = predict_pose_service(frame_data, target_pose)

    return jsonify(response)

if __name__ == '__main__':
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    socketio.run(app, host='0.0.0.0', port=5000)
