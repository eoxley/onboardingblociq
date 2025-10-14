-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-14 14:03:19
-- Extraction Version: 6.0 - PRODUCTION FINAL
-- Source Folder: N/A
-- Building ID: eaa40525-99f5-450f-ae63-c5e8fad09b23
-- ============================================================================
--
-- INSTRUCTIONS:
-- 1. Run this SQL script in Supabase SQL Editor
-- 2. Manually upload building documents to Supabase Storage bucket: building-documents
-- 3. Documents should be uploaded to: building-documents/{building_id}/...
-- 4. The documents table entries below reference where files SHOULD be uploaded
--
-- ============================================================================

BEGIN;


-- ============================================================================
-- Building Insert
-- ============================================================================
INSERT INTO buildings (
    id, building_name, building_address, postcode, city, country, num_units, num_floors, num_blocks, building_height_meters, construction_era, has_lifts, num_lifts, has_communal_heating, has_hot_water, has_hvac, has_plant_room, has_mechanical_ventilation, has_water_pumps, has_gas, has_sprinklers, has_lightning_conductor, has_gym, has_pool, has_sauna, has_squash_court, has_communal_showers, has_ev_charging, has_balconies, has_cladding, bsa_registration_required, bsa_status, data_quality, confidence_score, extraction_version
)
VALUES (
    'eaa40525-99f5-450f-ae63-c5e8fad09b23', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Registered', 'production', 0.99, '6.0 - PRODUCTION FINAL'
);


-- ============================================================================
-- Units
-- ============================================================================

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'f1a70060-54ac-481e-9928-162202748a6b',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 1',
    '219-01-001',
    'Flat',
    13.97,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '6a3bd4b3-d4b8-42df-8c70-05cf2616be08',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 2',
    '219-01-002',
    'Flat',
    11.51,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'a9f0c8d5-ff24-4a6e-b467-777207f9c854',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 3',
    '219-01-003',
    'Flat',
    12.18,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '2e34e5e7-e763-4b24-999d-ccc2299e2d34',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 4',
    '219-01-004',
    'Flat',
    11.21,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '2ff93a94-4cb1-4fd6-bb48-b9a1df9ef84d',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 5',
    '219-01-005',
    'Flat',
    11.75,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'b9d9a564-57c7-47fa-9344-b00bc366a7d8',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 6',
    '219-01-006',
    'Flat',
    24.13,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '57d98d30-315f-4221-8944-8845d17cacdb',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 7',
    '219-01-007',
    'Flat',
    9.25,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '716b2421-604c-4261-907b-7617a43dfceb',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    'Flat 8',
    '219-01-008',
    'Flat',
    6.0,
    'Last In',
    'connaught apportionment.xlsx',
    'high'
);


-- ============================================================================
-- Leaseholders
-- ============================================================================

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '89e44b62-d46d-4700-bfd8-5cd3cb647cff',
    'f1a70060-54ac-481e-9928-162202748a6b',
    'Marmotte Holdings Limited',
    'Flat 1, 32-34 Connaught Square, St George''s Fields, London, W2 2HL',
    '',
    '',
    'Current',
    0.0,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4a7ad817-eabe-404e-b2a2-e288e3b93b38',
    '6a3bd4b3-d4b8-42df-8c70-05cf2616be08',
    'Ms V Rebulla',
    'Flat 2/3, 32 Connaught Square, St Georges Fields, London',
    '',
    '',
    'Current',
    0.0,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'a4620e45-9bfd-493e-8f26-e82bd1cb8b0f',
    'a9f0c8d5-ff24-4a6e-b467-777207f9c854',
    'Ms V Rebulla',
    'Flat 2/3, 32 Connaught Square, St Georges Fields, London',
    '',
    '',
    'Current',
    0.0,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '087e4826-781e-4f66-bfae-94732c0cacb8',
    '2e34e5e7-e763-4b24-999d-ccc2299e2d34',
    'Mr P J J Reynish & Ms C A O''Loughlin',
    'Flat 4, 32-34 Connaught Square, St George''s Fields, London, W2 2HL',
    '',
    '',
    'Current',
    388.8,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'a3961883-064a-41d0-ae7e-d1c3df8629c5',
    '2ff93a94-4cb1-4fd6-bb48-b9a1df9ef84d',
    'Mr & Mrs M D Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    '07768803607',
    '',
    'Current',
    3673.34,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'effcc541-850d-4795-8278-82d09442ecee',
    'b9d9a564-57c7-47fa-9344-b00bc366a7d8',
    'Mr M D & Mrs C P Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    '07768803607',
    '',
    'Current',
    7543.64,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '86fcabbc-df0f-4e2d-994f-52ff8d6d4807',
    '57d98d30-315f-4221-8944-8845d17cacdb',
    'Ms J Gomm',
    'Flat 7/No 34, 32-34 Connaught Square, London, W2 2HL',
    '07912758299',
    '',
    'Current',
    0.0,
    'connaught.xlsx',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '2e67e123-2333-4de1-b221-321d5d1bcbdd',
    '716b2421-604c-4261-907b-7617a43dfceb',
    'Miss T V Samwoth & Miss G E Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    '',
    '',
    'Current',
    1875.75,
    'connaught.xlsx',
    'high'
);


-- ============================================================================
-- Compliance Assets
-- ============================================================================
-- Note: asset_type_id references compliance_asset_types table
-- Map asset_type to correct UUID from compliance_asset_types table


-- FRA
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'FRA'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '7ddbe953-7850-4f14-a515-7cbb1b72ed2b',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'FRA' LIMIT 1),
    '2023-12-07',
    NULL,
    '2024-12-31',
    'expired',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf',
    'medium'
);

-- EICR
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'EICR'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '87314bd3-26a0-4931-88d4-d6153434cd7c',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'EICR' LIMIT 1),
    '2023-01-01',
    NULL,
    '2028-01-01',
    'current',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    'EICR Cuanku 32-34 conaught square.pdf',
    'medium'
);

-- Legionella
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'LEGIONELLA'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1fd18c6e-0afa-4c4a-8544-2a4b50973b29',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'LEGIONELLA' LIMIT 1),
    '2022-06-07',
    NULL,
    '2024-06-07',
    'expired',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    'WHM Legionella Risk Assessment 09.12.25.pdf',
    'medium'
);

-- Asbestos
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'ASBESTOS'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1ff4d7cb-ac57-473d-9747-a67692268c9a',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'ASBESTOS' LIMIT 1),
    '2022-06-14',
    NULL,
    '2025-06-14',
    'current',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf',
    'medium'
);

-- Fire Door
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'FIRE_DOOR'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '96209df2-3115-4301-b6cf-1aee084a2793',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'FIRE_DOOR' LIMIT 1),
    '2024-01-24',
    NULL,
    '2025-01-24',
    'current',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    'Fire Door (Communal) Inspection (11m +) (7).pdf',
    'medium'
);

-- FRA
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'FRA'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1f82b4fa-3c3d-4bac-9961-ccf69f45c0e1',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'FRA' LIMIT 1),
    '2023-12-07',
    NULL,
    '2024-12-31',
    'expired',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf',
    'medium'
);

-- Legionella
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'LEGIONELLA'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'caa1f156-ea53-4b9d-9eb3-97f11073adff',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'LEGIONELLA' LIMIT 1),
    '2022-06-07',
    NULL,
    '2024-06-07',
    'expired',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    'WHM Legionella Risk Assessment 09.12.25.pdf',
    'medium'
);

-- Fire Alarm
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'FIRE_ALARM'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c515bdf6-0e21-446a-973c-9180defdcb64',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'FIRE_ALARM' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Emergency Lighting
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'EMERGENCY_LIGHTING'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '4a30178b-b169-4dcf-b25d-fecc82ca45af',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'EMERGENCY_LIGHTING' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- AOV
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'AOV'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '14bda2b0-e363-45b3-9352-1fa8a2d7179e',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'AOV' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Fire Extinguishers
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2727926e-7d5c-4929-a224-5b23cd4d80da',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Fire Stopping
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '4b8ac945-8349-4083-8bbe-16b69cb58d12',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Smoke Detectors
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '7ad2c626-d14e-4e76-8691-c30cae675f07',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- PAT Testing
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'PAT'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'a8468bf8-c7c3-454b-b831-ecfc1252b691',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'PAT' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Distribution Board
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '53d8c0d1-14c7-4aad-96fe-0b51172f5c56',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Roof Inspection
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b19a5ca7-fe0b-48e2-a1a7-fa9020d85e53',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Resident Engagement
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'd317ec83-ad24-4563-ad6e-62cd1b92faf9',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Compartmentation Survey
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'fa8d20a0-df23-4b7d-8195-80d25a2e6c56',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Lift
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'LIFT_LOLER'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b265d111-ec81-49da-af92-22141cdaab12',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'LIFT_LOLER' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Lift Maintenance
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '195480a5-79b2-4305-8313-5f821da8268c',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Gas Safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'GAS_SAFETY'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c5d482f0-5f1b-4e75-a137-e56a42f3e3ed',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'GAS_SAFETY' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Buildings Insurance
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '9f940925-7146-4121-b816-92e110b9eafa',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Public Liability
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c349b473-79df-463c-b5e2-0bb87c76ee81',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Health & Safety Risk
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '6d18509e-cbae-4673-b329-6cd19b6900c5',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- H&S Audit
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2db186e2-024c-4beb-97d0-311041be6635',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Cleaning Contract
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1545d83d-e88e-4180-8ca2-5ba834b208ac',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Pest Control
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '015c4e13-415d-47b2-b1ee-8cc9a803bc16',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Waste Management
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '434d82b8-1c8a-4e51-bc10-961e222727fe',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Insurance Schedule
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'e47f65fa-ad3e-4336-8ab7-061dfd96a48b',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Budget Approval
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2a7eb6c3-6f1e-4642-b5cd-b63e6752d992',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);

-- Resident Communication
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'a7287729-0c56-47a2-a452-2fa277879722',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'missing',
    NULL,
    FALSE,
    'Required by regulation (no historical evidence found)',
    NULL,
    FALSE,
    '',
    'medium'
);


-- ============================================================================
-- Maintenance Contracts
-- ============================================================================
-- Note: contract_type_id references contract_types table


-- Staff Payroll
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    '84888bfe-ee00-4b58-95e7-711d10f4ccc6',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'GENERAL_MAINTENANCE' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.33,
    FALSE,
    TRUE,
    '7. CONTRACTS/7.03 STAFF',
    'medium'
);

-- Conditional Reports
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    'b36fc643-cbed-4982-8c2e-5ea4ccb6e256',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'GENERAL_MAINTENANCE' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.0,
    TRUE,
    TRUE,
    '7. CONTRACTS/7.14-CONDITIONAL REPORTS',
    'medium'
);

-- Cctv
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    '296596ae-e1af-4d07-b8c8-b5107b213219',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'GENERAL_MAINTENANCE' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.0,
    TRUE,
    TRUE,
    '7. CONTRACTS/7.06 CCTV',
    'medium'
);

-- Business Roadio Simple Site Licence
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    '07d994eb-70af-4352-8c13-1a1a5bb5cabe',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'GENERAL_MAINTENANCE' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.0,
    TRUE,
    TRUE,
    '7. CONTRACTS/7.12 BUSINESS ROADIO SIMPLE SITE LICENCE',
    'medium'
);

-- Lifts
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    'f4c08c95-63b7-4bd9-9960-cccbe0033a69',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'GENERAL_MAINTENANCE' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.0,
    TRUE,
    TRUE,
    '7. CONTRACTS/7.04 LIFTS',
    'medium'
);

-- Cleaning
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    '671e9755-10f1-4d76-9d06-40cb83358020',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    (SELECT id FROM contract_types WHERE contract_type_code = 'CLEANING' LIMIT 1),
    'Unknown',
    '',
    NULL,
    NULL,
    FALSE,
    NULL,
    '',
    'Unknown',
    0.0,
    TRUE,
    TRUE,
    '7. CONTRACTS/7.01 CLEANING',
    'medium'
);


-- ============================================================================
-- Extraction Run Metadata
-- ============================================================================
INSERT INTO extraction_runs (
    id, building_id, extraction_date, extraction_version,
    units_extracted, leaseholders_extracted,
    compliance_assets_extracted, contracts_extracted,
    data_quality, confidence_score,
    new_types_discovered, low_confidence_detections,
    source_folder, extraction_status
)
VALUES (
    '11cee661-1a0a-4f41-b686-2a11c95de6ec',
    'eaa40525-99f5-450f-ae63-c5e8fad09b23',
    NOW(),
    '6.0 - PRODUCTION FINAL',
    8,
    8,
    31,
    6,
    'production',
    0.99,
    0,
    2,
    '',
    'Success'
);COMMIT;
