"""
Central configuration for SQL generator: UPSERT keys and column mappings.
Used by sql_generator.py and sql_writer.py to ensure schema alignment.
"""

# UPSERT conflict keys for each table (for ON CONFLICT clause)
UPSERT_KEYS = {
    'buildings': ['name', 'postcode'],
    'units': ['building_id', 'unit_ref'],
    'leaseholders': ['display_name'],
    'leases': ['unit_id', 'start_date', 'source_file'],
    'insurance_policies': ['building_id', 'policy_number', 'period_start'],
    'compliance_assets': ['building_id', 'name', 'next_due'],  # next_due nullable - use COALESCE in index
    'compliance_requirements_status': ['building_id', 'requirement_key'],
    'contractors': ['building_id', 'name'],
    'contracts': ['building_id', 'description', 'start_date'],
    'budget_items': ['building_id', 'service_charge_year', 'heading', 'schedule'],
    'documents': ['building_id', 'filename']
}

# Column name mappings: generator field name -> database column name
# Use this if your generator uses different names than DB columns
COLUMN_MAP = {
    'buildings': {
        'name': 'name',
        'full_address': 'full_address',
        'address_line1': 'address_line1',
        'address_line2': 'address_line2',
        'city': 'city',
        'postcode': 'postcode',
        'region': 'region',
        'total_units': 'total_units',
        'year_built': 'year_built',
        'managing_agent': 'managing_agent',
        'portfolio': 'portfolio'
    },
    'units': {
        'building_id': 'building_id',
        'unit_ref': 'unit_ref',
        'level': 'level'
    },
    'leaseholders': {
        'display_name': 'display_name',
        'email': 'email',
        'phone': 'phone'
    },
    'leases': {
        'unit_id': 'unit_id',
        'start_date': 'start_date',
        'end_date': 'end_date',
        'term_years': 'term_years',
        'ground_rent_text': 'ground_rent_text',
        'source_file': 'source_file'
    },
    'insurance_policies': {
        'building_id': 'building_id',
        'provider': 'provider',
        'policy_number': 'policy_number',
        'policy_type': 'policy_type',
        'period_start': 'period_start',
        'period_end': 'period_end',
        'source_file': 'source_file'
    },
    'compliance_assets': {
        'building_id': 'building_id',
        'category': 'category',
        'name': 'name',
        'last_inspection': 'last_inspection',
        'next_due': 'next_due',
        'status': 'status',
        'confidence': 'confidence',
        'provenance': 'provenance',
        'has_evidence': 'has_evidence',
        'dates_missing': 'dates_missing',
        'source_file': 'source_file'
    },
    'compliance_requirements_status': {
        'building_id': 'building_id',
        'requirement_key': 'requirement_key',
        'evidence_date': 'evidence_date',
        'expiry_date': 'expiry_date',
        'points': 'points',
        'source_doc_id': 'source_doc_id'
    },
    'contractors': {
        'building_id': 'building_id',
        'name': 'name',
        'service_type': 'service_type'
    },
    'contracts': {
        'building_id': 'building_id',
        'contractor_id': 'contractor_id',
        'description': 'description',
        'start_date': 'start_date',
        'end_date': 'end_date',
        'status': 'status'
    },
    'budget_items': {
        'building_id': 'building_id',
        'service_charge_year': 'service_charge_year',
        'heading': 'heading',
        'schedule': 'schedule',
        'amount': 'amount'
    },
    'documents': {
        'building_id': 'building_id',
        'category': 'category',
        'filename': 'filename',
        'path': 'path',
        'has_text': 'has_text',
        'needs_ocr': 'needs_ocr',
        'status': 'status',
        'archive_reason': 'archive_reason',
        'archived_at': 'archived_at'
    }
}

# Required compliance categories (for scoring)
REQUIRED_COMPLIANCE_CATEGORIES = [
    'FRA',              # Fire Risk Assessment
    'EL',               # Emergency Lighting
    'EICR',             # Electrical Installation Condition Report
    'Fire Doors',       # Fire Door Inspection
    'LOLER',            # Lifting Operations (if lifts present)
    'Legionella',       # Water Safety
    'Gas',              # Gas Safety (if applicable)
    'LPS',              # Lightning Protection (if present)
    'Asbestos',         # Asbestos Survey
]

# Optional compliance categories (informational, not scored)
OPTIONAL_COMPLIANCE_CATEGORIES = [
    'HRB',              # Higher Risk Building (only if flagged)
    'F-Gas',            # Refrigerant systems
    'AOV',              # Automatic Opening Vents
    'Firefighting',     # Wet/Dry risers
]

def get_upsert_conflict_clause(table: str) -> str:
    """Generate ON CONFLICT clause for a table"""
    keys = UPSERT_KEYS.get(table, [])
    if not keys:
        return ""

    # Handle nullable columns with COALESCE
    conflict_cols = []
    for key in keys:
        if table == 'compliance_assets' and key == 'next_due':
            conflict_cols.append("COALESCE(next_due, '1900-01-01'::DATE)")
        elif table == 'leases' and key == 'source_file':
            conflict_cols.append("COALESCE(source_file, '')")
        else:
            conflict_cols.append(key)

    return f"ON CONFLICT ({', '.join(conflict_cols)}) DO UPDATE SET"

def map_columns(table: str, data: dict) -> dict:
    """Map generator field names to database column names"""
    table_map = COLUMN_MAP.get(table, {})
    if not table_map:
        return data

    mapped = {}
    for key, value in data.items():
        db_column = table_map.get(key, key)
        mapped[db_column] = value

    return mapped
