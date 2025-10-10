#!/usr/bin/env python3
"""
Execute migration SQL directly against Supabase
"""

import os
import sys
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

def main():
    sql_file = sys.argv[1] if len(sys.argv) > 1 else '/Users/ellie/Desktop/BlocIQ_Output/migration_READY_TO_RUN.sql'
    
    print(f"🔌 Connecting to Supabase...")
    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')
    
    if not supabase_url or not supabase_key:
        print("❌ Missing Supabase credentials")
        return 1
    
    supabase = create_client(supabase_url, supabase_key)
    print(f"✅ Connected to {supabase_url}")
    
    print(f"\n📖 Reading SQL file: {sql_file}")
    with open(sql_file, 'r') as f:
        sql = f.read()
    
    print(f"   Size: {len(sql)} characters")
    print(f"   Lines: {sql.count(chr(10))}")
    
    print(f"\n🚀 Executing SQL migration...")
    
    try:
        # Execute via RPC
        result = supabase.rpc('exec_sql', {'query': sql}).execute()
        print(f"\n✅ SUCCESS! Migration executed")
        print(f"   Result: {result}")
        return 0
        
    except Exception as e:
        error_msg = str(e)
        print(f"\n❌ Error executing SQL:")
        print(f"   {error_msg}")
        
        # Parse error for details
        if 'does not exist' in error_msg:
            import re
            col_match = re.search(r'column "([^"]+)"', error_msg)
            table_match = re.search(r'relation "([^"]+)"', error_msg)
            if col_match and table_match:
                print(f"\n🔍 Schema mismatch:")
                print(f"   Table: {table_match.group(1)}")
                print(f"   Missing column: {col_match.group(1)}")
        
        return 1

if __name__ == '__main__':
    sys.exit(main())
