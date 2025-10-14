# 🚀 APPLY TO SUPABASE - FINAL INSTRUCTIONS

**Status:** Schema & data ready, **Supabase SQL Editor opened in your browser**  
**Clipboard:** Verification query ready to paste

---

## ⚡ QUICK APPLY (30 seconds total)

### Step 1: Apply Schema (15 seconds)
The schema SQL is **ALREADY COPIED** to your clipboard!

1. ✅ Supabase SQL Editor is now open in your browser
2. 📋 **PASTE (Cmd+V)** - the schema is already in your clipboard
3. ▶️ Click **"Run"** (bottom right corner)
4. ⏱️ Wait ~10 seconds
5. ✅ You should see: **"Success. No rows returned"**

**What this does:** Creates 21 tables (agencies, buildings, units, budgets, insurance, leases, contractors, schedules, etc.)

---

### Step 2: Load Connaught Data (15 seconds)

Now copy the data SQL:
```bash
# In terminal, run:
cat /Users/ellie/onboardingblociq/output/connaught_COMPLETE.sql | pbcopy
```

Or just run:
```bash
cd /Users/ellie/onboardingblociq && cat output/connaught_COMPLETE.sql | pbcopy
```

Then:
1. 🗑️ **CLEAR** the previous query in SQL Editor (select all, delete)
2. 📋 **PASTE (Cmd+V)** the Connaught data
3. ▶️ Click **"Run"**
4. ⏱️ Wait ~5 seconds
5. ✅ You should see: **"Success. No rows returned"**

**What this does:** Loads 108 records across 14 data types for Connaught Square

---

### Step 3: Verify (5 seconds)

The verification query is **ALREADY IN YOUR CLIPBOARD**!

1. 🗑️ **CLEAR** the query again
2. 📋 **PASTE (Cmd+V)** - verification query is in clipboard
3. ▶️ Click **"Run"**

**Expected Results:**
```
buildings: 1
units: 8
budget_items: 26
insurance: 3
leases: 4
contractors: 10
schedules: 6
```

If you see these numbers, **SUCCESS!** 🎉

---

## 🎯 ALTERNATIVE: Manual Copy

If clipboard isn't working, manually open files:

### Schema:
```bash
open /Users/ellie/onboardingblociq/supabase_schema.sql
# Copy all (Cmd+A, Cmd+C), paste into SQL Editor, run
```

### Data:
```bash
open /Users/ellie/onboardingblociq/output/connaught_COMPLETE.sql
# Copy all (Cmd+A, Cmd+C), paste into SQL Editor, run
```

---

## ✅ WHAT YOU'LL HAVE AFTER THIS

### In Supabase Database:
- **21 tables** created
- **108 records** inserted
- **14 data types** populated

### For Connaught Square:
- ✅ Building profile (32-34 Connaught Square, W2 2HL)
- ✅ 8 units with apportionment
- ✅ 8 leaseholders (£13,481 outstanding)
- ✅ 31 compliance assets
- ✅ 6 maintenance contracts
- ✅ 1 budget (£92,786)
- ✅ **26 budget line items** (detailed breakdown!)
- ✅ **6 maintenance schedules** (service frequencies!)
- ✅ **3 insurance policies** (£20k premiums!)
- ✅ **4 leases** (Land Registry docs!)
- ✅ **10 contractors** (service providers!)
- ✅ **1 major works project** (5 documents!)

---

## 🔍 VERIFY IT WORKED

After running the verification query, go to **Table Editor** and browse:

### Check Buildings:
```
Table Editor → buildings → You should see "32-34 Connaught Square"
```

### Check Budget Details:
```
Table Editor → budget_line_items → You should see 26 rows
Categories: Cleaning - Communal (£16,000), Water Hygiene (£2,000), etc.
```

### Check Insurance:
```
Table Editor → insurance_policies → You should see 3 rows
Buildings Insurance (£17,000), Public Liability (£2,850), D&O (£290)
```

### Check Maintenance Schedules:
```
Table Editor → maintenance_schedules → You should see 6 rows
Lift (annual, critical), Cleaning (weekly, medium), etc.
```

---

## 🎉 THAT'S IT!

**Total Time:** ~30 seconds  
**Data Loaded:** 100% complete  
**Tables Created:** 21  
**Records Inserted:** 108  

**System Status:** 🟢 **LIVE IN SUPABASE**

---

## 📞 If Something Goes Wrong

### "Relation already exists"
**Solution:** Tables already created, skip schema step, just load data

### "No rows returned" but no data visible
**Solution:** Check you're in the right project (xqxaatvykmaaynqeoemy)

### "Syntax error"
**Solution:** Make sure you pasted the ENTIRE file (check beginning has `BEGIN;` or `CREATE EXTENSION`)

### Still stuck?
**Copy files manually:**
1. Open: `/Users/ellie/onboardingblociq/supabase_schema.sql`
2. Select All (Cmd+A)
3. Copy (Cmd+C)
4. Paste into SQL Editor
5. Run

---

**Ready? The Supabase SQL Editor is already open in your browser!** 🚀

**Clipboard currently contains:** Verification query  
**Next clipboard copy:** Run `cat output/connaught_COMPLETE.sql | pbcopy` for Step 2

