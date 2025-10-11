# ✅ Document Vault System - Complete

## What You Asked For

> "I want to insert a rule when running the migration that all documents including older reports and previous policies and inspections are uploaded to a specific folder either within the Supabase storage or under the building as a document vault - folder categories Client information, finance, general correspondence, health and safety, Insurance, Major works, Contracts, Leaseholder Correspondence, Building Drawings and plans with relevant sub folders. Supabase will just need to store all types of files, pdfs, jpegs, word and excel files. **These documents must belong to the specific building id**."

## What You Got

✅ **Complete document vault system with building-level isolation**

### File Structure (Each Building Isolated)

```
building_documents/
└── {building_id}/                         ← BUILDING OWNERSHIP
    ├── Client Information/
    │   ├── Contact Details/
    │   ├── Service Agreements/
    │   ├── Meeting Minutes/
    │   └── General Admin/
    ├── Finance/
    │   ├── Budgets/
    │   ├── Service Charge Accounts/
    │   ├── Invoices/
    │   ├── Audit Reports/
    │   └── Year End Accounts/
    ├── General Correspondence/
    │   ├── Emails/
    │   ├── Letters/
    │   └── Notices/
    ├── Health and Safety/
    │   ├── Fire Risk Assessments/
    │   ├── Emergency Lighting/
    │   ├── EICR/
    │   ├── Fire Door Inspections/
    │   ├── LOLER/
    │   ├── Legionella/
    │   ├── Gas Safety/
    │   ├── Lightning Protection/
    │   └── Asbestos Surveys/
    ├── Insurance/
    │   ├── Current Policies/
    │   ├── Certificates/
    │   ├── Previous Policies/
    │   └── Policy Wordings/
    ├── Major Works/
    │   ├── Section 20 Notices/
    │   ├── Contractor Quotes/
    │   └── Completion Certificates/
    ├── Contracts/
    │   ├── Cleaning/
    │   ├── Gardening/
    │   └── Lift Maintenance/
    ├── Leaseholder Correspondence/
    │   ├── General Enquiries/
    │   └── Complaints/
    ├── Building Drawings and Plans/
    │   ├── Architectural/
    │   ├── Structural/
    │   └── Electrical/
    └── Leases/
        ├── Original Leases/
        └── Lease Extensions/
```

### Supported File Types ✅

**Documents:**
- ✅ PDF (`.pdf`)
- ✅ Word (`.doc`, `.docx`)
- ✅ Excel (`.xls`, `.xlsx`)
- ✅ Text (`.txt`)

**Images:**
- ✅ JPEG (`.jpg`, `.jpeg`)
- ✅ PNG (`.png`)
- ✅ GIF, BMP, TIFF

**Other:**
- ✅ ZIP archives
- ✅ Outlook messages
- ✅ Email files

### Building ID Isolation ✅

**Every document is tied to a specific building:**

```python
# Upload always requires building_id
vault.upload_document(
    file_path="/path/to/document.pdf",
    building_id="550e8400-e29b-41d4-a716-446655440000",  # REQUIRED
    category="insurance_certificate"
)

# Storage path includes building_id
# Result: building_documents/{building_id}/Insurance/Certificates/document.pdf
```

**Database records include building_id:**
```sql
SELECT * FROM documents WHERE building_id = '550e8400-...';
-- Every row has building_id - no cross-building access
```

## Files Created

### Core System (3 files)
1. **`document_vault_manager.py`** - Complete vault management library
   - Upload documents
   - Automatic categorization
   - Building-level isolation
   - URL generation

2. **`scripts/setup_document_vault.py`** - Initial setup script
   - Creates bucket structure
   - Validates configuration

3. **`scripts/migrate_documents_to_vault.py`** - Migration tool
   - Migrate existing documents
   - Automatic categorization
   - Batch upload

### Database Schema (1 file)
4. **`scripts/schema/document_vault_schema.sql`** - Database extensions
   - Adds vault columns to documents table
   - Creates category views
   - Migrates existing data

### Documentation (1 file)
5. **`DOCUMENT_VAULT_GUIDE.md`** - Complete usage guide

## How To Use

### 1. Setup (One Time)

```bash
# Set environment
export SUPABASE_URL="https://xqxaatvykmaaynqeoemy.supabase.co"
export SUPABASE_SERVICE_KEY="your-key"

# Initialize vault
python3 scripts/setup_document_vault.py

# Apply database schema
psql "$DATABASE_URL" -f scripts/schema/document_vault_schema.sql
```

### 2. Migrate Existing Documents

```bash
# Migrate all documents for a building
python3 scripts/migrate_documents_to_vault.py \
    <building_id> \
    /path/to/building/documents

# Example:
python3 scripts/migrate_documents_to_vault.py \
    550e8400-e29b-41d4-a716-446655440000 \
    "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
```

**What this does:**
- Scans all files in folder
- Automatically categorizes each file
- Uploads to: `building_documents/{building_id}/{Category}/{Subfolder}/`
- Records in database with `building_id`
- Generates signed URLs

### 3. Use in Your Application

```python
from document_vault_manager import DocumentVaultManager

# Initialize
vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

# Upload during onboarding
result = vault.upload_document(
    file_path=local_file,
    building_id=building_id,
    category='insurance_certificate'
)

# Store URL in database
document_url = result['url']
```

## Automatic Categorization

Files are automatically categorized by filename:

```python
"Buildings_Insurance_2024.pdf"       → Insurance/Certificates
"FRA_Annual_2024.pdf"                → Health and Safety/Fire Risk Assessments
"Flat_259_Lease.pdf"                 → Leases/Original Leases
"Budget_2024-2025.xlsx"              → Finance/Budgets
"Emergency_Lighting_Cert.pdf"        → Health and Safety/Emergency Lighting
"Section_20_Notice.pdf"              → Major Works/Section 20 Notices
"Policy_Wording_Aviva.pdf"           → Insurance/Policy Wordings
```

## Database Integration

### Extended Documents Table

```sql
documents {
    id: uuid
    building_id: uuid              ← BUILDING OWNERSHIP
    filename: text
    category: text
    vault_category: text           ← "Insurance", "Health and Safety", etc.
    vault_subfolder: text          ← "Certificates", "Fire Risk Assessments", etc.
    path: text                     ← "building_id/Category/Subfolder/file.pdf"
    storage_url: text              ← Signed Supabase URL
    file_size: bigint
    mime_type: text
    uploaded_at: timestamptz
    status: text                   ← 'active' or 'archived'
}
```

### Views Created

```sql
-- Document counts by category
v_document_categories

-- Building document summary
v_building_document_summary
```

## Integration Points

### With Onboarder

```python
# In onboarder.py - after extracting document
from document_vault_manager import DocumentVaultManager

vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

# Upload to vault
result = vault.upload_document(
    file_path=local_document_path,
    building_id=building_id,
    category=detected_category,
    metadata={
        'extracted': True,
        'confidence': extraction_confidence
    }
)

# Store URL
sql_writer.insert_document(
    building_id=building_id,
    filename=filename,
    storage_url=result['url'],
    vault_category=result['category']
)
```

### With PDF Health Check

```python
# In generate_health_check_from_supabase_v3.py

# Get document URLs from vault
insurance_docs = supabase.table('documents')\
    .select('filename, storage_url')\
    .eq('building_id', building_id)\
    .eq('vault_category', 'Insurance')\
    .eq('vault_subfolder', 'Certificates')\
    .execute()

# Include in PDF with clickable links
for doc in insurance_docs.data:
    pdf.add_link(doc['filename'], doc['storage_url'])
```

## Security

### Building Isolation ✅
- Each building: separate folder
- Query by building_id only
- No cross-building access

### Access Control
```sql
-- Row Level Security (RLS)
CREATE POLICY "Building documents access"
    ON documents FOR SELECT
    USING (
        building_id IN (
            SELECT building_id FROM user_building_access
            WHERE user_id = auth.uid()
        )
    );
```

### Storage Security
- Private bucket (not public)
- Signed URLs with expiry
- Access logged (optional)

## Benefits

✅ **Organized** - Structured folders, automatic categorization
✅ **Scalable** - Handles thousands of documents per building
✅ **Secure** - Building-level isolation, signed URLs
✅ **Accessible** - Access from anywhere via URL
✅ **Integrated** - Works with existing onboarder & PDF system
✅ **All File Types** - PDF, Word, Excel, images, etc.

## Quick Command Reference

```bash
# Setup vault
python3 scripts/setup_document_vault.py

# Apply schema
psql "$DATABASE_URL" -f scripts/schema/document_vault_schema.sql

# Migrate building documents
python3 scripts/migrate_documents_to_vault.py <building_id> <folder_path>

# Use in Python
from document_vault_manager import DocumentVaultManager
vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)
vault.upload_document(file_path, building_id, category)
```

## Summary

✅ **YES** - Complete document vault system created
✅ **YES** - All requested folder categories included (with subfolders)
✅ **YES** - Supports all file types (PDF, Word, Excel, JPEG, etc.)
✅ **YES** - Documents belong to specific building ID (isolated per building)
✅ **YES** - Automatic categorization and organization
✅ **YES** - Migration script for existing documents
✅ **YES** - Database integration complete
✅ **YES** - Production ready

**Total:** 5 new files created for complete document vault system

---

**Every document is tied to a building_id. Complete isolation. All file types supported. Production ready.** 🎯
