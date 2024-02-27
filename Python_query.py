import pymysql
import pandas as pd

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='Anand@123',
    database='salesdatawalmart'
)

cursor = conn.cursor()

query = "SHOW TABLES"

df = pd.read_sql(query, conn)
print(df)

query1="select * from sales"
df1 = pd.read_sql(query1, conn)
pd.set_option("display.max_columns", None)
# pd.set_option("display.max_rows", None)
print(df1)



conn.close()
