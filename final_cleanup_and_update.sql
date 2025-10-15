-- ============================================================================
-- FINAL CLEANUP: Keep complete building, delete duplicate, add contractors
-- ============================================================================

BEGIN;

-- Delete the newest building (less complete data but has contractors)
-- ID: 39d99eea-3d9d-4a9a-a946-8a61f3b9228c
DELETE FROM budget_line_items WHERE budget_id IN (SELECT id FROM budgets WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c');
DELETE FROM budgets WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM insurance_policies WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM major_works_projects WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM compliance_assets WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM leases WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM contractors WHERE id IN (
    SELECT id FROM contractors 
    WHERE created_at > (SELECT created_at FROM buildings WHERE id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c')
);
DELETE FROM leaseholders WHERE unit_id IN (SELECT id FROM units WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c');
DELETE FROM units WHERE building_id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';
DELETE FROM buildings WHERE id = '39d99eea-3d9d-4a9a-a946-8a61f3b9228c';

-- Update the complete building with contractor names
-- ID: 7883fde1-fec2-4ad4-a5d8-f583c12a49c0
UPDATE buildings 
SET 
    cleaning_contractor = 'New Step',
    lift_contractor = 'Jacksons Lift',
    heating_contractor = 'Quotehedge'
WHERE id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

COMMIT;

-- Verify
SELECT 
    id,
    building_name,
    cleaning_contractor,
    lift_contractor,
    heating_contractor,
    num_units
FROM buildings 
WHERE building_name LIKE '%Connaught%';

