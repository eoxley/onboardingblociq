-- ===========================================
-- VERIFICATION SCRIPT: All tables linked to buildings
-- ===========================================

-- Check if compliance_assets has building_id (critical fix)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'compliance_assets'
        AND column_name = 'building_id'
    ) THEN
        ALTER TABLE compliance_assets ADD COLUMN building_id UUID NOT NULL REFERENCES buildings(id);
        CREATE INDEX idx_compliance_assets_building_id ON compliance_assets(building_id);
        RAISE NOTICE 'Added building_id to compliance_assets';
    ELSE
        RAISE NOTICE 'compliance_assets.building_id already exists';
    END IF;
END $$;

-- Check if major_works_projects has building_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'major_works_projects'
        AND column_name = 'building_id'
    ) THEN
        ALTER TABLE major_works_projects ADD COLUMN building_id UUID REFERENCES buildings(id);
        CREATE INDEX idx_major_works_projects_building_id ON major_works_projects(building_id);
        RAISE NOTICE 'Added building_id to major_works_projects';
    ELSE
        RAISE NOTICE 'major_works_projects.building_id already exists';
    END IF;
END $$;

-- Check if compliance_inspections has building_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'compliance_inspections'
        AND column_name = 'building_id'
    ) THEN
        ALTER TABLE compliance_inspections ADD COLUMN building_id UUID REFERENCES buildings(id);
        CREATE INDEX idx_compliance_inspections_building_id ON compliance_inspections(building_id);
        RAISE NOTICE 'Added building_id to compliance_inspections';
    ELSE
        RAISE NOTICE 'compliance_inspections.building_id already exists';
    END IF;
END $$;

-- ===========================================
-- VERIFICATION QUERIES
-- Run these to check all tables link to buildings
-- ===========================================

-- List all tables and whether they have building_id
SELECT
    table_name,
    CASE
        WHEN EXISTS (
            SELECT 1 FROM information_schema.columns c2
            WHERE c2.table_name = c.table_name
            AND c2.column_name = 'building_id'
        ) THEN '✓ Has building_id'
        WHEN table_name IN ('leaseholders') THEN '✓ Via unit_id'
        WHEN table_name IN ('apportionments') THEN '✓ Via unit_id + budget_id'
        WHEN table_name IN ('major_works_notices') THEN '✓ Via project_id'
        ELSE '✗ NO LINK'
    END as building_link_status
FROM information_schema.columns c
WHERE table_schema = 'public'
AND table_name IN (
    'buildings',
    'units',
    'leaseholders',
    'building_documents',
    'compliance_assets',
    'compliance_inspections',
    'major_works_projects',
    'budgets',
    'apportionments',
    'major_works_notices',
    'building_compliance_assets',
    'uncategorised_docs',
    'building_contractors',
    'building_utilities',
    'building_insurance',
    'building_legal',
    'building_statutory_reports',
    'building_keys_access',
    'building_warranties',
    'company_secretary',
    'building_staff',
    'building_title_deeds'
)
GROUP BY table_name
ORDER BY table_name;

-- Count records per table that have NULL building_id
SELECT 'buildings' as table_name, COUNT(*) as total_records, 0 as null_building_ids FROM buildings
UNION ALL
SELECT 'units', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM units
UNION ALL
SELECT 'building_documents', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM building_documents
UNION ALL
SELECT 'compliance_assets', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM compliance_assets
UNION ALL
SELECT 'compliance_inspections', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM compliance_inspections
UNION ALL
SELECT 'major_works_projects', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM major_works_projects
UNION ALL
SELECT 'budgets', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM budgets
UNION ALL
SELECT 'building_compliance_assets', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM building_compliance_assets
UNION ALL
SELECT 'uncategorised_docs', COUNT(*), COUNT(*) FILTER (WHERE building_id IS NULL) FROM uncategorised_docs;
