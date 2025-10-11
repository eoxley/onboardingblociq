#!/usr/bin/env python3
"""
Validate that required columns exist in the schema snapshot.
Fails if any required columns are missing.
"""
import json
import sys
from typing import Dict, List, Set

REQUIRED_COLUMNS: Dict[str, List[str]] = {
    'buildings': [
        'id', 'name', 'postcode', 'full_address', 'address_line1',
        'total_units', 'managing_agent', 'portfolio'
    ],
    'units': ['id', 'building_id', 'unit_ref', 'level'],
    'leaseholders': ['id', 'display_name', 'email', 'phone'],
    'leases': [
        'id', 'unit_id', 'start_date', 'end_date', 'term_years',
        'ground_rent_text', 'source_file'
    ],
    'insurance_policies': [
        'id', 'building_id', 'provider', 'policy_number', 'policy_type',
        'period_start', 'period_end', 'source_file'
    ],
    'compliance_assets': [
        'id', 'building_id', 'category', 'name', 'last_inspection',
        'next_due', 'status', 'confidence', 'provenance', 'has_evidence',
        'dates_missing', 'source_file'
    ],
    'compliance_requirements_status': [
        'id', 'building_id', 'requirement_key', 'evidence_date',
        'expiry_date', 'points', 'source_doc_id'
    ],
    'budget_items': [
        'id', 'building_id', 'service_charge_year', 'heading',
        'schedule', 'amount'
    ],
    'documents': [
        'id', 'building_id', 'category', 'filename', 'path',
        'has_text', 'needs_ocr', 'status', 'archive_reason', 'archived_at'
    ],
    'contractors': ['id', 'building_id', 'name', 'service_type'],
    'contracts': [
        'id', 'building_id', 'contractor_id', 'description',
        'start_date', 'end_date', 'status'
    ]
}

REQUIRED_VIEWS = [
    'v_insurance_certificates',
    'v_compliance_rollup',
    'v_lease_coverage',
    'v_budget_years',
    'v_required_compliance_score'
]

def validate_schema():
    """Validate schema snapshot against requirements"""
    try:
        with open('schema_snapshot.json', 'r') as f:
            snapshot = json.load(f)
    except FileNotFoundError:
        print("❌ schema_snapshot.json not found. Run export_schema.py first.")
        sys.exit(1)

    # Build lookup of existing columns
    columns_by_table: Dict[str, Set[str]] = {}
    for col in snapshot['columns']:
        table = col['table_name']
        if table not in columns_by_table:
            columns_by_table[table] = set()
        columns_by_table[table].add(col['column_name'])

    # Build lookup of existing views
    existing_views = {v['view_name'] for v in snapshot.get('views', [])}

    errors = []
    warnings = []

    # Check tables and columns
    for table, required_cols in REQUIRED_COLUMNS.items():
        if table not in columns_by_table:
            errors.append(f"❌ Table '{table}' does not exist")
            continue

        existing = columns_by_table[table]
        missing = [col for col in required_cols if col not in existing]

        if missing:
            errors.append(f"❌ Table '{table}': missing columns {', '.join(missing)}")

    # Check views
    for view in REQUIRED_VIEWS:
        if view not in existing_views:
            warnings.append(f"⚠️  View '{view}' does not exist (will be created by migration)")

    # Report results
    if errors:
        print("Schema validation FAILED:\n")
        for err in errors:
            print(err)
        if warnings:
            print("\nWarnings:")
            for warn in warnings:
                print(warn)
        sys.exit(1)

    print("✅ Schema validation PASSED")
    if warnings:
        print("\nWarnings:")
        for warn in warnings:
            print(warn)

    print(f"\n   Tables validated: {len(REQUIRED_COLUMNS)}")
    print(f"   Views expected: {len(REQUIRED_VIEWS)}")
    print(f"   Views found: {len([v for v in REQUIRED_VIEWS if v in existing_views])}")

if __name__ == '__main__':
    validate_schema()
