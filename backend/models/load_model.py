import tensorflow as tf

# def load_pose_model(model_path="models/EfficientNet_yoga_model.h5"):
def load_pose_model(model_path="models/EfficientNet_54_Augmented.h5"):
    model = tf.keras.models.load_model(model_path)
    return model

model = load_pose_model()
