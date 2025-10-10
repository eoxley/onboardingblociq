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

    # Check constraints on major_works_projects
    cursor.execute("""
        SELECT conname, pg_get_constraintdef(oid)
        FROM pg_constraint
        WHERE conrelid = 'major_works_projects'::regclass
        AND contype = 'c';
    """)

    constraints = cursor.fetchall()

    print("✓ CHECK constraints on major_works_projects:")
    for constraint in constraints:
        print(f"\n  {constraint[0]}:")
        print(f"    {constraint[1]}")

    cursor.close()
    connection.close()

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
