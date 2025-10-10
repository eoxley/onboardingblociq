# 🚨 URGENT: Get Your Actual Supabase Schema

## Why This is Critical

I've fixed **3 schema errors** so far:
1. ❌ `role` column doesn't exist → ✅ Removed
2. ❌ `period` column NULL violation → ✅ Added with default
3. ❌ `insurance_type` column NULL violation → ✅ Added with default

But I'm **fixing blindly** without seeing your actual schema. To rebuild the SQL generator and PDF system properly, I need your complete schema.

## 🎯 What I Need

Run this SQL in your Supabase SQL Editor and share the **complete output** with me:

```sql
-- Get schema for all our tables
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN (
    'buildings',
    'units',
    'leaseholders',
    'budgets',
    'building_insurance', 
    'building_staff',
    'fire_door_inspections',
    'leases',
    'compliance_assets',
    'contractors',
    'contracts',
    'major_works_projects',
    'portfolios',
    'agencies'
)
ORDER BY table_name, ordinal_position;
```

## 📋 How to Do This

### Step 1: Open Supabase SQL Editor
1. Go to: https://supabase.com/dashboard
2. Select your project
3. Click "SQL Editor" in left sidebar
4. Click "New Query"

### Step 2: Run the Query
1. Copy the SQL above
2. Paste into the editor
3. Click "Run" (or press Cmd+Enter)

### Step 3: Export Results
1. Click "Download as CSV" or copy the results
2. Share with me either:
   - Paste the table output here
   - Or screenshot the results
   - Or save as CSV and share

## 🎁 What You'll Get

Once I have your schema, I will:

### ✅ SQL Generator Rebuild
- Match your EXACT Supabase schema (no more errors!)
- Add all missing columns:
  - `postcode`, `year_built`, `building_type` to buildings
  - `cover_type`, `insured_parties` to building_insurance
  - All NOT NULL columns with proper defaults
- Generate proper INSERT statements with all required fields
- Add intelligence metrics tables

### ✅ PDF Generator Rebuild  
- **Professional BlocIQ branding** from your Brandkit
- **Client-ready layout** with purple gradient, logo, professional fonts
- **Visual analytics**: charts, graphs, thermometer scores
- **Category breakdown**: Fire/Electrical/Water/General scores
- **Intelligence insights**: not just data dumps
- **Actionable recommendations**: AI-generated action items
- **Concise format**: 6 pages max, no N/A spam

### ✅ Complete Data Model
All fields from your specification:
- Building metadata (postcode, year_built, floors, etc.)
- Units & leaseholders (term dates, ground rent, occupancy)
- Budgets & finance (arrears, reserve fund, category breakdown)
- Contractors (retender dates, contact info)
- Compliance (deduped, scored by category)
- Insurance (cover type, insured parties, sum insured)
- Major works (costs, timelines, funding plans)
- Intelligence metrics (scores, risks, confidence index)

## 🚀 Quick Alternative

If you don't want to run SQL, you can also share:
1. Screenshot of your Supabase "Table Editor" showing column names for each table
2. Or export your database schema from Supabase Dashboard → Database → Schema

## Current Status

**Fixed so far:** 3 schema errors (role, period, insurance_type)
**Remaining:** Unknown - need your schema to find them all
**Next:** Complete rebuild once I have your schema

⏱️ **This will save hours** of back-and-forth fixing one error at a time!

Let me see your schema and I'll rebuild everything perfectly in one go. 🎯
