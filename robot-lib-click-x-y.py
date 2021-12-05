import pyautogui


def click_x_y(x, y):
    pyautogui.click(int(x), int(y), clicks=1, button='left')
