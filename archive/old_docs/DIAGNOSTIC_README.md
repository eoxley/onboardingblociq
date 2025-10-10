# BlocIQ Migration Diagnostic Tool

A comprehensive SQL migration health checker that scans generated migration files and flags common onboarding and data integrity issues.

## Features

### Health Checks

The diagnostic tool performs the following checks:

- ✅ **Date Field Validation**: Detects missing `inspection_date`, `last_inspection_date`, `next_due_date`, and `created_at` fields
- ⚠️ **Duplicate Detection**: Identifies repeated INSERT statements with identical values
- ⚠️ **Empty String Detection**: Flags hardcoded empty strings (`''`) for addresses and notes
- ⚠️ **ON CONFLICT Protection**: Verifies presence of `ON CONFLICT DO NOTHING/UPDATE` clauses
- ⚠️ **Compliance Frequency Analysis**: Checks if all compliance assets use default "12 months" frequency
- ⚠️ **Budget Metadata Validation**: Ensures budgets have `period`, `financial_year`, and `period_label` fields
- ⚠️ **UUID Validation**: Detects missing or malformed UUIDs
- ✅ **Foreign Key Check**: Validates presence of foreign key columns and constraints
- 📅 **Date Pattern Extraction**: Identifies and parses potential dates from filenames (DDMMYY, DDMMYYYY, YYYY-MM-DD formats)

### Record Statistics

Counts and displays:
- Buildings
- Units
- Leaseholders
- Documents
- Compliance Assets
- Budgets

## Installation

No installation required! The script uses only Node.js built-in modules.

### Requirements
- Node.js 12+ (uses ES6 features)

## Usage

### Basic Usage

```bash
node diagnostic.js path/to/migration.sql
```

### Example

```bash
node diagnostic.js output/migration.sql
```

### Make Executable (optional)

```bash
chmod +x diagnostic.js
./diagnostic.js output/migration.sql
```

## Example Output

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

## What It Checks

### 1. Missing Dates
- Compliance assets without `last_inspection_date` or `inspection_date`
- Compliance assets without `next_due_date` or `expiry_date`
- Tables missing `created_at` timestamps

### 2. Duplicate Inserts
- Identical INSERT statements (same VALUES clause)
- Shows example of duplicate for debugging

### 3. Empty String Detection
- Buildings with empty `address` field
- Records with empty `notes` fields

### 4. ON CONFLICT Protection
- Checks for `ON CONFLICT DO NOTHING` or `ON CONFLICT DO UPDATE`
- Warns if missing (inserts may fail on re-run)

### 5. Compliance Frequencies
- Detects if all compliance assets use "12 months" frequency
- Suggests extracting specific frequencies:
  - EICR: 60 months (quinquennial)
  - LOLER: 6 months (biannual)
  - FRA: 12 months (annual)

### 6. Budget Metadata
- Checks for `period` or `financial_year` fields in budgets
- Verifies `financial_year` and `period_label` in building_documents
- Suggests extraction patterns if missing

### 7. UUID Validation
- Counts valid UUIDs (with dashes)
- Flags malformed UUIDs (32 hex chars without dashes)

### 8. Foreign Keys
- Checks for `building_id`, `unit_id` columns
- Validates FOREIGN KEY constraints or REFERENCES clauses

### 9. Date Pattern Extraction
- Scans for date patterns in filenames and data:
  - `DDMMYY`: 160124 → 2024-01-16
  - `DDMMYYYY`: 16012024 → 2024-01-16
  - `YYYY-MM-DD`: 2024-01-16
  - `DD-MM-YYYY`: 16-01-2024
- Parses and validates dates
- Shows first 3 examples

## Integration with Onboarding Pipeline

### Recommended Workflow

1. **Generate Migration**
   ```bash
   python onboarder.py /path/to/building/folder
   ```

2. **Run Diagnostic**
   ```bash
   node diagnostic.js output/migration.sql
   ```

3. **Review Issues**
   - Fix critical issues (missing UUIDs, etc.)
   - Address warnings (missing dates, duplicates)
   - Implement suggestions (frequency extraction, etc.)

4. **Re-generate if Needed**
   ```bash
   python onboarder.py /path/to/building/folder
   ```

5. **Execute Migration**
   ```bash
   psql -d your_database -f output/migration.sql
   ```

## Troubleshooting

### No UUIDs Found
- Check if migration file is valid SQL
- Verify INSERT statements are properly formatted

### Many Duplicates Detected
- Review source data for duplicate files
- Check if classifier is over-detecting categories
- Consider deduplication logic in mapper

### Missing Date Fields
- Enhance date extraction in `schema_mapper.py`
- Use `_extract_inspection_date_from_filename()` helper
- Implement filename pattern matching

### All Frequencies are "12 months"
- Update compliance asset detection in `schema_mapper.py`
- Add specific frequency mapping:
  ```python
  asset_type_map = {
      'eicr': ('EICR', 'electrical', 'quinquennial', 60),
      'loler': ('LOLER', 'lift_safety', 'biannual', 6),
      'fra': ('FRA', 'fire_safety', 'annual', 12),
  }
  ```

## Contributing

To add new checks:

1. Create a new method in `BlocIQDiagnostic` class:
   ```javascript
   checkNewFeature() {
       // Your check logic
       this.issues.warnings.push('Your warning message');
   }
   ```

2. Call it in `run()` method:
   ```javascript
   this.checkNewFeature();
   ```

3. Add suggestions if needed:
   ```javascript
   this.issues.suggestions.push('Your suggestion');
   ```

## License

MIT License - Use freely in your BlocIQ onboarding pipeline.
