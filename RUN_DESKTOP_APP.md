# 🖥️ RUNNING THE BLOCIQ DESKTOP APPLICATION

The BlocIQ Onboarder desktop application is **fully connected** to the SQL generator and includes all the latest updates (contractor names, comprehensive PDF reports, etc.)

---

## 🚀 METHOD 1: Run the Python Desktop App (Fastest for testing)

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 app.py
```

**This will:**
1. Open a GUI window
2. Let you select a building folder
3. Automatically run extraction
4. **Generate SQL migration** (using updated `sql_writer.py`)
5. Show SQL preview in the app
6. Save outputs to `BlocIQ_Onboarder/output/`

---

## 🚀 METHOD 2: Run the Packaged Mac App

```bash
# Open the pre-built Mac application
open /Users/ellie/onboardingblociq/BlocIQ_Onboarder/dist/BlocIQOnboarder.app
```

**Note:** This may be an older build. If so, rebuild it:

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
./build_app.sh
```

---

## 🚀 METHOD 3: Command Line (Most Direct)

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 onboarder.py "/path/to/building/folder"
```

**Outputs:**
- `output/migration.sql` - Complete SQL for Supabase
- `output/summary.json` - All extracted data
- `output/building_health_check.pdf` - Health check report

---

## 📊 WHAT THE DESKTOP APP DOES

### Automatic Process:
1. ✅ **Scans** building folder for documents
2. ✅ **Classifies** documents (budgets, leases, compliance, etc.)
3. ✅ **Extracts** data from all document types
4. ✅ **Generates SQL** with contractor names (uses `sql_writer.py`)
5. ✅ **Creates PDF** summary report
6. ✅ **Shows preview** of SQL in app

### Connected Components:
- ✅ `sql_writer.py` - SQL generator (updated with contractor fields)
- ✅ `mapper.py` - Data mapping
- ✅ `extractors/` - All document extractors
- ✅ `report_generator.py` - PDF reports

---

## 🎯 RECOMMENDED: TEST RUN

Let's do a test run with Connaught Square:

```bash
# Navigate to onboarder
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder

# Run the desktop app
python3 app.py
```

**In the app:**
1. Click "Select Client Folder"
2. Choose: `/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE`
3. Click "Start Processing"
4. Wait for completion (2-3 minutes)
5. Review the SQL preview
6. Click "Save SQL to File"
7. Check the outputs in `BlocIQ_Onboarder/output/`

---

## 📁 OUTPUT FILES

After running, you'll find:

```
BlocIQ_Onboarder/output/
├── migration.sql              ← Complete SQL for Supabase
├── summary.json               ← All extracted data
├── building_health_check.pdf  ← Health check report
├── categorized_files_debug.json
├── audit_log.json
└── validation_report.json
```

---

## ✅ CONFIRMATION: SQL GENERATOR IS CONNECTED

The desktop app uses `BlocIQ_Onboarder/sql_writer.py` which we've already updated to include:

✅ Contractor names (cleaning_contractor, lift_contractor, etc.)  
✅ All 15 entity types (units, leaseholders, compliance, budgets, etc.)  
✅ Complete lease analysis (clauses, parties, financial terms)  
✅ Insurance policies  
✅ Maintenance schedules  
✅ Major works  

---

## 🔄 WORKFLOW COMPARISON

### Desktop App Workflow:
```
Select Folder → Extract Data → Generate SQL → Save Files → Review in App
```

### Command Line Workflow (our new script):
```bash
python3 run_complete_onboarding.py "/path/to/folder"
# Extracts → SQL → PDF → Auto-opens
```

**Both use the same SQL generator!**

---

## 🎨 DESKTOP APP FEATURES

- ✅ Visual progress tracking
- ✅ SQL preview window
- ✅ Copy SQL to clipboard
- ✅ Building name detection
- ✅ Document classification summary
- ✅ Error handling with friendly messages
- ✅ Auto-saves all outputs

---

## 🐛 IF YOU ENCOUNTER ISSUES

### Desktop app won't launch:
```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
pip3 install -r requirements.txt
python3 app.py
```

### Want to see terminal output:
```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
```

### Need to rebuild the Mac app:
```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
./build_app.sh
```

---

## 🎯 READY TO TRY?

Run this now to test with Connaught Square:

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder && python3 app.py
```

Or for command line:

```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 onboarder.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
```

**The SQL it generates will include contractor names and all the latest updates!** ✅

