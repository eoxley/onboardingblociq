# Document Vault System - Complete Guide

## Overview

A comprehensive document management system that organizes all building documents in Supabase Storage with a structured folder hierarchy. **Every document belongs to a specific building ID** and is automatically categorized.

## Folder Structure

Each building gets its own organized vault:

```
building_documents/
└── {building_id}/                    # Each building isolated
    ├── Client Information/
    │   ├── Contact Details/
    │   ├── Service Agreements/
    │   ├── Meeting Minutes/
    │   └── General Admin/
    ├── Finance/
    │   ├── Budgets/
    │   ├── Service Charge Accounts/
    │   ├── Invoices/
    │   ├── Payment Records/
    │   ├── Audit Reports/
    │   └── Year End Accounts/
    ├── General Correspondence/
    │   ├── Emails/
    │   ├── Letters/
    │   ├── Notices/
    │   └── Newsletters/
    ├── Health and Safety/
    │   ├── Fire Risk Assessments/
    │   ├── Emergency Lighting/
    │   ├── EICR/
    │   ├── Fire Door Inspections/
    │   ├── LOLER/
    │   ├── Legionella/
    │   ├── Gas Safety/
    │   ├── Lightning Protection/
    │   ├── Asbestos Surveys/
    │   └── Other Compliance/
    ├── Insurance/
    │   ├── Current Policies/
    │   ├── Certificates/
    │   ├── Claims/
    │   ├── Previous Policies/
    │   └── Policy Wordings/
    ├── Major Works/
    │   ├── Section 20 Notices/
    │   ├── Contractor Quotes/
    │   ├── Project Plans/
    │   ├── Completion Certificates/
    │   ├── Invoices/
    │   └── Correspondence/
    ├── Contracts/
    │   ├── Cleaning/
    │   ├── Gardening/
    │   ├── Lift Maintenance/
    │   ├── Door Entry/
    │   └── Other Contracts/
    ├── Leaseholder Correspondence/
    │   ├── General Enquiries/
    │   ├── Complaints/
    │   ├── Lease Variations/
    │   └── Subletting Notices/
    ├── Building Drawings and Plans/
    │   ├── Architectural/
    │   ├── Structural/
    │   ├── Electrical/
    │   ├── Plumbing/
    │   └── Fire Safety/
    └── Leases/
        ├── Original Leases/
        ├── Lease Extensions/
        └── Variations/
```

## Supported File Types

All common document and image formats:

### Documents
- PDF (`.pdf`)
- Word (`.doc`, `.docx`)
- Excel (`.xls`, `.xlsx`)
- Text (`.txt`)

### Images
- JPEG (`.jpg`, `.jpeg`)
- PNG (`.png`)
- GIF (`.gif`)
- BMP (`.bmp`)
- TIFF (`.tiff`)

### Other
- ZIP archives (`.zip`)
- Outlook messages (`.msg`)
- Email files (`.eml`)

## Setup

### 1. Initialize Document Vault

```bash
# Set environment variables
export SUPABASE_URL="https://xqxaatvykmaaynqeoemy.supabase.co"
export SUPABASE_SERVICE_KEY="your-service-key"

# Run setup script
python3 scripts/setup_document_vault.py
```

This creates the folder structure definition and ensures the storage bucket exists.

### 2. Apply Database Schema

```bash
# Add vault columns to documents table
psql "$DATABASE_URL" -f scripts/schema/document_vault_schema.sql
```

This adds:
- Vault-specific columns (`storage_url`, `vault_category`, `vault_subfolder`)
- Document category views
- Access logging table

## Usage

### Upload Documents Programmatically

```python
from document_vault_manager import DocumentVaultManager

# Initialize
vault = DocumentVaultManager(
    supabase_url="https://xqxaatvykmaaynqeoemy.supabase.co",
    supabase_key="your-service-key"
)

# Upload a document
result = vault.upload_document(
    file_path="/path/to/Buildings_Insurance_2024.pdf",
    building_id="550e8400-e29b-41d4-a716-446655440000",
    category="insurance_certificate"
)

if result['success']:
    print(f"✅ Uploaded to: {result['storage_path']}")
    print(f"   URL: {result['url']}")
```

### Migrate Existing Documents

```bash
# Migrate all documents for a building
python3 scripts/migrate_documents_to_vault.py \
    550e8400-e29b-41d4-a716-446655440000 \
    /path/to/building/documents
```

This will:
1. Scan all files in the folder
2. Automatically categorize each file
3. Upload to appropriate vault location
4. Record in database with building_id

### Integration with Onboarder

```python
# In your onboarder.py or extraction scripts
from document_vault_manager import DocumentVaultManager

# After extracting data from a document
vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

# Upload to vault
result = vault.upload_document(
    file_path=local_file_path,
    building_id=building_id,
    category=document_category,  # e.g., 'lease', 'insurance_certificate', 'fra'
    metadata={
        'extracted_at': datetime.now().isoformat(),
        'confidence': 0.92,
        'extractor_version': '2.0'
    }
)

# Store URL in database
document_url = result['url']
```

## Automatic Categorization

The system automatically categorizes documents based on filename:

```python
# These filenames are automatically categorized:

"Buildings_Insurance_2024.pdf"           → Insurance/Certificates
"FRA_Annual_Inspection_2024.pdf"         → Health and Safety/Fire Risk Assessments
"Flat_259_Lease.pdf"                     → Leases/Original Leases
"Budget_2024-2025.xlsx"                  → Finance/Budgets
"Emergency_Lighting_Certificate.pdf"     → Health and Safety/Emergency Lighting
"Section_20_Notice.pdf"                  → Major Works/Section 20 Notices
"Cleaning_Contract_2024.pdf"             → Contracts/Cleaning
```

## Database Integration

### Documents Table (Extended)

```sql
-- Each document record includes:
{
    id: uuid,
    building_id: uuid,              -- BUILDING OWNERSHIP
    filename: text,
    category: text,                 -- Original category
    vault_category: text,           -- Main folder
    vault_subfolder: text,          -- Subfolder
    path: text,                     -- Storage path
    storage_url: text,              -- Signed URL
    file_size: bigint,              -- Bytes
    mime_type: text,
    uploaded_at: timestamptz,
    status: text,                   -- 'active' or 'archived'
    metadata: jsonb                 -- Additional data
}
```

### Query Documents by Building

```sql
-- Get all documents for a building
SELECT * FROM documents
WHERE building_id = '550e8400-...'
  AND status = 'active';

-- Get documents by category
SELECT * FROM documents
WHERE building_id = '550e8400-...'
  AND vault_category = 'Insurance'
  AND status = 'active';

-- Get document counts by category
SELECT * FROM v_document_categories
WHERE building_id = '550e8400-...';

-- Get building document summary
SELECT * FROM v_building_document_summary
WHERE building_id = '550e8400-...';
```

## Security & Access Control

### Storage Bucket

- Bucket: `building_documents` (private by default)
- Access: Via signed URLs (expires in 1 year)
- Isolation: Each building has separate folder

### Row Level Security (RLS)

Add RLS policies in Supabase:

```sql
-- Only allow access to documents for buildings user has access to
CREATE POLICY "Users can only access their building documents"
    ON documents
    FOR SELECT
    USING (
        building_id IN (
            SELECT building_id
            FROM user_building_access
            WHERE user_id = auth.uid()
        )
    );
```

## Migration Workflow

### For Existing Buildings

1. **Export documents from current location**
   ```bash
   # Your current document storage
   /path/to/Connaught_Square/documents/
   ```

2. **Run migration script**
   ```bash
   python3 scripts/migrate_documents_to_vault.py \
       550e8400-... \
       /path/to/Connaught_Square/documents/
   ```

3. **Verify in Supabase**
   - Go to Storage → building_documents
   - Check folder structure
   - Verify documents table updated

4. **Update application to use vault URLs**
   - Replace local file paths with `storage_url`
   - Generate signed URLs for access

## API Examples

### Get Document URL

```python
# Get signed URL for a document
url = vault.get_document_url(
    building_id="550e8400-...",
    filename="Buildings_Insurance_2024.pdf"
)
# Returns: https://xqxaatvykmaaynqeoemy.supabase.co/storage/v1/...
```

### List Building Documents

```python
# List all documents for a building
documents = vault.list_documents(
    building_id="550e8400-...",
    category="insurance_certificate"  # Optional filter
)

for doc in documents:
    print(f"{doc['filename']} ({doc['vault_category']}/{doc['vault_subfolder']})")
```

### Upload Multiple Files

```python
# Upload entire folder
results = vault.upload_folder(
    folder_path="/path/to/documents",
    building_id="550e8400-...",
    category_mapping={
        'insurance': 'insurance_certificate',
        'lease': 'lease',
        'budget': 'budget'
    }
)

print(f"Uploaded {len([r for r in results if r['success']])} files")
```

## Views for Reporting

### Document Categories View

```sql
SELECT * FROM v_document_categories
WHERE building_id = '550e8400-...';

-- Returns:
-- vault_category    | vault_subfolder         | document_count | total_size_mb
-- Insurance         | Certificates            | 14             | 23.5
-- Health and Safety | Fire Risk Assessments   | 3              | 12.8
-- Leases            | Original Leases         | 256            | 145.2
```

### Building Document Summary

```sql
SELECT * FROM v_building_document_summary
WHERE building_id = '550e8400-...';

-- Returns:
-- total_documents | category_count | total_size_mb | first_upload | last_upload
-- 387             | 8              | 245.6         | 2024-01-15   | 2024-10-10
```

## Category Mappings

All supported categories:

```python
CATEGORY_MAPPING = {
    # Insurance
    'insurance_certificate': ('Insurance', 'Certificates'),
    'insurance_policy': ('Insurance', 'Current Policies'),
    'insurance_claim': ('Insurance', 'Claims'),
    'policy_wording': ('Insurance', 'Policy Wordings'),

    # Health & Safety
    'fire_risk_assessment': ('Health and Safety', 'Fire Risk Assessments'),
    'emergency_lighting': ('Health and Safety', 'Emergency Lighting'),
    'eicr': ('Health and Safety', 'EICR'),
    'fire_doors': ('Health and Safety', 'Fire Door Inspections'),
    'loler': ('Health and Safety', 'LOLER'),
    'legionella': ('Health and Safety', 'Legionella'),
    'gas_safety': ('Health and Safety', 'Gas Safety'),
    'lightning_protection': ('Health and Safety', 'Lightning Protection'),
    'asbestos': ('Health and Safety', 'Asbestos Surveys'),

    # Leases
    'lease': ('Leases', 'Original Leases'),
    'lease_extension': ('Leases', 'Lease Extensions'),
    'lease_variation_doc': ('Leases', 'Variations'),

    # Finance
    'budget': ('Finance', 'Budgets'),
    'accounts': ('Finance', 'Service Charge Accounts'),
    'year_end_accounts': ('Finance', 'Year End Accounts'),
    'invoice': ('Finance', 'Invoices'),
    'audit': ('Finance', 'Audit Reports'),

    # ... and more (see document_vault_manager.py for complete list)
}
```

## Benefits

### ✅ Organization
- Structured folder hierarchy
- Automatic categorization
- Easy to navigate

### ✅ Scalability
- Supabase Storage handles all file types
- No file size limits (within Supabase plan)
- Efficient for hundreds/thousands of documents

### ✅ Security
- Private storage by default
- Signed URLs with expiry
- Row-level security support
- Building-level isolation

### ✅ Accessibility
- Access from anywhere via URL
- No local storage required
- Mobile-friendly

### ✅ Integration
- Works with existing onboarder
- Database records link to storage
- Metadata support

## Files Created

1. **`scripts/setup_document_vault.py`** - Initial setup
2. **`document_vault_manager.py`** - Core library
3. **`scripts/migrate_documents_to_vault.py`** - Migration tool
4. **`scripts/schema/document_vault_schema.sql`** - Database schema
5. **`DOCUMENT_VAULT_GUIDE.md`** - This guide

## Next Steps

1. **Set up Supabase Storage bucket**
   - Go to Supabase dashboard → Storage
   - Create bucket: `building_documents` (private)

2. **Apply database schema**
   ```bash
   psql "$DATABASE_URL" -f scripts/schema/document_vault_schema.sql
   ```

3. **Migrate existing documents**
   ```bash
   python3 scripts/migrate_documents_to_vault.py <building_id> <folder_path>
   ```

4. **Integrate with onboarder**
   - Import `DocumentVaultManager`
   - Upload documents during extraction
   - Store `storage_url` in database

---

**All documents are isolated by building_id. Each building has its own complete folder structure in Supabase Storage.** 🎯
