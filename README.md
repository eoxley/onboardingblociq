# BlocIQ Onboarding System

Property management document processing and database migration system.

## 🚀 Quick Start

```bash
# Run the onboarder
cd BlocIQ_Onboarder
python3 onboarder.py "/path/to/building/documents"
```

## 📁 Directory Structure

```
.
├── BlocIQ_Onboarder/          # Main application
│   ├── onboarder.py           # Main entry point
│   ├── schema_mapper.py       # Data schema mapping
│   ├── schema_validator.py    # Schema validation
│   ├── reporting/             # PDF report generators
│   │   └── building_health_check_v2.py
│   └── ...
│
├── scripts/                   # Utility scripts
│   └── export_supabase_schema.py
│
├── tests/                     # Verification tests
│   ├── test_health_check_generation.py
│   └── test_sql_generation.py
│
├── archive/                   # Archived old files
│   ├── old_migrations/
│   ├── old_schema_scripts/
│   ├── old_sql/
│   ├── old_tests/
│   └── old_docs/
│
├── output/                    # Generated outputs
│   ├── migration.sql          # Database migration
│   ├── building_health_check.pdf
│   ├── summary.json
│   └── ...
│
├── supabase_current_schema.json  # Current DB schema
└── .env                       # Environment configuration
```

## 🔧 Configuration

Edit `.env` file with your credentials:
- Supabase URL and keys
- OpenAI API key
- PostgreSQL connection details

## 📊 Outputs

After running, check `output/` directory for:
- `migration.sql` - Schema-compliant SQL for database
- `building_health_check.pdf` - Building health report (V2)
- `summary.json` - Processing summary
- `audit_log.json` - Detailed processing log

## ✅ Testing

```bash
# Test PDF generation
python3 tests/test_health_check_generation.py

# Test SQL generation
python3 tests/test_sql_generation.py
```

## 🔄 Schema Management

```bash
# Export current Supabase schema
python3 scripts/export_supabase_schema.py
```

## 📝 Recent Changes (Oct 10, 2025)

- ✅ Schema validation against actual Supabase schema
- ✅ Building Health Check V2 PDF generator
- ✅ Column mappings: `name → project_name`, `file_path → storage_path`
- ✅ Status value mapping: `planning → planned`
- ✅ Cleaned up 100+ old/redundant files

## 🗃️ Archive

Old files moved to `archive/` directory for reference:
- Migration scripts and SQL files
- Schema discovery scripts
- Test/debug utilities
- Historical documentation
