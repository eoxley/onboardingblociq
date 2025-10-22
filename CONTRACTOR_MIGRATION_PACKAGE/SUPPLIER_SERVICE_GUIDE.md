# 🔧 Supplier Onboarding Service - Pure Logic Layer

## 📋 Overview

This is the **pure business logic** extracted from the supplier application - **NO GUI, NO CLI** - just reusable service classes.

**File:** `supplier_onboarding_service.py`

---

## 🎯 What It Provides

### Main Service: `SupplierOnboardingService`
Core business logic for onboarding a single supplier

### Batch Service: `SupplierBatchService`
Process multiple suppliers at once

### Utility Functions:
- `quick_extract()` - Fast extraction without saving
- `extract_and_save()` - Extract and save files
- `validate_supplier_data()` - Data quality validation

---

## 🚀 Basic Usage

### Example 1: Simple Extraction

```python
from supplier_onboarding_service import SupplierOnboardingService

# Create service
service = SupplierOnboardingService(output_dir="output")

# Process supplier (folder, file, or list of files)
result = service.process_supplier("/path/to/supplier/folder")

if result['success']:
    print(f"✅ Success!")
    print(f"   Name: {result['contractor_name']}")
    print(f"   ID: {result['supplier_id']}")
    print(f"   Confidence: {result['confidence']:.0%}")
    print(f"   JSON: {result['json_file']}")
    print(f"   SQL: {result['sql_file']}")
else:
    print(f"❌ Failed: {result['errors']}")
```

---

### Example 2: With Validation

```python
from supplier_onboarding_service import SupplierOnboardingService

service = SupplierOnboardingService()

# Step 1: Extract data
extraction = service.extract_supplier_data("/path/to/supplier")

if extraction['success']:
    # Step 2: Validate
    is_valid, warnings = service.validate_extraction()
    
    if warnings:
        print(f"⚠️  Warnings:")
        for warning in warnings:
            print(f"   - {warning}")
    
    # Step 3: Generate SQL if acceptable
    if is_valid:
        sql_result = service.generate_sql()
        
        if sql_result['success']:
            # Step 4: Save files
            save_result = service.save_files()
            print(f"✅ Saved to: {save_result['sql_file']}")
```

---

### Example 3: Quick Extract (No Files)

```python
from supplier_onboarding_service import quick_extract

# Just get the data - don't save anything
data = quick_extract("/path/to/supplier.xlsx")

print(f"Name: {data.get('contractor_name')}")
print(f"Email: {data.get('email')}")
print(f"Services: {data.get('services_provided')}")
```

---

### Example 4: Batch Processing

```python
from supplier_onboarding_service import SupplierBatchService

batch = SupplierBatchService(output_dir="output")

# Process all suppliers in a parent folder
# Parent folder contains: Supplier1/, Supplier2/, Supplier3/, etc.
result = batch.process_folder_of_suppliers("/path/to/suppliers")

print(f"Total: {result['total']}")
print(f"Successful: {result['successful']}")
print(f"Failed: {result['failed']}")

# Print detailed summary
print(batch.get_batch_summary())
```

---

## 📚 API Reference

### SupplierOnboardingService

#### `__init__(output_dir="output")`
Initialize service

**Args:**
- `output_dir` (str): Directory for output files

---

#### `process_supplier(path, name_hint=None) -> Dict`
Complete onboarding process

**Args:**
- `path` (str|Path|List[Path]): Folder, file, or list of files
- `name_hint` (str, optional): Suggested name for output files

**Returns:**
```python
{
    'success': True,
    'extracted_data': {...},
    'supplier_id': 'uuid-here',
    'json_file': '/path/to/output.json',
    'sql_file': '/path/to/output.sql',
    'confidence': 0.85,
    'contractor_name': 'Company Name',
    'errors': []
}
```

---

#### `extract_supplier_data(path) -> Dict`
Extract data from documents

**Args:**
- `path` (str|Path|List[Path]): Input path(s)

**Returns:**
```python
{
    'success': True,
    'data': {
        'contractor_name': '...',
        'email': '...',
        # ... all extracted fields
    },
    'errors': []
}
```

---

#### `generate_sql(name_hint=None) -> Dict`
Generate SQL INSERT statements

**Returns:**
```python
{
    'success': True,
    'supplier_id': 'uuid-here',
    'sql_content': 'INSERT INTO suppliers ...',
    'errors': []
}
```

---

#### `save_files(name_hint=None) -> Dict`
Save JSON and SQL files

**Returns:**
```python
{
    'success': True,
    'json_file': '/path/to/file.json',
    'sql_file': '/path/to/file.sql',
    'errors': []
}
```

---

#### `get_extraction_summary() -> Dict`
Get summary of extracted data

**Returns:**
```python
{
    'contractor_name': '...',
    'email': '...',
    'telephone': '...',
    'services_provided': [...],
    'extraction_confidence': 0.85,
    'documents_count': 3
}
```

---

#### `validate_extraction() -> Tuple[bool, List[str]]`
Validate data quality

**Returns:**
- `is_valid` (bool): Whether data is acceptable
- `warnings` (List[str]): List of issues found

---

#### `apply_to_database(apply_script) -> Dict`
Apply SQL to database

**Args:**
- `apply_script` (str): Path to database application script

**Returns:**
```python
{
    'success': True,
    'output': 'SQL execution output...',
    'supplier_id': 'uuid-here',
    'errors': []
}
```

---

### SupplierBatchService

#### `__init__(output_dir="output")`
Initialize batch service

---

#### `process_folder_of_suppliers(parent_folder) -> Dict`
Process multiple supplier folders

**Args:**
- `parent_folder` (str|Path): Folder containing supplier subfolders

**Returns:**
```python
{
    'success': True,
    'total': 10,
    'successful': 8,
    'failed': 2,
    'results': [...],
    'errors': [...]
}
```

---

#### `get_batch_summary() -> str`
Get formatted summary report

**Returns:** String with statistics and details

---

## 🔗 Integration Examples

### Integration 1: In Your API

```python
from fastapi import FastAPI, UploadFile, HTTPException
from supplier_onboarding_service import SupplierOnboardingService
import shutil
from pathlib import Path

app = FastAPI()

@app.post("/api/suppliers/onboard")
async def onboard_supplier(files: List[UploadFile]):
    """API endpoint for supplier onboarding"""
    
    # Save uploaded files
    temp_dir = Path(f"temp/supplier_{datetime.now().timestamp()}")
    temp_dir.mkdir(parents=True, exist_ok=True)
    
    try:
        file_paths = []
        for file in files:
            file_path = temp_dir / file.filename
            with open(file_path, "wb") as f:
                shutil.copyfileobj(file.file, f)
            file_paths.append(file_path)
        
        # Process with service
        service = SupplierOnboardingService()
        result = service.process_supplier(file_paths)
        
        if result['success']:
            # Optionally apply to database
            db_result = service.apply_to_database()
            
            return {
                'status': 'success',
                'supplier_id': result['supplier_id'],
                'contractor_name': result['contractor_name'],
                'confidence': result['confidence']
            }
        else:
            raise HTTPException(
                status_code=400,
                detail={'errors': result['errors']}
            )
    
    finally:
        # Cleanup temp files
        shutil.rmtree(temp_dir, ignore_errors=True)
```

---

### Integration 2: In Your Background Job

```python
from supplier_onboarding_service import SupplierOnboardingService
from celery import Celery

app = Celery('tasks')

@app.task
def process_supplier_async(supplier_folder_path: str):
    """Background task for supplier onboarding"""
    
    service = SupplierOnboardingService()
    result = service.process_supplier(supplier_folder_path)
    
    if result['success']:
        # Apply to database
        db_result = service.apply_to_database()
        
        if db_result['success']:
            # Send notification
            send_email_notification(
                subject=f"Supplier {result['contractor_name']} onboarded",
                supplier_id=result['supplier_id']
            )
        
        return {
            'status': 'completed',
            'supplier_id': result['supplier_id']
        }
    else:
        return {
            'status': 'failed',
            'errors': result['errors']
        }
```

---

### Integration 3: In Your Django View

```python
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from supplier_onboarding_service import SupplierOnboardingService

@require_POST
def onboard_supplier_view(request):
    """Django view for supplier onboarding"""
    
    folder_path = request.POST.get('folder_path')
    
    if not folder_path:
        return JsonResponse({'error': 'Missing folder_path'}, status=400)
    
    # Process with service
    service = SupplierOnboardingService()
    result = service.process_supplier(folder_path)
    
    if result['success']:
        # Create database record (Django ORM)
        supplier = Supplier.objects.create(
            supplier_id=result['supplier_id'],
            name=result['contractor_name'],
            json_file=result['json_file'],
            sql_file=result['sql_file'],
            confidence=result['confidence']
        )
        
        return JsonResponse({
            'status': 'success',
            'supplier_id': str(supplier.id),
            'name': supplier.name
        })
    else:
        return JsonResponse({
            'status': 'error',
            'errors': result['errors']
        }, status=400)
```

---

### Integration 4: In Your ETL Pipeline

```python
from supplier_onboarding_service import SupplierBatchService
import pandas as pd

def etl_supplier_pipeline():
    """ETL pipeline for supplier data"""
    
    # Step 1: Extract from all supplier folders
    batch = SupplierBatchService(output_dir="etl_output")
    result = batch.process_folder_of_suppliers("/data/suppliers")
    
    # Step 2: Transform - create DataFrame
    data = []
    for item in result['results']:
        if item['result']['success']:
            r = item['result']
            data.append({
                'supplier_id': r['supplier_id'],
                'name': r['contractor_name'],
                'confidence': r['confidence'],
                'folder': item['folder']
            })
    
    df = pd.DataFrame(data)
    
    # Step 3: Load to database or data warehouse
    df.to_sql('suppliers_staging', con=engine, if_exists='append')
    
    print(batch.get_batch_summary())
```

---

## 🎯 Use Cases

### Use Case 1: Admin Portal
User uploads supplier documents → Service extracts → Admin reviews → Apply to DB

### Use Case 2: Automated Processing
Dropbox/S3 folder → Webhook triggers → Service processes → Auto-insert to DB

### Use Case 3: Bulk Migration
CSV with supplier folder paths → Batch service → Generate all SQL → Review → Bulk apply

### Use Case 4: API Integration
External system POSTs files → API extracts → Returns supplier_id → External system stores

---

## 🔍 Error Handling

### All methods return standard result format:

```python
{
    'success': bool,       # True if operation succeeded
    'errors': List[str],   # Empty list if no errors
    # ... operation-specific fields
}
```

### Always check `success` before using results:

```python
result = service.process_supplier(path)

if result['success']:
    # Use result data
    supplier_id = result['supplier_id']
else:
    # Handle errors
    for error in result['errors']:
        log_error(error)
```

---

## 💡 Best Practices

### 1. Always Validate

```python
service = SupplierOnboardingService()
service.extract_supplier_data(path)

is_valid, warnings = service.validate_extraction()

if not is_valid:
    # Don't proceed - data quality too low
    notify_admin(warnings)
else:
    # Continue with SQL generation
    service.generate_sql()
```

---

### 2. Handle Low Confidence

```python
result = service.process_supplier(path)

if result['confidence'] < 0.7:
    # Flag for manual review
    mark_for_review(result['supplier_id'])
else:
    # Auto-approve
    auto_approve(result['supplier_id'])
```

---

### 3. Cleanup Temp Files

```python
try:
    result = service.process_supplier(temp_folder)
    # Process result
finally:
    # Always cleanup
    shutil.rmtree(temp_folder, ignore_errors=True)
```

---

### 4. Log Everything

```python
import logging

logger = logging.getLogger(__name__)

result = service.process_supplier(path)

if result['success']:
    logger.info(f"Onboarded supplier: {result['contractor_name']}")
else:
    logger.error(f"Failed to onboard: {result['errors']}")
```

---

## 🚀 Quick Start

### 1. Import the Service

```python
from supplier_onboarding_service import SupplierOnboardingService
```

### 2. Create Instance

```python
service = SupplierOnboardingService(output_dir="output")
```

### 3. Process Supplier

```python
result = service.process_supplier("/path/to/supplier")
```

### 4. Check Result

```python
if result['success']:
    print(f"✅ {result['contractor_name']}")
else:
    print(f"❌ {result['errors']}")
```

**That's it!** 🎉

---

## 📁 File Location

```
CONTRACTOR_MIGRATION_PACKAGE/
└── supplier_onboarding_service.py  ← THIS FILE
```

---

## 🔗 Dependencies

Uses the same extractors/generators as the main system:
- `extractors/contractor_extractor.py`
- `generators/supplier_sql_generator.py`

---

## ✅ What This Gives You

✅ **Pure logic** - No GUI/CLI dependencies  
✅ **Reusable** - Use in API, web app, ETL, scripts  
✅ **Testable** - Easy to unit test  
✅ **Flexible** - Supports files, folders, lists  
✅ **Validated** - Built-in data quality checks  
✅ **Batch-ready** - Process multiple suppliers  
✅ **Production-ready** - Proper error handling  

---

**Use this service layer in your live project for clean, maintainable code!**


