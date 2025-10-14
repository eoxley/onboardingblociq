# SQL Generator - Quick Start Guide

## Installation

```bash
cd sql-generator
pip install -r requirements.txt
```

## Basic Usage

### Process a folder of documents:

```bash
python main.py /path/to/building/folder
```

This will:
1. Scan the folder for all supported files
2. Read and classify each document
3. Extract metadata (dates, contractors, etc.)
4. Calculate renewal dates and status
5. Generate outputs in `./outputs/`

### Specify building name:

```bash
python main.py /path/to/folder --building-name "Connaught Square"
```

### Configure building features:

```bash
python main.py /path/to/folder \
    --building-name "Connaught Square" \
    --has-lifts \
    --over-11m \
    --has-gas
```

### Custom output directory:

```bash
python main.py /path/to/folder --output-dir /path/to/outputs
```

## Example

```bash
python main.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE" \
    --building-name "Connaught Square" \
    --has-lifts \
    --over-11m
```

## Output Files

For a building named "Connaught Square", you'll get:

```
outputs/
├── Connaught_Square_metadata.json      # Complete metadata
├── Connaught_Square_generated.sql      # SQL INSERT statements
├── Connaught_Square_summary.csv        # CSV summary
└── Connaught_Square_report.html        # HTML report

logs/
└── Connaught_Square_20251014_184500.log  # Processing log
```

## Supported File Types

- **PDF** (.pdf)
- **Word** (.doc, .docx)
- **Excel** (.xls, .xlsx)
- **CSV** (.csv)
- **Text** (.txt, .rtf)
- **Email** (.eml, .msg)
- **Images** (.png, .jpg, .jpeg) - requires OCR integration

## Document Types Detected

- FRA (Fire Risk Assessment)
- EICR (Electrical Installation Condition Report)
- Asbestos Survey
- Legionella Risk Assessment
- Lift/LOLER Inspection
- Insurance Policy
- Gas Safety Certificate
- Emergency Lighting Test
- Fire Alarm Inspection
- Safety Case
- Leases
- Budgets
- Major Works
- Meeting Minutes
- And more...

## Configuration

Edit config files to customize:

- `config/renewal_rules.json` - Renewal periods by document type
- `config/expected_docs.json` - Required documents by building type

## Testing

Test individual modules:

```bash
python test_generator.py
```

Test specific modules:

```bash
python classifier.py
python extractor.py
python time_utils.py
python reporter.py
```

## Troubleshooting

### Missing dependencies

```bash
pip install -r requirements.txt
```

### File reading errors

Check the log file in `logs/` for detailed error messages.

### Classification issues

Review `config/renewal_rules.json` and adjust keyword patterns if needed.

## Integration with Existing Onboarder

The SQL Generator is a standalone tool that can be used independently or integrated with the existing BlocIQ Onboarder.

To use it as a replacement for the current SQL generation logic:

1. Process documents with: `python main.py /path/to/folder`
2. Review the generated `{building}_metadata.json`
3. Use the generated `{building}_generated.sql` for database import
4. Upload files to Supabase Storage using the metadata

## Next Steps

1. Test with real building folders
2. Review classification accuracy
3. Adjust renewal rules if needed
4. Integrate with Supabase upload workflow
5. Add OCR integration for image documents
