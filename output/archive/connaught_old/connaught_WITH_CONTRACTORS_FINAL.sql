-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: 32-34 Connaught Square
-- Extraction Date: 2025-10-15 10:31:32
-- Extraction Version: 5.0 - FINAL COMPREHENSIVE
-- Source Folder: N/A
-- Building ID: 39d99eea-3d9d-4a9a-a946-8a61f3b9228c
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
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c', '32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'London', 'United Kingdom', 8, 4, 1, 14, 'Victorian', TRUE, 1, TRUE, 'Gas boiler', TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, 'Registered', 'New Step', 'Jacksons Lift', 'Unknown', 'comprehensive', 0.97, '5.0 - FINAL COMPREHENSIVE'
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
    'aaa075f3-76b7-4504-b349-583da0f21eae',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '9e55f7f5-2ff1-401e-801c-31799a8080f4',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '8b5fa8f6-b2cf-438c-813f-e6288a233c31',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '046f45d3-7af2-4e1f-a942-6371f0b791d1',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '1c69a79b-aa37-4ce9-ae2f-be91ff589ab0',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '5d018e62-9683-45ef-b3e0-d223e045480c',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'a9acfdfe-af96-4c36-9351-dbd5f06556e0',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '93e7aa71-b78c-4fa1-9396-877076947257',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '4ae830f9-f574-4417-82ec-eeec567d797f',
    '046f45d3-7af2-4e1f-a942-6371f0b791d1',
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
    'df981a66-8cfc-4443-9324-8c0423e5375f',
    'a9acfdfe-af96-4c36-9351-dbd5f06556e0',
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
    '77ea5ec8-c846-42db-b2ef-78681d5bb3b7',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'b217bdc6-ee6d-4d2d-a964-d13780386ac3',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'ddbd0299-4d59-454c-81eb-e536ba063167',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'd758de32-818e-452c-8de5-1dec34948fdd',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'cd996639-19ee-40ff-8e63-90233616e915',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'f31a2678-ebcf-4830-9b43-20b45a02ad79',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'fe3538fa-59ce-4b2f-940b-48cc04c81489',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '9081463f-e72d-40cd-85d2-386cef7fd221',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '931517ae-b6ca-401a-8687-b28ac20cbaaf',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'a8169e55-6f96-457e-a288-1ae3516c8977',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '7f9746e6-46cd-426b-bf72-fa90399f480d',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'bbf00b92-32d0-455d-8a49-413fa978ba90',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '3b18881f-b6ad-40e8-be41-f148b01649ae',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '1f218b39-1d93-40c9-974f-c66e3cfbb87a',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '76e52b9e-a0e7-48af-8a0d-75533d199aa0',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'beaf4107-d937-445a-9d23-607bf88bf791',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '9ade54db-5e13-47f7-88dd-e1442e92d3e5',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'ca92723b-282b-4af2-9643-f3aa9f508f58',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'aa45ec74-96d7-438d-ac11-61976796d84a',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '29955acc-92ce-4c27-a235-e57660688674',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'f7367493-8505-44fd-bba1-c6e860f6c928',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '89799680-f4b3-4171-ae9b-a3c6766a1be8',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '9245734e-a5f7-4ff0-9ecb-c0f71046ec86',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'f41d1f8d-6bcd-4726-aba0-63210d11abd1',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '8bc69a75-e514-4867-a3b7-d642bea16262',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'a24dd785-8697-48a4-a1b6-7cb9c10d7f9f',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '3f0c6c12-46f0-4a54-a3e3-e0165cc5d539',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'bafadcc8-93cd-4b5f-9e37-247e274910b7',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'b947f1fd-b642-42d3-96a1-03f428e849b8',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'c73ea43d-4f96-4fbb-b90e-c0b80bace866',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'ff61d32c-06fe-4d50-9d04-693c3690ebad',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '3fa9bc9b-b5f1-484e-b427-53d7ae9002ef',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'e901ace4-e1fa-4b89-b959-233f66c30d66',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '161210c0-6075-4c3b-8f3e-71690f162b6f',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '552ed456-71cb-4b20-81c6-068b0f108a5d',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '7a663cac-5c83-4076-8023-f10bbafbc972',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    'f98d74d4-0fc7-4dc5-9c55-b89ed63d4d01',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '782e76bf-a5ea-43d6-8c3a-a8e5fa8b611c',
    'de8d1edb-32e3-41d0-ade4-f71bda3ab42e',
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
    '9e0084fb-2481-4272-b413-30577ac9bd9a',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '3c3d6e12-cdff-44b2-9432-fdf238e576e0',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '1932a211-b70e-4133-8031-c72d7610f668',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'e57e4e1b-b6b4-4ff4-8f7a-320a89b41557',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '8867ce58-8244-46be-a84a-5f36d2d41a2f',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '44a73b71-c25e-4a76-8fb9-c79ba3123823',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '73bce48a-a628-4f3c-91bf-f8464548f8dd',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    'a6a45318-375d-4806-ad76-13dc309c9378',
    '7.03 STAFF',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.03 STAFF, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '2044c2d7-84a6-44df-816e-fb39819fa2eb',
    '7.02 UTILITIES',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.02 UTILITIES, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'f4e758f9-fe71-4402-8f34-b08a4883f8a9',
    '7.07 DRAINAGE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.07 DRAINAGE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'd3fe821f-1489-4276-99a2-e783c61b1a3d',
    '7.14-CONDITIONAL REPORTS',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.14-CONDITIONAL REPORTS, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '56f6e787-bffe-4b2c-b5b5-8195804d4a6c',
    '7.08 PEST CONTROL',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.08 PEST CONTROL, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '566181c0-b89c-4823-9f1f-17165f221498',
    '7.06 CCTV',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.06 CCTV, Documents: 2'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '2b36cf06-b7da-48ea-b76a-83c93ca05c16',
    '7.11-WATER HYGIENE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.11-WATER HYGIENE, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'eeae81a2-2787-4a81-87a1-107b97b522da',
    '7.12 BUSINESS ROADIO SIMPLE SITE LICENCE',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.12 BUSINESS ROADIO SIMPLE SITE LICENCE, Documents: 1'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '0d881ff6-2e85-4f4f-b243-75bc23692d36',
    '7.04 LIFTS',
    ARRAY['Lift Maintenance'],
    TRUE,
    'Folder: 7. CONTRACTS/7.04 LIFTS, Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'd2b8a431-dbe6-43cc-a05c-a9cc621ff5c3',
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
    'e618df1d-a33a-4677-a401-388414de4687',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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
    '61e8cac2-0836-470b-9633-1e04251d0057',
    '39d99eea-3d9d-4a9a-a946-8a61f3b9228c',
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