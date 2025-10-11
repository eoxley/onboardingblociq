# SQL Generation Logic - End-to-End Overview

## Overview

The BlocIQ SQL generator produces **schema-aligned, idempotent UPSERT statements** that safely insert or update data in Supabase without duplicates or conflicts.

## Core Capabilities

### 1. Schema Alignment

**Problem**: Generator might use field names that don't match database columns.

**Solution**: Central column mapping (`sql_generator_maps.py`)

```python
COLUMN_MAP = {
    'buildings': {
        'name': 'name',
        'full_address': 'full_address',
        'managing_agent': 'managing_agent',
        ...
    }
}

# Usage
mapped_data = map_columns('buildings', extracted_data)
```

### 2. Idempotent UPSERTs

**Problem**: Re-running extraction creates duplicates.

**Solution**: ON CONFLICT DO UPDATE with unique keys

```sql
INSERT INTO buildings (name, postcode, full_address, ...)
VALUES ('Connaught Square', 'W2 2HL', '219 Connaught Square', ...)
ON CONFLICT (name, postcode)
DO UPDATE SET
    full_address = EXCLUDED.full_address,
    managing_agent = EXCLUDED.managing_agent,
    updated_at = NOW();
```

### 3. Conflict Key Management

**Problem**: Each table has different uniqueness constraints.

**Solution**: Centralized UPSERT_KEYS configuration

```python
UPSERT_KEYS = {
    'buildings': ['name', 'postcode'],
    'units': ['building_id', 'unit_ref'],
    'leases': ['unit_id', 'start_date', 'source_file'],
    'insurance_policies': ['building_id', 'policy_number', 'period_start'],
    'compliance_assets': ['building_id', 'name', 'next_due'],
    'documents': ['building_id', 'filename'],
    ...
}
```

### 4. Nullable Key Handling

**Problem**: Some conflict keys can be NULL (e.g., `leases.source_file`, `compliance_assets.next_due`).

**Solution**: COALESCE in index definition and conflict clause

```sql
-- Index (created by migration)
CREATE UNIQUE INDEX uniq_leases_unit_start_source
ON leases (unit_id, start_date, COALESCE(source_file, ''));

-- Insert
INSERT INTO leases (unit_id, start_date, source_file, ...)
VALUES (...)
ON CONFLICT (unit_id, start_date, COALESCE(source_file, ''))
DO UPDATE SET ...;
```

## How It Works End-to-End

### Phase 1: Document Indexing

```python
# From onboarder.py or indexer
for file in document_folder:
    category = classify_document(file)
    has_text = check_has_text(file)
    needs_ocr = category.is_relevant() and not has_text

    insert_document(
        building_id=building_id,
        filename=file.name,
        category=category,
        has_text=has_text,
        needs_ocr=needs_ocr,
        status='active' if category.is_relevant() else 'archived'
    )
```

Generated SQL:
```sql
INSERT INTO documents (
    building_id, filename, category, path, has_text, needs_ocr, status
) VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    'Buildings_Insurance_2024.pdf',
    'insurance_certificate',
    '/path/to/file.pdf',
    true,
    false,
    'active'
)
ON CONFLICT (building_id, filename)
DO UPDATE SET
    category = EXCLUDED.category,
    has_text = EXCLUDED.has_text,
    needs_ocr = EXCLUDED.needs_ocr,
    status = EXCLUDED.status,
    updated_at = NOW();
```

### Phase 2: OCR Processing

```python
# Queue OCR for documents with needs_ocr=true
docs = get_documents(building_id, needs_ocr=True)

for doc in docs:
    text = run_ocr(doc.path)

    update_document(
        doc.id,
        has_text=True,
        needs_ocr=False,
        ocr_completed_at=datetime.now()
    )
```

### Phase 3: Extraction

#### Lease Extraction

```python
# From deep_parser/extractors/lease_extractor.py
for lease_doc in get_documents(category='lease'):
    text = read_text(lease_doc.path)

    lease_data = extract_lease_data(text, filename=lease_doc.filename)
    # Returns: {
    #   'unit_ref': '259',
    #   'lessee_names': ['John Smith', 'Mary Smith'],
    #   'term_years': 125,
    #   'start_date': date(1999, 1, 1),
    #   'end_date': date(2124, 1, 1),
    #   'ground_rent_text': 'one peppercorn',
    #   'confidence': 0.92
    # }

    # Map to DB columns
    lease_data = map_columns('leases', lease_data)

    # Find or create unit
    unit_id = find_or_create_unit(building_id, lease_data['unit_ref'])

    # Insert lease
    insert_lease(
        unit_id=unit_id,
        start_date=lease_data['start_date'],
        end_date=lease_data['end_date'],
        term_years=lease_data['term_years'],
        ground_rent_text=lease_data['ground_rent_text'],
        source_file=lease_doc.filename
    )
```

Generated SQL:
```sql
-- Unit (if not exists)
INSERT INTO units (building_id, unit_ref)
VALUES ('550e8400-...', '259')
ON CONFLICT (building_id, unit_ref)
DO NOTHING
RETURNING id;

-- Lease
INSERT INTO leases (
    unit_id, start_date, end_date, term_years, ground_rent_text, source_file
) VALUES (
    'unit-uuid-here',
    '1999-01-01',
    '2124-01-01',
    125,
    'one peppercorn',
    'Flat_259_Lease.pdf'
)
ON CONFLICT (unit_id, start_date, COALESCE(source_file, ''))
DO UPDATE SET
    end_date = EXCLUDED.end_date,
    term_years = EXCLUDED.term_years,
    ground_rent_text = EXCLUDED.ground_rent_text,
    updated_at = NOW();

-- Leaseholder (if names present)
INSERT INTO leaseholders (display_name)
VALUES ('John Smith')
ON CONFLICT (display_name)
DO NOTHING
RETURNING id;
```

#### Insurance Extraction (Certificates Only)

```python
# From deep_parser/extractors/insurance_extractor.py
for insurance_doc in get_documents(category='insurance_certificate'):
    # Skip if archived or policy wording
    if insurance_doc.status == 'archived':
        continue

    text = read_text(insurance_doc.path)

    # Check if this is a policy wording (not a certificate)
    if is_policy_wording(text):
        # Archive it
        archive_document(insurance_doc.id, reason='policy_wording')
        continue

    insurance_data = extract_insurance_data(text, filename=insurance_doc.filename)
    # Returns: {
    #   'provider': 'Aviva Insurance Limited',
    #   'policy_number': 'POL-2024-12345',
    #   'policy_type': 'Buildings Insurance',
    #   'period_start': date(2024, 1, 1),
    #   'period_end': date(2024, 12, 31),
    #   'confidence': 0.88
    # }

    if insurance_data['confidence'] < 0.6:
        # Low confidence - flag for review
        continue

    insert_insurance_policy(
        building_id=building_id,
        provider=insurance_data['provider'],
        policy_number=insurance_data['policy_number'],
        policy_type=insurance_data['policy_type'],
        period_start=insurance_data['period_start'],
        period_end=insurance_data['period_end'],
        source_file=insurance_doc.filename
    )
```

Generated SQL:
```sql
INSERT INTO insurance_policies (
    building_id, provider, policy_number, policy_type,
    period_start, period_end, source_file
) VALUES (
    '550e8400-...',
    'Aviva Insurance Limited',
    'POL-2024-12345',
    'Buildings Insurance',
    '2024-01-01',
    '2024-12-31',
    'Buildings_Insurance_2024.pdf'
)
ON CONFLICT (building_id, policy_number, period_start)
DO UPDATE SET
    provider = EXCLUDED.provider,
    policy_type = EXCLUDED.policy_type,
    period_end = EXCLUDED.period_end,
    source_file = EXCLUDED.source_file,
    updated_at = NOW();
```

#### Compliance Extraction

```python
# From deep_parser/extractors/compliance_extractor.py
for compliance_doc in get_documents(category='compliance'):
    text = read_text(compliance_doc.path)

    compliance_data = extract_compliance_data(text, filename=compliance_doc.filename)
    # Returns: {
    #   'category': 'EL',
    #   'name': 'Emergency Lighting Annual Inspection',
    #   'last_inspection': date(2024, 3, 15),
    #   'next_due': date(2025, 3, 15),
    #   'status': 'OK',  # Computed from next_due vs today
    #   'dates_missing': False,
    #   'has_evidence': True,
    #   'confidence': 0.85
    # }

    insert_compliance_asset(
        building_id=building_id,
        category=compliance_data['category'],
        name=compliance_data['name'],
        last_inspection=compliance_data['last_inspection'],
        next_due=compliance_data['next_due'],
        status=compliance_data['status'],
        confidence=compliance_data['confidence'],
        provenance='extracted',
        has_evidence=True,
        dates_missing=False,
        source_file=compliance_doc.filename
    )
```

Generated SQL:
```sql
INSERT INTO compliance_assets (
    building_id, category, name, last_inspection, next_due, status,
    confidence, provenance, has_evidence, dates_missing, source_file
) VALUES (
    '550e8400-...',
    'EL',
    'Emergency Lighting Annual Inspection',
    '2024-03-15',
    '2025-03-15',
    'OK',
    0.85,
    'extracted',
    true,
    false,
    'EL_Annual_2024.pdf'
)
ON CONFLICT (building_id, name, COALESCE(next_due, '1900-01-01'::DATE))
DO UPDATE SET
    last_inspection = EXCLUDED.last_inspection,
    status = EXCLUDED.status,
    confidence = EXCLUDED.confidence,
    has_evidence = EXCLUDED.has_evidence,
    dates_missing = EXCLUDED.dates_missing,
    source_file = EXCLUDED.source_file,
    updated_at = NOW();
```

### Phase 4: Compliance Requirements Scoring

```python
# From compliance_requirements.py
required_categories = [
    'FRA', 'EL', 'EICR', 'Fire Doors', 'LOLER',
    'Legionella', 'Gas', 'LPS', 'Asbestos'
]

for requirement in required_categories:
    # Check if we have compliant evidence
    assets = get_compliance_assets(
        building_id=building_id,
        category=requirement
    )

    # Calculate points
    if any(a.status == 'OK' and a.has_evidence for a in assets):
        points = 1.0  # Fully met
        evidence_date = max(a.last_inspection for a in assets)
        expiry_date = min(a.next_due for a in assets if a.next_due)
    else:
        points = 0.0  # Not met
        evidence_date = None
        expiry_date = None

    insert_compliance_requirement_status(
        building_id=building_id,
        requirement_key=requirement,
        points=points,
        evidence_date=evidence_date,
        expiry_date=expiry_date
    )
```

Generated SQL:
```sql
INSERT INTO compliance_requirements_status (
    building_id, requirement_key, points, evidence_date, expiry_date
) VALUES
    ('550e8400-...', 'FRA', 1.0, '2024-01-15', '2025-01-15'),
    ('550e8400-...', 'EL', 1.0, '2024-03-15', '2025-03-15'),
    ('550e8400-...', 'EICR', 1.0, '2023-11-20', '2028-11-20'),
    ('550e8400-...', 'Fire Doors', 0.0, NULL, NULL),
    ('550e8400-...', 'LOLER', 1.0, '2024-02-10', '2024-08-10'),
    ('550e8400-...', 'Legionella', 1.0, '2024-01-05', '2024-07-05'),
    ('550e8400-...', 'Gas', 0.0, NULL, NULL),
    ('550e8400-...', 'LPS', 0.0, NULL, NULL),
    ('550e8400-...', 'Asbestos', 1.0, '2022-06-15', NULL)
ON CONFLICT (building_id, requirement_key)
DO UPDATE SET
    points = EXCLUDED.points,
    evidence_date = EXCLUDED.evidence_date,
    expiry_date = EXCLUDED.expiry_date,
    updated_at = NOW();
```

### Phase 5: PDF Generation (View-Driven)

```python
# From generate_health_check_from_supabase_v3.py
def fetch_health_check_data(building_id):
    """Fetch all data using views only"""

    # Building info
    building = query("SELECT * FROM buildings WHERE id = %s", building_id)

    # Insurance (certificates only, via view)
    insurance = query("""
        SELECT * FROM v_insurance_certificates
        WHERE building_id = %s
        ORDER BY period_start DESC
    """, building_id)

    # Compliance (rollup via view)
    compliance = query("""
        SELECT * FROM v_compliance_rollup
        WHERE building_id = %s
    """, building_id)

    compliance_assets = query("""
        SELECT * FROM compliance_assets
        WHERE building_id = %s
        ORDER BY category, status, name
    """, building_id)

    # Lease coverage (via view)
    lease_coverage = query("""
        SELECT * FROM v_lease_coverage
        WHERE building_id = %s
    """, building_id)

    # Budget years (via view)
    budget_years = query("""
        SELECT * FROM v_budget_years
        WHERE building_id = %s
        ORDER BY service_charge_year DESC
        LIMIT 10
    """, building_id)

    # Health score (via view)
    health_score = query("""
        SELECT * FROM v_building_health_score
        WHERE building_id = %s
    """, building_id)

    return {
        'building': building,
        'insurance': insurance,
        'compliance': compliance,
        'compliance_assets': compliance_assets,
        'lease_coverage': lease_coverage,
        'budget_years': budget_years,
        'health_score': health_score
    }
```

## Key Benefits

### 1. **No Duplicates**
- Unique indexes enforce constraint at DB level
- ON CONFLICT handles re-runs gracefully
- Same data extracted twice → single row updated

### 2. **Schema Safety**
- Column mapping catches mismatches
- Dry-run validates before real insert
- Migration adds missing columns

### 3. **Data Quality**
- Certificates only (no policy wordings)
- Status computed from dates (Unknown ≠ Overdue)
- Distinct unit counting (no lease inflation)
- View-driven reporting (consistent queries)

### 4. **Maintainability**
- Central configuration (UPSERT_KEYS, COLUMN_MAP)
- Test coverage (unit + integration)
- Production readiness check validates everything

### 5. **Idempotency**
- Can re-run extraction safely
- Updates existing records
- No data loss or corruption

## What You Can Do Now

1. **Extract any building multiple times** → no duplicates
2. **Add new columns** → migration handles it safely
3. **Generate PDFs** → always uses latest data from views
4. **Run tests** → validates extractors, schema, and PDF
5. **Deploy confidently** → prod check verifies everything

## Example Workflow

```bash
# 1. Validate schema
python3 scripts/schema/export_schema.py
python3 scripts/schema/validate_against_supabase.py

# 2. Apply migration (safe, idempotent)
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql

# 3. Run extraction
python3 onboarder.py "/path/to/building/documents"

# 4. Check inputs
python3 scripts/smoke/health_inputs.py <building_id>

# 5. Generate PDF
python3 scripts/smoke/regenerate_pdf.py <building_id>

# 6. Full production check
python3 prod_check.py
```

## Summary

The SQL generator now:

✅ **Aligns with schema** via central column mapping
✅ **Prevents duplicates** via idempotent UPSERTs
✅ **Handles nullables** via COALESCE in conflict keys
✅ **Validates before deploy** via dry-run and prod check
✅ **Generates clean PDFs** via view-driven queries
✅ **Scores accurately** via required-only compliance
✅ **Archives noise** via document status management

**Result**: Production-ready, maintainable, safe SQL generation for BlocIQ onboarding. 🎉
