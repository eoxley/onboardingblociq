# Connaught Square - Folder Audit vs Extracted Data

**Total Files:** 368 files  
**Date:** October 16, 2025

---

## 📁 FOLDER STRUCTURE (Actual)

| Folder | Files | File Types | Purpose |
|--------|-------|------------|---------|
| **1. CLIENT INFORMATION** | 20 | PDF (13), DOCX (7) | Management agreements, leases, company docs, meetings |
| **2. FINANCE** | 21 | PDF (11), XLSX (5), MSG (4) | Budgets, year-end accounts, financial reports |
| **3. GENERAL CORRESPONDENCE** | 7 | DOCX (6), PDF (1) | Leaseholder/client communications |
| **4. HEALTH & SAFETY** | 92 | PDF (76), XLSX (2), IMG (13) | All compliance assessments |
| **5. INSURANCE** | 52 | PDF (49), MSG (3) | Buildings, Terrorism, D&O, Engineering |
| **6. MAJOR WORKS** | 6 | DOCX (3), PDF (2), MSG (1) | Project notices and documentation |
| **7. CONTRACTS** | 114 | PDF (99), XLSX (4), MSG (6) | Cleaning, Gardening, Staff, Lifts, etc. |
| **8. FLAT CORRESPONDENCE** | 4 | PDF (3), PNG (1) | Leaseholder-specific |
| **9. BUILDING DRAWINGS & PLANS** | 8 | JFIF (8) | Drawings (images) |
| **11. HANDOVER** | 38 | PDF (27), MSG (8), XLSX (2) | Handover documents |
| **ROOT** | 6 | XLSX (3), DOCX (2) | Property info, apportionments, meetings |

**TOTAL:** 368 files across 11 categories

---

## 🎯 WHAT NEEDS TO BE EXTRACTED (Your Specification)

### ✅ Already Good:
1. Folder categorization matches specification
2. Files are somewhat organized

### ⚠️ Extraction Improvements Needed:

#### 1. **File Categorization & Logging**
- [ ] Create comprehensive file log showing where each file was categorized
- [ ] Generate suggestions for miscategorized files

#### 2. **Client Information**
- [ ] Extract management agreement details and dates
- [ ] Parse company secretary information
- [ ] Extract meeting schedules and dates

#### 3. **Finance - Deep Parsing**
- [ ] Extract latest accounts issue date and approval date
- [ ] Parse budget with ALL line items and amounts
- [ ] Identify service charge year end date
- [ ] Extract demand dates and frequency

#### 4. **Health & Safety - Building Analysis**
- [ ] Read H&S reports to extract:
  - Building description
  - Number of floors
  - Building height
  - Construction details
- [ ] Create comprehensive asset register from all H&S docs
- [ ] Extract compliance dates (last assessment, next due)
- [ ] Find CURRENT/ACTIVE assessments, fallback to latest

#### 5. **Contracts - Contractor Consolidation**
- [ ] Extract contractor name, service type, contract dates
- [ ] Consolidate from budgets, invoices, contracts
- [ ] NO DUPLICATES - aggregate services per contractor
- [ ] Identify site staff (names, hours)

#### 6. **Units & Leaseholders - Unified Table**
- [ ] Unit number
- [ ] Floor number (if applicable)
- [ ] Leaseholder name(s)
- [ ] Correspondence address
- [ ] Email
- [ ] Phone numbers
- [ ] Apportionment %
- [ ] ALL IN ONE TABLE for SQL

#### 7. **Lease Analysis - Deep Dive**
- [ ] Select 3 representative leases
- [ ] Full clause-by-clause analysis
- [ ] Extract: service charge dates, reserve fund rules, responsibilities
- [ ] Cross-check with budget/demand dates
- [ ] Identify assignments and covenants

#### 8. **Building Assets Register**
- [ ] Compliance assets (Fire, Gas, Electrical, Lifts, etc.)
- [ ] Facilities (CCTV, Parking, EV chargers, Gym, Pool, etc.)
- [ ] Installations (Door entry, gates, lighting, etc.)

---

## 📊 CURRENT EXTRACTION VS REQUIRED

### What We Extract Now:
- ✅ 8 units
- ✅ 8 leaseholders
- ✅ 31 compliance assets (but dates unclear)
- ✅ Budget (but only totals, not line items)
- ✅ Some contractors

### What's Missing/Inaccurate:
- ❌ No floor numbers for units
- ❌ Incomplete leaseholder contact details
- ❌ Apportionments not linked properly
- ❌ Budget line items not extracted
- ❌ Accounts issue/approval dates not extracted
- ❌ Service charge demand dates not extracted
- ❌ Compliance assessment dates unclear
- ❌ Contract dates not extracted
- ❌ Contractors not consolidated (duplicates exist)
- ❌ Site staff not identified
- ❌ Lease analysis superficial (need deep dive on 3 leases)
- ❌ Building description from H&S reports not extracted
- ❌ Facility asset register incomplete

---

## 🎯 NEXT STEPS

1. **Build Intelligent Document Analyzer**
   - Read PDFs to extract structured data
   - Parse Excel files for exact amounts/dates
   - Extract text from Word docs for context

2. **Create Comprehensive Extractors**
   - Budget parser with line items
   - Compliance date extractor
   - Contract consolidator
   - Lease clause analyzer

3. **Generate Accurate SQL**
   - All data mapped correctly
   - Dates properly formatted
   - No missing information

4. **Generate Client PDF**
   - Matches extracted data exactly
   - Professional format
   - Complete information

5. **Clean Up Codebase**
   - Archive old files
   - Remove redundant code
   - Organize properly

---

**This audit shows we have the DATA in the folders, but our EXTRACTION needs to be more thorough and accurate.**

