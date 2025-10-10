-- Delete Connaught Square Building Data
-- This will delete the specific building and all related data

-- Step 1: Find the building ID for Connaught Square
-- (Uncomment to check first)
-- SELECT id, name, address FROM buildings WHERE name ILIKE '%connaught%' OR address ILIKE '%connaught%';

-- Step 2: Delete all related data for Connaught Square building
-- Replace 'YOUR-BUILDING-ID-HERE' with the actual UUID if you know it
-- Or use the WHERE clause to match by name

DO $$
DECLARE
    v_building_id uuid;
BEGIN
    -- Get the building ID
    SELECT id INTO v_building_id
    FROM buildings
    WHERE name ILIKE '%connaught%'
       OR address ILIKE '%connaught%'
    LIMIT 1;

    IF v_building_id IS NOT NULL THEN
        RAISE NOTICE 'Deleting data for building: %', v_building_id;

        -- Delete in order (child tables first)
        DELETE FROM building_compliance_assets WHERE building_id = v_building_id;
        DELETE FROM apportionments WHERE building_id = v_building_id;
        DELETE FROM budgets WHERE building_id = v_building_id;
        DELETE FROM compliance_assets WHERE building_id = v_building_id;
        DELETE FROM major_works_projects WHERE building_id = v_building_id;
        DELETE FROM building_documents WHERE building_id = v_building_id;
        DELETE FROM leaseholders WHERE building_id = v_building_id;
        DELETE FROM units WHERE building_id = v_building_id;
        DELETE FROM buildings WHERE id = v_building_id;

        RAISE NOTICE 'Deletion complete for Connaught Square';
    ELSE
        RAISE NOTICE 'No building found matching Connaught Square';
    END IF;
END $$;

-- Verify deletion
SELECT
    'buildings' as table_name,
    COUNT(*) as remaining_records
FROM buildings
WHERE name ILIKE '%connaught%' OR address ILIKE '%connaught%';
