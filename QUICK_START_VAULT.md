# Document Vault - Quick Start Guide

## Current Status

🟨 **95% Complete** - Database schema needs to be applied

## What You Need To Do (2 Steps)

### Step 1: Apply Database Schema (2 minutes)

1. Open Supabase SQL Editor:
   👉 https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new

2. Copy and paste this SQL:

```sql
-- Add vault columns
ALTER TABLE documents ADD COLUMN IF NOT EXISTS storage_url TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS mime_type TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_category TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS vault_subfolder TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_documents_vault_category
    ON documents(building_id, vault_category);

CREATE INDEX IF NOT EXISTS idx_documents_storage_url
    ON documents(storage_url) WHERE storage_url IS NOT NULL;
```

3. Click **"Run"** (bottom right)

4. ✅ You should see: "Success. No rows returned"

### Step 2: Upload Documents

```bash
# Set environment (if not already set)
export SUPABASE_URL="https://xqxaatvykmaaynqeoemy.supabase.co"
export SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxeGFhdHZ5a21hYXlucWVvZW15Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTE5Mzk5NCwiZXhwIjoyMDY2NzY5OTk0fQ.4Qza6DOdmF8s6jFMIkMwKgaU_DkIUspap8bOVldwMmk"

# Upload Connaught Square documents
python3 upload_to_vault_only.py \
    ceec21e6-b91e-4c40-9a57-51994caf3ab7 \
    "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
```

**Expected result**:
- ~350+ files uploaded
- Organized into 10 categories
- All accessible via Supabase Storage

## What You Get

### Organized Storage
```
building_documents/
└── ceec21e6-b91e-4c40-9a57-51994caf3ab7/
    ├── Insurance/Certificates/
    ├── Insurance/Current Policies/
    ├── Health and Safety/Fire Risk Assessments/
    ├── Health and Safety/EICR/
    ├── Health and Safety/Fire Door Inspections/
    ├── Health and Safety/Legionella/
    ├── Health and Safety/Asbestos Surveys/
    ├── Leases/Original Leases/
    ├── Finance/Service Charge Accounts/
    ├── Contracts/Lift Maintenance/
    ├── Client Information/Meeting Minutes/
    └── ... and 40+ more subfolders
```

### Database Integration
```sql
-- Query documents by category
SELECT * FROM documents
WHERE building_id = 'ceec21e6-b91e-4c40-9a57-51994caf3ab7'
  AND vault_category = 'Insurance';

-- Get document count by category
SELECT vault_category, vault_subfolder, COUNT(*)
FROM documents
WHERE building_id = 'ceec21e6-b91e-4c40-9a57-51994caf3ab7'
GROUP BY vault_category, vault_subfolder;
```

### Access URLs
Every document gets a signed URL:
```
https://xqxaatvykmaaynqeoemy.supabase.co/storage/v1/object/sign/building_documents/...
```

## Verify It Worked

### In Supabase Dashboard:

1. **Storage**:
   - Go to Storage → building_documents
   - Click folder: `ceec21e6-b91e-4c40-9a57-51994caf3ab7`
   - You should see organized folders

2. **Database**:
   - Go to Table Editor → documents
   - Filter by `building_id = ceec21e6-b91e-4c40-9a57-51994caf3ab7`
   - You should see ~350+ records with `storage_url`, `vault_category`, `vault_subfolder`

### Command Line:

```bash
# Check uploaded count
python3 -c "
from supabase import create_client
import os

supabase = create_client(
    'https://xqxaatvykmaaynqeoemy.supabase.co',
    os.getenv('SUPABASE_SERVICE_KEY')
)

result = supabase.table('documents').select(
    'vault_category', count='exact'
).eq('building_id', 'ceec21e6-b91e-4c40-9a57-51994caf3ab7').execute()

print(f'Total documents: {result.count}')
"
```

## Troubleshooting

### "Could not find the 'category' column"
❌ Schema not applied yet
✅ Run Step 1 above

### "Tenant or user not found" (psql)
❌ Direct PostgreSQL connection blocked
✅ Use Supabase SQL Editor instead (Step 1)

### "File not found"
❌ Folder path incorrect
✅ Check folder exists: `ls "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"`

### Files uploaded but can't see in Storage
✅ Files are there! Check:
   - Storage → building_documents → ceec21e6-b91e-4c40-9a57-51994caf3ab7

## What's Next?

Once documents are uploaded, you can:

1. **Query by category**:
   ```python
   from document_vault_manager import DocumentVaultManager
   vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_SERVICE_KEY)

   docs = vault.list_documents(
       building_id='ceec21e6-b91e-4c40-9a57-51994caf3ab7',
       category='insurance_certificate'
   )
   ```

2. **Get document URLs**:
   ```python
   url = vault.get_document_url(
       building_id='ceec21e6-b91e-4c40-9a57-51994caf3ab7',
       filename='Buildings_Insurance_2024.pdf'
   )
   ```

3. **Integrate with PDF Health Check**:
   ```python
   # In generate_health_check_from_supabase_v3.py
   insurance_docs = supabase.table('documents')\
       .select('filename, storage_url')\
       .eq('building_id', building_id)\
       .eq('vault_category', 'Insurance')\
       .execute()

   # Add clickable links in PDF
   for doc in insurance_docs.data:
       pdf.add_link(doc['filename'], doc['storage_url'])
   ```

## Summary

✅ Storage bucket: Ready
✅ Python library: Ready
✅ Migration scripts: Ready
✅ Auto-categorization: Ready
⚠️  Database schema: **Needs Step 1**

**Total time to complete**: ~5 minutes
**Files to upload**: ~377 (Connaught Square)
**Categories**: 10 main, 52 subfolders

---

**After Step 1, run Step 2, and you're done!** 🎉
