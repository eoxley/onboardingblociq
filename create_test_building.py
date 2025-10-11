#!/usr/bin/env python3
"""
Create a minimal building record for testing document vault uploads
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Create minimal building record
building_record = {
    'id': 'ceec21e6-b91e-4c40-9a57-51994caf3ab7',
    'name': 'Connaught Square',
    'address': '219.01 Connaught Square',
    'city': 'London',
    'postcode': 'W2 2HL',
    'country': 'United Kingdom'
}

print("\n" + "="*70)
print("🏢 Creating Building Record")
print("="*70 + "\n")

try:
    result = supabase.table('buildings').insert(building_record).execute()
    print(f"✅ Building created: {building_record['name']}")
    print(f"   ID: {building_record['id']}")
    print(f"   Address: {building_record['address']}")
except Exception as e:
    error_msg = str(e)
    if 'duplicate key' in error_msg or 'already exists' in error_msg:
        print(f"✅ Building already exists: {building_record['name']}")
    else:
        print(f"❌ Error: {error_msg}")
        exit(1)

print("\n" + "="*70)
print("✅ Ready for document uploads!")
print("="*70 + "\n")
