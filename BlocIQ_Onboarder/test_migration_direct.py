#!/usr/bin/env python3
"""
Test Migration Script - Executes migration.sql against Supabase
Reports all errors for debugging
"""
import psycopg2
from pathlib import Path
import sys
import os

# Supabase connection details
SUPABASE_CONFIG = {
    'host': 'aws-0-eu-west-2.pooler.supabase.com',
    'database': 'postgres',
    'user': 'postgres.wgpxjmajjfutwxgbdqoo',
    'password': os.environ.get('SUPABASE_PASSWORD', '1Poppydog!234'),
    'port': 6543
}

def test_migration(migration_file: str):
    """Test migration SQL file"""
    print("=" * 60)
    print("Testing Migration SQL")
    print("=" * 60)

    # Read migration file
    migration_path = Path(migration_file)
    if not migration_path.exists():
        print(f"❌ Migration file not found: {migration_file}")
        return False

    with open(migration_path, 'r') as f:
        migration_sql = f.read()

    print(f"\n📄 Migration file: {migration_file}")
    print(f"   Size: {len(migration_sql)} bytes")
    print(f"   Lines: {migration_sql.count(chr(10))}")

    # Split into individual statements
    statements = [s.strip() for s in migration_sql.split(';') if s.strip() and not s.strip().startswith('--')]
    print(f"   Statements: {len(statements)}")

    # Connect to Supabase
    print(f"\n🔌 Connecting to Supabase...")
    try:
        conn = psycopg2.connect(**SUPABASE_CONFIG)
        cursor = conn.cursor()
        print(f"   ✅ Connected")
    except Exception as e:
        print(f"   ❌ Connection failed: {e}")
        return False

    # Execute statements one by one
    errors = []
    success_count = 0

    print(f"\n🚀 Executing statements...")
    for i, statement in enumerate(statements, 1):
        # Skip comments and empty statements
        if not statement or statement.startswith('--'):
            continue

        # Show progress for INSERT statements
        if 'INSERT INTO' in statement:
            table_name = statement.split('INSERT INTO')[1].split('(')[0].strip()
            if i % 50 == 0:
                print(f"   Progress: {i}/{len(statements)} statements...")

        try:
            cursor.execute(statement)
            conn.commit()
            success_count += 1
        except Exception as e:
            # Extract statement preview
            preview = statement[:100].replace('\n', ' ')
            errors.append({
                'statement_num': i,
                'preview': preview,
                'error': str(e)
            })
            # Rollback this statement
            conn.rollback()

    # Close connection
    cursor.close()
    conn.close()

    # Report results
    print(f"\n" + "=" * 60)
    print(f"RESULTS")
    print("=" * 60)
    print(f"✅ Successful: {success_count}/{len(statements)}")
    print(f"❌ Failed: {len(errors)}/{len(statements)}")

    if errors:
        print(f"\n" + "=" * 60)
        print(f"ERRORS ({len(errors)} total)")
        print("=" * 60)

        # Group errors by type
        error_types = {}
        for err in errors:
            error_msg = err['error']
            # Extract error type (e.g., "column X does not exist")
            if 'column' in error_msg and 'does not exist' in error_msg:
                # Extract column name
                parts = error_msg.split('"')
                if len(parts) >= 2:
                    col_name = parts[1]
                    error_type = f"column '{col_name}' does not exist"
                else:
                    error_type = "column does not exist"
            elif 'does not exist' in error_msg:
                error_type = "does not exist"
            elif 'duplicate key' in error_msg:
                error_type = "duplicate key violation"
            else:
                error_type = error_msg[:50]

            if error_type not in error_types:
                error_types[error_type] = []
            error_types[error_type].append(err)

        # Print grouped errors
        for error_type, errs in error_types.items():
            print(f"\n🔴 {error_type} ({len(errs)} occurrences)")
            # Show first 3 examples
            for err in errs[:3]:
                print(f"   Statement {err['statement_num']}: {err['preview']}...")
            if len(errs) > 3:
                print(f"   ... and {len(errs) - 3} more")

    return len(errors) == 0

if __name__ == "__main__":
    if len(sys.argv) > 1:
        migration_file = sys.argv[1]
    else:
        migration_file = "/Users/ellie/Desktop/BlocIQ_Output/migration.sql"

    success = test_migration(migration_file)
    sys.exit(0 if success else 1)
