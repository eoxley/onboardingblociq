#!/usr/bin/env python3
"""
Execute the migration file directly - any errors will stop execution
"""
import pg8000
from dotenv import load_dotenv
import os

load_dotenv()

USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = int(os.getenv("port"))
DBNAME = os.getenv("dbname")

print("=" * 60)
print("BlocIQ Migration Executor - Final Attempt")
print("=" * 60)

try:
    print(f"\n🔌 Connecting to {HOST}:{PORT}...")
    connection = pg8000.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        database=DBNAME
    )
    # Use autocommit to avoid transaction blocks
    connection.autocommit = True
    print("✅ Connected!")

    cursor = connection.cursor()

    # Read the migration SQL file
    print(f"\n📄 Reading migration file...")
    with open('output/migration_final3.sql', 'r') as f:
        sql = f.read()

    print(f"✓ Read {len(sql)} characters")
    print(f"\n🚀 Executing migration...")
    print("   (This will stop at the first error)")

    # Execute as single statement
    cursor.execute(sql)

    print(f"\n✅ Migration executed successfully!")

    # Verify key tables
    print(f"\n📊 Verifying data...")

    cursor.execute("SELECT COUNT(*) FROM buildings;")
    print(f"  ✓ Buildings: {cursor.fetchone()[0]}")

    cursor.execute("SELECT COUNT(*) FROM units;")
    print(f"  ✓ Units: {cursor.fetchone()[0]}")

    cursor.execute("SELECT COUNT(*) FROM assets;")
    print(f"  ✓ Assets: {cursor.fetchone()[0]}")

    cursor.execute("SELECT COUNT(*) FROM leaseholders;")
    print(f"  ✓ Leaseholders: {cursor.fetchone()[0]}")

    cursor.close()
    connection.close()
    print("\n" + "=" * 60)
    print("🎉 Migration completed successfully!")
    print("=" * 60)

except Exception as e:
    print(f"\n❌ Error occurred:")
    print(f"   {str(e)}")
    print(f"\n💡 This error indicates a schema mismatch.")
    print(f"   The migration file expects different table structures than what exists.")
    print(f"\n📋 RECOMMENDATION:")
    print(f"   Execute the migration manually in Supabase SQL Editor:")
    print(f"   1. Go to: https://supabase.com/dashboard/project/aewixchhykxyhqjvqoek/sql/new")
    print(f"   2. Copy contents from: /Users/ellie/onboardingblociq/output/migration_final3.sql")
    print(f"   3. Execute and review each error manually")

    if 'connection' in locals():
        connection.close()
