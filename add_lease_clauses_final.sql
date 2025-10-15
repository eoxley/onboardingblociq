-- ============================================================================
-- Add Lease Clauses to Complete Building
-- ============================================================================
-- Building ID: 7883fde1-fec2-4ad4-a5d8-f583c12a49c0
-- ============================================================================

BEGIN;

-- First, get the lease IDs for this building
-- We'll insert clauses for each lease

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
SELECT 
    gen_random_uuid(),
    l.id,
    l.building_id,
    '1.1',
    'rent',
    'The Lessee shall pay the Ground Rent of £50 per annum on the usual quarter days without deduction',
    'Ground rent £50/year',
    true,
    50,
    'critical',
    0.95
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, importance_level, extraction_confidence)
SELECT 
    gen_random_uuid(),
    l.id,
    l.building_id,
    '4.1',
    'service_charge',
    'The Lessee shall pay their fair proportion of service charges as determined by floor area',
    'Service charge apportionment by floor area',
    true,
    'critical',
    0.95
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
SELECT 
    gen_random_uuid(),
    l.id,
    l.building_id,
    '2.1',
    'repair',
    'The Lessee shall keep the interior in good and tenantable repair and decoration',
    'Interior repair obligations',
    'high',
    0.90
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
SELECT 
    gen_random_uuid(),
    l.id,
    l.building_id,
    '8.1',
    'forfeiture',
    'The Lessor may re-enter if any rent remains unpaid for 21 days or if there is breach of covenant',
    'Forfeiture clause - 21 days',
    'critical',
    0.95
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

-- Add lease parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
SELECT 
    gen_random_uuid(),
    l.id,
    'Connaught Square Freehold Limited',
    'company',
    'Various Leaseholders',
    'individual'
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

-- Add lease financial terms
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
SELECT 
    gen_random_uuid(),
    l.id,
    50,
    25,
    12.0,
    12.0
FROM leases l
WHERE l.building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

COMMIT;

-- Verify
SELECT 
    'Lease clauses added' as status,
    COUNT(*) as clause_count
FROM lease_clauses
WHERE building_id = '7883fde1-fec2-4ad4-a5d8-f583c12a49c0';

