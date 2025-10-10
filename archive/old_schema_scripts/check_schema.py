#!/usr/bin/env python3
import pg8000
from dotenv import load_dotenv
import os

load_dotenv()

USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = int(os.getenv("port"))
DBNAME = os.getenv("dbname")

try:
    connection = pg8000.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        database=DBNAME
    )
    cursor = connection.cursor()

    # Check if major_works_projects table exists
    cursor.execute("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_name = 'major_works_projects'
        ORDER BY ordinal_position;
    """)

    columns = cursor.fetchall()

    if columns:
        print("✓ major_works_projects table EXISTS with columns:")
        for col in columns:
            print(f"  - {col[0]}: {col[1]}")
    else:
        print("✗ major_works_projects table does NOT exist")

    cursor.close()
    connection.close()

except Exception as e:
    print(f"Error: {e}")
