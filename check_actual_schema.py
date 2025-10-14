#!/usr/bin/env python3
"""
Check what actually exists in the Supabase database
"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n" + "="*100)
print("🔍 CHECKING ACTUAL DATABASE SCHEMA")
print("="*100)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Get all tables
    cursor.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name
    """)
    
    tables = cursor.fetchall()
    
    print(f"\n📊 Tables in database: {len(tables)}\n")
    
    for table in tables:
        table_name = table[0]
        
        # Get column count
        cursor.execute("""
            SELECT COUNT(*) 
            FROM information_schema.columns 
            WHERE table_name = %s
        """, (table_name,))
        col_count = cursor.fetchone()[0]
        
        # Get row count
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            row_count = cursor.fetchone()[0]
            status = f"{row_count} records" if row_count > 0 else "empty"
        except:
            status = "error"
        
        print(f"  • {table_name:<40} {col_count} columns, {status}")
    
    # Show what our building record has
    print("\n" + "="*100)
    print("🏢 BUILDING RECORD")
    print("="*100)
    
    cursor.execute("SELECT * FROM buildings WHERE building_name LIKE '%Connaught%' LIMIT 1")
    building = cursor.fetchone()
    
    if building:
        cursor.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name = 'buildings'
            ORDER BY ordinal_position
        """)
        cols = [c[0] for c in cursor.fetchall()]
        
        print("\nConnaught Square building data:")
        for col, val in zip(cols[:15], building[:15]):  # First 15 fields
            print(f"  {col}: {val}")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"\n❌ Error: {e}")

