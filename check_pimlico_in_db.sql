-- Check what Pimlico Place data exists in your Supabase
-- Run this in Supabase SQL Editor to see what's there

-- 1. Check buildings
SELECT 
    id,
    building_name,
    num_units,
    city
FROM buildings 
WHERE building_name LIKE '%Pimlico%'
ORDER BY created_at DESC;

-- 2. Count units for Pimlico
SELECT 
    b.building_name,
    COUNT(u.id) as unit_count
FROM buildings b
LEFT JOIN units u ON u.building_id = b.id
WHERE b.building_name LIKE '%Pimlico%'
GROUP BY b.id, b.building_name;

-- 3. Count leaseholders for Pimlico
SELECT 
    b.building_name,
    COUNT(l.id) as leaseholder_count
FROM buildings b
LEFT JOIN leaseholders l ON l.building_id = b.id
WHERE b.building_name LIKE '%Pimlico%'
GROUP BY b.id, b.building_name;

-- 4. Count all data for Pimlico
SELECT 
    'units' as entity,
    COUNT(*) as count
FROM units
WHERE building_id IN (SELECT id FROM buildings WHERE building_name LIKE '%Pimlico%')
UNION ALL
SELECT 
    'leaseholders',
    COUNT(*)
FROM leaseholders
WHERE building_id IN (SELECT id FROM buildings WHERE building_name LIKE '%Pimlico%')
UNION ALL
SELECT 
    'compliance_assets',
    COUNT(*)
FROM compliance_assets
WHERE building_id IN (SELECT id FROM buildings WHERE building_name LIKE '%Pimlico%')
UNION ALL
SELECT 
    'budgets',
    COUNT(*)
FROM budgets
WHERE building_id IN (SELECT id FROM buildings WHERE building_name LIKE '%Pimlico%');
