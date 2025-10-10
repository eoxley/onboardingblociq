#!/usr/bin/env python3
"""
Execute SQL migrations using Supabase RPC
"""
import os
from dotenv import load_dotenv
import requests

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

def execute_sql_via_rpc(sql_content, migration_name):
    """Execute SQL using Supabase's RPC endpoint"""
    print(f"\n📄 Executing {migration_name}...")

    # Supabase allows executing SQL via the PostgREST API using rpc
    # We need to create or use the sql execution endpoint

    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }

    # Use Supabase's query endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc/exec_sql"

    # Try to execute via RPC
    try:
        response = requests.post(
            url,
            headers=headers,
            json={'query': sql_content}
        )

        if response.status_code in [200, 201, 204]:
            print(f"   ✅ {migration_name} executed successfully!")
            return True
        else:
            print(f"   ⚠️  Response: {response.status_code}")
            print(f"   Error: {response.text}")
            return False

    except Exception as e:
        print(f"   ⚠️  Error: {str(e)}")
        return False

# Read migration files
migration_files = [
    ('migrations/002_lease_extraction_tables.sql', 'Lease Extraction Tables'),
    ('migrations/003_comprehensive_lease_schema.sql', 'Comprehensive Lease Schema')
]

print("=" * 60)
print("BlocIQ Database Migration Executor")
print("=" * 60)
print(f"Target: {SUPABASE_URL}\n")

# The Supabase Python/REST API doesn't support direct SQL execution
# We need to use the Dashboard or create a stored procedure
print("⚠️  Direct SQL execution via API is not supported.")
print("Creating combined migration file for manual execution...\n")

# Combine migrations into one file
combined_sql = "-- Combined migrations for BlocIQ\n"
combined_sql += "-- Generated automatically\n\n"

for file_path, name in migration_files:
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            combined_sql += f"-- {name}\n"
            combined_sql += "-- " + "=" * 58 + "\n\n"
            combined_sql += f.read()
            combined_sql += "\n\n"

# Write combined file
output_file = 'migrations/combined_lease_migrations.sql'
with open(output_file, 'w') as f:
    f.write(combined_sql)

print(f"✅ Created combined migration file: {output_file}")
print(f"   {len(combined_sql.splitlines())} lines")
print()
print("To execute this migration, use ONE of these methods:")
print("-" * 60)
print()
print("METHOD 1: Supabase Dashboard (Recommended)")
print(f"1. Go to: https://supabase.com/dashboard/project/aewixchhykxyhqjvqoek/sql/new")
print(f"2. Copy the contents of: {output_file}")
print("3. Paste into the SQL Editor")
print("4. Click 'Run'")
print()
print("METHOD 2: psql Command Line")
project_ref = SUPABASE_URL.replace('https://', '').replace('.supabase.co', '')
print(f"export PGPASSWORD='[YOUR_DB_PASSWORD]'")
print(f"psql -h db.{project_ref}.supabase.co -p 5432 -U postgres -d postgres -f {output_file}")
print()
print("📋 The migration will create:")
print("   • 6 new comprehensive lease tables")
print("   • 4 enhanced existing tables")
print("   • All necessary indexes and foreign keys")
print("   • Comments for documentation")
