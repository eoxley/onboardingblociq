#!/usr/bin/env python3
"""Remove all Pimlico Place buildings from Supabase"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n" + "="*100)
print("🔍 CHECKING FOR PIMLICO PLACE BUILDINGS")
print("="*100)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()

    # Find all Pimlico Place buildings
    cursor.execute("""
        SELECT
            id,
            name,
            address,
            num_units,
            created_at
        FROM buildings
        WHERE name ILIKE '%pimlico%' OR address ILIKE '%pimlico%'
        ORDER BY created_at DESC
    """)

    buildings = cursor.fetchall()

    print(f"\n📊 Found {len(buildings)} building(s) with 'Pimlico' in name/address:\n")

    if len(buildings) == 0:
        print("✅ No Pimlico Place buildings found in database!")
        cursor.close()
        conn.close()
        exit(0)

    building_ids = []
    for i, building in enumerate(buildings, 1):
        building_id = building[0]
        name = building[1]
        address = building[2]
        num_units = building[3]
        created = building[4]

        building_ids.append(building_id)

        print(f"Building #{i}:")
        print(f"  ID: {building_id}")
        print(f"  Name: {name}")
        print(f"  Address: {address}")
        print(f"  Units: {num_units}")
        print(f"  Created: {created}")

        # Count related records - check if table exists first
        try:
            cursor.execute("SELECT COUNT(*) FROM building_data_snapshots WHERE building_id = %s", (building_id,))
            snapshots = cursor.fetchone()[0]
        except:
            snapshots = 0

        print(f"  Related Records:")
        print(f"    • Snapshots: {snapshots}")
        print()

    print("="*100)
    print("⚠️  READY TO DELETE")
    print("="*100)

    confirm = input(f"\n❓ Delete {len(buildings)} Pimlico Place building(s) and all related data? (yes/no): ")

    if confirm.lower() == 'yes':
        print("\n🗑️  Deleting buildings...")

        for building_id in building_ids:
            # Delete building_data_snapshots first (FK constraint) if table exists
            deleted_snapshots = 0
            try:
                cursor.execute("DELETE FROM building_data_snapshots WHERE building_id = %s", (building_id,))
                deleted_snapshots = cursor.rowcount
            except:
                pass

            # Delete building
            cursor.execute("DELETE FROM buildings WHERE id = %s", (building_id,))

            print(f"  ✅ Deleted building {building_id} ({deleted_snapshots} snapshots)")

        conn.commit()
        print(f"\n✅ Successfully deleted {len(buildings)} building(s)!")
    else:
        print("\n❌ Deletion cancelled.")

    print("\n" + "="*100 + "\n")

    cursor.close()
    conn.close()

except Exception as e:
    print(f"\n❌ Error: {e}\n")
    if 'conn' in locals():
        conn.rollback()
