#!/usr/bin/env python3
"""
Create the assets table in Supabase
"""
import os
from supabase import create_client, Client

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

def execute_sql(sql_file):
    """Execute SQL file via Supabase"""
    print(f"\n📄 Reading {sql_file}...")

    with open(sql_file, 'r') as f:
        sql = f.read()

    print(f"🔌 Connecting to Supabase...")
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"✅ Connected!")

    print(f"🚀 Executing SQL...\n")

    # Try using exec_sql RPC if it exists
    try:
        result = supabase.rpc('exec_sql', {'query': sql}).execute()
        print(f"✅ Assets table created successfully!")
        return True
    except Exception as e:
        print(f"⚠️  exec_sql RPC not available: {e}")
        print(f"\n📋 Please run this SQL manually in Supabase SQL Editor:")
        print(f"\n1. Go to: {SUPABASE_URL.replace('https://', 'https://supabase.com/dashboard/project/')}/sql/new")
        print(f"2. Copy and execute the contents of: {sql_file}")
        print(f"\nSQL to execute:")
        print("=" * 70)
        print(sql)
        print("=" * 70)
        return False

if __name__ == '__main__':
    execute_sql('migrations/005_assets_table.sql')
