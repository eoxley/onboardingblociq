#!/usr/bin/env python3
import psycopg2
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Fetch variables
USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = os.getenv("port")
DBNAME = os.getenv("dbname")

print("=" * 60)
print("BlocIQ Migration Executor - psycopg2")
print("=" * 60)

# Connect to the database
try:
    print(f"\n🔌 Connecting to {HOST}...")
    connection = psycopg2.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        dbname=DBNAME
    )
    print("✅ Connection successful!")

    # Create a cursor to execute SQL queries
    cursor = connection.cursor()

    # Test query
    cursor.execute("SELECT NOW();")
    result = cursor.fetchone()
    print(f"✓ Current Time: {result[0]}")

    # Read the migration SQL file
    print(f"\n📄 Reading migration file...")
    with open('output/migration_final3.sql', 'r') as f:
        sql = f.read()

    print(f"✓ Read {len(sql)} characters ({len(sql.split(';'))} statements)")

    # Execute the migration
    print(f"\n🚀 Executing migration...")
    print("   (This may take a few minutes...)")

    cursor.execute(sql)
    connection.commit()

    print(f"\n✅ Migration executed successfully!")

    # Verify assets table was created
    cursor.execute("SELECT COUNT(*) FROM assets;")
    asset_count = cursor.fetchone()[0]
    print(f"✓ Assets table created with {asset_count} records")

    # Close the cursor and connection
    cursor.close()
    connection.close()
    print("\n✅ Connection closed.")

except Exception as e:
    print(f"\n❌ Failed: {e}")
    if 'connection' in locals():
        connection.rollback()
        connection.close()
