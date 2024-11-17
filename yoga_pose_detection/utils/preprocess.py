import cv2
import numpy as np
import tensorflow as tf
from tensorflow.keras.preprocessing.image import img_to_array

def preprocess_image(image, img_height=160, img_width=160):
    image = cv2.resize(image, (img_width, img_height))
    image = img_to_array(image)
    image = np.expand_dims(image, axis=0)
    return tf.keras.applications.efficientnet.preprocess_input(image)
