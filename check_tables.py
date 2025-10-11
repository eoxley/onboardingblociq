#!/usr/bin/env python3
"""
Check what tables exist in the database
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n" + "="*70)
print("🔍 Checking Database Tables")
print("="*70 + "\n")

# Try to query different tables to see what exists
tables_to_check = [
    'buildings',
    'documents',
    'units',
    'leases',
    'compliance_assets',
    'insurance_policies',
    'budget_items'
]

for table in tables_to_check:
    try:
        result = supabase.table(table).select('*').limit(1).execute()
        print(f"✅ {table}: EXISTS (has {len(result.data)} records in sample)")

        # Try to get column info by inspecting first record if exists
        if result.data:
            cols = list(result.data[0].keys())
            print(f"   Columns: {', '.join(cols[:5])}{'...' if len(cols) > 5 else ''}")
    except Exception as e:
        error_msg = str(e)
        if 'does not exist' in error_msg or 'not found' in error_msg:
            print(f"❌ {table}: DOES NOT EXIST")
        else:
            print(f"⚠️  {table}: ERROR - {error_msg[:60]}")

print("\n" + "="*70)
