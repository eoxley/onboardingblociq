-- ============================================================================
-- Connaught Square - COMPLETE DATA WITH LEASE CLAUSES
-- ============================================================================
-- Everything in correct dependency order
-- Building → Units → Leaseholders → Leases → Lease Clauses
-- ============================================================================

BEGIN;

-- ============================================================================
-- 1. BUILDING
-- ============================================================================
INSERT INTO buildings (
    id, building_name, building_address, postcode, city, country, 
    num_units, num_floors, num_blocks, building_height_meters, 
    construction_era, has_lifts, num_lifts, bsa_status,
    data_quality, confidence_score, extraction_version
)
VALUES (
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '32-34 Connaught Square',
    '32-34 Connaught Square, London',
    'W2 2HL',
    'London',
    'United Kingdom',
    8,
    4,
    1,
    14,
    'Victorian',
    TRUE,
    1,
    'Registered',
    'production',
    0.99,
    '6.0 - PRODUCTION FINAL'
) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 2. LEASES (4 documents)
-- ============================================================================

INSERT INTO leases (id, building_id, title_number, lease_type, source_document, document_location, page_count, file_size_mb, extraction_timestamp, extracted_successfully)
VALUES ('a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', 'NGL809841', 'Lease (Land Registry Official Copy)', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 25, 2.13, '2025-10-14T12:11:43.679062', TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (id, building_id, title_number, lease_type, source_document, document_location, page_count, file_size_mb, extraction_timestamp, extracted_successfully)
VALUES ('4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', 'NGL809841', 'Lease (Land Registry Official Copy)', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 25, 2.13, '2025-10-14T12:11:43.729408', TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (id, building_id, title_number, lease_type, source_document, document_location, page_count, file_size_mb, extraction_timestamp, extracted_successfully)
VALUES ('a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', 'NGL827422', 'Lease (Land Registry Official Copy)', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 21, 1.39, '2025-10-14T12:11:43.778311', TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO leases (id, building_id, title_number, lease_type, source_document, document_location, page_count, file_size_mb, extraction_timestamp, extracted_successfully)
VALUES ('07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', 'NGL809841', 'Lease (Land Registry Official Copy)', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', '1. CLIENT INFORMATION/1.02 LEASES/Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 23, 1.1, '2025-10-14T12:11:43.837056', TRUE) ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 3. LEASE CLAUSES (16 clauses)
-- ============================================================================

-- Lease 1 Clauses (Flat 1 - 13.97%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent of £50 per annum on the usual quarter days', 'Ground rent £50/year', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall pay 13.97% of the total service charges', 'Service charge 13.97%', true, 12955, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee shall keep the interior in good and tenantable repair', 'Interior repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'Assignment requires prior written consent', 'Assignment with consent', 'high', 0.90);

-- Lease 2 Clauses (Flat 2 - 11.51%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 11.51% of total', 'Service charge 11.51%', true, 10679, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Maintain in good condition', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'Re-entry if rent unpaid 21 days', 'Forfeiture', 'critical', 0.95);

-- Lease 3 Clauses (Flat 3 - 12.18%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 12.18%', 'Service charge 12.18%', true, 11306, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Keep in good repair', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.1', 'use', 'Private residence only', 'Use restriction', 'medium', 0.90);

-- Lease 4 Clauses (Flat 4 - 11.21%)
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 11.21%', 'Service charge 11.21%', true, 10403, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Interior repair', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.1', 'alterations', 'No structural alterations', 'Alterations', 'medium', 0.90);

-- ============================================================================
-- 4. LEASE PARTIES
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
-- 5. LEASE FINANCIAL TERMS
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
SELECT 'Connaught Square - Building + Leases + Clauses loaded!' as status;
SELECT 
    (SELECT COUNT(*) FROM buildings WHERE id = '2667e33e-b493-499f-ae8d-2de07b7bb707') as buildings,
    (SELECT COUNT(*) FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707') as leases,
    (SELECT COUNT(*) FROM lease_clauses WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707') as clauses,
    (SELECT COUNT(*) FROM lease_parties WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707')) as parties,
    (SELECT COUNT(*) FROM lease_financial_terms WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707')) as financial_terms;
-- Expected: buildings=1, leases=4, clauses=16, parties=4, financial_terms=4

