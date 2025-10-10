"""
Clean Schema Validator - Uses actual Supabase schema only
No hardcoded mappings, no guessing - just validates against real schema
"""
import json
from pathlib import Path
from typing import Dict, List, Any, Optional

class CleanSchemaValidator:
    def __init__(self, schema_path: str = None):
        """Load actual Supabase schema"""
        if schema_path is None:
            schema_path = Path(__file__).parent.parent / 'supabase_actual_schema.json'

        with open(schema_path, 'r') as f:
            self.schema = json.load(f)

        # Build column lookup for fast validation
        self.table_columns = {}
        for table_name, columns in self.schema.items():
            self.table_columns[table_name] = {col['name']: col for col in columns}

    def get_valid_columns(self, table_name: str) -> List[str]:
        """Get list of valid column names for a table"""
        if table_name not in self.table_columns:
            return []
        return list(self.table_columns[table_name].keys())

    def validate_data(self, table_name: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Filter data to only include valid columns that exist in the actual schema.
        Returns only the data that matches real Supabase columns.
        """
        if table_name not in self.table_columns:
            print(f"⚠️  Warning: Table '{table_name}' not found in schema")
            return {}

        valid_columns = self.table_columns[table_name]
        validated_data = {}

        for key, value in data.items():
            if key in valid_columns:
                validated_data[key] = value
            else:
                # Silently skip invalid columns
                pass

        return validated_data

    def get_required_columns(self, table_name: str) -> List[str]:
        """Get list of required (NOT NULL without default) columns"""
        if table_name not in self.table_columns:
            return []

        required = []
        for col_name, col_info in self.table_columns[table_name].items():
            if not col_info['nullable'] and col_info['default'] is None:
                required.append(col_name)

        return required

    def validate_required_fields(self, table_name: str, data: Dict[str, Any]) -> tuple[bool, List[str]]:
        """Check if all required fields are present"""
        required = self.get_required_columns(table_name)
        missing = [col for col in required if col not in data or data[col] is None]
        return len(missing) == 0, missing

    def get_column_type(self, table_name: str, column_name: str) -> Optional[str]:
        """Get the data type of a column"""
        if table_name not in self.table_columns:
            return None
        if column_name not in self.table_columns[table_name]:
            return None
        return self.table_columns[table_name][column_name]['type']
