# BlocIQ Production Readiness Check

## Quick Start

```bash
# Set required environment variables
export DATABASE_URL="postgresql://user:pass@host:5432/db"
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJ..."
export BUILDING_ID="uuid-here"

# Run the full production check
python3 prod_check.py
```

## What It Does

The `prod_check.py` script executes your complete validation pipeline:

1. **✅ Environment Check** - Verifies all required env vars are set
2. **✅ Schema Export** - Exports live Supabase schema to `schema_snapshot.json`
3. **✅ Schema Validate** - Ensures required columns exist in all tables
4. **✅ Compatibility Migration** - Applies idempotent migration (adds missing columns/views)
5. **✅ Unit Tests** - Tests lease, insurance, and compliance extractors
6. **✅ Smoke Tests** - Validates data inputs and PDF generation (if BUILDING_ID set)

## Output

### Console
Real-time progress with pass/fail for each check:
```
============================================================
🚀 BlocIQ Production Readiness Check
============================================================

📋 Checking environment variables...
✅ All required environment variables present

🔄 Running: Schema export...
   Command: python3 scripts/schema/export_schema.py
✅ Schema export: PASSED

🔄 Running: Schema validate...
   Command: python3 scripts/schema/validate_against_supabase.py
✅ Schema validate: PASSED

...

============================================================
📊 RESULT
============================================================
Status: ✅ Production-ready

Passed:  10 ✅
Failed:  0 ❌
Skipped: 0 ⏭️

Report → docs/PROD_READINESS_CHECKLIST.md

============================================================
✨ DONE
============================================================
```

### Report
Detailed markdown report at `docs/PROD_READINESS_CHECKLIST.md`:
- Summary with pass/fail counts
- Status: Production-ready / Issues detected / Critical failures
- Gate results (PASS/FAIL/SKIP)
- Full logs for each check (last 2000 chars)
- Schema details (tables, views)

### Artifacts
- `schema_snapshot.json` - Live schema export
- `output/*.pdf` - Generated health check PDFs (if smoke tests run)

## Environment Variables

### Required
- `DATABASE_URL` - PostgreSQL connection string
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_SERVICE_KEY` - Supabase service role key
- `BUILDING_ID` - Building UUID (required for smoke tests)

### Example
```bash
export DATABASE_URL="postgresql://postgres:password@db.xxx.supabase.co:5432/postgres"
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
export BUILDING_ID="550e8400-e29b-41d4-a716-446655440000"
```

## Success Criteria

**✅ Production Ready** when:
1. All environment variables set
2. Schema export succeeds
3. Schema validation passes (all required columns exist)
4. Compatibility migration applies successfully
5. Unit tests pass (extractors working correctly)
6. Smoke tests pass (data + PDF generation working)

## Checks Explained

### Schema Export
Exports live Supabase schema to JSON:
- Columns from `information_schema.columns`
- Constraints and foreign keys
- Indexes
- Views

**Output:** `schema_snapshot.json`

### Schema Validate
Validates that required columns exist for all tables:
- buildings, units, leaseholders, leases
- insurance_policies, compliance_assets, compliance_requirements_status
- budget_items, documents, contractors, contracts

**Fails if:** Critical columns are missing

### Compatibility Migration
Idempotent SQL migration that adds:
- Missing columns (IF NOT EXISTS)
- Unique indexes for UPSERT keys
- Reporting views (v_insurance_certificates, v_compliance_rollup, v_lease_coverage, etc.)

**Safe to run multiple times:** All operations use IF NOT EXISTS

### Unit Tests
Tests individual extractors:
- **Lease Extractor**: Unit ref, lessee names, term years, dates, peppercorn rent
- **Insurance Extractor**: Provider, policy number, period dates, no false positives from policy wordings
- **Compliance Extractor**: Inspection dates, status determination, category identification

### Smoke Tests
End-to-end validation (requires BUILDING_ID):
- **Health Inputs**: Prints data counts (documents, insurance, compliance, leases, budgets)
- **PDF Generation**: Tests full PDF render with metrics (health score, compliance score, lease coverage)

## Troubleshooting

### "Missing environment variables"
```bash
# Check what's set
env | grep -E "DATABASE_URL|SUPABASE"

# Set missing vars
export DATABASE_URL="..."
export SUPABASE_URL="..."
export SUPABASE_SERVICE_KEY="..."
export BUILDING_ID="..."
```

### "Schema validation failed"
```bash
# Check which columns are missing
python3 scripts/schema/validate_against_supabase.py

# Apply migration to add them
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### "Unit tests failed"
```bash
# Run individual test to see details
python3 -m unittest tests/unit/test_lease_extractor.py -v
python3 -m unittest tests/unit/test_insurance_extractor.py -v
python3 -m unittest tests/unit/test_compliance_extractor.py -v
```

### "Smoke tests skipped"
This is normal if `BUILDING_ID` is not set. Smoke tests require a real building to validate against.

To enable smoke tests:
```bash
# Find a building ID from your database
psql "$DATABASE_URL" -c "SELECT id, name FROM buildings LIMIT 1;"

# Set it
export BUILDING_ID="<uuid-from-above>"

# Re-run
python3 prod_check.py
```

## Run Individual Checks

You can also run checks individually:

```bash
# Schema export
python3 scripts/schema/export_schema.py

# Schema validation
python3 scripts/schema/validate_against_supabase.py

# Apply migration
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql

# Unit tests
python3 -m unittest tests/unit/test_lease_extractor.py
python3 -m unittest tests/unit/test_insurance_extractor.py
python3 -m unittest tests/unit/test_compliance_extractor.py

# Smoke tests (requires BUILDING_ID)
python3 scripts/smoke/health_inputs.py <building_id>
python3 scripts/smoke/regenerate_pdf.py <building_id>
```

## Exit Codes

- **0** - All checks passed (production ready)
- **1** - One or more checks failed (not production ready)

Use in CI/CD:
```bash
python3 prod_check.py
if [ $? -eq 0 ]; then
    echo "Production ready - deploying..."
    # deployment commands
else
    echo "Production check failed - aborting deployment"
    exit 1
fi
```

## What Gets Checked

### SQL Generation
- ✅ Schema-aligned (central column mapping)
- ✅ Idempotent UPSERTs (ON CONFLICT handling)
- ✅ Nullable key support (COALESCE)
- ✅ Standardized conflict keys

### Extraction Logic
- ✅ Presence-first parsing
- ✅ Certificates only (no policy wordings)
- ✅ Date-based status (Unknown ≠ Overdue)
- ✅ Light inference with confidence scoring

### PDF Generation
- ✅ View-driven queries
- ✅ Clean data (no archived documents)
- ✅ Accurate coverage (distinct units)
- ✅ Distinct budget years

## Documentation

- 📘 **This File**: Quick reference for prod_check.py
- 📗 **Full Guide**: `docs/PRODUCTION_READINESS_GUIDE.md`
- 📕 **SQL Logic**: `docs/SQL_GENERATION_LOGIC.md`
- 📊 **Latest Report**: `docs/PROD_READINESS_CHECKLIST.md` (generated)
- 🚀 **Quick Start**: `QUICKSTART.md`

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Production Check
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
          BUILDING_ID: ${{ secrets.TEST_BUILDING_ID }}
        run: python3 prod_check.py

      - name: Upload report
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: prod-readiness-report
          path: docs/PROD_READINESS_CHECKLIST.md
```

## Next Steps

1. **Set environment variables** (DATABASE_URL, SUPABASE_URL, SUPABASE_SERVICE_KEY, BUILDING_ID)
2. **Run check**: `python3 prod_check.py`
3. **Review report**: `docs/PROD_READINESS_CHECKLIST.md`
4. **Fix failures** (if any)
5. **Re-run** until all checks pass
6. **Deploy** with confidence!

---

**Need help?** Check the full documentation:
- `docs/PRODUCTION_READINESS_GUIDE.md` - Comprehensive guide
- `docs/SQL_GENERATION_LOGIC.md` - SQL generation details
- `QUICKSTART.md` - Quick reference
