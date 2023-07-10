import cv2
import numpy as np

# 打开摄像头
cap = cv2.VideoCapture(0)

# 创建窗口
cv2.namedWindow('image')

# # 创建滑动条，用于调整亮度
# def set_brightness(val):
#     cap.set(cv2.CAP_PROP_BRIGHTNESS, val)
#     print(cap.get(cv2.CAP_PROP_BRIGHTNESS))

# cv2.createTrackbar('Brightness', 'image', -64, 64, set_brightness)

# cap.set(cv2.CAP_PROP_BRIGHTNESS, -10)
cv2.createTrackbar('Brightness', 'image', -10, 64, lambda v: cap.set(cv2.CAP_PROP_BRIGHTNESS, int(v) ) )
cv2.setTrackbarMin('Brightness', 'image', -64)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('CONTRAST', 'image', 0, 95, lambda v: cap.set(cv2.CAP_PROP_CONTRAST, int(v) ) )
cv2.setTrackbarMin('CONTRAST', 'image', 0)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('SATURATION', 'image', 66, 255, lambda v: cap.set(cv2.CAP_PROP_SATURATION, int(v) ) )
cv2.setTrackbarMin('SATURATION', 'image', 0)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('EXPOSURE', 'image', -6, 0, lambda v: cap.set(cv2.CAP_PROP_EXPOSURE, int(v) ) )
cv2.setTrackbarMin('EXPOSURE', 'image', -13)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('WB_TEMPERATURE', 'image', 5300, 6500, lambda v: cap.set(cv2.CAP_PROP_WB_TEMPERATURE, int(v) ) )
cv2.setTrackbarMin('WB_TEMPERATURE', 'image', 2800)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('FOCUS', 'image', 500, 1023, lambda v: cap.set(cv2.CAP_PROP_FOCUS, int(v) ) )
cv2.setTrackbarMin('FOCUS', 'image', 0)


# cv2.error: OpenCV(4.5.5) D:\code\opencv\opencv-4.5.5\modules\highgui\src\window.cpp:1221: error: (-213:The function/feature is not implemented) The library is compiled without QT support in function 'cv::createButton'
# cv2.createButton(buttonName='AUTOFOCUS', lambda v: cap.set(cv2.CAP_PROP_AUTOFOCUS, bool(v)), None, cv2.QT_PUSH_BUTTON,1)
# def back(*args):
#     pass

# cv2.createButton("AUTOFOCUS",back,None,cv2.QT_PUSH_BUTTON,1)


while(True):
    # 从摄像头捕获一帧
    ret, frame = cap.read()
    if ret:
        # 显示图像
        cv2.imshow('image', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

# 关闭摄像头
cap.release()
cv2.destroyAllWindows()
