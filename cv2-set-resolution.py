import cv2

if __name__ == "__main__":
    webcam = cv2.VideoCapture(0)
    
    if not webcam.isOpened():
        print("can't open the camera!!!")
    # cv2.namedWindow("video", 0)
    # cv2.resizeWindow("video", 960, 720)
    # method 1:
    webcam.set(3, 1920)  # width=1920
    webcam.set(4, 1080)  # height=1080
    webcam.set(5, 30)
    # method 2:
    # webcam.set(cv2.CAP_PROP_FRAME_WIDTH, 960)
    # webcam.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

    webcam.set(cv2.CAP_PROP_BRIGHTNESS, 0.5)
    brightness = webcam.get(cv2.CAP_PROP_BRIGHTNESS)
    print(brightness)

    while(True):
        ret, frame = webcam.read() #摄像头读取,ret为是否成功打开摄像头,true,false。 frame为视频的每一帧图像
        frame = cv2.flip(frame, 1) #摄像头是和人对立的，将图像左右调换回来正常显示。
        cv2.imshow("video", frame)
        if cv2.waitKey(10) == ord("q"):
            break

    # Release handle to the webcam
    webcam.release()
    cv2.destroyAllWindows()
