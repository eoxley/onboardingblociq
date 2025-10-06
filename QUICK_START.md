# BlocIQ Onboarding Generator - Quick Start Guide

## 🚀 Quick Commands

### 1. Run Onboarding
```bash
python onboarder.py "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/"
```

### 2. Run Diagnostic
```bash
node diagnostic.js output/migration.sql
```

### 3. Execute Migration
```bash
psql -d your_database -f output/migration.sql
```

---

## 📊 What's New

### Financial Documents Enhancement
- **Enhanced Detection**: Captures budgets, variance reports, apportionments, quarterly statements
- **Metadata Extraction**: Automatically extracts `financial_year` (e.g., "2025") and `period_label` (e.g., "Q1")
- **Summary Report**: Shows all financial years and periods detected

### Migration Diagnostic Tool
- **Health Checks**: Validates dates, UUIDs, foreign keys, duplicates
- **Smart Suggestions**: Provides actionable fix recommendations
- **Date Intelligence**: Extracts and parses dates from filenames

---

## 📝 Expected Output

### Onboarding Summary
```
============================================================
✅ ONBOARDING COMPLETE
============================================================

Building: Connaught Square
Units: 15
Leaseholders: 12
Documents: 145
Compliance Assets: 35
Budgets: 18

============================================================
💰 FINANCIAL DOCUMENTS SUMMARY
============================================================

Detected 82 financial documents
Financial Years Found: 2021, 2022, 2023, 2024, 2025, 2026
Period Labels Found: Q1, Q2, Q3, Q4, AUG 21, NOV 22

Inserted 82 entries into building_documents ✅

Financial Document Types:
  • Apportionment Schedule: 15
  • Budget: 25
  • Service Charge Account: 20
  • Service Charge Demand: 12
  • Variance Report: 10
============================================================
```

### Diagnostic Report
```
============================================================
BlocIQ Migration Diagnostic
============================================================
File: output/migration.sql

📊 Record Counts:
  Buildings: 1
  Units: 15
  Leaseholders: 12
  Documents: 145
  Compliance Assets: 35
  Budgets: 18

⚠️  Warnings:
  15 compliance_assets missing inspection_date
  All 35 compliance_assets have default frequency "12 months"

ℹ️  Information:
  ✅ ON CONFLICT protection found
  ✅ Budget documents include financial_year and period_label metadata
  ✅ 487 UUIDs detected
  📅 23 potential date(s) found in filenames/data

💡 Suggestions:
  • Extract specific frequencies: EICR (60 months), LOLER (6 months)
============================================================
```

---

## 🔧 Troubleshooting

### Issue: No financial documents detected
**Solution:** Check if files contain keywords: budget, variance, apportionment, YE, Q1-Q4

### Issue: Missing financial_year/period_label
**Solution:** Ensure filenames follow patterns:
- YE25, YE 2024 (for year)
- Q1, Q2, Q3, Q4 (for quarter)
- Aug 22, Nov 23 (for month)

### Issue: Diagnostic shows UUID warnings
**Solution:** Check if UUIDs are properly formatted (8-4-4-4-12 hex digits)

### Issue: Duplicate inserts detected
**Solution:** Review source files for duplicates or adjust classification logic

---

## 📚 Documentation

- **Financial Enhancement**: See `UPGRADE_SUMMARY.md` section 1
- **Diagnostic Tool**: See `DIAGNOSTIC_README.md`
- **Full Details**: See `UPGRADE_SUMMARY.md`

---

## 🎯 Workflow

```
┌─────────────────┐
│  Source Files   │
│  (Excel, PDF)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Onboarder     │
│  (Python)       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  migration.sql  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Diagnostic    │
│   (Node.js)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Review & Fix   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Execute SQL   │
│   (psql/Supabase)│
└─────────────────┘
```

---

## ✅ Checklist

Before executing migration:

- [ ] Onboarding completed successfully
- [ ] Financial summary shows expected years/periods
- [ ] Diagnostic shows ✅ for budget metadata
- [ ] No critical issues in diagnostic report
- [ ] UUID count matches expected records
- [ ] ON CONFLICT protection present
- [ ] Foreign keys validated

---

## 🆘 Support

For issues or questions:
1. Check `UPGRADE_SUMMARY.md` for detailed explanations
2. Review `DIAGNOSTIC_README.md` for diagnostic troubleshooting
3. Examine example SQL output for expected format
