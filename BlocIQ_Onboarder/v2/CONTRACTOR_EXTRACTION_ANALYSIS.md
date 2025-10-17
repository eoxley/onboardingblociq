# Contractor Extraction Analysis - Issues Found

## ⚠️ CURRENT EXTRACTION RESULTS

From Connaught Square (367 files):

### Contractors Found: 2 (INACCURATE)

1. **Connaught Square Management**
   - Services: cleaning, security
   - Aliases: "Signed Connaught Square Management"
   - ✅ Valid contractor
   - ⚠️ Missing services they actually provide

2. **"Gas"** ❌ INCORRECT
   - Services: cleaning
   - ⚠️ This is NOT a contractor name!
   - ⚠️ Should be the actual gas company name

---

## ❌ WHAT'S WRONG

### Critical Issues:

1. **"Gas" is not a contractor name**
   - The contract extractor is picking up "Gas" from filename
   - Should be extracting the actual company name from inside the document

2. **Missing known contractors**
   - From previous runs, we know these exist:
     - ✅ New Step (cleaning)
     - ✅ Jacksons Lift (lifts)
     - ✅ Quotehedge (heating/boiler)
     - ✅ ISS (various services)
   - ❌ None of these are being found!

3. **Service categorization wrong**
   - "Gas" is categorized as "cleaning" (clearly wrong)
   - Should be heating/boiler service

4. **Contract dates missing**
   - Only 1 of 4 contracts has start/end dates extracted
   - Contract values: All £0 (not extracted)

---

## 🔍 ROOT CAUSES

### 1. Contract Name Extraction Too Simplistic
Current logic:
- Looks for patterns like "ABC Ltd" in first 2000 chars
- Falls back to filename if not found
- **Problem:** Gets "Gas" from "Gas Contract.pdf" filename

**Needs:**
- Deeper parsing of contract documents
- Look for "between X and Y Ltd" party clauses
- Check signatory sections
- Look for company letterheads

### 2. Not Checking Budget Files for Contractors
Expected contractors in budget line items:
- "Cleaning - New Step Ltd"
- "Lift Maintenance - Jacksons Lift"
- "Heating - Quotehedge"

**Current:** Budget files not being extracted (0 budgets found)
**Impact:** Missing major contractor source!

### 3. Not Checking Property Bible
Property Bible likely contains contractor list with:
- Cleaning contractor
- Lift contractor
- Heating contractor
- Gardening contractor

**Current:** Not being parsed
**Impact:** Missing authoritative source!

---

## 📊 WHAT SHOULD BE FOUND

### Expected Contractors (from previous runs):

| Contractor | Service | Source |
|-----------|---------|--------|
| **New Step** | Cleaning | Budget / Contract |
| **Jacksons Lift** | Lift Maintenance | Budget / Contract |
| **Quotehedge** | Heating/Boiler | Budget / Contract |
| **ISS** | Various | Budget |
| **Connaught Square Management** | Security, Management | Contract ✅ FOUND |

**Current Found:** 2 (but 1 is wrong)
**Expected:** ~5 contractors minimum

---

## 🔧 FIXES NEEDED

### Priority 1: Fix Contract Name Extraction
- Parse "between [Client] and [Contractor Ltd]" clauses
- Look deeper in documents (not just first 2000 chars)
- Check signatory sections
- Ignore generic words like "Gas", "Cleaning", "Lift"

### Priority 2: Fix Budget Extraction
**Currently:** 0 budgets extracted (files detected but extraction failing)
**Impact:** Missing primary contractor source

**Budget files found but not extracted:**
- Connaught Square Budget 2025-Final.xlsx
- Connaught Square Budget 2025-6 Draft.xlsx

**These likely contain:**
- Complete contractor list with services
- Annual costs per contractor
- Service descriptions

### Priority 3: Add Property Bible Parser
Property Bible files contain authoritative contractor lists.

**Need to parse:**
- Contractor name columns
- Service type columns
- Contact details

---

## ⚠️ ACCURACY ASSESSMENT

### Current Contractor Extraction: **INACCURATE**

**Issues:**
- ❌ Only 2 contractors found (should be ~5)
- ❌ One is wrong ("Gas" is not a contractor)
- ❌ Missing New Step, Jacksons Lift, Quotehedge, ISS
- ❌ No contract values extracted
- ❌ Most contract dates missing
- ❌ Services incorrectly categorized

**Root Cause:**
- Budget extraction not working (0 budgets)
- Contract name extraction too simplistic
- Not using Property Bible

---

## 🎯 RECOMMENDED FIXES

### Immediate
1. **Fix budget header detection** (currently returning None)
2. **Enhance contract name extraction** (deeper parsing)
3. **Add contractor name validation** (reject generic words)

### Short-term
4. **Parse Property Bible** for contractor lists
5. **Extract from invoices/expenditure reports**
6. **Check contractor folders** (folder names may indicate contractors)

---

## 📋 CONCLUSION

**Current Status:** ⚠️ **Contractor extraction NOT accurate enough**

**Found:** 2 contractors (1 valid, 1 wrong)
**Expected:** ~5 contractors minimum
**Accuracy:** ~20%

**Critical Fix Needed:** Budget extraction + contract name parsing

This needs to be the next priority before the system is production-ready.

---

*Analysis Date: 17 October 2025*
*Building: Connaught Square*
*Status: ⚠️ Needs Enhancement*

