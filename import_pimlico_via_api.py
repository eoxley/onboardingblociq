#!/usr/bin/env python3
"""
Import Pimlico Place via Supabase REST API
Parses the SQL and converts to API calls
"""

import os
import json
import re
import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

headers = {
    'apikey': SUPABASE_SERVICE_KEY,
    'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
    'Content-Type': 'application/json',
    'Prefer': 'return=representation'
}

def extract_building_data(sql_content):
    """Extract building data from SQL INSERT"""
    # Find the buildings INSERT
    building_match = re.search(
        r"INSERT INTO buildings \(name, address, postcode, num_units, bsa_status\)\s*VALUES \('([^']+)', '([^']+)', '([^']+)', (\d+), '([^']+)'\)",
        sql_content
    )

    if not building_match:
        return None

    return {
        'building_name': building_match.group(1),
        'building_address': building_match.group(2),
        'postcode': building_match.group(3),
        'num_units': int(building_match.group(4)),
        'bsa_status': building_match.group(5)
    }

def extract_snapshot_data(sql_content):
    """Extract building_data_snapshots JSON"""
    # Find the raw_sql_json content
    snapshot_match = re.search(
        r"raw_sql_json\)\s*VALUES \(\s*'([^']+)',\s*'([^']+)',\s*'([^']+)',\s*'([^']+)',\s*'({.*})'\s*\)",
        sql_content,
        re.DOTALL
    )

    if not snapshot_match:
        return None, None

    snapshot_id = snapshot_match.group(1)
    building_id = snapshot_match.group(2)
    extracted_at = snapshot_match.group(3)
    source_folder = snapshot_match.group(4)
    json_data = snapshot_match.group(5)

    # Parse JSON
    try:
        data = json.loads(json_data)
        return {
            'id': snapshot_id,
            'building_id': building_id,
            'extracted_at': extracted_at,
            'source_folder': source_folder,
            'raw_sql_json': data
        }, data
    except json.JSONDecodeError as e:
        print(f"❌ JSON parse error: {e}")
        return None, None

def main():
    print("\n" + "="*100)
    print("🚀 IMPORTING PIMLICO PLACE VIA API")
    print("="*100)

    sql_file = "output/pimlico_place_production.sql"

    if not os.path.exists(sql_file):
        print(f"❌ File not found: {sql_file}")
        return

    with open(sql_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    print(f"\n📄 Parsing SQL file...")

    # Extract data
    building_data = extract_building_data(sql_content)
    snapshot_data, json_data = extract_snapshot_data(sql_content)

    if not building_data:
        print("❌ Could not extract building data")
        return

    print(f"\n✅ Extracted:")
    print(f"   Building: {building_data['building_name']}")
    print(f"   Units: {building_data['num_units']}")
    if json_data:
        print(f"   Leaseholders: {len(json_data.get('leaseholders', []))}")
        print(f"   Units in JSON: {len(json_data.get('units', []))}")

    # Step 1: Insert building
    print(f"\n🔄 Step 1: Creating building...")
    response = requests.post(
        f"{SUPABASE_URL}/rest/v1/buildings",
        headers=headers,
        json=building_data
    )

    if response.status_code in [200, 201]:
        created_building = response.json()[0] if isinstance(response.json(), list) else response.json()
        building_id = created_building['id']
        print(f"✅ Building created with ID: {building_id}")
    else:
        print(f"❌ Error creating building: {response.status_code}")
        print(f"   Response: {response.text}")
        return

    # Step 2: Insert snapshot if we have it
    if snapshot_data:
        print(f"\n🔄 Step 2: Creating building_data_snapshot...")

        # Update building_id to the actual created ID
        snapshot_data['building_id'] = building_id

        response = requests.post(
            f"{SUPABASE_URL}/rest/v1/building_data_snapshots",
            headers=headers,
            json=snapshot_data
        )

        if response.status_code in [200, 201]:
            print(f"✅ Snapshot created!")
        else:
            print(f"⚠️  Snapshot creation failed: {response.status_code}")
            print(f"   Response: {response.text}")
            print(f"   (This is OK if table doesn't exist)")

    # Verify
    print(f"\n{'='*100}")
    print(f"🔍 VERIFICATION")
    print(f"{'='*100}")

    response = requests.get(
        f"{SUPABASE_URL}/rest/v1/buildings",
        headers=headers,
        params={
            'building_name': f'eq.{building_data["building_name"]}',
            'select': 'id,building_name,building_address,num_units,created_at'
        }
    )

    if response.status_code == 200:
        buildings = response.json()
        if buildings:
            print(f"\n✅ Found {len(buildings)} Pimlico Place building(s):\n")
            for building in buildings:
                print(f"  ID: {building['id']}")
                print(f"  Name: {building['building_name']}")
                print(f"  Address: {building['building_address']}")
                print(f"  Units: {building['num_units']}")
                print()

    print("="*100)
    print("🎉 IMPORT COMPLETE!")
    print("="*100)
    print(f"\n🔗 View in Supabase:")
    print(f"   {SUPABASE_URL.replace('https://', 'https://app.supabase.com/project/')}/editor")

if __name__ == "__main__":
    main()
