-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-14 15:52:04
-- Extraction Version: 6.0 - PRODUCTION FINAL
-- Source Folder: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- Building ID: c8074940-d00d-4ed9-9ce2-b8a741088849
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
    'c8074940-d00d-4ed9-9ce2-b8a741088849', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Registered', 'production', 0.99, '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE', '6.0 - PRODUCTION FINAL'
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
    '2fe36b55-d4f9-4879-aede-d0479fbecb8f',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '36ada302-0a33-4b18-a855-c8b1953619f7',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'e15a681d-086d-460d-a550-6a1f7ecf5baa',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'b8702ea9-ff36-4745-bcb9-209e000743b0',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'c1e51b21-8c9f-47a1-9df2-078685858c58',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '7e78588e-0618-463f-9e48-05a1802ad6e5',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '0abecb29-e15a-4ea6-874a-6ef10c18c624',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'f0a69e73-81a5-43c2-87b7-0f3767226791',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '3ac4c93c-8406-4554-bdb2-3ea9f6ba629f',
    '2fe36b55-d4f9-4879-aede-d0479fbecb8f',
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
    '6ea63fa3-1730-4ce0-9e68-8d4f6655a9f3',
    '36ada302-0a33-4b18-a855-c8b1953619f7',
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
    '933771d4-f97b-4150-817b-7c3983b3a92b',
    'e15a681d-086d-460d-a550-6a1f7ecf5baa',
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
    '21238080-e2d7-4c1d-b1b9-6d43a0faa3fd',
    'b8702ea9-ff36-4745-bcb9-209e000743b0',
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
    '1a5441c4-4c1d-44e4-87e5-e442d30a4483',
    'c1e51b21-8c9f-47a1-9df2-078685858c58',
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
    '745a9c2f-c38b-494c-9c74-531857363585',
    '7e78588e-0618-463f-9e48-05a1802ad6e5',
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
    'ff22412b-8913-483e-9fda-82aeff9898a3',
    '0abecb29-e15a-4ea6-874a-6ef10c18c624',
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
    '28eabf39-278b-4b15-bc4b-1e65b13ffb4c',
    'f0a69e73-81a5-43c2-87b7-0f3767226791',
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
    '5634b35b-31fd-44c5-bf48-38c0f0edb0a5',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '250fa8d4-7b47-4e7d-b938-019dedd0d4ea',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'a7de12f1-1856-4fb2-83db-4b264b3fe276',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'f69dfeff-8476-497e-a44c-1137004de7d4',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '0c51b846-b1a2-4945-8dfb-9cff7410663c',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '8cf66235-a28c-41c5-8771-a79bd5cfbeb4',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '57c7ab34-5bb8-4e30-bd08-5ec1bf67bfe3',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '56852810-a230-4ce4-bb13-2fbc2d1f3d06',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'fbfbb421-87a8-41ab-ac3d-4734ad391ef6',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '27e4524a-f54d-4d13-b4a9-0500d495fa96',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'cd8dbfe9-7910-41da-b7ce-eb0212df4250',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '16efe9f6-7eb5-4d02-bea7-62f8dc62e2ee',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'c2540e8f-95a4-4fd9-b5d8-479b2dc16bfb',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '5f6460b5-7f2a-496b-8984-02f592d3760d',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'b3cebca3-b63e-44fa-b079-a0f3f3e6e11d',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '41420acd-a5fb-46fb-acf7-eb913924377d',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '2808b80a-1cba-4ebf-b85e-5743b01cf72f',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'e2d76b0b-9f2d-4e57-a798-2c473457e4dc',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'c26363f3-f0b7-4c46-bb6b-678f2355a036',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '69ec6b0b-1bd1-4b99-b1fc-ade953024c6e',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'a3f0de0b-ce2e-4476-ba95-45b407c325aa',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '46894e1e-b55c-485b-b93a-aabff671c86a',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '9a1c2bb3-96cf-4ee9-aacb-88cc744fcee7',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'aa68add1-3faf-41b9-a40e-ee001453cdc2',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '45560a8f-5928-4ac3-bcba-ce410f2f7b56',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '6e3eb2d6-4031-4530-a0e8-5e5e695eadef',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'e43cd699-fa47-4886-b615-9b2bfb874fe4',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'b9c45f10-1b28-46df-9eb6-fb8b8194c4e3',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'e7bf5950-313a-4ab5-a559-374b6bbb4f4d',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '1d8a3a18-b3a9-4b6f-b04e-2673d369d31e',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '3012817d-3be8-477a-b0e6-df869bb7167c',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '410fe6ec-4af4-4352-9600-6f422d90b159',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'da90a1ac-b814-45fd-b97f-8802cb580483',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '0ebf73f7-485b-4efe-b0a0-4763e1570553',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'c1c31d76-9b86-48e0-ae51-5fc24df634a9',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    '59e7b651-d28b-4bf6-a10f-1d5c29480283',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
    'fb46b8f9-38bf-4b82-ad40-489afd09c0e0',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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
-- Documents Registry
-- ============================================================================
-- Documents reference where files SHOULD be uploaded in Supabase Storage
-- Bucket: building-documents
-- Path structure: building-documents/c8074940-d00d-4ed9-9ce2-b8a741088849/...
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
    '0b51bff8-3e9d-4ec3-babc-2a0c5691c8b2',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
    '1. CLIENT INFORMATION',
    'Folder',
    'Client Information',
    'building-documents',
    'c8074940-d00d-4ed9-9ce2-b8a741088849/1. CLIENT INFORMATION'
);

-- Health & Safety Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    'e7e3846d-9d62-484f-a54a-09f0da802327',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
    '4. HEALTH & SAFETY',
    'Folder',
    'Health & Safety',
    'building-documents',
    'c8074940-d00d-4ed9-9ce2-b8a741088849/4. HEALTH & SAFETY'
);

-- Contracts Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    'b708ce8e-c43d-4245-9416-b2ea6561302e',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
    '7. CONTRACTS',
    'Folder',
    'Contracts',
    'building-documents',
    'c8074940-d00d-4ed9-9ce2-b8a741088849/7. CONTRACTS'
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
    'cb609482-fcc9-4220-bb6d-de1c2dfdf9c3',
    'c8074940-d00d-4ed9-9ce2-b8a741088849',
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