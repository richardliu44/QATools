import pandas as pd

df1_title = ['name','id','phone']
df2_title = ['name','sex','age']
df3_title = ['name','grade','score']
count = 101
writer = pd.ExcelWriter('file_name.xlsx')

def generate_df1():
    df1 = pd.DataFrame({df1_title[0]:[], df1_title[1]:[], df1_title[2]:[]})
    for i in range (1, count):
        df1 = df1.append({df1_title[0]:'content_of_1st_column', df1_title[1]:'content_of_2nd_column', df1_title[2]:'content_of_3rd_column'},ignore_index=True)
        df1.to_excel(writer, sheet_name="sheet1", index=False)
        
def generate_df2():
    df2 = pd.DataFrame({df2_title[0]:[], df2_title[1]:[], df2_title[2]:[]})
    for i in range (1, count):
        df2 = df2.append({df2_title[0]:'content_of_1st_column', df2_title[1]:'content_of_2nd_column', df2_title[2]:'content_of_3rd_column'},ignore_index=True)
        df2.to_excel(writer, sheet_name="sheet2", index=False)

def generate_df3():
    df3 = pd.DataFrame({df3_title[0]:[], df3_title[1]:[], df3_title[2]:[]})
    for i in range (1, count):
        df3 = df3.append({df3_title[0]:'content_of_1st_column', df3_title[1]:'content_of_2nd_column', df3_title[2]:'content_of_3rd_column'},ignore_index=True)
        df3.to_excel(writer, sheet_name="sheet3", index=False)
        
generate_df1()
generate_df2()
generate_df3()
writer.save()
