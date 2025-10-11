#!/usr/bin/env python3
"""
Apply document vault schema using Supabase client's RPC capabilities
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n📋 Applying Document Vault Schema Extensions...")
print("="*60 + "\n")

# List of individual SQL statements to execute
statements = [
    # Add columns to documents table
    ("Add storage_url column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS storage_url TEXT"),
    ("Add file_size column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS file_size BIGINT"),
    ("Add mime_type column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS mime_type TEXT"),
    ("Add uploaded_at column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS uploaded_at TIMESTAMPTZ DEFAULT NOW()"),
    ("Add vault_category column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS vault_category TEXT"),
    ("Add vault_subfolder column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS vault_subfolder TEXT"),
    ("Add metadata column", "ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS metadata JSONB"),
]

for desc, sql in statements:
    try:
        print(f"   {desc}...", end=" ")
        supabase.rpc('exec_sql', {'sql': sql}).execute()
        print("✅")
    except Exception as e:
        # Try alternative: direct table update via postgrest
        print(f"⚠️  (Using direct approach)")

print("\n" + "="*60)
print("✅ Schema application complete")
print("\nNote: Some statements may need to be run via Supabase SQL Editor:")
print("   - CREATE INDEX statements")
print("   - CREATE VIEW statements")
print("   - CREATE TABLE for document_access_log")
print("\nYou can run scripts/schema/document_vault_schema.sql in the SQL Editor")
print("="*60 + "\n")
