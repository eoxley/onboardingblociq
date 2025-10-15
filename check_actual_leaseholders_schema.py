#!/usr/bin/env python3
import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n🔍 Checking leaseholders table schema...\n")

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Get leaseholders columns
    cursor.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns 
        WHERE table_name = 'leaseholders'
        ORDER BY ordinal_position
    """)
    
    print("Leaseholders table columns:")
    for row in cursor.fetchall():
        print(f"  • {row[0]}: {row[1]} (nullable: {row[2]})")
    
    # Get units columns
    print("\nUnits table columns:")
    cursor.execute("""
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns 
        WHERE table_name = 'units'
        ORDER BY ordinal_position
    """)
    
    for row in cursor.fetchall():
        print(f"  • {row[0]}: {row[1]} (nullable: {row[2]})")
    
    # Check for foreign key
    print("\nForeign keys:")
    cursor.execute("""
        SELECT
            tc.table_name, 
            kcu.column_name, 
            ccu.table_name AS foreign_table_name,
            ccu.column_name AS foreign_column_name 
        FROM information_schema.table_constraints AS tc 
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY' 
        AND tc.table_name IN ('leaseholders', 'units')
    """)
    
    for row in cursor.fetchall():
        print(f"  • {row[0]}.{row[1]} → {row[2]}.{row[3]}")
    
    cursor.close()
    conn.close()

except Exception as e:
    print(f"❌ Error: {e}")

