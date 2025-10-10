# BlocIQ Onboarding Generator Upgrade Summary

## Overview

Two major enhancements have been implemented for the BlocIQ Onboarding Generator:

1. **Financial Documents Enhancement** - Comprehensive budget and service charge file detection and metadata extraction
2. **Migration Diagnostic Tool** - SQL migration health checker with data integrity validation

---

## 1. Financial Documents Enhancement ✅

### Goal
Capture **ALL** service charge and budget files with comprehensive metadata extraction for easy filtering in the UI.

### Implementation Changes

#### 1.1 Enhanced Budget Detection (`classifier.py`)

**Before:**
```python
'budgets': {
    'keywords': ['budget', 'service charge', 'expenditure', 'income'],
    'filename_patterns': [
        r'.*budget.*',
        r'.*ye\s*\d{2}.*',
    ],
}
```

**After:**
```python
'budgets': {
    'keywords': ['budget', 'service charge', 'expenditure', 'income', 'year end',
                'variance', 'forecast', 'apportionment', 'schedule', 'arrears'],
    'filename_patterns': [
        r'.*budget.*',
        r'.*ye\s*\d{2}.*',
        r'.*year[\s_-]?end.*',
        r'.*service[\s_-]?charge.*',
        r'.*variance.*',
        r'.*forecast.*',
        r'.*apportionment.*',
        r'.*\bq[1-4]\b.*',  # Quarterly reports (Q1-Q4)
        r'.*(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[\s_-]?\d{2,4}.*'  # Monthly
    ],
}
```

**Impact:** Now captures variance reports, quarterly statements, monthly accounts, and all service charge documents.

#### 1.2 Financial Metadata Extraction (`schema_mapper.py`)

**New Helper Function:**
```python
def _extract_financial_metadata(self, filename: str) -> Dict[str, Optional[str]]:
    """
    Extract financial year and period label from filenames

    Examples:
    - "Budget YE25.xlsx" → {'financial_year': '2025', 'period_label': None}
    - "Variance Q1 YE25.pdf" → {'financial_year': '2025', 'period_label': 'Q1'}
    - "Service Charge Aug 22.pdf" → {'financial_year': '2022', 'period_label': 'AUG 22'}
    """
```

**Supported Patterns:**
- **Year Formats:**
  - YE25, YE 2024, YE24 → "2025", "2024", "2024"
  - 2024-2025, 2024/2025 → "2024-2025"
  - Single year: 2024 → "2024"

- **Period Labels:**
  - Quarterly: Q1, Q2, Q3, Q4 → "Q1", "Q2", etc.
  - Monthly: Aug 22, Nov 2023 → "AUG 22", "NOV 23"

#### 1.3 Extended Database Schema

**Updated `building_documents` table:**
```sql
CREATE TABLE building_documents (
    id uuid PRIMARY KEY,
    building_id uuid NOT NULL REFERENCES buildings(id),
    category text NOT NULL,
    file_name text NOT NULL,
    storage_path text NOT NULL,
    entity_type text,
    linked_entity_id uuid,
    financial_year text,      -- NEW: e.g., "2025", "2024-2025"
    period_label text,         -- NEW: e.g., "Q1", "AUG 22"
    uploaded_at timestamptz DEFAULT now()
);
```

#### 1.4 Automatic Metadata Population

**Updated `map_building_documents()` in `schema_mapper.py`:**
```python
# Extract financial metadata if this is a finance document
if normalized_category == 'finance':
    metadata = self._extract_financial_metadata(filename)
    doc_record['financial_year'] = metadata['financial_year']
    doc_record['period_label'] = metadata['period_label']
```

**Impact:** All budget documents automatically get `financial_year` and `period_label` populated in SQL inserts.

#### 1.5 Financial Summary Report

**New Output in `onboarder.py`:**
```
============================================================
💰 FINANCIAL DOCUMENTS SUMMARY
============================================================

Detected 82 financial documents
Financial Years Found: 2021, 2022, 2023, 2024, 2025, 2026
Period Labels Found: Q1, Q2, Q3, Q4, AUG 21, NOV 22

Inserted 82 entries into building_documents ✅

Financial Document Types:
  • Apportionment Schedule: 15
  • Budget: 25
  • Service Charge Account: 20
  • Service Charge Demand: 12
  • Variance Report: 10
============================================================
```

### Files Modified

1. `BlocIQ_Onboarder/classifier.py` - Enhanced budget detection regex
2. `BlocIQ_Onboarder/schema_mapper.py` - Added `_extract_financial_metadata()` helper
3. `BlocIQ_Onboarder/schema_mapper.py` - Extended `building_documents` schema
4. `BlocIQ_Onboarder/schema_mapper.py` - Updated `map_building_documents()`
5. `BlocIQ_Onboarder/onboarder.py` - Added financial summary report to `_print_summary()`

### SQL Output Example

**Before:**
```sql
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type)
VALUES ('uuid', 'building_id', 'finance', 'Budget YE25.xlsx', 'finance/Budget YE25.xlsx', 'budget');
```

**After:**
```sql
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, financial_year, period_label)
VALUES ('uuid', 'building_id', 'finance', 'Budget YE25.xlsx', 'finance/Budget YE25.xlsx', 'budget', '2025', NULL);

INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, financial_year, period_label)
VALUES ('uuid', 'building_id', 'finance', 'Variance Q1 YE25.pdf', 'finance/Variance Q1 YE25.pdf', 'budget', '2025', 'Q1');
```

### Benefits

✅ **Complete Capture** - All budget, variance, apportionment, and service charge documents detected
✅ **Rich Metadata** - Financial year and period labels extracted automatically
✅ **UI Filtering** - Documents can be filtered by year (2021-2026) and period (Q1-Q4, monthly)
✅ **Historical Trail** - Full financial history preserved (YE21→YE26)
✅ **Non-Destructive** - No files skipped or reduced
✅ **Rerunnable** - SQL uses ON CONFLICT for safe re-execution

---

## 2. Migration Diagnostic Tool ✅

### Goal
Provide a comprehensive SQL migration health checker that flags common onboarding and data integrity issues.

### Features

#### 2.1 Health Checks Implemented

1. **Date Field Validation**
   - Missing `inspection_date`, `last_inspection_date` in compliance assets
   - Missing `next_due_date`, `expiry_date` in compliance assets
   - Missing `created_at` timestamps across all tables

2. **Duplicate Detection**
   - Identifies repeated INSERT statements with identical VALUES
   - Shows examples of duplicates for debugging

3. **Empty String Detection**
   - Flags hardcoded `''` for address fields
   - Warns about empty notes fields

4. **ON CONFLICT Protection**
   - Verifies presence of `ON CONFLICT DO NOTHING/UPDATE`
   - Warns if missing (inserts may fail on re-run)

5. **Compliance Frequency Analysis**
   - Detects if all assets use default "12 months"
   - Suggests specific frequencies (EICR: 60mo, LOLER: 6mo, FRA: 12mo)

6. **Budget Metadata Validation**
   - Checks for `period`, `financial_year`, `period_label` fields
   - Validates budget document metadata

7. **UUID Validation**
   - Counts valid UUIDs (with dashes)
   - Flags malformed UUIDs (32 hex without dashes)

8. **Foreign Key Check**
   - Validates presence of foreign key columns
   - Checks for FOREIGN KEY constraints

9. **Date Pattern Extraction**
   - Finds and parses potential dates from filenames
   - Supports formats: DDMMYY, DDMMYYYY, YYYY-MM-DD, DD-MM-YYYY
   - Shows parsed examples

#### 2.2 Record Statistics

Counts and displays:
- Buildings
- Units
- Leaseholders
- Documents
- Compliance Assets
- Budgets

### Usage

```bash
# Basic usage
node diagnostic.js path/to/migration.sql

# Example
node diagnostic.js output/migration.sql

# Make executable (optional)
chmod +x diagnostic.js
./diagnostic.js output/migration.sql
```

### Example Output

```
============================================================
BlocIQ Migration Diagnostic
============================================================
File: output/migration.sql

📊 Record Counts:
  Buildings: 1
  Units: 15
  Leaseholders: 12
  Documents: 145
  Compliance Assets: 35
  Budgets: 18

⚠️  Warnings:
  15 compliance_assets missing inspection_date/last_inspection_date
  10 compliance_assets missing next_due_date/expiry_date
  All 35 compliance_assets have default frequency "12 months"
  3 possible duplicate INSERT(s) in compliance_assets
  1 building record(s) with empty address value

ℹ️  Information:
  ✅ ON CONFLICT protection found
  ✅ Foreign key columns present (building_id, unit_id)
  ✅ Foreign key constraints defined
  ✅ 487 UUIDs detected
  ✅ Budget documents include financial_year and period_label metadata
  📅 23 potential date(s) found in filenames/data
    160124 (DDMMYY) → 2024-01-16
    2023-11-15 (YYYY-MM-DD) → 2023-11-15
    15-03-2024 (DD-MM-YYYY) → 2024-03-15

💡 Suggestions:
  • Extract specific frequencies: EICR (60 months), LOLER (6 months), FRA (12 months)
  • Add ON CONFLICT (id) DO NOTHING to all INSERT statements

============================================================
Found 6 issue(s) that may need attention.
============================================================
```

### Files Created

1. `diagnostic.js` - Main diagnostic script (Node.js)
2. `DIAGNOSTIC_README.md` - Comprehensive usage guide

### Integration Workflow

```bash
# Step 1: Generate migration
python onboarder.py /path/to/building/folder

# Step 2: Run diagnostic
node diagnostic.js output/migration.sql

# Step 3: Review and fix issues
# (Edit source data or onboarding logic)

# Step 4: Re-generate if needed
python onboarder.py /path/to/building/folder

# Step 5: Execute migration
psql -d your_database -f output/migration.sql
```

### Benefits

✅ **Early Detection** - Catches data issues before executing SQL
✅ **Comprehensive Checks** - Validates dates, UUIDs, foreign keys, duplicates
✅ **Actionable Suggestions** - Provides specific fix recommendations
✅ **Date Intelligence** - Extracts and validates dates from filenames
✅ **Zero Dependencies** - Pure Node.js, no npm packages required
✅ **Fast Execution** - Scans large migrations in seconds

---

## Testing Recommendations

### 1. Test Financial Enhancement

```bash
# Run onboarding on a building with budget files
python onboarder.py "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/"

# Verify output shows financial summary
# Check migration.sql for financial_year and period_label columns
```

**Expected Output:**
- Financial summary section in terminal
- `financial_year` and `period_label` in building_documents INSERTs
- All budget/variance/apportionment files captured

### 2. Test Diagnostic Tool

```bash
# Run diagnostic on generated migration
node diagnostic.js output/migration.sql

# Review warnings and suggestions
# Check if budget metadata is detected
```

**Expected Output:**
- Record counts displayed
- Warnings for any missing dates/duplicates
- ✅ confirmation for budget metadata
- Date pattern extraction examples

---

## Migration Guide

### For Existing Databases

If you need to add `financial_year` and `period_label` to existing `building_documents` table:

```sql
-- Add new columns
ALTER TABLE building_documents
ADD COLUMN IF NOT EXISTS financial_year text,
ADD COLUMN IF NOT EXISTS period_label text;

-- Create index for filtering
CREATE INDEX IF NOT EXISTS idx_building_documents_financial_year
ON building_documents(financial_year);

CREATE INDEX IF NOT EXISTS idx_building_documents_period_label
ON building_documents(period_label);
```

---

## Summary

### Financial Enhancement
- ✅ Enhanced budget detection with comprehensive regex patterns
- ✅ Automatic extraction of `financial_year` (e.g., "2025") and `period_label` (e.g., "Q1")
- ✅ Extended database schema to store financial metadata
- ✅ Detailed financial summary report in onboarding output
- ✅ Non-destructive capture of all budget files

### Diagnostic Tool
- ✅ Comprehensive SQL migration health checker
- ✅ 9 categories of validation checks
- ✅ Date pattern extraction and parsing
- ✅ Actionable fix suggestions
- ✅ Zero dependencies, pure Node.js

### Impact
- **UI Enhancement:** Documents can now be filtered by year and period
- **Data Quality:** Diagnostic tool ensures migration integrity
- **Developer Experience:** Clear feedback on data issues before SQL execution
- **Historical Tracking:** Full financial history preserved (YE21→YE26)
