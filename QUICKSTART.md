# BlocIQ Production Check - Quick Start

## Prerequisites

```bash
# Set environment variables
export DATABASE_URL="postgresql://user:pass@host:5432/db"
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJ..."
export BUILDING_ID="uuid-here"  # Optional, for smoke tests
```

## Run Full Production Check

```bash
python3 prod_check.py
```

This runs:
1. ✅ Environment check
2. ✅ Schema export → `schema_snapshot.json`
3. ✅ Schema validation
4. ✅ Compatibility migration (adds missing columns/views)
5. ✅ Unit tests (extractors)
6. ✅ Smoke tests (if BUILDING_ID set)
7. 📄 Generates report → `docs/PROD_READINESS_CHECKLIST.md`

## Run Individual Checks

### Schema

```bash
# Export live schema
python3 scripts/schema/export_schema.py

# Validate required columns exist
python3 scripts/schema/validate_against_supabase.py

# Apply migration (idempotent)
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql

# Dry-run SQL (rollback transaction)
python3 scripts/schema/dryrun_generator.py generated_seed.sql
```

### Unit Tests

```bash
# All extractors
python3 -m unittest discover tests/unit -v

# Individual
python3 -m unittest tests/unit/test_lease_extractor.py
python3 -m unittest tests/unit/test_insurance_extractor.py
python3 -m unittest tests/unit/test_compliance_extractor.py
```

### Smoke Tests

```bash
# Check data inputs for a building
python3 scripts/smoke/health_inputs.py <building_id>

# Regenerate PDF
python3 scripts/smoke/regenerate_pdf.py <building_id>
```

## What Gets Created

### Schema Artifacts
- `schema_snapshot.json` - Live schema export
- Tables: buildings, units, leases, insurance_policies, compliance_assets, etc.
- Views: v_insurance_certificates, v_compliance_rollup, v_lease_coverage, v_budget_years, v_required_compliance_score
- Indexes: Unique constraints for UPSERT keys

### Test Artifacts
- Test fixtures in `tests/fixtures/`
- Unit tests in `tests/unit/`
- Test results in console output

### Reports
- `docs/PROD_READINESS_CHECKLIST.md` - Full production readiness report
- Console output with pass/fail for each check

## Success Criteria

✅ **Production Ready** when:
- All environment variables set
- Schema validation passes
- Migration applies successfully
- Unit tests pass
- Smoke tests pass (if BUILDING_ID set)
- No critical errors in report

## Common Issues

### "DATABASE_URL not set"
```bash
export DATABASE_URL="postgresql://..."
```

### "Table does not exist"
```bash
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### "Missing required columns"
```bash
# Migration will add them
psql "$DATABASE_URL" -f scripts/schema/compatibility_migration.sql
```

### Unit test fails
```bash
# Check extractor implementation matches test expectations
python3 -m unittest tests/unit/test_lease_extractor.py -v
```

## File Structure

```
/Users/ellie/onboardingblociq/
├── prod_check.py                          # Main orchestrator
├── sql_generator_maps.py                  # UPSERT keys & column maps
├── scripts/
│   ├── schema/
│   │   ├── export_schema.py              # Export live schema
│   │   ├── validate_against_supabase.py  # Validate columns
│   │   ├── compatibility_migration.sql   # Add missing columns/views
│   │   └── dryrun_generator.py           # Test SQL in rollback
│   └── smoke/
│       ├── health_inputs.py              # Check data counts
│       └── regenerate_pdf.py             # Test PDF generation
├── tests/
│   ├── fixtures/                          # Test data
│   │   ├── lease_peppercorn.txt
│   │   ├── insurance_cert_short.txt
│   │   ├── compliance_el_annual.txt
│   │   └── folder_index.json
│   └── unit/                              # Unit tests
│       ├── test_lease_extractor.py
│       ├── test_insurance_extractor.py
│       └── test_compliance_extractor.py
└── docs/
    ├── PROD_READINESS_CHECKLIST.md       # Generated report
    ├── PRODUCTION_READINESS_GUIDE.md     # Full documentation
    └── SQL_GENERATION_LOGIC.md           # SQL generator details
```

## Next Steps

1. **Review report**: `docs/PROD_READINESS_CHECKLIST.md`
2. **Fix failures**: Address any critical errors
3. **Re-run**: `python3 prod_check.py`
4. **Deploy**: When all checks pass

## Documentation

- 📘 **Full Guide**: `docs/PRODUCTION_READINESS_GUIDE.md`
- 🔧 **SQL Logic**: `docs/SQL_GENERATION_LOGIC.md`
- 📊 **Latest Report**: `docs/PROD_READINESS_CHECKLIST.md`

## Support

For detailed explanations of:
- Schema sync and validation
- UPSERT key management
- Extractor logic and testing
- PDF generation rules
- View-driven reporting

See `docs/PRODUCTION_READINESS_GUIDE.md` and `docs/SQL_GENERATION_LOGIC.md`.
