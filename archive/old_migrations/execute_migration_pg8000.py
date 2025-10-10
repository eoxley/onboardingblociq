#!/usr/bin/env python3
import pg8000
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Fetch variables
USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = int(os.getenv("port"))
DBNAME = os.getenv("dbname")

print("=" * 60)
print("BlocIQ Migration Executor - pg8000")
print("=" * 60)

# Connect to the database
try:
    print(f"\n🔌 Connecting to {HOST}:{PORT}...")
    print(f"   User: {USER}")
    print(f"   Database: {DBNAME}")

    connection = pg8000.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        database=DBNAME
    )
    print("✅ Connection successful!")

    # Create a cursor to execute SQL queries
    cursor = connection.cursor()

    # Test query
    cursor.execute("SELECT NOW();")
    result = cursor.fetchone()
    print(f"✓ Current Time: {result[0]}")

    # Read the migration SQL file
    print(f"\n📄 Reading schema-compliant migration file...")
    with open('output/migration_schema_compliant.sql', 'r') as f:
        sql = f.read()

    print(f"✓ Read {len(sql)} characters (schema-compliant version)")

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

    # Verify buildings
    cursor.execute("SELECT COUNT(*) FROM buildings;")
    building_count = cursor.fetchone()[0]
    print(f"✓ Buildings: {building_count}")

    # Verify units
    cursor.execute("SELECT COUNT(*) FROM units;")
    unit_count = cursor.fetchone()[0]
    print(f"✓ Units: {unit_count}")

    # Close the cursor and connection
    cursor.close()
    connection.close()
    print("\n✅ Connection closed.")
    print("\n" + "=" * 60)
    print("🎉 Migration completed successfully!")
    print("=" * 60)

except Exception as e:
    print(f"\n❌ Failed: {e}")
    import traceback
    traceback.print_exc()
    if 'connection' in locals():
        connection.rollback()
        connection.close()
