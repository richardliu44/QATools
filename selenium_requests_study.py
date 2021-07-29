from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import requests

base_url = "https://www.xxxx1xxx.com"
api_base_url = "https://api.xxxxx33.com"
init_agentId = 10000

chrome_options = Options()
chrome_options.add_argument('--no-sandbox')
#chrome_options.add_argument('--headless')
chrome_options.add_argument('--disable-gpu')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('window-size=1920,1080')
chrome_options.add_argument('--use-fake-device-for-media-stream')
chrome_options.add_argument('--use-fake-ui-for-media-stream')
chrome_options.add_experimental_option("detach", True)
chrome_options.add_experimental_option("prefs", {"profile.default_content_setting_values.media_stream_mic": 1})

for i in range(1, 11):
    global driver
    driver = webdriver.Chrome(options=chrome_options)
    driver.get(base_url)
    driver.implicitly_wait(60)
    username = driver.find_element_by_id('username_id')
    username.send_keys('user%s@xxxxxx.com' % i)
    driver.implicitly_wait(3)
    password = driver.find_element_by_id('password_id')
    password.send_keys('password')
    login_button = driver.find_element_by_id('login_button_id')
    login_button.click()
    time.sleep(2)
    #driver.save_screenshot('login-%s.png' % i)

    cookies = driver.get_cookies()[0]
    auth_value = cookies['value']
    #print(auth_value)

    agentId = init_agentId + i
    data = {'authorization': '%s' % auth_value, 'tenantId': 'tenantid...', 'agentId': agentId,
            'presence': 'FREE'}
    print(data)

    r = requests.put(api_base_url + "/ssss/api/v1/xxxx/yyy", params=data)
    print("This is user0%s." % i)
    print(r.text)
    time.sleep(3)

