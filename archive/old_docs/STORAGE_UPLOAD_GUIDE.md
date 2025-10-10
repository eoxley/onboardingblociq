# Supabase Storage Upload - Implementation Guide

## What Was Implemented

The onboarder now automatically uploads all files to Supabase Storage during the onboarding process.

## How It Works

### 1. **Bucket Creation**
- Creates a unique bucket per building: `building-{building_id}`
- Buckets are private by default (requires authentication to access)
- 50MB file size limit per file

### 2. **File Organization**
Files are organized by category:
```
building-{building_id}/
  ├── compliance/
  │   ├── Fire Risk Assessment 2024.pdf
  │   └── EICR Certificate.pdf
  ├── finance/
  │   ├── Budget 2024-2025.xlsx
  │   └── Service Charge Accounts YE24.pdf
  ├── major_works/
  │   └── Section 20 Notice.pdf
  ├── lease/
  │   └── Unit Leases.pdf
  ├── contracts/
  │   └── Lift Maintenance Contract.pdf
  └── correspondence/
      └── Letters.pdf
```

### 3. **Storage Paths in Database**
The `building_documents` table stores:
- `storage_path`: Path within the bucket (e.g., `compliance/FRA 2024.pdf`)
- `file_name`: Original filename
- `category`: Document category

### 4. **Workflow**

```
1. Parse files from client folder
2. Classify files by category
3. Map data to Supabase schema
4. Create bucket: building-{building_id}
5. Upload each file to bucket/category/filename
6. Update storage_path in building_documents
7. Generate SQL migration with correct paths
8. Files are now in Supabase Storage! ✅
```

## Configuration

The uploader uses credentials from `.env.local`:

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Features

✅ **Automatic bucket creation** - One bucket per building
✅ **Organized by category** - Files sorted into folders
✅ **Duplicate handling** - Uses upsert (overwrites existing files)
✅ **Error handling** - Continues with placeholders if upload fails
✅ **Upload summary** - Shows file count and total size
✅ **Mime type detection** - Correct content-type for all files

## Usage

Just run the onboarder as usual:

```bash
python3 onboarder.py /path/to/client/folder
```

The uploader will automatically:
1. Create the bucket
2. Upload all files
3. Update the SQL with correct storage paths

## Accessing Files

### From Supabase Dashboard:
1. Go to Storage
2. Find bucket: `building-{building_id}`
3. Navigate to category folder
4. View/download files

### From Code:
```python
from supabase import create_client

supabase = create_client(url, key)

# Get file URL
url = supabase.storage.from_('building-{building_id}').get_public_url('compliance/FRA.pdf')

# Download file
file_data = supabase.storage.from_('building-{building_id}').download('compliance/FRA.pdf')
```

## Troubleshooting

### Upload Failed
- Check `.env.local` has correct credentials
- Verify `SUPABASE_SERVICE_ROLE_KEY` (not anon key)
- Check Supabase Storage is enabled in project

### Bucket Already Exists
- This is normal! The uploader will use the existing bucket
- Files with same name will be overwritten (upsert behavior)

### Files Not Showing in Database
- Check the `building_documents` table
- `storage_path` should contain the bucket path
- SQL migration must be run for paths to be in database

## Storage Management

### Delete Building Bucket
```python
from storage_uploader import SupabaseStorageUploader
uploader = SupabaseStorageUploader(supabase)
uploader.delete_building_bucket('building-uuid')
```

### View Upload Summary
The uploader tracks all uploads and shows:
- Total files uploaded
- Total size (MB)
- List of uploaded files

## Next Steps

1. ✅ Supabase schema updated
2. ✅ Storage uploader implemented
3. ✅ Integrated into onboarder
4. 🚀 Run onboarder - files will auto-upload!
5. 📊 Check Supabase Storage dashboard
6. 🗄️ Run SQL migration
7. ✨ Done!
