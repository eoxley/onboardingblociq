#!/usr/bin/env python3
"""
Execute SQL migrations using Supabase Python client
Uses psycopg2 to connect directly to the database
"""
import os
from dotenv import load_dotenv
import psycopg2

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
PROJECT_ID = SUPABASE_URL.replace('https://', '').replace('.supabase.co', '')

# Database connection string - using direct database connection
# Password needs to be provided
DB_PASSWORD = os.getenv('SUPABASE_DB_PASSWORD')

if not DB_PASSWORD:
    print("❌ SUPABASE_DB_PASSWORD not set in .env")
    print("\nTo find your database password:")
    print("1. Go to: https://supabase.com/dashboard/project/aewixchhykxyhqjvqoek/settings/database")
    print("2. Look for 'Database password' or 'Connection pooling'")
    print("3. Add to .env: SUPABASE_DB_PASSWORD=your_password")
    exit(1)

def execute_migration(file_path):
    """Execute a migration file"""
    print(f"\n📄 Executing {file_path}...")

    with open(file_path, 'r') as f:
        sql = f.read()

    # Connect to database
    conn_string = f"postgresql://postgres.{PROJECT_ID}:{DB_PASSWORD}@aws-0-eu-west-2.pooler.supabase.com:6543/postgres"

    print(f"🔌 Connecting to database...")

    try:
        conn = psycopg2.connect(conn_string)
        conn.autocommit = True
        cursor = conn.cursor()

        print(f"✅ Connected!")
        print(f"🚀 Executing SQL...")

        cursor.execute(sql)

        print(f"✅ {file_path} executed successfully!")

        cursor.close()
        conn.close()

        return True

    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == '__main__':
    print("=" * 60)
    print("BlocIQ Migration Executor")
    print("=" * 60)

    migrations = [
        'output/migration_final3.sql'
    ]

    for migration in migrations:
        if not execute_migration(migration):
            print(f"\n⚠️  Migration {migration} failed")
            break
    else:
        print("\n✅ All migrations completed successfully!")
