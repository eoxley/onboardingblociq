-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-14 15:54:13
-- Extraction Version: 6.0 - PRODUCTION FINAL
-- Source Folder: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- Building ID: 2667e33e-b493-499f-ae8d-2de07b7bb707
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
    id, building_name, building_address, postcode, city, country, num_units, num_floors, num_blocks, building_height_meters, construction_era, has_lifts, num_lifts, has_communal_heating, has_hot_water, has_hvac, has_plant_room, has_mechanical_ventilation, has_water_pumps, has_gas, has_sprinklers, has_lightning_conductor, has_gym, has_pool, has_sauna, has_squash_court, has_communal_showers, has_ev_charging, has_balconies, has_cladding, bsa_registration_required, bsa_status, data_quality, confidence_score, source_folder, extraction_version
)
VALUES (
    '2667e33e-b493-499f-ae8d-2de07b7bb707', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Registered', 'production', 0.99, '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE', '6.0 - PRODUCTION FINAL'
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
    '53e39de9-1dcf-4e2e-87c3-848252620d16',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '6b063e9b-2358-43c9-a858-1ebdf9af982b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'b6f63f41-2525-4a1c-bd29-2b6e059cc1f6',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '1b45c4f6-bb3f-4cfb-bcc5-5b7188d0e261',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '68c44d01-82ce-4144-9082-1eb745342927',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '7338b838-11fe-4417-bf0f-37ea4ae863e5',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '8255523c-a932-493a-8f1b-321afd35eeee',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '4c64d02a-c049-4042-9d76-97e315327dfa',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'dc4e5506-3e69-4ea5-a514-81eb83257379',
    '53e39de9-1dcf-4e2e-87c3-848252620d16',
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
    '077b38b7-88fa-4df6-a4fb-6c2375ce6006',
    '6b063e9b-2358-43c9-a858-1ebdf9af982b',
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
    'cd32520e-dcc8-49b4-9879-e73bed5bd695',
    'b6f63f41-2525-4a1c-bd29-2b6e059cc1f6',
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
    'e8e65a73-ae08-47b4-840d-251fe64bff75',
    '1b45c4f6-bb3f-4cfb-bcc5-5b7188d0e261',
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
    '220d18e2-76b8-4cb7-bd73-e821384cf7ba',
    '68c44d01-82ce-4144-9082-1eb745342927',
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
    '82676575-33e0-40e1-ad1f-03218ea6d3fa',
    '7338b838-11fe-4417-bf0f-37ea4ae863e5',
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
    '7c086698-0eee-41e0-87ee-8fc1d002e3b5',
    '8255523c-a932-493a-8f1b-321afd35eeee',
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
    'c4068e3f-e220-4541-b920-a35bd0115c58',
    '4c64d02a-c049-4042-9d76-97e315327dfa',
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
    'b7835e78-f4da-43a0-a0bb-28e67ba3870b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'df9e387d-07a4-4dab-8cca-d493cc2d4455',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '2891f441-a277-440d-aa4a-e51f7177a09d',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '57d2055e-bb39-479b-9ac3-fd0efe12048c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '9e5d7b31-0185-4053-ae02-2193e50e4661',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '94c4fa14-ce2e-455e-bfe2-6562f72647a7',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'c91fc3bd-fa36-41cf-acc7-582d0a7278ef',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'fad4b326-7a45-4554-a795-abdc4c44917b',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '6f73298a-969d-4689-b53e-d106ef44e52e',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '7419e3a3-2933-435a-971c-388ae8b1cb6e',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '325cd28c-87d8-40ce-a3f7-7fa6c5b0caf9',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'f445a907-307d-4d4b-98db-742d4dff2546',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '28e3954e-ae3f-44b1-b6ee-9fc5ce8819c3',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'c94a9b46-5a57-4a4d-835f-18ac1fb08fa3',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'd5464e6c-a28e-4dee-bac0-8607ec5ce12e',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'bf330e43-e257-447d-94da-b75dfccf6487',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'd1cdd1ca-2be3-4a5d-9a5b-dc9669b17185',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '22884813-7e42-45f5-8bab-895e5836cea6',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '21d3ab1e-b2f0-4be3-aba5-67716e74f218',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '02d7977c-96e0-41a4-9414-fc695e06a957',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '5d0dbd1c-3feb-4d93-8655-41598bdaad7a',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'fd0aaea4-849c-4622-9402-bc8a593878bb',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '1dc9647f-89f4-471b-9df1-480c33b362cf',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '747a1810-b500-4519-9003-065c832c8689',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'd7b5857d-d870-4414-8a5c-dd760b857ccf',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'c40d2385-9c85-4cc1-86e9-2415fcb59a6d',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '2c46119a-ef53-4fbc-930d-e83795d1a793',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '3f94b151-65d6-40e9-aed8-896ce53a7458',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '44a4b36e-53fe-4ea6-a126-d8c2d5027b81',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '40e48ef9-c4d3-47de-b99c-0c69f5ae9aaa',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '8ec5973f-16e0-4327-b94f-6d91b3434bf5',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    'bf673794-8691-4ef3-9d4e-94d93c833cdc',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '45575e80-47fb-4306-bbb9-085d25842412',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '76d1c3d1-b676-4b54-a802-57706348b77f',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '4d6e2ea9-96dc-4659-976c-e139e221e568',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '014f6d92-623d-4e63-a440-71022d8ddf16',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
-- Budget (with 26 line items)
-- ============================================================================
INSERT INTO budgets (
    id, building_id, budget_year, total_budget, 
    status, source_document
)
VALUES (
    '06e2461d-9574-472e-9056-cf38b414a738',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    2025,
    92786.0,
    'draft',
    'Connaught Square Budget 2025-6 Draft.xlsx'
);

-- Budget Line Items (26 items)

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '9e822c1a-37e8-48d8-86ff-1fb1f46b8879',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Utilities - Electricity - power and lighting internal',
    'UTILITIES AND ENERGY',
    6000.0,
    1667.27,
    4332.73,
    259.87
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'f60ec260-d1d9-4e3c-9924-53765d7d6ddb',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Utilities - Gas - heating/hot water',
    'UTILITIES AND ENERGY',
    20000.0,
    11846.36,
    8153.639999999999,
    68.83
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'c865b720-23a6-41a6-b993-8b48969c2e33',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Cleaning - Communal',
    'MAINTENANCE AND SERVICES',
    16000.0,
    22500.0,
    -6500.0,
    -28.89
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '05fc4ac8-dc24-43fe-8474-7615e4bcd5f4',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Cleaning - Consumables',
    'MAINTENANCE AND SERVICES',
    400.0,
    252.4,
    147.6,
    58.48
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '82c42ae9-59d5-400c-8572-77cd861d65f4',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Repairs - General',
    'MAINTENANCE AND SERVICES',
    2000.0,
    3376.59,
    -1376.5900000000001,
    -40.77
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '49da4b9a-0b7a-4763-8f1c-2a6313bbcdda',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Drain/Gutter',
    'MAINTENANCE AND SERVICES',
    1200.0,
    1592.0,
    -392.0,
    -24.62
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'c07e18ba-36c1-45eb-973c-5445f5d6b5af',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Fire Equipment',
    'MAINTENANCE AND SERVICES',
    900.0,
    4212.0,
    -3312.0,
    -78.63
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'a8438496-9a93-48d8-b202-1b399592c3f6',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Lighting',
    'MAINTENANCE AND SERVICES',
    850.0,
    0,
    850.0,
    NULL
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '5343c51e-2f88-4215-a630-a2916aa4fcb0',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Communal Heating',
    'MAINTENANCE AND SERVICES',
    2100.0,
    7938.14,
    -5838.14,
    -73.55
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '973f2ac9-316e-4b90-99f5-a59f2391d980',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Lift',
    'MAINTENANCE AND SERVICES',
    3000.0,
    3096.0,
    -96.0,
    -3.1
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '7d0fc8a3-4ecc-4d68-8304-c96650c1958a',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Pest Control',
    'MAINTENANCE AND SERVICES',
    700.0,
    541.8,
    158.20000000000005,
    29.2
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '657c3d82-2559-4cf0-849d-1a5132667ac6',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Asbestos Reinspection',
    'MAINTENANCE AND SERVICES',
    570.0,
    0,
    570.0,
    NULL
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'd4688416-0439-4d2e-8c84-8d9afca1b70b',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Water Hygiene',
    'MAINTENANCE AND SERVICES',
    2000.0,
    1900.58,
    99.42000000000007,
    5.23
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '8d39740a-418b-4acc-9f5d-8c56a8a37343',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Insurance - Buildings',
    'ADMINISTRATION',
    20000.0,
    13245.61,
    6754.389999999999,
    50.99
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '17c3bf02-e594-4b1d-a897-52be9690c80f',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Insurance - Terrorism',
    'ADMINISTRATION',
    2900.0,
    1329.17,
    1570.83,
    118.18
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'c9c49a66-3d18-4b8f-ba63-feb417e70ac4',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Insurance - Directors & Officers',
    'ADMINISTRATION',
    290.0,
    272.27,
    17.730000000000018,
    6.51
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '9d87051e-3640-4faa-8a3e-9aed7b087934',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Insurance - Engineering',
    'ADMINISTRATION',
    560.0,
    529.81,
    30.190000000000055,
    5.7
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'ca25a9c4-5bbb-49b9-9251-3b8b8fefbb70',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Accountancy',
    'ADMINISTRATION',
    1300.0,
    1083.33,
    216.67000000000007,
    20.0
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '63c1db5e-068c-4811-82b9-ce1d223d8dfe',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Professional Fees incl Co Sec Admin',
    'ADMINISTRATION',
    250.0,
    0,
    250.0,
    NULL
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '4abab0ef-b23d-4969-a9ce-438277823eed',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Company Secretary',
    'ADMINISTRATION',
    380.0,
    480.0,
    -100.0,
    -20.83
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'cb4e2d10-770e-45c8-92e0-6c637056ed4c',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Health & Safety',
    'ADMINISTRATION',
    1100.0,
    216.0,
    884.0,
    409.26
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '980e6318-c6fa-4a5e-b875-856786a47f9c',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Estate Management Charges - Connaught Sq',
    'ADMINISTRATION',
    800.0,
    1124.08,
    -324.0799999999999,
    -28.83
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '1bebff47-0396-4271-8480-299119560616',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Maintenance - Garden Charge',
    'ADMINISTRATION',
    4000.0,
    3297.93,
    702.0700000000002,
    21.29
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    'cf67210d-96c0-41a8-8066-85af3df0ad2e',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Management Fees incl VAT',
    'ADMINISTRATION',
    5460.0,
    4500.0,
    960.0,
    21.33
);

INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '51946604-b29f-4bca-bb69-c6adf15babce',
    '06e2461d-9574-472e-9056-cf38b414a738',
    'Out of Hours Fee',
    'ADMINISTRATION',
    26.0,
    0,
    26.0,
    NULL
);


-- ============================================================================
-- Maintenance Schedules (inferred from 6 contracts)
-- ============================================================================

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '67583895-cda0-497c-b987-4b7d869000a5',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Staff Payroll',
    'annual',
    12,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled annual maintenance for Staff Payroll'
);

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '2f4d3a71-2691-42a2-afeb-1c542dc6c640',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Conditional Reports',
    'annual',
    12,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled annual maintenance for Conditional Reports'
);

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '936e5481-7705-4bf1-8079-cb19d7c2290f',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Cctv',
    'annual',
    12,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled annual maintenance for Cctv'
);

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '9392a870-6d6d-44af-aebe-fc011b8c6330',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Business Roadio Simple Site Licence',
    'annual',
    12,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled annual maintenance for Business Roadio Simple Site Licence'
);

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '3f3cd7fe-1ed4-4c1e-a6fc-5c0ca43d5c09',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Lifts',
    'annual',
    12,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled annual maintenance for Lifts'
);

INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '4ca69306-e10f-49d6-b8f2-e4b5342b0e09',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '30bce3dc-ca8e-4d61-93bf-4e3f0c643113',
    'Cleaning',
    'weekly',
    0.25,
    'medium',
    'upcoming',
    'Unknown',
    'Scheduled weekly maintenance for Cleaning'
);


-- ============================================================================
-- Insurance Policies (Supabase: insurance_policies table)
-- ============================================================================

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '7f026b5c-3664-4e20-9557-9394e1b88b6c',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'Buildings Insurance',
    'Camberford Underwriting',
    '2025-03-30',
    17000,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8982f01f-aa0e-4336-a3a0-c94db6f61474',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'Terrorism Insurance',
    'Angel Risk Management',
    '2025-03-31',
    2000,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '4edbe610-183f-42c0-811c-c64cc25f93c8',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'Directors & Officers',
    'AXA Insurance UK plc',
    '2025-03-31',
    290,
    ''
);


-- ============================================================================
-- Leases (4 lease documents)
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
);

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
);

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
);

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
);


-- ============================================================================
-- Contractors (10 contractors)
-- ============================================================================

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '4d1ecf94-caf4-4bce-9645-3b9b330f1067',
    '7.03 STAFF',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.03 STAFF, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'a3b0772c-fb2f-42c1-8fa9-05de93683566',
    '7.02 UTILITIES',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.02 UTILITIES, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '14234dae-88f6-45a2-829f-55b45d1c300b',
    '7.07 DRAINAGE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.07 DRAINAGE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'a7fb29ba-a3f1-41d8-99e7-22bc57877dfe',
    '7.14-CONDITIONAL REPORTS',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.14-CONDITIONAL REPORTS, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '73a5de28-7c60-48f6-be4d-82d34843552a',
    '7.08 PEST CONTROL',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.08 PEST CONTROL, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '64cfe5e3-6806-4d9b-affd-31c26046b6c9',
    '7.06 CCTV',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.06 CCTV, Documents: 2'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '035df10a-ce98-4f01-bde8-b03e11bb1fb6',
    '7.11-WATER HYGIENE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.11-WATER HYGIENE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '38504950-1265-4a3c-88e2-78c191286172',
    '7.12 BUSINESS ROADIO SIMPLE SITE LICENCE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.12 BUSINESS ROADIO SIMPLE SITE LICENCE, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '2887aba9-1daf-47ff-bd77-c6e437cf5bc6',
    '7.04 LIFTS',
    ARRAY['Lift Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.04 LIFTS, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '2d2b4dfe-3549-481e-8fcb-3680c5ee2284',
    '7.01 CLEANING',
    ARRAY['Cleaning'],
    TRUE,
    'Folder: 7. CONTRACTS/7.01 CLEANING, Documents: 1'
);


-- ============================================================================
-- Major Works Projects (1 projects detected)
-- ============================================================================

INSERT INTO major_works_projects (
    id, building_id, project_name, description,
    status, s20_consultation_required, s20_documents_count,
    folder_path, total_documents
)
VALUES (
    '0f383187-c050-4575-a320-c2ccfc8af8ab',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    'Major Works Project',
    'Detected from documents folder',
    'planned',
    FALSE,
    0,
    '6. MAJOR WORKS',
    5
);


-- ============================================================================
-- Documents Registry
-- ============================================================================
-- Documents reference where files SHOULD be uploaded in Supabase Storage
-- Bucket: building-documents
-- Path structure: building-documents/2667e33e-b493-499f-ae8d-2de07b7bb707/...
--
-- MANUAL UPLOAD REQUIRED:
-- 1. Upload all files from: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- 2. To Supabase Storage bucket: building-documents
-- 3. Preserve folder structure under building_id
-- ============================================================================


-- Client Information Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    'c834fae6-7340-4f2a-adf2-0743a9173eb4',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '1. CLIENT INFORMATION',
    'Folder',
    'Client Information',
    'building-documents',
    '2667e33e-b493-499f-ae8d-2de07b7bb707/1. CLIENT INFORMATION'
);

-- Health & Safety Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    '15a4b58b-cc98-467c-98cb-69958d9b9d93',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '4. HEALTH & SAFETY',
    'Folder',
    'Health & Safety',
    'building-documents',
    '2667e33e-b493-499f-ae8d-2de07b7bb707/4. HEALTH & SAFETY'
);

-- Contracts Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    '1cc9a194-c7c2-424e-99a3-d85b00b27d7a',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
    '7. CONTRACTS',
    'Folder',
    'Contracts',
    'building-documents',
    '2667e33e-b493-499f-ae8d-2de07b7bb707/7. CONTRACTS'
);

-- Additional documents to be added after manual upload
-- You can query uploaded files and insert document records programmatically



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
    '71ca8b12-038f-44e2-a4cb-375cd2f1cb39',
    '2667e33e-b493-499f-ae8d-2de07b7bb707',
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
    '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE',
    'Success'
);