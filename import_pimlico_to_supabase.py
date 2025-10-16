#!/usr/bin/env python3
"""
Import Pimlico Place Production SQL to Supabase
"""

import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

def main():
    print("\n" + "="*100)
    print("🚀 IMPORTING PIMLICO PLACE TO SUPABASE")
    print("="*100)

    sql_file = "output/pimlico_place_production.sql"

    if not os.path.exists(sql_file):
        print(f"❌ File not found: {sql_file}")
        return

    print(f"\n📄 File: {sql_file}")

    with open(sql_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    file_size = len(sql_content) / 1024
    line_count = sql_content.count('\n')

    print(f"📊 Size: {file_size:.1f} KB, {line_count:,} lines")
    print(f"\n🔄 Connecting to Supabase...")

    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        print(f"✅ Connected!")

        print(f"\n🔄 Executing SQL...")
        cursor.execute(sql_content)
        conn.commit()

        print(f"✅ SQL executed successfully!")

        # Verify
        print(f"\n{'='*100}")
        print(f"🔍 VERIFICATION")
        print(f"{'='*100}")

        cursor.execute("""
            SELECT id, building_name, building_address, num_units, created_at
            FROM buildings
            WHERE building_name ILIKE '%pimlico%' OR building_address ILIKE '%pimlico%'
        """)

        buildings = cursor.fetchall()

        if buildings:
            print(f"\n✅ Found {len(buildings)} Pimlico Place building(s):\n")
            for building in buildings:
                print(f"  ID: {building[0]}")
                print(f"  Name: {building[1]}")
                print(f"  Address: {building[2]}")
                print(f"  Units: {building[3]}")
                print(f"  Created: {building[4]}")
                print()
        else:
            print(f"\n⚠️ No Pimlico Place buildings found!")

        print("="*100)
        print("🎉 IMPORT COMPLETE!")
        print("="*100)

        cursor.close()
        conn.close()

    except Exception as e:
        print(f"\n❌ Error: {e}")
        if 'conn' in locals():
            conn.rollback()
        raise

if __name__ == "__main__":
    main()
