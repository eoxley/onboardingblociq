#!/usr/bin/env python3
"""
Apply SQL directly to Supabase and show errors
Handles errors and provides fixes
"""

import sys
import psycopg2
from psycopg2 import sql
import re

# Supabase connection
DATABASE_URL = "postgresql://postgres.xqxaatvykmaaynqeoemy:1Poppydog!234@aws-0-us-east-1.pooler.supabase.com:5432/postgres"


def apply_sql_file(filepath: str):
    """Apply SQL file with error handling"""
    
    print(f"\n{'='*80}")
    print(f"📄 Applying: {filepath}")
    print(f"{'='*80}\n")
    
    # Read SQL
    with open(filepath, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    # Connect
    print("🔄 Connecting to Supabase...")
    
    try:
        conn = psycopg2.connect(DATABASE_URL)
        conn.autocommit = True  # Auto-commit each statement
        cursor = conn.cursor()
        print("✅ Connected!\n")
        
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return False
    
    # Split into individual statements
    # Handle both semicolon and GO separators
    statements = []
    current_stmt = []
    in_function = False
    
    for line in sql_content.split('\n'):
        # Track if we're in a function definition
        if 'CREATE FUNCTION' in line or 'CREATE OR REPLACE FUNCTION' in line or '$$' in line or '$function$' in line:
            in_function = not in_function
        
        # Skip comments and empty lines
        stripped = line.strip()
        if not stripped or stripped.startswith('--'):
            continue
        
        current_stmt.append(line)
        
        # End of statement (semicolon, but not in function)
        if stripped.endswith(';') and not in_function:
            stmt = '\n'.join(current_stmt)
            if stmt.strip():
                statements.append(stmt)
            current_stmt = []
    
    # Execute statements one by one
    total = len(statements)
    success_count = 0
    errors = []
    
    print(f"📊 Found {total} SQL statements to execute\n")
    
    for i, stmt in enumerate(statements, 1):
        # Get a preview of the statement
        preview = stmt.strip()[:100].replace('\n', ' ')
        
        try:
            cursor.execute(stmt)
            success_count += 1
            print(f"✅ [{i}/{total}] {preview}...")
            
        except psycopg2.Error as e:
            error_msg = str(e)
            
            # Handle common errors
            if 'already exists' in error_msg:
                print(f"⚠️  [{i}/{total}] SKIP (already exists): {preview}...")
                success_count += 1  # Count as success
            
            elif 'does not exist' in error_msg and 'table' in error_msg.lower():
                print(f"❌ [{i}/{total}] ERROR: {preview}...")
                print(f"   {error_msg}")
                errors.append({
                    'statement': preview,
                    'error': error_msg,
                    'fix': 'Create referenced table first'
                })
            
            elif 'column' in error_msg and 'does not exist' in error_msg:
                print(f"❌ [{i}/{total}] ERROR: {preview}...")
                print(f"   {error_msg}")
                errors.append({
                    'statement': preview,
                    'error': error_msg,
                    'fix': 'Add missing column'
                })
            
            else:
                print(f"❌ [{i}/{total}] ERROR: {preview}...")
                print(f"   {error_msg}")
                errors.append({
                    'statement': preview,
                    'error': error_msg,
                    'fix': 'See error message'
                })
    
    cursor.close()
    conn.close()
    
    # Summary
    print(f"\n{'='*80}")
    print(f"📊 SUMMARY")
    print(f"{'='*80}")
    print(f"✅ Successful: {success_count}/{total}")
    print(f"❌ Errors: {len(errors)}")
    
    if errors:
        print(f"\n🔧 ERRORS TO FIX:")
        for i, error in enumerate(errors, 1):
            print(f"\n{i}. {error['statement']}")
            print(f"   Error: {error['error']}")
            print(f"   Fix: {error['fix']}")
    else:
        print(f"\n🎉 All statements executed successfully!")
    
    return len(errors) == 0


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 apply_sql_direct.py <sql_file>")
        sys.exit(1)
    
    filepath = sys.argv[1]
    success = apply_sql_file(filepath)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()

