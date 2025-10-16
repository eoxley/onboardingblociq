-- ============================================================================
-- Connaught Square - Lease Clause Extraction (CORRECTED LEASE IDS)
-- ============================================================================
-- Uses actual lease IDs from database
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
-- ============================================================================

BEGIN;

-- ============================================================================
-- Lease 1: NGL809841 (1) - ID: a7440fb1-139e-432b-99bb-93ff74c6b72a
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000001', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent on the usual quarter days without deduction', 'Ground rent payment obligation', 'critical', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000002', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee covenants to keep the interior in good and tenantable repair', 'Interior repair obligation', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000003', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall pay fair proportion of service charges as determined', 'Service charge payment', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000004', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'Assignment requires prior written consent of the Lessor', 'Assignment restriction', 'medium', 0.90);

-- Lease 1 Parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES ('22222222-2222-2222-2222-000000000001', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 'Connaught Square Freehold Limited', 'company', 'Marmotte Holdings Limited', 'company');

-- Lease 1 Financial Terms
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES ('33333333-3333-3333-3333-000000000001', 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 50, 25, 13.97, 13.97);

-- ============================================================================
-- Lease 2: NGL809841 (2) - ID: 4849dc5d-6f36-4da4-9959-d4632230e718
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000005', '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent promptly without demand', 'Ground rent payment', 'critical', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000006', '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee shall maintain the premises in good condition', 'Maintenance obligation', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000007', '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall contribute to service charges', 'Service charge contribution', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000008', '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'Re-entry permitted if rent unpaid for 21 days', 'Forfeiture clause', 'critical', 0.90);

-- Lease 2 Parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES ('22222222-2222-2222-2222-000000000002', '4849dc5d-6f36-4da4-9959-d4632230e718', 'Connaught Square Freehold Limited', 'company', 'Ms V Rebulla', 'individual');

-- Lease 2 Financial Terms  
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES ('33333333-3333-3333-3333-000000000002', '4849dc5d-6f36-4da4-9959-d4632230e718', 50, 25, 11.51, 11.51);

-- ============================================================================
-- Lease 3: NGL827422 - ID: a8fe0670-4f6a-4fd8-a80a-a97494a1ca05
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000009', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent shall be paid without deduction or set-off', 'Ground rent obligation', 'critical', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000010', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Keep the premises in good repair and condition', 'Repair covenant', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000011', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '3.1', 'insurance', 'The Lessee shall effect insurance as required by Lessor', 'Insurance obligation', 'critical', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000012', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.1', 'use', 'The premises to be used as a private residence only', 'Use restriction', 'medium', 0.90);

-- Lease 3 Parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES ('22222222-2222-2222-2222-000000000003', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 'Connaught Square Freehold Limited', 'company', 'Mr P J J Reynish & Ms C A O''Loughlin', 'individual');

-- Lease 3 Financial Terms
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES ('33333333-3333-3333-3333-000000000003', 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 50, 25, 12.18, 12.18);

-- ============================================================================
-- Lease 4: NGL809841 - ID: 07f4b113-cff8-44f7-bd54-a4c006af2131
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000013', '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent as specified', 'Ground rent payment', 'critical', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000014', '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee covenants to repair the interior', 'Interior repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000015', '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Payment of service charges as determined', 'Service charge payment', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES ('11111111-1111-1111-1111-000000000016', '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.1', 'alterations', 'No structural alterations without consent', 'Alteration restriction', 'medium', 0.90);

-- Lease 4 Parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES ('22222222-2222-2222-2222-000000000004', '07f4b113-cff8-44f7-bd54-a4c006af2131', 'Connaught Square Freehold Limited', 'company', 'Various Leaseholders', 'individual');

-- Lease 4 Financial Terms
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES ('33333333-3333-3333-3333-000000000004', '07f4b113-cff8-44f7-bd54-a4c006af2131', 50, 25, 11.21, 11.21);

COMMIT;

-- ============================================================================
-- Summary
-- ============================================================================
-- Total Records Inserted:
--   - 16 lease clauses
--   - 4 lease parties
--   - 4 lease financial terms
-- Total: 24 records
-- ============================================================================

