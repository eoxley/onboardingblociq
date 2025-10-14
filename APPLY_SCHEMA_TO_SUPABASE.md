# Apply Schema to Supabase - Step-by-Step Guide

**Date:** October 14, 2025  
**Schema File:** `supabase_schema.sql` (1,153 lines)  
**Database:** Supabase (xqxaatvykmaaynqeoemy)

---

## 🎯 What This Does

Applies the **complete BlocIQ schema** to your Supabase database including:
- ✅ Multi-tenancy (agencies, users, user_buildings)
- ✅ Buildings & units
- ✅ Leaseholders & leases
- ✅ Compliance assets (50+ types)
- ✅ Maintenance contracts & schedules
- ✅ Budgets & budget line items (52 items!)
- ✅ Insurance policies
- ✅ Contractors & major works
- ✅ Documents & extraction runs
- ✅ Row-level security policies

---

## 📋 Prerequisites

Before running, ensure:
1. ✅ You have Supabase dashboard access
2. ✅ Project ID: `xqxaatvykmaaynqeoemy`
3. ✅ Database is empty OR you're okay with adding new tables
4. ⚠️ **BACKUP FIRST** if you have existing data

---

## 🚀 Method 1: Supabase SQL Editor (RECOMMENDED)

### Step 1: Open SQL Editor
Go to: https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new

### Step 2: Copy Schema
```bash
# On your Mac, copy the schema file
cat /Users/ellie/onboardingblociq/supabase_schema.sql | pbcopy
```

Or manually open: `/Users/ellie/onboardingblociq/supabase_schema.sql`

### Step 3: Paste & Run
1. Paste into SQL Editor
2. Click **"Run"** (bottom right)
3. Wait ~10-15 seconds

### Step 4: Verify Success
You should see:
```
Success. No rows returned
```

### Step 5: Verify Tables Created
Go to: Table Editor
You should now see 19 tables:
- agencies
- users
- user_buildings
- buildings
- building_blocks
- units
- leaseholders
- compliance_asset_types
- compliance_assets
- contract_types
- maintenance_contracts
- budgets
- budget_line_items
- maintenance_schedules
- contractors
- leases
- major_works_projects
- leaseholder_accounts
- insurance_policies
- documents
- extraction_runs
- audit_log

---

## 🚀 Method 2: Command Line (ALTERNATIVE)

If you have the correct Supabase connection string:

```bash
# Set connection string
export DATABASE_URL="your-supabase-connection-pooler-url"

# Apply schema
psql $DATABASE_URL < /Users/ellie/onboardingblociq/supabase_schema.sql
```

**Note:** Free tier may not allow direct psql connections. Use Method 1 instead.

---

## ✅ Verification Queries

After applying schema, run these in SQL Editor to verify:

```sql
-- Check all tables created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check compliance_asset_types populated
SELECT COUNT(*) FROM compliance_asset_types;
-- Expected: 50+ types

-- Check contract_types populated  
SELECT COUNT(*) FROM contract_types;
-- Expected: 20+ types

-- Check RLS enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND rowsecurity = true;
-- Expected: 8 tables with RLS enabled
```

---

## ⚠️ Troubleshooting

### "relation already exists"
**Cause:** Tables already exist  
**Solution:** Either:
- Drop existing tables first: `DROP TABLE IF EXISTS buildings CASCADE;`
- Or skip this step if schema already applied

### "extension uuid-ossp does not exist"
**Cause:** UUID extension not available  
**Solution:** Change line 11:
```sql
CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- Use pgcrypto instead
```

### "permission denied"
**Cause:** Insufficient database permissions  
**Solution:** Ensure you're using the service role key or owner account

---

## 📊 What Gets Created

| Category | Tables | Reference Data |
|----------|--------|----------------|
| Multi-Tenancy | 3 | - |
| Core Entities | 4 | - |
| Compliance | 2 | 50+ asset types |
| Contracts | 4 | 20+ contract types |
| Financial | 3 | - |
| Legal & Works | 2 | - |
| System | 3 | - |
| **TOTAL** | **21 tables** | **70+ reference records** |

---

## 🎉 After Schema Applied

You're ready to:
1. ✅ Load Connaught Square data
2. ✅ Set up agencies and users
3. ✅ Assign buildings to property managers
4. ✅ Start using the system

---

**Next:** Generate fresh Connaught SQL with ALL 14 data types!

