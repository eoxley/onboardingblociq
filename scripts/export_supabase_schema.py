#!/usr/bin/env python3
"""
Export the complete current Supabase schema
"""
import pg8000
from dotenv import load_dotenv
import os
import json

load_dotenv()

USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = int(os.getenv("port"))
DBNAME = os.getenv("dbname")

print("=" * 60)
print("Supabase Schema Exporter")
print("=" * 60)

try:
    print(f"\n🔌 Connecting to {HOST}...")
    connection = pg8000.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        port=PORT,
        database=DBNAME
    )
    print("✅ Connected!")

    cursor = connection.cursor()

    # Get all tables in public schema
    cursor.execute("""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name;
    """)

    tables = [row[0] for row in cursor.fetchall()]
    print(f"\n📋 Found {len(tables)} tables:")
    for table in tables:
        print(f"  - {table}")

    schema = {}

    # For each table, get columns, data types, and constraints
    for table in tables:
        print(f"\n🔍 Analyzing {table}...")

        # Get columns
        cursor.execute("""
            SELECT
                column_name,
                data_type,
                character_maximum_length,
                is_nullable,
                column_default
            FROM information_schema.columns
            WHERE table_schema = 'public'
            AND table_name = %s
            ORDER BY ordinal_position;
        """, (table,))

        columns = []
        for row in cursor.fetchall():
            columns.append({
                'name': row[0],
                'type': row[1],
                'max_length': row[2],
                'nullable': row[3] == 'YES',
                'default': row[4]
            })

        # Get constraints
        cursor.execute("""
            SELECT
                conname as constraint_name,
                pg_get_constraintdef(oid) as definition
            FROM pg_constraint
            WHERE conrelid = %s::regclass;
        """, (table,))

        constraints = []
        for row in cursor.fetchall():
            constraints.append({
                'name': row[0],
                'definition': row[1]
            })

        # Get indexes
        cursor.execute("""
            SELECT
                indexname,
                indexdef
            FROM pg_indexes
            WHERE schemaname = 'public'
            AND tablename = %s;
        """, (table,))

        indexes = []
        for row in cursor.fetchall():
            indexes.append({
                'name': row[0],
                'definition': row[1]
            })

        schema[table] = {
            'columns': columns,
            'constraints': constraints,
            'indexes': indexes
        }

        print(f"  ✓ {len(columns)} columns, {len(constraints)} constraints, {len(indexes)} indexes")

    # Save to JSON file
    output_file = 'supabase_current_schema.json'
    with open(output_file, 'w') as f:
        json.dump(schema, f, indent=2)

    print(f"\n✅ Schema exported to: {output_file}")

    # Also create a readable text version
    output_text = 'supabase_current_schema.txt'
    with open(output_text, 'w') as f:
        f.write("SUPABASE CURRENT SCHEMA\n")
        f.write("=" * 60 + "\n\n")

        for table_name, table_info in schema.items():
            f.write(f"\nTABLE: {table_name}\n")
            f.write("-" * 60 + "\n")
            f.write("Columns:\n")
            for col in table_info['columns']:
                nullable = "NULL" if col['nullable'] else "NOT NULL"
                f.write(f"  - {col['name']}: {col['type']} {nullable}")
                if col['default']:
                    f.write(f" DEFAULT {col['default']}")
                f.write("\n")

            if table_info['constraints']:
                f.write("\nConstraints:\n")
                for constraint in table_info['constraints']:
                    f.write(f"  - {constraint['name']}: {constraint['definition']}\n")

            if table_info['indexes']:
                f.write("\nIndexes:\n")
                for index in table_info['indexes']:
                    f.write(f"  - {index['name']}\n")

            f.write("\n")

    print(f"✅ Readable schema exported to: {output_text}")

    cursor.close()
    connection.close()
    print("\n✅ Export complete!")

except Exception as e:
    print(f"\n❌ Error: {e}")
    import traceback
    traceback.print_exc()
