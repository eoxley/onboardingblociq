# Data Loss Analysis - BlocIQ Onboarder

**Date:** October 10, 2025
**Building Analyzed:** Connaught Square
**Files Extracted:** 318 documents

---

## Executive Summary

**Total Data Points at Risk:** 36 records
**Percentage of Extracted Data:** ~0.3% (minimal impact)
**Critical Data Loss:** ⚠️ 22 maintenance schedules

---

## Detailed Findings

### 1. Assets Table - `service_frequency` Column

**Status:** Column does NOT exist in Supabase
**Impact:** 14 assets lose service frequency information
**Data Type:** Text (e.g., "annual", "monthly", "quarterly")

**Affected Assets:**
- Fire alarms with annual service schedules
- Lifts with quarterly maintenance
- Boilers with annual servicing
- Emergency lighting systems

**Workaround Options:**
- A) Add `service_frequency` column to `assets` table in Supabase
- B) Store in `notes` field as JSON: `{"service_frequency": "annual"}`
- C) Use `next_service_date` to imply frequency (less explicit)

**Recommendation:** **Option A** - Add column to preserve structured data

---

### 2. Maintenance Schedules Table - ENTIRE TABLE MISSING

**Status:** Table does NOT exist in Supabase
**Alternative:** `schedules` table exists but has only 7 basic columns
**Impact:** 22 maintenance schedule records would be LOST

**Data Captured by Extractor:**
```
maintenance_schedules:
  - id (UUID)
  - building_id (UUID)
  - contract_id (UUID) - Links to contractor contracts
  - service_type (text) - "Fire Alarm Service", "Lift Maintenance", etc.
  - frequency (text) - "annual", "quarterly", "monthly"
  - frequency_interval (integer) - 1, 3, 6, 12
  - next_due_date (date)
  - description (text)
  - priority (text) - "high", "medium", "low"
  - status (text) - "active", "overdue", "upcoming"
  - estimated_duration (text) - "2 hours", "1 day"
```

**Supabase `schedules` Table (Current):**
```
schedules:
  - id (UUID)
  - building_id (UUID)
  - agency_id (UUID)
  - name (text)
  - description (text)
  - created_at (timestamp)
  - updated_at (timestamp)
```

**Gap Analysis:**
- ❌ Missing: contract linkage
- ❌ Missing: frequency/interval
- ❌ Missing: next due date
- ❌ Missing: priority
- ❌ Missing: status tracking
- ❌ Missing: service type categorization

---

## Impact by Data Category

### Critical Business Data (Would be LOST)

1. **Maintenance Contracts Tracking**
   - 22 scheduled maintenance items
   - Contract-to-service linkages
   - Due date tracking for compliance

2. **Service Frequency for Assets**
   - 14 assets with defined service intervals
   - Regulatory compliance tracking (fire, lifts, gas)

### Non-Critical Data (Already Captured)

✅ Building information (1 building)
✅ Units (8 units)
✅ Leaseholders (8 leaseholders)
✅ Documents (318 documents)
✅ Compliance assets (56 compliance records)
✅ Insurance policies
✅ Budgets

---

## Three Options for Resolution

### Option 1: Update Supabase Schema ✅ RECOMMENDED

**Pros:**
- Zero data loss
- Structured, queryable data
- Future-proof for more buildings
- Clean data model

**Cons:**
- Requires schema migration
- One-time setup effort

**Implementation:**
```sql
-- Add service_frequency to assets
ALTER TABLE assets ADD COLUMN service_frequency TEXT;

-- Enhance schedules table OR create maintenance_schedules
ALTER TABLE schedules ADD COLUMN contract_id UUID REFERENCES contractor_contracts(id);
ALTER TABLE schedules ADD COLUMN service_type TEXT;
ALTER TABLE schedules ADD COLUMN frequency TEXT;
ALTER TABLE schedules ADD COLUMN frequency_interval INTEGER;
ALTER TABLE schedules ADD COLUMN next_due_date DATE;
ALTER TABLE schedules ADD COLUMN priority TEXT DEFAULT 'medium';
ALTER TABLE schedules ADD COLUMN status TEXT DEFAULT 'active';
ALTER TABLE schedules ADD COLUMN estimated_duration TEXT;
```

**Timeline:** 15 minutes to add columns + 5 minutes to test

---

### Option 2: Use JSON Storage in Existing Fields ⚠️ COMPROMISE

**Pros:**
- No schema changes needed
- Works immediately
- Data is preserved

**Cons:**
- Not easily queryable
- Requires JSON parsing in application
- Less structured
- Harder to report on

**Implementation:**
```json
// Store in assets.notes field:
{
  "service_frequency": "annual",
  "last_service": "2024-01-15",
  "contract_reference": "ABC123"
}

// Store in building_knowledge table:
{
  "table": "maintenance_schedules",
  "data": [...]
}
```

---

### Option 3: Drop Non-Matching Data ❌ NOT RECOMMENDED

**Pros:**
- Simplest implementation
- No schema changes

**Cons:**
- **PERMANENT DATA LOSS**
- Lose compliance tracking capability
- Lose maintenance scheduling
- Have to re-extract if schema updated later
- Defeats purpose of comprehensive onboarding

**Lost Capabilities:**
- Can't track when services are due
- Can't link maintenance to contractors
- Can't prioritize maintenance tasks
- Can't generate maintenance schedules report

---

## Financial Impact Analysis

### Cost of Schema Updates (Option 1)
- **Developer time:** 15 minutes
- **Testing time:** 10 minutes
- **Risk:** Very low (non-breaking addition)
- **Total cost:** ~30 minutes

### Cost of Data Loss (Option 3)
- **Re-extraction:** ~2 hours per building if needed later
- **Manual data entry:** ~4 hours to manually input 36 records
- **Compliance risk:** Missed maintenance could lead to regulatory issues
- **Lost insights:** Can't generate maintenance reports

**ROI:** Spending 30 minutes now saves 4-6 hours per building later

---

## Recommended Action Plan

### Phase 1: Quick Schema Updates (30 mins)

1. **Add `service_frequency` to `assets` table:**
   ```sql
   ALTER TABLE assets ADD COLUMN service_frequency TEXT;
   ```

2. **Enhance `schedules` table to support maintenance scheduling:**
   ```sql
   ALTER TABLE schedules
   ADD COLUMN contract_id UUID REFERENCES contractor_contracts(id),
   ADD COLUMN service_type TEXT,
   ADD COLUMN frequency TEXT,
   ADD COLUMN frequency_interval INTEGER,
   ADD COLUMN next_due_date DATE,
   ADD COLUMN priority TEXT DEFAULT 'medium',
   ADD COLUMN status TEXT DEFAULT 'active',
   ADD COLUMN estimated_duration TEXT;

   -- Add index for performance
   CREATE INDEX idx_schedules_next_due_date ON schedules(next_due_date);
   CREATE INDEX idx_schedules_status ON schedules(status);
   ```

3. **Update onboarder to map to `schedules` table:**
   - Change `maintenance_schedules` → `schedules` in SQL generator
   - Map extracted fields to enhanced `schedules` table

### Phase 2: Update Clean SQL Generator (10 mins)

Update the column mapping in `clean_sql_generator.py` to map:
- `maintenance_schedules` → `schedules` (with enhanced columns)
- Ensure all extracted fields have valid targets

### Phase 3: Test End-to-End (15 mins)

1. Run onboarder on Connaught Square
2. Verify migration.sql generates correctly
3. Execute against Supabase
4. Verify all 36 data points are imported

---

## Conclusion

**Recommendation:** Implement **Option 1** (Update Supabase Schema)

**Rationale:**
- Only 30 minutes of work
- Preserves 100% of extracted data
- Enables powerful maintenance tracking features
- Professional, scalable solution
- Avoids technical debt

**Alternative:** If schema changes are blocked, use **Option 2** (JSON storage) as interim solution, but plan to migrate to Option 1 within next sprint.

**Do NOT choose Option 3** - The time saved is negligible compared to data loss impact.

---

## Next Steps

1. ✅ Get approval for schema updates
2. ⏳ Execute SQL migrations on Supabase
3. ⏳ Update clean SQL generator with mappings
4. ⏳ Re-run onboarder with clean implementation
5. ⏳ Verify complete data import

**Estimated Total Time:** 1 hour including testing
