# BlocIQ Onboarder - Clean Implementation Plan

**Date:** October 10, 2025
**Status:** AUDIT COMPLETE - Ready for Clean Implementation

---

## AUDIT FINDINGS

### 1. Schema Validation Issues ✅ IDENTIFIED
- **Problem:** Multiple schema files (`schema_validator.py`, `schema_mapper.py`, `validate_schema.py`) with conflicting logic
- **Impact:** Generated SQL contains invalid columns (`condition_rating`, `service_frequency`, etc.) that don't exist in Supabase
- **Root Cause:** Hardcoded column mappings and outdated schema assumptions

### 2. PDF Generation Failure ✅ IDENTIFIED
- **Problem:** `building_health_check_v2.py` crashes with `'NoneType' object is not subscriptable`
- **Impact:** No Building Health Check PDF is generated despite data extraction succeeding
- **Root Cause:** Missing null checks in PDF generator when accessing nested data structures

### 3. Code Duplication ✅ IDENTIFIED
- **Duplicate schema files:**
  - `schema_validator.py` (8.1K)
  - `schema_mapper.py` (103K - BLOATED!)
  - `validate_schema.py` (14K)
  - `mapper.py` (6.8K)
- **Old backup files:** 3 backup versions of health check PDF generator in `/reporting/`
- **Impact:** Confusion, maintenance burden, conflicting logic

---

## CLEAN SOLUTION

### Phase 1: Clean Schema Validation (COMPLETE)

**Created Files:**
1. ✅ `/BlocIQ_Onboarder/clean_schema_validator.py` - Simple, direct schema validation using actual Supabase schema
2. ✅ `/BlocIQ_Onboarder/clean_sql_generator.py` - Generates SQL with ONLY valid columns
3. ✅ `/supabase_actual_schema.json` - Fresh export of actual Supabase schema (88 tables)

**Key Features:**
- No hardcoded mappings
- No guessing column names
- Direct validation against `supabase_actual_schema.json`
- Automatic filtering of invalid columns
- Clear user instructions for agency ID/name replacement

---

### Phase 2: Update Onboarder to Use Clean Components (TODO)

**Changes Required:**

1. **Update `onboarder.py` line ~1045:**
   ```python
   # OLD: from sql_writer import  generate_sql
   # NEW:
   from clean_sql_generator import generate_clean_migration
   ```

2. **Replace SQL generation call (line ~1050):**
   ```python
   # OLD: sql_writer.generate_migration(...)
   # NEW:
   generate_clean_migration(
       extracted_data=final_data,
       building_name=building_name,
       output_path=str(self.output_dir / 'migration.sql')
   )
   ```

3. **Remove old imports:**
   - Remove `schema_validator` import
   - Remove `schema_mapper` import
   - Remove `sql_writer` import

---

### Phase 3: Fix PDF Generation (TODO)

**File:** `/BlocIQ_Onboarder/reporting/building_health_check_v2.py`

**Changes Required:**

1. **Add null checks before accessing nested data**
2. **Handle missing compliance_assets gracefully**
3. **Provide default values for missing data sections**
4. **Add try-except blocks around data access**

**Test after fix:**
```bash
python3 BlocIQ_Onboarder/onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
# Should output: building_health_check.pdf
```

---

### Phase 4: Clean Up Old Code (TODO)

**Files to Archive/Delete:**

1. **Schema Files (Move to `/archive/old_schema_files/`):**
   - `schema_validator.py` (keep for reference, not active)
   - `schema_mapper.py` (BLOATED - 103K!)
   - `validate_schema.py`
   - `mapper.py` (if not used elsewhere)

2. **Old Health Check Backups (Move to `/archive/old_reporting/`):**
   - `building_health_check_OLD_BACKUP.py`
   - `building_health_check_OLD_SIMPLE.py`
   - `building_health_check_OLD_V1.py`

3. **Old Schema Scripts (Already in archive):**
   - `supabase_current_schema.json` (outdated)
   - Various `*_schema.py` scripts

**Verification:**
```bash
# After cleanup, only these schema files should be active:
ls -1 BlocIQ_Onboarder/*schema*.py
# Expected output:
#   schema_loader.py (if still needed)
#   clean_schema_validator.py (NEW - active)
```

---

### Phase 5: End-to-End Testing (TODO)

**Test Script:**
```bash
# 1. Clear output directory
rm -rf /Users/ellie/Desktop/BlocIQ_Output/*

# 2. Run onboarder with clean implementation
cd /Users/ellie/onboardingblociq
python3 BlocIQ_Onboarder/onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"

# 3. Verify outputs
ls -lh /Users/ellie/Desktop/BlocIQ_Output/
# Expected:
#   ✅ migration.sql (clean, no invalid columns)
#   ✅ building_health_check.pdf (generated successfully)
#   ✅ summary.json
#   ✅ audit_log.json
#   ✅ document_log.csv

# 4. Validate SQL
grep -c "condition_rating\|service_frequency" /Users/ellie/Desktop/BlocIQ_Output/migration.sql
# Expected: 0 (no invalid columns)

# 5. Test SQL execution
python3 << 'EOF'
import pg8000
conn = pg8000.connect(
    host='aws-1-eu-west-1.pooler.supabase.com',
    port=6543,
    user='postgres.aewixchhykxyhqjvqoek',
    password='1Poppydog!234',
    database='postgres'
)

# Read migration.sql (after replacing placeholders)
with open('/Users/ellie/Desktop/BlocIQ_Output/migration.sql', 'r') as f:
    sql = f.read()

# Replace placeholders
sql = sql.replace('AGENCY_ID_PLACEHOLDER', '11111111-1111-1111-1111-111111111111')
sql = sql.replace('AGENCY_NAME_PLACEHOLDER', 'BlocIQ')

# Execute
cursor = conn.cursor()
cursor.execute(sql)
conn.commit()
print("✅ Migration executed successfully!")
EOF
```

---

## EXPECTED USER WORKFLOW (After Implementation)

1. **User runs onboarder on building folder:**
   ```bash
   python3 BlocIQ_Onboarder/onboarder.py "/path/to/building/files"
   ```

2. **Onboarder outputs:**
   - ✅ `migration.sql` - Clean SQL with agency placeholders
   - ✅ `building_health_check.pdf` - Professional PDF report
   - ✅ `summary.json` - Extraction summary
   - ✅ Various logs and audits

3. **User edits `migration.sql`:**
   - Find and replace `AGENCY_ID_PLACEHOLDER` → their actual agency UUID
   - Find and replace `AGENCY_NAME_PLACEHOLDER` → their actual agency name

4. **User executes migration:**
   ```bash
   psql -h [supabase-host] -U [user] -d postgres -f migration.sql
   ```

5. **Done!** All data imported to Supabase with proper validation

---

## BENEFITS OF CLEAN IMPLEMENTATION

1. **No More SQL Errors:** Only valid columns, guaranteed
2. **Simple Maintenance:** One schema validator, one SQL generator
3. **Clear User Instructions:** Obvious placeholder replacement
4. **Reliable PDF Generation:** Proper null handling
5. **Reduced Code Size:** Remove 100K+ of bloated/duplicate code
6. **Faster Development:** Clear, single-purpose modules

---

## NEXT STEPS

1. ✅ Audit complete - findings documented
2. ✅ Clean validator created
3. ✅ Clean SQL generator created
4. ⏳ Update onboarder.py to use clean components
5. ⏳ Fix PDF generation null handling
6. ⏳ Archive old schema files
7. ⏳ Run end-to-end test
8. ⏳ Document for user

---

## FILES CREATED

- `/Users/ellie/onboardingblociq/supabase_actual_schema.json` (Fresh schema export)
- `/Users/ellie/onboardingblociq/BlocIQ_Onboarder/clean_schema_validator.py` (Simple validator)
- `/Users/ellie/onboardingblociq/BlocIQ_Onboarder/clean_sql_generator.py` (Clean SQL generator)
- `/Users/ellie/onboardingblociq/CLEAN_IMPLEMENTATION_PLAN.md` (This file)
