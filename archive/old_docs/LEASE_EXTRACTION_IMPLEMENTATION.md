# 📋 Comprehensive Lease & Safety Extraction System

## Overview

Comprehensive OCR → SQL Generator → Health Check PDF pipeline for extracting structured data from leases and building safety reports.

---

## 🔧 Components Created

### 1. Database Schema (`migrations/002_lease_extraction_tables.sql`)

**New Tables:**

- ✅ `document_texts` - Stores all OCR results for reuse
- ✅ `lease_financial_terms` - Ground rent, service charges, reviews
- ✅ `lease_insurance_terms` - Insurance obligations
- ✅ `lease_covenants` - Repair, alterations, use restrictions
- ✅ `lease_restrictions` - Pets, subletting, assignment rules
- ✅ `building_safety_reports` - FRAs, BSCs, compliance data

**To Apply:**
```bash
psql -h your-supabase-db -U postgres -d postgres -f migrations/002_lease_extraction_tables.sql
```

### 2. Lease Data Extractor (`BlocIQ_Onboarder/lease_data_extractor.py`)

**Class:** `LeaseDataExtractor`

**Extracts:**
- **Financial Terms:**
  - Ground rent amount + frequency + due dates
  - Service charge year (start/end dates)
  - Payment frequency (quarterly/monthly/annual)
  - Reserve fund details
  - Interest on arrears
  - Rent review frequency + basis (RPI/market/fixed)

- **Insurance Terms:**
  - Who insures (landlord/tenant/shared)
  - Coverage types (fire, flood, liability)
  - Tenant contribution method
  - Excess amounts
  - Contents insurance requirements

- **Covenants:**
  - Repairing obligations
  - Alteration restrictions
  - Use restrictions
  - Nuisance prohibitions

- **Restrictions:**
  - Pets policy
  - Subletting rules
  - Assignment permissions
  - Short-term letting rules

**Usage:**
```python
from lease_data_extractor import LeaseDataExtractor

extractor = LeaseDataExtractor(
    lease_id='uuid-here',
    building_id='building-uuid',
    unit_id='unit-uuid',
    ocr_text='full lease text from OCR...'
)

data = extractor.extract_all()
# Returns: {'financial_terms': {...}, 'insurance_terms': {...}, 'covenants': [...], 'restrictions': [...]}
```

### 3. Safety Report Extractor (`BlocIQ_Onboarder/safety_report_extractor.py`)

**Class:** `SafetyReportExtractor`

**Extracts:**
- Report type (FRA, BSC, Gateway 3, EICR, Gas Safety)
- Key dates (report, completion, next review)
- Responsible persons (PAP, duty holder, assessor)
- Fire strategy compliance
- BSC reference + status
- Action items with priorities
- Risk rating (trivial → intolerable)
- Overall compliance status

**Usage:**
```python
from safety_report_extractor import SafetyReportExtractor

extractor = SafetyReportExtractor(
    building_id='building-uuid',
    ocr_text='FRA document text...',
    document_name='Fire_Risk_Assessment_2024.pdf'
)

report = extractor.extract_safety_report()
# Returns safety report dict or None
```

### 4. Updated Lease Extractor (`BlocIQ_Onboarder/lease_extractor.py`)

**Changes:**
- ✅ OCR limit increased: 1 → **5 documents per run**
- ✅ OCR timeout increased: 60s → **180s (3 minutes)**
- ✅ Added building safety keywords detection
- ✅ Document type classification (lease/head_lease/safety_report)

**New Detection Keywords:**
- Lease: lease, head lease, underlease, assignment
- Safety: fire safety, BSC, safety case, gateway 3, FRA, principal accountable person

---

## 📊 Data Flow

### Step 1: OCR Processing
```
Document (PDF)
    ↓
OCR Service (Render)
    ↓
document_texts table (stores raw text)
    ↓
Document type classification
```

### Step 2: Extraction

**For Leases:**
```
OCR Text → LeaseDataExtractor
    ↓
Generates:
  - lease_financial_terms record
  - lease_insurance_terms record
  - lease_covenants records (multiple)
  - lease_restrictions records (multiple)
```

**For Safety Reports:**
```
OCR Text → SafetyReportExtractor
    ↓
Generates:
  - building_safety_reports record
    (with action_items as JSONB)
```

### Step 3: SQL Generation

SQL writer generates INSERTs for:
```sql
INSERT INTO document_texts (...);
INSERT INTO leases (...);
INSERT INTO lease_financial_terms (...);
INSERT INTO lease_insurance_terms (...);
INSERT INTO lease_covenants (...) VALUES (...), (...), (...);
INSERT INTO lease_restrictions (...) VALUES (...), (...);
INSERT INTO building_safety_reports (...);
```

### Step 4: Health Check PDF

PDF generator queries database and renders:

**Lease Summary Section (per unit):**
```
📄 LEASE SUMMARY – Flat 10

Lease Term
  Commencement: 1 January 2003
  Term: 125 years (expires 31 December 2127)

Financial Terms
  Ground Rent: £350 per annum, due 25 March & 29 September
  Service Charge Year: 1 April – 31 March (quarterly in advance)
  Reserve Fund: Provided
  Interest on arrears: 4% above base

Insurance
  Landlord insures building; Tenant contributes via Service Charge
  Excess: £250 per claim

Covenants
  Repair: Lessee to keep demised premises in good repair
  Alterations: No structural changes without consent
  Pets: Not permitted
  Subletting: Allowed with written consent

Other Clauses
  Rent review: Every 5 years, RPI-linked
  Assignment: Consent not to be unreasonably withheld
```

**Building-Level Lease Table:**
```
Flat    | Term              | Ground Rent | SC Year  | Restrictions
--------|-------------------|-------------|----------|-------------
10      | 125y (2003-2127)  | £350        | Apr-Mar  | No pets
11      | 125y (2003-2127)  | £350        | Apr-Mar  | None
Penth   | 999y              | Peppercorn  | Apr-Mar  | No sublets
```

**Compliance Section:**
```
🔥 FIRE SAFETY & COMPLIANCE

Fire Risk Assessment
  Status: Minor Issues
  Date: 15 March 2024
  Next Review: 15 March 2025
  Assessor: ABC Fire Safety Ltd
  Risk Rating: Tolerable

Outstanding Actions (3):
  [HIGH] Install fire doors to stairwell (Due: 01 Dec 2025)
  [MED] Update fire safety signage
  [LOW] Review emergency lighting schedule

Building Safety Certificate
  Status: Granted
  Reference: BSC-2024-001234
  Principal Accountable Person: John Smith
```

---

## 🚀 Next Steps

### To Complete Implementation:

1. **Apply Database Migration**
   ```bash
   psql -f migrations/002_lease_extraction_tables.sql
   ```

2. **Update `lease_extractor.py`** to:
   - Call `LeaseDataExtractor` for each lease
   - Call `SafetyReportExtractor` for safety docs
   - Store OCR text in `document_texts`
   - Return comprehensive extraction results

3. **Update `sql_writer.py`** to:
   - Add `_generate_document_texts_inserts()`
   - Add `_generate_lease_financial_terms_inserts()`
   - Add `_generate_lease_insurance_terms_inserts()`
   - Add `_generate_lease_covenants_inserts()`
   - Add `_generate_lease_restrictions_inserts()`
   - Add `_generate_building_safety_reports_inserts()`

4. **Update `building_health_check.py`** to:
   - Query new lease tables
   - Render lease summary sections
   - Add compliance section with safety data

5. **Test End-to-End:**
   ```bash
   python3 BlocIQ_Onboarder/onboarder.py
   # → Should extract comprehensive lease + safety data
   # → Should generate SQL with all new tables
   # → Health Check PDF should include new sections
   ```

---

## 📝 Example Extraction Output

### Lease Financial Terms:
```json
{
  "id": "uuid",
  "lease_id": "lease-uuid",
  "ground_rent": 350.00,
  "ground_rent_frequency": "semi_annual",
  "ground_rent_due_dates": ["25 March", "29 September"],
  "service_charge_year_start": "2025-04-01",
  "service_charge_year_end": "2026-03-31",
  "service_charge_frequency": "quarterly",
  "service_charge_advance": true,
  "reserve_fund_provided": true,
  "rent_review_frequency_years": 5,
  "rent_review_basis": "RPI-linked"
}
```

### Building Safety Report:
```json
{
  "id": "uuid",
  "building_id": "building-uuid",
  "report_type": "fire_risk_assessment",
  "report_date": "2024-03-15",
  "next_review_date": "2025-03-15",
  "assessor_company": "ABC Fire Safety Ltd",
  "overall_risk_rating": "tolerable",
  "compliance_status": "minor_issues",
  "action_items": [
    {
      "action": "Install fire doors to stairwell",
      "priority": "high",
      "status": "open",
      "due_date": "2025-12-01"
    }
  ]
}
```

---

## ✅ Status

- ✅ Database schema designed
- ✅ Lease data extractor built
- ✅ Safety report extractor built
- ✅ OCR limits increased (5 docs, 3min timeout)
- ✅ Document detection expanded
- ⏳ SQL generator updates (in progress)
- ⏳ Health Check PDF updates (pending)
- ⏳ End-to-end testing (pending)
