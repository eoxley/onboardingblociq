-- ============================================================================
-- DELETE Pimlico Place with ID: 65e81534-9f27-4464-8f04-0d4709beb8ca
-- ============================================================================

BEGIN;

-- Delete in correct dependency order
DELETE FROM building_keys_access WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM lease_clauses WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM leases WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM insurance_policies WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM compliance_assets WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM budgets WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM maintenance_contracts WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM major_works_projects WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM unit_leaseholder_links WHERE unit_id IN (SELECT id FROM units WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca');
DELETE FROM units WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM leaseholders; -- Safe because we're deleting all units
DELETE FROM building_contractor_links WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca';
DELETE FROM buildings WHERE id = '65e81534-9f27-4464-8f04-0d4709beb8ca';

COMMIT;

-- Verify deletion
SELECT 
    'Deleted building 65e81534-9f27-4464-8f04-0d4709beb8ca' as status,
    (SELECT COUNT(*) FROM buildings WHERE id = '65e81534-9f27-4464-8f04-0d4709beb8ca') as remaining_buildings,
    (SELECT COUNT(*) FROM units WHERE building_id = '65e81534-9f27-4464-8f04-0d4709beb8ca') as remaining_units;
