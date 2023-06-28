
import logging, cv2
from rich import print
from rich.logging import RichHandler

logging.basicConfig(
    level=logging.NOTSET,
    handlers=[RichHandler(level="DEBUG")],
    format="%(message)s",
    datefmt="[%X]",
)
# 打开摄像头，参数0代表计算机的默认摄像头，如果有多个摄像头，可以改变参数为1，2等
cap = cv2.VideoCapture(0) 

try:
    # 获取摄像头的属性信息
    width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    fps = cap.get(cv2.CAP_PROP_FPS)
except:
    print(f".....")

print("Width: ", width)
print("Height: ", height)
print("FPS: ", fps)

cap.release()  # 最后，关闭摄像头
cv2.destroyAllWindows()


