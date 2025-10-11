#!/usr/bin/env python3
"""
Find a user ID to use for document uploads
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print("\n" + "="*70)
print("🔍 Finding User ID for Document Uploads")
print("="*70 + "\n")

# Check existing document to see what user IDs are being used
existing_docs = supabase.table('documents').select('uploaded_by').limit(5).execute()

if existing_docs.data:
    print("Existing uploaded_by values in documents:")
    used_users = set()
    for doc in existing_docs.data:
        user_id = doc.get('uploaded_by')
        if user_id:
            used_users.add(user_id)
            print(f"  • {user_id}")

    if used_users:
        system_user = list(used_users)[0]
        print(f"\n✅ Using this user ID for vault uploads: {system_user}")
        print(f"\nUpdate document_vault_manager.py line 233:")
        print(f"'uploaded_by': '{system_user}'")
    else:
        print("\n⚠️  All uploaded_by values are NULL")
else:
    print("No documents found")

print("\n" + "="*70)
