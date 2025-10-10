-- Fix compliance_assets table - remove duplicate/conflicting columns
-- Keep ONLY the V2 schema columns

-- Drop old columns that conflict with new schema
ALTER TABLE compliance_assets
    DROP COLUMN IF EXISTS name CASCADE,
    DROP COLUMN IF EXISTS frequency CASCADE;

-- Ensure description is nullable (it was nullable in the schema you showed)
ALTER TABLE compliance_assets
    ALTER COLUMN description DROP NOT NULL;

-- Ensure inspection_frequency is nullable (it is in the V2 schema)
ALTER TABLE compliance_assets
    ALTER COLUMN inspection_frequency DROP NOT NULL;

-- Verify final schema - should only have: id, building_id, asset_name, asset_type, inspection_frequency, description
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'compliance_assets'
ORDER BY ordinal_position;
