-- Quick verification query to run in Supabase SQL Editor
-- Copy and paste this into: https://supabase.com/dashboard/project/aewixchhykxyhqjvqoek/sql/new

SELECT
    '✅ Data Import Verification' as status;

-- Check buildings
SELECT
    'Buildings' as table_name,
    COUNT(*) as row_count,
    STRING_AGG(building_name, ', ') as building_names
FROM buildings;

-- Check units
SELECT
    'Units' as table_name,
    COUNT(*) as row_count
FROM units;

-- Check leaseholders
SELECT
    'Leaseholders' as table_name,
    COUNT(*) as row_count,
    SUM(current_balance) as total_balance
FROM leaseholders;

-- Check compliance assets
SELECT
    'Compliance Assets' as table_name,
    COUNT(*) as row_count,
    COUNT(*) FILTER (WHERE status = 'current') as current_count,
    COUNT(*) FILTER (WHERE status = 'expired') as expired_count,
    COUNT(*) FILTER (WHERE status = 'missing') as missing_count
FROM compliance_assets;

-- Check contracts
SELECT
    'Maintenance Contracts' as table_name,
    COUNT(*) as row_count
FROM maintenance_contracts;

-- Detailed building info
SELECT
    building_name,
    num_units,
    postcode,
    has_lifts,
    bsa_status,
    confidence_score
FROM buildings;
