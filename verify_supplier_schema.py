#!/usr/bin/env python3
"""Verify supplier onboarding schema was created"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n" + "="*80)
print("🔍 VERIFYING SUPPLIER ONBOARDING SCHEMA")
print("="*80)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Check if suppliers table exists
    cursor.execute("""
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_name = 'suppliers'
    """)
    
    if cursor.fetchone()[0] > 0:
        print("\n✅ suppliers table created!")
        
        # Get column count
        cursor.execute("""
            SELECT COUNT(*) 
            FROM information_schema.columns 
            WHERE table_name = 'suppliers'
        """)
        col_count = cursor.fetchone()[0]
        print(f"   • {col_count} columns")
        
        # Show key columns
        cursor.execute("""
            SELECT column_name, data_type
            FROM information_schema.columns 
            WHERE table_name = 'suppliers'
            AND column_name IN (
                'contractor_name', 'email', 'telephone', 'postcode',
                'services_provided', 'bank_sort_code', 'pli_expiry_date',
                'has_audited_accounts', 'has_certificate_of_incorporation',
                'onboarding_status'
            )
            ORDER BY ordinal_position
        """)
        
        print(f"\n   Key fields:")
        for row in cursor.fetchall():
            print(f"   • {row[0]}: {row[1]}")
    else:
        print("\n❌ suppliers table NOT found")
    
    # Check supplier_documents table
    cursor.execute("""
        SELECT COUNT(*) 
        FROM information_schema.tables 
        WHERE table_name = 'supplier_documents'
    """)
    
    if cursor.fetchone()[0] > 0:
        print("\n✅ supplier_documents table created!")
        
        cursor.execute("""
            SELECT COUNT(*) 
            FROM information_schema.columns 
            WHERE table_name = 'supplier_documents'
        """)
        col_count = cursor.fetchone()[0]
        print(f"   • {col_count} columns")
    else:
        print("\n❌ supplier_documents table NOT found")
    
    # Check views
    cursor.execute("""
        SELECT COUNT(*) 
        FROM information_schema.views 
        WHERE table_name IN ('vw_suppliers_documents_expiring', 'vw_approved_suppliers')
    """)
    
    view_count = cursor.fetchone()[0]
    print(f"\n✅ Views created: {view_count}")
    
    # Check record count
    cursor.execute("SELECT COUNT(*) FROM suppliers")
    supplier_count = cursor.fetchone()[0]
    
    print(f"\n📊 Current suppliers in database: {supplier_count}")
    
    print("\n" + "="*80)
    print("✅ SUPPLIER ONBOARDING SCHEMA IS LIVE!")
    print("="*80 + "\n")
    
    cursor.close()
    conn.close()

except Exception as e:
    print(f"\n❌ Error: {e}\n")

