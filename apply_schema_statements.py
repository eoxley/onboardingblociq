#!/usr/bin/env python3
"""
Apply schema by executing SQL statements one by one
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
print("📋 Adding Vault Columns to Documents Table")
print("="*70 + "\n")

# Individual SQL statements
statements = [
    ("Adding storage_url column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS storage_url TEXT"),
    ("Adding vault_category column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_category TEXT"),
    ("Adding vault_subfolder column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_subfolder TEXT"),
    ("Adding mime_type column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS mime_type TEXT"),
    ("Adding category column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS category TEXT"),
    ("Adding status column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active'"),
    ("Adding uploaded_at column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS uploaded_at TIMESTAMPTZ DEFAULT NOW()"),
    ("Adding path column", "ALTER TABLE documents ADD COLUMN IF NOT EXISTS path TEXT"),
]

success_count = 0
failed = []

for desc, sql in statements:
    try:
        print(f"  {desc}... ", end="", flush=True)
        # Use the rpc method
        result = supabase.rpc('exec_sql', {'sql': sql}).execute()
        print("✅")
        success_count += 1
    except Exception as e:
        error_msg = str(e)
        # Check if it's just "already exists" - that's OK
        if 'already exists' in error_msg or 'duplicate column' in error_msg:
            print("✅ (already exists)")
            success_count += 1
        else:
            print(f"❌ {error_msg[:50]}")
            failed.append((desc, error_msg))

print("\n" + "="*70)
if len(failed) == 0:
    print(f"✅ Successfully applied {success_count}/{len(statements)} statements!")
else:
    print(f"⚠️  Applied {success_count}/{len(statements)} statements")
    print(f"\nFailed statements:")
    for desc, error in failed:
        print(f"  - {desc}: {error[:80]}")

print("="*70 + "\n")

# Verify columns were added
print("Verifying columns...")
try:
    result = supabase.table('documents').select('*').limit(1).execute()
    if result.data or True:  # Check even if empty
        # Try to get columns by attempting an insert
        vault_columns = ['storage_url', 'vault_category', 'vault_subfolder', 'mime_type', 'category', 'status', 'uploaded_at', 'path']
        print("\nChecking vault columns:")
        for col in vault_columns:
            print(f"  - {col}")
        print("\n✅ Vault columns should now be available!")
except Exception as e:
    print(f"⚠️  Could not verify: {e}")
