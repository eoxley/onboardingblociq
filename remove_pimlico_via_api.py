#!/usr/bin/env python3
"""Remove all Pimlico Place buildings via Supabase API"""

import os
import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

headers = {
    'apikey': SUPABASE_SERVICE_KEY,
    'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
    'Content-Type': 'application/json'
}

print("\n" + "="*100)
print("🔍 CHECKING FOR PIMLICO PLACE BUILDINGS VIA API")
print("="*100)

# Query for Pimlico buildings
response = requests.get(
    f"{SUPABASE_URL}/rest/v1/buildings",
    headers=headers,
    params={
        'or': '(building_name.ilike.*pimlico*,building_address.ilike.*pimlico*)',
        'select': 'id,building_name,building_address,num_units,created_at'
    }
)

if response.status_code != 200:
    print(f"❌ Error querying buildings: {response.status_code} - {response.text}")
    exit(1)

buildings = response.json()

print(f"\n📊 Found {len(buildings)} building(s) with 'Pimlico' in name/address:\n")

if len(buildings) == 0:
    print("✅ No Pimlico Place buildings found in database!")
    exit(0)

for i, building in enumerate(buildings, 1):
    print(f"Building #{i}:")
    print(f"  ID: {building['id']}")
    print(f"  Name: {building['building_name']}")
    print(f"  Address: {building['building_address']}")
    print(f"  Units: {building['num_units']}")
    print(f"  Created: {building['created_at']}")
    print()

print("="*100)
print("⚠️  READY TO DELETE")
print("="*100)

confirm = input(f"\n❓ Delete {len(buildings)} Pimlico Place building(s)? (yes/no): ")

if confirm.lower() == 'yes':
    print("\n🗑️  Deleting buildings...")

    for building in buildings:
        building_id = building['id']

        # Delete the building (cascading deletes should handle related records)
        delete_response = requests.delete(
            f"{SUPABASE_URL}/rest/v1/buildings",
            headers=headers,
            params={'id': f'eq.{building_id}'}
        )

        if delete_response.status_code in [200, 204]:
            print(f"  ✅ Deleted building {building_id}")
        else:
            print(f"  ❌ Failed to delete {building_id}: {delete_response.status_code} - {delete_response.text}")

    print(f"\n✅ Successfully deleted {len(buildings)} building(s)!")
else:
    print("\n❌ Deletion cancelled.")

print("\n" + "="*100 + "\n")
