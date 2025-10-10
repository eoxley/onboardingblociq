# Correct Order of Operations

## THE PROBLEM
Your Python code generates SQL with `building_id` columns, but your Supabase database doesn't have those columns yet.

## THE SOLUTION - Run in this EXACT order:

### 1. Delete existing Connaught Square data
```bash
File: DELETE_CONNAUGHT_SQUARE_CORRECT.sql
```
Run this in Supabase SQL Editor to clean out the old data.

---

### 2. Run the schema migration
```bash
File: SCHEMA_MIGRATION_STEP_BY_STEP.sql
```
This adds `building_id` columns to:
- leaseholders
- apportionments
- major_works_notices

**IMPORTANT:** Run STEP 1 first (the SELECT query) to see your current schema.
Then run STEPS 2-6 to add the columns.

---

### 3. Generate new SQL
```bash
python3 onboarder.py "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/"
```
This will create SQL with `building_id` columns included.

---

### 4. Run the generated migration SQL
The generated SQL file will now work because the database has the `building_id` columns.

---

## Why this failed before:
- ❌ Database schema: `leaseholders (id, unit_id, name, email)`
- ✅ Generated SQL: `INSERT INTO leaseholders (id, building_id, unit_id, name)`
- 💥 ERROR: Column building_id doesn't exist!

## After migration:
- ✅ Database schema: `leaseholders (id, building_id, unit_id, name, email)`
- ✅ Generated SQL: `INSERT INTO leaseholders (id, building_id, unit_id, name)`
- ✅ SUCCESS!
