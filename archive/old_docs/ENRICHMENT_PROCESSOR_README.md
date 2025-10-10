# 🧠 Enrichment Post-Processor

## Overview

The Enrichment Post-Processor automatically enhances generated SQL migrations with:

1. **Building Metadata Enrichment** - Extracts missing addresses from files
2. **Major Works Project Type Inference** - Classifies projects by type
3. **Budget Fallback Creation** - Creates placeholders for unstructured PDFs
4. **Building Knowledge Extraction** - Auto-extracts access codes, utility locations, etc.

## What Gets Enhanced

### 1️⃣ Building Metadata (Address Extraction)

**Problem:** Buildings often have empty `address` fields after initial mapping.

**Solution:** Searches for addresses in:
- Folder names (e.g., "219.01 CONNAUGHT SQUARE")
- Property information form files
- Document text containing "Address:", "Property Address:", etc.

**Output:**
```sql
-- Update building address
UPDATE buildings
SET address = 'Connaught Square, London, W2 2LL'
WHERE id = 'building-uuid';
```

**Stats:**
- `addresses_extracted`: Number of addresses successfully found
- `addresses_skipped`: Number of buildings without extractable addresses

---

### 2️⃣ Major Works Project Type Inference

**Problem:** Major works projects often missing `project_type` classification.

**Solution:** Rule-based classifier matches project names/filenames:

| Keyword | Project Type |
|---------|-------------|
| lift, elevator | Lift Renewal |
| roof, roofing | Roof Works |
| facade, cladding | Cladding / Façade |
| redecoration, painting | Internal / External Redecoration |
| window, glazing | Window Replacement |
| fire, fire safety | Fire Safety / FRA Works |
| m&e, mechanical, electrical | Mechanical & Electrical |
| door, entrance | Door Replacement |
| balcony | Balcony Refurbishment |
| drainage, drains | Drainage Works |

**Output:**
```sql
-- Classify major works project type
UPDATE major_works_projects
SET project_type = 'Lift Renewal'
WHERE id = 'project-uuid';
```

**Stats:**
- `major_works_tagged`: Number of projects classified

---

### 3️⃣ Budget Fallback for Unstructured PDFs

**Problem:** Budget PDFs that can't be parsed (no apportionment tables) don't appear in the system.

**Solution:** Creates placeholder budget records so the document still appears in BlocIQ UI.

**Trigger:**
- Document category is `finance`
- Filename contains "budget", "service charge", or "apportionment"
- No budget record already exists for this document

**Output:**
```sql
-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'budget-uuid',
    'building-uuid',
    'document-uuid',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;
```

**Stats:**
- `budget_placeholders_created`: Number of placeholder budgets created

---

### 4️⃣ Building Knowledge Extraction

**Problem:** Property forms contain valuable operational info (access codes, utility locations) but it's not structured.

**Solution:** Pattern-based extraction for 4 categories:

#### **Access** 🔑
- Gate codes: `gate code: 4829#`
- Entry codes: `entry code: 1234*`
- Keypad codes: `keypad code: 5678#`
- Access codes: `access code: 9999*`

#### **Utilities** ⚡
- Stopcock: `stopcock: Boiler room cupboard to the left`
- Gas meter: `gas meter: External wall, rear of building`
- Electric meter: `electric meter: Ground floor utility cupboard`
- Water meter: `water meter: Basement, left corner`
- Boiler: `boiler: Basement plant room`

#### **Safety** 🚨
- Alarm panel: `alarm panel: Main entrance hallway, left side`
- Fire alarm: `fire alarm: Ground floor, near lift`
- CCTV: `cctv: Main entrance and rear exit`
- Sprinkler: `sprinkler: All floors except basement`
- Assembly point: `assembly point: Front courtyard near main gate`

#### **General** 🧾
- Bin store: `bin store: Rear of building, code 1234`
- Post room: `post room: Ground floor, flat 1`
- Caretaker: `caretaker: On-site Mon-Fri 9am-5pm`
- Parking: `parking: Underground level -1`
- Bike store: `bike store: Ground floor, rear entrance`

**Output:**
```sql
-- Building knowledge: Gate Code
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'knowledge-uuid',
    'building-uuid',
    'gate_code',
    'access',
    'Gate Code',
    '4829#',
    NULL,
    NULL,
    'contractors'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Stopcock
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'knowledge-uuid',
    'building-uuid',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'Boiler room cupboard to the left',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
```

**Visibility Rules:**
- `access` category → `contractors` (shareable)
- `utilities`, `safety`, `general` → `team` (internal only)

**Stats:**
- `building_intelligence_entries`: Number of knowledge entries extracted

---

## Output Files

### 1. `migration.sql` (Enhanced)

```sql
-- ============================================================
-- BlocIQ Onboarding Migration
-- Generated: 2025-10-05
-- ============================================================

-- Portfolio placeholder
INSERT INTO portfolios (id, name) VALUES ...

-- Building, units, leaseholders
INSERT INTO buildings (id, portfolio_id, name, address) VALUES ...
INSERT INTO units (id, building_id, unit_number) VALUES ...
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ...

-- Documents, compliance, budgets, major works
...

-- ============================================================
-- POST-PROCESSING ENRICHMENT
-- Auto-generated corrections and enhancements
-- ============================================================

-- ============================================================
-- Building Knowledge Enhancement
-- ============================================================
-- Note: Uses existing building_keys_access table with enhanced columns
-- This DDL ensures the table has the required columns for building knowledge

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add category column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'category'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN category text;
    END IF;
    ...
END $$;

-- Update building address
UPDATE buildings
SET address = 'Connaught Square, London, W2 2LL'
WHERE id = 'building-uuid';

-- Classify major works project type
UPDATE major_works_projects
SET project_type = 'Lift Renewal'
WHERE id = 'project-uuid';

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES ('budget-uuid', 'building-uuid', 'doc-uuid', '2025', 'service_charge', NULL);

-- Building knowledge: Gate Code
INSERT INTO building_keys_access (...)
VALUES (...);

-- Building knowledge: Stopcock
INSERT INTO building_keys_access (...)
VALUES (...);
```

### 2. `summary.json` (Enhanced)

```json
{
  "timestamp": "2025-10-05T14:30:00",
  "client_folder": "/path/to/building",
  "building_name": "Connaught Square",
  "statistics": {
    "files_parsed": 150,
    "buildings": 1,
    "units": 15,
    "leaseholders": 12,
    "documents": 150
  },
  "categories": {
    "compliance": 35,
    "finance": 82,
    "major_works": 12,
    "lease": 8,
    "contracts": 13
  },
  "post_processing_summary": {
    "building_metadata_filled": 1,
    "addresses_extracted": 1,
    "major_works_tagged": 6,
    "budget_placeholders_created": 12,
    "building_intelligence_entries": 5
  },
  "building_intelligence": {
    "total_entries": 5,
    "by_category": {
      "access": 2,
      "utilities": 2,
      "general": 1
    }
  }
}
```

### 3. `validation_report.json` (Enhanced)

```json
{
  "valid": true,
  "errors": [],
  "warnings": [],
  "enrichment_summary": "✅ Enrichment Passed: 1 address(es) extracted\n✅ Tagged 6 major works project(s) with types\n✅ Created 12 budget placeholder(s) for unstructured PDFs\n✅ Extracted 5 building knowledge entrie(s)"
}
```

---

## Usage

### Running Onboarding with Enrichment

```bash
# Standard onboarding (enrichment runs automatically)
python BlocIQ_Onboarder/onboarder.py "/path/to/building/folder"
```

**Expected Console Output:**

```
🏢 BlocIQ Onboarder
📁 Client Folder: /path/to/building/folder

📄 Parsing files...
  ✅ Parsed 150 files

🏷️  Classifying documents...
  compliance: 35 files
  finance: 82 files
  major_works: 12 files

🔗 Mapping to Supabase schema...
  ✅ Building: Connaught Square
  ✅ Units: 15
  ✅ Leaseholders: 12
  ✅ Documents: 150

🔍 Validating data against Supabase schema...
  ✅ Validation report: output/validation_report.json

🧠 Running post-processing enrichment...

  📊 Enrichment Summary:
     ✅ Addresses extracted: 1
     ✅ Major works tagged: 6
     ✅ Budget placeholders: 12
     🧠 Building knowledge entries: 5

  ✅ SQL migration: output/migration.sql

============================================================
✅ ONBOARDING COMPLETE
============================================================

Building: Connaught Square
Units: 15
Documents: 150
Budgets: 25

  ✅ Summary: output/summary.json
  ✅ Migration: output/migration.sql
  ✅ Validation: output/validation_report.json
```

---

## Customization

### Adding New Project Types

Edit `BlocIQ_Onboarder/enrichment_processor.py` line ~18:

```python
self.PROJECT_TYPE_MAP = {
    'lift': 'Lift Renewal',
    'roof': 'Roof Works',
    # Add new mapping:
    'hvac': 'HVAC System Upgrade',
    'insulation': 'Insulation Works',
}
```

### Adding New Knowledge Patterns

Edit `BlocIQ_Onboarder/enrichment_processor.py` line ~40:

```python
self.KNOWLEDGE_PATTERNS = {
    'utilities': [
        (r'stopcock[:\s]+(.+?)(?:\n|$)', 'stopcock_location', 'Stopcock'),
        # Add new pattern:
        (r'fuse\s*box[:\s]+(.+?)(?:\n|$)', 'fuse_box_location', 'Fuse Box'),
    ]
}
```

**Pattern Syntax:**
- Regex pattern with capture group for the value
- Key identifier (snake_case)
- Human-readable label

---

## Integration with Ask BlocIQ

Building knowledge entries are automatically available to Ask BlocIQ chat:

**User Query:**
> "Where's the stopcock at Connaught Square?"

**BlocIQ Response:**
```sql
SELECT label, location
FROM building_keys_access
WHERE building_id = 'connaught-square-uuid'
  AND (label ILIKE '%stopcock%' OR location ILIKE '%stopcock%');
```

**Result:**
> Stopcock: Boiler room cupboard to the left
> Last updated: 5 Oct 2025

---

## Troubleshooting

### No address extracted

**Symptom:**
```
⚠️ Skipped: Could not extract address for building ...
```

**Solution:**
1. Check folder name contains recognizable address pattern
2. Check property information form has "Address:" field
3. Manually update in Supabase after migration

### No building knowledge found

**Symptom:**
```
🧠 Building knowledge entries: 0
```

**Solution:**
1. Check property forms contain extractable patterns (e.g., "Gate Code: 1234")
2. Review `KNOWLEDGE_PATTERNS` in `enrichment_processor.py`
3. Add custom patterns for your property form format

### Budget placeholders created but don't want them

**Symptom:**
```
✅ Budget placeholders: 25
```

**Solution:**
- Placeholders are created for unstructured budget PDFs
- These allow the document to appear in BlocIQ UI
- `total_amount` is NULL and requires manual entry
- To disable, comment out budget fallback section in enrichment processor

---

## Example: Full Enrichment Flow

**Input Files:**
```
/path/to/building/
  Property Information Form.xlsx
    - Gate Codes: 4829#
    - Stopcock Location: Boiler room
  Budget YE25.pdf (unstructured)
  Section 20 Lift NOI.pdf
```

**Enrichment Process:**

1. **Address extraction**: ❌ No address in property form
   - Checks folder name: `/path/to/building/` → No match
   - **Result:** Skipped

2. **Major works classification**: ✅
   - Detects "lift" in filename
   - **Result:** `UPDATE major_works_projects SET project_type = 'Lift Renewal'`

3. **Budget fallback**: ✅
   - Detects unstructured budget PDF
   - **Result:** `INSERT INTO budgets (...) VALUES (...)`

4. **Building knowledge**: ✅
   - Extracts gate code: `4829#`
   - Extracts stopcock: `Boiler room`
   - **Result:** 2 INSERT statements into `building_keys_access`

**Final Stats:**
```
addresses_extracted: 0
major_works_tagged: 1
budget_placeholders_created: 1
building_intelligence_entries: 2
```

---

## Summary

✅ Runs automatically after SQL generation
✅ Appends enrichments to `migration.sql`
✅ Updates `summary.json` with stats
✅ Adds validation summary to `validation_report.json`
✅ Zero configuration required (works out of the box)
✅ Customizable patterns and project types
✅ Idempotent (safe to run multiple times)

**Result:** Cleaner data, fewer manual corrections, instant building intelligence for Ask BlocIQ!
