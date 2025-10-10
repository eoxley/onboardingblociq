# 🔧 Schema Migration Guide - BlocIQ Onboarder

**Status:** In Progress
**Target:** Align SQL generator with actual Supabase production schema

---

## ✅ Completed Changes

### 1. Buildings Table
- ✅ Removed `portfolio_id` reference
- ✅ Updated to match production schema with proper fields

### 2. Leaseholders Table
- ✅ Changed from `name` (single field) → `first_name`, `last_name` (separate)
- ✅ Changed from `unit_id` (UUID) → `unit_number` (TEXT)
- ✅ Removed `correspondence_address`, added `notes`
- ✅ Added all missing fields (title, phone, mobile, lease_start_date, etc.)

---

## ⚠️ Pending Changes (Breaking Changes - Requires Testing)

### 3. Rename Tables

**Current Name** → **Production Name**

1. `building_contractors` → `contractor_contracts`
2. `major_works_projects` → `major_works`

### 4. Remove Non-Existent Tables

The following tables DON'T exist in production and should NOT be generated:

- ❌ `portfolios` - Manually managed
- ❌ `apportionments` - Not in schema
- ❌ `major_works_notices` - Not in schema
- ❌ `building_keys_access` - Now `building_knowledge`

---

## 📋 Required Code Changes

### A. Update `schema_mapper.py`

**Line 123:** Rename table definition
```python
# OLD
'major_works_projects': {

# NEW
'major_works': {
```

**Line 147-155:** Remove apportionments table entirely
```python
# DELETE THIS ENTIRE SECTION
'apportionments': { ... }
```

**Line 156-164:** Remove major_works_notices table
```python
# DELETE THIS ENTIRE SECTION
'major_works_notices': { ... }
```

**Line 190:** Rename table definition
```python
# OLD
'building_contractors': {

# NEW
'contractor_contracts': {
    'id': 'uuid PRIMARY KEY',
    'building_id': 'uuid REFERENCES buildings(id)',
    'contractor_id': 'uuid REFERENCES contractors(id)',  # ADD THIS
    'service_category': 'text NOT NULL',
    'contract_value': 'numeric',
    'payment_frequency': 'text',
    'start_date': 'date NOT NULL',
    'end_date': 'date NOT NULL',
    'notice_period_days': 'integer DEFAULT 90',
    'is_active': 'boolean DEFAULT true',
    'notes': 'text',
    'retender_status': 'text DEFAULT not_scheduled',
    'retender_due_date': 'date',
    'next_review_date': 'date',
    'renewal_notice_period': 'interval DEFAULT interval \'90 days\'',
    'created_at': 'timestamp with time zone DEFAULT now()',
    'updated_at': 'timestamp with time zone DEFAULT now()'
}
```

**Line 260-272:** Remove building_keys_access table
```python
# DELETE THIS ENTIRE SECTION
'building_keys_access': { ... }
```

---

### B. Update `sql_writer.py`

**Line 185-187:** Remove portfolio insert
```python
# DELETE THESE LINES
INSERT INTO portfolios (id, agency_id, name)
VALUES ('{self.portfolio_id}', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')
ON CONFLICT (id) DO NOTHING;
```

**Line 204-214:** Remove portfolio_id from building insert
```python
# OLD
def _generate_building_insert(self, building: Dict):
    building_with_portfolio = building.copy()
    building_with_portfolio['portfolio_id'] = self.portfolio_id

# NEW
def _generate_building_insert(self, building: Dict):
    # portfolio_id removed - not in production schema
```

**Rename methods:**
- `_generate_building_contractors_inserts()` → `_generate_contractor_contracts_inserts()`
- References to `building_contractors` → `contractor_contracts`
- References to `major_works_projects` → `major_works`

**Remove methods:**
- `_generate_apportionments_inserts()`
- `_generate_major_works_notices_inserts()`
- `_generate_building_keys_access_inserts()`

---

### C. Update `mapper.py`

Search for all references to renamed/removed tables and update:

```bash
grep -r "building_contractors" BlocIQ_Onboarder/
grep -r "major_works_projects" BlocIQ_Onboarder/
grep -r "apportionments" BlocIQ_Onboarder/
```

---

### D. Update Leaseholder Mapping Logic

**File:** `schema_mapper.py` line ~500-542

Current logic creates:
```python
{
    'unit_id': unit_map.get(unit_number),  # UUID
    'name': 'Derek Mason'  # Single field
}
```

Should create:
```python
{
    'unit_number': 'A1',  # TEXT not UUID
    'first_name': 'Derek',
    'last_name': 'Mason',
    'notes': 'Joint owners: Derek Mason & Peter Hayward'  # For multiple names
}
```

**Helper function needed:**
```python
def _parse_leaseholder_name(self, name_string: str) -> tuple:
    """
    Parse name into title, first_name, last_name

    Examples:
        'Derek Mason' → (None, 'Derek', 'Mason')
        'Mr Derek Mason' → ('Mr', 'Derek', 'Mason')
        'Derek Mason & Peter Hayward' → (None, 'Derek', 'Mason', 'Joint: Derek Mason & Peter Hayward')
    """
    import re

    # Handle multiple names
    if ' & ' in name_string or ' and ' in name_string:
        # Take first person, put full text in notes
        first_person = name_string.split(' & ')[0].split(' and ')[0]
        notes = f"Joint owners: {name_string}"
    else:
        first_person = name_string
        notes = None

    # Extract title
    titles = ['Mr', 'Mrs', 'Ms', 'Miss', 'Dr', 'Prof', 'Sir', 'Lady']
    title = None
    for t in titles:
        if first_person.startswith(t + ' '):
            title = t
            first_person = first_person[len(t)+1:]
            break

    # Split first/last name
    parts = first_person.strip().split()
    if len(parts) >= 2:
        first_name = parts[0]
        last_name = ' '.join(parts[1:])
    elif len(parts) == 1:
        first_name = parts[0]
        last_name = ''
    else:
        first_name = ''
        last_name = ''

    return title, first_name, last_name, notes
```

---

## 🧪 Testing Checklist

Before deploying these changes:

- [ ] Test SQL generation with sample building
- [ ] Verify leaseholder name parsing works correctly
- [ ] Confirm `contractor_contracts` table inserts work
- [ ] Verify `major_works` table inserts work
- [ ] Check that removed tables don't cause errors
- [ ] Test full onboarding workflow end-to-end
- [ ] Verify Supabase import succeeds

---

## 🚨 Breaking Changes Warning

**These changes will break existing workflows that depend on:**
1. Portfolio system
2. Apportionments table
3. Table names: `building_contractors`, `major_works_projects`
4. Leaseholder `name` field
5. Leaseholder `unit_id` UUID reference

**Migration strategy:**
1. Apply schema changes
2. Test with sample data
3. Update all dependent code
4. Run full integration test
5. Deploy to production

---

## 📝 Notes

- The contractor lifecycle tracking features we just added need to be preserved
- Building knowledge system should replace `building_keys_access`
- Consider adding migration SQL to update existing data if needed
