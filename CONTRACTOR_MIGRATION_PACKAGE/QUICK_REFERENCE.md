# 🚀 Quick Reference - Contractor Onboarding

One-page reference for the most common operations.

---

## 📥 BASIC USAGE

### Onboard a Contractor (CLI)
```bash
python3 onboard_contractor.py "/path/to/contractor/folder"
```

**Output:**
- `output/<ContractorName>_contractor_data.json`
- `output/<ContractorName>_supplier.sql`

---

## 💻 CODE EXAMPLES

### Extract from Folder
```python
from extractors.contractor_extractor import ContractorExtractor

extractor = ContractorExtractor()
data = extractor.extract_from_folder("/path/to/folder")

print(f"Name: {data['contractor_name']}")
print(f"Email: {data['email']}")
print(f"Confidence: {data['extraction_confidence']:.0%}")
```

---

### Extract from Budget Notes
```python
from extractors.budget_contractor_extractor import BudgetContractorExtractor

extractor = BudgetContractorExtractor()
name = extractor.extract_contractor_from_notes(
    "This contract is with New Step Ltd"
)
# Returns: "New Step Ltd"
```

---

### Consolidate Contractors (Deduplicate)
```python
from consolidators.contractor_consolidator import ContractorConsolidator

consolidator = ContractorConsolidator()

# Add from budget
consolidator.add_from_budget(budget_line_items)

# Add from contracts
consolidator.add_from_contracts(contracts)

# Get unique contractors
contractors = consolidator.get_consolidated_contractors()
```

---

### Validate Contractor Names
```python
from validators.contractor_name_validator import ContractorNameValidator

validator = ContractorNameValidator()

if validator.is_valid_contractor("New Step Ltd"):
    print("✅ Valid")
else:
    print("❌ Invalid")

# Filter list
valid_contractors = validator.filter_contractors(all_contractors)
```

---

### Generate SQL
```python
from generators.supplier_sql_generator import SupplierSQLGenerator

generator = SupplierSQLGenerator()
sql = generator.generate_sql(
    contractor_data,
    output_file="output/contractor.sql"
)

print(f"Supplier ID: {generator.supplier_id}")
```

---

## 🗄️ DATABASE QUERIES

### Find Contractors by Service
```sql
SELECT contractor_name, email, telephone
FROM suppliers
WHERE 'Cleaning' = ANY(services_provided)
AND is_approved_contractor = true;
```

---

### Check Expiring Insurance
```sql
SELECT * FROM vw_suppliers_documents_expiring;
```

---

### Get Approved Suppliers
```sql
SELECT * FROM vw_approved_suppliers
ORDER BY rating DESC;
```

---

### Update Onboarding Status
```sql
UPDATE suppliers 
SET onboarding_status = 'approved',
    is_approved_contractor = true,
    approved_by = 'admin@example.com',
    approved_date = CURRENT_DATE
WHERE id = '<supplier_id>';
```

---

## 🔧 CUSTOMIZATION

### Add Service Keywords
**File:** `extractors/contractor_extractor.py`
```python
self.service_keywords = [
    'cleaning', 'lift maintenance',
    'your_custom_service',  # Add here
]
```

---

### Adjust Fuzzy Matching
**File:** `consolidators/contractor_consolidator.py`
```python
# Line ~211
if similarity > 0.85:  # Change threshold (0.80-0.95)
    # Match found
```

---

### Add Extraction Pattern
**File:** `extractors/contractor_extractor.py`
```python
# Add custom regex pattern
custom_pattern = r'your_regex_here'
match = re.search(custom_pattern, text)
```

---

## 📊 DATA STRUCTURE

### Contractor Data Dictionary
```python
{
    'contractor_name': 'New Step Ltd',
    'email': 'info@newstep.co.uk',
    'telephone': '020 1234 5678',
    'postcode': 'SW1A 1AA',
    'address': '123 Example St, London',
    'services_provided': ['Cleaning', 'FM'],
    'bank_account_name': 'New Step Ltd',
    'bank_sort_code': '12-34-56',
    'pli_expiry_date': '2025-03-31',
    'has_audited_accounts': True,
    'has_certificate_of_incorporation': True,
    'extraction_confidence': 0.9,
    'documents_found': [
        {
            'file_name': 'Profile.xlsx',
            'file_type': '.xlsx',
            'file_size': 52480
        }
    ]
}
```

---

### Consolidated Contractor Dictionary
```python
{
    'contractor_name': 'New Step Ltd',
    'services_provided': ['cleaning', 'facilities'],
    'aliases': ['New Step', 'New Step Cleaning'],
    'sources': ['budget', 'contract'],
    'annual_value': 15000.00,
    'is_active': True,
    'service_count': 2
}
```

---

## 🎯 INTEGRATION PATTERNS

### Pattern: Integrate with Building Onboarding
```python
from consolidators.contractor_consolidator import ContractorConsolidator

def onboard_building(building_data):
    # Your existing code
    building_id = process_building(building_data)
    
    # Add contractor extraction
    consolidator = ContractorConsolidator()
    consolidator.add_from_budget(building_data['budget_line_items'])
    contractors = consolidator.get_consolidated_contractors()
    
    # Store contractors
    for contractor in contractors:
        store_contractor(contractor, building_id)
    
    return building_id
```

---

### Pattern: Batch Process Multiple Contractors
```python
from pathlib import Path

contractor_folders = Path("/data/contractors").iterdir()

for folder in contractor_folders:
    if folder.is_dir():
        result = onboard_contractor(str(folder))
        print(f"✅ {folder.name}")
```

---

## 🐛 TROUBLESHOOTING

| Issue | Solution |
|-------|----------|
| No text extracted from PDF | PDF is scanned - use OCR or request text-based PDF |
| Contractor name not found | Check first few lines of document, adjust regex |
| PLI date incorrect | Verify date format (DD/MM/YYYY vs MM/DD/YYYY) |
| Duplicates created | Lower fuzzy matching threshold or add manual alias |
| Import error | Check Python path and package structure |

---

## ⚡ COMMON COMMANDS

```bash
# Install dependencies
pip install PyPDF2 openpyxl python-docx rapidfuzz

# Onboard contractor
python3 onboard_contractor.py "/path/to/folder"

# Run examples
python3 examples/example_usage.py

# Apply SQL to database
# Copy output/*.sql to Supabase SQL Editor and run

# Check output
ls output/
cat output/ContractorName_contractor_data.json
```

---

## 📁 FILE LOCATIONS

```
contractor_onboarding/
├── extractors/
│   ├── contractor_extractor.py          # Main extraction
│   └── budget_contractor_extractor.py   # Budget notes
├── consolidators/
│   └── contractor_consolidator.py       # Deduplication
├── validators/
│   └── contractor_name_validator.py     # Name filtering
├── generators/
│   └── supplier_sql_generator.py        # SQL generation
├── schema/
│   └── supplier_onboarding_schema.sql   # Database schema
├── onboard_contractor.py                # CLI tool
└── examples/
    ├── example_usage.py                 # Usage examples
    └── example_integration.py           # Integration examples
```

---

## 📞 SUPPORT RESOURCES

- **Full Documentation:** `INTEGRATION_GUIDE.md`
- **Migration Guide:** See main README
- **Examples:** `examples/` folder
- **Schema Details:** `schema/supplier_onboarding_schema.sql`

---

**Quick Start:**
1. Install dependencies
2. Apply database schema
3. Run `python3 onboard_contractor.py "/path/to/folder"`
4. Apply generated SQL to Supabase

---

*For detailed information, see INTEGRATION_GUIDE.md*


