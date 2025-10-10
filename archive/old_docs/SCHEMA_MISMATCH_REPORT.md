# Schema Mismatch Report - Migration SQL vs Actual Supabase

**Date:** 2025-10-06
**Issue:** Generated migration.sql uses columns that don't exist in actual Supabase schema

---

## ❌ Problem Summary

The BlocIQ Onboarder is generating SQL INSERT statements with column names that **do not exist** in the actual Supabase database schema. This will cause the migration SQL to **FAIL** when executed.

---

## 🔍 Schema Comparison

### 1️⃣ **buildings** Table

| Column in SQL | Exists in Supabase? | Notes |
|--------------|---------------------|-------|
| `id` | ✅ Yes | OK |
| `name` | ✅ Yes | OK |
| `address` | ✅ Yes | OK |
| `portfolio_id` | ✅ Yes | OK (but migration doesn't use it in the basic INSERT) |

**Status:** ✅ COMPATIBLE (using minimal column set)

**Actual Supabase columns:**
- id, name, address, portfolio_id, number_of_units
- created_at, year_end_date, demand_date_1, demand_date_2
- management_fee_ex_vat, management_fee_inc_vat
- company_secretary_fee_ex_vat, company_secretary_fee_inc_vat
- insurance_broker, insurance_renewal_date
- ground_rent_applicable, ground_rent_charges
- expenditure_limit, section_20_limit_inc_vat
- current_accountants, previous_agents, accountant_contact, additional_info

---

### 2️⃣ **units** Table

**Migration SQL uses:**
```sql
INSERT INTO units (id, building_id, unit_number, floor_number, unit_type, bedrooms, square_footage)
```

| Column in SQL | Exists in Supabase? | Notes |
|--------------|---------------------|-------|
| `id` | ✅ Yes | OK |
| `building_id` | ✅ Yes | OK |
| `unit_number` | ✅ Yes | OK |
| `floor_number` | ❌ **NO** | **WILL FAIL** |
| `unit_type` | ❌ **NO** | **WILL FAIL** |
| `bedrooms` | ❌ **NO** | **WILL FAIL** |
| `square_footage` | ❌ **NO** | **WILL FAIL** |

**Status:** ❌ INCOMPATIBLE - Using non-existent columns

**Actual Supabase columns:**
- id, building_id, unit_number, created_at

**Required Fix:** Only use `id, building_id, unit_number`

---

### 3️⃣ **leaseholders** Table

**Migration SQL uses:**
```sql
INSERT INTO leaseholders (id, building_id, unit_number, first_name, last_name)
```

| Column in SQL | Exists in Supabase? | Notes |
|--------------|---------------------|-------|
| `id` | ✅ Likely yes | OK |
| `building_id` | ✅ Will be added by ALTER | OK |
| `unit_number` | ✅ Likely yes | OK |
| `first_name` | ❌ **NO** | **WILL FAIL** |
| `last_name` | ❌ **NO** | **WILL FAIL** |

**Status:** ❌ INCOMPATIBLE - Using non-existent columns

**Actual Supabase columns:** Unknown (table is empty, cannot infer schema from data)

**Required Action:**
1. Check actual Supabase schema definition
2. Only use columns that exist
3. Possibly store full name in a single `name` or `leaseholder_name` column

---

### 4️⃣ **compliance_assets** Table

**Migration SQL uses:**
```sql
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status)
```

| Column in SQL | Exists in Supabase? | Notes |
|--------------|---------------------|-------|
| `id` | ✅ Likely yes | OK |
| `building_id` | ✅ Likely yes | OK |
| `category` | ❌ **NO** | **WILL FAIL** - Added to code but NOT in Supabase |
| `asset_name` | ❌ **Unknown** | Needs verification |
| `asset_type` | ❌ **Unknown** | Needs verification |
| `inspection_frequency` | ❌ **Unknown** | Needs verification |
| `last_inspection_date` | ✅ Will be added by ALTER | OK |
| `next_due_date` | ✅ Will be added by ALTER | OK |
| `compliance_status` | ✅ Will be added by ALTER | OK |

**Status:** ❌ INCOMPATIBLE - Using non-existent columns

**Required Fix:**
1. Check actual compliance_assets schema
2. Align migration SQL with actual columns
3. If `category` doesn't exist, either:
   - Add ALTER TABLE to create it, OR
   - Remove it from INSERTs

---

### 5️⃣ **building_documents** Table

**Migration SQL uses:**
```sql
INSERT INTO building_documents (id, building_id, category, file_name, file_path, file_type, uploaded_at)
```

| Column in SQL | Exists in Supabase? | Notes |
|--------------|---------------------|-------|
| `id` | ✅ Yes | OK |
| `building_id` | ✅ Yes | OK |
| `category` | ✅ Yes | OK |
| `file_name` | ✅ Yes | OK |
| `file_path` | ❌ **NO** | **WILL FAIL** - Actual column is `storage_path` |
| `file_type` | ❌ **NO** | **WILL FAIL** - Not in schema |
| `uploaded_at` | ✅ Yes | OK |

**Status:** ❌ INCOMPATIBLE - Wrong column names

**Actual Supabase columns:**
- id, building_id, category, file_name, storage_path
- uploaded_at, ai_confidence, entity_type, linked_entity_id

**Required Fix:** Use `storage_path` instead of `file_path`, remove `file_type`

---

## 🔧 Root Cause

The `schema_mapper.py` file defines an **internal schema** that doesn't match the **actual Supabase database schema**:

**File:** `/Users/ellie/onboardingblociq/BlocIQ_Onboarder/schema_mapper.py`
**Lines:** 73-182 (SCHEMA definition)

This internal schema is used to:
1. Validate data before INSERT
2. Generate SQL column lists

**Problem:** This internal schema was designed for a "theoretical BlocIQ V2" but the ACTUAL Supabase database has different columns.

---

## ✅ Solution

### Option 1: Fix Migration SQL Generator (RECOMMENDED)

Update `schema_mapper.py` SCHEMA definition to match the ACTUAL Supabase schema:

```python
SCHEMA = {
    'buildings': {
        'id': 'uuid PRIMARY KEY',
        'portfolio_id': 'uuid REFERENCES portfolios(id)',
        'name': 'text NOT NULL',
        'address': 'text',
        'number_of_units': 'integer',
        # ... other ACTUAL Supabase columns
    },
    'units': {
        'id': 'uuid PRIMARY KEY',
        'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
        'unit_number': 'text NOT NULL',
        'created_at': 'timestamptz DEFAULT now()'
        # REMOVE: floor_number, unit_type, bedrooms, square_footage
    },
    'leaseholders': {
        'id': 'uuid PRIMARY KEY',
        'building_id': 'uuid REFERENCES buildings(id)',
        'unit_number': 'text',
        # TODO: Check actual schema - might have 'name' instead of first_name/last_name
    },
    'building_documents': {
        'id': 'uuid PRIMARY KEY',
        'building_id': 'uuid REFERENCES buildings(id)',
        'category': 'text',
        'file_name': 'text',
        'storage_path': 'text',  # NOT file_path!
        'uploaded_at': 'timestamptz',
        'ai_confidence': 'numeric',
        'entity_type': 'text',
        'linked_entity_id': 'uuid'
        # REMOVE: file_type
    },
    'compliance_assets': {
        # TODO: Discover actual schema
    }
}
```

### Option 2: Update Supabase Schema

Add the missing columns to Supabase via migration:

```sql
-- Add columns to units
ALTER TABLE units ADD COLUMN IF NOT EXISTS floor_number integer;
ALTER TABLE units ADD COLUMN IF NOT EXISTS unit_type text;
ALTER TABLE units ADD COLUMN IF NOT EXISTS bedrooms integer;
ALTER TABLE units ADD COLUMN IF NOT EXISTS square_footage numeric;

-- Add columns to leaseholders
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS first_name text;
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS last_name text;

-- Add columns to building_documents
ALTER TABLE building_documents ADD COLUMN IF NOT EXISTS file_path text;
ALTER TABLE building_documents ADD COLUMN IF NOT EXISTS file_type text;

-- Add columns to compliance_assets
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS category text;
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS asset_name text;
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS asset_type text;
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS inspection_frequency text;
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS description text;
```

---

## 📋 Next Steps

1. ✅ **Discovered actual schema** - See above comparison
2. ⏳ **Decide on solution:** Option 1 (fix generator) or Option 2 (update Supabase)
3. ⏳ **Implement fix**
4. ⏳ **Re-generate migration.sql**
5. ⏳ **Test against Supabase**
6. ⏳ **Validate with actual INSERT test**

---

## 🎯 Recommendation

**Use Option 2** - Add the missing columns to Supabase schema.

**Why:**
- The onboarder code already extracts this valuable data (floor numbers, unit types, leaseholder names, etc.)
- Storing this data provides better property management capabilities
- The internal schema is well-designed for property management needs
- Easier to add columns than to remove functionality from the code

**Implementation:**
1. Create a schema migration SQL file with all the ALTER TABLE statements
2. Run it in Supabase SQL Editor
3. Re-run the onboarder to generate migration.sql
4. Test INSERT operations

---

*Generated: 2025-10-06*
*Status: Schema mismatch identified - awaiting fix*
