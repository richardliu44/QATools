import pandas as pd
import random

title = ['name','phone1','phone2','phone3','notes']
count = 101
names = ['a','b','c','d','e']
notes = ['1','2','3','4','5']
phone_start_4_digit = ['130','131','132','133','134','135','136']
writer - pd.ExcelWriter('file_name.xlsx')

def create_phone_number():
    str_start = random.choice(phone_start_4_digit)
    str_end = ''.join(random.sample('0123456789', 8))
    phone_number = str_start + str_end
    return phone_number
def generate_user_list():
    df = pd.DataFrame({title[0]:[],title[1]:[],title[2]:[],title[3]:[],title[4]:[]})
    for i in range (1, count):
        df = df.append({title[0]:random.choice(names),title[1]:create_phone_number(),title[2]:create_phone_number(),title[3]:create_phone_number(),title[4]:random.choice(notes)},ignore_index=True)
        df.to_excel(writer, sheet_name='user_info',index=False)
    writer.save()
    
generate_user_list()
