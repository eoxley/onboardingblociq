# Run Pimlico Place SQL - Simple Guide

## ⚠️ Terminal Connection Blocked
Supabase blocks automated connections. Must use UI.

---

## 🎯 What to Run

**19 files total** (too many!)

**BETTER OPTION: Use the combined file**

---

## ✅ SIMPLE 2-STEP PROCESS

### Step 1: Delete Old Pimlico

**In Supabase SQL Editor:**
1. Go to: https://aewixchhykxyhqjvqoek.supabase.co
2. Click **SQL Editor** → **New query**
3. Copy/paste this:

```sql
DELETE FROM buildings WHERE id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
```

4. Click **RUN**
5. Should complete instantly

---

### Step 2: Insert New Pimlico (SPLIT INTO PARTS)

The complete SQL is 871KB - **too large for Supabase UI.**

**You have 2 options:**

#### Option A: Run 18 small files (PIMLICO_PART01.sql through PIMLICO_PART18.sql)
- Each file is 30-75KB
- Run them in order: 01, 02, 03, ..., 18
- Copy/paste each one into Supabase SQL Editor
- Takes 5-10 minutes total

#### Option B: Run via Supabase CLI (if installed)
```bash
supabase db push --file PIMLICO_SCHEMA_CORRECT.sql
```

---

## 📊 What Will Be Inserted

**Building:** Pimlico Place  
**Building ID:** cd83b608-ee5a-4bcc-b02d-0bc65a477829

**Data:**
- 1 building
- 83 units
- 82 leaseholders
- 197 budgets
- 81 compliance assets
- 71 insurance policies
- 265 leases
- 1,558 lease clauses

---

## 🚫 Why Terminal Won't Work

Supabase blocks:
- ❌ Port 6543 (connection pooler)
- ❌ Port 5432 (direct database)
- ❌ Automated psycopg2 connections

This is a Supabase free tier security restriction.

---

## ✅ Recommended Approach

**Use the 18 part files:**

Files are in: `/Users/ellie/onboardingblociq/`

```
PIMLICO_PART01.sql  →  Building, Units
PIMLICO_PART02.sql  →  Leaseholders
PIMLICO_PART03.sql  →  Insurance
PIMLICO_PART04.sql  →  Compliance
PIMLICO_PART05.sql  →  Budgets (part 1)
PIMLICO_PART06.sql  →  Budgets (part 2)
PIMLICO_PART07.sql  →  Leases
PIMLICO_PART08-18.sql  →  Lease Clauses
```

**Run each in Supabase SQL Editor in order.**

---

## 🎯 After Running

Tell me "done" and I'll:
1. Generate the PDF report
2. Show you all the data
3. Verify everything is correct

---

**Sorry for the connection issues - Supabase doesn't allow automated access on free tier.** 🔒

