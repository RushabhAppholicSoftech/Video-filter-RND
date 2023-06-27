import cv2

def apply_filters(frame):
    # Convert the frame to grayscale
    gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Apply edge detection using the Canny algorithm
    edges = cv2.Canny(gray_frame, 100, 200)

    return edges

def main():
    # Open a video file or capture video from a camera
    video_capture = cv2.VideoCapture(0)  # Change the parameter to your video file path if applicable

    while True:
        # Read a frame from the video
        ret, frame = video_capture.read()

        if not ret:
            # Break the loop if there are no more frames
            break

        # Apply the filters to the frame
        filtered_frame = apply_filters(frame)

        # Display the filtered frame
        cv2.imshow('Filtered Video', filtered_frame)

        # Wait for the 'q' key to be pressed to exit
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Release the video capture and close the OpenCV windows
    video_capture.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
