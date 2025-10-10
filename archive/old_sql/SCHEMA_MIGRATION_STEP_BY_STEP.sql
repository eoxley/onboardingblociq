-- SCHEMA MIGRATION: Add building_id to tables
-- RUN THIS BEFORE running the generated migration SQL
-- This adds the missing building_id columns to your database

-- =============================================================================
-- STEP 1: Check current schema (run this first to see what you have)
-- =============================================================================
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('leaseholders', 'apportionments', 'major_works_notices')
  AND table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- =============================================================================
-- STEP 2: Add building_id columns (if they don't exist)
-- =============================================================================

-- Add to leaseholders
ALTER TABLE leaseholders
ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add to apportionments
ALTER TABLE apportionments
ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add to major_works_notices
ALTER TABLE major_works_notices
ADD COLUMN IF NOT EXISTS building_id uuid;

-- =============================================================================
-- STEP 3: Backfill building_id from related tables
-- =============================================================================

-- Backfill leaseholders.building_id from units
UPDATE leaseholders
SET building_id = units.building_id
FROM units
WHERE leaseholders.unit_id = units.id
  AND leaseholders.building_id IS NULL;

-- Backfill apportionments.building_id from units
UPDATE apportionments
SET building_id = units.building_id
FROM units
WHERE apportionments.unit_id = units.id
  AND apportionments.building_id IS NULL;

-- Backfill major_works_notices.building_id from major_works_projects
UPDATE major_works_notices
SET building_id = major_works_projects.building_id
FROM major_works_projects
WHERE major_works_notices.project_id = major_works_projects.id
  AND major_works_notices.building_id IS NULL;

-- =============================================================================
-- STEP 4: Add NOT NULL constraint and foreign key
-- =============================================================================

-- Leaseholders
ALTER TABLE leaseholders
ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE leaseholders
ADD CONSTRAINT fk_leaseholders_building
FOREIGN KEY (building_id) REFERENCES buildings(id);

-- Apportionments
ALTER TABLE apportionments
ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE apportionments
ADD CONSTRAINT fk_apportionments_building
FOREIGN KEY (building_id) REFERENCES buildings(id);

-- Major works notices
ALTER TABLE major_works_notices
ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE major_works_notices
ADD CONSTRAINT fk_major_works_notices_building
FOREIGN KEY (building_id) REFERENCES buildings(id);

-- =============================================================================
-- STEP 5: Create indexes for performance
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_leaseholders_building_id
ON leaseholders(building_id);

CREATE INDEX IF NOT EXISTS idx_apportionments_building_id
ON apportionments(building_id);

CREATE INDEX IF NOT EXISTS idx_major_works_notices_building_id
ON major_works_notices(building_id);

-- =============================================================================
-- STEP 6: Verify the migration worked
-- =============================================================================

SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('leaseholders', 'apportionments', 'major_works_notices')
  AND column_name = 'building_id'
  AND table_schema = 'public'
ORDER BY table_name;

-- All three tables should show building_id as 'uuid' and 'NO' for is_nullable
