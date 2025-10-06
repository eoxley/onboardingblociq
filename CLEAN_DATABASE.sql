-- Clean Database - Delete all onboarding data for re-testing
-- Run this to clear all data and start fresh

-- IMPORTANT: This will delete ALL data from these tables!
-- Make sure you have backups if needed

-- Step 1: Delete dependent records first (to avoid foreign key violations)
DELETE FROM major_works_notices;
DELETE FROM building_compliance_assets;
DELETE FROM uncategorised_docs;
DELETE FROM apportionments;
DELETE FROM major_works_projects;
DELETE FROM budgets;
DELETE FROM compliance_inspections;
DELETE FROM compliance_assets;
DELETE FROM building_documents;
DELETE FROM leaseholders;
DELETE FROM units;

-- Step 2: Delete property form structured data
DELETE FROM building_contractors;
DELETE FROM building_utilities;
DELETE FROM building_insurance;
DELETE FROM building_legal;
DELETE FROM building_statutory_reports;
DELETE FROM building_keys_access;
DELETE FROM building_warranties;
DELETE FROM company_secretary;
DELETE FROM building_staff;
DELETE FROM building_title_deeds;

-- Step 3: Delete buildings (root table)
DELETE FROM buildings;

-- Step 4: Verify everything is clean
SELECT 'buildings' as table_name, COUNT(*) as record_count FROM buildings
UNION ALL
SELECT 'units', COUNT(*) FROM units
UNION ALL
SELECT 'leaseholders', COUNT(*) FROM leaseholders
UNION ALL
SELECT 'building_documents', COUNT(*) FROM building_documents
UNION ALL
SELECT 'compliance_assets', COUNT(*) FROM compliance_assets
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'apportionments', COUNT(*) FROM apportionments
UNION ALL
SELECT 'major_works_projects', COUNT(*) FROM major_works_projects
UNION ALL
SELECT 'major_works_notices', COUNT(*) FROM major_works_notices
ORDER BY table_name;

-- All counts should be 0
