#!/usr/bin/env python3
"""
Check the actual schema of documents table
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n" + "="*70)
print("📋 Documents Table Schema")
print("="*70 + "\n")

# Get a sample document to see all columns
result = supabase.table('documents').select('*').limit(1).execute()

if result.data:
    doc = result.data[0]
    print("Current columns in documents table:")
    for col, value in doc.items():
        val_type = type(value).__name__
        val_preview = str(value)[:50] if value else 'NULL'
        print(f"  • {col:<25} ({val_type}): {val_preview}")

    print("\n" + "="*70)
    print("Checking for vault columns:")
    print("="*70 + "\n")

    vault_columns = ['storage_url', 'vault_category', 'vault_subfolder', 'mime_type', 'category', 'status', 'path', 'uploaded_at']
    for col in vault_columns:
        if col in doc:
            print(f"  ✅ {col}: EXISTS")
        else:
            print(f"  ❌ {col}: MISSING")
else:
    print("No documents found in table")

print("\n" + "="*70)
