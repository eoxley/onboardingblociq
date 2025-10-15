#!/usr/bin/env python3
"""Check for duplicate buildings in Supabase"""

import psycopg2
from datetime import datetime

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n" + "="*100)
print("🔍 CHECKING FOR DUPLICATE BUILDINGS")
print("="*100)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Find all Connaught Square buildings
    cursor.execute("""
        SELECT 
            id, 
            building_name, 
            created_at,
            cleaning_contractor,
            lift_contractor,
            num_units
        FROM buildings 
        WHERE building_name LIKE '%Connaught%'
        ORDER BY created_at DESC
    """)
    
    buildings = cursor.fetchall()
    
    print(f"\n📊 Found {len(buildings)} building(s) with 'Connaught' in name:\n")
    
    for i, building in enumerate(buildings, 1):
        building_id = building[0]
        name = building[1]
        created = building[2]
        cleaning = building[3]
        lift = building[4]
        num_units = building[5]
        
        print(f"Building #{i}:")
        print(f"  ID: {building_id}")
        print(f"  Name: {name}")
        print(f"  Created: {created}")
        print(f"  Cleaning: {cleaning or 'Not set'}")
        print(f"  Lift: {lift or 'Not set'}")
        print(f"  Units Count: {num_units}")
        
        # Count related records
        cursor.execute(f"SELECT COUNT(*) FROM units WHERE building_id = '{building_id}'")
        units = cursor.fetchone()[0]
        
        cursor.execute(f"SELECT COUNT(*) FROM compliance_assets WHERE building_id = '{building_id}'")
        compliance = cursor.fetchone()[0]
        
        cursor.execute(f"SELECT COUNT(*) FROM leases WHERE building_id = '{building_id}'")
        leases = cursor.fetchone()[0]
        
        cursor.execute(f"SELECT COUNT(*) FROM budgets WHERE building_id = '{building_id}'")
        budgets = cursor.fetchone()[0]
        
        cursor.execute(f"SELECT COUNT(*) FROM lease_clauses WHERE building_id = '{building_id}'")
        clauses = cursor.fetchone()[0]
        
        total_records = units + compliance + leases + budgets + clauses
        
        print(f"  Related Records:")
        print(f"    • Units: {units}")
        print(f"    • Compliance: {compliance}")
        print(f"    • Leases: {leases}")
        print(f"    • Budgets: {budgets}")
        print(f"    • Lease Clauses: {clauses}")
        print(f"    • TOTAL: {total_records}")
        
        # Recommendation
        has_contractors = cleaning or lift
        is_complete = total_records > 50
        
        status = "✅ KEEP (Most complete)" if (has_contractors and is_complete) else \
                 "⚠️  KEEP (Has contractors)" if has_contractors else \
                 "🗑️  DELETE (Incomplete)"
        
        print(f"  Status: {status}")
        print()
    
    print("="*100)
    print("💡 RECOMMENDATION:")
    print("="*100)
    
    if len(buildings) > 1:
        print("\nYou have duplicate buildings. Recommended action:")
        print("1. Keep the building with contractor names AND most records")
        print("2. Delete the others")
        print("\nI can generate a cleanup script for you.")
    else:
        print("\n✅ No duplicates found!")
    
    print("\n" + "="*100 + "\n")
    
    cursor.close()
    conn.close()

except Exception as e:
    print(f"\n❌ Error: {e}\n")

