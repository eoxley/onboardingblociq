# 🔧 Contractor Onboarding - Integration Guide

Step-by-step guide to integrate the contractor onboarding system into your live project.

---

## 📋 TABLE OF CONTENTS

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Database Setup](#database-setup)
4. [Component Overview](#component-overview)
5. [Integration Patterns](#integration-patterns)
6. [API Reference](#api-reference)
7. [Configuration](#configuration)
8. [Testing](#testing)
9. [Deployment](#deployment)
10. [Troubleshooting](#troubleshooting)

---

## 🎯 PREREQUISITES

### System Requirements:
- Python 3.8+
- PostgreSQL 12+ (or Supabase)
- 100MB disk space

### Python Packages:
```bash
pip install PyPDF2>=3.0.0
pip install openpyxl>=3.0.0
pip install python-docx>=0.8.0
pip install rapidfuzz>=2.0.0  # Optional, for fuzzy matching
```

### Database Access:
- Supabase project URL
- Service role key (for SQL execution)
- Storage bucket access

---

## 📦 INSTALLATION

### Step 1: Copy Files to Your Project

```bash
# Navigate to your live project
cd /path/to/your/live/project

# Copy the entire package
cp -r /path/to/CONTRACTOR_MIGRATION_PACKAGE/ ./contractor_onboarding/

# Verify structure
ls contractor_onboarding/
# Should see: extractors/ consolidators/ validators/ generators/ schema/ examples/ onboard_contractor.py
```

### Step 2: Verify Python Environment

```bash
cd contractor_onboarding
python3 --version  # Should be 3.8+

# Test imports
python3 -c "import PyPDF2; import openpyxl; import docx; print('✅ All imports successful')"
```

### Step 3: Update Import Paths (if needed)

If your project has a different structure, update imports in each file:

**Example: `consolidators/contractor_consolidator.py`**
```python
# If files are in same directory:
from budget_contractor_extractor import BudgetContractorExtractor

# If using package structure:
from contractor_onboarding.extractors.budget_contractor_extractor import BudgetContractorExtractor

# If using relative imports:
from ..extractors.budget_contractor_extractor import BudgetContractorExtractor
```

---

## 💾 DATABASE SETUP

### Step 1: Apply Schema to Supabase

1. Open Supabase Dashboard
2. Go to SQL Editor
3. Copy contents of `schema/supplier_onboarding_schema.sql`
4. Paste and run

**This creates:**
- `suppliers` table (60+ fields)
- `supplier_documents` table
- Views: `vw_suppliers_documents_expiring`, `vw_approved_suppliers`
- Triggers for auto-calculations
- Indexes for performance
- RLS policies

### Step 2: Create Storage Bucket

1. In Supabase Dashboard, go to Storage
2. Create new bucket: `supplier_documents`
3. Settings:
   - **Public bucket:** No (keep private)
   - **File size limit:** 50MB
   - **Allowed MIME types:** PDF, Excel, Word, images

4. Add RLS policy (optional):
```sql
CREATE POLICY "Authenticated users can view supplier documents"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'supplier_documents');

CREATE POLICY "Admins can upload supplier documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'supplier_documents' AND
    EXISTS (
        SELECT 1 FROM users
        WHERE auth_user_id = auth.uid()
        AND role IN ('admin', 'manager')
    )
);
```

### Step 3: Verify Setup

Run verification query:
```sql
-- Check tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('suppliers', 'supplier_documents');

-- Check bucket exists
SELECT * FROM storage.buckets WHERE name = 'supplier_documents';
```

---

## 🧩 COMPONENT OVERVIEW

### 1. Contractor Extractor
**File:** `extractors/contractor_extractor.py`

**Purpose:** Extract data from documents

**Methods:**
- `extract_from_folder(folder_path)` - Process entire folder
- `extract_from_files(files)` - Process specific files
- `_extract_from_excel(file)` - Extract from Excel
- `_extract_from_pdf(file)` - Extract from PDF
- `_extract_from_word(file)` - Extract from Word

**Returns:**
```python
{
    'contractor_name': str,
    'email': str,
    'telephone': str,
    'postcode': str,
    'address': str,
    'services_provided': List[str],
    'bank_account_name': str,
    'bank_sort_code': str,
    'pli_expiry_date': str,
    'has_audited_accounts': bool,
    'has_certificate_of_incorporation': bool,
    'extraction_confidence': float,  # 0.0 to 1.0
    'documents_found': List[Dict]
}
```

---

### 2. Budget Contractor Extractor
**File:** `extractors/budget_contractor_extractor.py`

**Purpose:** Extract contractor names from budget notes/comments

**Methods:**
- `extract_contractor_from_notes(notes: str) -> Optional[str]`

**Example:**
```python
notes = "This contract is with New Step Cleaning Ltd"
name = extractor.extract_contractor_from_notes(notes)
# Returns: "New Step Cleaning Ltd"
```

**Patterns matched:**
- "contract with ABC Ltd"
- "currently with XYZ Services"
- "provided by ABC Maintenance"
- "by XYZ Ltd which..."

---

### 3. Contractor Consolidator
**File:** `consolidators/contractor_consolidator.py`

**Purpose:** Deduplicate and aggregate contractor data

**Methods:**
- `add_from_budget(budget_line_items)` - Extract from budget
- `add_from_contracts(contracts)` - Extract from contracts
- `add_from_property_bible(contractors)` - Add from property bible
- `get_consolidated_contractors()` - Get final deduplicated list
- `print_summary()` - Print consolidation summary

**Fuzzy Matching:**
- "New Step" matches "New Step Ltd" (85%+ similarity)
- Tracks aliases automatically
- Aggregates services and values

**Example:**
```python
consolidator = ContractorConsolidator()

# Add from multiple sources
consolidator.add_from_budget(budget_items)
consolidator.add_from_contracts(contracts)

# Get consolidated list (no duplicates)
contractors = consolidator.get_consolidated_contractors()

# Print summary
consolidator.print_summary()
```

---

### 4. Contractor Name Validator
**File:** `validators/contractor_name_validator.py`

**Purpose:** Filter out invalid/garbage contractor names

**Methods:**
- `is_valid_contractor(name: str) -> bool` - Check if valid
- `filter_contractors(contractors: List[Dict]) -> List[Dict]` - Filter list

**Rejects:**
- Generic words ("Gas", "Cleaning")
- Legal clause text ("s and each contractor engaged...")
- Text without proper capitalization
- Very short/long names

**Example:**
```python
validator = ContractorNameValidator()

# Check individual name
if validator.is_valid_contractor("New Step Ltd"):
    print("Valid contractor name")

# Filter list
valid_only = validator.filter_contractors(all_contractors)
```

---

### 5. SQL Generator
**File:** `generators/supplier_sql_generator.py`

**Purpose:** Generate SQL INSERT statements for Supabase

**Methods:**
- `generate_sql(contractor_data: Dict, output_file: str = None) -> str`

**Features:**
- UUID generation
- Array formatting (`TEXT[]`)
- Date parsing and normalization
- SQL escaping
- Transaction wrapping (BEGIN/COMMIT)
- Verification query included

**Example:**
```python
generator = SupplierSQLGenerator()
sql = generator.generate_sql(contractor_data, "output/contractor.sql")

print(f"Supplier ID: {generator.supplier_id}")
print(f"Storage path: {generator.storage_bucket}/{generator.supplier_id}/")
```

---

### 6. Main Onboarding Tool
**File:** `onboard_contractor.py`

**Purpose:** Complete CLI workflow

**Usage:**
```bash
python3 onboard_contractor.py "/path/to/contractor/folder"
```

**Workflow:**
1. Extract data from all documents in folder
2. Calculate confidence score
3. Generate JSON data file
4. Generate SQL file
5. Print summary report
6. Show next steps

---

## 🔗 INTEGRATION PATTERNS

### Pattern 1: Standalone CLI Tool

Use as a separate tool for onboarding contractors:

```bash
# User runs from command line
python3 contractor_onboarding/onboard_contractor.py "/path/to/contractor/folder"

# Output files created in output/
# Apply SQL manually to database
```

**Use when:**
- Onboarding suppliers separately from buildings
- One-off contractor additions
- Manual review workflow

---

### Pattern 2: Integrated with Building Onboarding

Automatically extract contractors during building onboarding:

```python
from contractor_onboarding.consolidators.contractor_consolidator import ContractorConsolidator

class BuildingOnboarder:
    def __init__(self):
        self.contractor_consolidator = ContractorConsolidator()
    
    def onboard_building(self, building_data):
        # Your existing building processing
        building_id = self.process_building(building_data)
        
        # Extract contractors from budget
        if building_data.get('budget_line_items'):
            self.contractor_consolidator.add_from_budget(
                building_data['budget_line_items']
            )
        
        # Get contractors
        contractors = self.contractor_consolidator.get_consolidated_contractors()
        
        # Store in database
        for contractor in contractors:
            self.store_contractor(contractor, building_id)
        
        return building_id
```

**Use when:**
- Onboarding buildings and want to capture contractors automatically
- Want to link contractors to buildings
- Processing many buildings in batch

---

### Pattern 3: API Integration

Expose contractor onboarding via API:

```python
from fastapi import FastAPI, UploadFile
from contractor_onboarding.extractors.contractor_extractor import ContractorExtractor
from contractor_onboarding.generators.supplier_sql_generator import SupplierSQLGenerator

app = FastAPI()

@app.post("/api/contractors/onboard")
async def onboard_contractor(files: List[UploadFile]):
    # Save uploaded files
    temp_folder = save_uploaded_files(files)
    
    # Extract data
    extractor = ContractorExtractor()
    data = extractor.extract_from_folder(temp_folder)
    
    # Generate SQL
    generator = SupplierSQLGenerator()
    sql = generator.generate_sql(data)
    
    # Execute SQL
    execute_sql(sql)
    
    return {
        'supplier_id': generator.supplier_id,
        'contractor_name': data.get('contractor_name'),
        'confidence': data.get('extraction_confidence')
    }
```

**Use when:**
- Building web application
- Need REST API for contractor onboarding
- Want to integrate with frontend

---

### Pattern 4: Batch Processing

Process multiple contractors at once:

```python
from pathlib import Path
from contractor_onboarding import onboard_contractor

# Get all contractor folders
contractor_folders = Path("/data/contractors").iterdir()

results = []
for folder in contractor_folders:
    if folder.is_dir():
        try:
            result = onboard_contractor(str(folder))
            results.append(result)
        except Exception as e:
            print(f"Failed to onboard {folder.name}: {e}")

# Summary
print(f"Successfully onboarded {len(results)} contractors")
```

---

## 📖 API REFERENCE

### ContractorExtractor

```python
class ContractorExtractor:
    def __init__(self):
        """Initialize extractor with default settings"""
    
    def extract_from_folder(self, folder_path: str) -> Dict:
        """
        Extract contractor data from all documents in folder
        
        Args:
            folder_path: Path to folder containing contractor documents
        
        Returns:
            Dictionary with extracted contractor data
        
        Raises:
            FileNotFoundError: If folder doesn't exist
        """
    
    def extract_from_files(self, files: List[Path]) -> Dict:
        """
        Extract from specific files
        
        Args:
            files: List of Path objects
        
        Returns:
            Dictionary with extracted data
        """
```

---

### BudgetContractorExtractor

```python
class BudgetContractorExtractor:
    def extract_contractor_from_notes(self, notes: str) -> Optional[str]:
        """
        Extract contractor name from PM comments/notes
        
        Args:
            notes: Budget line item notes/comments
        
        Returns:
            Contractor name if found, None otherwise
        
        Example:
            >>> extractor.extract_contractor_from_notes(
            ...     "Contract is with New Step Ltd"
            ... )
            'New Step Ltd'
        """
```

---

### ContractorConsolidator

```python
class ContractorConsolidator:
    def add_from_budget(self, budget_line_items: List[Dict]):
        """
        Extract contractors from budget line items
        
        Args:
            budget_line_items: List of dicts with keys:
                - description: str
                - category: str (optional)
                - annual_amount: float
                - notes: str (PM Comments - key source!)
        """
    
    def add_from_contracts(self, contracts: List[Dict]):
        """
        Add contractors from contract documents
        
        Args:
            contracts: List of dicts with keys:
                - contractor_name: str
                - service_type: str
                - start_date: str
                - end_date: str
                - annual_value: float
        """
    
    def get_consolidated_contractors(self) -> List[Dict]:
        """
        Get deduplicated contractor list
        
        Returns:
            List of contractor dicts with keys:
                - contractor_name: str
                - services_provided: List[str]
                - aliases: List[str]
                - sources: List[str]
                - annual_value: float
                - is_active: bool
        """
```

---

### SupplierSQLGenerator

```python
class SupplierSQLGenerator:
    def __init__(self):
        """Initialize generator with new UUID"""
        self.supplier_id: str  # Generated UUID
        self.storage_bucket: str = "supplier_documents"
    
    def generate_sql(
        self,
        contractor_data: Dict,
        output_file: str = None
    ) -> str:
        """
        Generate SQL INSERT statement
        
        Args:
            contractor_data: Dictionary with contractor data
            output_file: Optional path to save SQL file
        
        Returns:
            SQL string
        
        Side Effects:
            - Sets self.supplier_id
            - Writes to output_file if provided
        """
```

---

## ⚙️ CONFIGURATION

### Customize Service Keywords

**File:** `extractors/contractor_extractor.py`

```python
# Add your industry-specific services
self.service_keywords = [
    'cleaning', 'lift maintenance', 'electrical',
    # Add more:
    'hvac', 'access control', 'landscaping',
    'window cleaning', 'waste management'
]
```

---

### Adjust Fuzzy Matching Threshold

**File:** `consolidators/contractor_consolidator.py`

```python
# Line ~211: Adjust similarity threshold
if similarity > 0.85:  # Change to 0.90 for stricter matching
    self.aliases[name] = canonical
    return canonical
```

**Lower threshold (0.80):** More aggressive deduplication  
**Higher threshold (0.90):** More conservative (may create duplicates)

---

### Customize Extraction Patterns

**File:** `extractors/contractor_extractor.py`

Add your own regex patterns:

```python
# Example: Add pattern for Australian phone numbers
phone_patterns = [
    r'\b0\d{10}\b',  # UK
    r'\+61\s?\d{1}\s?\d{4}\s?\d{4}\b',  # Australia
]
```

---

## 🧪 TESTING

### Unit Tests

Create `tests/test_contractor_extractor.py`:

```python
import unittest
from contractor_onboarding.extractors.contractor_extractor import ContractorExtractor

class TestContractorExtractor(unittest.TestCase):
    def setUp(self):
        self.extractor = ContractorExtractor()
    
    def test_extract_email(self):
        text = "Contact us at info@example.com"
        self.extractor._extract_fields_from_text(text, 'test')
        self.assertEqual(self.extractor.data['email'], 'info@example.com')
    
    def test_extract_phone(self):
        text = "Call us on 020 1234 5678"
        self.extractor._extract_fields_from_text(text, 'test')
        self.assertEqual(self.extractor.data['telephone'], '020 1234 5678')

if __name__ == '__main__':
    unittest.main()
```

Run tests:
```bash
python3 -m unittest discover tests/
```

---

### Integration Tests

Test with sample contractor folder:

```bash
# Create test folder
mkdir -p test_data/test_contractor
cp sample_documents/* test_data/test_contractor/

# Run onboarding
python3 onboard_contractor.py test_data/test_contractor

# Verify output
ls output/
# Should see JSON and SQL files
```

---

### Validation Tests

Test name validation:

```python
from contractor_onboarding.validators.contractor_name_validator import ContractorNameValidator

validator = ContractorNameValidator()

# Test cases
test_cases = [
    ("New Step Ltd", True),
    ("Gas", False),
    ("s and each contractor", False),
]

for name, expected in test_cases:
    result = validator.is_valid_contractor(name)
    assert result == expected, f"Failed for {name}"
```

---

## 🚀 DEPLOYMENT

### Production Checklist

- [ ] Database schema applied
- [ ] Storage bucket created
- [ ] RLS policies configured
- [ ] Python dependencies installed
- [ ] File permissions set correctly
- [ ] Error logging configured
- [ ] Backup strategy in place
- [ ] Monitoring set up
- [ ] Documentation updated
- [ ] Team trained on usage

---

### Environment Variables

Create `.env` file:

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
STORAGE_BUCKET=supplier_documents
OUTPUT_DIRECTORY=/path/to/output
```

Load in your code:

```python
import os
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')
```

---

### Logging Configuration

Add logging:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('contractor_onboarding.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)
logger.info("Starting contractor onboarding...")
```

---

## 🐛 TROUBLESHOOTING

### Issue: "No text extracted from PDF"

**Causes:**
- Scanned PDF (image-based)
- Encrypted PDF
- Corrupted file

**Solutions:**
1. Use OCR (install `pytesseract` and `pdf2image`)
2. Request text-based PDF
3. Manual data entry

---

### Issue: "Contractor name not found"

**Debug:**
```python
# Add debug output
print(f"First 500 chars: {text[:500]}")
print(f"Looking for company pattern...")

# Try different patterns
patterns = [
    r'([A-Z][A-Za-z\s&]+(?:Ltd|Limited))',
    r'([A-Z][A-Za-z\s]+)',  # Any capitalized words
]
```

---

### Issue: "Duplicates still created"

**Solutions:**
1. Lower fuzzy matching threshold
2. Add manual alias:
   ```python
   consolidator.aliases['New Step'] = 'New Step Ltd'
   ```
3. Use exact matching for specific contractors

---

### Issue: "PLI date incorrect"

**Debug:**
```python
# Check date format
print(f"Raw date string: {date_str}")

# Try different formats
formats = ['%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%d/%m/%y']
for fmt in formats:
    try:
        dt = datetime.strptime(date_str, fmt)
        print(f"Matched format: {fmt}")
    except:
        pass
```

---

## 📞 SUPPORT

### Common Questions

**Q: Can I use this with MySQL instead of PostgreSQL?**  
A: Yes, but you'll need to adapt the SQL schema (array types, triggers, etc.)

**Q: How do I handle scanned PDFs?**  
A: Install OCR: `pip install pytesseract pdf2image` and update extractor

**Q: Can I extract from emails?**  
A: Yes, add email parsing to `contractor_extractor.py`

**Q: How do I handle multiple contacts?**  
A: Store as JSON array in database or create separate contacts table

---

### Performance Tips

1. **Batch processing:** Process multiple contractors at once
2. **Caching:** Cache database queries for existing contractors
3. **Parallel processing:** Use multiprocessing for large batches
4. **Optimize regex:** Compile patterns once at initialization

---

### Best Practices

1. **Validation:** Always validate extracted data before storage
2. **Backups:** Keep JSON backup of extracted data
3. **Audit trail:** Log all changes to contractor records
4. **Reviews:** Manual review for low confidence extractions
5. **Updates:** Regularly update contractor data (quarterly)

---

**END OF INTEGRATION GUIDE**

For more examples, see `examples/` folder.


