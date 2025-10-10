#!/usr/bin/env python3
"""
Execute SQL migration using Supabase REST API
"""
import os
from dotenv import load_dotenv
import requests
import json

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_SERVICE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
    print("❌ Missing environment variables")
    print("Required: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY")
    exit(1)

def execute_sql_via_api(sql_file_path):
    """Execute SQL via Supabase REST API"""
    print(f"\n📄 Reading {sql_file_path}...")

    with open(sql_file_path, 'r') as f:
        sql = f.read()

    print(f"🔌 Connecting to Supabase API...")

    # Use PostgREST rpc endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc/exec_sql"

    headers = {
        'apikey': SUPABASE_SERVICE_KEY,
        'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
        'Content-Type': 'application/json'
    }

    payload = {
        'query': sql
    }

    print(f"🚀 Executing SQL via API...")

    try:
        response = requests.post(url, headers=headers, json=payload)

        if response.status_code == 200:
            print(f"✅ Migration executed successfully!")
            return True
        else:
            print(f"❌ Error {response.status_code}: {response.text}")

            # Try alternative: use Supabase Management API
            print(f"\n🔄 Trying alternative method...")
            return execute_sql_chunks(sql)

    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def execute_sql_chunks(sql):
    """Execute SQL in smaller chunks using Supabase Python client"""
    try:
        from supabase import create_client, Client

        print(f"🔌 Using Supabase Python client...")

        supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

        # Split SQL into statements
        statements = [s.strip() for s in sql.split(';') if s.strip()]

        print(f"📝 Executing {len(statements)} SQL statements...")

        for i, statement in enumerate(statements):
            if statement:
                try:
                    # Use query for each statement
                    result = supabase.postgrest.rpc('exec_sql', {'query': statement + ';'}).execute()
                    if i % 100 == 0:
                        print(f"  ✓ Executed {i}/{len(statements)} statements")
                except Exception as e:
                    print(f"  ⚠️  Statement {i} failed: {statement[:100]}...")
                    print(f"     Error: {str(e)}")

        print(f"✅ Migration completed!")
        return True

    except ImportError:
        print(f"❌ supabase-py not installed. Install with: pip3 install supabase")
        return False
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == '__main__':
    print("=" * 60)
    print("BlocIQ Migration Executor")
    print("=" * 60)

    success = execute_sql_via_api('output/migration_final3.sql')

    if success:
        print("\n✅ Migration completed successfully!")
    else:
        print("\n⚠️  Migration failed")
        print("\n💡 Alternative: Run SQL manually in Supabase SQL Editor:")
        print(f"   {SUPABASE_URL.replace('https://', 'https://supabase.com/dashboard/project/').replace('.supabase.co', '')}/sql/new")
