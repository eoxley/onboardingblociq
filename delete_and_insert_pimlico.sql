-- ============================================================================
-- STEP 1: Delete ALL Pimlico Place data
-- ============================================================================

BEGIN;

-- Delete in correct order (children first, then parent)
DELETE FROM building_keys_access WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM lease_clauses WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM leases WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM insurance_policies WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM compliance_assets WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM budgets WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM leaseholders WHERE id IN (SELECT leaseholder_id FROM unit_leaseholder_links WHERE unit_id IN (SELECT id FROM units WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place')));
DELETE FROM unit_leaseholder_links WHERE unit_id IN (SELECT id FROM units WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place'));
DELETE FROM units WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM contractors WHERE id IN (SELECT contractor_id FROM building_contractor_links WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place'));
DELETE FROM building_contractor_links WHERE building_id IN (SELECT id FROM buildings WHERE building_name = 'Pimlico Place');
DELETE FROM buildings WHERE building_name = 'Pimlico Place';

COMMIT;

-- Verify deletion
SELECT 'Deleted successfully - ready for fresh insert' as status;
