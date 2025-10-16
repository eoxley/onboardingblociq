
-- ============================================================================
-- Connaught Square - Lease Clause Extraction
-- ============================================================================
-- Generated from 4 lease documents
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
-- ============================================================================

BEGIN;


-- Lease 1: NGL809841 (4 clauses)

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '8d10b791-bfca-4fb1-853e-979612a6b4bf',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '2.1',
    'repair',
    'REPAIR AND MAINTENANCE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '9d84acee-5d03-458c-b170-1a72d385730d',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '4.2',
    'service_charge',
    'SERVICE CHARGE RESERVE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '358218e4-9472-4aa9-94fb-f0e4d14988d8',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '6.2',
    'alterations',
    'NON-STRUCTURAL ALTERATIONS',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '74eb06e7-50cf-4e53-b14c-4ac394bd7540',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '7.1',
    'assignment',
    'ASSIGNMENT AND SUBLETTING',
    '',
    'medium',
    0.85
);

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    'f158e597-545a-41a4-8695-306bb4118171',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    'Connaught Square Freehold Limited',
    'company',
    'Name, Leaseholder',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '44b02df3-04d9-44b5-8a3c-f74b6ce1d559',
    '6aadec5e-4ebf-4537-941b-1db7fe332991',
    50,
    25,
    13.97,
    13.97
);

-- Lease 2: NGL809841 (4 clauses)

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    'ee33f529-d243-47cb-ba95-a9b1ca7e3e85',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '2.1',
    'repair',
    'REPAIR AND MAINTENANCE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '185c44b6-f0c9-40ab-a426-ade23d0e7295',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '4.2',
    'service_charge',
    'SERVICE CHARGE RESERVE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '2a00ff6b-d171-44df-a4fb-3b7f9c297f33',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '6.2',
    'alterations',
    'NON-STRUCTURAL ALTERATIONS',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '420ace84-aa9d-45d9-818d-7242efc6b54f',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '7.1',
    'assignment',
    'ASSIGNMENT AND SUBLETTING',
    '',
    'medium',
    0.85
);

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    '18690dd2-8a2e-48d4-aab2-9386db8b0b03',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    'Connaught Square Freehold Limited',
    'company',
    'Name, Leaseholder',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '449ec0de-70dc-453b-8a41-927954fe9f34',
    '2ec12bc1-2876-40f2-ad3d-671ba770b40c',
    50,
    25,
    11.51,
    11.51
);

-- Lease 3: NGL827422 (4 clauses)

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    'f77a5734-8044-40d6-a0d6-b05f58c09330',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '2.1',
    'repair',
    'REPAIR AND MAINTENANCE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '84444871-f4c6-4cd5-b61b-e9d897e6842f',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '4.2',
    'service_charge',
    'SERVICE CHARGE RESERVE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    'f564545a-4b4a-498d-b99d-198ddf8798a1',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '6.2',
    'alterations',
    'NON-STRUCTURAL ALTERATIONS',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '7bacc32d-721f-469f-8b92-834670535170',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '7.1',
    'assignment',
    'ASSIGNMENT AND SUBLETTING',
    '',
    'medium',
    0.85
);

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    'c5964b1a-565d-466c-9719-43eba994461e',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    'Connaught Square Freehold Limited',
    'company',
    'Name, Leaseholder',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '4f158153-eea7-47e4-b853-c19ddf47027d',
    'a97a4a86-8e89-4ea1-a55d-4ae66c98ec9b',
    50,
    25,
    12.18,
    12.18
);

-- Lease 4: NGL809841 (4 clauses)

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '574f6875-41d9-445c-a970-ca866fa93d41',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '2.1',
    'repair',
    'REPAIR AND MAINTENANCE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    'eebedfa3-1c8f-44ba-a45c-38ae9fa5f51a',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '4.2',
    'service_charge',
    'SERVICE CHARGE RESERVE',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    'b6da2432-e5c1-43b6-aa85-54b4de7e049e',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '6.2',
    'alterations',
    'NON-STRUCTURAL ALTERATIONS',
    '',
    'medium',
    0.85
);

INSERT INTO lease_clauses (
    id, lease_id, building_id,
    clause_number, clause_category, clause_text, clause_summary,
    importance_level, extraction_confidence
)
VALUES (
    '474b3dff-89c7-4821-b98c-2059c3b0d935',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '7.1',
    'assignment',
    'ASSIGNMENT AND SUBLETTING',
    '',
    'medium',
    0.85
);

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    '8d334330-3936-49b8-a6a3-01143f7899d9',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    'Connaught Square Freehold Limited',
    'company',
    'Name, Leaseholder',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    'b62bfbc7-300d-4781-b37b-1604e25bd385',
    '57c82ade-5819-4909-9175-a63f8d9f3aea',
    50,
    25,
    11.21,
    11.21
);

COMMIT;