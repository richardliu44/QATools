from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import logging

base_url = "https://www.xxxxxx.com/login"

chrome_options = Options()
chrome_options.add_argument('--no-sandbox')
#chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--use-fake-device-for-media-string')
chrome_options.add_argument('--use-fake-ui-for-media-string')
chrome_options.add_argument('--ignore-certificate-errors')
chrome_options.add_experimental_option("prefs", {"profile.default_content_setting_values.media_stream_mic": 1})
chrome_options.add_experimental_option("detach", True)

logging.basicConfig(level=logging.DEBUG)

for i in range (1,11):
    global driver
    driver = webdriver.Chrome(options=chrome_options)
    driver.get(base_url)
    driver.maximize_window()
    driver.implicitly_wait(10)
    username = driver.find_element_by_id('username_id')
    username.send_keys('user%s@test.com' % i)
    password = driver.find_element_by_id('password_id')
    password.send_keys('password')
    login_button = driver.find_element_by_id('login_button_id')
    login_button.click()
    driver.minimize_window()
