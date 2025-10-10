"""
Schema Loader - Loads actual Supabase schema for validation
"""
import json
from pathlib import Path

class SchemaLoader:
    """Loads and provides access to actual Supabase schema"""

    def __init__(self, schema_file='supabase_current_schema.json'):
        # Try to find schema file
        schema_path = Path(__file__).parent.parent / schema_file

        if not schema_path.exists():
            print(f"⚠️  Schema file not found at {schema_path}")
            print(f"   Using fallback schema (may have mismatches)")
            self.schema = {}
            return

        with open(schema_path, 'r') as f:
            self.schema = json.load(f)

    def get_table_columns(self, table_name):
        """Get list of column names for a table"""
        if table_name not in self.schema:
            return None
        return [col['name'] for col in self.schema[table_name]['columns']]

    def validate_columns(self, table_name, data_dict):
        """
        Validate that data dict keys match actual table columns
        Returns tuple: (valid_data, warnings)
        """
        actual_columns = self.get_table_columns(table_name)
        if actual_columns is None:
            return data_dict, [f"Table {table_name} not in schema"]

        warnings = []
        valid_data = {}

        for key, value in data_dict.items():
            if key in actual_columns:
                valid_data[key] = value
            else:
                warnings.append(f"Column '{key}' does not exist in {table_name}")

        return valid_data, warnings

    def get_column_type(self, table_name, column_name):
        """Get data type for a specific column"""
        if table_name not in self.schema:
            return None

        for col in self.schema[table_name]['columns']:
            if col['name'] == column_name:
                return col['type']

        return None
