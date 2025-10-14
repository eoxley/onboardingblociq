#!/usr/bin/env python3
"""
BlocIQ SQL Generator & Schema Alignment
========================================
Dynamic SQL generator that converts AI-extracted building data into clean,
idempotent SQL UPSERT statements for Supabase.

Features:
- Flexible field mapping to handle varying input structures
- Automatic UPSERT generation with conflict resolution
- Unstructured data preservation in JSONB snapshots
- Idempotent operations (re-running produces same result)
- CLI with --dry-run option

Author: BlocIQ Team
Date: 2025-10-14
"""

import json
import argparse
from typing import Dict, List, Optional, Any, Tuple
from pathlib import Path
from datetime import datetime
import uuid


# ============================================================================
# TABLE MAPPING CONFIGURATION
# ============================================================================

TABLE_MAP = {
    "buildings": {
        "name": ["building_name", "development_name", "name"],
        "address": ["building_address", "address", "demised_premises"],
        "postcode": ["postcode", "postal_code"],
        "year_built": ["year_built", "construction_year"],
        "num_floors": ["num_floors", "floors", "number_of_floors"],
        "num_units": ["num_units", "total_units", "unit_count"],
        "construction_type": ["construction_type", "building_type"],
        "has_lifts": ["has_lifts", "lift_present"],
        "num_lifts": ["num_lifts", "number_of_lifts"],
        "fire_strategy": ["fire_strategy_type", "evacuation_strategy"],
        "bsa_status": ["bsa_status"],
        "bsa_registration_number": ["bsa_registration_number", "bsa_registration"],
    },

    "units": {
        "building_id": ["building_id"],
        "unit_number": ["unit_number", "flat_number", "apartment_number"],
        "floor_number": ["floor_number", "floor"],
        "bedrooms": ["bedrooms", "num_bedrooms"],
        "tenure_type": ["tenure_type", "tenure"],
        "leaseholder_name": ["leaseholder_name", "leaseholder", "tenant_name"],
        "correspondence_address": ["correspondence_address", "service_address"],
        "is_resident_owner": ["is_resident_owner", "owner_occupied"],
        "apportionment_percentage": ["apportionment_percentage", "service_charge_percentage"],
    },

    "leases": {
        "unit_id": ["unit_id"],
        "lease_date": ["lease_date", "execution_date"],
        "term_years": ["lease_term_years", "lease_term", "term_years"],
        "start_date": ["lease_term_start", "lease_start", "start_date"],
        "end_date": ["lease_term_end", "lease_end", "end_date"],
        "ground_rent_amount": ["ground_rent_amount", "ground_rent"],
        "ground_rent_review_basis": ["ground_rent_review_basis", "ground_rent_pattern"],
        "service_charge_basis": ["service_charge_basis"],
        "title_number": ["title_number"],
        "landlord_name": ["landlord_name"],
    },

    "compliance_assets": {
        "building_id": ["building_id"],
        "asset_type": ["category", "document_type", "compliance_type"],
        "inspection_date": ["inspection_date", "fra_date", "eicr_date"],
        "next_due_date": ["next_due_date", "fra_next_due", "eicr_next_due"],
        "status": ["status", "fra_status", "eicr_status"],
        "risk_rating": ["risk_rating", "fra_risk_rating"],
        "assessor": ["assessor", "contractor", "fra_assessor"],
        "certificate_reference": ["certificate_reference", "cert_ref"],
    },

    "budgets": {
        "building_id": ["building_id"],
        "financial_year": ["financial_year", "service_charge_year"],
        "budget_total": ["budget_total", "total_budget"],
        "reserve_fund": ["reserve_fund_amount", "reserve_fund"],
        "schedule_letter": ["schedule_letter"],
        "version": ["budget_version", "version"],
    },

    "repair_obligations": {
        "lease_id": ["lease_id"],
        "responsible_party": ["responsible_party"],
        "component": ["component"],
        "obligation": ["obligation"],
        "frequency_years": ["frequency_years"],
    },

    "restrictions": {
        "lease_id": ["lease_id"],
        "restriction_type": ["restriction_type"],
        "clause_text": ["clause_text"],
        "allows_with_consent": ["allows_with_consent"],
        "absolute_prohibition": ["absolute_prohibition"],
    },

    "rights_and_easements": {
        "lease_id": ["lease_id"],
        "right_type": ["right_type"],
        "description": ["description"],
        "granted_to": ["granted_to"],
    },

    "estate_assets": {
        "development_id": ["development_id"],
        "asset_type": ["asset_type"],
        "description": ["description"],
        "shared_by_all_buildings": ["shared_by_all_buildings"],
        "maintenance_provider": ["maintenance_provider"],
    }
}


# Primary keys for each table (used for UPSERT conflict resolution)
TABLE_PRIMARY_KEYS = {
    "buildings": ["name", "address"],
    "units": ["building_id", "unit_number"],
    "leases": ["unit_id", "start_date"],
    "compliance_assets": ["building_id", "asset_type", "inspection_date"],
    "budgets": ["building_id", "financial_year"],
    "repair_obligations": ["lease_id", "component"],
    "restrictions": ["lease_id", "restriction_type"],
    "rights_and_easements": ["lease_id", "right_type"],
    "estate_assets": ["development_id", "asset_type"],
}


# ============================================================================
# SQL GENERATOR CLASS
# ============================================================================

class SQLGenerator:
    """Generates idempotent SQL UPSERT statements from extracted data."""

    def __init__(self, table_map: Dict = None):
        """
        Initialize SQL generator.

        Args:
            table_map: Optional custom table mapping (defaults to TABLE_MAP)
        """
        self.table_map = table_map or TABLE_MAP
        self.primary_keys = TABLE_PRIMARY_KEYS

    def match_field_to_column(self, field_name: str, table_name: str) -> Optional[str]:
        """
        Match an input field name to a database column name.

        Args:
            field_name: Input field name from extracted data
            table_name: Target table name

        Returns:
            Database column name or None if no match
        """
        if table_name not in self.table_map:
            return None

        for db_column, possible_names in self.table_map[table_name].items():
            if field_name.lower() in [name.lower() for name in possible_names]:
                return db_column

        return None

    def distribute_fields(self, data: Dict[str, Any]) -> Tuple[Dict[str, Dict], Dict[str, Any]]:
        """
        Distribute input fields across tables based on mapping.

        Args:
            data: Input data dictionary

        Returns:
            Tuple of (table_data, unmapped_fields)
            - table_data: Dict of {table_name: {column: value}}
            - unmapped_fields: Dict of fields that didn't match any table
        """
        table_data = {table: {} for table in self.table_map.keys()}
        unmapped_fields = {}

        for field_name, field_value in data.items():
            # Skip None values and empty strings
            if field_value is None or field_value == "":
                continue

            matched = False

            # Try to match to each table
            for table_name in self.table_map.keys():
                column_name = self.match_field_to_column(field_name, table_name)

                if column_name:
                    table_data[table_name][column_name] = field_value
                    matched = True
                    break  # Field matched, stop searching

            # If no match found, add to unmapped
            if not matched:
                unmapped_fields[field_name] = field_value

        # Remove empty tables
        table_data = {table: fields for table, fields in table_data.items() if fields}

        return table_data, unmapped_fields

    def format_value(self, value: Any) -> str:
        """
        Format a Python value for SQL.

        Args:
            value: Python value (str, int, bool, list, dict, etc.)

        Returns:
            SQL-formatted string
        """
        if value is None:
            return "NULL"
        elif isinstance(value, bool):
            return "TRUE" if value else "FALSE"
        elif isinstance(value, (int, float)):
            return str(value)
        elif isinstance(value, (list, dict)):
            # JSON format
            return f"'{json.dumps(value, ensure_ascii=False)}'::jsonb"
        elif isinstance(value, str):
            # Escape single quotes
            escaped = value.replace("'", "''")
            return f"'{escaped}'"
        else:
            # Convert to string and escape
            escaped = str(value).replace("'", "''")
            return f"'{escaped}'"

    def generate_upsert(self, table_name: str, data: Dict[str, Any]) -> str:
        """
        Generate an UPSERT SQL statement for a table.

        Args:
            table_name: Target table name
            data: Dictionary of {column: value}

        Returns:
            SQL UPSERT statement with ON CONFLICT DO UPDATE
        """
        if not data:
            return ""

        columns = list(data.keys())
        values = [self.format_value(data[col]) for col in columns]

        # Build INSERT statement
        columns_str = ", ".join(columns)
        values_str = ", ".join(values)

        sql = f"INSERT INTO {table_name} ({columns_str})\n"
        sql += f"VALUES ({values_str})\n"

        # Build ON CONFLICT clause
        if table_name in self.primary_keys:
            conflict_cols = ", ".join(self.primary_keys[table_name])
            sql += f"ON CONFLICT ({conflict_cols}) DO UPDATE SET\n"

            # Update all non-key columns
            update_clauses = []
            for col in columns:
                if col not in self.primary_keys[table_name]:
                    update_clauses.append(f"  {col} = EXCLUDED.{col}")

            if update_clauses:
                sql += ",\n".join(update_clauses)
            else:
                # If all columns are part of primary key, do nothing
                sql = sql.replace("DO UPDATE SET", "DO NOTHING")
                sql = sql.rstrip("\n")
        else:
            # No conflict resolution defined, just insert
            sql += "ON CONFLICT DO NOTHING"

        sql += ";\n"

        return sql

    def generate_snapshot_insert(self, building_id: str, unmapped_data: Dict, source_folder: str = None) -> str:
        """
        Generate SQL to insert unmapped data into building_data_snapshots.

        Args:
            building_id: Building UUID
            unmapped_data: Dictionary of unmapped fields
            source_folder: Optional source folder path

        Returns:
            SQL INSERT statement for snapshots table
        """
        if not unmapped_data:
            return ""

        snapshot_id = str(uuid.uuid4())
        extracted_at = datetime.now().isoformat()
        raw_json = json.dumps(unmapped_data, ensure_ascii=False)

        sql = "INSERT INTO building_data_snapshots (id, building_id, extracted_at, source_folder, raw_sql_json)\n"
        sql += f"VALUES (\n"
        sql += f"  '{snapshot_id}',\n"
        sql += f"  '{building_id}',\n"
        sql += f"  '{extracted_at}',\n"
        sql += f"  {self.format_value(source_folder)},\n"
        sql += f"  '{raw_json}'::jsonb\n"
        sql += ");\n"

        return sql

    def generate_sql_from_data(self, data: Dict[str, Any], source_folder: str = None) -> Dict[str, Any]:
        """
        Main method: Generate complete SQL from extracted data.

        Args:
            data: Extracted building data dictionary
            source_folder: Optional source folder path

        Returns:
            Dictionary containing:
            - sql_statements: List of SQL statements
            - table_data: Distributed data by table
            - unmapped_fields: Fields that didn't match schema
            - summary: Generation summary
        """
        # 1. Distribute fields to tables
        table_data, unmapped_fields = self.distribute_fields(data)

        # 2. Generate UPSERT statements for each populated table
        sql_statements = []
        tables_generated = []

        for table_name, table_fields in table_data.items():
            if table_fields:
                sql = self.generate_upsert(table_name, table_fields)
                sql_statements.append(sql)
                tables_generated.append(table_name)

        # 3. Generate snapshot INSERT for unmapped data
        if unmapped_fields:
            # Use building_id from data if available, otherwise generate one
            building_id = data.get('building_id', str(uuid.uuid4()))
            snapshot_sql = self.generate_snapshot_insert(building_id, unmapped_fields, source_folder)
            if snapshot_sql:
                sql_statements.append(snapshot_sql)
                tables_generated.append("building_data_snapshots")

        # 4. Build summary
        summary = {
            "tables_affected": tables_generated,
            "total_statements": len(sql_statements),
            "fields_mapped": sum(len(fields) for fields in table_data.values()),
            "fields_unmapped": len(unmapped_fields),
            "unmapped_field_names": list(unmapped_fields.keys()),
        }

        return {
            "sql_statements": sql_statements,
            "table_data": table_data,
            "unmapped_fields": unmapped_fields,
            "summary": summary,
        }

    def generate_sql_file(self, data: Dict[str, Any], output_path: str, source_folder: str = None) -> Dict[str, Any]:
        """
        Generate SQL and write to file.

        Args:
            data: Extracted building data
            output_path: Path to output SQL file
            source_folder: Optional source folder path

        Returns:
            Generation result dictionary
        """
        result = self.generate_sql_from_data(data, source_folder)

        # Write SQL to file
        output_file = Path(output_path)
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, 'w') as f:
            f.write("-- BlocIQ SQL Generator Output\n")
            f.write(f"-- Generated: {datetime.now().isoformat()}\n")
            f.write(f"-- Source: {source_folder or 'Unknown'}\n")
            f.write(f"-- Tables affected: {', '.join(result['summary']['tables_affected'])}\n\n")

            f.write("BEGIN;\n\n")

            for sql in result['sql_statements']:
                f.write(sql)
                f.write("\n")

            f.write("COMMIT;\n")

        result['output_file'] = str(output_file)

        return result


# ============================================================================
# CLI INTERFACE
# ============================================================================

def main():
    """CLI entry point for SQL generator."""
    parser = argparse.ArgumentParser(
        description="BlocIQ SQL Generator - Convert extracted data to Supabase SQL"
    )

    parser.add_argument(
        "input_file",
        help="Path to input JSON file with extracted data"
    )

    parser.add_argument(
        "-o", "--output",
        help="Output SQL file path (default: output/generated.sql)",
        default="output/generated.sql"
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print SQL to stdout instead of writing to file"
    )

    parser.add_argument(
        "--source-folder",
        help="Source folder path for reference",
        default=None
    )

    args = parser.parse_args()

    # Load input data
    input_path = Path(args.input_file)
    if not input_path.exists():
        print(f"Error: Input file not found: {args.input_file}")
        return 1

    with open(input_path, 'r') as f:
        data = json.load(f)

    # Generate SQL
    generator = SQLGenerator()

    if args.dry_run:
        # Dry run: print to stdout
        result = generator.generate_sql_from_data(data, args.source_folder)

        print("\n" + "="*70)
        print("DRY RUN - SQL GENERATION PREVIEW")
        print("="*70)
        print(f"\nInput: {args.input_file}")
        print(f"Tables affected: {', '.join(result['summary']['tables_affected'])}")
        print(f"Fields mapped: {result['summary']['fields_mapped']}")
        print(f"Fields unmapped: {result['summary']['fields_unmapped']}")

        if result['summary']['fields_unmapped'] > 0:
            print(f"Unmapped fields: {', '.join(result['summary']['unmapped_field_names'])}")

        print("\n" + "-"*70)
        print("GENERATED SQL:")
        print("-"*70 + "\n")

        print("BEGIN;\n")
        for sql in result['sql_statements']:
            print(sql)
        print("COMMIT;\n")

        print("="*70)

    else:
        # Write to file
        result = generator.generate_sql_file(data, args.output, args.source_folder)

        print("\n" + "="*70)
        print("SQL GENERATION COMPLETE")
        print("="*70)
        print(f"\nInput: {args.input_file}")
        print(f"Output: {result['output_file']}")
        print(f"Tables affected: {', '.join(result['summary']['tables_affected'])}")
        print(f"Total statements: {result['summary']['total_statements']}")
        print(f"Fields mapped: {result['summary']['fields_mapped']}")
        print(f"Fields unmapped: {result['summary']['fields_unmapped']}")

        if result['summary']['fields_unmapped'] > 0:
            print(f"\nUnmapped fields (saved to snapshots):")
            for field in result['summary']['unmapped_field_names']:
                print(f"  - {field}")

        print("\n✅ SQL file generated successfully!")
        print("="*70 + "\n")

    return 0


if __name__ == "__main__":
    exit(main())
