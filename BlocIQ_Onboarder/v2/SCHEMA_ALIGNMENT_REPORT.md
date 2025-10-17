# 🔍 Schema Alignment Report - SQL Generator vs Supabase

**Date:** 17 October 2025  
**Purpose:** Ensure SQL generator creates 100% Supabase-compatible SQL  
**Priority:** CRITICAL - Must work instantly without errors

---

## 🔴 CRITICAL MISMATCHES FOUND

### **BUILDINGS TABLE**

| SQL Generator Uses | Supabase Schema Has | Status | Fix Needed |
|-------------------|---------------------|--------|------------|
| `name` | `building_name` | ❌ MISMATCH | Change to building_name |
| `address` | `building_address` | ❌ MISMATCH | Change to building_address |
| `number_of_units` | `num_units` | ❌ MISMATCH | Change to num_units |
| `number_of_floors` | `num_floors` | ❌ MISMATCH | Change to num_floors |
| `has_basement` | ❌ NOT IN SCHEMA | ❌ REMOVE | Column doesn't exist |
| `is_hrb` | ❌ NOT IN SCHEMA | ❌ REMOVE | Use bsa_registration_required |
| `sc_year_start` | ❌ NOT IN SCHEMA | ❌ REMOVE | Goes in budgets table |
| `sc_year_end` | ❌ NOT IN SCHEMA | ❌ REMOVE | Goes in budgets table |
| `construction_type` | `construction_type` | ✅ OK | No change |
| `building_height_meters` | `building_height_meters` | ✅ OK | No change |
| `bsa_status` | `bsa_status` | ✅ OK | No change |
| `postcode` | `postcode` | ✅ OK | No change |

**Action:** Fix 8 columns in buildings INSERT

---

### **UNITS TABLE**

| SQL Generator Uses | Supabase Schema Has | Status | Fix Needed |
|-------------------|---------------------|--------|------------|
| `leaseholder_name` | ❌ NOT IN SCHEMA | ❌ REMOVE | Goes in leaseholders table |
| `correspondence_address` | ❌ NOT IN SCHEMA | ❌ REMOVE | Goes in leaseholders table |
| `apportionment` | `apportionment_percentage` | ✅ OK | Already correct |
| `unit_number` | `unit_number` | ✅ OK | No change |
| `floor_number` | `floor_number` | ✅ OK | No change |
| `building_id` | `building_id` | ✅ OK | No change |

**Action:** Remove leaseholder_name and correspondence_address, create proper leaseholders table INSERTs

---

### **BUDGETS TABLE**

| SQL Generator Uses | Supabase Schema Has | Status | Fix Needed |
|-------------------|---------------------|--------|------------|
| `total_amount` | `total_budget` | ❌ MISMATCH | Change to total_budget |
| `sc_year_start` | `budget_period_start` | ❌ MISMATCH | Change to budget_period_start |
| `sc_year_end` | `budget_period_end` | ❌ MISMATCH | Change to budget_period_end |
| `budget_year` | `budget_year` | ✅ OK | No change |
| `status` | `status` | ✅ OK | No change |
| `building_id` | `building_id` | ✅ OK | No change |

**Action:** Fix 3 columns in budgets INSERT

---

### **MISSING TABLES IN SQL GENERATOR**

| SQL Generator Creates | Actual Supabase Table | Status | Fix Needed |
|----------------------|----------------------|--------|------------|
| `apportionments` | ❌ NO TABLE | ❌ REMOVE | Data goes in units.apportionment_percentage |
| `asset_register` | ❌ NO TABLE | ⚠️ CHECK | Might be compliance_assets or separate table |
| `contracts` | `maintenance_contracts` | ❌ MISMATCH | Use maintenance_contracts |
| `accounts` | `leaseholder_accounts` OR `service_charge_accounts` | ⚠️ CHECK | Verify table name |

**Action:** Update table names, remove apportionments, check asset_register

---

## 🔗 FOREIGN KEY RELATIONSHIPS

### **Correct Dependency Order:**

```sql
1. agencies (optional - can skip for now)
2. users (optional - can skip for now)
3. buildings ← START HERE (no dependencies)
4. units (needs building_id)
5. leaseholders (needs unit_id)
6. budgets (needs building_id)
7. budget_line_items (needs budget_id)
8. compliance_assets (needs building_id, asset_type_id)
9. maintenance_contracts (needs building_id)
10. leases (needs building_id, unit_id, leaseholder_id, document_id)
11. lease_clauses (needs lease_id)
12. insurance_policies (needs building_id)
```

**Current SQL Generator Order:** ✅ Mostly correct (buildings first, then children)

---

## ✅ CORRECT SCHEMA STRUCTURE

### **Buildings** (Parent - No dependencies)
```sql
INSERT INTO buildings (
    id,
    building_name,              -- NOT "name"
    building_address,           -- NOT "address"  
    postcode,
    num_units,                  -- NOT "number_of_units"
    num_floors,                 -- NOT "number_of_floors"
    building_height_meters,
    bsa_registration_required,  -- NOT "is_hrb"
    bsa_status,
    construction_type
)
```

### **Units** (Child of buildings)
```sql
INSERT INTO units (
    id,
    building_id,                -- FK to buildings
    unit_number,
    floor_number,
    apportionment_percentage,   -- Store percentage directly here!
    unit_type
)
```

### **Leaseholders** (Child of units)
```sql
INSERT INTO leaseholders (
    id,
    unit_id,                    -- FK to units
    full_name,                  -- Leaseholder name goes here!
    correspondence_address,     -- Address goes here!
    email,
    phone,
    mobile
)
```

### **Budgets** (Child of buildings)
```sql
INSERT INTO budgets (
    id,
    building_id,                -- FK to buildings
    budget_year,
    total_budget,               -- NOT "total_amount"
    budget_period_start,        -- NOT "sc_year_start"
    budget_period_end,          -- NOT "sc_year_end"
    status
)
```

### **Budget Line Items** (Child of budgets)
```sql
INSERT INTO budget_line_items (
    id,
    budget_id,                  -- FK to budgets
    category,
    description,
    budgeted_amount
)
```

### **Maintenance Contracts** (Child of buildings)
```sql
INSERT INTO maintenance_contracts (  -- NOT "contracts"
    id,
    building_id,                -- FK to buildings
    contractor_name,
    service_type,
    start_date,
    end_date
)
```

### **Compliance Assets** (Child of buildings)
```sql
INSERT INTO compliance_assets (
    id,
    building_id,                -- FK to buildings
    asset_type_id,              -- FK to compliance_asset_types (optional)
    inspection_date,
    next_due_date,
    status,
    document_name
)
```

### **Insurance Policies** (Child of buildings)
```sql
INSERT INTO insurance_policies (
    id,
    building_id,                -- FK to buildings
    policy_type,
    insurer_name,
    premium_amount,
    renewal_date
)
```

---

## 🔧 REQUIRED FIXES

### **Priority 1: Fix Column Names**
- [ ] buildings.name → building_name
- [ ] buildings.address → building_address
- [ ] buildings.number_of_units → num_units
- [ ] buildings.number_of_floors → num_floors
- [ ] budgets.total_amount → total_budget
- [ ] budgets.sc_year_start → budget_period_start
- [ ] budgets.sc_year_end → budget_period_end

### **Priority 2: Remove Invalid Columns**
- [ ] buildings.has_basement (doesn't exist in schema)
- [ ] buildings.is_hrb (use bsa_registration_required instead)
- [ ] buildings.sc_year_start (goes in budgets)
- [ ] buildings.sc_year_end (goes in budgets)

### **Priority 3: Fix Table Names**
- [ ] contracts → maintenance_contracts
- [ ] Remove separate apportionments table (data in units.apportionment_percentage)

### **Priority 4: Create Missing INSERTs**
- [ ] Add leaseholders table INSERTs (separate from units)
- [ ] Add insurance_policies INSERTs
- [ ] Verify lease_clauses structure

### **Priority 5: Verify Relationships**
- [ ] All units have building_id
- [ ] All budgets have building_id
- [ ] All compliance_assets have building_id
- [ ] All leaseholders have unit_id
- [ ] All leases have building_id, unit_id, leaseholder_id

---

## 📋 INSERTION ORDER (Critical!)

```sql
-- Step 1: Parent (no dependencies)
INSERT INTO buildings (...);

-- Step 2: Direct children of buildings
INSERT INTO units (building_id, ...);
INSERT INTO budgets (building_id, ...);
INSERT INTO compliance_assets (building_id, ...);
INSERT INTO maintenance_contracts (building_id, ...);
INSERT INTO insurance_policies (building_id, ...);

-- Step 3: Children of units
INSERT INTO leaseholders (unit_id, ...);

-- Step 4: Children of budgets
INSERT INTO budget_line_items (budget_id, ...);

-- Step 5: Complex relationships
INSERT INTO leases (building_id, unit_id, leaseholder_id, ...);
INSERT INTO lease_clauses (lease_id, ...);
```

**Current Generator:** Needs reordering!

---

## 🎯 EXPECTED OUTCOME

After fixes, the generated SQL will:
- ✅ Use correct column names (building_name not name)
- ✅ Use correct table names (maintenance_contracts not contracts)
- ✅ Insert in correct order (parent → children)
- ✅ Link all data via building_id
- ✅ Handle all foreign key relationships
- ✅ Work instantly in Supabase (no errors!)

---

**Status:** DOCUMENTED - Ready to implement fixes  
**Next:** Fix sql_generator_v2.py to match schema exactly

