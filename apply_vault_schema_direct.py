#!/usr/bin/env python3
"""
Apply document vault schema using direct Supabase queries
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n📋 Checking documents table structure...")

# First, let's check if the documents table has the needed columns
try:
    result = supabase.table('documents').select('*').limit(1).execute()

    if result.data:
        existing_columns = result.data[0].keys() if result.data else []
        print(f"✅ Found documents table")
        print(f"   Existing columns: {', '.join(list(existing_columns)[:10])}...")

        needed_columns = ['storage_url', 'vault_category', 'vault_subfolder', 'file_size', 'mime_type']
        missing = [col for col in needed_columns if col not in existing_columns]

        if missing:
            print(f"\n⚠️  Missing vault columns: {', '.join(missing)}")
            print("\nℹ️  These columns need to be added in Supabase SQL Editor:")
            print("   Go to: https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new")
            print("\n   Run this SQL:")
            print("   " + "="*60)
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS storage_url TEXT;")
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS file_size BIGINT;")
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS mime_type TEXT;")
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_category TEXT;")
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_subfolder TEXT;")
            print("   ALTER TABLE documents ADD COLUMN IF NOT EXISTS metadata JSONB;")
            print("   " + "="*60)
        else:
            print("\n✅ All vault columns present!")

    else:
        print("⚠️  Documents table is empty - can't check structure")
        print("   Assuming schema needs to be applied")

except Exception as e:
    print(f"❌ Error checking table: {e}")
    print("\n   You need to apply the schema manually in Supabase SQL Editor")

print("\n")
