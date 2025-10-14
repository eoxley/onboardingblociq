#!/usr/bin/env python3
"""
Example: BlocIQ SQL Generator Usage
====================================
Demonstrates how to use the SQL generator to convert extracted building data
into Supabase-ready SQL statements.

Usage:
    python run_generator.py
    python run_generator.py --dry-run
"""

import sys
import json
from pathlib import Path

# Add parent directory to path to import sql_generator
sys.path.insert(0, str(Path(__file__).parent.parent / "sql-generator"))

from sql_generator import SQLGenerator


def example_1_basic_usage():
    """Example 1: Basic usage with sample data."""
    print("\n" + "="*70)
    print("EXAMPLE 1: Basic SQL Generation")
    print("="*70)

    # Sample extracted data
    data = {
        "building_name": "50 Kensington Gardens Square",
        "building_address": "50 Kensington Gardens Square, London",
        "postcode": "W2 4BA",
        "year_built": 1880,
        "unit_number": "Flat 4",
        "leaseholder_name": "John Smith",
        "lease_term": 125,
        "lease_start": "1996-03-25",
        "unknown_field": "Extra notes about the property"
    }

    # Initialize generator
    generator = SQLGenerator()

    # Generate SQL
    result = generator.generate_sql_from_data(data, source_folder="/handover/KGS")

    # Print summary
    print(f"\nTables affected: {', '.join(result['summary']['tables_affected'])}")
    print(f"Fields mapped: {result['summary']['fields_mapped']}")
    print(f"Fields unmapped: {result['summary']['fields_unmapped']}")

    print("\nGenerated SQL:")
    print("-" * 70)
    for sql in result['sql_statements']:
        print(sql)


def example_2_from_json_file():
    """Example 2: Load data from JSON file and generate SQL."""
    print("\n" + "="*70)
    print("EXAMPLE 2: Generate SQL from JSON File")
    print("="*70)

    # Path to sample data
    json_file = Path(__file__).parent / "sample_extracted_data.json"

    if not json_file.exists():
        print(f"Error: Sample file not found: {json_file}")
        return

    # Load JSON data
    with open(json_file, 'r') as f:
        data = json.load(f)

    print(f"\nLoaded data from: {json_file}")
    print(f"Fields in input: {len(data)}")

    # Initialize generator
    generator = SQLGenerator()

    # Generate SQL and save to file
    output_file = Path(__file__).parent.parent / "output" / "generated_example.sql"
    result = generator.generate_sql_file(data, str(output_file), source_folder="/handover/KGS")

    # Print summary
    print(f"\n✅ SQL generation complete!")
    print(f"Output file: {result['output_file']}")
    print(f"Tables affected: {', '.join(result['summary']['tables_affected'])}")
    print(f"Total SQL statements: {result['summary']['total_statements']}")
    print(f"Fields mapped: {result['summary']['fields_mapped']}")
    print(f"Fields unmapped: {result['summary']['fields_unmapped']}")

    if result['summary']['fields_unmapped'] > 0:
        print(f"\nUnmapped fields (saved to building_data_snapshots):")
        for field in result['summary']['unmapped_field_names']:
            print(f"  - {field}")


def example_3_programmatic_usage():
    """Example 3: Programmatic usage with custom data structures."""
    print("\n" + "="*70)
    print("EXAMPLE 3: Programmatic Usage with Multiple Records")
    print("="*70)

    # Simulate multiple units in a building
    building_data = {
        "building_name": "52 Kensington Gardens Square",
        "building_address": "52 Kensington Gardens Square, London",
        "postcode": "W2 4BA",
        "year_built": 1885,
        "num_units": 10,
        "has_lifts": true,
    }

    units_data = [
        {
            "building_id": "building_id_placeholder",  # Would be populated after building insert
            "unit_number": "Flat 1",
            "leaseholder_name": "Alice Johnson",
            "apportionment_percentage": 10.0
        },
        {
            "building_id": "building_id_placeholder",
            "unit_number": "Flat 2",
            "leaseholder_name": "Bob Williams",
            "apportionment_percentage": 10.0
        }
    ]

    generator = SQLGenerator()

    # Generate building SQL
    print("\n1. Generating building SQL:")
    building_result = generator.generate_sql_from_data(building_data)
    for sql in building_result['sql_statements']:
        print(sql)

    # Generate unit SQL
    print("\n2. Generating units SQL:")
    for unit_data in units_data:
        unit_result = generator.generate_sql_from_data(unit_data)
        for sql in unit_result['sql_statements']:
            print(sql)

    print("\n✅ Multi-record generation complete!")


def example_4_field_mapping_demo():
    """Example 4: Demonstrate field mapping flexibility."""
    print("\n" + "="*70)
    print("EXAMPLE 4: Field Mapping Flexibility")
    print("="*70)

    # Same data with different field names
    data_variant_1 = {
        "building_name": "Building A",
        "address": "123 Main Street",
        "year_built": 1990
    }

    data_variant_2 = {
        "name": "Building B",
        "building_address": "456 High Street",
        "construction_year": 1995
    }

    generator = SQLGenerator()

    print("\nVariant 1 (using 'building_name', 'address'):")
    result1 = generator.generate_sql_from_data(data_variant_1)
    print(f"Mapped to buildings: {result1['table_data'].get('buildings', {})}")

    print("\nVariant 2 (using 'name', 'building_address', 'construction_year'):")
    result2 = generator.generate_sql_from_data(data_variant_2)
    print(f"Mapped to buildings: {result2['table_data'].get('buildings', {})}")

    print("\n✅ Both variants map to same database columns!")
    print("   - building_name/name → buildings.name")
    print("   - address/building_address → buildings.address")
    print("   - year_built/construction_year → buildings.year_built")


def main():
    """Run all examples."""
    import argparse

    parser = argparse.ArgumentParser(description="BlocIQ SQL Generator Examples")
    parser.add_argument("--example", type=int, help="Run specific example (1-4)")
    parser.add_argument("--all", action="store_true", help="Run all examples")

    args = parser.parse_args()

    if args.example == 1:
        example_1_basic_usage()
    elif args.example == 2:
        example_2_from_json_file()
    elif args.example == 3:
        example_3_programmatic_usage()
    elif args.example == 4:
        example_4_field_mapping_demo()
    elif args.all or not args.example:
        # Run all examples
        example_1_basic_usage()
        example_2_from_json_file()
        example_3_programmatic_usage()
        example_4_field_mapping_demo()

    print("\n" + "="*70)
    print("Examples complete! Check the output folder for generated SQL files.")
    print("="*70 + "\n")


if __name__ == "__main__":
    main()
