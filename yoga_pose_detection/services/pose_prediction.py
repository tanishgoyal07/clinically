import base64
import cv2
import numpy as np
from models.load_model import model
from utils.preprocess import preprocess_image
from pose_list import pose_classes
import os

def predict_pose_service(frame_data, target_pose):
    
    frame_data = base64.b64decode(frame_data)
    nparr = np.frombuffer(frame_data, np.uint8)
    frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    processed_image = preprocess_image(frame)

    predictions = model.predict(processed_image)
    predicted_class = np.argmax(predictions)
    predicted_pose = pose_classes[predicted_class]
    confidence = float(predictions[0][predicted_class])

    is_correct = predicted_pose == target_pose
    alert = not is_correct  

    return {
        "is_correct": is_correct,
        "confidence": confidence,
        "predicted_pose": predicted_pose,
        "alert": alert
    }
