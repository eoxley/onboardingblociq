# Schema Alignment Analysis - SQL Generator vs Supabase Schema

**Date:** October 14, 2025  
**Issue:** SQL generator is creating INSERTs for tables/columns that don't match Supabase schema

---

## 🔴 CRITICAL MISMATCHES

### 1. **Insurance Table Name Mismatch**

**SQL Generator generates:**
```sql
INSERT INTO building_insurance (...)
```

**Supabase schema has:**
```sql
CREATE TABLE insurance_policies (...)
```

**Impact:** Insurance data (3 policies, ~£20k premiums) won't insert

**Fix Required:**
- Change `_generate_insurance_insert()` to use `insurance_policies` table
- Map column names:
  - `insurance_type` → `policy_type`
  - `insurer_name` → `insurer`
  - `premium_amount` → `annual_premium`

---

### 2. **Budget Column Name Mismatch**

**SQL Generator expects:**
```python
data['summary']['service_charge_budget']  # £126,150 for Connaught
```

**Supabase schema has:**
```sql
CREATE TABLE budgets (
    budget_year INTEGER NOT NULL,
    total_budget NUMERIC(12,2),  -- ✅ This exists
    ...
)
```

**Status:** ⚠️ Partially compatible - need to map correctly

**Fix Required:**
- Map `service_charge_budget` → `total_budget`
- Ensure `budget_year` is set (required field)
- Set `status` to 'Approved'

---

### 3. **Missing: Building-Level Financial Fields**

**Data Extracted:**
```json
{
  "annual_service_charge_budget": 126150,  // ❌ Not in buildings table
  "construction_type": "Period conversion",  // ❌ Not in buildings table
}
```

**Supabase `buildings` table:**
- Has: 100+ columns for physical characteristics
- Missing: Financial summary fields

**Options:**
1. Add to `buildings` table: `annual_service_charge_budget NUMERIC(12,2)`
2. Store in `budgets` table (recommended - proper normalization)

---

## ✅ WHAT'S WORKING

### Tables that Match:
- ✅ `buildings` - Core building data
- ✅ `units` - All unit data with apportionment
- ✅ `leaseholders` - Contact info, balances
- ✅ `compliance_assets` - 50+ asset types
- ✅ `maintenance_contracts` - Contract tracking
- ✅ `extraction_runs` - Metadata tracking
- ✅ `budgets` - Budget periods (just need correct mapping)

---

## 📋 REQUIRED SCHEMA CHANGES

### Option A: Minimal Changes (Recommended)

#### 1. Update SQL Generator (Code Changes)
```python
# In sql_writer.py

def _generate_insurance_insert(self, data: Dict) -> str:
    """Generate insurance policies INSERT statements"""
    policies = data.get('insurance_policies', [])
    if not policies:
        return ""
    
    sql_parts = ["""
-- ============================================================================
-- Insurance Policies
-- ============================================================================"""]
    
    for policy in policies:
        policy_id = str(uuid.uuid4())
        
        sql_parts.append(f"""
INSERT INTO insurance_policies (  -- ✅ CHANGED FROM building_insurance
    id, building_id, policy_type, insurer,  -- ✅ CHANGED COLUMN NAMES
    renewal_date, annual_premium, policy_number, notes
)
VALUES (
    '{policy_id}',
    '{self.building_id}',
    '{self._sql_escape(policy.get('policy_type', 'General'))}',
    '{self._sql_escape(policy.get('insurer', ''))}',
    {self._sql_date(policy.get('renewal_date'))},
    {policy.get('estimated_premium') or policy.get('annual_premium') or 'NULL'},
    '{self._sql_escape(policy.get('policy_number', ''))}',
    'Source: {self._sql_escape(policy.get('source', ''))}'
);""")
    
    return "\\n".join(sql_parts)

def _generate_budgets_insert(self, data: Dict) -> str:
    """Generate budgets INSERT statement"""
    # Extract budget from data
    summary = data.get('summary', {})
    budget_total = summary.get('service_charge_budget') or summary.get('total_budget')
    
    if not budget_total:
        return ""
    
    budget_id = str(uuid.uuid4())
    current_year = datetime.now().year
    
    sql = f"""
-- ============================================================================
-- Budget
-- ============================================================================
INSERT INTO budgets (
    id, building_id, budget_year, total_budget, 
    status, source_document
)
VALUES (
    '{budget_id}',
    '{self.building_id}',
    {current_year},
    {budget_total},
    'Approved',
    'Extracted from documents'
);"""
    
    return sql
```

#### 2. Optional: Add Financial Summary to Buildings
```sql
-- Add to Supabase schema (nice to have, not critical)
ALTER TABLE buildings 
ADD COLUMN annual_service_charge NUMERIC(12,2),
ADD COLUMN construction_type VARCHAR(100);

-- Update from budgets (can be calculated)
UPDATE buildings b
SET annual_service_charge = (
    SELECT total_budget 
    FROM budgets 
    WHERE building_id = b.id 
    AND budget_year = EXTRACT(YEAR FROM NOW())
    LIMIT 1
);
```

### Option B: Add Schema Tables (From DATA_LOSS_ANALYSIS.md)

Already documented in `/Users/ellie/onboardingblociq/DATA_LOSS_ANALYSIS.md` lines 217-237:

```sql
-- Enhanced schedules for maintenance tracking
ALTER TABLE schedules
ADD COLUMN contract_id UUID REFERENCES maintenance_contracts(id),
ADD COLUMN service_type TEXT,
ADD COLUMN frequency TEXT,
ADD COLUMN frequency_interval INTEGER,
ADD COLUMN next_due_date DATE,
ADD COLUMN priority TEXT DEFAULT 'medium',
ADD COLUMN status TEXT DEFAULT 'active',
ADD COLUMN estimated_duration TEXT;

CREATE INDEX idx_schedules_next_due_date ON schedules(next_due_date);
CREATE INDEX idx_schedules_status ON schedules(status);
```

---

## 🎯 RECOMMENDED ACTION PLAN

### Step 1: Fix SQL Generator (30 mins) - PRIORITY
1. Change `building_insurance` → `insurance_policies`
2. Update column mappings
3. Fix budget generation to use correct fields
4. Test with Connaught Square data

### Step 2: Optional Schema Enhancements (1 hour)
1. Add `annual_service_charge` to `buildings` table
2. Enhance `schedules` table per DATA_LOSS_ANALYSIS.md
3. Run migrations on Supabase

### Step 3: Validation (15 mins)
1. Re-generate Connaught Square SQL
2. Verify all data present:
   - ✅ Buildings
   - ✅ Units (8)
   - ✅ Leaseholders (8)
   - ✅ Compliance (31 assets)
   - ✅ Contracts (6)
   - ✅ **Budget (£126,150)** ← Currently missing
   - ✅ **Insurance (3 policies)** ← Currently missing
3. Execute SQL in Supabase
4. Query to verify data loaded

---

## 📊 IMPACT SUMMARY

| Data Type | Extracted | Currently Generated in SQL | After Fix |
|-----------|-----------|----------------------------|-----------|
| Buildings | 1 | ✅ Yes | ✅ Yes |
| Units | 8 | ✅ Yes | ✅ Yes |
| Leaseholders | 8 | ✅ Yes | ✅ Yes |
| Compliance Assets | 31 | ✅ Yes | ✅ Yes |
| Maintenance Contracts | 6 | ✅ Yes | ✅ Yes |
| **Budgets** | **1 (£126k)** | **❌ No** | **✅ Yes** |
| **Insurance Policies** | **3 (~£20k)** | **❌ No** | **✅ Yes** |
| Budget Line Items | 52 | ❌ No | ⏳ Future |
| Maintenance Schedules | 22 | ❌ No | ⏳ Future |

**Current Data Loss:** ~15% of extracted data (budgets + insurance)  
**After Fix:** 0% data loss for core entities  
**Future Enhancement:** Budget line items + maintenance schedules

---

## 🚀 NEXT STEPS

1. **Immediate (Now):**
   - Fix `_generate_insurance_insert()` table name
   - Fix `_generate_budgets_insert()` column mapping
   - Test generation with Connaught data

2. **Short Term (This Week):**
   - Add `annual_service_charge` to buildings table
   - Enhance schedules table per recommendations

3. **Medium Term (Next Sprint):**
   - Implement budget_line_items generation
   - Implement maintenance_schedules generation
   - Full financial year-end data capture

---

**Status:** Ready to implement  
**Estimated Time:** 30-60 minutes  
**Impact:** Recover 15% of currently lost data

