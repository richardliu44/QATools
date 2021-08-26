import xlsxwriter
count = 101
sheet1_column = ['name','id','phone']
sheet2_column = ['name','sex','age']
sheet3_column = ['name','grade','score']

writer = xlsxwriter.Workbook("file_name.xlsx")

def generate_sheet1():
  worksheet1 = writer.add_worksheet(name="sheet1")
  for i, j in enumerate(sheet1_column):
      worksheet1.write(0, i, j)
  for k in range (1, count):
      worksheet1.write(k, 0, "content_of_1st_column")
      worksheet1.write(k, 1, "content_of_1st_column")
      worksheet1.write(k, 2, "content_of_1st_column")

def generate_sheet2():
  worksheet1 = writer.add_worksheet(name="sheet2")
  for i, j in enumerate(sheet2_column):
      worksheet2.write(0, i, j)
  for k in range (1, count):
      worksheet2.write(k, 0, "content_of_1st_column")
      worksheet2.write(k, 1, "content_of_1st_column")
      worksheet2.write(k, 2, "content_of_1st_column")
      
def generate_sheet3():
  worksheet3 = writer.add_worksheet(name="sheet3")
  for i, j in enumerate(sheet3_column):
      worksheet3.write(0, i, j)
  for k in range (1, count):
      worksheet3.write(k, 0, "content_of_1st_column")
      worksheet3.write(k, 1, "content_of_1st_column")
      worksheet3.write(k, 2, "content_of_1st_column")

generate_sheet1()
generate_sheet2()
generate_sheet3()
writer.close()
 
