import numpy as np
import cv2 as cv
print( cv.__version__ )

cap = cv.VideoCapture(0)

# Define the codec and create VideoWriter object
fourcc = cv.VideoWriter_fourcc('H', '2', '6', '5')
out = cv.VideoWriter('../temp/mix-sound-camera.mp4', fourcc, 20.0, (640, 480))


if not cap.isOpened():
    print("Cannot open camera")
    exit()
while True:
    
    e1 = cv.getTickCount()

    # Capture frame-by-frame
    ret, frame = cap.read()
    # if frame is read correctly ret is True
    if not ret:
      print("Can't receive frame (stream end?). Exiting ...")
      break
    # Our operations on the frame come here
    # gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)

    sound_origin = cv.imread(filename='Pic2_640_480.png', flags=-1)
    sound_jet = cv.applyColorMap(src=sound_origin, colormap=cv.COLORMAP_JET)

    # just for test
    # # mix_image = cv.add(src1=frame, src2=sound_jet)

    # I want to put logo on top-left corner, So I create a ROI
    rows,cols = sound_origin.shape
    roi = frame[0:rows, 0:cols]

    # Now create a mask of logo and create its inverse mask also
    img2gray = sound_origin
    ret, mask = cv.threshold(img2gray, 180, 255, cv.THRESH_BINARY)
    mask_inv = cv.bitwise_not(mask)

    # Now black-out the area of logo in ROI
    img1_bg = cv.bitwise_and(roi,roi,mask = mask_inv)

    # Take only region of logo from logo image.
    img2_fg = cv.bitwise_and(sound_jet,sound_jet,mask = mask)

    # Put logo in ROI and modify the main image
    dst = cv.add(img1_bg,img2_fg)
    frame[0:rows, 0:cols ] = dst

    font = cv.FONT_HERSHEY_SIMPLEX
    cv.putText(frame,'GGEC',(30,40), font, 1, (0,255,0), 2, cv.LINE_AA)


    # Measuring Performance with OpenCV
    e2 = cv.getTickCount()
    time = (e2 - e1)/ cv.getTickFrequency()
    print(time)
    # write the flipped frame
    out.write(frame)
    # Display the resulting frame
    cv.imshow('frame', frame)
    if cv.waitKey(1) == ord('q'):
      break

# When everything done, release the capture
out.release()
cap.release()
cv.destroyAllWindows()
