"""
Schema Validator - Validates data against actual Supabase schema
Ensures all NOT NULL constraints are satisfied and column names match
"""

import json
from typing import Dict, Any, List, Optional

# Load actual Supabase schema
import os
schema_path = os.path.join(os.path.dirname(__file__), '..', 'supabase_current_schema.json')
try:
    with open(schema_path, 'r') as f:
        schema_data = json.load(f)
    # Convert to simple dict format: {table: {col: type}}
    ACTUAL_SCHEMA = {}
    for table_name, table_info in schema_data.items():
        ACTUAL_SCHEMA[table_name] = {col['name']: col['type'] for col in table_info['columns']}
    print(f"✓ Loaded actual Supabase schema for {len(ACTUAL_SCHEMA)} tables")
except FileNotFoundError:
    print(f"⚠️  Schema file not found at {schema_path}, using fallback")
    ACTUAL_SCHEMA = {}


class SchemaValidator:
    """Validates and transforms data to match actual Supabase schema"""

    def __init__(self):
        self.schema = ACTUAL_SCHEMA

    def validate_and_transform(self, table: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validate data against schema and transform to match exact schema

        Args:
            table: Table name
            data: Dictionary of data to validate

        Returns:
            Transformed and validated data
        """
        if table not in self.schema:
            # Table not in schema, return data as-is
            return data

        table_schema = self.schema[table]
        validated = {}

        # Apply column mappings
        data = self._apply_column_mappings(table, data)

        # Process each field in the data
        for col_name, value in data.items():
            if col_name not in table_schema:
                # Column doesn't exist in schema, skip it
                continue

            col_schema = table_schema[col_name]

            # Handle NULL values
            if value is None:
                if 'NOT NULL' in col_schema and 'DEFAULT' not in col_schema:
                    # NOT NULL column without default - need to provide value
                    value = self._get_default_value_for_type(col_schema)
                elif 'DEFAULT' in col_schema:
                    # Has default, can skip
                    continue
                else:
                    # Nullable, keep NULL
                    validated[col_name] = None
                    continue

            validated[col_name] = value

        # Check for missing NOT NULL columns
        for col_name, col_schema in table_schema.items():
            if col_name not in validated and 'NOT NULL' in col_schema and 'DEFAULT' not in col_schema:
                # Missing NOT NULL column without default
                default = self._get_table_specific_default(table, col_name)
                if default is not None:
                    validated[col_name] = default

        return validated

    def _apply_column_mappings(self, table: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Apply table-specific column name mappings

        This handles cases where the generator uses different column names than the schema
        """
        # Mappings: FROM extracted data column TO actual schema column
        mappings = {
            'major_works_projects': {
                'name': 'project_name',  # Schema has 'project_name' not 'name'
            },
            'building_documents': {
                'filename': 'file_name',  # Legacy alias
                'file_path': 'storage_path',  # Schema has 'storage_path' not 'file_path'
            },
            'building_contractors': {
                'service_type': 'contractor_type',  # Schema may have contractor_type
            }
        }

        if table not in mappings:
            return data

        table_mappings = mappings[table]
        mapped_data = {}

        if table == 'major_works_projects':
            print(f"  Table mappings for {table}: {table_mappings}")
            print(f"  Input data keys: {list(data.keys())}")

        for col_name, value in data.items():
            # Check if this column should be mapped to a different name
            if col_name in table_mappings:
                new_col_name = table_mappings[col_name]
                # Only map if the target column doesn't already exist
                if new_col_name not in data:
                    if table == 'major_works_projects':
                        print(f"  Mapping: {col_name} -> {new_col_name}")
                    mapped_data[new_col_name] = value
                    # Don't include the old column name
                else:
                    # Target exists, keep original too
                    mapped_data[col_name] = value
            else:
                mapped_data[col_name] = value

        # Apply value mappings for CHECK constraints
        if table == 'major_works_projects' and 'status' in mapped_data:
            # Map 'planning' to 'planned' for CHECK constraint (actual schema uses 'planned')
            if mapped_data['status'] == 'planning':
                mapped_data['status'] = 'planned'

        # Map building_documents category values
        if table == 'building_documents' and 'category' in mapped_data:
            category_mappings = {
                'lease': 'leases',
                'finance': 'other',
                'budget': 'other',
                'accounts': 'other',
                'contract': 'other',
                'contracts': 'other',
                'correspondence': 'other',
                'uncategorised': 'other',
            }
            if mapped_data['category'] in category_mappings:
                mapped_data['category'] = category_mappings[mapped_data['category']]

        return mapped_data

    def _get_default_value_for_type(self, col_schema: str) -> Any:
        """Get a sensible default value based on column type"""
        if 'uuid' in col_schema.lower():
            import uuid
            return str(uuid.uuid4())
        elif 'text' in col_schema.lower() or 'character varying' in col_schema.lower():
            return ''
        elif 'integer' in col_schema.lower() or 'bigint' in col_schema.lower():
            return 0
        elif 'numeric' in col_schema.lower() or 'decimal' in col_schema.lower():
            return 0.0
        elif 'boolean' in col_schema.lower():
            return False
        elif 'date' in col_schema.lower():
            return None  # Let database handle
        elif 'timestamp' in col_schema.lower():
            return None  # Let database handle
        elif 'jsonb' in col_schema.lower() or 'json' in col_schema.lower():
            return {}
        elif 'array' in col_schema.lower():
            return []
        else:
            return None

    def _get_table_specific_default(self, table: str, col_name: str) -> Optional[Any]:
        """Get table-specific default values for required columns"""
        defaults = {
            'budgets': {
                'period': 'Unknown',
            },
            'building_insurance': {
                'insurance_type': 'general',
            },
            'leases': {
                'unit_number': 'Unknown',
                'leaseholder_name': 'Unknown',
                'ground_rent': '0',
                'file_path': 'unknown',
            },
            'compliance_assets': {
                'asset_name': 'Unknown Asset',
                'asset_type': 'General',
                'inspection_frequency': 'Annual',
            },
            'building_documents': {
                'category': 'other',
                'file_size': 0,
                'uploaded_by': 'System',
                'ocr_status': 'pending',
            }
        }

        if table in defaults and col_name in defaults[table]:
            return defaults[table][col_name]

        return None

    def get_required_columns(self, table: str) -> List[str]:
        """Get list of required (NOT NULL without DEFAULT) columns for a table"""
        if table not in self.schema:
            return []

        required = []
        for col_name, col_schema in self.schema[table].items():
            if 'NOT NULL' in col_schema and 'DEFAULT' not in col_schema:
                required.append(col_name)

        return required
