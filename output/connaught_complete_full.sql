-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-14 15:53:01
-- Extraction Version: 6.0 - PRODUCTION FINAL
-- Source Folder: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- Building ID: f30670da-7ced-4889-9a4c-783d72fad33d
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
    'f30670da-7ced-4889-9a4c-783d72fad33d', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'Registered', 'production', 0.99, '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE', '6.0 - PRODUCTION FINAL'
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
    '1f7dcb54-5827-463d-b6eb-446627bb6d65',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'e0b51634-ea49-41d5-820d-6719630dd2b5',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '65f27688-4219-4c3a-a725-0fce22447d14',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'b5d51f1d-dbbd-4852-ae21-fff1382a081d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '21388585-2698-414d-8783-7e86f216909d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '3ddfbf2f-bb60-4172-a5d2-35732b39e275',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '1b4511b2-85a3-4f9f-895f-2847379ba44a',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'df72638c-8a78-4681-a6ee-c3c508489c30',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '20088b5a-552c-4671-9f87-0ff8a56145ac',
    '1f7dcb54-5827-463d-b6eb-446627bb6d65',
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
    '987ea256-2e30-4e16-b7ca-2c8754792be7',
    'e0b51634-ea49-41d5-820d-6719630dd2b5',
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
    'fe9039ea-99f0-428f-9a5d-1174021e87c9',
    '65f27688-4219-4c3a-a725-0fce22447d14',
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
    '12b70332-02f7-4e1e-979f-5f6665aad4ab',
    'b5d51f1d-dbbd-4852-ae21-fff1382a081d',
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
    'f12ae349-0ad5-4549-bd7b-e907aea47984',
    '21388585-2698-414d-8783-7e86f216909d',
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
    '2ef22eec-0222-4da7-a485-533f1593a00b',
    '3ddfbf2f-bb60-4172-a5d2-35732b39e275',
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
    '43e9bf9d-8ff7-4bba-8e19-fd2fc1f2150e',
    '1b4511b2-85a3-4f9f-895f-2847379ba44a',
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
    '1aa1e147-1b33-4fa0-b501-4878616cfe76',
    'df72638c-8a78-4681-a6ee-c3c508489c30',
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
    '51bbd08e-3df4-4897-9f0d-d661849cc26e',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '1eb2b9b2-5215-426a-bed2-dc62cd176227',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'd9f82c87-d973-43d6-b373-64dd3988c581',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'c67bc430-1877-404e-9854-5200925dfbbe',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0e2afe1b-abbb-4a96-9266-6815b3bca080',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'dc512d18-e6d8-44ee-9f6b-f8b0fe4241d8',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'ad922c75-ca07-41c4-88a7-63d4ad734883',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '5d14b974-0367-4d87-8059-63cec382c4f1',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'af02ab45-11fe-420d-86cb-20d57b09e8c3',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '19f8455c-8bf4-4e83-964e-769f6a81c572',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '5808bec2-5dc1-4a5d-8217-e0c2c7282810',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0c61027a-91c5-4685-ac12-d9828561b41d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'e1039dd7-a92b-4110-a386-8c9861e8b3b4',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0e587dae-3fc6-4aae-b48b-49bcfb1d3cbe',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '690e1b36-a5d7-4a9d-a292-763b04ecc4c8',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '7df01c06-4515-42b5-8b77-699354ed1d59',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'a3119a96-a4aa-47df-9b8b-0958b1736770',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '53e6b6c6-0e5c-44b8-a6cc-e3f875d7c829',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '760a5766-6b39-45c8-a674-52327f18883d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'f630620e-e754-49ec-a214-7da0ff50cb49',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'e05bfc8b-0899-437c-85b8-bbde2ffed103',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '5ff85a06-1a65-4ad9-ba9c-9adc7fe87a83',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'bdf2a1c2-aaa9-4abf-a334-be079786e4b8',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '7e0c2000-4e96-42a0-a66b-323d3dd8bfe3',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '076bba60-56e1-4e5b-8d9e-3ce6968a2867',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0930be09-0288-45ac-8444-9dbb1d3c2c5d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0e9b519b-2617-435a-9ebf-c792cc2e26ee',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '82a805c6-b931-426d-98b3-bf19f0b24f35',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'ae6bb064-4f73-4eff-8d5d-6d7301c1a748',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '3990e971-a270-4f08-b105-40124c180bd6',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    'e22ccc62-b463-4cdc-844d-d0c432fbfa50',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '0a35694a-6202-4ce3-a151-0ccf5f61137c',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '49c7a917-7982-4e74-b88f-d9539053b19d',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '100b55c8-3f3d-4b32-8230-1e2840de9db5',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '5dbfeb54-26fc-4cc7-9dc2-55f11e4b48b8',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '27539116-45ba-4742-bee5-7c944c124382',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
    '83080274-9c10-4bea-b3a2-a913a9820de8',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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
-- Path structure: building-documents/f30670da-7ced-4889-9a4c-783d72fad33d/...
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
    'fb7bd04f-2a1d-46c8-b74a-bec2935d3020',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
    '1. CLIENT INFORMATION',
    'Folder',
    'Client Information',
    'building-documents',
    'f30670da-7ced-4889-9a4c-783d72fad33d/1. CLIENT INFORMATION'
);

-- Health & Safety Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    '839d8c93-7724-4709-93d0-53e84cc659a4',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
    '4. HEALTH & SAFETY',
    'Folder',
    'Health & Safety',
    'building-documents',
    'f30670da-7ced-4889-9a4c-783d72fad33d/4. HEALTH & SAFETY'
);

-- Contracts Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    '22146106-1662-4ea5-b389-4a1fe1ae2ffd',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
    '7. CONTRACTS',
    'Folder',
    'Contracts',
    'building-documents',
    'f30670da-7ced-4889-9a4c-783d72fad33d/7. CONTRACTS'
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
    '45dc29d7-06f5-43fe-bf5f-96dd4e3dcb73',
    'f30670da-7ced-4889-9a4c-783d72fad33d',
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