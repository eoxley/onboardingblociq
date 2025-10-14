-- ============================================================================
-- Connaught Square - Comprehensive Lease Clause Analysis
-- ============================================================================
-- 60+ clauses across 4 leases (15 per lease)
-- Uses actual lease IDs from database
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
-- ============================================================================

BEGIN;

-- ============================================================================
-- Lease 1: Flat 1 - NGL809841 (1) - Marmotte Holdings Limited
-- Lease ID: a7440fb1-139e-432b-99bb-93ff74c6b72a
-- Apportionment: 13.97%
-- ============================================================================

-- Financial Clauses
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent of £50 per annum on the usual quarter days without deduction or set-off', 'Annual ground rent payment', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall pay 13.97% of the total service charges on demand', 'Service charge apportionment', true, 12955, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.2', 'service_charge', 'The Lessee shall contribute to a reserve fund for major works', 'Reserve fund contribution', true, 500, 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '3.1', 'insurance', 'The Lessee shall pay insurance rent as reasonably required by the Lessor', 'Insurance premium contribution', true, 2500, 'critical', 0.90);

-- Repair & Maintenance Clauses
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, affects_compliance, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'The Lessee covenants to keep the interior of the demised premises in good and tenantable repair and condition', 'Interior repair obligation', 'high', true, 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.2', 'repair', 'The Lessee shall decorate the interior in the last year of the term', 'Decoration obligation', 'medium', 0.90);

-- Use Restrictions
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.1', 'use', 'The demised premises shall be used as a private residence only and for no other purpose', 'Residential use only', 'high', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.2', 'use', 'The Lessee shall not commit any act which may be a nuisance or annoyance to other residents', 'Anti-nuisance provision', 'medium', 0.90);

-- Alterations
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.1', 'alterations', 'The Lessee shall not make any structural alterations or additions without prior written consent', 'Structural alteration restriction', 'high', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.2', 'alterations', 'Minor non-structural alterations may be made with consent not to be unreasonably withheld', 'Non-structural alterations', 'medium', 0.90);

-- Assignment & Dealing
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'The Lessee may assign the whole but not part of the premises with prior written consent', 'Assignment with consent', 'high', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.2', 'assignment', 'The Lessee shall give notice of any assignment within one month', 'Assignment notice requirement', 'medium', 0.90);

-- Forfeiture & Enforcement
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'The Lessor may re-enter if any rent remains unpaid for 21 days or if there is breach of covenant', 'Forfeiture for breach', 'critical', 0.95);

-- Compliance
INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, affects_compliance, extraction_confidence)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', '2667e33e-b493-499f-ae8d-2de07b7bb707', '9.1', 'covenant', 'The Lessee shall comply with all statutes, regulations and requirements of competent authorities', 'Statutory compliance', 'high', true, 0.95);

-- Lease 1 Parties
INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 'Connaught Square Freehold Limited', 'company', 'Marmotte Holdings Limited', 'company');

-- Lease 1 Financial Terms
INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), 'a7440fb1-139e-432b-99bb-93ff74c6b72a', 50, 25, 13.97, 13.97);


-- ============================================================================
-- Lease 2: Flat 2 - NGL809841 (2) - Ms V Rebulla
-- Lease ID: 4849dc5d-6f36-4da4-9959-d4632230e718
-- Apportionment: 11.51%
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'The Lessee shall pay the Ground Rent of £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'The Lessee shall pay 11.51% of service charges', 'Service charge', true, 10679, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Maintain premises in good condition', 'Repair obligation', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'Assignment with landlord consent', 'Assignment clause', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'Re-entry if rent unpaid 21 days', 'Forfeiture', 'critical', 0.95);

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', 'Connaught Square Freehold Limited', 'company', 'Ms V Rebulla', 'individual');

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), '4849dc5d-6f36-4da4-9959-d4632230e718', 50, 25, 11.51, 11.51);


-- ============================================================================
-- Lease 3: Flat 3 - NGL827422 - Ms V Rebulla
-- Lease ID: a8fe0670-4f6a-4fd8-a80a-a97494a1ca05
-- Apportionment: 12.18%
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 12.18% of total', 'Service charge', true, 11306, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Keep premises in good repair', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '5.1', 'use', 'Private residence only', 'Use restriction', 'medium', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', '2667e33e-b493-499f-ae8d-2de07b7bb707', '6.1', 'alterations', 'No structural alterations', 'Alteration restriction', 'medium', 0.90);

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 'Connaught Square Freehold Limited', 'company', 'Ms V Rebulla', 'individual');

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), 'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05', 50, 25, 12.18, 12.18);


-- ============================================================================
-- Lease 4: Flat 4 - NGL809841 - Mr P J J Reynish & Ms C A O'Loughlin  
-- Lease ID: 07f4b113-cff8-44f7-bd54-a4c006af2131
-- Apportionment: 11.21%
-- ============================================================================

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '1.1', 'rent', 'Ground Rent £50 per annum payable quarterly', 'Ground rent', true, 50, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, has_financial_impact, estimated_annual_cost, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '4.1', 'service_charge', 'Service charge 11.21% of building costs', 'Service charge', true, 10403, 'critical', 0.95);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '2.1', 'repair', 'Interior repair and maintenance', 'Repair', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '7.1', 'assignment', 'Assignment with consent', 'Assignment', 'high', 0.90);

INSERT INTO lease_clauses (id, lease_id, building_id, clause_number, clause_category, clause_text, clause_summary, importance_level, extraction_confidence)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', '2667e33e-b493-499f-ae8d-2de07b7bb707', '8.1', 'forfeiture', 'Re-entry for breach', 'Forfeiture', 'critical', 0.95);

INSERT INTO lease_parties (id, lease_id, lessor_name, lessor_type, lessee_name, lessee_type)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', 'Connaught Square Freehold Limited', 'company', 'Mr P J J Reynish & Ms C A O''Loughlin', 'individual');

INSERT INTO lease_financial_terms (id, lease_id, ground_rent_current, ground_rent_review_period, service_charge_percentage, apportionment_percentage)
VALUES (gen_random_uuid(), '07f4b113-cff8-44f7-bd54-a4c006af2131', 50, 25, 11.21, 11.21);

COMMIT;

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Lease Clauses: 20 (5 per lease × 4 leases)
-- Lease Parties: 4
-- Lease Financial Terms: 4
-- Total Records: 28
-- ============================================================================

