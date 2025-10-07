# 🏢 BlocIQ Onboarder

Comprehensive property onboarding automation system that processes building documents, extracts data using OCR, and generates structured SQL migrations for the BlocIQ V2 platform.

---

## 🚀 Quick Start

```bash
# Install dependencies
pip install pandas requests reportlab PyPDF2

# Run onboarding
python3 onboarder.py "/path/to/building/folder/"
```

---

## 📦 Features

### ✅ Document Processing
- PDF, DOCX, XLSX, CSV parsing
- Automatic categorization (finance, compliance, leases, contracts)
- OCR integration via Render.com service (Tesseract/Google Vision)

### ✅ Data Extraction
- **Leases**: Term, rent, parties, dates (with OCR)
- **Budgets**: Year ranges, totals, status
- **Apportionments**: Unit percentages with validation
- **Insurance**: Policies, expiry dates, premiums
- **Staff**: Roles, hours, contacts, company links
- **Fire Door Inspections**: Compliance tracking

### ✅ SQL Generation
- Auto-creates tables if they don't exist
- Generates complete migration.sql
- Safe to re-run (ON CONFLICT DO NOTHING)
- Auto-executes to Supabase (if configured)

### ✅ Building Health Check Report
- Professional PDF with letterhead
- 15 comprehensive sections
- Lease summaries with standard clauses
- Health scoring (40% compliance, 25% maintenance, 25% financial, 10% insurance)
- Client-facing format

---

## 📁 Project Structure

```
BlocIQ_Onboarder/
├── 📄 Core Files
│   ├── onboarder.py                              # Main orchestrator
│   ├── sql_writer.py                             # SQL generator
│   ├── document_mapper.py                        # Schema mapper
│   ├── excel_financial_extractor.py              # Excel extraction
│   ├── lease_extractor.py                        # Lease + OCR
│   ├── staffing_extractor.py                     # Staff extraction
│   └── financial_intelligence_extractor.py       # Financial intel
│
├── 📊 Reporting
│   └── reporting/
│       └── building_health_check.py              # PDF generator
│
├── 📚 Documentation
│   └── docs/
│       ├── README.md                             # Basic usage
│       ├── COMPLETE_SYSTEM_SUMMARY.md            # Full system docs
│       ├── LEASE_EXTRACTION_README.md            # Lease extraction guide
│       ├── EXCEL_FINANCIAL_EXTRACTION_README.md  # Excel extraction guide
│       ├── SUPABASE_SCHEMA_VERIFICATION.md       # Schema compatibility
│       ├── DATA_VALIDATION_GUIDE.md              # Validation rules
│       ├── ONBOARDING_GUIDANCE.md                # Step-by-step guide
│       ├── EXAMPLE_USAGE.md                      # Usage examples
│       └── PACKAGING.md                          # Deployment guide
│
├── 🧪 Tests
│   └── tests/
│       ├── test_insurance_extractor.py
│       ├── test_insurance_classification.py
│       ├── test_classifier_preservation.py
│       ├── exact_test.py
│       ├── cli_test.py
│       └── test_app.py
│
└── 🗄️ SQL Scripts
    └── sql_scripts/
        ├── DELETE_BUILDING.sql                   # Cleanup script
        └── test_schema.sql                       # Schema test
```

---

## 🔧 Configuration

### Required Environment Variables (Optional)

```bash
# OCR Service (for lease extraction)
export RENDER_OCR_URL="https://ocr-server-2-ykmk.onrender.com/upload"
export RENDER_OCR_TOKEN="blociq-dev-token-2024"

# Supabase (for auto-execution and Building Health Check)
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
```

**Note**: System works without these, but with reduced functionality:
- Without OCR: Partial lease records created from filenames only
- Without Supabase: Migration SQL generated but not auto-executed

---

## 📊 Output

### Generated Files

```
/Users/ellie/Desktop/BlocIQ_Output/
├── migration.sql                      # Complete SQL migration
├── audit_log.json                     # Processing audit trail
├── summary.json                       # Extracted data summary
├── document_log.csv                   # Per-document log
├── confidence_report.csv              # AI confidence scores
├── document_summary.html              # Visual summary
└── {building_id}/
    └── building_health_check.pdf      # Comprehensive report
```

---

## 🎯 Database Schema

### Tables Auto-Created

```sql
-- Core
buildings, units, leaseholders, documents

-- Financial
budgets, apportionments, building_insurance

-- Compliance
compliance_assets, fire_door_inspections

-- Property Management
building_contractors, building_staff, building_utilities

-- Leases
leases (NEW: term_start, term_years, ground_rent, parties, etc.)

-- Audit
timeline_events (NEW: error logging and tracking)
```

---

## 📖 Documentation

### Quick Reference

| Topic | Document |
|-------|----------|
| **Complete System Overview** | [docs/COMPLETE_SYSTEM_SUMMARY.md](docs/COMPLETE_SYSTEM_SUMMARY.md) |
| **Lease Extraction Guide** | [docs/LEASE_EXTRACTION_README.md](docs/LEASE_EXTRACTION_README.md) |
| **Excel Financial Extraction** | [docs/EXCEL_FINANCIAL_EXTRACTION_README.md](docs/EXCEL_FINANCIAL_EXTRACTION_README.md) |
| **Schema Compatibility** | [docs/SUPABASE_SCHEMA_VERIFICATION.md](docs/SUPABASE_SCHEMA_VERIFICATION.md) |
| **Data Validation Rules** | [docs/DATA_VALIDATION_GUIDE.md](docs/DATA_VALIDATION_GUIDE.md) |
| **Step-by-Step Guide** | [docs/ONBOARDING_GUIDANCE.md](docs/ONBOARDING_GUIDANCE.md) |
| **Usage Examples** | [docs/EXAMPLE_USAGE.md](docs/EXAMPLE_USAGE.md) |

---

## 🧪 Testing

```bash
# Run all tests
cd tests
python3 -m pytest

# Run specific test
python3 test_insurance_extractor.py
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: OCR service unavailable
```
⚠️  OCR service not configured
```
**Solution**: Set `RENDER_OCR_URL` and `RENDER_OCR_TOKEN` environment variables

**Issue**: Supabase connection failed
```
⚠️  Could not execute migration
```
**Solution**: Check `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` or execute `migration.sql` manually

**Issue**: Missing lease fields
```
⚠️  Errors: 1
```
**Solution**: Check `timeline_events` table or `audit_log.json` for details

---

## 📈 Performance

### Typical Processing Times
- **Excel Extraction**: ~100ms per file
- **Lease OCR**: ~5-15 seconds per page
- **Building Health Check**: ~2-5 seconds
- **Complete Pipeline**: ~30-60 seconds for 300 documents

### Resource Requirements
- **Memory**: ~500MB
- **Disk**: ~1GB temporary files
- **Network**: OCR service calls (60s timeout each)

---

## 🎓 Example Usage

### Basic Onboarding
```python
python3 onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/"
```

### Expected Output
```
📊 Extracting financial data from Excel files...
     ✅ Budgets extracted: 3
     ✅ Apportionments extracted: 8
     ✅ Insurance records: 2

👤 Extracting building staffing data...
     ✅ Staff members found: 5

📜 Extracting lease information...
     🔍 Performing OCR on Flat3_Lease.pdf...
        ✅ OCR complete: 3500 characters extracted
     ✅ Lease files found: 6
     ✅ Leases extracted: 5
     ✅ Files processed with OCR: 3

📊 Generating Building Health Check Report...
   ✅ Report generated: /Users/ellie/Desktop/BlocIQ_Output/.../building_health_check.pdf

✅ Onboarding complete!
```

---

## 🔒 Data Safety

- ✅ Safe to re-run (uses `ON CONFLICT DO NOTHING`)
- ✅ Partial records created when OCR fails
- ✅ All errors logged to `timeline_events`
- ✅ Audit trail in `audit_log.json`
- ✅ No data overwrites without explicit UUIDs

---

## 🚀 Deployment

See [docs/PACKAGING.md](docs/PACKAGING.md) for deployment instructions.

---

## 📝 License

Proprietary - BlocIQ Limited

---

## 🤝 Support

For issues or questions, please contact the BlocIQ development team.

---

**Status**: ✅ Production Ready
**Version**: 2.0
**Last Updated**: 2025-10-07
