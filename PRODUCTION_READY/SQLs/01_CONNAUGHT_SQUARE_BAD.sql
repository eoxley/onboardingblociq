-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T16:02:30.611541
-- Building: 219.01 CONNAUGHT SQUARE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    '219.01 CONNAUGHT SQUARE',
    NULL,
    NULL,
    0,
    1,
    NULL,
    FALSE,
    'Not HRB',
    'and use of the premises',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Budgets (1)
INSERT INTO budgets (
    id, building_id, budget_year, total_budget,
    budget_period_start, budget_period_end, status
) VALUES (
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    2025,
    124650.0,
    '2024-04-01',
    '2025-03-31',
    'final'
) ON CONFLICT (building_id, budget_year) DO UPDATE SET total_budget = EXCLUDED.total_budget;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f6bb2fdc-e956-428a-95c7-d981b4c099fd',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'utilities',
    'Utilities - Electricity - power and lighting internal',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '486dec41-4826-44f8-8e58-7d08878c43bc',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'utilities',
    'Utilities - Gas - heating/hot water',
    15000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '9ea36f1a-9f28-47f3-846a-81fe086a7dbc',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'cleaning',
    'Cleaning - Communal',
    27000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '5e56ff92-58ae-418d-a7d5-74179f4a8cf1',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'repairs_maintenance',
    'Repairs - General',
    5000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a1e3db1a-1894-40aa-ae90-fbdb46d42676',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'repairs_maintenance',
    'Maintenance - Drain/Gutter',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f0fd5a86-5362-4b1c-9116-e8e542f41c80',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'repairs_maintenance',
    'Maintenance - Fire Equipment',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '0cac86e9-dcf2-4336-bf8e-626f61177a6e',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'utilities',
    'Maintenance - Lighting',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '37d229f3-3c02-4b64-8123-a52a04fdedca',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'utilities',
    'Maintenance - Communal Heating',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'c27f4064-b740-4e18-8fd4-3970986384f9',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'lifts',
    'Maintenance - Lift',
    3500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ef495239-3ad0-4ac5-b077-5b0f3c4f9c65',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'other',
    'Pest Control',
    700.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '274feb98-3aeb-4dc5-a682-db60a73a2fb8',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'other',
    'Asbestos Reinspection',
    570.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '21d9c377-b023-45ee-a479-51c1fc94051b',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'utilities',
    'Water Hygiene',
    2200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ec081632-9007-4247-b58e-d42e3222485b',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'insurance',
    'Insurance - Buildings',
    17000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'baa0ffac-a9b2-4073-8efd-2de678aea3d8',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'insurance',
    'Insurance - Terrorism',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '9474f390-eb84-42e2-99e3-0ac4ec8b0ac7',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'insurance',
    'Insurance - Directors & Officers',
    290.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'addf5e43-9a3d-4749-a750-3b071ec91a4c',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'insurance',
    'Insurance - Engineering',
    560.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ec129524-428a-42ca-87ad-aecd65fbd97c',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'professional_fees',
    'Accountancy',
    1200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '1d90ad45-cafe-404a-998c-afbedc471161',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'professional_fees',
    'Professional Fees incl Co Sec Admin',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '02df8a03-4cab-45fc-b684-0c3067830b8c',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'professional_fees',
    'Company Secretary',
    480.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '7f1db269-5e8a-4e8a-9b27-f83e086e66a1',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'other',
    'Bank Charges',
    100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '64f4a53d-3c56-47e7-9ca5-f5a1aa7aa79a',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'compliance',
    'Health & Safety',
    950.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'bc88943c-a293-469d-95bf-74d79d38f7c7',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'management',
    'Estate Management Charges - Connaught Sq',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '87edf5f0-af1c-450c-b27a-fe6f227fec44',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'gardening',
    'Maintenance - Garden Charge',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'd6470a8a-02fd-4f6f-a224-234998b901e2',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'insurance',
    'Insurance Valuation',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '6e5311ad-fc65-4e2e-80a5-53d9e74cd6f7',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'management',
    'Management Fees incl VAT',
    5500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '127aac92-e992-464f-b062-e85f78e87df5',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'management',
    'VAT on Management Fees',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'd32581c2-147d-48d8-af35-2dc4d2680f33',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'other',
    'Out of Hours Fee',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '50ee92e3-d315-4748-a709-acc82ac9d4f1',
    'dd060a12-fdea-436b-bcd1-99b06bc127de',
    'reserve_fund',
    'Reserve Fund',
    25000.0
) ON CONFLICT DO NOTHING;

-- Compliance Assets (7)
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '18c6ccd9-529d-4af9-a677-67ce8bf1bc1b',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2025-08-26',
    '2027-08-26',
    'Unknown',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'addf7f29-5308-4c46-9c0d-012f5465226d',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2023-05-05',
    '2028-05-05',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'EICR';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'e8eb3273-9d15-48eb-9e55-7877d94e0c52',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2025-02-21',
    '2026-02-21',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '36e4bd4b-a494-46d6-875b-82f7ca5da20b',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2024-01-24',
    '2025-01-24',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '784e78d2-19b3-41a3-ac4e-4fd5793b7f64',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2025-07-25',
    '2026-07-25',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'c8d74b4f-8313-4dba-b5c7-181806fea220',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2025-07-22',
    '2026-07-22',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'daeb7ff6-a1d6-4650-acaf-db987fea6829',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    '2025-07-03',
    '2026-07-03',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';

-- Maintenance Contracts (5)
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'd962826f-83fb-483c-8004-4182081d45d2',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    's and each 
contractor engaged to provide services',
    '01/04/2025',
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'cdd7c2ca-0e3c-4766-8e05-a4b19e5136cd',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '46347209-0457-4d3f-81b1-e79884c49f47',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    's and each contractor engaged to provide services',
    '01/04/2025',
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '1b713d46-eda4-4ef6-a789-f7060d1725d3',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    's and each 
contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'c453554e-1e45-49f9-969b-2fdb1a8486d5',
    'e3652671-36b9-4df8-bba2-a39236d32ba1',
    id,
    'is undertaking works to the services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';

-- Contractors (7)
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '92a59095-2a47-4192-983f-7db4b2c67f6c',
    'New Step',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'bbf23636-ae01-46bf-946a-b1a0d4f59df8',
    'Crown Gas And Power',
    {"utilities"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '54d2bcb6-89b6-404d-90b1-ce1e9e19d951',
    'Positive Energy',
    {"utilities"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '6a42db00-f15b-4a76-a2d6-4ba50f26d944',
    'Jacksons Lift',
    {"lifts"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'd159d37f-7402-4dcf-aa81-50cfa0b7153f',
    'Water Hygiene Maintenance',
    {"utilities"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '8d8d276b-aa32-4fa7-8e0c-391097ad1b84',
    'City Maintenance',
    {"repairs_maintenance"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'ac5139ee-9e20-4611-be2f-3f7d2561a7b1',
    'City Spec',
    {"other"},
    TRUE
) ON CONFLICT DO NOTHING;
