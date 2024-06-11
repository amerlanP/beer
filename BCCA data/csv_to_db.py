import pandas as pd
import sqlite3

def imageConcat(df, side):
    if side == "F":
        return "http://bcca-usbc-supplement.com/images/SupplementImages/" + str(df['CanIdentifier']) + ".jpg"
    elif side == "L":
        return "http://bcca-usbc-supplement.com/images/SupplementImages/" + str(df['CanIdentifier']) + "_LeftSide.jpg"
    elif side == "R":
        return "http://bcca-usbc-supplement.com/images/SupplementImages/" + str(df['CanIdentifier']) + "_RightSide.jpg"
    elif side == "T":
        return "http://bcca-usbc-supplement.com/images/SupplementImages/" + str(df['CanIdentifier']) + "_Top.jpg"
    else:
        return "http://bcca-usbc-supplement.com/images/SupplementImages/" + str(df['CanIdentifier']) + "_Back.jpg"

def priceFix(price):
    if price == '1000+':
        return 9999
    elif pd.isna(price):
        return 0
    else:
        return int(price)

# Define the path to the CSV file and the SQLite database file
csv_file_path = 'table_data_volume1.csv'  # Replace with your CSV file path
sqlite_db_path = 'can_data.db'  # Replace with your desired SQLite database path

# Read the CSV file into a DataFrame
df = pd.read_csv(csv_file_path)

# Add columns for image links of each side of the cans
df['ImageFront'] = df.apply(imageConcat, args=("F"), axis=1)
df['ImageLeft'] = df.apply(imageConcat, args=("L"), axis=1)
df['ImageRight'] = df.apply(imageConcat, args=("R"), axis=1)
df['ImageTop'] = df.apply(imageConcat, args=("T"), axis=1)
df['ImageBack'] = df.apply(imageConcat, args=("B"), axis=1)

df['Price'] = df['Price'].apply(priceFix)

# Connect to the SQLite database (it will create the file if it does not exist)
conn = sqlite3.connect(sqlite_db_path)

# Define the table name
table_name = 'my_table'

# Write the DataFrame to the SQLite database
df.to_sql(table_name, conn, if_exists='replace', index=False)

# Close the connection
conn.close()