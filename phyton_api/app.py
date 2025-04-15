import cv2
import numpy as np
from flask import Flask, request, send_file
import io

# Create web application via Flask.
app = Flask(__name__)

# Create function for apply filter.
def cartoonize_image(img):

    # Covert image to gray.
    gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

    # Apply medianBlur for image noising.
    gray = cv2.medianBlur(gray, 5)

    # Highlight edges.
    edges = cv2.adaptiveThreshold(gray, 255,
                                  cv2.ADAPTIVE_THRESH_MEAN_C,
                                  cv2.THRESH_BINARY, 9, 9)

    # Make soft colors.
    color = cv2.bilateralFilter(img, d=9,sigmaColor=250,sigmaSpace=250)

    # Combine mask image with original image.
    cartoon = cv2.bitwise_and(color,color,mask=edges)

    return cartoon

    # Trigger cartoonize function with POST method.
@app.route("/cartoon",methods=["POST"])
def cartoonize():

    # If image named file not send, throw error.
    if 'image' not in request.files:
        return "No image provided", 400

    # Convert image to img matrix for make readable from OpenCV
    # using with bytes array.
    file = request.files['image']
    in_memory_file = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(in_memory_file,cv2.IMREAD_COLOR)

    # Call catoonize_image function and apply the filter.
    cartoon_img = cartoonize_image(img)

    # Encode filter applied image as png.
    _, buffer = cv2.imencode('.png',cartoon_img)

    # Hold filter applied image on temporary memory.
    io_buf = io.BytesIO(buffer)

    # Send filter applied image to client.
    return send_file(io_buf,mimetype='image/png')

    # Server running on 0.0.0.0:5050 address
    # 0.0.0.0 for define to everyone.
    # You can change port as you wish (Don't forget to change also at phyton_filter.service.dart file)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)