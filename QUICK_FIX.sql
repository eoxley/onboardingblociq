-- ===========================================
-- QUICK FIX: Just delete everything and start fresh
-- ===========================================

-- Option 1: Delete all buildings (cascades to everything)
DELETE FROM buildings;

-- Now run the full migration
-- The NOT NULL constraint will work fine with no data

-- ===========================================
-- OR if you want to keep data:
-- ===========================================

-- Step 1: Add building_id as NULLABLE first
ALTER TABLE compliance_assets DROP COLUMN IF EXISTS building_id;
ALTER TABLE compliance_assets ADD COLUMN building_id UUID REFERENCES buildings(id);
CREATE INDEX idx_compliance_assets_building_id ON compliance_assets(building_id);

-- Step 2: Populate building_id from building_compliance_assets junction table
UPDATE compliance_assets ca
SET building_id = bca.building_id
FROM building_compliance_assets bca
WHERE ca.id = bca.compliance_asset_id
AND ca.building_id IS NULL;

-- Step 3: Delete orphaned records (compliance_assets with no building link)
DELETE FROM compliance_assets WHERE building_id IS NULL;

-- Step 4: Make it NOT NULL now that all records are linked
ALTER TABLE compliance_assets ALTER COLUMN building_id SET NOT NULL;
