#!/usr/bin/env python3
"""
Clean up all Connaught Square data from Supabase
Removes all related data (documents, leases, insurance, compliance, etc.)
"""
import os
import sys

try:
    from supabase import create_client
except ImportError:
    print("Installing supabase client...")
    os.system("pip3 install supabase")
    from supabase import create_client

# Environment variables
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY environment variable not set")
    sys.exit(1)

def cleanup_connaught_square():
    """Delete all Connaught Square data from Supabase"""

    print("\n" + "="*60)
    print("🧹 Cleaning up Connaught Square data from Supabase")
    print("="*60 + "\n")

    # Create client
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

    # Find Connaught Square building(s)
    print("🔍 Finding Connaught Square building(s)...")

    try:
        response = supabase.table('buildings').select('id, name').ilike('name', '%connaught%').execute()

        if not response.data:
            print("✅ No Connaught Square buildings found - database is clean!")
            return

        print(f"   Found {len(response.data)} building(s):")
        building_ids = []
        for building in response.data:
            print(f"   - {building['name']} (ID: {building['id']})")
            building_ids.append(building['id'])

        # Confirm deletion
        print("\n⚠️  WARNING: This will delete ALL data for these buildings!")
        confirm = input("\nType 'DELETE' to confirm: ")

        if confirm != 'DELETE':
            print("❌ Aborted - no data deleted")
            return

        print("\n🗑️  Deleting data...")

        # Delete in order (respecting foreign keys)
        # Child tables first, parent tables last

        tables_to_clean = [
            # Child tables (have foreign keys to other tables)
            'leases',
            'budget_items',
            'compliance_requirements_status',
            'compliance_assets',
            'insurance_policies',
            'contracts',
            'contractors',
            'documents',
            'units',
            # Parent table (last)
            'buildings'
        ]

        deleted_counts = {}

        for table in tables_to_clean:
            try:
                print(f"   Deleting from {table}...", end=" ")

                # Delete all records for these building IDs
                result = supabase.table(table).delete().in_('building_id', building_ids).execute()

                count = len(result.data) if result.data else 0
                deleted_counts[table] = count

                if count > 0:
                    print(f"✅ {count} records deleted")
                else:
                    print("✅ (no records)")

            except Exception as e:
                error_msg = str(e)
                if 'does not exist' in error_msg or 'column' in error_msg:
                    print(f"⏭️  (table doesn't exist)")
                    deleted_counts[table] = 0
                else:
                    print(f"❌ Error: {e}")
                    deleted_counts[table] = f"ERROR: {e}"

        # Summary
        print("\n" + "="*60)
        print("📊 Cleanup Summary")
        print("="*60)

        total_deleted = sum(v for v in deleted_counts.values() if isinstance(v, int))

        for table, count in deleted_counts.items():
            if isinstance(count, int):
                print(f"  {table:.<40} {count} records")
            else:
                print(f"  {table:.<40} {count}")

        print(f"\n  {'TOTAL':.<40} {total_deleted} records deleted")

        print("\n✅ Cleanup complete! Database is now clean.\n")

    except Exception as e:
        print(f"\n❌ Error during cleanup: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    cleanup_connaught_square()
