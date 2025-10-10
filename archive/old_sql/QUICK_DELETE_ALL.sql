-- Quick Delete All Data - Single Script
-- Copy and paste this entire script into Supabase SQL Editor and run

-- Delete in order (respects foreign keys)
-- Only delete from core tables that exist
DELETE FROM building_compliance_assets WHERE true;
DELETE FROM apportionments WHERE true;
DELETE FROM budgets WHERE true;
DELETE FROM compliance_assets WHERE true;
DELETE FROM major_works_projects WHERE true;
DELETE FROM building_documents WHERE true;
DELETE FROM leaseholders WHERE true;
DELETE FROM units WHERE true;
DELETE FROM buildings WHERE true;

-- Verify clean (should all show 0)
SELECT
    'buildings' as table_name, COUNT(*) as count FROM buildings
UNION ALL SELECT 'units', COUNT(*) FROM units
UNION ALL SELECT 'leaseholders', COUNT(*) FROM leaseholders
UNION ALL SELECT 'apportionments', COUNT(*) FROM apportionments
UNION ALL SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL SELECT 'building_documents', COUNT(*) FROM building_documents;
