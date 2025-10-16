# Run Pimlico Place Complete SQL - Instructions

## 🎯 Goal
Insert complete Pimlico Place data into Supabase with ALL extracted data

---

## 📝 Steps to Execute

### 1. Go to Supabase SQL Editor
**URL:** https://aewixchhykxyhqjvqoek.supabase.co/project/aewixchhykxyhqjvqoek/sql/new

---

### 2. STEP 1 - Delete Old Pimlico Data

**File:** `DELETE_pimlico_65e81534.sql` (in project root)

**Action:**
1. Open the file `DELETE_pimlico_65e81534.sql`
2. Copy ALL contents
3. Paste into Supabase SQL Editor
4. Click **"Run"**
5. Wait for success message

**Expected Result:**
```
Deleted successfully - ready for fresh insert
remaining_buildings: 0
remaining_units: 0
```

---

### 3. STEP 2 - Insert Complete Pimlico Data

**File:** `PIMLICO_COMPLETE_FINAL.sql` (748KB)

**Action:**
1. Open the file `PIMLICO_COMPLETE_FINAL.sql`
2. Copy ALL contents (it's large - 2,640 INSERT statements)
3. Paste into Supabase SQL Editor
4. Click **"Run"**
5. Wait for completion (may take 30-60 seconds)

**Expected Result:**
```
Success. No rows returned
```

---

## ✅ What Will Be Inserted

**Building ID:** `cd83b608-ee5a-4bcc-b02d-0bc65a477829`

**Data:**
- ✅ 1 building (Pimlico Place, 79 units, has_lifts=TRUE)
- ✅ 83 units (A1-F25)
- ✅ 82 leaseholders
- ✅ 197 budgets
- ✅ 81 compliance assets
- ✅ 71 insurance policies
- ✅ 265 leases
- ✅ 1,558 lease clauses
- ✅ 6 contractors
- ✅ 295 building knowledge items

**Total:** 2,640 INSERT statements

---

## 🔍 Verify After Running

Run this query in Supabase SQL Editor:

```sql
-- Verify Pimlico Place data
SELECT 
    b.building_name,
    b.num_units,
    (SELECT COUNT(*) FROM units WHERE building_id = b.id) as actual_units,
    (SELECT COUNT(*) FROM leaseholders) as leaseholders_total,
    (SELECT COUNT(*) FROM budgets WHERE building_id = b.id) as budgets,
    (SELECT COUNT(*) FROM compliance_assets WHERE building_id = b.id) as compliance,
    (SELECT COUNT(*) FROM insurance_policies WHERE building_id = b.id) as insurance,
    (SELECT COUNT(*) FROM leases WHERE building_id = b.id) as leases,
    (SELECT COUNT(*) FROM lease_clauses WHERE building_id = b.id) as lease_clauses
FROM buildings b
WHERE b.id = 'cd83b608-ee5a-4bcc-b02d-0bc65a477829';
```

**Expected:**
```
building_name: Pimlico Place
num_units: 79
actual_units: 83
leaseholders_total: 82
budgets: 197
compliance: 81
insurance: 71
leases: 265
lease_clauses: 1558
```

---

## ⚠️ Troubleshooting

### If DELETE fails:
- Check if building exists: `SELECT * FROM buildings WHERE id = '65e81534-9f27-4464-8f04-0d4709beb8ca';`
- If it doesn't exist, skip to STEP 2

### If INSERT fails with "already exists":
- Run DELETE again
- Or change the building_id in PIMLICO_COMPLETE_FINAL.sql

### If you get foreign key errors:
- Make sure DELETE completed first
- Make sure all required tables exist (buildings, units, leaseholders, etc.)

---

## 📊 After Success

Once both SQLs run successfully:

1. **Generate the PDF:**
   ```bash
   cd /Users/ellie/onboardingblociq
   python3 generate_ultimate_report.py BlocIQ_Onboarder/output/mapped_data.json -o output/Pimlico_Place_FINAL.pdf
   ```

2. **The PDF will show:**
   - ✅ 83 units (not 0)
   - ✅ 82 leaseholders (not 0)
   - ✅ All extracted data from Supabase

---

**Ready to run!** 🚀

