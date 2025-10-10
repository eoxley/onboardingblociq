# Enrichment Processor - Example Output

## Example Building: Connaught Square

### Input Files

```
/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/
├── Property Information Form.xlsx
│   Content:
│   - Gate Codes: 4829#
│   - Entrance Code: 1234*
│   - Location of Stopcock: Boiler room cupboard to the left
│   - Gas Meter Location: External wall, rear of building
│
├── Budget YE25.pdf (unstructured - no apportionment table)
├── Section 20 Lift Renewal NOI.pdf
├── EICR Report 2024.pdf
└── Fire Risk Assessment 2023.pdf
```

---

## Enrichment Process Log

### 1. Address Extraction

```
🔍 Searching for building address...
   ✅ Found in folder name: "219.01 CONNAUGHT SQUARE"
   → Extracted: "Connaught Square"
```

**Generated SQL:**
```sql
-- Update building address
UPDATE buildings
SET address = 'Connaught Square'
WHERE id = '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b';
```

---

### 2. Major Works Project Type Inference

```
🔍 Classifying major works projects...
   ✅ Project: "Section 20 Lift Renewal NOI - 2024"
      → Detected keyword: "lift"
      → Assigned type: "Lift Renewal"
```

**Generated SQL:**
```sql
-- Classify major works project type
UPDATE major_works_projects
SET project_type = 'Lift Renewal'
WHERE id = '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d';
```

---

### 3. Budget Fallback for Unstructured PDFs

```
🔍 Checking for unstructured budget PDFs...
   ✅ Found: "Budget YE25.pdf"
      → Category: finance
      → No budget record exists
      → Creating placeholder
```

**Generated SQL:**
```sql
-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '9f8e7d6c-5b4a-3c2d-1e0f-9a8b7c6d5e4f',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'doc-uuid-budget-ye25',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;
```

---

### 4. Building Knowledge Extraction

```
🔍 Extracting building knowledge from property forms...

   📄 Processing: Property Information Form.xlsx

   ✅ Found access code:
      Pattern: "Gate Codes: 4829#"
      → Category: access
      → Label: Gate Code
      → Value: 4829#

   ✅ Found access code:
      Pattern: "Entrance Code: 1234*"
      → Category: access
      → Label: Entry Code
      → Value: 1234*

   ✅ Found utility location:
      Pattern: "Location of Stopcock: Boiler room cupboard to the left"
      → Category: utilities
      → Label: Stopcock
      → Value: Boiler room cupboard to the left

   ✅ Found utility location:
      Pattern: "Gas Meter Location: External wall, rear of building"
      → Category: utilities
      → Label: Gas Meter
      → Value: External wall, rear of building
```

**Generated SQL:**
```sql
-- Building knowledge: Gate Code
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'gate_codes',
    'access',
    'Gate Code',
    '4829#',
    NULL,
    NULL,
    'contractors'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Entry Code
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'entry_code',
    'access',
    'Entry Code',
    '1234*',
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
    'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'Boiler room cupboard to the left',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'External wall, rear of building',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
```

---

## Final Output: `migration.sql`

```sql
-- ============================================================
-- BlocIQ Onboarding Migration
-- Generated: 2025-10-05T14:30:00
-- Building: Connaught Square
-- ============================================================

-- Portfolio placeholder
INSERT INTO portfolios (id, name)
VALUES ('00000000-0000-0000-0000-000000000001', '⚠️ REPLACE: Your Agency/Portfolio Name')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- Building
INSERT INTO buildings (id, portfolio_id, name, address)
VALUES (
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    '00000000-0000-0000-0000-000000000001',
    'Connaught Square',
    ''  -- Will be filled by enrichment
)
ON CONFLICT (id) DO NOTHING;

-- Units (15 units)
INSERT INTO units (id, building_id, unit_number) VALUES ...

-- Leaseholders (12 leaseholders)
INSERT INTO leaseholders (id, building_id, unit_id, name, email) VALUES ...

-- Documents (150 documents)
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ...

-- Compliance Assets (35 assets)
INSERT INTO compliance_assets (id, building_id, asset_name, asset_type) VALUES ...

-- Budgets (25 budgets - from structured files)
INSERT INTO budgets (id, building_id, document_id, period, budget_type) VALUES ...

-- Major Works Projects (12 projects)
INSERT INTO major_works_projects (id, building_id, project_name, status) VALUES
    (
        '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d',
        '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
        'Section 20 Lift Renewal NOI - 2024',
        'planned',
        NULL,
        NULL
    )
    -- ... 11 more projects
ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- POST-PROCESSING ENRICHMENT
-- Auto-generated corrections and enhancements
-- ============================================================

-- ============================================================
-- Building Knowledge Enhancement
-- ============================================================
-- Note: Uses existing building_keys_access table with enhanced columns

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'category'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN category text;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'label'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN label text;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'visibility'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN visibility text DEFAULT 'team';
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_building_keys_access_category
    ON building_keys_access(building_id, category);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_search
    ON building_keys_access USING gin(
        to_tsvector('english',
            COALESCE(label, '') || ' ' ||
            COALESCE(description, '') || ' ' ||
            COALESCE(location, '')
        )
    );

-- Update building address
UPDATE buildings
SET address = 'Connaught Square'
WHERE id = '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b';

-- Classify major works project type
UPDATE major_works_projects
SET project_type = 'Lift Renewal'
WHERE id = '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d';

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '9f8e7d6c-5b4a-3c2d-1e0f-9a8b7c6d5e4f',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'doc-uuid-budget-ye25',
    '2025',
    'service_charge',
    NULL
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gate Code
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'gate_codes',
    'access',
    'Gate Code',
    '4829#',
    NULL,
    NULL,
    'contractors'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Entry Code
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'entry_code',
    'access',
    'Entry Code',
    '1234*',
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
    'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'Boiler room cupboard to the left',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a',
    '8e7f9a2b-4c3d-4e1f-9a8b-7c6d5e4f3a2b',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'External wall, rear of building',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
```

---

## Final Output: `summary.json`

```json
{
  "timestamp": "2025-10-05T14:30:00.123456",
  "client_folder": "/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE",
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
    "major_works_tagged": 1,
    "budget_placeholders_created": 1,
    "building_intelligence_entries": 4
  },
  "building_intelligence": {
    "total_entries": 4,
    "by_category": {
      "access": 2,
      "utilities": 2
    }
  }
}
```

---

## Final Output: `validation_report.json`

```json
{
  "valid": true,
  "errors": [],
  "warnings": [
    "Building has no portfolio_id - will use placeholder"
  ],
  "tables_validated": [
    "buildings",
    "units",
    "leaseholders",
    "building_documents",
    "compliance_assets",
    "budgets",
    "major_works_projects"
  ],
  "enrichment_summary": "✅ Enrichment Passed: 1 address(es) extracted\n✅ Tagged 1 major works project(s) with types\n✅ Created 1 budget placeholder(s) for unstructured PDFs\n✅ Extracted 4 building knowledge entrie(s)"
}
```

---

## Console Output

```
🏢 BlocIQ Onboarder
📁 Client Folder: /Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE

📄 Parsing files...
  ✅ Parsed 150 files

🏷️  Classifying documents...
  compliance: 35 files
  finance: 82 files
  major_works: 12 files
  lease: 8 files
  contracts: 13 files

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
     ✅ Major works tagged: 1
     ✅ Budget placeholders: 1
     🧠 Building knowledge entries: 4

  ✅ SQL migration: output/migration.sql

============================================================
✅ ONBOARDING COMPLETE
============================================================

Building: Connaught Square
Units: 15
Documents: 150
Budgets: 26 (25 structured + 1 placeholder)

  ✅ Summary: output/summary.json
  ✅ Migration: output/migration.sql
  ✅ Validation: output/validation_report.json

============================================================
```

---

## What Got Enriched?

✅ **1 address** extracted from folder name
✅ **1 major works project** tagged as "Lift Renewal"
✅ **1 budget placeholder** created for unstructured PDF
✅ **4 building knowledge entries** extracted:
   - 2 access codes (gate, entrance)
   - 2 utility locations (stopcock, gas meter)

**Total SQL additions:** 7 statements appended to migration.sql
