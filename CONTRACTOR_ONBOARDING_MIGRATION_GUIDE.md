# 🏗️ CONTRACTOR ONBOARDING SYSTEM - MIGRATION GUIDE

Complete system to onboard contractors/suppliers with automatic data extraction and database integration.

---

## 📋 SYSTEM OVERVIEW

### What It Does:
- **Extracts** contractor data from Excel, PDF, and Word documents
- **Validates** contractor names and filters out garbage text
- **Consolidates** duplicate contractors using fuzzy matching
- **Generates** SQL for database insertion
- **Tracks** compliance documents and insurance expiry dates

### Data Extracted:
✅ Company name, address, postcode  
✅ Email, telephone, website  
✅ Services provided  
✅ Bank details (account name, sort code)  
✅ PLI (Public Liability Insurance) expiry date  
✅ Document status (audited accounts, incorporation certificate)  
✅ Contact person details  

---

## 📁 FILE STRUCTURE

```
your-live-project/
├── contractor_onboarding/
│   ├── extractors/
│   │   ├── contractor_extractor.py          # Extract from Excel/PDF/Word
│   │   └── budget_contractor_extractor.py   # Extract from budget notes
│   ├── consolidators/
│   │   └── contractor_consolidator.py       # Deduplicate & merge
│   ├── validators/
│   │   └── contractor_name_validator.py     # Filter garbage names
│   ├── generators/
│   │   └── supplier_sql_generator.py        # Generate SQL
│   ├── onboard_contractor.py                # Main CLI tool
│   └── schema/
│       └── supplier_onboarding_schema.sql   # Database schema
```

---

## 🔧 INSTALLATION

### 1. Install Dependencies

```bash
pip install PyPDF2 openpyxl python-docx rapidfuzz
```

### 2. Apply Database Schema

Run the schema SQL in your Supabase SQL Editor to create the tables:
- `suppliers` (main contractor table)
- `supplier_documents` (document tracking)
- Views for expiring insurance and approved suppliers
- Triggers for auto-calculation

---

## 📝 CORE COMPONENTS

### Component 1: Contractor Extractor
**File:** `contractor_extractor.py`

**Purpose:** Extract contractor data from documents

**Key Features:**
- Reads Excel (.xlsx, .xls)
- Reads PDF (with text extraction)
- Reads Word (.docx, .doc)
- Pattern matching for UK phone numbers, emails, postcodes
- Bank sort code extraction
- PLI expiry date detection
- Service type inference

**Usage:**
```python
from contractor_extractor import ContractorExtractor

extractor = ContractorExtractor()
data = extractor.extract_from_folder("/path/to/contractor/folder")
```

---

### Component 2: Budget Contractor Extractor
**File:** `budget_contractor_extractor.py`

**Purpose:** Extract contractor names from budget PM Comments

**Key Features:**
- Pattern matching: "contract is with XYZ Ltd"
- Pattern matching: "currently with ABC Services"
- Validates extracted names
- Cleans up company suffixes (Ltd, Limited, LLP)

**Usage:**
```python
from budget_contractor_extractor import BudgetContractorExtractor

extractor = BudgetContractorExtractor()
name = extractor.extract_contractor_from_notes("This contract is with New Step Cleaning Ltd")
# Returns: "New Step Cleaning Ltd"
```

---

### Component 3: Contractor Consolidator
**File:** `contractor_consolidator.py`

**Purpose:** Deduplicate contractors and aggregate services

**Key Features:**
- Fuzzy matching (handles "New Step" vs "New Step Ltd")
- Alias tracking
- Service aggregation
- Source tracking (budget, contract, property bible)
- Annual value calculation

**Usage:**
```python
from contractor_consolidator import ContractorConsolidator

consolidator = ContractorConsolidator()

# Add from budget line items
consolidator.add_from_budget(budget_line_items)

# Add from contracts
consolidator.add_from_contracts(contracts)

# Get consolidated list
contractors = consolidator.get_consolidated_contractors()
```

---

### Component 4: Contractor Name Validator
**File:** `contractor_name_validator.py`

**Purpose:** Filter out invalid contractor names

**Key Features:**
- Rejects garbage text ("s and each contractor engaged...")
- Rejects generic words ("Gas", "Cleaning")
- Rejects legal boilerplate
- Validates proper capitalization
- Checks minimum/maximum length

**Usage:**
```python
from contractor_name_validator import ContractorNameValidator

validator = ContractorNameValidator()

if validator.is_valid_contractor("New Step Ltd"):
    # Valid contractor name
    pass

# Filter list
valid_contractors = validator.filter_contractors(all_contractors)
```

---

### Component 5: SQL Generator
**File:** `supplier_sql_generator.py`

**Purpose:** Generate SQL INSERT statements for Supabase

**Key Features:**
- UUID generation
- Array handling (services_provided)
- Date parsing and normalization
- Storage path generation
- Transaction wrapping (BEGIN/COMMIT)

**Usage:**
```python
from supplier_sql_generator import SupplierSQLGenerator

generator = SupplierSQLGenerator()
sql = generator.generate_sql(contractor_data, "output/contractor.sql")
```

---

### Component 6: Main Onboarding Tool
**File:** `onboard_contractor.py`

**Purpose:** Complete end-to-end onboarding workflow

**Workflow:**
1. Extract data from folder
2. Generate SQL
3. Print summary report
4. Show next steps

**CLI Usage:**
```bash
python3 onboard_contractor.py "/path/to/contractor/folder"
```

**Output:**
- JSON file with extracted data
- SQL file ready to apply
- Console summary with data quality score

---

## 💾 DATABASE SCHEMA

### Main Table: `suppliers`

**60+ Fields Including:**

#### Contact Information:
- `contractor_name` (required)
- `email`, `telephone`, `website`
- `address`, `postcode`, `city`, `country`
- `contact_person_name`, `contact_person_email`

#### Services:
- `services_provided` (TEXT[]) - Array of services
- `service_categories` (TEXT[])
- `specializations`

#### Banking:
- `bank_account_name`
- `bank_sort_code` (XX-XX-XX format)
- `bank_account_number`
- `bank_iban`

#### Compliance:
- `pli_expiry_date` (PUBLIC LIABILITY INSURANCE - CRITICAL)
- `pli_status` (auto-calculated: 'current', 'expiring_soon', 'expired')
- `days_until_pli_expiry` (auto-calculated)
- `eli_expiry_date` (Employers Liability)
- `pi_expiry_date` (Professional Indemnity)

#### Documentation:
- `has_audited_accounts` (boolean)
- `has_certificate_of_incorporation` (boolean)
- `has_vat_certificate` (boolean)
- `documents_storage_folder`

#### Onboarding Status:
- `onboarding_status` ('pending', 'in_progress', 'approved', 'rejected')
- `approved_by`, `approved_date`
- `rejection_reason`

#### Performance:
- `rating` (1.0-5.0)
- `contracts_completed`
- `on_time_completion_rate`
- `is_preferred_contractor`
- `is_approved_contractor`

---

### Document Table: `supplier_documents`

**Tracks Each Document:**
- Document type (PLI Certificate, Audited Accounts, etc.)
- File details (name, size, mime type)
- Supabase Storage path
- Expiry dates
- Verification status
- Extracted data (JSONB)

---

## 🚀 INTEGRATION STEPS

### Step 1: Set Up File Structure

```bash
cd your-live-project
mkdir -p contractor_onboarding/{extractors,consolidators,validators,generators,schema}
```

### Step 2: Copy Core Files

Copy these files from the onboarding system:
1. `contractor_extractor.py` → `contractor_onboarding/extractors/`
2. `budget_contractor_extractor.py` → `contractor_onboarding/extractors/`
3. `contractor_consolidator.py` → `contractor_onboarding/consolidators/`
4. `contractor_name_validator.py` → `contractor_onboarding/validators/`
5. `supplier_sql_generator.py` → `contractor_onboarding/generators/`
6. `onboard_contractor.py` → `contractor_onboarding/`
7. `supplier_onboarding_schema.sql` → `contractor_onboarding/schema/`

### Step 3: Adapt Import Paths

**Update imports in each file to match your project structure.**

Example in `contractor_consolidator.py`:
```python
# OLD:
from budget_contractor_extractor import BudgetContractorExtractor
from contractor_name_validator import ContractorNameValidator

# NEW:
from contractor_onboarding.extractors.budget_contractor_extractor import BudgetContractorExtractor
from contractor_onboarding.validators.contractor_name_validator import ContractorNameValidator
```

### Step 4: Apply Database Schema

```bash
# Option A: Via Supabase Dashboard
# Copy contents of supplier_onboarding_schema.sql
# Paste into SQL Editor and run

# Option B: Via API (if you have a script)
python3 apply_sql_to_supabase.py contractor_onboarding/schema/supplier_onboarding_schema.sql
```

### Step 5: Configure Storage Bucket

In Supabase Dashboard:
1. Go to Storage
2. Create new bucket: `supplier_documents`
3. Set public/private access (recommend private)
4. Configure RLS policies if needed

### Step 6: Test the System

```bash
# Test with a contractor folder
python3 contractor_onboarding/onboard_contractor.py "/path/to/test/contractor"

# Check output files
ls output/
# Should see: <ContractorName>_contractor_data.json
#             <ContractorName>_supplier.sql
```

---

## 🎯 USAGE EXAMPLES

### Example 1: Simple Onboarding

```bash
python3 onboard_contractor.py "/Users/data/NewStepCleaning"
```

**Expected Output:**
```
🚀 CONTRACTOR ONBOARDING
================================================================================
Folder: NewStepCleaning

📥 EXTRACTING DATA FROM DOCUMENTS
   📄 Processing: Company Profile.xlsx
      → Excel file detected
      → Read 45 rows
      → Extracted 2,340 characters
      ✓ Excel data extracted successfully

📊 CONTRACTOR ONBOARDING SUMMARY
================================================================================
✅ Contractor Name: New Step Cleaning Ltd
✅ Email: info@newstep.co.uk
✅ Telephone: 020 1234 5678
✅ Postcode: SW1A 1AA
✅ Services: Cleaning, Facilities Management
✅ Bank Sort Code: 12-34-56
✅ PLI Expiry: 31/03/2025

📊 Data Quality: 🟢 Excellent (90%)

✅ CONTRACTOR ONBOARDING COMPLETE!
```

---

### Example 2: Integrate with Your Building Onboarding

```python
from contractor_onboarding.consolidators.contractor_consolidator import ContractorConsolidator

# In your building onboarding process
def process_building(building_data):
    # ... existing code ...
    
    # Add contractor consolidation
    consolidator = ContractorConsolidator()
    
    # Extract from budget
    if building_data.get('budget_line_items'):
        consolidator.add_from_budget(building_data['budget_line_items'])
    
    # Extract from contracts
    if building_data.get('contracts'):
        consolidator.add_from_contracts(building_data['contracts'])
    
    # Get consolidated list
    contractors = consolidator.get_consolidated_contractors()
    
    # Store in your database
    for contractor in contractors:
        insert_contractor_to_db(contractor)
```

---

### Example 3: Extract from Budget Line Items

```python
from contractor_onboarding.extractors.budget_contractor_extractor import BudgetContractorExtractor

extractor = BudgetContractorExtractor()

budget_items = [
    {
        'description': 'Cleaning services',
        'notes': 'This is the current cleaning contract with New Step',
        'annual_amount': 12000
    },
    {
        'description': 'Lift maintenance',
        'notes': 'Contract is with Jacksons Lift Services Ltd',
        'annual_amount': 8500
    }
]

for item in budget_items:
    contractor_name = extractor.extract_contractor_from_notes(item['notes'])
    print(f"Found: {contractor_name}")

# Output:
# Found: New Step
# Found: Jacksons Lift Services Ltd
```

---

### Example 4: Validate Contractor Names

```python
from contractor_onboarding.validators.contractor_name_validator import ContractorNameValidator

validator = ContractorNameValidator()

names_to_check = [
    "New Step Cleaning Ltd",           # ✅ Valid
    "Gas",                              # ❌ Generic word
    "s and each contractor engaged",   # ❌ Clause text
    "Positive Energy",                  # ✅ Valid
]

for name in names_to_check:
    is_valid = validator.is_valid_contractor(name)
    status = "✅" if is_valid else "❌"
    print(f"{status} {name}")
```

---

## 🔍 EXTRACTION PATTERNS

### UK Phone Number Patterns:
```python
r'\b0\d{10}\b'                        # 01234567890
r'\b0\d{3}\s?\d{3}\s?\d{4}\b'        # 0123 456 7890
r'\+44\s?\d{3,4}\s?\d{3,4}\s?\d{4}\b' # +44 123 456 7890
```

### Email Pattern:
```python
r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
```

### UK Postcode Pattern:
```python
r'\b[A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2}\b'
```

### Sort Code Pattern:
```python
r'\b\d{2}[-\s]?\d{2}[-\s]?\d{2}\b'  # 12-34-56 or 12 34 56
```

### Company Name Pattern:
```python
r'([A-Z][A-Za-z\s&]+(?:Limited|Ltd|LLP|plc|PLC))'
```

---

## 💡 ADVANCED FEATURES

### Fuzzy Matching for Deduplication

**Handles variations like:**
- "New Step" vs "New Step Ltd" vs "New Step Cleaning Ltd"
- "ISS" vs "ISS Facility Services Ltd"

**Algorithm:**
1. Extract core name (remove Ltd, Limited, etc.)
2. Compare core names
3. If >85% similar, treat as same contractor
4. Track aliases

---

### Service Type Inference

**Automatically categorizes from description:**
- "clean" → cleaning
- "lift" → lifts
- "fire" → fire_safety
- "heat" / "boiler" → heating
- "garden" / "landscape" → gardening

---

### Confidence Scoring

**Factors:**
- Required fields found (name, email, phone, postcode)
- Bonus for services found (+10%)
- Bonus for bank details (+10%)
- Bonus for PLI expiry (+10%)

**Scale:** 0.0 to 1.0 (100%)

---

## 📊 DATABASE QUERIES

### Find Contractors by Service:
```sql
SELECT contractor_name, email, telephone
FROM suppliers
WHERE 'Cleaning' = ANY(services_provided)
AND is_approved_contractor = true;
```

### Check Expiring Insurance:
```sql
SELECT * FROM vw_suppliers_documents_expiring;
```

### Get Approved Suppliers:
```sql
SELECT * FROM vw_approved_suppliers
ORDER BY rating DESC;
```

### Update Onboarding Status:
```sql
UPDATE suppliers 
SET onboarding_status = 'approved',
    is_approved_contractor = true,
    approved_by = 'admin@example.com',
    approved_date = CURRENT_DATE
WHERE id = '<supplier_id>';
```

---

## 🛡️ SECURITY CONSIDERATIONS

### 1. Bank Details
- Store only last 4 digits of account number
- Consider encryption for full account numbers
- Use separate secure storage for sensitive data

### 2. Row Level Security (RLS)
- Schema includes RLS policies
- Only authenticated users can view
- Only admins can insert/update

### 3. Storage Bucket
- Set to private
- Use signed URLs for document access
- Configure expiry times

### 4. Data Validation
- Sanitize all inputs
- Use parameterized queries
- Validate email formats
- Verify phone number formats

---

## 🐛 TROUBLESHOOTING

### Issue: "No text extracted from PDF"
**Solution:** PDF may be scanned image. Options:
1. Use OCR service (Tesseract)
2. Manually enter key data
3. Request text-based PDF from contractor

### Issue: "Contractor name not found"
**Solution:** 
1. Check if company name has standard suffix (Ltd, Limited)
2. Look at first few lines of document
3. May need to adjust regex pattern

### Issue: "PLI expiry date incorrect"
**Solution:**
1. Check date format (DD/MM/YYYY vs MM/DD/YYYY)
2. Ensure "expiry" or "renewal" keyword is near date
3. Adjust date patterns in extractor

### Issue: "Duplicate contractors created"
**Solution:**
1. Use ContractorConsolidator
2. Adjust fuzzy matching threshold (currently 0.85)
3. Add alias entries manually

---

## 📈 FUTURE ENHANCEMENTS

### Potential Additions:
- [ ] OCR integration for scanned PDFs
- [ ] AI-powered document classification
- [ ] Automatic document upload to Supabase Storage
- [ ] Email notifications for expiring insurance
- [ ] Contractor portal for self-service updates
- [ ] Integration with Companies House API
- [ ] Automated VAT number validation
- [ ] Credit score integration
- [ ] Performance rating system
- [ ] Automated invoice processing

---

## ✅ PRODUCTION CHECKLIST

Before going live:

- [ ] Database schema applied to production
- [ ] Storage bucket created and configured
- [ ] RLS policies tested
- [ ] Test onboarding with 3+ real contractors
- [ ] Verify SQL generation matches schema
- [ ] Document upload workflow tested
- [ ] Expiry notification system configured
- [ ] Admin approval workflow established
- [ ] Backup strategy in place
- [ ] Error logging configured
- [ ] User permissions assigned

---

## 📞 SUPPORT & MAINTENANCE

### Regular Tasks:
1. **Weekly:** Review pending onboarding requests
2. **Monthly:** Check for expiring insurance
3. **Quarterly:** Audit contractor data quality
4. **Annually:** Review and update service categories

### Monitoring:
- Track extraction confidence scores
- Monitor failed extractions
- Review rejected contractor names
- Audit database for duplicates

---

## 🎉 BENEFITS

✅ **Automated** - Extracts from documents automatically  
✅ **Accurate** - Regex patterns tuned for UK data  
✅ **Smart** - Fuzzy matching prevents duplicates  
✅ **Validated** - Filters out garbage text  
✅ **Complete** - 60+ fields captured  
✅ **Compliant** - Tracks insurance expiry  
✅ **Integrated** - Ready for Supabase  
✅ **Production-Ready** - Full error handling  

---

## 📝 LICENSE & CREDITS

Developed for BlocIQ property management platform.
Adapt and modify as needed for your live project.

---

**END OF MIGRATION GUIDE**


