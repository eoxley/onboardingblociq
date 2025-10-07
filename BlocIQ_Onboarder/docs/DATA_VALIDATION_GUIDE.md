# Data Validation Guide
## Ensuring Correct Data Capture in BlocIQ Application

This guide explains how to ensure that data extracted by the onboarder is correctly captured in the BlocIQ application.

---

## 🔍 Built-in Validation System

The onboarder now includes automatic validation that checks:

### 1. **Schema Compliance**
- All generated data matches exact Supabase schema definitions
- Only valid columns are included in SQL statements
- Data types are correctly formatted (UUIDs, dates, booleans)

### 2. **Required Fields**
- Building: `id`, `name`, `address`
- Units: `id`, `building_id`, `unit_number`
- Leaseholders: `id`, `unit_id`
- Documents: `id`, `building_id`, `file_name`, `category`
- Compliance Assets: `id`, `building_id`, `asset_name`, `asset_type`, `category`, `inspection_frequency`
- Compliance Inspections: `id`, `asset_id`, `inspection_date`
- Major Works: `id`, `building_id`, `project_name`, `project_type`
- Budgets: `id`, `building_id`, `financial_year`
- Service Charge Years: `id`, `building_id`, `financial_year`

### 3. **Foreign Key Relationships**
- All units, documents, compliance assets, major works → reference valid `building_id`
- All leaseholders → reference valid `unit_id`
- All compliance inspections → reference valid `asset_id`
- No orphaned records

### 4. **Data Quality**
- UUID format validation
- Email format validation (if present)
- Date format normalization (ISO 8601)
- Amount validation for financial data

---

## 📝 Output Files for Validation

After running the onboarder, you'll get these files in the output directory:

### **1. validation_report.json**
```json
{
  "valid": true,
  "errors": [],
  "warnings": [
    "budgets: No budgets found"
  ],
  "results": [
    "✅ buildings.id: abc123...",
    "✅ buildings.name: Test Building",
    "✅ Inspection 0: Has findings extracted"
  ]
}
```

**Action**: Review this first! If `valid: false`, fix errors before executing SQL.

### **2. migration.sql**
The complete SQL script with INSERT statements for all tables.

**What to check**:
- Building name is correct
- Unit numbers match your spreadsheet
- Document categories are accurate
- Compliance asset types are recognized
- Dates are in correct format (YYYY-MM-DD)

### **3. document_log.csv**
CSV of all processed documents with categories and confidence scores.

**Action**: Verify each document was classified correctly.

### **4. summary.json**
High-level statistics about what was extracted.

```json
{
  "statistics": {
    "buildings": 1,
    "units": 45,
    "leaseholders": 52,
    "documents": 316,
    "compliance_assets": 12,
    "compliance_inspections": 18,
    "major_works_projects": 3,
    "budgets": 2,
    "service_charge_years": 2
  }
}
```

---

## ✅ Step-by-Step Validation Process

### Step 1: Run the Onboarder
```bash
python onboarder.py /path/to/client/folder --building-name "Building Name"
```

### Step 2: Check Console Output
Look for:
- ✅ Green checkmarks = successful steps
- ⚠️ Yellow warnings = missing data (not critical)
- ❌ Red errors = validation failures (critical)

### Step 3: Review validation_report.json
```bash
cat output/validation_report.json
```

**If valid: true** → Proceed to Step 4
**If valid: false** → Review errors, fix source data, re-run

### Step 4: Review migration.sql
Open in text editor and spot-check:

```sql
-- Check building details
INSERT INTO buildings (id, name, address, postcode, ...)
VALUES ('uuid', 'Correct Name?', 'Correct Address?', ...);

-- Check a few units
INSERT INTO units (id, building_id, unit_number, floor, apportionment_percent)
VALUES ('uuid', 'building-uuid', 'Flat 1', '1', 2.5);

-- Check compliance assets
INSERT INTO compliance_assets (asset_name, asset_type, last_inspection_date, next_due_date)
VALUES ('Fire Risk Assessment', 'fire_risk_assessment', '2024-03-15', '2025-03-15');
```

### Step 5: Test in Supabase (Staging First!)
1. Create a test building in staging environment
2. Copy the SQL from migration.sql
3. Run in Supabase SQL Editor
4. Check for errors

**Common SQL errors**:
- Foreign key constraint violations → UUID mismatch
- Column doesn't exist → Schema version mismatch
- Type mismatch → Data format issue

### Step 6: Verify in Frontend Application
After SQL executes successfully:

1. **Building Details Page**
   - Check all building fields populated correctly
   - Emergency contacts visible
   - Physical characteristics correct

2. **Units List**
   - All units appear
   - Unit numbers match source data
   - Leaseholder names linked correctly
   - Apportionment percentages present

3. **Leaseholders**
   - Names, emails, phones correct
   - Linked to correct units

4. **Documents Page**
   - All 316 documents listed
   - Categories assigned correctly
   - File paths correct

5. **Compliance Section**
   - All compliance assets visible (FRA, EICR, Gas Safety, etc.)
   - Inspection dates correct
   - Next due dates calculated
   - Status indicators accurate
   - **Findings/Actions visible in inspection records**

6. **Major Works**
   - Projects listed with correct details
   - Section 20 timeline visible
   - Costs and contractors present

7. **Financials**
   - Budget years appear
   - Service charge accounts visible
   - Line items with correct amounts

---

## 🚨 Common Issues & Fixes

### Issue: "Foreign key constraint violation"
**Cause**: Generated UUID not matching between related tables
**Fix**:
1. Check that building_id is same in all related records
2. Verify unit_id references match between units and leaseholders
3. Re-run onboarder if UUIDs are inconsistent

### Issue: "Column 'xyz' doesn't exist"
**Cause**: Schema mismatch between onboarder and Supabase
**Fix**:
1. Run schema migrations in Supabase to add missing columns
2. Check `/Users/ellie/Desktop/blociq-frontend/database/` for latest schema
3. Run ALTER TABLE commands to match

### Issue: "No compliance assets found"
**Cause**: Document classification didn't detect compliance documents
**Fix**:
1. Check document_log.csv for classification confidence scores
2. Verify document filenames contain keywords (FRA, EICR, Gas Safety, etc.)
3. Manually add asset records if needed

### Issue: "Dates in wrong format"
**Cause**: Source data has non-standard date format
**Fix**: Dates are automatically normalized to YYYY-MM-DD. Check validation report.

### Issue: "Leaseholders not linked to units"
**Cause**: Unit numbers in leaseholder list don't match units table
**Fix**:
1. Check source spreadsheet for consistent unit numbering
2. Verify unit_leaseholder_links are generated
3. Check UPDATE statements at end of SQL

---

## 🎯 Testing Checklist

Before deploying to production:

- [ ] validation_report.json shows `valid: true`
- [ ] All required tables have records in migration.sql
- [ ] Building name and address are correct
- [ ] Unit count matches source data
- [ ] Leaseholder count matches source data
- [ ] All 316 documents classified in document_log.csv
- [ ] Compliance assets detected (12+ expected)
- [ ] Major works projects found (if applicable)
- [ ] Financial years extracted (if applicable)
- [ ] SQL executes without errors in Supabase staging
- [ ] Frontend displays all data correctly
- [ ] Foreign key relationships maintained
- [ ] No orphaned records
- [ ] Dates in correct format and valid
- [ ] Compliance findings and actions visible
- [ ] Major works costs and timelines accurate

---

## 🔧 Advanced Validation

### Manual SQL Queries to Verify Data

After executing migration.sql in Supabase:

```sql
-- Check building was created
SELECT * FROM buildings WHERE name = 'Your Building Name';

-- Count units
SELECT COUNT(*) FROM units WHERE building_id = 'your-building-uuid';

-- Check leaseholder linkage
SELECT u.unit_number, l.name, l.email
FROM units u
LEFT JOIN leaseholders l ON l.unit_id = u.id
WHERE u.building_id = 'your-building-uuid';

-- Verify compliance assets
SELECT asset_name, asset_type, last_inspection_date, next_due_date, status
FROM compliance_assets
WHERE building_id = 'your-building-uuid';

-- Check compliance inspections have findings
SELECT ca.asset_name, ci.inspection_date, ci.findings, ci.actions_required
FROM compliance_inspections ci
JOIN compliance_assets ca ON ca.id = ci.asset_id
WHERE ca.building_id = 'your-building-uuid';

-- Verify major works
SELECT project_name, project_type, estimated_cost, start_date, status
FROM major_works_projects
WHERE building_id = 'your-building-uuid';

-- Check financial data
SELECT financial_year, total_budget, status
FROM budgets
WHERE building_id = 'your-building-uuid';
```

---

## 📊 Data Completeness Score

The system extracts data for **9 core tables**:

1. ✅ buildings (1 record expected)
2. ✅ units (variable, based on building size)
3. ✅ leaseholders (variable, typically ≥ units)
4. ✅ building_documents (should match file count)
5. ✅ compliance_assets (12+ for comprehensive properties)
6. ✅ compliance_inspections (≥ assets)
7. ✅ major_works_projects (0-10+ depending on history)
8. ✅ budgets (0-5 recent years)
9. ✅ service_charge_years (0-5 recent years)

**Target**: All 9 tables populated with accurate data

---

## 🎓 Understanding the Validation Flow

```
┌─────────────────┐
│  Parse Files    │  ← Extract text from all documents
└────────┬────────┘
         │
┌────────▼────────┐
│  Classify       │  ← Categorize each document
└────────┬────────┘
         │
┌────────▼────────┐
│  Extract Data   │  ← Pull structured data from documents
└────────┬────────┘
         │
┌────────▼────────┐
│  Map to Schema  │  ← Convert to Supabase format
└────────┬────────┘
         │
┌────────▼────────┐
│  Validate ★     │  ← CHECK SCHEMA COMPLIANCE (NEW!)
└────────┬────────┘
         │
┌────────▼────────┐
│  Generate SQL   │  ← Create INSERT statements
└────────┬────────┘
         │
┌────────▼────────┐
│  Review & Test  │  ← Manual verification
└────────┬────────┘
         │
┌────────▼────────┐
│  Execute in DB  │  ← Run in Supabase
└────────┬────────┘
         │
┌────────▼────────┐
│  Verify in App  │  ← Check frontend displays correctly
└─────────────────┘
```

The **Validate** step (marked with ★) is your safety net before SQL generation.

---

## 💡 Pro Tips

1. **Always use staging environment first** - Test SQL execution before production
2. **Keep original documents** - Upload to Supabase Storage after SQL import
3. **Review validation_report.json** - This is your data quality checklist
4. **Spot-check random records** - Don't trust 100%, verify samples
5. **Use frontend to verify** - The application is the final test
6. **Document custom mappings** - If you modify extractors, note changes
7. **Run regression tests** - Use same test folder to verify improvements

---

## 📞 Support

If validation fails or data doesn't appear correctly in the application:

1. Check validation_report.json for specific errors
2. Review migration.sql for obvious issues
3. Test SQL in Supabase staging environment
4. Query database directly to verify records exist
5. Check frontend console for API errors
6. Verify Supabase schema matches onboarder expectations

---

## 🎉 Success Criteria

Data is correctly captured when:

✅ validation_report.json shows no errors
✅ All SQL statements execute successfully
✅ Frontend displays all building details
✅ All units and leaseholders visible
✅ All 316 documents listed and categorized
✅ Compliance section shows assets with inspection history
✅ Major works projects appear with full details
✅ Financial data displays correctly
✅ No console errors in frontend
✅ Data matches source documents when spot-checked

**You now have the best property onboarding system in the industry! 🏆**
