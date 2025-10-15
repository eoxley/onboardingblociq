-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-15 10:31:21
-- Extraction Version: 6.0 - PRODUCTION FINAL
-- Source Folder: N/A
-- Building ID: 7883fde1-fec2-4ad4-a5d8-f583c12a49c0
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
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Registered', 'production', 0.99, '6.0 - PRODUCTION FINAL'
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
    'c4025e49-b2da-4a65-b739-71867ea70b3a',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '1320c26a-24b3-4c27-9c86-422b8549da51',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '200eb965-1e94-4697-ac30-eaab91345c1d',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'a02eeafc-d69c-446b-abff-daa3b26e4822',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '48b4d8e5-d141-4d02-bb7a-fd2dcf61b097',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '8a6d6ddb-8d52-4f72-ad43-9e9922d97a0c',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '666a501f-9153-4bc7-9894-e1ed9ea096c8',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '98dbb13f-ea5c-46f5-bc0b-e3bb07747b23',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '14264df6-2683-47fc-8fee-0252d04feff2',
    'c4025e49-b2da-4a65-b739-71867ea70b3a',
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
    '89a833be-a5e1-4dab-9d31-f144bda223d2',
    '1320c26a-24b3-4c27-9c86-422b8549da51',
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
    '135b15bb-9582-4f02-8fcf-93cce239782f',
    '200eb965-1e94-4697-ac30-eaab91345c1d',
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
    'aa23af3d-11c6-4b06-8847-69292ac1fa79',
    'a02eeafc-d69c-446b-abff-daa3b26e4822',
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
    'e06e11ea-a459-42c5-8c11-ff8f21df2a29',
    '48b4d8e5-d141-4d02-bb7a-fd2dcf61b097',
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
    '5af425e0-08b6-4793-86d0-eb9b645802ab',
    '8a6d6ddb-8d52-4f72-ad43-9e9922d97a0c',
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
    '594ae5c2-b9a6-4ee0-9c8d-4b1e4116fa4b',
    '666a501f-9153-4bc7-9894-e1ed9ea096c8',
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
    '9995fc17-534d-4e2e-9d94-c3da18d3cad0',
    '98dbb13f-ea5c-46f5-bc0b-e3bb07747b23',
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
    'fee93d2f-706b-4fe0-a84a-9ccdd6474c29',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'd0bded54-b8b1-4ea4-8320-d6be99667c6e',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '44c190d5-0d49-4928-9aea-1dfd9ad18f78',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '35bdaad8-6855-4643-8b24-7b1aa536bbbd',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '7658644e-1e33-43b9-90e2-10f0325e1893',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '956ce68c-a8cd-4015-b6eb-db647419ca1d',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '700a1697-b4a9-413e-88ab-f9bfb30ca3b6',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '05aec1bd-a6a3-46c4-a7b0-e5b23eefe369',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '1586be78-cecf-4ea0-8f7b-0a99cf9cf1a2',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '11ce58a3-7548-4e74-befa-0ad20494db58',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'a21f570e-dd64-4082-a6a2-0160157bfc60',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '0d90f2b7-ddc7-4455-b245-b9e418a19406',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'd65953a4-952d-44df-8e6a-8d6e3c95ae40',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '2b554df1-1043-456b-a57c-c00148aaf93e',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '6b7a762a-23c4-4095-9b3a-3ebcc34a4683',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '3fdc871b-cf66-4e51-8762-4749a7a0ce80',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'a107e861-8032-4521-904c-c4934c7e9154',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'fb73321e-9815-4e0c-9373-c741c045181f',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '3223cbe4-bd66-425c-b182-38a5300e54b6',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '0ee1ce09-bb92-459e-a5b0-d383f959a6ec',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '8c5c1604-a922-465b-83ac-2ffe86fd4fa2',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'bdc292e4-3d9b-4c80-8056-57aebbc94140',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '5f6c8939-bb70-41db-9007-c19e465e90c6',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'b433c479-87e3-4d22-9aec-e39ba8d13c7d',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'f5649f76-2f5a-4155-a5a6-a05432662cf4',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '1d7d27e2-1c69-4e23-9ace-2cf30c41ba07',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '04f174f0-9573-471d-aff1-9360141350b5',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'b501581c-6b65-43e6-8a4d-827a5350051c',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'f283a799-ed61-468f-a4f5-7ef54ddd6903',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '6fda08fd-1cbc-4ea1-8cdb-24830fae234f',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '5c393405-7a0d-4b55-81ad-d14bbaf0daa7',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'fcaabc45-50d2-4ec4-898a-addc0c5d241c',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'b8c64eea-622b-4796-b372-da77aa6dd6ff',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'b6e602e0-c6dd-490e-98ea-8305e03afd6b',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'd1a38d10-29ef-46c0-9aa2-cf6a2451c3dc',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '9442b766-4ecf-4d04-941c-7a9d7ad2662c',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '4f788a54-652e-4e66-abdf-fefe3e5237a6',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '6c539bda-f75b-48da-965e-97e7537f61c9',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '08d0238e-dcd7-4aab-8839-b2854b9fdf40',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '3829a43c-a21d-4452-9b37-cb336c09b703',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '0484c583-1675-40cf-a758-6fc162a3b5a0',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'cce3cfc6-e1da-4924-a82f-a7befb970030',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'fd45fcbe-d49f-4e8b-8b7c-3e07e130df9a',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '255477fe-8964-4a94-ad12-d92321cdf6ab',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '389d7dc7-fc77-4507-ba44-dd3ae4f6ba1f',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'cdeb25f3-f78e-4819-8b63-7fb71f9cb00f',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'ee799109-fd32-49ab-8c10-685a7c8ee95c',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '71a3b765-2b99-4b52-9cf4-a41efa79a934',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '945d71b6-e7fc-400a-945c-90d145f21cfa',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'fad02f85-b151-406f-937e-6e5990c01f5f',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '2a3ae8ac-45db-4053-b38e-6008e1ba3836',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '3234fb25-d685-4f09-bff5-bcc78dbc394f',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'bc19467f-fd79-46fc-b18c-74ad1c6235c3',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '1dff5a8f-3e68-4ae8-bf90-3a89c10923dd',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'cad2e1b9-40a5-4da8-b37c-304da4f3e4b6',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '7a51093b-7817-4979-abef-6cb371a9e844',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '5cb14bab-1630-4d67-99d5-1f4f250ac217',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '8ffaf32d-e3c1-42d3-934c-a8782d622eb6',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'b54e47ae-dab4-4e71-84e9-12c35a1e3e02',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '355bf8e6-cbf0-4901-88b6-8ca43e845357',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    '0add5b60-0228-4b20-8e55-2281d782c4f7',
    '4311d804-3a0e-4070-9373-2de3612cc7d8',
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
    'd5c2aa08-ed6a-449d-8810-805b931111ab',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    'd4b8048f-0435-4f5b-80b2-508a0857e3c4',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    'f0ad5403-b652-41bf-933c-580803ca74d2',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    'c0f45650-fff9-4235-8a0f-dac51e12beb4',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    'd84ec4fb-9a07-46dd-8255-e704057f4733',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    '260d96a4-9739-4da8-ad56-55ab1e2ceec8',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'a3e173da-d31d-4007-aa9f-cf8e87206179',
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
    '7f634ca1-b31e-48c1-9090-42335fdd31c9',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'da678ea1-5ecd-43e8-ac4e-367c0889e3c6',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '510d50f8-45a8-4e98-8931-9c9ad21e0136',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '735cb708-3cbc-4f27-bbd4-d1e92c551ec8',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'cd8caa27-a009-4ee9-b082-a6b1d66c3bcc',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '420ea5f7-4337-4e47-a695-42c2f067c7a6',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    'eea62b70-5262-4192-8035-3043d1b00917',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
    '68dc019c-f481-4559-8ea8-ebc010642ab6',
    '7.03 STAFF',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.03 STAFF, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '77e25114-d783-44d7-b798-c80724b1665a',
    '7.02 UTILITIES',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.02 UTILITIES, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'de03ef0e-11fb-4cb6-bebd-65ea408c5298',
    '7.07 DRAINAGE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.07 DRAINAGE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'f8ef686a-00d6-4f8d-8a37-740238d7a25d',
    '7.14-CONDITIONAL REPORTS',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.14-CONDITIONAL REPORTS, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '14924b76-f425-446d-a394-ef55749900bb',
    '7.08 PEST CONTROL',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.08 PEST CONTROL, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '10fb84d8-abb0-47b8-b39c-ad8c63ff449e',
    '7.06 CCTV',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.06 CCTV, Documents: 2'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'ef8250e2-a9fd-475c-98c6-0fe6d95232b1',
    '7.11-WATER HYGIENE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.11-WATER HYGIENE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '182b7601-12b3-4a27-aea4-3fc8e0281c32',
    '7.12 BUSINESS ROADIO SIMPLE SITE LICENCE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.12 BUSINESS ROADIO SIMPLE SITE LICENCE, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '1555696f-5aa3-4fb3-a36b-a6a04fe62b66',
    '7.04 LIFTS',
    ARRAY['Lift Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.04 LIFTS, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '6f1a7afa-fc6c-4570-bd23-80e0d4602da5',
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
    '87cff9d9-ae48-4120-bb4e-41010b676aa0',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
    'Major Works Project',
    'Detected from documents folder',
    'planned',
    FALSE,
    0,
    '6. MAJOR WORKS',
    5
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
    '9501dc81-3590-48d3-b8c9-189939067d07',
    '7883fde1-fec2-4ad4-a5d8-f583c12a49c0',
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
);