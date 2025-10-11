# Production Readiness Implementation Summary

## What Was Built

A comprehensive end-to-end production readiness check system for BlocIQ's onboarding pipeline that validates:
1. ✅ **Extraction Logic** (presence-first, certificates-only, light inference)
2. ✅ **SQL Generation** (schema-aligned, idempotent UPSERTs)
3. ✅ **PDF Health Checks** (view-driven, noise-free reporting)

## Files Created

### Core System

#### `prod_check.py` - Production Check Orchestrator
Main entry point that runs all checks and generates comprehensive report.

**Usage:**
```bash
python3 prod_check.py
```

**What it does:**
- Checks environment variables
- Runs schema validation
- Applies migration
- Executes unit tests
- Runs smoke tests (if BUILDING_ID set)
- Generates markdown report

#### `sql_generator_maps.py` - SQL Generator Configuration
Central configuration for UPSERT keys and column mappings.

**Key Components:**
- `UPSERT_KEYS`: Conflict resolution keys for each table
- `COLUMN_MAP`: Field name mappings (generator → database)
- `REQUIRED_COMPLIANCE_CATEGORIES`: Scoring categories
- `get_upsert_conflict_clause()`: Generates ON CONFLICT clauses
- `map_columns()`: Maps field names to DB columns

### Schema Sync Scripts (`scripts/schema/`)

#### `export_schema.py`
Exports live Supabase schema to JSON.

**Output:** `schema_snapshot.json` with columns, constraints, indexes, views

#### `validate_against_supabase.py`
Validates required columns exist for all tables.

**Checks:**
- Buildings, units, leaseholders, leases
- Insurance policies, compliance assets
- Budget items, documents, contractors

#### `compatibility_migration.sql`
Idempotent migration that adds missing columns and creates views.

**Creates:**
- Missing columns (IF NOT EXISTS)
- Unique indexes for UPSERT keys
- Reporting views (v_insurance_certificates, v_compliance_rollup, etc.)

#### `dryrun_generator.py`
Tests generated SQL in a rollback transaction.

**Safety:** Executes in BEGIN...ROLLBACK to catch errors without side effects

### Unit Tests (`tests/unit/`)

#### `test_lease_extractor.py`
Tests lease document parsing:
- Unit reference extraction (Flat 259)
- Multiple lessee names
- Term years (125)
- Start/end date computation
- Peppercorn rent identification

#### `test_insurance_extractor.py`
Tests insurance certificate extraction:
- Provider name (Aviva)
- Policy number
- Period dates
- No false positives from policy wordings
- Confidence scoring

#### `test_compliance_extractor.py`
Tests compliance certificate extraction:
- Last inspection date
- Next due date
- Status determination (OK/Overdue/Unknown)
- Category identification
- dates_missing flag

### Test Fixtures (`tests/fixtures/`)

#### `lease_peppercorn.txt`
Sample lease with:
- Flat 259, Connaught Square
- 125-year term from 1999
- Peppercorn rent
- Multiple lessees

#### `insurance_cert_short.txt`
Sample insurance certificate with:
- Aviva provider
- Policy number POL-2024-12345
- Period: 1 Jan 2024 - 31 Dec 2024

#### `compliance_el_annual.txt`
Sample compliance certificate with:
- Emergency Lighting inspection
- Inspection date: 15 March 2024
- Next due: 15 March 2025
- Status: Satisfactory

#### `folder_index.json`
Representative file inventory with:
- 6 leases (including 1 duplicate)
- 14 insurance certificates
- 93 compliance certificates
- Budget/accounts files
- Archived contracts/correspondence

### Smoke Tests (`scripts/smoke/`)

#### `health_inputs.py`
Prints key counts for a building:
- Documents (active/archived/OCR status)
- Insurance certificates
- Compliance assets (OK/Overdue/Unknown)
- Lease coverage
- Budget years
- Compliance requirements

**Usage:**
```bash
python3 scripts/smoke/health_inputs.py <building_id>
```

#### `regenerate_pdf.py`
One-shot PDF generation with metrics:
- Health score
- Compliance score
- Lease coverage %
- Budget years present

**Usage:**
```bash
python3 scripts/smoke/regenerate_pdf.py <building_id>
```

### Documentation (`docs/`)

#### `PRODUCTION_READINESS_GUIDE.md`
Comprehensive guide covering:
- Architecture overview
- Component descriptions
- Running production check
- PDF generation rules
- SQL generation rules
- Extraction rules
- Reporting views
- Troubleshooting
- CI/CD integration

#### `SQL_GENERATION_LOGIC.md`
End-to-end SQL generation explanation:
- Schema alignment
- Idempotent UPSERTs
- Conflict key management
- Nullable key handling
- Complete workflow examples
- Key benefits
- Example workflows

#### `PROD_READINESS_CHECKLIST.md` (generated)
Auto-generated report with:
- Summary (passed/failed/warnings)
- Status (production ready or not)
- Detailed results for each check
- Warnings and errors
- Recommendations
- Next steps

### Quick Reference

#### `QUICKSTART.md`
Quick start guide with:
- Prerequisites
- Run commands
- What gets created
- Success criteria
- Common issues
- File structure
- Next steps

## SQL Generation Changes

### Before
- ❌ Hardcoded field names
- ❌ Duplicate inserts on re-run
- ❌ No schema validation
- ❌ Manual conflict handling
- ❌ Inconsistent UPSERT keys

### After
- ✅ Central column mapping (`sql_generator_maps.py`)
- ✅ Idempotent UPSERTs with ON CONFLICT
- ✅ Automated schema validation
- ✅ Standardized conflict keys for all tables
- ✅ Nullable key handling with COALESCE
- ✅ Dry-run testing before real inserts
- ✅ View-driven PDF generation

## Key Capabilities Now Available

### 1. Schema Safety
```bash
# Export live schema
python3 scripts/schema/export_schema.py

# Validate columns exist
python3 scripts/schema/validate_against_supabase.py

# Apply migration safely
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### 2. Idempotent Extraction
```python
# Run extraction multiple times → no duplicates
from sql_generator_maps import UPSERT_KEYS, map_columns

# Map fields to DB columns
data = map_columns('buildings', extracted_data)

# Generate UPSERT with conflict handling
INSERT INTO buildings (name, postcode, ...)
VALUES (...)
ON CONFLICT (name, postcode)
DO UPDATE SET ...
```

### 3. Clean PDF Generation
```python
# All queries use views (no direct table access)
SELECT * FROM v_insurance_certificates WHERE building_id = %s
SELECT * FROM v_compliance_rollup WHERE building_id = %s
SELECT * FROM v_lease_coverage WHERE building_id = %s
SELECT * FROM v_budget_years WHERE building_id = %s
SELECT * FROM v_required_compliance_score WHERE building_id = %s
```

### 4. Automated Testing
```bash
# Run all unit tests
python3 -m unittest discover tests/unit -v

# Test specific extractor
python3 -m unittest tests/unit/test_lease_extractor.py
```

### 5. Production Validation
```bash
# Full check in one command
python3 prod_check.py

# Generates report: docs/PROD_READINESS_CHECKLIST.md
```

## Workflow Example

### 1. Initial Setup
```bash
# Set environment
export DATABASE_URL="postgresql://..."
export SUPABASE_URL="https://..."
export SUPABASE_SERVICE_KEY="..."
export BUILDING_ID="uuid-here"

# Validate and migrate
python3 scripts/schema/export_schema.py
python3 scripts/schema/validate_against_supabase.py
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### 2. Extract Building
```bash
# Run onboarder (uses sql_generator_maps internally)
python3 onboarder.py "/path/to/building/documents"

# SQL generator now:
# - Maps columns correctly
# - Uses idempotent UPSERTs
# - Handles nullable keys
# - Archives irrelevant docs
# - Extracts certificates only
```

### 3. Check Results
```bash
# Check inputs
python3 scripts/smoke/health_inputs.py <building_id>

# Output:
# 🏢 Building: Connaught Square
#    ID: 550e8400-...
# 📄 Documents: 125 total, 95 active, 30 archived
# 🛡️  Insurance: 14 certificates
# ✅ Compliance: 93 assets (65 OK, 8 Overdue, 20 Unknown)
# 📋 Leases: 85% coverage (256/300 units)
# 💰 Budget Years: 3 (2024/25, 2023/24, 2022/23)
```

### 4. Generate PDF
```bash
# One-shot PDF generation
python3 scripts/smoke/regenerate_pdf.py <building_id>

# Output:
# ✅ PDF Generated Successfully
#    Path: output/Connaught_Square_Health_Check_20251010.pdf
# 📊 Key Metrics:
#    Health Score: 82.5
#    Compliance Score: 72.2
#    Lease Coverage: 85.3%
#    Compliance Items: 9
#    Budget Years: 3
```

### 5. Full Production Check
```bash
# Run everything
python3 prod_check.py

# Output:
# ✅ Environment Check: PASSED
# ✅ Schema Export: PASSED
# ✅ Schema Validation: PASSED
# ✅ Compatibility Migration: PASSED
# ✅ Unit Tests (Lease): PASSED
# ✅ Unit Tests (Insurance): PASSED
# ✅ Unit Tests (Compliance): PASSED
# ✅ Smoke Test (Inputs): PASSED
# ✅ Smoke Test (PDF): PASSED
#
# 🎉 ✅ PRODUCTION READY
```

## Production Ready Criteria

✅ All critical checks pass:
1. Environment variables set
2. Schema validated (all required columns exist)
3. Migration applied (views created)
4. Unit tests pass (extractors working)
5. Smoke tests pass (data + PDF generation)

✅ PDF follows rules:
- Insurance from certificates only (no policy wordings)
- Compliance status based on dates (Unknown ≠ Overdue)
- Lease coverage = distinct units (no inflation)
- Budget years distinct (latest first)
- Archived documents excluded
- No markdown artifacts

✅ SQL generation:
- Idempotent (can re-run safely)
- Schema-aligned (columns mapped correctly)
- Conflict keys standardized
- Nullable keys handled with COALESCE

## Next Steps

1. **Review Report**
   ```bash
   cat docs/PROD_READINESS_CHECKLIST.md
   ```

2. **Run Check**
   ```bash
   python3 prod_check.py
   ```

3. **Fix Issues** (if any)
   - Address critical failures
   - Re-run prod check
   - Iterate until green

4. **Deploy**
   - All checks passing
   - Report shows "PRODUCTION READY"
   - Deploy with confidence

## Benefits Achieved

1. **Safety**: Schema validated before deployment
2. **Consistency**: Central configuration for UPSERT keys
3. **Quality**: Automated testing of extractors
4. **Confidence**: Full production readiness check
5. **Maintainability**: Comprehensive documentation
6. **Reliability**: Idempotent operations (no duplicates)
7. **Accuracy**: View-driven reporting (consistent queries)

## Documentation Links

- 📘 **Quick Start**: `QUICKSTART.md`
- 📗 **Full Guide**: `docs/PRODUCTION_READINESS_GUIDE.md`
- 📕 **SQL Logic**: `docs/SQL_GENERATION_LOGIC.md`
- 📊 **Latest Report**: `docs/PROD_READINESS_CHECKLIST.md` (generated)

---

**Status**: ✅ Complete and ready for use

**Command to run**: `python3 prod_check.py`
