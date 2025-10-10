#!/usr/bin/env python3
"""
Safe migration executor - skips statements that fail and continues
"""
import pg8000
from dotenv import load_dotenv
import os
import re

load_dotenv()

USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = int(os.getenv("port"))
DBNAME = os.getenv("dbname")

print("=" * 60)
print("BlocIQ SAFE Migration Executor")
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
    connection.autocommit = False  # Use transactions
    print("✅ Connected!")

    cursor = connection.cursor()

    # Read the migration SQL file
    print(f"\n📄 Reading migration file...")
    with open('output/migration_final3.sql', 'r') as f:
        sql = f.read()

    # Split into individual statements
    statements = [s.strip() + ';' for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

    print(f"✓ Found {len(statements)} SQL statements")
    print(f"\n🚀 Executing migration (skipping errors)...")

    success_count = 0
    error_count = 0
    errors = []

    for i, statement in enumerate(statements):
        if i % 100 == 0 and i > 0:
            print(f"  Progress: {i}/{len(statements)} statements ({success_count} success, {error_count} errors)")

        try:
            cursor.execute(statement)
            success_count += 1
        except Exception as e:
            error_count += 1
            error_msg = str(e)
            # Only show first 100 chars of statement
            stmt_preview = statement[:100].replace('\n', ' ')
            errors.append({
                'statement': stmt_preview,
                'error': error_msg
            })

            # Skip duplicate key errors and continue
            if '23505' in error_msg or 'duplicate' in error_msg.lower():
                continue  # Duplicate key, ignore

            # Log other errors but continue
            if len(errors) <= 10:  # Only show first 10 unique errors
                print(f"  ⚠️  Error {error_count}: {error_msg[:80]}...")

    # Commit all successful changes
    connection.commit()

    print(f"\n" + "=" * 60)
    print(f"✅ Migration completed!")
    print(f"=" * 60)
    print(f"  Success: {success_count}")
    print(f"  Errors: {error_count}")

    if error_count > 0:
        print(f"\n⚠️  {error_count} statements failed (see details above)")

    #  Verify key tables
    print(f"\n📊 Verifying data...")

    try:
        cursor.execute("SELECT COUNT(*) FROM buildings;")
        print(f"  ✓ Buildings: {cursor.fetchone()[0]}")
    except:
        pass

    try:
        cursor.execute("SELECT COUNT(*) FROM units;")
        print(f"  ✓ Units: {cursor.fetchone()[0]}")
    except:
        pass

    try:
        cursor.execute("SELECT COUNT(*) FROM assets;")
        print(f"  ✓ Assets: {cursor.fetchone()[0]}")
    except:
        pass

    cursor.close()
    connection.close()
    print("\n✅ Connection closed.")

except Exception as e:
    print(f"\n❌ Fatal error: {e}")
    import traceback
    traceback.print_exc()
    if 'connection' in locals():
        connection.rollback()
        connection.close()
