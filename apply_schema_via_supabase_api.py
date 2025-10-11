#!/usr/bin/env python3
"""
Apply schema by executing SQL statements via Supabase REST API
"""
import os
import requests

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    exit(1)

# Read SQL file
with open('add_vault_columns.sql', 'r') as f:
    sql = f.read()

print("\n" + "="*70)
print("📋 Applying Vault Schema via Supabase API")
print("="*70 + "\n")

# Try using Supabase REST API to execute SQL
# This uses the PostgREST RPC endpoint
url = f"{SUPABASE_URL}/rest/v1/rpc/exec_sql"

headers = {
    'apikey': SUPABASE_KEY,
    'Authorization': f'Bearer {SUPABASE_KEY}',
    'Content-Type': 'application/json'
}

payload = {
    'sql': sql
}

print("Attempting to execute SQL via REST API...")
response = requests.post(url, headers=headers, json=payload)

if response.status_code == 200:
    print("✅ SQL executed successfully!")
    print(response.json())
else:
    print(f"❌ Failed with status {response.status_code}")
    print(f"Response: {response.text}")
    print("\n" + "="*70)
    print("⚠️  Direct API execution not available.")
    print("\nPlease run the SQL manually in Supabase SQL Editor:")
    print("👉 https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new")
    print("\nOr use the file: add_vault_columns.sql")
    print("="*70)
