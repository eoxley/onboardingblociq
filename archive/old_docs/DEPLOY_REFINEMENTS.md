# 🚀 Quick Deploy Guide - BlocIQ Refinements

## ⚡ 3-Minute Deployment

### Step 1: Run the Migration

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 run_refinements.py
```

### Step 2: Choose Your Method

**If you have `psql` installed and DATABASE_URL set:**
- Type `yes` when prompted
- Migration runs automatically
- Type `yes` to run tests

**If not:**
- Follow the manual instructions shown
- Open Supabase Dashboard → SQL Editor
- Copy/paste the SQL file contents
- Click Run

### Step 3: Verify

You should see:
```
✅ MIGRATION COMPLETE!
📊 Your database now has:
   ✓ Enterprise-grade ENUM validation
   ✓ AI confidence scoring on all extractions
   ✓ Comprehensive audit logging
   ✓ Performance-optimized indexes
   ✓ Auto-updating timestamps
   ✓ Ready-to-use dashboard views
```

---

## 📁 What You're Deploying

### Core Files (All Ready ✅)
- `sql_scripts/BLOCIQ_GRADE_REFINEMENTS.sql` - Main migration (16KB)
- `sql_scripts/TEST_REFINEMENTS.sql` - Validation tests (8.6KB)
- `run_refinements.py` - Interactive deployment tool
- `sql_scripts/README.md` - Full documentation

---

## 🎯 What Gets Added to Your Database

### Tables (2 new)
- `safety_case_documents` - Track ERPs, fire strategies, etc.
- `document_ai_audit_log` - Full AI extraction audit trail

### Columns (6 tables updated)
- `confidence_score` added to compliance_assets, leaseholders, budgets, etc.
- `extraction_source` added where applicable

### Types (6 ENUMs)
- document_status, compliance_status, asset_type_enum, etc.

### Indexes (15+)
- Optimized for building queries, status filters, date ranges

### Views (3)
- `low_confidence_extractions`
- `missing_safety_documents`
- `overdue_compliance`

### Triggers (3+)
- Auto-update `updated_at` timestamps

---

## ⚠️ Safety Checklist

✅ **Backward Compatible** - Existing code continues to work
✅ **Idempotent** - Safe to run multiple times
✅ **Non-Destructive** - Only adds, never removes
✅ **Tested** - Comprehensive test suite included
✅ **Documented** - Full inline comments

---

## 🧪 Testing

After deployment, test the new features:

### Query a View
```sql
SELECT * FROM low_confidence_extractions LIMIT 10;
```

### Check Confidence Scores
```sql
SELECT
    asset_name,
    confidence_score
FROM compliance_assets
WHERE confidence_score < 0.80;
```

### View AI Audit Log
```sql
SELECT * FROM document_ai_audit_log
ORDER BY created_at DESC
LIMIT 20;
```

---

## 📊 Live Testing

Run the full test suite:
```bash
python3 run_refinements.py
# Choose "yes" for tests when prompted
```

Or manually in Supabase SQL Editor:
```sql
-- Copy/paste contents of TEST_REFINEMENTS.sql
```

Expected: All 9 tests pass ✅

---

## 🎉 You're Done!

Your database is now BlocIQ-grade with:
- AI transparency via confidence scoring
- Complete audit trails
- Performance-optimized queries
- Production-ready validation

**Next:** Update your onboarder code to populate confidence_score fields!

---

## 📚 More Info

- **Full Details:** `BLOCIQ_REFINEMENTS_SUMMARY.md`
- **Documentation:** `BlocIQ_Onboarder/sql_scripts/README.md`
- **Example Queries:** See README.md in sql_scripts/

---

**Questions?** All SQL files have inline comments explaining each section.
