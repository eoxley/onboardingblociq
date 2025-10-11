#!/usr/bin/env python3
import os
from document_vault_manager import DocumentVaultManager

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

# Test single PDF upload
result = vault.upload_document(
    file_path='/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/1. CLIENT INFORMATION/Letter of Authority - Connaught Square.doc.pdf',
    building_id='ceec21e6-b91e-4c40-9a57-51994caf3ab7',
    category='general_correspondence'
)

print('Test Upload Result:')
print(f'Success: {result["success"]}')
if result['success']:
    print(f'✅ Uploaded to: {result["storage_path"]}')
    print(f'   Category: {result.get("category")}')
    print(f'   URL: {result["url"][:80]}...')
else:
    print(f'❌ Error: {result.get("error", "Unknown")}')
