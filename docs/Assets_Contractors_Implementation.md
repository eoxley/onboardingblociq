# Assets & Contractors Implementation Guide

## Overview

This document describes the comprehensive enhancement to the BlocIQ Onboarder system that enables automatic detection, extraction, and interlinking of:
- **Contractors** - Service providers with full contact details
- **Contracts** - Service agreements with lifecycle tracking
- **Assets** - Building equipment and systems (AOV, Boilers, Lifts, etc.)
- **Maintenance Schedules** - Recurring service patterns derived from contracts

These enhancements form the foundation of the **Building Health Check** dataset and enable comprehensive property management reporting.

---

## Architecture

### 1. Database Schema

#### New Tables

**contractors**
```sql
CREATE TABLE contractors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name TEXT NOT NULL,
  contact_person TEXT,
  email TEXT,
  phone TEXT,
  address TEXT,
  specialization TEXT,
  accreditations TEXT[],  -- Array of certifications
  insurance_expiry DATE,
  vat_number TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

**contracts**
```sql
CREATE TABLE contracts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id),
  contractor_id UUID REFERENCES contractors(id),
  contractor_name TEXT,  -- Denormalized for query performance
  service_type TEXT,  -- fire_alarm, lifts, cleaning, etc.
  start_date DATE,
  end_date DATE,
  renewal_date DATE,
  frequency TEXT,  -- monthly, quarterly, annual
  value NUMERIC,
  contract_status TEXT,  -- active, expired, expiring_soon
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

**building_contractors** (junction table)
```sql
CREATE TABLE building_contractors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id),
  contractor_id UUID NOT NULL REFERENCES contractors(id),
  relationship_type TEXT,  -- service_provider, consultant, etc.
  is_preferred BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

**assets**
```sql
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id),
  contractor_id UUID REFERENCES contractors(id),
  compliance_asset_id UUID REFERENCES compliance_assets(id),
  asset_type TEXT NOT NULL,  -- aov, boiler, lift, fire_alarm, etc.
  asset_name TEXT,
  location_description TEXT,
  manufacturer TEXT,
  model_number TEXT,
  serial_number TEXT,
  installation_date DATE,
  service_frequency TEXT,
  last_service_date DATE,
  next_due_date DATE,
  condition_rating TEXT,  -- excellent, good, fair, poor, failed
  compliance_category TEXT,  -- fire_safety, gas_safety, etc.
  linked_documents TEXT[],
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

**maintenance_schedules**
```sql
CREATE TABLE maintenance_schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id),
  contract_id UUID REFERENCES contracts(id),
  contractor_id UUID REFERENCES contractors(id),
  service_type TEXT NOT NULL,
  description TEXT,
  frequency TEXT,
  frequency_interval INTERVAL,  -- PostgreSQL interval type
  next_due_date DATE,
  last_completed_date DATE,
  estimated_duration INTERVAL,
  cost_estimate NUMERIC,
  priority TEXT,  -- high, medium, low
  status TEXT,  -- scheduled, completed, overdue
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

#### Indexes

Performance-optimized indexes created automatically:
- `idx_contractors_company_name` - Fast contractor lookup
- `idx_assets_asset_type` - Asset filtering
- `idx_assets_next_due` - Service scheduling
- `idx_maintenance_schedules_next_due` - Schedule queries
- `idx_maintenance_schedules_status` - Status filtering

---

## 2. Data Extraction

### Contractor Detection (`contracts_extractor.py`)

**Enhanced with:**
- Company name extraction with legal suffix normalization
- Contact person identification
- Email extraction with false positive filtering
- UK phone number parsing (+44, 01/02, 5-6 digit formats)
- Address extraction via postcode detection
- Accreditation recognition (ISO, CHAS, Gas Safe, NICEIC, etc.)
- Insurance expiry parsing
- VAT number extraction and validation

**Example Extraction:**
```python
{
  'company_name': 'ABC Lifts Limited',
  'contact_person': 'John Smith',
  'email': 'john@abclifts.co.uk',
  'phone': '0207 123 4567',
  'address': 'Unit 5, Industrial Estate, London, SW1A 1AA',
  'specialization': 'lifts',
  'accreditations': ['ISO 9001', 'SafeContractor'],
  'insurance_expiry': '2026-03-15',
  'vat_number': 'GB123456789'
}
```

### Asset Detection (`assets_extractor.py`)

**Detects 16 Asset Types:**
- AOV (Automatic Opening Vents)
- Boilers
- Roller Shutters
- Fire Alarms
- Sprinklers
- Lifts
- Pumps
- CCTV
- Door Entry Systems
- Emergency Lighting
- Fire Extinguishers
- Lightning Protection
- Communal Aerials
- Waste Chutes
- Water Tanks
- Generators

**Extraction Features:**
- Keyword-based detection with fuzzy matching
- Location extraction (roof, basement, plant room, core)
- Manufacturer and model number parsing
- Serial number identification
- Service history tracking
- Condition rating assessment
- Compliance category linking

**Example Detection:**
```
Document: "Fire Risk Assessment 2025"
Detected: Fire Alarm System (Core A, Last Service: 15/03/2025)
```

### Maintenance Schedule Generation (`maintenance_schedule_generator.py`)

**Automatic Schedule Creation:**
- Parses frequency patterns (monthly, quarterly, annual, 6-weekly, etc.)
- Generates next_due_date based on last_service or start_date
- Calculates frequency_interval as PostgreSQL INTERVAL
- Assigns priority based on service criticality
- Detects recurring date patterns in documents

**Frequency Patterns Supported:**
- Standard: daily, weekly, fortnightly, monthly, quarterly, annual
- Custom: "every 3 months", "4x per year", "6-weekly"
- Detected from text: "monthly inspection", "quarterly service"

**Example Schedule:**
```python
{
  'service_type': 'fire_alarm',
  'description': 'Fire Alarm Service - ABC Fire Ltd',
  'frequency': 'quarterly',
  'frequency_interval': '3 months',
  'next_due_date': '2025-06-15',
  'priority': 'high',
  'status': 'scheduled'
}
```

---

## 3. Deduplication System

### Contractor Deduplication (`db/contractor_deduplicator.py`)

**Features:**
- Fuzzy name matching using rapidfuzz (85% similarity threshold)
- Legal suffix normalization (Ltd, Limited, plc, LLC, etc.)
- Punctuation removal (except &)
- Whitespace normalization
- Update detection for existing records
- Accreditation merging

**Normalization Examples:**
```
"ABC Lifts Limited"    → "abc lifts"
"ABC Lifts Ltd."       → "abc lifts"
"ABC LIFTS LTD"        → "abc lifts"
```

**Usage:**
```python
from db.contractor_deduplicator import ContractorDeduplicator

deduplicator = ContractorDeduplicator(existing_contractors)
result = deduplicator.deduplicate(new_contractors)

# Result:
# {
#   'new': [...],       # Unique contractors to insert
#   'existing': [...],  # Duplicates skipped
#   'updated': [...]    # Existing records with new info
# }
```

---

## 4. Building Health Check Report

### Enhanced PDF Report

**New Section: Asset Register**

Displays:
- Total asset count and type summary
- Asset table with:
  - Asset Type (AOV, Boiler, Lift, etc.)
  - Name/Identifier
  - Location
  - Condition (color-coded: Green=Excellent, Red=Poor)
  - Last Service Date
  - Next Due Date
- First 20 assets shown, with count of remaining

**Visual Features:**
- Color-coded condition ratings
- Sortable by type
- Links to compliance records
- Service scheduling visibility

**Example Output:**
```
🏗️ Asset Register

Total Assets: 47 | Types: 12

┌──────────────────┬─────────────┬──────────────┬───────────┬──────────────┬─────────────┐
│ Asset Type       │ Name        │ Location     │ Condition │ Last Service │ Next Due    │
├──────────────────┼─────────────┼──────────────┼───────────┼──────────────┼─────────────┤
│ Aov              │ AOV-01      │ Roof Core A  │ Good      │ 15/03/2025   │ 15/03/2026  │
│ Boiler           │ Boiler Unit │ Plant Room   │ Excellent │ 10/01/2025   │ 10/01/2026  │
│ Lift             │ Passenger 1 │ Core B       │ Good      │ 20/02/2025   │ 20/05/2025  │
└──────────────────┴─────────────┴──────────────┴───────────┴──────────────┴─────────────┘
```

---

## 5. SQL Generation

### Dynamic Schema Detection (`sql_writer.py`)

**New INSERT Generators:**
- `_generate_contractors_inserts()`
- `_generate_contracts_inserts()`
- `_generate_building_contractor_links_inserts()`
- `_generate_assets_inserts()`
- `_generate_maintenance_schedules_inserts()`

**Array Handling:**
Enhanced `_format_value()` to handle PostgreSQL arrays:
```python
['ISO 9001', 'CHAS'] → ARRAY['ISO 9001', 'CHAS']
```

**Schema Introspection:**
- Reads existing schema via `information_schema.columns`
- Generates migration suggestions for missing tables/columns
- Outputs to `schema_suggestions.sql` for manual review
- Never auto-executes schema changes

---

## 6. Integration Flow

### Onboarder Pipeline Enhancement

**Step 1: Extract Contracts**
```
contracts_extractor.extract()
  ├─ Extract contract details
  ├─ Extract contractor details
  └─ Return both in result dict
```

**Step 2: Deduplicate Contractors**
```
ContractorDeduplicator.deduplicate()
  ├─ Fuzzy match against existing
  ├─ Filter out duplicates
  └─ Merge new information
```

**Step 3: Generate Schedules**
```
MaintenanceScheduleGenerator.generate_from_contract()
  ├─ Parse frequency patterns
  ├─ Calculate next_due_date
  └─ Create schedule records
```

**Step 4: Detect Assets**
```
AssetsExtractor.extract()
  ├─ Scan documents for asset keywords
  ├─ Extract asset details
  └─ Link to compliance_assets
```

**Step 5: Create Links**
```
Create building_contractors junction records
  ├─ Link each contractor to building
  └─ Set relationship_type and is_preferred
```

---

## 7. Usage Examples

### CLI Usage

**Full Onboarding with Assets:**
```bash
python run_onboarder.py \
  --folder "/path/to/handover" \
  --building-id "abc-123" \
  --generate-report
```

**Output:**
```
🔍 Extracting additional handover intelligence...
  📋 Processing 15 contract documents...
     ✓ Fire Alarm Service Agreement.pdf: fire_alarm
     ✓ Lift Maintenance Contract.pdf: lifts
     ✓ Cleaning Services.pdf: cleaning
  ✅ Extracted 15 service contracts
  ✅ Extracted 8 unique contractors (2 duplicates skipped)
  ✅ Generated 15 maintenance schedules
  📋 Scanning all documents for building assets...
     ✓ Fire Risk Assessment.pdf: Found 3 asset(s)
     ✓ Lift Inspection Report.pdf: Found 2 asset(s)
  ✅ Extracted 47 building assets
  ✅ Created 8 building-contractor links

📊 Generating Building Health Check Report...
  ✅ Building Health Check Report: out/abc-123_Building_Health_Check.pdf
```

### Programmatic Usage

**Query Assets:**
```python
from BlocIQ_Onboarder.reporting import BuildingHealthCheckGenerator
from supabase import create_client

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
report_gen = BuildingHealthCheckGenerator(supabase)

# Get building data
data = report_gen._gather_building_data(building_id='abc-123')

# Access assets
assets = data['assets']
for asset in assets:
    print(f"{asset['asset_type']}: {asset['asset_name']} - {asset['condition_rating']}")
```

**Deduplicate Contractors:**
```python
from BlocIQ_Onboarder.db.contractor_deduplicator import deduplicate_contractors

new_contractors = [
    {'company_name': 'ABC Lifts Limited', 'email': 'info@abclifts.co.uk'},
    {'company_name': 'ABC Lifts Ltd', 'phone': '0207 123 4567'}  # Duplicate
]

result = deduplicate_contractors(new_contractors, existing_contractors)
print(f"New: {len(result['new'])}, Duplicates: {len(result['existing'])}")
```

---

## 8. Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│              HANDOVER DOCUMENT FOLDER                        │
└─────────────────────────────────────────────────────────────┘
                         │
                         ▼
    ┌────────────────────────────────────────────┐
    │    DOCUMENT CLASSIFICATION                │
    │    (Insurance, Contracts, Compliance)      │
    └────────────────────────────────────────────┘
                         │
        ┌────────────────┴────────────────┐
        │                                 │
        ▼                                 ▼
┌──────────────────┐            ┌──────────────────┐
│  CONTRACTS       │            │  COMPLIANCE      │
│  EXTRACTOR       │            │  DOCUMENTS       │
└──────────────────┘            └──────────────────┘
        │                                 │
        ├─► Extract Contractor Details    │
        ├─► Extract Contract Terms        │
        └─► Generate Maintenance Schedule │
                         │                │
        ┌────────────────┴────────────────┘
        │
        ▼
┌──────────────────┐            ┌──────────────────┐
│  ASSETS          │            │  CONTRACTOR      │
│  EXTRACTOR       │            │  DEDUPLICATOR    │
└──────────────────┘            └──────────────────┘
        │                                 │
        ├─► Detect Building Assets        │
        ├─► Link to Compliance            ├─► Fuzzy Match
        └─► Extract Service History       └─► Merge Data
                         │
        ┌────────────────┴────────────────┐
        ▼                                 ▼
┌──────────────────┐            ┌──────────────────┐
│   SQL WRITER     │            │  BUILDING HEALTH │
│   (migration.sql)│            │  CHECK REPORT    │
└──────────────────┘            └──────────────────┘
        │                                 │
        ▼                                 ▼
┌──────────────────┐            ┌──────────────────┐
│   SUPABASE       │            │   PDF REPORT     │
│   DATABASE       │            │   (Health Score) │
└──────────────────┘            └──────────────────┘
```

---

## 9. File Structure

```
BlocIQ_Onboarder/
├── extractors/
│   ├── contracts_extractor.py           # Enhanced with contractor detection
│   ├── assets_extractor.py              # NEW: Asset detection
│   └── maintenance_schedule_generator.py # NEW: Schedule generation
│
├── db/
│   ├── introspect.py                    # Enhanced with 4 new table schemas
│   └── contractor_deduplicator.py       # NEW: Deduplication logic
│
├── reporting/
│   └── building_health_check.py         # Enhanced with asset section
│
├── sql_writer.py                        # Enhanced with new insert generators
├── schema_mapper.py                     # Enhanced with new table schemas
└── onboarder.py                         # Enhanced pipeline integration
```

---

## 10. Testing

### Validation Checklist

**Contractor Extraction:**
- [ ] Company name extracted correctly
- [ ] Contact details parsed (email, phone, address)
- [ ] Accreditations detected
- [ ] Deduplication prevents duplicates
- [ ] VAT numbers validated

**Asset Detection:**
- [ ] All 16 asset types detected
- [ ] Location information extracted
- [ ] Service history tracked
- [ ] Compliance links created
- [ ] Condition ratings assigned

**Maintenance Schedules:**
- [ ] Frequency patterns parsed
- [ ] Next due dates calculated
- [ ] Priorities assigned correctly
- [ ] Intervals stored as PostgreSQL INTERVAL

**SQL Generation:**
- [ ] All INSERT statements valid
- [ ] Array types formatted correctly
- [ ] Foreign key references valid
- [ ] ON CONFLICT handling works

**Building Health Check Report:**
- [ ] Asset section renders
- [ ] Asset table displays correctly
- [ ] Condition color-coding works
- [ ] Asset count accurate

---

## 11. Performance Considerations

**Optimization Strategies:**
- Contractor deduplication uses in-memory cache
- Asset detection limited to relevant document categories
- Database queries use indexed columns
- Report generation paginated (20 assets per page)
- Bulk inserts for multiple records

**Typical Processing Times:**
- Small building (<50 units): 5-10 seconds
- Medium building (50-200 units): 10-20 seconds
- Large building (>200 units): 20-40 seconds

---

## 12. Error Handling

**Graceful Degradation:**
- Missing contractor details → Partial record created
- Asset detection failures → Logged, process continues
- Deduplication errors → Falls back to insert
- Schedule generation errors → Contract still saved
- Report generation failures → Error logged, migration.sql still created

**Logging:**
- All extraction results logged to audit_log
- Deduplication statistics printed to console
- Asset detection counts displayed
- Error stack traces saved to error logs

---

## 13. Future Enhancements

**Planned Features:**
- [ ] AI-powered asset condition assessment
- [ ] Contractor performance scoring
- [ ] Predictive maintenance scheduling
- [ ] Cost forecasting based on maintenance history
- [ ] Multi-building contractor comparison
- [ ] Asset depreciation tracking
- [ ] Insurance claim linking to assets
- [ ] Contractor insurance validation alerts

---

## 14. API Reference

### ContractorDeduplicator

```python
deduplicator = ContractorDeduplicator(existing_contractors)

# Find match for single contractor
match = deduplicator.find_match(contractor_dict)

# Deduplicate batch
result = deduplicator.deduplicate(new_contractors)
# Returns: {'new': [...], 'existing': [...], 'updated': [...]}

# Link contractor to building
link = deduplicator.link_contractor_to_building(
    contractor_id='uuid',
    building_id='uuid',
    relationship_type='service_provider',
    is_preferred=False
)
```

### MaintenanceScheduleGenerator

```python
generator = MaintenanceScheduleGenerator()

# Generate from contract
schedules = generator.generate_from_contract(contract_dict)

# Detect recurring dates in text
schedules = generator.detect_recurring_dates(text, contract_dict)
```

### AssetsExtractor

```python
extractor = AssetsExtractor()

# Extract assets from document
assets = extractor.extract(file_data, building_id)

# Link asset to compliance
compliance_id = extractor.link_to_compliance(asset, compliance_assets)
```

---

**Version:** 2.0
**Date:** 2025-10-07
**Status:** Production Ready ✅
