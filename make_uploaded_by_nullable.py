#!/usr/bin/env python3
"""
Make uploaded_by nullable via Supabase RPC
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n" + "="*70)
print("🔧 Making uploaded_by Column Nullable")
print("="*70 + "\n")

sql = "ALTER TABLE documents ALTER COLUMN uploaded_by DROP NOT NULL;"

try:
    # Try direct SQL execution via rpc (if function exists)
    result = supabase.rpc('exec_sql', {'sql': sql}).execute()
    print("✅ uploaded_by is now nullable!")
except Exception as e:
    error_msg = str(e)
    print(f"❌ RPC method failed: {error_msg[:100]}")
    print("\nTrying alternative method...")

    # Alternative: Check if we can get an existing user ID to use as default
    try:
        users_result = supabase.table('users').select('id').limit(1).execute()
        if users_result.data:
            user_id = users_result.data[0]['id']
            print(f"\n✅ Found user ID to use as fallback: {user_id}")
            print(f"\nWe can set uploaded_by to this user ID instead of NULL")
        else:
            print("\n⚠️  No users found in database")
    except Exception as e2:
        print(f"\n⚠️  Cannot access users table: {str(e2)[:60]}")

print("\n" + "="*70)
print("\nThe SQL that needs to be run:")
print("ALTER TABLE documents ALTER COLUMN uploaded_by DROP NOT NULL;")
print("="*70 + "\n")
