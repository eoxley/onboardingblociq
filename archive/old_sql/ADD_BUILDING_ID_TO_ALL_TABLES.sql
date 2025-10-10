-- Migration: Add building_id to all tables for direct building linkage
-- This ensures ALL data in the system can be filtered/queried by building_id

-- Step 1: Add building_id columns as NULLABLE first
ALTER TABLE leaseholders
ADD COLUMN IF NOT EXISTS building_id uuid REFERENCES buildings(id);

ALTER TABLE apportionments
ADD COLUMN IF NOT EXISTS building_id uuid REFERENCES buildings(id);

ALTER TABLE major_works_notices
ADD COLUMN IF NOT EXISTS building_id uuid REFERENCES buildings(id);

-- Step 2: Backfill building_id from related tables
-- Leaseholders: get building_id from units table
UPDATE leaseholders
SET building_id = units.building_id
FROM units
WHERE leaseholders.unit_id = units.id
AND leaseholders.building_id IS NULL;

-- Apportionments: get building_id from units table
UPDATE apportionments
SET building_id = units.building_id
FROM units
WHERE apportionments.unit_id = units.id
AND apportionments.building_id IS NULL;

-- Major works notices: get building_id from major_works_projects table
UPDATE major_works_notices
SET building_id = major_works_projects.building_id
FROM major_works_projects
WHERE major_works_notices.project_id = major_works_projects.id
AND major_works_notices.building_id IS NULL;

-- Step 3: Make building_id NOT NULL after backfill
ALTER TABLE leaseholders
ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE apportionments
ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE major_works_notices
ALTER COLUMN building_id SET NOT NULL;

-- Step 4: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_leaseholders_building_id ON leaseholders(building_id);
CREATE INDEX IF NOT EXISTS idx_apportionments_building_id ON apportionments(building_id);
CREATE INDEX IF NOT EXISTS idx_major_works_notices_building_id ON major_works_notices(building_id);

-- Step 5: Verify all tables now have building_id (should return ALL core tables)
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM
    information_schema.columns
WHERE
    column_name = 'building_id'
    AND table_schema = 'public'
ORDER BY
    table_name;
