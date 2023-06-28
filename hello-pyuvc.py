import uvc
import cv2

# 获取UVC设备列表
dev_list = uvc.device_list()
print(dev_list)

# 创建一个摄像头设备对象，这里假设我们选择第一个设备
cap = uvc.Capture(dev_list[0]["uid"])

# 设定摄像头的属性

for frame in cap.stream():
cap.frame_mode = (640, 480, 30)
    # 在这          里处理你的帧，例如使用cv2显示
    cv2.imshow('frame', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()
