-- ============================================================================
-- CLEANUP DUPLICATE CONNAUGHT SQUARE BUILDINGS
-- ============================================================================
-- 
-- SITUATION: 3 buildings with same name, none has complete data
-- 
-- OPTION 1: Delete all 3 and start fresh with complete data
-- OPTION 2: Keep building #1 (has contractors) and migrate lease clauses
-- 
-- RECOMMENDED: OPTION 1 - Clean slate with complete data
-- ============================================================================

BEGIN;

-- ============================================================================
-- OPTION 1: DELETE ALL THREE BUILDINGS (RECOMMENDED)
-- ============================================================================
-- This deletes all buildings and related data
-- Then you can reload with one complete, fresh SQL file

-- Building #3 (oldest - eaa40525...)
DELETE FROM compliance_assets WHERE building_id = 'eaa40525-99f5-450f-ae63-c5e8fad09b23';
DELETE FROM units WHERE building_id = 'eaa40525-99f5-450f-ae63-c5e8fad09b23';
DELETE FROM buildings WHERE id = 'eaa40525-99f5-450f-ae63-c5e8fad09b23';

-- Building #2 (middle - 2667e33e...)
DELETE FROM lease_clauses WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707';
DELETE FROM lease_parties WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707');
DELETE FROM lease_financial_terms WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707');
DELETE FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707';
DELETE FROM buildings WHERE id = '2667e33e-b493-499f-ae8d-2de07b7bb707';

-- Building #1 (newest - aa439d22...)
DELETE FROM budget_line_items WHERE budget_id IN (SELECT id FROM budgets WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b');
DELETE FROM budgets WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM insurance_policies WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM major_works_projects WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM compliance_assets WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM leases WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM leaseholders WHERE unit_id IN (SELECT id FROM units WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b');
DELETE FROM units WHERE building_id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';
DELETE FROM buildings WHERE id = 'aa439d22-a7e2-42b8-bfcd-7a113f17a00b';

COMMIT;

-- ============================================================================
-- VERIFICATION
-- ============================================================================
SELECT 
    'Buildings deleted' as status,
    COUNT(*) as remaining_connaught_buildings
FROM buildings 
WHERE building_name LIKE '%Connaught%';

-- ============================================================================
-- NEXT STEPS AFTER CLEANUP:
-- ============================================================================
-- 
-- 1. Run this cleanup: 
--    python3 apply_with_new_credentials.py cleanup_duplicates.sql
-- 
-- 2. Generate complete fresh SQL from best JSON:
--    python3 sql_generator_v2.py output/connaught_square_production_final.json -o output/connaught_COMPLETE_FRESH.sql
-- 
-- 3. Apply the complete data:
--    python3 apply_with_new_credentials.py output/connaught_COMPLETE_FRESH.sql
-- 
-- This will give you ONE building with ALL data + contractor names!
-- ============================================================================

