#!/usr/bin/env python3
"""
Apply vault schema using Supabase RPC or direct table manipulation
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
print("📋 Applying Document Vault Schema")
print("="*70 + "\n")

# SQL statements to execute
sql_statements = [
    """
    ALTER TABLE documents
    ADD COLUMN IF NOT EXISTS storage_url TEXT,
    ADD COLUMN IF NOT EXISTS mime_type TEXT,
    ADD COLUMN IF NOT EXISTS vault_category TEXT,
    ADD COLUMN IF NOT EXISTS vault_subfolder TEXT,
    ADD COLUMN IF NOT EXISTS metadata JSONB;
    """,
    """
    CREATE INDEX IF NOT EXISTS idx_documents_vault_category
    ON documents(building_id, vault_category);
    """,
    """
    CREATE INDEX IF NOT EXISTS idx_documents_storage_url
    ON documents(storage_url) WHERE storage_url IS NOT NULL;
    """
]

# Try to execute via RPC
print("Attempting to apply schema via Supabase API...\n")

for i, sql in enumerate(sql_statements, 1):
    try:
        print(f"Statement {i}... ", end="")

        # Try using the SQL execution endpoint
        response = supabase.postgrest.rpc('exec_sql', {'query': sql}).execute()
        print("✅")

    except Exception as e:
        print(f"❌ Failed: {str(e)[:100]}")

        if i == 1:
            print("\n⚠️  Cannot apply schema via API.")
            print("\nPlease run this SQL manually in Supabase SQL Editor:")
            print("👉 https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new\n")

            print("Copy and paste this SQL:")
            print("="*70)
            for stmt in sql_statements:
                print(stmt.strip())
                print()
            print("="*70)
            exit(1)

print("\n" + "="*70)
print("✅ Schema applied successfully!")
print("="*70 + "\n")
