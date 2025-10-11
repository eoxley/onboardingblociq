#!/usr/bin/env python3
"""
Create minimal building record
"""
import os
from supabase import create_client

SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

building_id = 'ceec21e6-b91e-4c40-9a57-51994caf3ab7'

print("\n" + "="*70)
print("🏢 Creating Building Record")
print("="*70 + "\n")

# First check what columns the buildings table has
try:
    existing = supabase.table('buildings').select('*').limit(1).execute()
    if existing.data:
        print("Existing buildings table columns:")
        for col in existing.data[0].keys():
            print(f"  • {col}")
        print()
except:
    pass

# Try minimal insert - just id, name, address
building_record = {
    'id': building_id,
    'name': 'Connaught Square',
    'address': '219.01 Connaught Square'
}

try:
    result = supabase.table('buildings').insert(building_record).execute()
    print(f"✅ Building created successfully!")
    print(f"   ID: {building_id}")
    print(f"   Name: Connaught Square")
except Exception as e:
    error_msg = str(e)
    if 'duplicate' in error_msg or 'already exists' in error_msg:
        print(f"✅ Building already exists: {building_id}")
    else:
        print(f"❌ Error: {error_msg}")

print("\n" + "="*70)
