# 🔨 CONTRACTOR ONBOARDING SYSTEM

Simple system to onboard contractors with automatic data extraction and SQL generation.

---

## 📋 WHAT IT DOES

### Extracts From Documents:
- ✅ Excel spreadsheets (.xlsx, .xls)
- ✅ PDF documents
- ✅ Word documents (.docx, .doc)

### Data Extracted:
- ✅ Contractor name
- ✅ Address & postcode
- ✅ Email & telephone
- ✅ Services provided
- ✅ Bank account name
- ✅ Bank sort code
- ✅ PLI expiry date
- ✅ Has audited accounts (auto-detected)
- ✅ Has certificate of incorporation (auto-detected)

### Output:
- ✅ JSON file with extracted data
- ✅ SQL file for Supabase insertion
- ✅ Document list for upload

---

## 🚀 QUICK START

### 1. Apply Schema to Supabase (First Time Only)

```bash
python3 apply_with_new_credentials.py contractor_onboarding_schema.sql
```

This creates:
- `contractor_onboarding` table (main contractor data)
- `contractor_onboarding_documents` table (document tracking)
- Views for expiring documents and approved contractors
- Storage bucket reference: `contractor_documents`

---

### 2. Onboard a Contractor

```bash
python3 onboard_contractor.py "/path/to/contractor/folder"
```

**Example:**
```bash
python3 onboard_contractor.py "/Users/ellie/Downloads/NewStepCleaning"
```

**The folder should contain:**
- Contractor information sheet (Excel/PDF/Word)
- PLI certificate (PDF)
- Audited accounts (optional)
- Certificate of incorporation (optional)
- Bank details document (optional)

---

### 3. Review Output

After running, check:

```bash
output/
├── <ContractorName>_contractor_data.json  ← Extracted data
└── <ContractorName>_contractor.sql        ← SQL to apply
```

---

### 4. Apply to Supabase

```bash
python3 apply_with_new_credentials.py output/<ContractorName>_contractor.sql
```

---

## 📊 SCHEMA DETAILS

### **contractor_onboarding** Table (60+ fields)

#### Contact Information:
- contractor_name, trading_name, company_number
- address, postcode, city, country
- email, telephone, mobile, website
- contact_person (name, role, email, phone)

#### Services:
- services_provided (array)
- service_categories (array)
- specializations, years_in_business

#### Banking:
- bank_account_name
- bank_name
- bank_sort_code (XX-XX-XX)
- bank_account_number
- bank_iban

#### Compliance:
- **pli_expiry_date** ← Critical
- pli_insurer, pli_policy_number, pli_coverage_amount
- pli_status (auto-calculated)
- days_until_pli_expiry (auto-calculated)
- eli_expiry_date (Employers Liability)
- pi_expiry_date (Professional Indemnity)

#### Documentation:
- **has_audited_accounts** (boolean)
- **has_certificate_of_incorporation** (boolean)
- has_vat_certificate
- has_health_safety_policy
- has_environmental_policy
- has_quality_assurance_cert

#### Onboarding Status:
- onboarding_status ('pending', 'in_progress', 'approved', 'rejected')
- onboarding_stage
- approved_by, approved_date
- rejection_reason

#### Documents:
- pli_certificate_path
- audited_accounts_path
- certificate_of_incorporation_path
- total_documents_uploaded
- documents_storage_folder

#### Performance:
- rating (1.0-5.0)
- is_preferred_contractor
- is_approved_contractor
- contracts_completed
- on_time_completion_rate

---

## 📁 DOCUMENT STORAGE

### Supabase Storage Bucket: `contractor_documents`

**Structure:**
```
contractor_documents/
└── <contractor_id>/
    ├── pli_certificate.pdf
    ├── audited_accounts.pdf
    ├── certificate_of_incorporation.pdf
    ├── bank_details.pdf
    └── other_documents/
```

---

## 🔍 EXTRACTION LOGIC

### Automatic Detection:

**Contractor Name:**
- Looks for company names ending in "Limited", "Ltd", "LLP", "plc"
- Usually at top of document

**Email:**
- Regex pattern: `name@domain.com`

**Telephone:**
- UK formats: `01234567890`, `0123 456 7890`, `+44 123 456 7890`

**Postcode:**
- UK format: `SW1A 1AA`

**Sort Code:**
- Format: `12-34-56` or `12 34 56`
- Looks near "sort code" text

**PLI Expiry:**
- Looks for dates near: "expiry", "expires", "renewal", "valid until"

**Services:**
- Scans for keywords: cleaning, lift, electrical, plumbing, heating, etc.

**Document Types:**
- Audited accounts: filename contains "accounts", "financial", "audit"
- Certificate: filename contains "incorporation", "companies house", "certificate"

---

## 🎯 EXAMPLE WORKFLOW

### Input Folder:
```
NewStepCleaning/
├── New Step Company Profile.xlsx
├── PLI Insurance Certificate 2025.pdf
├── Audited Accounts 2024.pdf
└── Certificate of Incorporation.pdf
```

### Run:
```bash
python3 onboard_contractor.py "/Users/ellie/Downloads/NewStepCleaning"
```

### Output:
```
📊 EXTRACTION RESULTS
✅ Contractor Name: New Step Limited
✅ Email: info@newstep.co.uk
✅ Telephone: 020 1234 5678
✅ Postcode: SW1A 1AA
✅ Services: Cleaning, Facilities Management
✅ Bank Sort Code: 12-34-56
✅ Bank Account Name: New Step Limited
✅ PLI Expiry: 31/03/2025
✅ Has Audited Accounts: True
✅ Has Certificate of Incorporation: True

📊 Confidence: 90%
📁 Documents: 4

✅ Data saved to: output/NewStepCleaning_contractor_data.json
✅ SQL generated: output/NewStepCleaning_contractor.sql
```

### Apply to Database:
```bash
python3 apply_with_new_credentials.py output/NewStepCleaning_contractor.sql
```

---

## 📋 VIEWS CREATED

### 1. `vw_contractors_documents_expiring`
Shows contractors with:
- PLI expiring in next 60 days
- Incomplete onboarding status

### 2. `vw_approved_contractors`
Shows approved contractors with:
- Current PLI
- Rating and performance metrics
- Services offered

---

## 🔧 ADVANCED USAGE

### Extract Only:
```bash
python3 contractor_extractor.py "/path/to/folder"
```

### Generate SQL Only:
```bash
python3 contractor_sql_generator.py contractor_data.json -o contractor.sql
```

### Check Expiring PLI:
```sql
SELECT * FROM vw_contractors_documents_expiring;
```

### Find Contractors by Service:
```sql
SELECT contractor_name, services_provided, email
FROM contractor_onboarding
WHERE 'Cleaning' = ANY(services_provided);
```

---

## ⚙️ SCHEMA FEATURES

### Auto-Calculations:
- ✅ `days_until_pli_expiry` - Auto-calculated from expiry date
- ✅ `pli_status` - Auto-set to 'current', 'expiring_soon', 'expired'
- ✅ `updated_at` - Auto-updated on changes

### Triggers:
- ✅ PLI expiry calculation trigger
- ✅ Update timestamp trigger

### Row-Level Security:
- ✅ Authenticated users can view
- ✅ Only admins/managers can edit

---

## 📊 REQUIRED FIELDS

### Minimum Required:
- ✅ Contractor name
- ✅ PLI expiry date (critical)

### Highly Recommended:
- ✅ Email
- ✅ Telephone
- ✅ Postcode
- ✅ Services provided
- ✅ Bank details

### Optional but Valuable:
- Certificate of incorporation
- Audited accounts
- Additional insurance (ELI, PI)
- Certifications (Gas Safe, NICEIC, etc.)

---

## 🎉 BENEFITS

✅ **Simple** - One command to onboard  
✅ **Automatic** - Extracts from Excel/PDF/Word  
✅ **Complete** - 60+ fields captured  
✅ **Compliant** - Tracks PLI, accounts, certificates  
✅ **Integrated** - Links to Supabase Storage  
✅ **Smart** - Auto-calculates expiry warnings  

---

## 📁 FILES CREATED

1. **contractor_onboarding_schema.sql** - Database schema
2. **contractor_extractor.py** - Data extraction from documents
3. **contractor_sql_generator.py** - SQL generation
4. **onboard_contractor.py** - Complete workflow (recommended)

---

## 🚀 READY TO USE

The contractor onboarding system is ready!

Try it with any contractor folder containing their documents.

