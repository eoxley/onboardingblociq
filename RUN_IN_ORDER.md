# Run These Scripts In Order

## Step 1: Run the Migration (Adds all new columns and tables)
**File**: `SUPABASE_MIGRATION.sql`

This adds:
- All new columns to `buildings` table
- `building_id` column to `compliance_assets` ⚠️ **CRITICAL**
- All new columns to `budgets` table
- All 10 new tables

## Step 2: Fix Existing Data (Links old records to buildings)
**File**: `FIX_BUILDING_LINKS.sql`

This links existing records to buildings.

## Step 3: Verify Everything (Check all tables)
**File**: `VERIFY_BUILDING_LINKS.sql`

This verifies all tables are properly linked.

---

## OR Just Do This (Recommended):

1. Run `SUPABASE_MIGRATION.sql`
2. Delete your test building: `DELETE FROM buildings WHERE id = 'your-uuid';`
3. Re-run the onboarder from scratch

This avoids any data migration issues! 🚀
