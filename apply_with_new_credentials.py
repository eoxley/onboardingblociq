#!/usr/bin/env python3
"""
Apply SQL directly to Supabase with correct credentials
"""

import sys
import psycopg2

# NEW Supabase credentials
SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"
DB_PASSWORD = "GizmoFrank2025!"

# Try different connection formats
DATABASE_URLS = [
    f"postgresql://postgres.aewixchhykxyhqjvqoek:{DB_PASSWORD}@aws-0-us-east-1.pooler.supabase.com:5432/postgres",
    f"postgresql://postgres:{DB_PASSWORD}@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres",
    f"postgresql://postgres.aewixchhykxyhqjvqoek:{DB_PASSWORD}@aws-0-us-east-1.pooler.supabase.com:6543/postgres",
]

def apply_sql(filepath):
    """Apply SQL file to Supabase"""
    
    print(f"\n{'='*80}")
    print(f"🚀 Applying SQL: {filepath}")
    print(f"   Project: aewixchhykxyhqjvqoek")
    print(f"{'='*80}\n")
    
    # Read SQL
    with open(filepath, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    print(f"📊 SQL Size: {len(sql_content):,} chars, {sql_content.count('INSERT'):,} INSERTs")
    
    # Try each connection string
    conn = None
    for i, db_url in enumerate(DATABASE_URLS, 1):
        print(f"🔄 Trying connection {i}/3...")
        try:
            conn = psycopg2.connect(db_url)
            conn.autocommit = False
            print(f"✅ Connected!\n")
            break
        except Exception as e:
            print(f"   ❌ Failed: {str(e)[:80]}")
            if i == len(DATABASE_URLS):
                print(f"\n❌ All connection attempts failed")
                return False
    
    if conn:
        try:
            cursor = conn.cursor()
            
            print(f"🔄 Executing SQL...")
            cursor.execute(sql_content)
            conn.commit()
            
            print(f"✅ SQL executed successfully!")
            
            cursor.close()
            conn.close()
            
            return True
            
        except Exception as e:
            print(f"❌ Error: {e}")
            if 'conn' in locals():
                conn.rollback()
            return False
    
    return False


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python3 apply_with_new_credentials.py <sql_file>")
        sys.exit(1)
    
    success = apply_sql(sys.argv[1])
    sys.exit(0 if success else 1)

