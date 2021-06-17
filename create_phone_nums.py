import random

def create_phone():
    start_list = ['130','131','132','133','134','135','136','137','138','139']
    end_list = random.sample('0123456789',8)
    phone_num = random.choice(start_list) + "".join(end_list)
    return phone_num
print(create_phone())