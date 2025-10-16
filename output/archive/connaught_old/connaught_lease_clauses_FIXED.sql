
-- ============================================================================
-- Connaught Square - Lease Clause Extraction (CORRECT LEASE IDS)
-- ============================================================================
-- Links to existing leases already in database
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
-- ============================================================================

BEGIN;


-- Lease 1: NGL809841 (ID: a7440fb1-139e-432b-99bb-93ff74c6b72a) - 0 clauses

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    '2c9119dd-8692-464b-a76c-7c5ecd88ec75',
    'a7440fb1-139e-432b-99bb-93ff74c6b72a',
    'Connaught Square Freehold Limited',
    'company',
    '',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '7bd9890c-1451-4d82-8d8c-e845ea6f88a7',
    'a7440fb1-139e-432b-99bb-93ff74c6b72a',
    50,
    25,
    13.97,
    13.97
);

-- Lease 2: NGL809841 (ID: 4849dc5d-6f36-4da4-9959-d4632230e718) - 0 clauses

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    '0d6ba04c-6622-4a20-a303-1e7011b2621e',
    '4849dc5d-6f36-4da4-9959-d4632230e718',
    'Connaught Square Freehold Limited',
    'company',
    '',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '4784d0e3-9776-41c4-9152-dd4e49a2df92',
    '4849dc5d-6f36-4da4-9959-d4632230e718',
    50,
    25,
    11.51,
    11.51
);

-- Lease 3: NGL827422 (ID: a8fe0670-4f6a-4fd8-a80a-a97494a1ca05) - 0 clauses

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    '655363dc-938d-4cd3-9825-ae52b4749126',
    'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05',
    'Connaught Square Freehold Limited',
    'company',
    '',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '1ed59c07-beff-4656-a60a-46d7d2130d5e',
    'a8fe0670-4f6a-4fd8-a80a-a97494a1ca05',
    50,
    25,
    12.18,
    12.18
);

-- Lease 4: NGL809841 (ID: 07f4b113-cff8-44f7-bd54-a4c006af2131) - 0 clauses

INSERT INTO lease_parties (
    id, lease_id,
    lessor_name, lessor_type,
    lessee_name, lessee_type
)
VALUES (
    'dbb34d42-ca0b-46d1-bbfa-f2e38a3aa4dd',
    '07f4b113-cff8-44f7-bd54-a4c006af2131',
    'Connaught Square Freehold Limited',
    'company',
    '',
    'individual'
);

INSERT INTO lease_financial_terms (
    id, lease_id,
    ground_rent_current, ground_rent_review_period,
    service_charge_percentage, apportionment_percentage
)
VALUES (
    '6340d625-b461-49cb-952b-7658967b8c77',
    '07f4b113-cff8-44f7-bd54-a4c006af2131',
    50,
    25,
    11.21,
    11.21
);

COMMIT;