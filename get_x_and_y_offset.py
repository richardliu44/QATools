import pyautogui
import os
import time

try:
    while True:
        print("Press Ctrl + C to terminate.")
        x, y = pyautogui.position()
        posStr = "Current mouse position:" + str(x).rjust(4) + ',' + str(y).rjust(4)
        print(posStr)
        time.sleep(1)
        os.system('cls')
        
        
except KeyboardInterrupt:
    print("exit!")
