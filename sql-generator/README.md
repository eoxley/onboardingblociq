# SQL Generator - Building Document Metadata Processor

A modular Python application that processes building handover folders and generates intelligent metadata reports.

## 🎯 Features

- **Universal File Reading**: Supports PDF, Word, Excel, CSV, TXT, RTF, images (OCR), and emails
- **Intelligent Classification**: Automatically categorizes documents (FRA, EICR, Insurance, etc.)
- **Metadata Extraction**: Extracts dates, contractors, risk levels, costs, and reference numbers
- **Renewal Logic**: Calculates next due dates based on document type and inspection dates
- **Status Tracking**: Determines if documents are current, expired, or missing
- **Multiple Outputs**: Generates JSON metadata, SQL scripts, CSV summaries, and HTML reports

## 📁 Architecture

```
sql-generator/
├── main.py              # Main orchestrator
├── reader.py            # Universal file reader (PDF, Word, Excel, etc.)
├── classifier.py        # Document classification logic
├── extractor.py         # Metadata extraction (dates, contractors, etc.)
├── time_utils.py        # Renewal calculations and status determination
├── reporter.py          # Output generation (JSON, SQL, CSV, HTML)
├── config/
│   ├── renewal_rules.json      # Renewal periods by document type
│   └── expected_docs.json      # Required documents by building type
├── logs/                # Execution logs
└── outputs/             # Generated reports
```

## 🚀 Usage

### Basic Usage

```bash
python main.py /path/to/building/folder
```

### With Building Configuration

```bash
python main.py /path/to/building/folder \
    --building-name "Connaught Square" \
    --has-lifts \
    --over-11m \
    --has-gas
```

### Command Line Options

- `folder` - Path to folder containing building documents (required)
- `--building-name` - Name of the building (default: folder name)
- `--output-dir` - Output directory (default: ./outputs)
- `--has-lifts` - Building has lifts (requires LOLER inspection)
- `--over-11m` - Building is over 11m tall (requires Safety Case)
- `--has-gas` - Building has gas supply (requires Gas Safety cert)

## 📊 Output Files

For each building, the generator creates:

1. **`{building}_metadata.json`** - Complete metadata with all extracted information
2. **`{building}_generated.sql`** - SQL INSERT statements for database import
3. **`{building}_summary.csv`** - CSV summary for spreadsheet analysis
4. **`{building}_report.html`** - Human-readable HTML report
5. **`{building}_{timestamp}.log`** - Execution log with detailed processing info

## 🧠 How It Works

### 1. Folder Intake
- Recursively scans folder for all supported file types
- Detects MIME types to confirm file formats
- Builds comprehensive file inventory

### 2. File Reading
- Dispatches to appropriate reader based on file type
- Extracts text from PDFs, Word docs, Excel files, etc.
- Handles OCR for image files (requires integration)
- Processes email files (.msg, .eml)

### 3. Classification
- Uses filename patterns and content keywords
- Assigns document type (FRA, EICR, Insurance, etc.)
- Calculates confidence score for classification

### 4. Metadata Extraction
- Extracts inspection dates, issue dates, expiry dates
- Identifies contractors and assessors
- Captures risk levels, costs, and reference numbers
- Uses context-aware regex patterns

### 5. Renewal Logic
- Calculates next due dates based on document type
- Applies renewal rules (FRA=12mo, EICR=60mo, etc.)
- Determines status (current, due soon, expired)
- Computes urgency scores

### 6. Missing Document Detection
- Compares found documents against expected list
- Accounts for building-specific requirements
- Flags missing required documents

### 7. Output Generation
- Creates structured JSON metadata
- Generates SQL INSERT statements
- Produces CSV and HTML reports
- Logs entire process for traceability

## ⚙️ Configuration

### Renewal Rules (`config/renewal_rules.json`)

Defines renewal periods in months for each document type:

```json
{
  "FRA": 12,
  "EICR": 60,
  "Asbestos": 12,
  "Legionella": 24,
  "Lift_LOLER": 6,
  "Insurance": 12
}
```

### Expected Documents (`config/expected_docs.json`)

Defines required documents by building characteristics:

```json
{
  "default": ["FRA", "EICR", "Asbestos", "Legionella", "Insurance"],
  "has_lifts": ["Lift_LOLER"],
  "over_11m": ["Safety_Case"]
}
```

## 📋 Supported Document Types

- **FRA** - Fire Risk Assessment
- **EICR** - Electrical Installation Condition Report
- **Asbestos** - Asbestos Survey
- **Legionella** - Water Hygiene/Legionella Risk Assessment
- **Lift_LOLER** - Lift Inspection (LOLER)
- **Insurance** - Buildings Insurance Policy
- **Gas_Safety** - Gas Safety Certificate
- **Emergency_Lighting** - Emergency Lighting Test
- **Fire_Alarm** - Fire Alarm Inspection
- **Safety_Case** - Building Safety Case
- **PAT_Testing** - Portable Appliance Testing
- **Lease** - Lease Documents
- **Budget** - Service Charge Budgets
- **Major_Works** - Major Works Projects
- **Minutes** - Meeting Minutes (AGM/EGM)

## 🔧 Installation

```bash
cd sql-generator
pip install -r requirements.txt
```

## 🧪 Testing Individual Modules

Each module can be tested independently:

```bash
# Test file reader
python reader.py /path/to/file.pdf

# Test classifier
python classifier.py

# Test extractor
python extractor.py

# Test time utilities
python time_utils.py

# Test reporter
python reporter.py
```

## 📝 Example Output

### JSON Metadata
```json
{
  "building": "Connaught Square",
  "generated_at": "2025-10-14T18:45:00Z",
  "total_documents": 15,
  "documents": [
    {
      "file_name": "FRA_2025.pdf",
      "document_type": "FRA",
      "inspection_date": "2025-03-04",
      "next_due_date": "2026-03-04",
      "status": "current",
      "is_current": true,
      "contractor": "TriFire Safety Ltd",
      "risk_rating": "Low"
    }
  ]
}
```

### SQL Output
```sql
INSERT INTO building_documents (
    building_name, file_name, document_type,
    inspection_date, next_due_date, status,
    contractor, is_current
) VALUES (
    'Connaught Square', 'FRA_2025.pdf', 'FRA',
    '2025-03-04', '2026-03-04', 'current',
    'TriFire Safety Ltd', TRUE
);
```

## 🚨 Status Determination

- **current** - Document is valid and not due soon
- **due_soon** - Document due within 30 days
- **expired** - Document is past due date
- **missing** - Required document not found

## 📊 Logging

All processing steps are logged with timestamps:

```
[18:44:01] Starting SQL Generator for: Connaught Square
[18:44:01] Found 136 files
[18:44:07] [1/136] Budget_2025.xlsx → Budget (0.95)
[18:44:10] [2/136] FRA_2025.pdf → FRA (0.98)
[18:44:12] Missing: Legionella report
[18:44:15] ✅ Complete!
```

## 🎯 Design Principles

1. **Modular** - Each component is independent and testable
2. **Self-contained** - No database dependencies, runs locally
3. **Extensible** - Easy to add new document types or file formats
4. **Traceable** - Comprehensive logging for debugging
5. **Accurate** - Time-aware with proper renewal logic
6. **Complete** - Handles all common building document formats

## 🔄 Integration with Supabase

While this version generates standalone outputs, the generated SQL can be adapted for Supabase upload:

1. Review `{building}_metadata.json` for data quality
2. Adapt `{building}_generated.sql` to match your schema
3. Use the metadata to populate Supabase storage with document references
4. Track renewal dates and compliance status

## 📄 License

Internal BlocIQ tool - Not for distribution
