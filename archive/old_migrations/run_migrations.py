#!/usr/bin/env python3
"""
Run database migrations using Supabase SQL API
"""
import os
import sys
from dotenv import load_dotenv
import requests

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

def execute_sql_file(filename):
    """Execute a SQL file using Supabase REST API"""
    print(f"\n📄 Running {filename}...")

    with open(filename, 'r') as f:
        sql = f.read()

    # Use Supabase's REST API to execute SQL
    # Note: This requires the SQL to be executed via postgrest or using a stored procedure
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json'
    }

    # For direct SQL execution, we need to use Supabase's RPC endpoint
    # Split SQL into individual statements
    statements = [s.strip() for s in sql.split(';') if s.strip() and not s.strip().startswith('--')]

    print(f"   Found {len(statements)} SQL statements")

    success_count = 0
    error_count = 0

    for i, stmt in enumerate(statements, 1):
        if not stmt:
            continue

        # Skip comments
        if stmt.startswith('--'):
            continue

        try:
            # Use Supabase's query endpoint (requires creating a custom RPC function)
            # For now, just print the SQL that needs to be run
            print(f"   Statement {i}/{len(statements)}: {stmt[:60]}...")
            success_count += 1
        except Exception as e:
            print(f"   ⚠️  Error in statement {i}: {str(e)}")
            error_count += 1

    print(f"   ✅ {success_count} statements prepared")
    if error_count > 0:
        print(f"   ⚠️  {error_count} statements had errors")

    return success_count, error_count

if __name__ == '__main__':
    print("=" * 60)
    print("BlocIQ Database Migration Runner")
    print("=" * 60)
    print(f"Target: {SUPABASE_URL}")
    print()

    print("⚠️  IMPORTANT:")
    print("The Supabase Python client cannot execute raw SQL directly.")
    print("You need to run these migrations using ONE of these methods:")
    print()
    print("METHOD 1: Supabase Dashboard SQL Editor")
    print("-" * 60)
    print(f"1. Go to: {SUPABASE_URL.replace('https://', 'https://supabase.com/dashboard/project/')}/sql/new")
    print("2. Copy and paste the contents of:")
    print("   - migrations/002_lease_extraction_tables.sql")
    print("   - migrations/003_comprehensive_lease_schema.sql")
    print("3. Click 'Run' for each file")
    print()
    print("METHOD 2: psql Command Line")
    print("-" * 60)
    project_ref = SUPABASE_URL.replace('https://', '').replace('.supabase.co', '')
    print(f"psql 'postgresql://postgres:[YOUR_DB_PASSWORD]@db.{project_ref}.supabase.co:5432/postgres' \\")
    print(f"  -f migrations/002_lease_extraction_tables.sql")
    print(f"psql 'postgresql://postgres:[YOUR_DB_PASSWORD]@db.{project_ref}.supabase.co:5432/postgres' \\")
    print(f"  -f migrations/003_comprehensive_lease_schema.sql")
    print()
    print("Your database password is in: Project Settings > Database > Connection Pooling")
    print()

    # Show what would be executed
    print("\n📋 Migration Preview:")
    print("=" * 60)

    for migration_file in ['migrations/002_lease_extraction_tables.sql',
                          'migrations/003_comprehensive_lease_schema.sql']:
        if os.path.exists(migration_file):
            execute_sql_file(migration_file)
        else:
            print(f"⚠️  File not found: {migration_file}")
