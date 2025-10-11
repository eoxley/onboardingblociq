#!/usr/bin/env python3
"""
Cleanup script to wipe all data for a specific building
"""
import os
import sys
from supabase import create_client

# Get building ID from command line
if len(sys.argv) < 2:
    print("Usage: python3 cleanup_building.py <building_id>")
    sys.exit(1)

building_id = sys.argv[1]

# Environment
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY environment variable not set")
    print("Please set it in your environment or .env file")
    sys.exit(1)

# Initialize Supabase
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

print(f"\n🗑️  Cleaning up all data for building: {building_id}")
print("="*60)

# Order matters - delete in reverse dependency order
tables_to_clean = [
    'leases',
    'budget_items',
    'compliance_assets',
    'insurance_policies',
    'documents',
    'units',
    'buildings'
]

total_deleted = 0

for table in tables_to_clean:
    try:
        print(f"\n📋 Checking {table}...", end=" ")

        # Count records
        count_result = supabase.table(table).select('id', count='exact').eq('building_id', building_id).execute()
        count = count_result.count if hasattr(count_result, 'count') else len(count_result.data)

        if count == 0:
            print(f"✓ No records")
            continue

        print(f"Found {count} record(s)")

        # Delete records
        if table == 'buildings':
            # For buildings table, delete by id directly
            delete_result = supabase.table(table).delete().eq('id', building_id).execute()
        else:
            # For other tables, delete by building_id
            delete_result = supabase.table(table).delete().eq('building_id', building_id).execute()

        deleted_count = len(delete_result.data) if delete_result.data else count
        total_deleted += deleted_count
        print(f"   ✅ Deleted {deleted_count} record(s)")

    except Exception as e:
        print(f"   ⚠️  Warning: {str(e)}")
        continue

print("\n" + "="*60)
print(f"✅ Cleanup complete. Total records deleted: {total_deleted}")
print("="*60 + "\n")
