# BlocIQ Onboarder Desktop App

A lightweight desktop application for processing client onboarding data into Supabase-ready SQL migrations.

## Features

- **Simple GUI**: Clean Tkinter interface for easy use
- **File Processing**: Parses Excel, PDF, Word, and CSV files
- **Smart Classification**: Automatically categorizes documents by type
- **SQL Generation**: Creates Supabase-compliant migration scripts
- **Audit Trail**: Comprehensive logging and backup of all processed files

## Installation

1. **Install Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Launch the Application**:
   ```bash
   python app.py
   ```

## Usage

1. **Enter Building Name**: Type the name of the building/property
2. **Select Client Folder**: Click "Select Folder" to choose the client's data folder
3. **Run Onboarder**: Click "Run Onboarder" to process the data
4. **Review Results**: Check the "Results" tab for generated files and SQL preview

## Generated Output

The app creates an `output/` directory with:

- **`migration.sql`** - SQL insert script for Supabase
- **`document_log.csv`** - File metadata for building_documents table
- **`audit_log.json`** - Processing logs and statistics
- **`summary.json`** - Summary of buildings, units, leaseholders
- **`client-backup/`** - Copy of all original input files

## File Structure

```
BlocIQ_Onboarder/
├── app.py              # Tkinter GUI application
├── onboarder.py        # Core processing logic
├── parsers.py          # File parsing modules
├── mapper.py           # Data mapping to Supabase schema
├── sql_writer.py       # SQL generation
├── schema_mapper.py    # Schema validation
├── classifier.py       # Document classification
├── requirements.txt    # Python dependencies
├── README.md          # This file
└── output/            # Generated files (created on first run)
```

## Supported File Types

- **Excel**: `.xlsx`, `.xls` (property forms, tenant lists, budgets)
- **PDF**: `.pdf` (leases, insurance, compliance documents)
- **Word**: `.docx`, `.doc` (contracts, meeting minutes)
- **CSV**: `.csv` (data exports)

## Document Classification

The app automatically categorizes documents into:

- **Units & Leaseholders**: Property information, tenant lists, leases
- **Budgets**: Financial accounts, service charge statements
- **Compliance**: Safety certificates, inspections, EICR reports
- **Contracts**: Management agreements, service contracts
- **Insurance**: Policy documents, certificates
- **Major Works**: Project documentation, quotes
- **Arrears**: Debt collection procedures, aged debtors

## Next Steps After Processing

1. **Review `migration.sql`** in the Supabase SQL Editor
2. **Execute the SQL** to import data into your Supabase database
3. **Upload files** from `client-backup/` to your S3 storage
4. **Verify data** in your Supabase dashboard

## Requirements

- Python 3.8+
- Tkinter (included with Python)
- Dependencies listed in `requirements.txt`

## Notes

- This is a staff-only tool for internal use
- The app does not execute SQL - it only generates it for review
- All original files are backed up before processing
- Processing runs in a separate thread to keep the UI responsive

## Troubleshooting

- **"No module named 'tkinter'"**: Install python3-tk on Linux: `sudo apt-get install python3-tk`
- **File parsing errors**: Check that files are not corrupted or password-protected
- **Memory issues**: Process smaller batches of files if dealing with very large datasets