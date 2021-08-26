import pandas as pd
from pandas import DataFrame
from sqlalchemy import create_engine

mysql_username = 'root'
mysql_password = 'password'
mysql_ip = '192.168.1.100'
mysql_port = '3306'
mysql_db = 'db_name'
tenant_id = '1234567'
mysql_db_table = 'table_name'
task_id = '12345'

def mysql_query_2_excel():
    sql = '''SELECT * FROM `{}` WHERE tenant_id="{}" AND task_id={} LIMIT 1000;'''.format(mysql_db_table,tenant_id,task_id)
    engine = create_engine('mysql+pymysql://{}:{}@{}:{}/{}'.format(mysql_username, mysql_password, mysql_ip, mysql_port, mysql_db))
    df = pd.read_sql_query(sql, engine)
    query_results = DataFrame.from_records(df)
    query_results.to_excel('mysql-2-excel.xlsx', sheet_name='sheet1', index=False)
    
mysql_query_2_excel()
