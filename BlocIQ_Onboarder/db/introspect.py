"""
BlocIQ Onboarder - Database Schema Introspection
Queries Supabase to discover existing schema and generates migration suggestions
"""

import os
from typing import Dict, List, Set
from datetime import datetime


# Target schema definition for all tables
TARGET_SCHEMA = {
    'compliance_assets': {
        'inspection_contractor': 'TEXT',
        'inspection_date': 'DATE',
        'reinspection_date': 'DATE',
        'outcome': 'TEXT',
        'compliance_status': 'TEXT',
        'source_document_id': 'UUID REFERENCES building_documents(id)'
    },
    'insurance_policies': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'insurer': 'TEXT',
        'broker': 'TEXT',
        'policy_number': 'TEXT',
        'cover_type': 'TEXT',
        'sum_insured': 'NUMERIC',
        'reinstatement_value': 'NUMERIC',
        'valuation_date': 'DATE',
        'start_date': 'DATE',
        'end_date': 'DATE',
        'excess_json': 'JSONB',
        'endorsements': 'TEXT',
        'conditions': 'TEXT',
        'claims_json': 'JSONB',
        'evidence_url': 'TEXT',
        'policy_status': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'contracts': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'contractor_name': 'TEXT',
        'service_type': 'TEXT',
        'start_date': 'DATE',
        'end_date': 'DATE',
        'renewal_date': 'DATE',
        'frequency': 'TEXT',
        'value': 'NUMERIC',
        'contract_status': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'utilities': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'supplier': 'TEXT',
        'utility_type': 'TEXT',
        'account_number': 'TEXT',
        'start_date': 'DATE',
        'end_date': 'DATE',
        'tariff': 'TEXT',
        'contract_status': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'meetings': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'meeting_type': 'TEXT',
        'meeting_date': 'DATE',
        'attendees': 'TEXT',
        'key_decisions': 'TEXT',
        'minutes_url': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'client_money_snapshots': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'snapshot_date': 'DATE',
        'bank_name': 'TEXT',
        'account_identifier': 'TEXT',
        'balance': 'NUMERIC',
        'uncommitted_funds': 'NUMERIC',
        'arrears_total': 'NUMERIC',
        'notes': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'building_documents': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'file_name': 'TEXT NOT NULL',
        'storage_path': 'TEXT',
        'category': 'TEXT',
        'document_type': 'TEXT',
        'ocr_text': 'TEXT',
        'metadata': 'JSONB',
        'created_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'contractors': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'company_name': 'TEXT NOT NULL',
        'contact_person': 'TEXT',
        'email': 'TEXT',
        'phone': 'TEXT',
        'address': 'TEXT',
        'specialization': 'TEXT',
        'accreditations': 'TEXT[]',
        'insurance_expiry': 'DATE',
        'vat_number': 'TEXT',
        'notes': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'building_contractors': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'contractor_id': 'UUID NOT NULL REFERENCES contractors(id) ON DELETE CASCADE',
        'relationship_type': 'TEXT',
        'is_preferred': 'BOOLEAN DEFAULT false',
        'notes': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'maintenance_schedules': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'contract_id': 'UUID REFERENCES contracts(id) ON DELETE SET NULL',
        'contractor_id': 'UUID REFERENCES contractors(id) ON DELETE SET NULL',
        'service_type': 'TEXT NOT NULL',
        'description': 'TEXT',
        'frequency': 'TEXT',
        'frequency_interval': 'INTERVAL',
        'next_due_date': 'DATE',
        'last_completed_date': 'DATE',
        'estimated_duration': 'INTERVAL',
        'cost_estimate': 'NUMERIC',
        'priority': 'TEXT',
        'status': 'TEXT',
        'notes': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    },
    'assets': {
        'id': 'UUID PRIMARY KEY DEFAULT gen_random_uuid()',
        'building_id': 'UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE',
        'contractor_id': 'UUID REFERENCES contractors(id) ON DELETE SET NULL',
        'compliance_asset_id': 'UUID REFERENCES compliance_assets(id) ON DELETE SET NULL',
        'asset_type': 'TEXT NOT NULL',
        'asset_name': 'TEXT',
        'location_description': 'TEXT',
        'manufacturer': 'TEXT',
        'model_number': 'TEXT',
        'serial_number': 'TEXT',
        'installation_date': 'DATE',
        'service_frequency': 'TEXT',
        'last_service_date': 'DATE',
        'next_due_date': 'DATE',
        'condition_rating': 'TEXT',
        'compliance_category': 'TEXT',
        'linked_documents': 'TEXT[]',
        'notes': 'TEXT',
        'created_at': 'TIMESTAMPTZ DEFAULT now()',
        'updated_at': 'TIMESTAMPTZ DEFAULT now()'
    }
}


class SchemaIntrospector:
    """Introspects Supabase schema and generates migration suggestions"""

    def __init__(self, supabase_client=None):
        """
        Initialize introspector

        Args:
            supabase_client: Supabase client instance (optional)
        """
        self.supabase = supabase_client
        self.existing_schema = {}
        self.suggestions = []

    def introspect(self) -> Dict:
        """
        Query Supabase to discover existing schema

        Returns:
            Dict with existing schema structure
        """
        if not self.supabase:
            print("  ⚠️  No Supabase client provided - will generate full schema")
            return {}

        try:
            # Query information_schema to get existing tables and columns
            for table_name in TARGET_SCHEMA.keys():
                columns = self._get_table_columns(table_name)
                if columns:
                    self.existing_schema[table_name] = columns
                    print(f"  ✓ Found existing table: {table_name} ({len(columns)} columns)")

            return self.existing_schema

        except Exception as e:
            print(f"  ⚠️  Error introspecting schema: {e}")
            return {}

    def _get_table_columns(self, table_name: str) -> Dict[str, str]:
        """
        Query columns for a specific table

        Args:
            table_name: Name of the table

        Returns:
            Dict mapping column names to data types
        """
        try:
            # Use Supabase's PostgreSQL query capabilities
            query = f"""
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns
            WHERE table_name = '{table_name}'
            AND table_schema = 'public'
            ORDER BY ordinal_position;
            """

            result = self.supabase.rpc('exec_sql', {'query': query}).execute()

            columns = {}
            if result.data:
                for row in result.data:
                    col_name = row['column_name']
                    col_type = row['data_type'].upper()
                    columns[col_name] = col_type

            return columns

        except Exception as e:
            # Table doesn't exist or error querying
            return {}

    def generate_migration_suggestions(self, output_file: str = 'out/schema_suggestions.sql'):
        """
        Generate SQL migration suggestions file

        Args:
            output_file: Path to output SQL file
        """
        sql_statements = []
        sql_statements.append("-- ============================================================")
        sql_statements.append("-- BlocIQ Onboarder - Schema Migration Suggestions")
        sql_statements.append(f"-- Generated: {datetime.now().isoformat()}")
        sql_statements.append("-- ============================================================")
        sql_statements.append("-- IMPORTANT: Review carefully before executing!")
        sql_statements.append("-- This file contains suggestions based on schema introspection.")
        sql_statements.append("-- ============================================================\n")

        # Process each target table
        for table_name, target_columns in TARGET_SCHEMA.items():
            existing_columns = self.existing_schema.get(table_name, {})

            if not existing_columns:
                # Table doesn't exist - generate CREATE TABLE
                sql_statements.append(f"\n-- Create new table: {table_name}")
                sql_statements.append(self._generate_create_table(table_name, target_columns))
                self.suggestions.append(f"CREATE TABLE {table_name}")
            else:
                # Table exists - check for missing columns
                missing_columns = set(target_columns.keys()) - set(existing_columns.keys())

                if missing_columns:
                    sql_statements.append(f"\n-- Add missing columns to: {table_name}")
                    for col_name in sorted(missing_columns):
                        col_def = target_columns[col_name]
                        # Skip PRIMARY KEY constraint in ALTER (already exists)
                        if 'PRIMARY KEY' in col_def:
                            continue
                        sql_statements.append(f"ALTER TABLE {table_name} ADD COLUMN {col_name} {col_def};")
                        self.suggestions.append(f"ALTER TABLE {table_name} ADD COLUMN {col_name}")

        # Write to file
        sql_content = '\n'.join(sql_statements)

        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_file), exist_ok=True)

        with open(output_file, 'w') as f:
            f.write(sql_content)

        print(f"\n  ✅ Schema suggestions written to: {output_file}")
        print(f"     • {len(self.suggestions)} suggestion(s) generated")

        # Print summary
        create_tables = [s for s in self.suggestions if s.startswith('CREATE TABLE')]
        alter_tables = [s for s in self.suggestions if s.startswith('ALTER TABLE')]

        if create_tables:
            print(f"     • {len(create_tables)} new table(s) to create")
        if alter_tables:
            print(f"     • {len(alter_tables)} column(s) to add")

        return output_file

    def _generate_create_table(self, table_name: str, columns: Dict[str, str]) -> str:
        """
        Generate CREATE TABLE statement

        Args:
            table_name: Name of the table
            columns: Dict of column definitions

        Returns:
            SQL CREATE TABLE statement
        """
        lines = [f"CREATE TABLE IF NOT EXISTS {table_name} ("]

        col_lines = []
        for col_name, col_def in columns.items():
            col_lines.append(f"  {col_name} {col_def}")

        lines.append(',\n'.join(col_lines))
        lines.append(");")

        # Add indexes for foreign keys and common lookup fields
        index_statements = []
        if 'building_id' in columns:
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_building_id ON {table_name}(building_id);")

        if table_name == 'insurance_policies':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_policy_number ON {table_name}(policy_number);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_dates ON {table_name}(start_date, end_date);")
        elif table_name == 'contracts':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_service_type ON {table_name}(service_type);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_renewal ON {table_name}(renewal_date);")
        elif table_name == 'utilities':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_utility_type ON {table_name}(utility_type);")
        elif table_name == 'meetings':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_date ON {table_name}(meeting_date);")
        elif table_name == 'client_money_snapshots':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_snapshot_date ON {table_name}(snapshot_date);")
        elif table_name == 'building_documents':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_category ON {table_name}(category);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_doc_type ON {table_name}(document_type);")
        elif table_name == 'contractors':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_company_name ON {table_name}(company_name);")
        elif table_name == 'maintenance_schedules':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_next_due ON {table_name}(next_due_date);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_status ON {table_name}(status);")
        elif table_name == 'assets':
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_asset_type ON {table_name}(asset_type);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_next_due ON {table_name}(next_due_date);")
            index_statements.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_compliance ON {table_name}(compliance_category);")

        if index_statements:
            lines.append('\n' + '\n'.join(index_statements))

        return '\n'.join(lines)

    def get_summary(self) -> Dict:
        """
        Get introspection summary

        Returns:
            Dict with summary statistics
        """
        return {
            'existing_tables': len(self.existing_schema),
            'target_tables': len(TARGET_SCHEMA),
            'suggestions_count': len(self.suggestions),
            'tables_to_create': len([s for s in self.suggestions if 'CREATE TABLE' in s]),
            'columns_to_add': len([s for s in self.suggestions if 'ALTER TABLE' in s])
        }


def introspect_and_generate(supabase_client=None, output_file: str = 'out/schema_suggestions.sql') -> str:
    """
    Convenience function to introspect schema and generate suggestions

    Args:
        supabase_client: Supabase client instance (optional)
        output_file: Path to output SQL file

    Returns:
        Path to generated SQL file
    """
    print("\n🔍 Introspecting database schema...")

    introspector = SchemaIntrospector(supabase_client)
    introspector.introspect()
    sql_file = introspector.generate_migration_suggestions(output_file)

    summary = introspector.get_summary()
    print(f"\n  📊 Introspection Summary:")
    print(f"     • Existing tables: {summary['existing_tables']}/{summary['target_tables']}")
    print(f"     • Tables to create: {summary['tables_to_create']}")
    print(f"     • Columns to add: {summary['columns_to_add']}")

    return sql_file


if __name__ == '__main__':
    # Standalone execution for testing
    from dotenv import load_dotenv
    from supabase import create_client
    from pathlib import Path

    # Load environment
    env_path = Path(__file__).parent.parent / '.env.local'
    load_dotenv(env_path)

    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

    if supabase_url and supabase_key:
        supabase = create_client(supabase_url, supabase_key)
        introspect_and_generate(supabase)
    else:
        print("⚠️  No Supabase credentials - generating full schema")
        introspect_and_generate()
