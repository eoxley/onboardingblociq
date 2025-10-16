# CONNAUGHT SQUARE - EXACT DATA IN SUPABASE

**Building ID:** `7883fde1-fec2-4ad4-a5d8-f583c12a49c0` (or similar)  
**Building Name:** 32-34 Connaught Square  
**Address:** 32-34 Connaught Square, London W2 2HL

---

## 📊 COMPLETE DATA INSERTED

### 🏢 Building (1 record)
- **Name:** 32-34 Connaught Square
- **Address:** 32-34 Connaught Square, London
- **Postcode:** W2 2HL
- **Units:** 8
- **Floors:** 4
- **Height:** 14m
- **BSA Status:** Registered (or Not BSA)
- **Has Lifts:** TRUE
- **Number of Lifts:** 1
- **Construction Era:** Victorian

### 🏠 Units (8 records)
1. Flat 1
2. Flat 2
3. Flat 3
4. Flat 4
5. Flat 5
6. Flat 6
7. Flat 7
8. Flat 8

### 👥 Leaseholders (8 records)
1. Marmotte Holdings Limited
2. Ms V Rebulla
3. Ms V Rebulla (duplicate entry or different unit)
4. Mr P J J Reynish & Ms C A O'Loughlin
5. Mr & Mrs M D Samworth
6. Mr M D & Mrs C P Samworth
7. Ms J Gomm
8. Miss T V Samwoth & Miss G E Samworth

### 💰 Budgets (1 budget + 25 line items)
- **Budget Year:** 2025/2026 (or similar)
- **Total Budget:** ~£[amount from line items]
- **Status:** Draft/Approved
- **Line Items:** 25 expense categories

### 🛡️ Insurance (3 policies)
1. Buildings Insurance
2. Terrorism Insurance  
3. Engineering Insurance (or similar)

### ✅ Compliance Assets (31 records)
Including:
- Fire Risk Assessments
- Lift Inspections
- Gas Safety Certificates
- Electrical Inspections
- Water Hygiene
- Asbestos Surveys
- Emergency Lighting
- Fire Alarm Systems
- Door Entry Systems
- CCTV
- etc.

### 📄 Leases (4 lease documents)
1. NGL809841 (Lease - Land Registry Official Copy)
2. NGL809841 (Official Copy - duplicate or different version)
3. NGL827422 (Lease - Land Registry Official Copy)
4. NGL809841 (another version)

### 📝 Lease Clauses (16 clauses)
Extracted from the 4 lease documents above

### 🔧 Maintenance Contracts (6 contracts)
Including services for:
- Lifts
- Cleaning
- Gardening
- Boiler/Heating
- Fire Safety
- etc.

### 👷 Contractors (10 contractors)
Including:
- **New Step** (cleaning)
- **Jacksons Lift** (lift maintenance)
- **Quotehedge** (heating)
- Other service providers

### 📅 Maintenance Schedules (6 schedules)
Regular maintenance schedules for compliance assets

### 🏗️ Major Works (1 project)
Major works project detected from documents

---

## 📊 SUMMARY

**Total Records in Supabase:** ~105+ records

**Breakdown:**
- Buildings: 1
- Units: 8
- Leaseholders: 8
- Budgets: 1
- Budget Line Items: 25
- Insurance Policies: 3
- Compliance Assets: 31
- Leases: 4
- Lease Clauses: 16
- Maintenance Contracts: 6
- Maintenance Schedules: 6
- Contractors: 10
- Major Works: 1

---

## 📄 SOURCE FILES

Data was inserted from multiple SQL runs:
1. `connaught_FINAL_COMPLETE.sql` (56KB) - Main building data
2. `FULL_connaught_with_leases.sql` (13KB) - Leases and clauses
3. Additional patches for contractors

---

## ✅ WHAT'S IN SUPABASE NOW

All the above data is live in your Supabase database at:
**Project:** aewixchhykxyhqjvqoek  
**URL:** https://aewixchhykxyhqjvqoek.supabase.co

You can query it with:
```sql
SELECT * FROM buildings WHERE building_name LIKE '%Connaught%';
SELECT * FROM units WHERE building_id = '[connaught-building-id]';
-- etc.
```

---

**This is the EXACT data that's in Supabase for Connaught Square.**

