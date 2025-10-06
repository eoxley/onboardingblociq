-- Delete Connaught Square Building Data
-- Works with CURRENT database schema (without building_id on all tables)

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

        -- Delete building_compliance_assets (has building_id)
        DELETE FROM building_compliance_assets WHERE building_id = v_building_id;

        -- Delete apportionments (via units -> building_id)
        DELETE FROM apportionments
        WHERE unit_id IN (SELECT id FROM units WHERE building_id = v_building_id);

        -- Delete leaseholders (via units -> building_id)
        DELETE FROM leaseholders
        WHERE unit_id IN (SELECT id FROM units WHERE building_id = v_building_id);

        -- Delete budgets (has building_id)
        DELETE FROM budgets WHERE building_id = v_building_id;

        -- Delete compliance_assets (has building_id)
        DELETE FROM compliance_assets WHERE building_id = v_building_id;

        -- Delete major_works_projects (has building_id)
        DELETE FROM major_works_projects WHERE building_id = v_building_id;

        -- Delete building_documents (has building_id)
        DELETE FROM building_documents WHERE building_id = v_building_id;

        -- Delete units (has building_id)
        DELETE FROM units WHERE building_id = v_building_id;

        -- Delete the building
        DELETE FROM buildings WHERE id = v_building_id;

        RAISE NOTICE 'Deletion complete for Connaught Square';
    ELSE
        RAISE NOTICE 'No building found matching Connaught Square';
    END IF;
END $$;

-- Verify deletion
SELECT COUNT(*) as remaining_records
FROM buildings
WHERE name ILIKE '%connaught%' OR address ILIKE '%connaught%';
