#!/usr/bin/env python3
"""
Export live Supabase schema to JSON snapshot.
Queries information_schema for columns, constraints, and indexes.
"""
import json
import os
import psycopg2
from psycopg2.extras import RealDictCursor

def export_schema():
    """Export schema from DATABASE_URL to schema_snapshot.json"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        raise ValueError("DATABASE_URL environment variable not set")

    conn = psycopg2.connect(database_url)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Get columns
    cur.execute("""
        SELECT table_name, column_name, data_type, is_nullable,
               udt_name, coalesce(column_default, '') as column_default
        FROM information_schema.columns
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position
    """)
    columns = [dict(row) for row in cur.fetchall()]

    # Get constraints
    cur.execute("""
        SELECT tc.table_name, tc.constraint_name, tc.constraint_type,
               array_agg(kcu.column_name ORDER BY kcu.ordinal_position) as columns
        FROM information_schema.table_constraints tc
        LEFT JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema = kcu.table_schema
        WHERE tc.table_schema = 'public'
        GROUP BY tc.table_name, tc.constraint_name, tc.constraint_type
    """)
    constraints = [dict(row) for row in cur.fetchall()]

    # Get indexes
    cur.execute("""
        SELECT
            t.relname as table_name,
            i.relname as index_name,
            am.amname as index_type,
            idx.indisunique as is_unique,
            pg_get_indexdef(idx.indexrelid) as indexdef
        FROM pg_index idx
        JOIN pg_class i ON i.oid = idx.indexrelid
        JOIN pg_class t ON t.oid = idx.indrelid
        JOIN pg_am am ON am.oid = i.relam
        JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = 'public'
    """)
    indexes = [dict(row) for row in cur.fetchall()]

    # Get views
    cur.execute("""
        SELECT table_name as view_name, view_definition
        FROM information_schema.views
        WHERE table_schema = 'public'
    """)
    views = [dict(row) for row in cur.fetchall()]

    schema = {
        'columns': columns,
        'constraints': constraints,
        'indexes': indexes,
        'views': views
    }

    cur.close()
    conn.close()

    with open('schema_snapshot.json', 'w') as f:
        json.dump(schema, f, indent=2, default=str)

    print(f"✅ Schema exported to schema_snapshot.json")
    print(f"   - {len(columns)} columns")
    print(f"   - {len(constraints)} constraints")
    print(f"   - {len(indexes)} indexes")
    print(f"   - {len(views)} views")

if __name__ == '__main__':
    export_schema()
