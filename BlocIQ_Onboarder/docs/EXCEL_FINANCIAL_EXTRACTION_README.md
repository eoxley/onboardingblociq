# Excel Financial Data Extractor

## Overview
Extracts financial data directly from Excel files (.xlsx, .xls) without OCR, and metadata from PDFs.

## Features

### 1. Budget Extraction
- **Detection**: Matches files with category=finance or keywords: budget, accounts, service charge
- **Extraction**:
  - `year_start` and `year_end` from filename/sheet (e.g., "Budget 2025-26")
  - `total_amount` from sum of "Total" columns
  - `status` = 'draft' if "Draft" in filename, else 'final'
- **Output**: INSERT INTO budgets table

### 2. Apportionment Extraction
- **Detection**: Sheets with "Flat", "Unit", or "Apportionment %" columns
- **Extraction**: Cross-matches with units table by unit number/name
- **Validation**: Checks total = 100%
- **Output**: INSERT INTO apportionments table

### 3. Insurance Extraction
- **Excel**: Extracts provider, policy_number, expiry_date
- **PDF**: Stores metadata only (filename, inferred year, status)
- **Output**: INSERT INTO building_insurance table

### 4. Error Logging
- Missing totals logged to timeline_events table
- Error type and file tracked in metadata
- Severity: 'warning' for recoverable issues

## Database Schema

### budgets
```sql
CREATE TABLE budgets (
  id uuid PRIMARY KEY,
  building_id uuid REFERENCES buildings(id),
  year_start date,
  year_end date,
  total_amount numeric(15,2),
  status text CHECK (status IN ('draft','final','approved')),
  source_document text,
  notes text
);
```

### building_insurance
```sql
CREATE TABLE building_insurance (
  id uuid PRIMARY KEY,
  building_id uuid REFERENCES buildings(id),
  provider text,
  policy_number text,
  expiry_date date,
  premium_amount numeric(15,2),
  source_document text,
  notes text
);
```

### building_staff
```sql
CREATE TABLE building_staff (
  id uuid PRIMARY KEY,
  building_id uuid REFERENCES buildings(id),
  name text NOT NULL,
  role text,
  contact_info text,
  hours text,
  company_name text,
  contractor_id uuid REFERENCES building_contractors(id),
  source_document text,
  notes text
);
```

### timeline_events
```sql
CREATE TABLE timeline_events (
  id uuid PRIMARY KEY,
  building_id uuid REFERENCES buildings(id),
  event_type text NOT NULL,
  event_date timestamptz DEFAULT now(),
  description text,
  metadata jsonb,
  severity text CHECK (severity IN ('info','warning','error'))
);
```

## Workflow Integration

### Onboarder Step 4.555
```python
def _extract_excel_financial_data(self):
    """Extract financial data directly from Excel files"""
    extractor = ExcelFinancialExtractor(
        parsed_files=self.parsed_files,
        mapped_data=self.mapped_data
    )

    results = extractor.extract_all()

    # Merge budgets, apportionments, insurance
    # Convert errors to timeline_events
    # Store summary for Building Health Check
```

## Building Health Check Report

### Financial Detection Status
- **Budgets**: "✅ Budgets detected: 3 | ⚠️ Missing totals in 1/3 docs"
- **Apportionments**: "✅ Apportionments mapped: 8/8 units"
- **Insurance**: Shows provider, policy, expiry date

### Health Score Calculation
- Compliance Coverage: 40%
- Maintenance & Contractor Readiness: 25%
- Financial Completeness: 25%
- Insurance Validity: 10%

## SQL Output Safety

### Conflict Handling
```sql
INSERT INTO budgets (...) VALUES (...)
ON CONFLICT DO NOTHING;
```

### Table Existence Check
```sql
CREATE TABLE IF NOT EXISTS budgets (...);
```

### Batch Transactions
All inserts for a single file type are grouped together with comments:
```sql
-- Insert 3 budgets
INSERT INTO budgets ...
INSERT INTO budgets ...
INSERT INTO budgets ...
```

## Error Handling

### Types
1. **excel_processing**: Failed to open/parse Excel file
2. **budget_missing_total**: Budget file has no extractable total
3. **unit_not_found**: Apportionment references unknown unit

### Logging
```python
{
  'file': 'Connaught Square Budget 2025.xlsx',
  'error': 'Missing total in budget',
  'type': 'budget_missing_total'
}
```

### Timeline Event
```sql
INSERT INTO timeline_events (
  building_id, event_type, description, metadata, severity
) VALUES (
  '{{building_id}}',
  'import_error',
  'Missing total in budget',
  '{"file": "...", "error_type": "budget_missing_total"}',
  'warning'
);
```

## Performance

- ✅ Processes .xlsx/.xls only (no OCR overhead)
- ✅ Uses pandas for fast Excel parsing
- ✅ Deduplicates on source_document to avoid double-imports
- ✅ Limits report output (10 budgets, 20 apportionments)
- ✅ Batch SQL transactions

## Testing

### Clear Caches
```bash
find . -type d -name "__pycache__" -exec rm -rf {} +
rm -rf /Users/ellie/Desktop/BlocIQ_Output/*
```

### Run Onboarder
```bash
python3 onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/"
```

### Expected Output
```
📊 Extracting financial data from Excel files...
  💰 Extracting financial data from Excel files...
     ✅ Budgets extracted: 3
     ✅ Apportionments extracted: 8
     ✅ Insurance records: 2
     ⚠️  Errors: 1

📊 Generating Building Health Check Report...
   ✅ Report generated: /Users/ellie/Desktop/BlocIQ_Output/63567c.../building_health_check.pdf
```

### Verify SQL
```bash
grep "INSERT INTO budgets" /Users/ellie/Desktop/BlocIQ_Output/migration.sql
grep "INSERT INTO apportionments" /Users/ellie/Desktop/BlocIQ_Output/migration.sql
grep "INSERT INTO building_insurance" /Users/ellie/Desktop/BlocIQ_Output/migration.sql
grep "INSERT INTO timeline_events" /Users/ellie/Desktop/BlocIQ_Output/migration.sql
```

## Files Modified

1. **excel_financial_extractor.py** (NEW) - Core extraction logic
2. **sql_writer.py** - Added schema DDL for budgets, building_insurance, building_staff, timeline_events
3. **onboarder.py** - Added _extract_excel_financial_data() method
4. **reporting/building_health_check.py** - Added financial detection status display

## Notes

- PDF insurance files create metadata-only records (no OCR)
- Year extraction supports formats: "2025-26", "2025-6", "Budget 2025"
- Fiscal year assumed: April 1 - March 31 (UK standard)
- Apportionment validation: warns if total ≠ 100%
- All UUIDs generated with uuid4()
- All timestamps use ISO format
