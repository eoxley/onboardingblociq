#!/usr/bin/env python3
"""Verify leases and clauses were loaded"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"
BUILDING_ID = '2667e33e-b493-499f-ae8d-2de07b7bb707'

print("\n" + "="*80)
print("🔍 VERIFYING LEASE DATA IN DATABASE")
print("="*80)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Check leases
    cursor.execute(f"SELECT COUNT(*) FROM leases WHERE building_id = '{BUILDING_ID}'")
    lease_count = cursor.fetchone()[0]
    print(f"\n✅ Leases: {lease_count}")
    
    if lease_count > 0:
        cursor.execute(f"""
            SELECT title_number, source_document, page_count 
            FROM leases 
            WHERE building_id = '{BUILDING_ID}'
            ORDER BY title_number
        """)
        for row in cursor.fetchall():
            print(f"   • {row[0]}: {row[1][:40]}... ({row[2]} pages)")
    
    # Check lease clauses
    cursor.execute(f"SELECT COUNT(*) FROM lease_clauses WHERE building_id = '{BUILDING_ID}'")
    clause_count = cursor.fetchone()[0]
    print(f"\n✅ Lease Clauses: {clause_count}")
    
    if clause_count > 0:
        cursor.execute(f"""
            SELECT clause_category, COUNT(*) 
            FROM lease_clauses 
            WHERE building_id = '{BUILDING_ID}'
            GROUP BY clause_category
            ORDER BY COUNT(*) DESC
        """)
        for row in cursor.fetchall():
            print(f"   • {row[0].title()}: {row[1]} clauses")
    
    # Check parties
    cursor.execute(f"""
        SELECT COUNT(*) FROM lease_parties lp 
        JOIN leases l ON lp.lease_id = l.id 
        WHERE l.building_id = '{BUILDING_ID}'
    """)
    party_count = cursor.fetchone()[0]
    print(f"\n✅ Lease Parties: {party_count}")
    
    # Check financial terms
    cursor.execute(f"""
        SELECT COUNT(*) FROM lease_financial_terms lft 
        JOIN leases l ON lft.lease_id = l.id 
        WHERE l.building_id = '{BUILDING_ID}'
    """)
    financial_count = cursor.fetchone()[0]
    print(f"✅ Lease Financial Terms: {financial_count}")
    
    # Show financial summary
    if financial_count > 0:
        cursor.execute(f"""
            SELECT SUM(ground_rent_current), SUM(service_charge_percentage)
            FROM lease_financial_terms lft 
            JOIN leases l ON lft.lease_id = l.id 
            WHERE l.building_id = '{BUILDING_ID}'
        """)
        gr, sc = cursor.fetchone()
        print(f"\n💰 Financial Summary:")
        print(f"   • Total Ground Rent: £{gr}/year")
        print(f"   • Total Service Charge %: {sc:.2f}%")
    
    total = lease_count + clause_count + party_count + financial_count
    
    print("\n" + "="*80)
    print(f"🎉 TOTAL LEASE RECORDS: {total}")
    print("="*80 + "\n")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"\n❌ Error: {e}")

