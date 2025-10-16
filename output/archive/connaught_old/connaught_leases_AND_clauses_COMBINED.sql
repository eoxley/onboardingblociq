-- ============================================================================
-- Connaught Square - Leases + Lease Clauses (COMBINED)
-- ============================================================================
-- First inserts the 4 lease records, then their clauses
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
-- ============================================================================

BEGIN;

-- ============================================================================
-- PART 1: Insert the 4 Lease Records
-- ============================================================================

INSERT INTO leases (
    id, building_id, title_number, lease_type,
    source_document, document_location, page_count,
    file_size_mb, extraction_timestamp, extracted_successfully
)
VALUES (
    'a7440fb1-139e-432b-99bb-93ff74c6b72a',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'NGL809841',
    'Lease (Land Registry Official Copy)',
    'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf',
    '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf',
    25,
    2.13,
    '2025-10-14T12:11:43.679062',
    TRUE
) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (
    id, building_id, title_number, lease_type,
    source_document, document_location, page_count,
    file_size_mb, extraction_timestamp, extracted_successfully
)
VALUES (
    '4849dc5d-6f36-4da4-9959-d4632230e718',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'NGL809841',
    'Lease (Land Registry Official Copy)',
    'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf',
    '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf',
    25,
    2.13,
    '2025-10-14T12:11:43.729408',
    TRUE
) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (
    id, building_id, title_number, lease_type,
    source_document, document_location, page_count,
    file_size_mb, extraction_timestamp, extracted_successfully
)
VALUES (
    'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'NGL827422',
    'Lease (Land Registry Official Copy)',
    'Official Copy (Lease) 13.06.2003 - NGL827422.pdf',
    '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 13.06.2003 - NGL827422.pdf',
    21,
    1.39,
    '2025-10-14T12:11:43.778311',
    TRUE
) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (
    id, building_id, title_number, lease_type,
    source_document, document_location, page_count,
    file_size_mb, extraction_timestamp, extracted_successfully
)
VALUES (
    '07f4b113-cff8-44f7-bd54-a4c006af2131',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'NGL809841',
    'Lease (Land Registry Official Copy)',
    'Official Copy (Lease) 04.08.2022 - NGL809841.pdf',
    '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841.pdf',
    23,
    1.1,
    '2025-10-14T12:11:43.837056',
    TRUE
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- PART 2: Insert Lease Clauses
-- ============================================================================

-- Lease 1: Flat 1 (13.97%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent of £50 per annum on the usual quarter days without deduction or set-off', 'Annual ground rent payment', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall pay 13.97% of the total service charges on demand', 'Service charge apportionment', true, 12955, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee covenants to keep the interior of the demised premises in good and tenantable repair and condition', 'Interior repair obligation', false, NULL, 'high', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'The Lessee may assign the whole but not part of the premises with prior written consent', 'Assignment with consent', 'high', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'The Lessor may re-enter if any rent remains unpaid for 21 days or if there is breach of covenant', 'Forfeiture for breach', 'critical', 0.95);

-- Lease 2: Flat 2 (11.51%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 11.51% of total', 'Service charge', true, 10679, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Maintain premises in good condition', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'Re-entry if rent unpaid 21 days', 'Forfeiture', 'critical', 0.95);

-- Lease 3: Flat 3 (12.18%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 12.18% of total', 'Service charge', true, 11306, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Keep premises in good repair', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.1', 'use', 'Private residence only', 'Use restriction', 'medium', 0.90);

-- Lease 4: Flat 4 (11.21%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 11.21% of total', 'Service charge', true, 10403, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Interior repair obligation', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.1', 'alterations', 'No structural alterations', 'Alteration restriction', 'medium', 0.90);

-- ============================================================================
-- PART 3: Insert Lease Parties
-- ============================================================================

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 'Connaught Square Freehold Limited', 'company', 'Marmotte Holdings Limited', 'company');

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', 'Connaught Square Freehold Limited', 'company', 'Ms V Rebulla', 'individual');

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 'Connaught Square Freehold Limited', 'company', 'Ms V Rebulla', 'individual');

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', 'Connaught Square Freehold Limited', 'company', 'Mr P J J Reynish & Ms C A O''Loughlin', 'individual');

-- ============================================================================
-- PART 4: Insert Lease Financial Terms
-- ============================================================================

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 50, 25, 13.97, 13.97);

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', 50, 25, 11.51, 11.51);

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 50, 25, 12.18, 12.18);

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', 50, 25, 11.21, 11.21);

COMMIT;

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Leases inserted: 4
-- Lease Clauses: 16
-- Lease Parties: 4
-- Lease Financial Terms: 4
-- Total Records: 28
-- ============================================================================

SELECT 'Leases and lease clauses loaded successfully!' as status;
SELECT COUNT(*) as lease_count FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707';
SELECT COUNT(*) as clause_count FROM lease_clauses WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707';

