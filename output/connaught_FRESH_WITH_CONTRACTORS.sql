-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-15 10:26:24
-- Extraction Version: 5.0 - FINAL COMPREHENSIVE
-- Source Folder: N/A
-- Building ID: aa439d22-a7e2-42b8-bfcd-7a113f17a00b
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
    id, building_name, building_address, postcode, city, country, num_units, num_floors, num_blocks, building_height_meters, construction_era, has_lifts, num_lifts, has_communal_heating, heating_type, has_hot_water, has_hvac, has_plant_room, has_mechanical_ventilation, has_water_pumps, has_gas, has_sprinklers, has_lightning_conductor, has_gym, has_pool, has_sauna, has_squash_court, has_communal_showers, has_ev_charging, has_balconies, has_cladding, bsa_registration_required, bsa_status, cleaning_contractor, lift_contractor, property_manager, data_quality, confidence_score, extraction_version
)
VALUES (
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, TRUE, 'Gas boiler', TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Registered', 'New Step', 'Jacksons Lift', 'Unknown', 'comprehensive', 0.97, '5.0 - FINAL COMPREHENSIVE'
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
    '32fce8ec-01ee-458a-bbcf-707208b1cd92',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '6018fd49-4e54-495b-a2f9-04a44c7e8c5a',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '961bed40-a528-408c-bde0-ab3895d99876',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '4cb50de5-26af-481f-8439-4bfba54db115',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'c6cb536a-2165-4489-8ed6-200efba5e5f0',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '7c1b9b29-edc6-444c-b6b2-9e05b1df8b80',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '02d14115-174b-482b-bdb0-5e5b5e65a820',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'f97fd28b-6b85-41a4-b305-78b07530e195',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'f4b91b91-30ec-4187-8111-6163cde07c97',
    '4cb50de5-26af-481f-8439-4bfba54db115',
    'Title Number',
    '',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'c15778a3-080f-4f2f-882c-a3365ca90a0b',
    '02d14115-174b-482b-bdb0-5e5b5e65a820',
    'Managing Agent',
    '15 Young Street, London, W8 5EH',
    '',
    '',
    'Current',
    0,
    '',
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
    'd72f2a22-1878-43bc-9d22-b31a4c6d6183',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '46a63a60-1146-4b90-8604-d71de599ba7d',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'be683fd4-bf29-44ba-9b75-86ada11e23f0',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '76499732-074f-477f-940c-f92919acde55',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'ef8941cf-3654-4e8f-94cd-f8d63e148f36',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '8e4be271-98dd-4ddd-a05c-04e8d3b0e5d5',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'f1d254c6-5b9b-420b-bf70-f827feb7fa7d',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '414f96bd-f893-4c59-a985-c0a8816e9688',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'eea0124f-432a-4988-bd34-d1985997ec86',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '2e20793a-b90c-4442-8170-96bf893c28c8',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'e31b9acb-d639-46de-abc2-9823636fa669',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '3b5344a6-1053-4410-9151-bd3e46a30b85',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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

-- EPC
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '16149c65-46f3-4956-81e0-9f00bbc81e6f',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
-- Budget (with 26 line items)
-- ============================================================================
INSERT INTO budgets (
    id, building_id, budget_year, total_budget, 
    status, source_document
)
VALUES (
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '0faa3972-9203-49ac-9f30-c594a3fdc53e',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '91ad5fd9-652d-4489-b0ea-e9b148cb4562',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'a15419a6-12fd-47f8-a5a2-6ab4eb82b9c1',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'aa3f54fe-ab27-47ea-99e4-2a39e61f2022',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'a9ff0a03-583c-4240-bc0e-c45bb0015854',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '2563be60-b7c0-4ea6-9a5a-a8a5b24a5b7a',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'af517ade-7ee6-4e54-b334-64f53baab9ca',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '3704fc5b-5450-4841-83ac-200688fd6111',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '5358deee-7fc8-41b0-9a09-670d1bf13ad7',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '4c0df67f-6eda-4045-b095-679fc72bf0bb',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '7b0ca36c-b767-4d75-8663-e65c850035ca',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'd0a8c874-8d92-45bf-ac97-393793ac5bc6',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '5044163e-403d-4f71-a90e-60f03b581a83',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'abd99a66-e4c0-47f3-a0ff-47cec5ffa1d4',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'c7609dc8-02eb-4860-8244-b75dcb4634de',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '9b742677-eaa6-4f23-93a5-d933d76d0a4d',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '3e919d31-2a69-4d28-8e45-f351592f9ddb',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '78ccef63-e81f-46c2-ae43-f80929bdd67d',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '272d7296-f0ab-405e-93af-8acc83d4864d',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '88ecf225-b610-44c0-aa6a-6cfa2ae3209d',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '615ecef0-94e7-4713-89bc-4e1cd4a4f309',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'bcaa601f-5f2c-495f-a3f9-476016463537',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    '68d69fa4-6f65-404b-8c69-84f742358655',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'd79c5a0a-61d0-46fc-acb9-968f50bcc686',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
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
    'e4fc5a7a-88aa-4396-9cfe-6cb3065c8e90',
    '59b28b36-fe62-4d17-b654-ff2cacad73b5',
    'Out of Hours Fee',
    'ADMINISTRATION',
    26.0,
    0,
    26.0,
    NULL
);


-- ============================================================================
-- Insurance Policies (Supabase: insurance_policies table)
-- ============================================================================

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '030fe3df-2484-45aa-90f4-340ea4128286',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'd82470f6-b043-4c26-92ea-11a1bf165952',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    'd34405c5-8fd8-4601-91c7-95866ff88907',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '04054637-83fc-42c2-bfe2-b0043ebe19c0',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '834549b2-dc9b-418f-8066-25d9ea74e143',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '3535f355-c2c7-45ff-b3aa-1bfe81eee741',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '13391186-b793-4f06-86c6-b6dd98315114',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '0848b0ad-06ab-4b5b-90ab-4b9dd6d7499b',
    '7.03 STAFF',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.03 STAFF, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '302d38b0-1f5f-4559-87d6-45297f8db5ca',
    '7.02 UTILITIES',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.02 UTILITIES, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '424e1721-a4be-4545-a580-4ecdcf726f39',
    '7.07 DRAINAGE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.07 DRAINAGE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '91b41866-d859-4710-926a-76138db7187d',
    '7.14-CONDITIONAL REPORTS',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.14-CONDITIONAL REPORTS, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '81aff6ba-cabd-451a-96ad-9bc8e76f56c4',
    '7.08 PEST CONTROL',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.08 PEST CONTROL, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'ff1f289d-b1b2-4f12-91a3-95b32461209a',
    '7.06 CCTV',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.06 CCTV, Documents: 2'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '47fbb740-e79c-4a98-a9ff-0beb903dc2e1',
    '7.11-WATER HYGIENE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.11-WATER HYGIENE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'cfc8e921-f110-445d-9986-8781d0fa97b7',
    '7.12 BUSINESS ROADIO SIMPLE SITE LICENCE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.12 BUSINESS ROADIO SIMPLE SITE LICENCE, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'cc4b27db-af79-4ac8-8a3f-24a2cc73860d',
    '7.04 LIFTS',
    ARRAY['Lift Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.04 LIFTS, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'f5351aaf-29c8-4b9f-bfc1-9a9a4c362ef7',
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
    '553c5dff-1753-4a92-ba07-fa4e9d68e7b8',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
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
    '235c4532-fcde-4ac3-9dfc-fecbe8115f43',
    'aa439d22-a7e2-42b8-bfcd-7a113f17a00b',
    NOW(),
    '5.0 - FINAL COMPREHENSIVE',
    8,
    2,
    13,
    0,
    'comprehensive',
    0.97,
    0,
    0,
    '',
    'Success'
);