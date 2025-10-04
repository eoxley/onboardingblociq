-- ===========================================
-- FIX SCRIPT: Link all existing records to buildings
-- ===========================================

-- Fix compliance_assets: Link via building_compliance_assets junction table
UPDATE compliance_assets ca
SET building_id = bca.building_id
FROM building_compliance_assets bca
WHERE ca.id = bca.compliance_asset_id
AND ca.building_id IS NULL;

-- Fix compliance_inspections: Link via building_id if exists in table
-- (This should already be populated, but just in case)

-- Fix major_works_projects: Link via building_documents
UPDATE major_works_projects mwp
SET building_id = bd.building_id
FROM building_documents bd
WHERE mwp.document_id = bd.id
AND mwp.building_id IS NULL;

-- ===========================================
-- ORPHAN DETECTION
-- Find any records that still have NULL building_id
-- ===========================================

SELECT 'compliance_assets' as table_name, id, name
FROM compliance_assets
WHERE building_id IS NULL
UNION ALL
SELECT 'major_works_projects', id, project_name
FROM major_works_projects
WHERE building_id IS NULL
UNION ALL
SELECT 'budgets', id, period
FROM budgets
WHERE building_id IS NULL
UNION ALL
SELECT 'building_documents', id, file_name
FROM building_documents
WHERE building_id IS NULL;

-- ===========================================
-- DELETE ORPHANED RECORDS (OPTIONAL - BE CAREFUL!)
-- Only run this if you want to remove records with no building link
-- ===========================================

-- DELETE FROM compliance_assets WHERE building_id IS NULL;
-- DELETE FROM major_works_projects WHERE building_id IS NULL;
-- DELETE FROM budgets WHERE building_id IS NULL;
-- DELETE FROM building_documents WHERE building_id IS NULL;
