import cv2 as cv
from rich import print


# Load two images
img1 = cv.imread('../images/messi5.jpg')
img2 = cv.imread('../images/opencv-logo-white.png')

cv.imshow('messi5',img1)
cv.imshow('logo',img2)

# I want to put logo on top-left corner, So I create a ROI
rows,cols,channels = img2.shape
roi = img1[0:rows, 0:cols ]

# Now create a mask of logo and create its inverse mask also
img2gray     = cv.cvtColor(img2,cv.COLOR_BGR2GRAY)
ret, mask    = cv.threshold(img2gray, 10, 255, cv.THRESH_BINARY)
mask_inv     = cv.bitwise_not(mask)

# Now black-out the area of logo in ROI
# mask_inv 盖到比它大的图, 返回mask_inv 的大小, crop.
img1_bg = cv.bitwise_and(roi,roi,mask = mask_inv)

# Take only region of logo from logo image.
img2_fg = cv.bitwise_and(img2,img2,mask = mask)

# Put logo in ROI and modify the main image
dst = cv.add(img1_bg,img2_fg)
img1[0:rows, 0:cols ] = dst


cv.imshow('bg',img1_bg)
cv.imshow('fg',img2_fg)
cv.imshow('result',img1)
cv.waitKey(0)
cv.destroyAllWindows()