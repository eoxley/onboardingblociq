# BlocIQ Production Readiness Guide

## Overview

This guide explains the end-to-end production readiness check system for BlocIQ's onboarding and health check generation pipeline.

## Architecture

The system validates three critical components:

1. **Extraction Logic**: Presence-first parsing with certificates-only for insurance, leases priority, and light inference
2. **SQL Generator**: Schema-aligned, idempotent UPSERTs with conflict resolution
3. **PDF Health Check**: View-driven, noise-free reporting

## Components

### Schema Sync Scripts (`scripts/schema/`)

#### `export_schema.py`
Exports live Supabase schema to `schema_snapshot.json`:
- Columns from `information_schema.columns`
- Constraints and foreign keys
- Indexes
- Views

```bash
python3 scripts/schema/export_schema.py
```

#### `validate_against_supabase.py`
Validates that required columns exist for all tables:
- buildings, units, leaseholders, leases
- insurance_policies, compliance_assets, compliance_requirements_status
- budget_items, documents, contractors, contracts

Fails if critical columns are missing.

```bash
python3 scripts/schema/validate_against_supabase.py
```

#### `compatibility_migration.sql`
Idempotent migration that adds:
- Missing columns (IF NOT EXISTS)
- Unique indexes for UPSERT keys
- Reporting views (v_insurance_certificates, v_compliance_rollup, v_lease_coverage, etc.)

```bash
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

#### `dryrun_generator.py`
Tests generated SQL in a rollback transaction:
- BEGIN → Execute SQL → ROLLBACK
- Catches schema mismatches without side effects

```bash
python3 scripts/schema/dryrun_generator.py generated_seed.sql
```

### SQL Generator Maps (`sql_generator_maps.py`)

Central configuration for SQL generation:

**UPSERT_KEYS**: Conflict resolution keys for each table
```python
UPSERT_KEYS = {
    'buildings': ['name', 'postcode'],
    'units': ['building_id', 'unit_ref'],
    'leases': ['unit_id', 'start_date', 'source_file'],
    ...
}
```

**COLUMN_MAP**: Field name mappings (generator → database)
```python
COLUMN_MAP = {
    'buildings': {
        'name': 'name',
        'full_address': 'full_address',
        ...
    },
    ...
}
```

**Helper Functions**:
- `get_upsert_conflict_clause(table)`: Generates ON CONFLICT clause
- `map_columns(table, data)`: Maps field names to DB columns

### Unit Tests (`tests/unit/`)

#### `test_lease_extractor.py`
Tests lease extraction:
- ✅ Unit reference parsing (Flat 259)
- ✅ Multiple lessee names
- ✅ Term years (125)
- ✅ Start/end date computation
- ✅ Peppercorn rent identification

#### `test_insurance_extractor.py`
Tests insurance certificate extraction:
- ✅ Provider name (Aviva)
- ✅ Policy number
- ✅ Period dates
- ✅ No false positives from policy wordings
- ✅ Confidence scoring

#### `test_compliance_extractor.py`
Tests compliance certificate extraction:
- ✅ Last inspection date
- ✅ Next due date
- ✅ Status (OK/Overdue/Unknown)
- ✅ Category identification
- ✅ dates_missing flag

### Smoke Tests (`scripts/smoke/`)

#### `health_inputs.py`
Prints key counts for a building:
- Documents (active/archived/OCR status)
- Insurance certificates
- Compliance assets (OK/Overdue/Unknown)
- Lease coverage
- Budget years
- Compliance requirements

```bash
python3 scripts/smoke/health_inputs.py <building_id>
```

#### `regenerate_pdf.py`
One-shot PDF generation with metrics:
- Health score
- Compliance score
- Lease coverage %
- Budget years present

```bash
python3 scripts/smoke/regenerate_pdf.py <building_id>
```

## Running Production Check

### Prerequisites

Set environment variables:
```bash
export DATABASE_URL="postgresql://user:pass@host:5432/db"
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJ..."
export BUILDING_ID="uuid-here"  # Optional, for smoke tests
```

### Full Check

Run all checks:
```bash
python3 prod_check.py
```

This executes:
1. ✅ Environment variable check
2. ✅ Schema export
3. ✅ Schema validation
4. ✅ Compatibility migration
5. ✅ Unit tests (lease, insurance, compliance extractors)
6. ✅ Smoke tests (if BUILDING_ID set)

### Output

- **Console**: Real-time check results
- **Report**: `docs/PROD_READINESS_CHECKLIST.md`
- **Schema**: `schema_snapshot.json`

## PDF Generation Rules

The health check PDF must follow these rules (validated by tests):

### Insurance
- ✅ Only from `v_insurance_certificates` (no policy wordings)
- ✅ Current period from active certificates only
- ✅ Archived documents excluded

### Compliance
- ✅ Status based on dates: OK if `next_due >= today`, Overdue if `next_due < today`, Unknown if dates missing
- ✅ Unknown ≠ Overdue (don't inflate overdue count)
- ✅ Required items only for scoring (FRA, EL, EICR, Fire Doors, LOLER, Legionella, Gas, LPS, Asbestos)
- ✅ HRB only if building flagged as high-risk

### Leases
- ✅ Coverage = distinct leased units / total units (no inflation from duplicate leases)
- ✅ Banner if zero leased units
- ✅ No null unit_id leases counted

### Budgets
- ✅ Distinct years only (latest first)
- ✅ No 100+ row spam
- ✅ Service charge year presence

### Documents
- ✅ Archived documents never affect sections or scores
- ✅ No markdown artifacts (`**`, `##`) in PDF text

## SQL Generation Rules

### Idempotent UPSERTs

All inserts use ON CONFLICT:
```sql
INSERT INTO buildings (name, postcode, ...)
VALUES (...)
ON CONFLICT (name, postcode)
DO UPDATE SET ...
```

### Nullable Keys

Handle nullable conflict columns with COALESCE:
```sql
-- Compliance assets: next_due can be NULL
ON CONFLICT (building_id, name, COALESCE(next_due, '1900-01-01'::DATE))

-- Leases: source_file can be NULL
ON CONFLICT (unit_id, start_date, COALESCE(source_file, ''))
```

### Column Mapping

Use `sql_generator_maps.py` for consistency:
```python
from sql_generator_maps import UPSERT_KEYS, map_columns

# Map data fields to DB columns
mapped_data = map_columns('buildings', raw_data)

# Generate conflict clause
conflict_clause = get_upsert_conflict_clause('buildings')
```

## Extraction Rules

### Presence-First Parsing

1. **Index documents** → category, has_text, needs_ocr
2. **Archive irrelevant** → contracts, correspondence, policy wordings
3. **OCR if needed** → has_text=false AND category relevant
4. **Extract from text** → certificates only, no wordings
5. **Light inference** → only if filename/path patterns clear

### Insurance: Certificates Only

✅ Extract from:
- "Buildings Insurance Certificate 2024.pdf"
- "Liability Insurance Cert.pdf"

❌ Ignore:
- "Policy Wording Aviva.pdf"
- "Terms and Conditions.pdf"
- "Policy Schedule.pdf"

### Compliance: Dates Drive Status

- **OK**: `next_due >= today` AND has dates
- **Overdue**: `next_due < today` AND has dates
- **Unknown**: No dates OR dates_missing=true

### Leases: Priority Parsing

1. Parse unit_ref from filename first
2. Extract lessee names, term, dates from text
3. Deduplicate by (unit_id, start_date, source_file)
4. Coverage = distinct units with ≥1 lease

## Reporting Views

All PDF queries use views (no direct table access):

### `v_insurance_certificates`
Active insurance certificates (no policy wordings):
```sql
SELECT p.*
FROM insurance_policies p
JOIN documents d ON d.building_id = p.building_id
  AND d.category = 'insurance_certificate'
  AND d.status = 'active'
```

### `v_compliance_rollup`
Compliance status counts:
```sql
SELECT building_id,
       COUNT(*) as total_assets,
       COUNT(*) FILTER (WHERE status='OK') as ok_count,
       COUNT(*) FILTER (WHERE status='Overdue') as overdue_count,
       COUNT(*) FILTER (WHERE status='Unknown') as unknown_count,
       ROUND(100.0 * ok_count / total_assets, 1) as ok_pct
FROM compliance_assets
GROUP BY building_id
```

### `v_lease_coverage`
Distinct leased units / total units:
```sql
WITH leased_units AS (
  SELECT DISTINCT u.building_id, u.id
  FROM units u
  JOIN leases l ON l.unit_id = u.id
)
SELECT b.id, total_units, leased_units,
       ROUND(100.0 * leased_units / total_units, 1) as lease_pct
FROM buildings b
LEFT JOIN leased_units ON ...
```

### `v_budget_years`
Distinct service charge years with totals:
```sql
SELECT building_id, service_charge_year,
       COUNT(*) as line_count,
       SUM(amount) as total_amount
FROM budget_items
GROUP BY building_id, service_charge_year
ORDER BY SUBSTRING(service_charge_year FROM '\d{4}')::INT DESC
```

### `v_required_compliance_score`
Required-only compliance score (0-100):
```sql
SELECT building_id,
       ROUND(100.0 * SUM(points) / COUNT(*), 1) as req_score
FROM compliance_requirements_status
GROUP BY building_id
```

## Troubleshooting

### Schema Validation Fails

```bash
# Re-export schema
python3 scripts/schema/export_schema.py

# Check what's missing
python3 scripts/schema/validate_against_supabase.py

# Apply migration
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### Unit Tests Fail

Check extractor implementations match test expectations:
```bash
# Run individual tests
python3 -m unittest tests/unit/test_lease_extractor.py -v
python3 -m unittest tests/unit/test_insurance_extractor.py -v
python3 -m unittest tests/unit/test_compliance_extractor.py -v
```

### PDF Generation Fails

Check inputs:
```bash
python3 scripts/smoke/health_inputs.py <building_id>
```

Check views exist:
```sql
SELECT table_name FROM information_schema.views
WHERE table_schema='public' AND table_name LIKE 'v_%';
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Production Readiness Check
on: [push, pull_request]

jobs:
  prod-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.9'

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run production check
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}
        run: python3 prod_check.py

      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: prod-readiness-report
          path: docs/PROD_READINESS_CHECKLIST.md
```

## Success Criteria

✅ Production ready when:

1. **Schema validated**: All required columns exist
2. **Migration applied**: Views and indexes created
3. **Unit tests pass**: Extractors work correctly
4. **Smoke tests pass**: PDF generates with correct metrics
5. **No critical errors**: All critical checks green

## Support

For issues or questions:
- Check `docs/PROD_READINESS_CHECKLIST.md` for detailed results
- Review `schema_snapshot.json` for schema state
- Run individual checks to isolate failures
- Ensure all environment variables are set correctly
