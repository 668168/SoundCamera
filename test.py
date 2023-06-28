import cv2 as cv
import numpy as np
img = cv.imread(cv.samples.findFile('sudoku.png'))
gray = cv.cvtColor(img,cv.COLOR_BGR2GRAY)
edges = cv.Canny(gray,50,150,apertureSize = 3)
lines = cv.HoughLinesP(edges,1,np.pi/180,100,minLineLength=100,maxLineGap=10)
for line in lines:
    x1,y1,x2,y2 = line[0]
    
cv.imshow('houghlines5.jpg',img)
if cv.waitKey(0) == ord('q'):
    cv.destroyAllWindows()
# cv.imwrite('houghlines5.jpg',img)


