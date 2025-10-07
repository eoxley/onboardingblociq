# 📁 BlocIQ Onboarder - Project Structure

Clean, organized codebase with documentation, tests, and SQL scripts separated into logical folders.

---

## 🗂️ Directory Structure

```
BlocIQ_Onboarder/
│
├── 📄 Core Application Files
│   ├── onboarder.py                              # Main orchestrator
│   ├── sql_writer.py                             # SQL migration generator
│   ├── document_mapper.py                        # BlocIQ V2 schema mapper
│   ├── parser.py                                 # Document parser (PDF/DOCX/XLSX)
│   ├── classifier.py                             # AI document classifier
│   │
│   ├── 🔍 Extractors
│   ├── excel_financial_extractor.py              # Excel budget/apportionment extraction
│   ├── lease_extractor.py                        # Lease extraction with OCR
│   ├── staffing_extractor.py                     # Building staff extraction
│   ├── financial_intelligence_extractor.py       # Financial intelligence
│   ├── compliance_extractor.py                   # Compliance assets
│   ├── financial_extractor.py                    # Financial data
│   ├── major_works_extractor.py                  # Major works notices
│   │
│   ├── 🔧 Utilities
│   ├── mapper.py                                 # Data mapping utilities
│   ├── matchers.py                               # Unit/leaseholder matching
│   ├── data_collator.py                          # Data collation
│   ├── enrichment_processor.py                   # Post-processing enrichment
│   ├── schema_mapper.py                          # Schema validation
│   │
│   └── 🖥️ Interface
│       ├── app.py                                # Flask web interface
│       └── launch.py                             # Launcher script
│
├── 📊 reporting/
│   ├── __init__.py
│   └── building_health_check.py                  # Professional PDF report generator
│       └── Generates: Building Health Check with lease summaries
│
├── 📚 docs/                                       # All Documentation
│   ├── README.md                                 # Basic usage guide
│   ├── COMPLETE_SYSTEM_SUMMARY.md                # Full system documentation
│   ├── LEASE_EXTRACTION_README.md                # Lease extraction guide
│   ├── EXCEL_FINANCIAL_EXTRACTION_README.md      # Excel extraction guide
│   ├── SUPABASE_SCHEMA_VERIFICATION.md           # Schema compatibility
│   ├── DATA_VALIDATION_GUIDE.md                  # Validation rules
│   ├── ONBOARDING_GUIDANCE.md                    # Step-by-step guide
│   ├── EXAMPLE_USAGE.md                          # Usage examples
│   └── PACKAGING.md                              # Deployment guide
│
├── 🧪 tests/                                      # All Test Files
│   ├── __init__.py
│   ├── test_insurance_extractor.py               # Insurance extraction tests
│   ├── test_insurance_classification.py          # Classification tests
│   ├── test_classifier_preservation.py           # Classifier tests
│   ├── exact_test.py                             # Exact match tests
│   ├── cli_test.py                               # CLI tests
│   └── test_app.py                               # Application tests
│
├── 🗄️ sql_scripts/                               # SQL Utilities
│   ├── DELETE_BUILDING.sql                       # Building cleanup script
│   └── test_schema.sql                           # Schema testing
│
├── 📦 Supporting Files
│   ├── requirements.txt                          # Python dependencies
│   ├── .env.example                              # Environment template
│   └── .gitignore                                # Git ignore rules
│
└── 📋 Project Documentation
    ├── README.md                                 # Main project README
    ├── PROJECT_STRUCTURE.md                      # This file
    └── CHANGELOG.md                              # Version history
```

---

## 📚 Documentation Guide

### Getting Started
1. **Read First**: [README.md](README.md) - Quick start and overview
2. **Deep Dive**: [docs/COMPLETE_SYSTEM_SUMMARY.md](docs/COMPLETE_SYSTEM_SUMMARY.md) - Full system details

### Feature-Specific Guides
- **Lease Extraction**: [docs/LEASE_EXTRACTION_README.md](docs/LEASE_EXTRACTION_README.md)
- **Excel Financial**: [docs/EXCEL_FINANCIAL_EXTRACTION_README.md](docs/EXCEL_FINANCIAL_EXTRACTION_README.md)
- **Schema Compatibility**: [docs/SUPABASE_SCHEMA_VERIFICATION.md](docs/SUPABASE_SCHEMA_VERIFICATION.md)

### Operational Guides
- **Data Validation**: [docs/DATA_VALIDATION_GUIDE.md](docs/DATA_VALIDATION_GUIDE.md)
- **Step-by-Step**: [docs/ONBOARDING_GUIDANCE.md](docs/ONBOARDING_GUIDANCE.md)
- **Deployment**: [docs/PACKAGING.md](docs/PACKAGING.md)

---

## 🔑 Key Components

### Core Processing Pipeline

```
onboarder.py
├─> parser.py              (Parse PDFs/DOCX/XLSX)
├─> classifier.py          (Categorize documents)
├─> document_mapper.py     (Map to BlocIQ V2 schema)
│
├─> Extractors:
│   ├─> excel_financial_extractor.py
│   ├─> lease_extractor.py (with OCR)
│   ├─> staffing_extractor.py
│   └─> financial_intelligence_extractor.py
│
├─> enrichment_processor.py (Post-processing)
├─> sql_writer.py          (Generate migration.sql)
└─> reporting/building_health_check.py (Generate PDF)
```

### Report Generation

```
building_health_check.py
├─> Queries Supabase for live data
├─> Generates 15-section PDF report
│   ├─> Section 13: Lease Summaries (NEW)
│   │   ├─> Executive summary per lease
│   │   ├─> Property details table
│   │   ├─> Key lease terms (6 clauses)
│   │   └─> Professional disclaimer
│   └─> Applies BlocIQ letterhead to all pages
└─> Output: /reports/{building_id}/building_health_check.pdf
```

---

## 🎯 File Purposes

### Extraction Files

| File | Purpose | Output |
|------|---------|--------|
| `excel_financial_extractor.py` | Extract budgets, apportionments from Excel | `budgets`, `apportionments`, `building_insurance` |
| `lease_extractor.py` | Extract lease data with OCR | `leases` table records |
| `staffing_extractor.py` | Extract building staff info | `building_staff` table records |
| `financial_intelligence_extractor.py` | Extract fire doors, insurance | `fire_door_inspections`, `building_insurance` |
| `compliance_extractor.py` | Extract compliance assets | `compliance_assets` table records |

### Core Files

| File | Purpose |
|------|---------|
| `onboarder.py` | Main orchestrator - runs complete pipeline |
| `sql_writer.py` | Generates migration.sql with DDL + INSERTs |
| `document_mapper.py` | Maps parsed data to BlocIQ V2 schema |
| `parser.py` | Parses PDF/DOCX/XLSX/CSV files |
| `classifier.py` | AI-powered document categorization |
| `mapper.py` | Data mapping utilities |
| `matchers.py` | Fuzzy matching for units/leaseholders |

### Reporting Files

| File | Purpose |
|------|---------|
| `reporting/building_health_check.py` | Generates comprehensive PDF report with lease summaries |

---

## 🧪 Testing

### Running Tests

```bash
# All tests
cd tests && python3 -m pytest

# Specific test
python3 tests/test_insurance_extractor.py

# Test coverage
python3 -m pytest --cov=. --cov-report=html
```

### Test Files

| File | Tests |
|------|-------|
| `test_insurance_extractor.py` | Insurance data extraction |
| `test_insurance_classification.py` | Document classification accuracy |
| `test_classifier_preservation.py` | Classifier behavior |
| `exact_test.py` | Exact match validation |
| `cli_test.py` | Command-line interface |
| `test_app.py` | Flask application |

---

## 🗄️ SQL Scripts

| File | Purpose |
|------|---------|
| `DELETE_BUILDING.sql` | Safely delete building and all related records |
| `test_schema.sql` | Test schema compatibility |

---

## 📦 Output Structure

```
/Users/ellie/Desktop/BlocIQ_Output/
├── migration.sql                      # Complete SQL migration
├── audit_log.json                     # Processing audit trail
├── summary.json                       # Extracted data summary
├── document_log.csv                   # Per-document processing log
├── confidence_report.csv              # AI confidence scores
├── document_summary.html              # Visual document summary
│
└── {building_id}/                     # Building-specific outputs
    └── building_health_check.pdf      # Professional report with lease summaries
```

---

## 🎨 Code Organization Principles

### ✅ Clean Separation
- **Documentation**: All `.md` files in `docs/`
- **Tests**: All test files in `tests/`
- **SQL**: All `.sql` files in `sql_scripts/`
- **Core**: Application code in root
- **Reporting**: Report generation in `reporting/`

### ✅ Clear Naming
- Extractors: `*_extractor.py`
- Tests: `test_*.py`
- Documentation: `*_README.md`, `*_GUIDE.md`
- SQL Scripts: `*.sql`

### ✅ Logical Grouping
- Feature-specific docs grouped by topic
- Tests mirror source file structure
- SQL utilities in dedicated folder

---

## 🚀 Adding New Features

### Adding a New Extractor

1. Create file: `new_feature_extractor.py`
2. Implement: `extract_all()` method returning `Dict`
3. Integrate in: `onboarder.py::run()` method
4. Add SQL generation in: `sql_writer.py`
5. Document in: `docs/NEW_FEATURE_README.md`
6. Test in: `tests/test_new_feature.py`

### Adding Documentation

1. Create file in: `docs/FEATURE_NAME.md`
2. Update: `README.md` with link
3. Update: `PROJECT_STRUCTURE.md` (this file)

### Adding Tests

1. Create file in: `tests/test_feature_name.py`
2. Follow naming convention: `test_*`
3. Run tests: `python3 -m pytest tests/`

---

## 📊 Statistics

### Codebase Size
- **Core Files**: 25+ Python files
- **Documentation**: 9 comprehensive guides
- **Tests**: 7 test suites
- **Total Lines**: ~15,000+ lines of code
- **SQL Statements**: Auto-generated (typically 300-500 INSERTs per building)

### Features
- ✅ 7 specialized extractors
- ✅ OCR integration (Render.com)
- ✅ Auto-migration to Supabase
- ✅ 15-section PDF reports
- ✅ Lease summaries with 6 standard clauses
- ✅ Health scoring algorithm
- ✅ Error logging & audit trails

---

## 🔧 Maintenance

### Regular Tasks
- Review `timeline_events` table for extraction errors
- Monitor OCR service uptime (Render.com)
- Update regex patterns as lease formats evolve
- Review confidence scores in `confidence_report.csv`

### Troubleshooting
- Check `audit_log.json` for processing statistics
- Review `tests/` for regression issues
- Consult `docs/DATA_VALIDATION_GUIDE.md` for validation rules

---

## 📝 Version History

- **v2.0** (2025-10-07)
  - ✅ Lease extraction with OCR
  - ✅ Comprehensive lease summaries in PDF
  - ✅ Excel financial extraction (no OCR)
  - ✅ Building staff extraction
  - ✅ Clean project structure
  - ✅ Complete documentation

- **v1.0** (2025-10-01)
  - Initial release with basic extraction

---

## 🎯 Quick Reference

| I want to... | Go to... |
|--------------|----------|
| Run the onboarder | `python3 onboarder.py "/path/"` |
| Understand lease extraction | [docs/LEASE_EXTRACTION_README.md](docs/LEASE_EXTRACTION_README.md) |
| Check schema compatibility | [docs/SUPABASE_SCHEMA_VERIFICATION.md](docs/SUPABASE_SCHEMA_VERIFICATION.md) |
| View all features | [docs/COMPLETE_SYSTEM_SUMMARY.md](docs/COMPLETE_SYSTEM_SUMMARY.md) |
| Run tests | `cd tests && python3 -m pytest` |
| Clean up a building | `sql_scripts/DELETE_BUILDING.sql` |
| Deploy to production | [docs/PACKAGING.md](docs/PACKAGING.md) |

---

**Status**: ✅ Clean & Organized | ✅ Production Ready
**Last Updated**: 2025-10-07
