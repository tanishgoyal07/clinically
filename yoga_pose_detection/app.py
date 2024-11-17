from flask import Flask, request, jsonify
from services.pose_prediction import predict_pose_service
from pose_list import pose_classes

app = Flask(__name__)

@app.route('/predict_pose', methods=['POST'])
def predict_pose():
    data = request.get_json()
    frame_data = data.get('frame')
    target_pose = data.get('target_pose')

    if not frame_data or not target_pose:
        return jsonify({"error": "Invalid input data"}), 400
    
    response = predict_pose_service(frame_data, target_pose)
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
