#!/usr/bin/env python3
"""
Execute SQL migration by uploading to Supabase and running via Management API
"""
import os
import requests
import json

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"
PROJECT_REF = "aewixchhykxyhqjvqoek"

def read_sql_file():
    """Read the migration SQL file"""
    with open('output/migration_final3.sql', 'r') as f:
        return f.read()

def execute_via_management_api(sql):
    """Execute SQL via Supabase Management API"""
    print("🔌 Attempting to execute via Supabase Management API...")

    # Management API endpoint
    url = f"https://api.supabase.com/v1/projects/{PROJECT_REF}/database/query"

    headers = {
        'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
        'Content-Type': 'application/json'
    }

    payload = {
        'query': sql
    }

    try:
        response = requests.post(url, headers=headers, json=payload)
        print(f"Response Status: {response.status_code}")
        print(f"Response: {response.text[:500]}")

        if response.status_code == 200:
            print("✅ Migration executed successfully!")
            return True
        else:
            print(f"❌ Failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def main():
    print("=" * 60)
    print("BlocIQ Migration Executor - Management API")
    print("=" * 60)

    print("\n📄 Reading migration file...")
    sql = read_sql_file()
    print(f"✓ Read {len(sql)} characters")

    success = execute_via_management_api(sql)

    if not success:
        print("\n" + "=" * 60)
        print("⚠️  Automatic execution failed")
        print("=" * 60)
        print("\n📋 Manual execution required:")
        print(f"1. Go to: https://supabase.com/dashboard/project/{PROJECT_REF}/sql/new")
        print(f"2. Copy contents from: output/migration_final3.sql")
        print(f"3. Paste and execute in SQL Editor")
        print("\n💡 The file has been fixed and includes the assets table creation!")

if __name__ == '__main__':
    main()
