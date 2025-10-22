# 🏗️ Contractor Onboarding - System Architecture

Visual guide to how all components work together.

---

## 🎯 SYSTEM OVERVIEW

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTRACTOR ONBOARDING SYSTEM                 │
│                                                                 │
│  INPUT: Folder with contractor documents (Excel/PDF/Word)      │
│  OUTPUT: JSON data + SQL for Supabase + Summary report         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 DATA FLOW

```
                        ┌─────────────────────┐
                        │  Contractor Folder  │
                        │                     │
                        │  - Excel files      │
                        │  - PDF documents    │
                        │  - Word docs        │
                        └──────────┬──────────┘
                                   │
                                   ↓
                        ┌──────────────────────┐
                        │ ContractorExtractor  │
                        │                      │
                        │ - Read Excel         │
                        │ - Extract PDF text   │
                        │ - Parse Word         │
                        │ - Apply regex        │
                        └──────────┬───────────┘
                                   │
                                   ↓
                        ┌──────────────────────┐
                        │  Raw Extracted Data  │
                        │                      │
                        │ {                    │
                        │   name: "...",       │
                        │   email: "...",      │
                        │   ...                │
                        │ }                    │
                        └──────────┬───────────┘
                                   │
                                   ↓
                        ┌──────────────────────┐
                        │ ContractorValidator  │
                        │                      │
                        │ - Check name valid   │
                        │ - Filter garbage     │
                        │ - Verify format      │
                        └──────────┬───────────┘
                                   │
                                   ↓
                        ┌──────────────────────┐
                        │   Validated Data     │
                        │                      │
                        │ - Clean names        │
                        │ - Verified format    │
                        │ - Confidence score   │
                        └──────────┬───────────┘
                                   │
                                   ↓
                        ┌──────────────────────┐
                        │  SQLGenerator        │
                        │                      │
                        │ - Generate UUID      │
                        │ - Format arrays      │
                        │ - Create INSERT      │
                        └──────────┬───────────┘
                                   │
                                   ↓
              ┌────────────────────┴────────────────────┐
              │                                         │
              ↓                                         ↓
    ┌─────────────────┐                    ┌──────────────────┐
    │   JSON File     │                    │    SQL File      │
    │                 │                    │                  │
    │ contractor_     │                    │ INSERT INTO      │
    │ data.json       │                    │ suppliers ...    │
    └─────────────────┘                    └──────────────────┘
```

---

## 🔄 CONSOLIDATION FLOW (Deduplication)

```
┌────────────────────────────────────────────────────────────────┐
│                   MULTIPLE DATA SOURCES                        │
└────────────────────────────────────────────────────────────────┘
          │                    │                    │
          ↓                    ↓                    ↓
   ┌───────────┐        ┌───────────┐        ┌───────────┐
   │  Budget   │        │ Contracts │        │ Property  │
   │   Items   │        │           │        │   Bible   │
   └─────┬─────┘        └─────┬─────┘        └─────┬─────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              │
                              ↓
                  ┌───────────────────────┐
                  │ ContractorConsolidator│
                  │                       │
                  │ 1. Extract names      │
                  │ 2. Fuzzy match        │
                  │ 3. Find aliases       │
                  │ 4. Aggregate services │
                  │ 5. Sum values         │
                  └───────────┬───────────┘
                              │
                              ↓
              ┌───────────────────────────────┐
              │  Consolidated Contractors     │
              │                               │
              │  "New Step Ltd"               │
              │  - Aliases: ["New Step",      │
              │              "New Step        │
              │               Cleaning"]      │
              │  - Services: [cleaning, fm]   │
              │  - Sources: [budget,          │
              │              contract]        │
              │  - Annual: £15,000            │
              └───────────────────────────────┘
```

---

## 🧩 COMPONENT RELATIONSHIPS

```
┌─────────────────────────────────────────────────────────────┐
│                     onboard_contractor.py                   │
│                      (Main Orchestrator)                    │
│                                                             │
│  Coordinates all components in sequence:                    │
│  1. Extract  2. Validate  3. Generate  4. Report           │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ↓              ↓              ↓
┌───────────────┐ ┌─────────────┐ ┌────────────────┐
│  Extractors   │ │ Validators  │ │  Generators    │
│               │ │             │ │                │
│ - contractor_ │ │ - name_     │ │ - sql_         │
│   extractor   │ │   validator │ │   generator    │
│               │ │             │ │                │
│ - budget_     │ │             │ │                │
│   extractor   │ │             │ │                │
└───────────────┘ └─────────────┘ └────────────────┘
        │                                    │
        ↓                                    ↓
┌───────────────┐                    ┌──────────────┐
│ Consolidators │                    │   Database   │
│               │                    │              │
│ - contractor_ │                    │ - suppliers  │
│   consolidator│                    │   table      │
└───────────────┘                    │ - supplier_  │
                                     │   documents  │
                                     └──────────────┘
```

---

## 🎭 COMPONENT INTERACTIONS

### 1. Standalone Extraction

```
User Input
    │
    ↓
ContractorExtractor
    │
    ├─→ Read Excel
    ├─→ Read PDF
    ├─→ Read Word
    │
    ↓
Raw Data Dict
    │
    ↓
ContractorValidator
    │
    ↓
Validated Data
```

---

### 2. Budget Extraction

```
Budget Line Items
    │
    ├─ description: "Cleaning services"
    ├─ category: "cleaning"
    ├─ amount: 12000
    └─ notes: "Contract is with New Step"
           │
           ↓
   BudgetContractorExtractor
           │
           ↓
   Contractor Name: "New Step"
```

---

### 3. Consolidation

```
Multiple Sources          Consolidator
    │                         │
    ├─ Budget: "New Step" ────┼─→ Core name: "new step"
    │                         │
    ├─ Contract: "New Step Ltd"─┼─→ Core name: "new step"
    │                         │       ↓
    └─ Bible: "New Step      │    MATCH! (Same contractor)
         Cleaning Ltd" ───────┼─→     │
                             │       ↓
                             │   Single Record:
                             │   - Name: "New Step Ltd"
                             │   - Aliases: [...]
                             │   - Services: [...]
                             └──────────────────────────
```

---

## 🏗️ DATABASE SCHEMA ARCHITECTURE

```
┌──────────────────────────────────────────────────────────────┐
│                      SUPABASE DATABASE                       │
└──────────────────────────────────────────────────────────────┘
           │
           ├─────────────────────────────────────┐
           │                                     │
           ↓                                     ↓
┌────────────────────────┐          ┌─────────────────────────┐
│   suppliers TABLE      │          │ supplier_documents TABLE│
│                        │          │                         │
│ - id (UUID)           │ 1     ∞  │ - id (UUID)            │
│ - contractor_name     │◄─────────┤ - supplier_id (FK)     │
│ - email               │          │ - document_type        │
│ - telephone           │          │ - storage_path         │
│ - services_provided[] │          │ - expiry_date          │
│ - pli_expiry_date     │          │ - is_verified          │
│ - pli_status          │          └─────────────────────────┘
│ - onboarding_status   │
│ - is_approved         │
│ - rating              │
│ - created_at          │
│ - updated_at          │
└───────────┬───────────┘
            │
            ↓
    ┌───────────────────┐
    │     TRIGGERS      │
    │                   │
    │ - Update PLI days │
    │ - Set PLI status  │
    │ - Update timestamp│
    └───────────────────┘
            │
            ↓
    ┌───────────────────┐
    │      VIEWS        │
    │                   │
    │ - Expiring docs   │
    │ - Approved        │
    │   suppliers       │
    └───────────────────┘
```

---

## 🔁 INTEGRATION ARCHITECTURE

### Option A: Standalone Tool

```
                    User
                     │
                     ↓
              Command Line
                     │
                     ↓
        onboard_contractor.py
                     │
                     ↓
              Output Files
                     │
                     ├─→ JSON file
                     └─→ SQL file
                           │
                           ↓
                    Manual Review
                           │
                           ↓
                    Apply to DB
```

---

### Option B: Integrated with Building Onboarding

```
    Building Onboarding
            │
            ├─ Process building
            ├─ Process units
            ├─ Process leaseholders
            │
            ├─→ ContractorConsolidator
            │       │
            │       ├─ Extract from budget
            │       ├─ Extract from contracts
            │       ├─ Deduplicate
            │       │
            │       ↓
            │   Contractors List
            │       │
            └───────┼─→ Store in DB
                    │
                    ↓
             Link to Building
```

---

### Option C: API Integration

```
    Web Frontend
         │
         ↓
    POST /api/contractors/onboard
         │
         ├─ Upload files
         │
         ↓
    FastAPI Endpoint
         │
         ├─→ ContractorExtractor
         ├─→ Validator
         ├─→ SQLGenerator
         │
         ↓
    Auto-insert to DB
         │
         ↓
    Return supplier_id
         │
         ↓
    Frontend shows success
```

---

## 🔐 SECURITY ARCHITECTURE

```
┌─────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                    │
│                                                         │
│  - Input validation (all fields)                       │
│  - SQL escaping (prevent injection)                    │
│  - File type validation                                │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────┐
│                    DATABASE LAYER                       │
│                                                         │
│  - Row Level Security (RLS)                            │
│  - Role-based access (admin/manager)                   │
│  - Audit trail (created_at, updated_at)                │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────┐
│                    STORAGE LAYER                        │
│                                                         │
│  - Private bucket                                       │
│  - Signed URLs                                          │
│  - Access control policies                             │
└─────────────────────────────────────────────────────────┘
```

---

## 📈 PERFORMANCE ARCHITECTURE

```
┌───────────────────┐
│  File Reading     │  ← Optimized: Read first N rows/pages
└─────────┬─────────┘
          │
          ↓
┌───────────────────┐
│  Regex Matching   │  ← Pre-compiled patterns
└─────────┬─────────┘
          │
          ↓
┌───────────────────┐
│  Fuzzy Matching   │  ← rapidfuzz library (C++ backend)
└─────────┬─────────┘
          │
          ↓
┌───────────────────┐
│  Database Insert  │  ← Batch inserts, indexed queries
└───────────────────┘

Performance Targets:
- Small folder (5 files):  <5 seconds
- Medium folder (20 files): <20 seconds
- Fuzzy matching: <100ms per contractor
- Database insert: <200ms per record
```

---

## 🔄 ERROR HANDLING ARCHITECTURE

```
┌─────────────────────────────────────────────┐
│         GRACEFUL DEGRADATION STRATEGY       │
└─────────────────────────────────────────────┘
           │
           ├─→ File Read Error
           │   └─→ Skip file, log error, continue
           │
           ├─→ Extraction Error
           │   └─→ Set field to None, lower confidence
           │
           ├─→ Validation Error
           │   └─→ Filter out, log reason
           │
           ├─→ SQL Generation Error
           │   └─→ Save JSON only, log SQL error
           │
           └─→ Database Error
               └─→ Save SQL file, show manual steps
```

---

## 📦 DEPLOYMENT ARCHITECTURE

```
┌─────────────────────────────────────────────────────┐
│                  PRODUCTION SETUP                   │
└─────────────────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ↓                ↓                ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Application  │  │   Database   │  │   Storage    │
│              │  │              │  │              │
│ - Python 3.8+│  │ - PostgreSQL │  │ - Supabase   │
│ - Dependencies│  │ - Schema     │  │   Storage    │
│ - Code files │  │ - Indexes    │  │ - Bucket     │
└──────────────┘  └──────────────┘  └──────────────┘
        │                │                │
        └────────────────┼────────────────┘
                         │
                         ↓
                ┌─────────────────┐
                │   Monitoring    │
                │                 │
                │ - Error logs    │
                │ - Performance   │
                │ - Usage stats   │
                └─────────────────┘
```

---

## 🎯 DATA LIFECYCLE

```
1. CAPTURE
   │
   ├─ Documents uploaded/provided
   └─ Metadata captured
       │
       ↓
2. EXTRACT
   │
   ├─ Text extracted from documents
   ├─ Patterns matched with regex
   └─ Data normalized
       │
       ↓
3. VALIDATE
   │
   ├─ Names validated
   ├─ Formats checked
   └─ Confidence calculated
       │
       ↓
4. CONSOLIDATE (if multiple sources)
   │
   ├─ Fuzzy matching applied
   ├─ Aliases tracked
   └─ Data aggregated
       │
       ↓
5. STORE
   │
   ├─ SQL generated
   ├─ Records inserted
   └─ Documents linked
       │
       ↓
6. MAINTAIN
   │
   ├─ Expiry tracking
   ├─ Status updates
   └─ Performance monitoring
```

---

## 🔍 MONITORING POINTS

```
┌─────────────────────────────────────────────────────┐
│                 KEY METRICS TO TRACK                │
└─────────────────────────────────────────────────────┘

1. EXTRACTION
   └─→ Files processed per day
   └─→ Average extraction confidence
   └─→ Failed extractions (%)

2. VALIDATION
   └─→ Names filtered out (%)
   └─→ Validation pass rate

3. CONSOLIDATION
   └─→ Duplicates found and merged
   └─→ Aliases tracked per contractor

4. DATABASE
   └─→ Total contractors in system
   └─→ Approved contractors (%)
   └─→ Expiring insurance alerts

5. PERFORMANCE
   └─→ Average processing time
   └─→ Database query times
   └─→ Storage usage
```

---

## ✅ SYSTEM HEALTH CHECKS

```
Daily:
  ├─ Check expiring PLI certificates
  ├─ Review pending onboarding requests
  └─ Monitor extraction errors

Weekly:
  ├─ Review data quality metrics
  ├─ Audit duplicate contractors
  └─ Check storage usage

Monthly:
  ├─ Performance optimization
  ├─ Schema maintenance
  └─ Backup verification

Quarterly:
  ├─ Security audit
  ├─ Update service keywords
  └─ Review extraction patterns
```

---

## 🎉 SUMMARY

This system provides:

✅ **End-to-end automation** from documents to database  
✅ **Smart deduplication** with fuzzy matching  
✅ **Production-ready** error handling and validation  
✅ **Scalable architecture** supporting multiple integration patterns  
✅ **Secure by design** with RLS and access controls  
✅ **Performance optimized** with indexes and caching  
✅ **Maintainable** with clear component separation  

**Result:** Robust, reliable contractor onboarding in minutes instead of hours!

---

**END OF ARCHITECTURE GUIDE**


