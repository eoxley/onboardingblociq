# BlocIQ Onboarder - Handover Full Strip Documentation

## Overview

The BlocIQ Onboarder comprehensively extracts structured intelligence from building handover folders across **all major categories**: compliance, insurance, finance, contracts, utilities, legal/RTM, keys/access, meetings, and client money. This document details the complete extraction schema, field mappings, and usage.

## Quick Start

```bash
# Process a handover folder
python run_onboarder.py --folder "/path/to/handover" --building-id "your-building-id"

# Generate schema suggestions only
python run_onboarder.py --schema-only

# View help
python run_onboarder.py --help
```

## Target Data Model

### 1. Compliance Assets (`compliance_assets`)

Enhanced compliance tracking with inspection history:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `asset_name` | TEXT | Name of compliance asset |
| `asset_type` | TEXT | Type: FRA, EICR, Gas, Asbestos, etc. |
| `inspection_frequency` | INTERVAL | Frequency (e.g., "12 months") |
| `description` | TEXT | Asset description |
| **`inspection_contractor`** | TEXT | Company that performed inspection |
| **`inspection_date`** | DATE | Date of last inspection |
| **`reinspection_date`** | DATE | Date next inspection due |
| **`outcome`** | TEXT | Satisfactory/Certified/Failed |
| **`compliance_status`** | TEXT | compliant/due_soon/overdue/unknown |
| **`source_document_id`** | UUID | Link to building_documents record |

**Extraction Sources:**
- Fire Risk Assessments
- EICRs (Electrical Installation Condition Reports)
- Gas Safety Certificates
- Asbestos Surveys
- Legionella Risk Assessments
- Lift Inspection Reports (LOLER)
- Emergency Lighting Certificates
- PAT Testing Records

### 2. Insurance Policies (`insurance_policies`)

Comprehensive insurance policy extraction:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `insurer` | TEXT | Insurance company name |
| `broker` | TEXT | Insurance broker/intermediary |
| `policy_number` | TEXT | Policy reference number |
| `cover_type` | TEXT | buildings/terrorism/engineering/EL/PL/D&O |
| `sum_insured` | NUMERIC | Total sum insured (£) |
| `reinstatement_value` | NUMERIC | Rebuilding/replacement value (£) |
| `valuation_date` | DATE | Date of valuation |
| `start_date` | DATE | Policy start date |
| `end_date` | DATE | Policy end/renewal date |
| `excess_json` | JSONB | Map of peril -> excess amount |
| `endorsements` | TEXT | Policy endorsements |
| `conditions` | TEXT | Policy conditions/terms |
| `claims_json` | JSONB | Claims history [{ref, date, status, amount}] |
| `evidence_url` | TEXT | Link to policy document in storage |
| `policy_status` | TEXT | active/expired/expiring_soon |

**Extraction Patterns:**
- Policy schedules
- Certificates of insurance
- Cover notes
- Claims history documents

**Example `excess_json`:**
```json
{
  "escape_of_water": 1000.00,
  "subsidence": 5000.00,
  "standard": 500.00
}
```

**Example `claims_json`:**
```json
[
  {
    "reference": "CLM123456",
    "date": "2023-03-15",
    "status": "settled",
    "amount": 15000.00,
    "description": "Escape of water - flat 5"
  }
]
```

### 3. Contracts (`contracts`)

Service agreements and maintenance contracts:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `contractor_name` | TEXT | Contractor/supplier company name |
| `service_type` | TEXT | fire_alarm/lifts/cleaning/security/etc. |
| `start_date` | DATE | Contract start date |
| `end_date` | DATE | Contract expiry date |
| `renewal_date` | DATE | Next renewal date |
| `frequency` | TEXT | monthly/quarterly/annual |
| `value` | NUMERIC | Annual contract value (£) |
| `contract_status` | TEXT | active/expired/expiring_soon |

**Common Service Types:**
- `fire_alarm` - Fire alarm servicing
- `lifts` - Lift maintenance
- `cleaning` - Cleaning services
- `grounds_maintenance` - Landscaping/grounds
- `security` - Security services
- `emergency_lighting` - Emergency lighting testing
- `cctv` - CCTV maintenance
- `door_entry` - Door entry systems
- `pest_control` - Pest control services

### 4. Utilities (`utilities`)

Utility accounts and supply information:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `supplier` | TEXT | Utility supplier name |
| `utility_type` | TEXT | electricity/gas/water/waste/telecommunications |
| `account_number` | TEXT | Account/supply number (MPAN/MPRN/etc.) |
| `start_date` | DATE | Contract start date |
| `end_date` | DATE | Contract end date |
| `tariff` | TEXT | Tariff name/description |
| `contract_status` | TEXT | active/expired |

**Extraction Patterns:**
- MPAN (Electricity) - 13 or 21 digit identifier
- MPRN (Gas) - 6-10 digit identifier
- Supplier correspondence
- Utility bills

### 5. Meetings (`meetings`)

Meeting minutes and agendas:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `meeting_type` | TEXT | AGM/EGM/Board/Handover |
| `meeting_date` | DATE | Date of meeting |
| `attendees` | TEXT | List of attendees |
| `key_decisions` | TEXT | Summary of key decisions/resolutions |
| `minutes_url` | TEXT | Link to full minutes document |

**Meeting Types:**
- `AGM` - Annual General Meeting
- `EGM` - Extraordinary General Meeting
- `Board` - Board meeting
- `Handover` - Handover meeting

### 6. Client Money Snapshots (`client_money_snapshots`)

Financial handover snapshots:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `snapshot_date` | DATE | Date of snapshot |
| `bank_name` | TEXT | Bank holding client money |
| `account_identifier` | TEXT | Account number/sort code |
| `balance` | NUMERIC | Total account balance (£) |
| `uncommitted_funds` | NUMERIC | Uncommitted funds (£) |
| `arrears_total` | NUMERIC | Total arrears (£) |
| `notes` | TEXT | Additional notes |

**Use Cases:**
- Handover financial position
- Trust account reconciliation
- Service charge balance verification

### 7. Building Documents (`building_documents`)

Enhanced document metadata with linking:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Primary key |
| `building_id` | UUID | Foreign key to buildings |
| `file_name` | TEXT | Original filename |
| `storage_path` | TEXT | Path in Supabase storage |
| `category` | TEXT | compliance/insurance/budget/contract/utilities/meetings/legal |
| `document_type` | TEXT | Specific type (FRA/EICR/PolicySchedule/etc.) |
| `ocr_text` | TEXT | OCR text (leave null by default) |
| `metadata` | JSONB | Flexible metadata storage |
| `created_at` | TIMESTAMPTZ | Upload timestamp |

## Document Classification

### Enhanced Categories

The classifier now recognizes these categories:

1. **`compliance`** - Fire Risk Assessments, EICRs, Gas Safety, Asbestos, Legionella, Lifts
2. **`insurance`** - Policy schedules, certificates, claims documents
3. **`contracts`** - Service agreements, SLAs, maintenance contracts
4. **`utilities`** - Utility bills, MPAN/MPRN documents, supplier correspondence
5. **`meetings`** - AGM/EGM minutes, board meeting minutes, agendas
6. **`client_money`** - Client account statements, trial balances, reconciliations
7. **`section20`** - Section 20 notices, consultation documents
8. **`keys_access`** - Key registers, fob lists, access control logs
9. **`budgets`** - Service charge budgets, forecasts
10. **`major_works`** - Major works projects, tender documents
11. **`units_leaseholders`** - Leaseholder lists, tenancy schedules
12. **`apportionments`** - Apportionment schedules

### Classification Keywords

**Insurance:**
- policy schedule, certificate of insurance, sum insured, insurer, broker, policy number, reinstatement value, excess, indemnity

**Client Money:**
- client account, uncommitted funds, service charge balance, arrears report, trial balance, trust account

**Utilities:**
- account number, MPAN, MPRN, supply number, tariff, unit rate, electricity, gas, water

**Meetings:**
- AGM, EGM, board meeting, minutes, agenda, action log, annual general meeting

**Section 20:**
- section 20, notice of intention, statement of estimates, consultation, qualifying works

## Extraction Workflow

### Phase 1: File Classification

```python
from BlocIQ_Onboarder.classifier import DocumentClassifier

classifier = DocumentClassifier()
category, confidence = classifier.classify(parsed_data)
```

### Phase 2: Specialized Extraction

Each category routes to its specialized extractor:

```python
from BlocIQ_Onboarder.extractors import (
    insurance_extractor,
    contracts_extractor,
    utilities_extractor,
    meetings_extractor,
    client_money_extractor
)

# Route based on category
if category == 'insurance':
    extractor = insurance_extractor.InsuranceExtractor()
    result = extractor.extract(file_data, building_id)

elif category == 'contracts':
    extractor = contracts_extractor.ContractsExtractor()
    result = extractor.extract(file_data, building_id)

# ... etc
```

### Phase 3: Database Insertion

```python
from BlocIQ_Onboarder.db.insert import SafeInserter

inserter = SafeInserter(supabase_client)

# Safe insert with column validation
results = inserter.insert_insurance_policies([policy])
results = inserter.insert_contracts([contract])
```

### Phase 4: Schema Validation

```python
from BlocIQ_Onboarder.db.introspect import introspect_and_generate

# Generate migration suggestions
sql_file = introspect_and_generate(supabase_client, 'out/schema_suggestions.sql')
```

## Regex Pattern Library

### Dates
```regex
(\d{1,2}[\/\.-]\d{1,2}[\/\.-]\d{2,4})
```

### Policy Numbers
```regex
(policy\s*(no\.|number)\s*[:#]?\s*([A-Z0-9\-\/]+))
```

### Currency (GBP)
```regex
£([0-9,]+(?:\.[0-9]{2})?)
```

### Excess Amounts
```regex
(excess|deductible)\s*[:£]?\s*([£$]?[0-9,\.]+)(?:\s*per\s*(?:claim|peril|event))?
```

### Contractors
```regex
(Tetra|WHM|Quotehedge|Cuanku|BES Group|Marsh|Gallagher|Zurich|Aviva|RSA|[A-Z][a-z]+\s+(Consulting|Surveyors|Electrical|Fire|Environmental))
```

### MPAN (Electricity)
```regex
\b\d{13}\b|\b\d{21}\b
```

### MPRN (Gas)
```regex
\b\d{6,10}\b
```

## CLI Usage Examples

### Basic Usage
```bash
python run_onboarder.py \
  --folder "/Users/ellie/Desktop/BlocIQ Buildings/1.Building Name" \
  --building-id "abc-def-123"
```

### With Building Name Override
```bash
python run_onboarder.py \
  --folder "./handover_folder" \
  --building-id "abc-123" \
  --building-name "Connaught Square"
```

### Custom Output Directory
```bash
python run_onboarder.py \
  --folder "./handover_folder" \
  --building-id "abc-123" \
  --output "./results"
```

### Schema Introspection Only
```bash
python run_onboarder.py --schema-only
```

## Output Files

### 1. `migration.sql`
Complete SQL migration with all data inserts.

### 2. `schema_suggestions.sql`
**DO NOT RUN AUTOMATICALLY!**
Contains suggested CREATE TABLE and ALTER TABLE statements based on schema introspection.

### 3. `ingestion_audit.csv`
Detailed log of all files processed with extraction results.

| Column | Description |
|--------|-------------|
| file_name | Original filename |
| category | Classified category |
| confidence | Classification confidence (0-1) |
| extractor_used | Which extractor processed it |
| records_extracted | Number of records extracted |
| status | success/failed/skipped |
| notes | Any extraction notes/warnings |

### 4. `confidence_report.csv`
Confidence scores for all extracted data.

### 5. `validation_report.json`
Schema validation results and warnings.

## Testing

### Unit Tests

Run extractor tests:

```bash
# Test insurance extractor
python -m pytest BlocIQ_Onboarder/tests/test_insurance_extractor.py

# Test all extractors
python -m pytest BlocIQ_Onboarder/tests/
```

### Integration Test

```bash
# Run on sample handover folder
python run_onboarder.py \
  --folder "./test_data/sample_handover" \
  --building-id "test-123" \
  --output "./test_output"
```

## Troubleshooting

### No Text Extracted
**Problem:** `full_text` field is empty, extractor returns None.

**Solution:** Check if document is:
- Image-based PDF (needs OCR - currently not supported)
- Encrypted/password-protected
- Corrupted file

Tag with `parse_mode='no_text'` in metadata and still index the file.

### Missing Schema Columns
**Problem:** Extractor tries to insert data but column doesn't exist.

**Solution:**
1. Run schema introspection: `python run_onboarder.py --schema-only`
2. Review `out/schema_suggestions.sql`
3. Apply missing columns manually in Supabase SQL Editor

### Low Confidence Scores
**Problem:** Extracted data has low confidence scores.

**Solution:**
- Review pattern matching in extractor
- Add more keywords to classifier
- Check if document format is non-standard

## Best Practices

1. **Always review `schema_suggestions.sql` before applying**
2. **Check confidence_report.csv for low-confidence extractions**
3. **Validate currency amounts manually** (especially sums insured)
4. **Cross-reference policy numbers** with original documents
5. **Verify compliance dates** for overdue items
6. **Review contractor names** for typos/variations

## Future Enhancements

- [ ] OCR support for image-based PDFs
- [ ] Natural language processing for unstructured text
- [ ] Automated confidence thresholds
- [ ] Multi-language support
- [ ] AI-powered document summarization
- [ ] Automated Section 20 deadline tracking
- [ ] Contract renewal alerting

## Support

For issues or questions:
- GitHub: https://github.com/anthropics/blociq-onboarder/issues
- Email: support@blociq.com

---

**Generated:** 2025-10-07
**Version:** 2.0.0
**Schema:** BlocIQ V2
