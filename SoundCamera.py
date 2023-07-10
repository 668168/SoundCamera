import numpy as np
import cv2
print( cv2.__version__ )

cap = cv2.VideoCapture(0)

# 创建窗口
cv2.namedWindow('Sound Camera Rec...')

# # 创建滑动条，用于调整亮度
# def set_brightness(val):
#     cap.set(cv2.CAP_PROP_BRIGHTNESS, val)
#     print(cap.get(cv2.CAP_PROP_BRIGHTNESS))

# cv2.createTrackbar('Brightness', 'Sound Camera Rec...', -64, 64, set_brightness)

# cap.set(cv2.CAP_PROP_BRIGHTNESS, -10)
cv2.createTrackbar('Brightness', 'Sound Camera Rec...', -10, 64, lambda v: cap.set(cv2.CAP_PROP_BRIGHTNESS, int(v) ) )
cv2.setTrackbarMin('Brightness', 'Sound Camera Rec...', -64)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('CONTRAST', 'Sound Camera Rec...', 0, 95, lambda v: cap.set(cv2.CAP_PROP_CONTRAST, int(v) ) )
cv2.setTrackbarMin('CONTRAST', 'Sound Camera Rec...', 0)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('SATURATION', 'Sound Camera Rec...', 66, 255, lambda v: cap.set(cv2.CAP_PROP_SATURATION, int(v) ) )
cv2.setTrackbarMin('SATURATION', 'Sound Camera Rec...', 0)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('EXPOSURE', 'Sound Camera Rec...', -6, 0, lambda v: cap.set(cv2.CAP_PROP_EXPOSURE, int(v) ) )
cv2.setTrackbarMin('EXPOSURE', 'Sound Camera Rec...', -13)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('WB_TEMPERATURE', 'Sound Camera Rec...', 5300, 6500, lambda v: cap.set(cv2.CAP_PROP_WB_TEMPERATURE, int(v) ) )
cv2.setTrackbarMin('WB_TEMPERATURE', 'Sound Camera Rec...', 2800)

# print(cap.get(cv2.CAP_PROP_BRIGHTNESS))
cv2.createTrackbar('FOCUS', 'Sound Camera Rec...', 500, 1023, lambda v: cap.set(cv2.CAP_PROP_FOCUS, int(v) ) )
cv2.setTrackbarMin('FOCUS', 'Sound Camera Rec...', 0)


# cv2.error: OpenCV(4.5.5) D:\code\opencv\opencv-4.5.5\modules\highgui\src\window.cpp:1221: error: (-213:The function/feature is not implemented) The library is compiled without QT support in function 'cv::createButton'
# cv2.createButton(buttonName='AUTOFOCUS', lambda v: cap.set(cv2.CAP_PROP_AUTOFOCUS, bool(v)), None, cv2.QT_PUSH_BUTTON,1)
# def back(*args):
#     pass

# cv2.createButton("AUTOFOCUS",back,None,cv2.QT_PUSH_BUTTON,1)


# Define the codec and create VideoWriter object
fourcc = cv2.VideoWriter_fourcc('H', '2', '6', '5')
out = cv2.VideoWriter('../temp/mix-sound-camera.mp4', fourcc, 20.0, (640, 480))


if not cap.isOpened():
    print("Cannot open camera")
    exit()
while True:
    
    e1 = cv2.getTickCount()

    # Capture frame-by-frame
    ret, frame = cap.read()
    # if frame is read correctly ret is True
    if not ret:
      print("Can't receive frame (stream end?). Exiting ...")
      break
    # Our operations on the frame come here
    # gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    sound_origin = cv2.imread(filename='Pic2_640_480.png', flags=-1)
    sound_jet = cv2.applyColorMap(src=sound_origin, colormap=cv2.COLORMAP_JET)

    # just for test
    # # mix_image = cv2.add(src1=frame, src2=sound_jet)

    # I want to put logo on top-left corner, So I create a ROI
    rows,cols = sound_origin.shape
    roi = frame[0:rows, 0:cols]

    # Now create a mask of logo and create its inverse mask also
    img2gray = sound_origin
    ret, mask = cv2.threshold(img2gray, 180, 255, cv2.THRESH_BINARY)
    mask_inv = cv2.bitwise_not(mask)

    # Now black-out the area of logo in ROI
    img1_bg = cv2.bitwise_and(roi,roi,mask = mask_inv)

    # Take only region of logo from logo image.
    img2_fg = cv2.bitwise_and(sound_jet,sound_jet,mask = mask)

    # Put logo in ROI and modify the main image
    dst = cv2.add(img1_bg,img2_fg)
    frame[0:rows, 0:cols ] = dst

    font = cv2.FONT_HERSHEY_SIMPLEX
    cv2.putText(frame,'GGEC',(30,40), font, 1, (0,255,0), 2, cv2.LINE_AA)


    # Measuring Performance with OpenCV
    e2 = cv2.getTickCount()
    time = (e2 - e1)/ cv2.getTickFrequency()
    print(f"Current Frame Process Duaration: {time}")
    # write the flipped frame
    out.write(frame)
    # Display the resulting frame
    cv2.imshow('Sound Camera Rec...', frame)
    if cv2.waitKey(1) == ord('q'):
      break

# When everything done, release the capture
out.release()
cap.release()
cv2.destroyAllWindows()
