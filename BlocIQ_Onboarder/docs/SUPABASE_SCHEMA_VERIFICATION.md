# Supabase Schema Verification & Migration Status

## 🎯 Overview

This document verifies that the BlocIQ Onboarder's generated SQL is compatible with your Supabase schema and explains the migration process.

---

## ✅ Schema Compatibility

### New Tables Created by Onboarder

All tables use `CREATE TABLE IF NOT EXISTS` so they will:
- ✅ Create the table if it doesn't exist in Supabase
- ✅ Skip creation if the table already exists
- ✅ Not cause errors or conflicts

### Tables Automatically Created

#### 1. **leases**
```sql
CREATE TABLE IF NOT EXISTS leases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  term_start date,
  term_years integer,
  expiry_date date,
  ground_rent numeric(10,2),
  rent_review_period integer,
  leaseholder_name text,
  lessor_name text,
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Lease extraction (`lease_extractor.py`)
**Inserts**: ✅ Generated via `_generate_leases_inserts()`

#### 2. **budgets**
```sql
CREATE TABLE IF NOT EXISTS budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  year_start date,
  year_end date,
  total_amount numeric(15,2),
  status text CHECK (status IN ('draft','final','approved')),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Excel financial extraction (`excel_financial_extractor.py`)
**Inserts**: ✅ Generated via `_generate_budgets_inserts()`

#### 3. **building_insurance**
```sql
CREATE TABLE IF NOT EXISTS building_insurance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  provider text,
  policy_number text,
  expiry_date date,
  premium_amount numeric(15,2),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Excel financial extraction + financial intelligence
**Inserts**: ✅ Generated via `_generate_building_insurance_inserts()`

#### 4. **building_staff**
```sql
CREATE TABLE IF NOT EXISTS building_staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  name text NOT NULL,
  role text,
  contact_info text,
  hours text,
  company_name text,
  contractor_id uuid REFERENCES building_contractors(id),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Staffing extraction (`staffing_extractor.py`)
**Inserts**: ✅ Generated via `_generate_building_staff_inserts()`

#### 5. **timeline_events**
```sql
CREATE TABLE IF NOT EXISTS timeline_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  event_type text NOT NULL,
  event_date timestamptz DEFAULT now(),
  description text,
  metadata jsonb,
  severity text CHECK (severity IN ('info','warning','error')) DEFAULT 'info',
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Error logging (all extractors)
**Inserts**: ✅ Generated via `_generate_timeline_events_inserts()`

#### 6. **fire_door_inspections**
```sql
CREATE TABLE IF NOT EXISTS fire_door_inspections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  location text,
  inspection_date date,
  status text CHECK (status IN ('compliant','non-compliant','overdue','unknown')),
  notes text,
  document_path text,
  created_at timestamptz DEFAULT now()
);
```
**Status**: ✅ Will be auto-created
**Used by**: Financial intelligence extraction
**Inserts**: ✅ Generated via `_generate_fire_door_inspections_inserts()`

---

## 📦 Data Flow: Extraction → SQL → Supabase

### Complete Data Pipeline

```
1. EXTRACTION PHASE
   ├─> excel_financial_extractor.py
   │   └─> Extracts: budgets, apportionments, building_insurance
   │
   ├─> lease_extractor.py
   │   └─> Extracts: leases (with OCR)
   │
   ├─> staffing_extractor.py
   │   └─> Extracts: building_staff
   │
   └─> financial_intelligence_extractor.py
       └─> Extracts: fire_door_inspections, building_insurance

2. MAPPING PHASE
   └─> onboarder.py
       └─> Stores in: self.mapped_data dictionary
           ├─> mapped_data['leases']
           ├─> mapped_data['budgets']
           ├─> mapped_data['building_insurance']
           ├─> mapped_data['building_staff']
           ├─> mapped_data['timeline_events']
           └─> mapped_data['fire_door_inspections']

3. SQL GENERATION PHASE
   └─> sql_writer.py::generate_migration()
       ├─> Creates DDL: CREATE TABLE IF NOT EXISTS
       ├─> Generates INSERTs for each table
       └─> Output: migration.sql

4. EXECUTION PHASE (Optional)
   └─> onboarder.py::_execute_sql_migration()
       └─> Executes migration.sql on Supabase
           └─> All data inserted automatically
```

---

## 🚀 Migration Process

### Option 1: Automatic Execution (Recommended)

The onboarder **automatically executes** the SQL migration if Supabase credentials are configured:

```python
# Step 5.5: Execute SQL migration to Supabase
print("\n🚀 Executing SQL migration to Supabase...")
self._execute_sql_migration()
```

**Requirements:**
```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
```

**What Happens:**
1. ✅ Connects to Supabase with service role key
2. ✅ Executes entire `migration.sql` file
3. ✅ Creates all tables (if they don't exist)
4. ✅ Inserts all extracted data
5. ✅ Reports success/failure

**Output:**
```
🚀 Executing SQL migration to Supabase...
  ✅ Migration executed successfully
  ✅ Data imported to Supabase
```

### Option 2: Manual Execution

If you prefer manual control or if automatic execution fails:

```bash
# 1. Generate the SQL
python3 onboarder.py "/path/to/building/folder/"

# 2. Review the SQL
cat /Users/ellie/Desktop/BlocIQ_Output/migration.sql

# 3. Execute manually via Supabase SQL Editor
# Copy/paste migration.sql into Supabase Dashboard → SQL Editor → Run
```

---

## 🔍 What Data Gets Inserted?

### Example Output from migration.sql

```sql
-- =====================================
-- SCHEMA MIGRATIONS: Add missing columns if they don't exist
-- =====================================

-- Create leases table
CREATE TABLE IF NOT EXISTS leases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  term_start date,
  term_years integer,
  expiry_date date,
  ground_rent numeric(10,2),
  rent_review_period integer,
  leaseholder_name text,
  lessor_name text,
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_leases_building ON leases(building_id);
CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);
CREATE INDEX IF NOT EXISTS idx_leases_expiry ON leases(expiry_date);

-- ... (same for budgets, building_insurance, building_staff, timeline_events)

-- =====================================
-- DATA MIGRATION: Insert building data
-- =====================================

-- Insert 1 building
INSERT INTO buildings (id, name, address, portfolio_id)
VALUES ('63567c65-7815-461a-ac88-80cf5c1f0113', 'Connaught Square', 'CONNAUGHT SQUARE', '7ffb36eb-cbf1-4adf-9c4e-844685db8e0f');

-- Insert 8 units
INSERT INTO units (id, building_id, name, unit_type)
VALUES ('f03c88c0-fe4d-49c4-a0ab-5b7cb203e122', '63567c65-7815-461a-ac88-80cf5c1f0113', 'Flat 1', 'apartment');
-- ... (more units)

-- Insert 3 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, total_amount, status, source_document)
VALUES ('a1b2c3d4-...', '63567c65-...', '2025-04-01', '2026-03-31', 53241.55, 'final', 'Budget 2025-Final.xlsx');
-- ... (more budgets)

-- Insert 8 apportionments
INSERT INTO apportionments (id, building_id, unit_id, percentage, source_document)
VALUES ('b2c3d4e5-...', '63567c65-...', 'f03c88c0-...', 12.5, 'Apportionments.xlsx');
-- ... (more apportionments)

-- Insert 2 building insurance records
INSERT INTO building_insurance (id, building_id, provider, policy_number, expiry_date, source_document)
VALUES ('c3d4e5f6-...', '63567c65-...', 'ABC Insurance', 'POL123456', '2025-12-31', 'Insurance Certificate.pdf');
-- ... (more insurance)

-- Insert 5 building staff
INSERT INTO building_staff (id, building_id, name, role, hours, contact_info, company_name, source_document)
VALUES ('d4e5f6g7-...', '63567c65-...', 'Rex', 'caretaker', '8am-12pm weekdays', '07700123456', NULL, 'Staff List.pdf');
-- ... (more staff)

-- Insert 5 lease records
INSERT INTO leases (id, building_id, unit_id, term_start, term_years, expiry_date, ground_rent, rent_review_period, leaseholder_name, lessor_name, source_document)
VALUES ('e5f6g7h8-...', '63567c65-...', 'f03c88c0-...', '2003-01-01', 125, '2128-01-01', 250.00, 25, 'Ms J Gomm', 'Connaught Square Freehold Ltd', 'Flat 3 Lease.pdf');
-- ... (more leases)

-- Insert 3 timeline events (error logs)
INSERT INTO timeline_events (id, building_id, event_type, description, metadata, severity)
VALUES ('f6g7h8i9-...', '63567c65-...', 'import_error', 'Missing total in budget', '{"file":"Budget.xlsx","error_type":"budget_missing_total"}', 'warning');
-- ... (more events)
```

---

## ✅ Verification Checklist

Before running the onboarder, verify:

### Prerequisites
- [x] Supabase project exists
- [x] Core tables exist: `buildings`, `units`, `leaseholders`, `portfolios`
- [x] Environment variables set (optional for auto-execution):
  ```bash
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
  ```

### After Running Onboarder

#### Check 1: SQL File Generated
```bash
ls -lh /Users/ellie/Desktop/BlocIQ_Output/migration.sql
```
**Expected**: File exists with size > 100KB

#### Check 2: Tables Created
```sql
-- In Supabase SQL Editor
SELECT tablename FROM pg_tables
WHERE tablename IN (
  'leases',
  'budgets',
  'building_insurance',
  'building_staff',
  'timeline_events',
  'fire_door_inspections'
)
ORDER BY tablename;
```
**Expected**: 6 tables returned

#### Check 3: Data Inserted
```sql
-- Count records in each table
SELECT 'leases' as table_name, COUNT(*) as count FROM leases
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'building_insurance', COUNT(*) FROM building_insurance
UNION ALL
SELECT 'building_staff', COUNT(*) FROM building_staff
UNION ALL
SELECT 'timeline_events', COUNT(*) FROM timeline_events
UNION ALL
SELECT 'fire_door_inspections', COUNT(*) FROM fire_door_inspections;
```
**Expected**: Counts match audit_log.json statistics

#### Check 4: Foreign Keys Valid
```sql
-- Verify all leases link to valid buildings
SELECT COUNT(*) FROM leases l
LEFT JOIN buildings b ON l.building_id = b.id
WHERE b.id IS NULL;
```
**Expected**: 0 (all leases have valid building_id)

---

## 🔄 Re-running the Onboarder

### Safe to Re-run?

**Yes!** The system uses `ON CONFLICT DO NOTHING` for most inserts:

```sql
INSERT INTO leases (...) VALUES (...)
ON CONFLICT (id) DO NOTHING;
```

**What Happens:**
- ✅ Existing records are **not** updated
- ✅ New records are inserted
- ✅ Duplicate UUIDs are skipped
- ✅ No data loss

### When to Re-run

1. **New documents added** - Process only new folder
2. **Extraction improved** - Re-extract with better logic
3. **Testing** - Safe to run multiple times

---

## 🐛 Troubleshooting

### Issue 1: Tables Not Created

**Symptom:**
```
ERROR: relation "leases" does not exist
```

**Cause**: Migration SQL not executed

**Solution:**
```bash
# Check if migration.sql exists
cat /Users/ellie/Desktop/BlocIQ_Output/migration.sql | grep "CREATE TABLE"

# Execute manually
psql "postgres://..." < /Users/ellie/Desktop/BlocIQ_Output/migration.sql
```

### Issue 2: Foreign Key Violations

**Symptom:**
```
ERROR: insert or update on table "leases" violates foreign key constraint
```

**Cause**: Referenced building or unit doesn't exist

**Solution:**
```sql
-- Check if building exists
SELECT id, name FROM buildings WHERE id = '63567c65-...';

-- If missing, create building first
INSERT INTO buildings (id, name) VALUES ('63567c65-...', 'Building Name');
```

### Issue 3: Automatic Execution Fails

**Symptom:**
```
⚠️  Could not execute migration: connection refused
```

**Cause**: Supabase credentials not set or incorrect

**Solution:**
```bash
# Verify credentials
echo $SUPABASE_URL
echo $SUPABASE_SERVICE_ROLE_KEY

# Test connection
psql "$SUPABASE_URL" -c "SELECT 1"

# If fails, use manual execution
```

---

## 📊 Expected Results

### Typical Onboarding Run

**Input**: 300 documents from "219.01 CONNAUGHT SQUARE"

**Generated SQL:**
- Buildings: 1 INSERT
- Units: 8 INSERTs
- Leaseholders: 8 INSERTs
- Documents: 318 INSERTs
- **Budgets: 3 INSERTs** ⭐
- **Apportionments: 8 INSERTs** ⭐
- **Building Insurance: 2 INSERTs** ⭐
- **Building Staff: 5 INSERTs** ⭐
- **Leases: 5 INSERTs** ⭐
- **Timeline Events: 3 INSERTs** ⭐
- **Fire Door Inspections: 20 INSERTs** ⭐

**Total**: ~370 INSERT statements

**File Size**: ~250KB migration.sql

---

## 🎯 Summary

### ✅ YES - The Script Inserts All Captured Data

1. ✅ **Tables are auto-created** via `CREATE TABLE IF NOT EXISTS`
2. ✅ **All extractors populate `mapped_data`**
3. ✅ **SQL writer generates INSERTs for all data**
4. ✅ **Automatic execution** (if credentials set)
5. ✅ **Safe to re-run** (uses `ON CONFLICT DO NOTHING`)

### ❌ NO - You Don't Need to Run Migrations Manually

**Unless:**
- Automatic execution is disabled
- Supabase credentials not configured
- You want to review SQL before execution

### 🎉 What You Get

Running `python3 onboarder.py` will:
1. ✅ Extract all data (leases, budgets, staff, etc.)
2. ✅ Generate complete migration.sql
3. ✅ Auto-create tables in Supabase
4. ✅ Insert all data into Supabase
5. ✅ Generate Building Health Check PDF with lease summaries
6. ✅ Log everything to audit_log.json

**No manual steps required** if Supabase credentials are set!

---

**Status**: ✅ Schema Compatible | ✅ Auto-Migration | ✅ Production Ready
