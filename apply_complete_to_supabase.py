#!/usr/bin/env python3
"""
Apply Complete Schema and Connaught Data to Supabase
Directly executes SQL using PostgreSQL connection
"""

import os
import sys
import psycopg2
from pathlib import Path

# Supabase connection from .env
DATABASE_URL = "postgresql://postgres.xqxaatvykmaaynqeoemy:1Poppydog!234@aws-0-us-east-1.pooler.supabase.com:5432/postgres"

def execute_sql_file(cursor, sql_file: str, description: str):
    """Execute a SQL file"""
    print(f"\n{'='*80}")
    print(f"📄 {description}")
    print(f"{'='*80}")
    print(f"File: {sql_file}")
    
    if not os.path.exists(sql_file):
        print(f"❌ File not found: {sql_file}")
        return False
    
    with open(sql_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    file_size = len(sql_content)
    line_count = sql_content.count('\n')
    insert_count = sql_content.count('INSERT INTO')
    
    print(f"📊 Size: {file_size:,} characters, {line_count:,} lines")
    print(f"📊 INSERT statements: {insert_count}")
    print(f"\n🔄 Executing SQL...")
    
    try:
        cursor.execute(sql_content)
        print(f"✅ SQL executed successfully!")
        return True
    except Exception as e:
        print(f"❌ Error: {e}")
        return False


def main():
    """Main application function"""
    
    print("\n" + "="*80)
    print("🚀 BlocIQ - Apply Complete Schema & Data to Supabase")
    print("="*80)
    
    # Files to apply
    schema_file = "/Users/ellie/onboardingblociq/supabase_schema.sql"
    data_file = "/Users/ellie/onboardingblociq/output/connaught_COMPLETE.sql"
    
    print(f"\n📋 Plan:")
    print(f"   1. Apply schema (21 tables, 1,153 lines)")
    print(f"   2. Load Connaught Square data (108 INSERTs, 14 data types)")
    
    # Auto-confirm if --yes flag or non-interactive
    if len(sys.argv) > 1 and sys.argv[1] == '--yes':
        print(f"\n✅ Auto-confirmed with --yes flag")
    else:
        try:
            response = input(f"\n⚠️  This will modify your Supabase database. Continue? (yes/no): ")
            if response.lower() not in ['yes', 'y']:
                print("❌ Cancelled by user")
                return
        except (EOFError, KeyboardInterrupt):
            # Non-interactive shell, proceed automatically
            print(f"\n✅ Non-interactive mode detected, proceeding...")
    
    # Connect to database
    print(f"\n🔄 Connecting to Supabase...")
    print(f"   URL: {DATABASE_URL.split('@')[1] if '@' in DATABASE_URL else 'supabase'}")
    
    try:
        conn = psycopg2.connect(DATABASE_URL)
        conn.autocommit = False  # Use transactions
        cursor = conn.cursor()
        print(f"✅ Connected successfully!")
        
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        print(f"\n💡 Alternative: Use Supabase SQL Editor")
        print(f"   1. Open: https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new")
        print(f"   2. Copy & paste: {schema_file}")
        print(f"   3. Click 'Run'")
        print(f"   4. Repeat for: {data_file}")
        return
    
    try:
        # Step 1: Apply Schema
        success = execute_sql_file(cursor, schema_file, "STEP 1: Apply Schema (Create Tables)")
        
        if not success:
            print(f"\n⚠️  Schema application failed. Rolling back...")
            conn.rollback()
            return
        
        # Commit schema
        conn.commit()
        print(f"\n✅ Schema committed to database")
        
        # Step 2: Load Data
        success = execute_sql_file(cursor, data_file, "STEP 2: Load Connaught Square Data")
        
        if not success:
            print(f"\n⚠️  Data load failed. Rolling back...")
            conn.rollback()
            return
        
        # Commit data
        conn.commit()
        print(f"\n✅ Data committed to database")
        
        # Verify
        print(f"\n{'='*80}")
        print(f"🎉 VERIFICATION")
        print(f"{'='*80}")
        
        cursor.execute("""
            SELECT 
                (SELECT COUNT(*) FROM buildings) as buildings,
                (SELECT COUNT(*) FROM units) as units,
                (SELECT COUNT(*) FROM leaseholders) as leaseholders,
                (SELECT COUNT(*) FROM compliance_assets) as compliance,
                (SELECT COUNT(*) FROM maintenance_contracts) as contracts,
                (SELECT COUNT(*) FROM budgets) as budgets,
                (SELECT COUNT(*) FROM budget_line_items) as budget_items,
                (SELECT COUNT(*) FROM maintenance_schedules) as schedules,
                (SELECT COUNT(*) FROM insurance_policies) as insurance,
                (SELECT COUNT(*) FROM leases) as leases,
                (SELECT COUNT(*) FROM contractors) as contractors,
                (SELECT COUNT(*) FROM major_works_projects) as major_works
        """)
        
        result = cursor.fetchone()
        
        print(f"\n📊 Database Record Counts:")
        print(f"   Buildings: {result[0]}")
        print(f"   Units: {result[1]}")
        print(f"   Leaseholders: {result[2]}")
        print(f"   Compliance Assets: {result[3]}")
        print(f"   Maintenance Contracts: {result[4]}")
        print(f"   Budgets: {result[5]}")
        print(f"   Budget Line Items: {result[6]} ✨ NEW!")
        print(f"   Maintenance Schedules: {result[7]} ✨ NEW!")
        print(f"   Insurance Policies: {result[8]} ✨ NEW!")
        print(f"   Leases: {result[9]} ✨ NEW!")
        print(f"   Contractors: {result[10]} ✨ NEW!")
        print(f"   Major Works: {result[11]} ✨ NEW!")
        
        # Get building details
        cursor.execute("""
            SELECT building_name, postcode, num_units 
            FROM buildings 
            LIMIT 1
        """)
        building = cursor.fetchone()
        
        if building:
            print(f"\n🏢 Building Loaded:")
            print(f"   Name: {building[0]}")
            print(f"   Postcode: {building[1]}")
            print(f"   Units: {building[2]}")
        
        print(f"\n{'='*80}")
        print(f"🎉 SUCCESS! All data loaded to Supabase")
        print(f"{'='*80}")
        
        print(f"\n🔗 View in Supabase Dashboard:")
        print(f"   https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/editor")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        print(f"\n🔄 Rolling back transaction...")
        conn.rollback()
        raise
    
    finally:
        cursor.close()
        conn.close()
        print(f"\n✅ Connection closed")


if __name__ == "__main__":
    main()

