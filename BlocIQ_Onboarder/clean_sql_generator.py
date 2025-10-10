"""
Clean SQL Generator - Generates migration SQL using actual Supabase schema only
"""
import json
from typing import Dict, List, Any
from datetime import datetime
from clean_schema_validator import CleanSchemaValidator

class CleanSQLGenerator:
    def __init__(self):
        self.validator = CleanSchemaValidator()
        self.sql_statements = []

    def generate_migration(self, extracted_data: Dict[str, List[Dict]],
                          building_name: str,
                          output_path: str) -> str:
        """
        Generate complete migration SQL from extracted data.
        All data is validated against actual Supabase schema.
        """
        self.sql_statements = []

        # Header
        self._add_header(building_name)

        # Extensions
        self._add_extensions()

        # Agency placeholder
        self._add_agency_placeholder()

        # Table name mappings (extractor → Supabase)
        self.table_mappings = {
            'maintenance_schedules': 'schedules',  # Map to enhanced schedules table
        }

        # Process each table's data
        table_order = [
            'buildings',
            'units',
            'leaseholders',
            'leases',
            'budgets',
            'building_documents',
            'assets',
            'compliance_assets',
            'major_works_projects',
            'building_insurance',
            'building_contractors',
            'maintenance_schedules'  # Will be mapped to 'schedules'
        ]

        for table in table_order:
            if table in extracted_data and extracted_data[table]:
                # Apply table name mapping
                target_table = self.table_mappings.get(table, table)
                self._generate_inserts_for_table(target_table, extracted_data[table], original_table=table)

        # Write to file
        sql_content = '\n'.join(self.sql_statements)
        with open(output_path, 'w') as f:
            f.write(sql_content)

        return sql_content

    def _add_header(self, building_name: str):
        """Add SQL file header"""
        timestamp = datetime.now().isoformat()
        self.sql_statements.append(f"""-- ============================================================
-- BlocIQ Onboarder - Clean Migration SQL
-- Building: {building_name}
-- Generated: {timestamp}
-- Schema: Validated against actual Supabase schema
-- ============================================================
""")

    def _add_extensions(self):
        """Add required PostgreSQL extensions"""
        self.sql_statements.append("""
-- =====================================
-- EXTENSIONS
-- =====================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
""")

    def _add_agency_placeholder(self):
        """Add agency INSERT with placeholder instructions"""
        self.sql_statements.append("""
-- =====================================
-- AGENCY SETUP
-- =====================================
-- INSTRUCTIONS: Replace AGENCY_ID_PLACEHOLDER and AGENCY_NAME_PLACEHOLDER below
-- with your actual agency UUID and name before running this migration.
--
-- Example:
--   AGENCY_ID_PLACEHOLDER   -> '11111111-1111-1111-1111-111111111111'
--   AGENCY_NAME_PLACEHOLDER -> 'BlocIQ'
--

INSERT INTO agencies (id, name, created_at)
VALUES ('AGENCY_ID_PLACEHOLDER', 'AGENCY_NAME_PLACEHOLDER', NOW())
ON CONFLICT (id) DO NOTHING;

""")

    def _generate_inserts_for_table(self, table_name: str, records: List[Dict], original_table: str = None):
        """Generate INSERT statements for a table"""
        if not records:
            return

        display_name = f"{table_name.upper()}" + (f" (from {original_table})" if original_table and original_table != table_name else "")

        self.sql_statements.append(f"""
-- =====================================
-- TABLE: {display_name}
-- =====================================
-- Records: {len(records)}
""")

        valid_count = 0
        skipped_count = 0

        for record in records:
            # Validate data against schema
            validated_record = self.validator.validate_data(table_name, record)

            if not validated_record:
                skipped_count += 1
                continue

            # Generate INSERT
            sql = self._generate_insert(table_name, validated_record)
            if sql:
                self.sql_statements.append(sql)
                valid_count += 1

        self.sql_statements.append(f"-- Inserted: {valid_count}, Skipped: {skipped_count}\n")

    def _generate_insert(self, table_name: str, data: Dict[str, Any]) -> str:
        """Generate a single INSERT statement"""
        if not data:
            return ""

        columns = list(data.keys())
        values = []

        for col in columns:
            value = data[col]
            values.append(self._format_value(value, table_name, col))

        columns_str = ', '.join(columns)
        values_str = ', '.join(values)

        return f"INSERT INTO {table_name} ({columns_str}) VALUES ({values_str});"

    def _format_value(self, value: Any, table_name: str, column_name: str) -> str:
        """Format a value for SQL"""
        if value is None:
            return 'NULL'

        col_type = self.validator.get_column_type(table_name, column_name)

        # UUID type
        if col_type == 'uuid':
            if isinstance(value, str):
                return f"'{value}'"
            return f"'{str(value)}'"

        # Array type
        if col_type == 'ARRAY':
            if isinstance(value, list):
                if not value:
                    return 'ARRAY[]::text[]'
                # Escape single quotes in array elements
                escaped_items = [item.replace("'", "''") for item in value]
                items_str = "', '".join(escaped_items)
                return f"ARRAY['{items_str}']"
            return 'ARRAY[]::text[]'

        # Boolean type
        if col_type == 'boolean':
            return 'TRUE' if value else 'FALSE'

        # Numeric types
        if col_type in ['integer', 'bigint', 'smallint', 'numeric', 'decimal', 'real', 'double precision']:
            if isinstance(value, (int, float)):
                return str(value)
            try:
                return str(float(value))
            except:
                return 'NULL'

        # Date/timestamp types
        if col_type in ['date', 'timestamp', 'timestamp with time zone', 'timestamp without time zone']:
            if isinstance(value, str):
                return f"'{value}'"
            return f"'{str(value)}'"

        # Text/JSON types (default)
        if isinstance(value, str):
            # Escape single quotes
            escaped = value.replace("'", "''")
            # Handle newlines
            escaped = escaped.replace('\n', ' ').replace('\r', ' ')
            return f"'{escaped}'"

        return f"'{str(value)}'"


# Convenience function
def generate_clean_migration(extracted_data: Dict, building_name: str, output_path: str):
    """Generate clean migration SQL"""
    generator = CleanSQLGenerator()
    return generator.generate_migration(extracted_data, building_name, output_path)
