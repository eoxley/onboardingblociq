-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T13:57:23.300819
-- Building: CONNAUGHT SQUARE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'CONNAUGHT SQUARE',
    NULL,
    NULL,
    8,
    1,
    NULL,
    FALSE,
    'Not HRB',
    'and use of the premises',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Units (8)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '98c800fb-8db6-448c-9b7a-83f971b93924',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-001',
    21,
    13.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cffed73b-4fac-48d4-b04f-2879ae3bb5b9',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-002',
    21,
    11.51,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '851a2289-9f54-47f7-87bc-4205158c7456',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-003',
    21,
    12.18,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9b063728-c1d0-4543-8ba8-c6cfccf0d184',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-004',
    21,
    11.21,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9ee65e9f-8377-4791-b33e-4c6551cdcc45',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-005',
    21,
    11.75,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7ebf09b3-3c1f-4e91-873a-4c44a9bf9402',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-006',
    21,
    24.13,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '27530c5d-960f-4a80-a25f-c6d011e84e40',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-007',
    21,
    9.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '37fe23d5-7e08-4fdd-a2e7-2f72c4b58c26',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '219-01-008',
    21,
    6.0,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (8)
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b7c042c8-a017-4460-948c-66a71f812780',
    '98c800fb-8db6-448c-9b7a-83f971b93924',
    'Marmotte Holdings Limited',
    'Flat 1, 32-34 Connaught Square, St George''s Fields, London, W2 2HL',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6da6404d-aecb-47f0-94d2-24e3480e36da',
    'cffed73b-4fac-48d4-b04f-2879ae3bb5b9',
    'Ms V Rebulla',
    'Flat 2/3, 32 Connaught Square, St Georges Fields, London',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '970e396e-79a4-4b1c-9038-fda16ce4baba',
    '851a2289-9f54-47f7-87bc-4205158c7456',
    'Ms V Rebulla',
    'Flat 2/3, 32 Connaught Square, St Georges Fields, London',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '19e4968b-488f-42c8-a8fd-74ecfabf17b1',
    '9b063728-c1d0-4543-8ba8-c6cfccf0d184',
    'Mr P J J Reynish & Ms C A O''Loughlin',
    'Flat 4, 32-34 Connaught Square, St George''s Fields, London, W2 2HL',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e38b3c64-123f-4d5d-9e9c-e52c06a65551',
    '9ee65e9f-8377-4791-b33e-4c6551cdcc45',
    'Mr & Mrs M D Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    NULL,
    '07768 803 607'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ac6a97ee-7094-4ab4-81f5-7c976953859a',
    '7ebf09b3-3c1f-4e91-873a-4c44a9bf9402',
    'Mr M D & Mrs C P Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    NULL,
    '07768803607'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f9438f74-ba59-4cdd-9cf1-c524663cba4b',
    '27530c5d-960f-4a80-a25f-c6d011e84e40',
    'Ms J Gomm',
    'Flat 7/No 34, 32-34 Connaught Square, London, W2 2HL',
    NULL,
    '07912758299'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '098b7bdf-2a60-44be-9734-8a2d6e6ac71f',
    '37fe23d5-7e08-4fdd-a2e7-2f72c4b58c26',
    'Miss T V Samwoth & Miss G E Samworth',
    'Glemscot House, Brawlings Lane, SL9 0RE',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Budgets (1)
INSERT INTO budgets (
    id, building_id, budget_year, total_budget,
    budget_period_start, budget_period_end, status
) VALUES (
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    2025,
    124650.0,
    '2024-04-01',
    '2025-03-31',
    'final'
) ON CONFLICT (building_id, budget_year) DO UPDATE SET total_budget = EXCLUDED.total_budget;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'd78f935c-1d58-474d-a6e1-0b5bd033b052',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'utilities',
    'Utilities - Electricity - power and lighting internal',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ea7a7882-47c8-403a-a9a2-d75326659d7a',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'utilities',
    'Utilities - Gas - heating/hot water',
    15000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ddb72613-7f94-4a38-9ee8-02c5a46a71f0',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'cleaning',
    'Cleaning - Communal',
    27000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '0bb819c1-646f-4b4a-83b6-3ef7c8980a7d',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'repairs_maintenance',
    'Repairs - General',
    5000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e5d082d2-2aa6-43f7-8955-8df9631b94e7',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'repairs_maintenance',
    'Maintenance - Drain/Gutter',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4ad8211e-bcd3-43bb-817e-bca0e1d34404',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'repairs_maintenance',
    'Maintenance - Fire Equipment',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'd3dd58d3-f13f-46d8-8fc7-a312e3fb1d78',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'utilities',
    'Maintenance - Lighting',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '2b7b6a06-6079-4ed3-9a2b-9d769c5b0927',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'utilities',
    'Maintenance - Communal Heating',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '1d73f334-a299-4399-81fc-23d6bbdb963c',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'lifts',
    'Maintenance - Lift',
    3500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '09c3923d-8c3e-484a-a75b-1b1d8ab14487',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'other',
    'Pest Control',
    700.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a37f34d7-6bc8-41ae-abff-36e54d2ef0aa',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'other',
    'Asbestos Reinspection',
    570.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'feec4e81-fd7e-4bdf-9fff-6f7596f1978c',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'utilities',
    'Water Hygiene',
    2200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '344a4414-32d2-4878-b636-a1d8e51eaa12',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'insurance',
    'Insurance - Buildings',
    17000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '1d5d0bee-c567-442c-8232-bff8a364cd0f',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'insurance',
    'Insurance - Terrorism',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '179bcb6f-2493-413f-9baa-256c853faa11',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'insurance',
    'Insurance - Directors & Officers',
    290.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'bdced5e6-6143-41ea-93dd-91b2b78e8fc2',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'insurance',
    'Insurance - Engineering',
    560.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '639aaab8-ddff-49d1-9d6c-d8fb56f3b1d5',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'professional_fees',
    'Accountancy',
    1200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8de6aa7c-62f6-4280-bb08-a643239ecd0b',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'professional_fees',
    'Professional Fees incl Co Sec Admin',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '5ab0e0cf-c8d6-4f37-8e86-c94cea97cfa2',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'professional_fees',
    'Company Secretary',
    480.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '75124f6a-3273-49f6-b0fe-0e021e226a6a',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'other',
    'Bank Charges',
    100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4b208a21-212e-4faf-9a56-6fb1fc5d64b4',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'compliance',
    'Health & Safety',
    950.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '61e04650-7acf-4897-a223-dfc4507202c0',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'management',
    'Estate Management Charges - Connaught Sq',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '01a02eae-670e-48df-9acc-d726fc73e61b',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'gardening',
    'Maintenance - Garden Charge',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '78307745-7193-4c5c-adc3-3f2a8b4fd535',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'insurance',
    'Insurance Valuation',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ffc74176-3d78-4185-95c8-551bd1542312',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'management',
    'Management Fees incl VAT',
    5500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f29abfa7-4568-4445-9939-d54bfcfba285',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'management',
    'VAT on Management Fees',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4447756a-5423-4bd2-adfa-c13ae010e38a',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'other',
    'Out of Hours Fee',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '787109d5-04c4-4a93-b935-efd4cc2669d8',
    'ad289906-8da1-4e72-8c3e-642cb7d0904a',
    'reserve_fund',
    'Reserve Fund',
    25000.0
) ON CONFLICT DO NOTHING;

-- Compliance Assets (7)
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'c6193d20-6631-4b17-95e1-4873695b3391',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Legionella Risk Assessment',
    'legionella',
    '2025-08-26',
    '2027-08-26',
    'Unknown',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '9d679a3f-ba01-47ec-9dfa-0862bd1dd895',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'EICR',
    'eicr',
    '2023-05-05',
    '2028-05-05',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'b2c47a10-6ab5-4b3f-a50a-229934506038',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Fire Risk Assessment',
    'fire_risk_assessment',
    '2025-02-21',
    '2026-02-21',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '1fe378f0-e826-49fb-a6cd-493c24f953bf',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Fire Door Inspection',
    'fire_door_inspection',
    '2024-01-24',
    '2025-01-24',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '50999929-aeeb-474d-ac0b-7190a42bea3e',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Gas Safety Certificate',
    'gas_safety',
    '2025-07-25',
    '2026-07-25',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'e5139fbb-2b56-4d9c-80c8-2aba8438da82',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Asbestos Survey',
    'asbestos',
    '2025-07-22',
    '2026-07-22',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '726d48a5-25c7-45c7-a70c-b8bd92eeadde',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Emergency Lighting Test',
    'emergency_lighting',
    '2025-07-03',
    '2026-07-03',
    'Pass',
    NULL
);

-- Maintenance Contracts (5)
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '02788ba2-2aff-411c-95b9-272b165e260b',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    's and each 
contractor engaged to provide services',
    'cleaning',
    '01/04/2025',
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'e9637b05-1f41-417d-bee8-475b03dbcd41',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    's and each contractor engaged to provide services',
    'security',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'ee13c496-1b0e-4866-b95a-942c6ab05c76',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    's and each contractor engaged to provide services',
    'security',
    '01/04/2025',
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '0e10b379-b322-4f5b-8c42-e7a0d872c175',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    's and each 
contractor engaged to provide services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'a53f1290-189c-4514-9938-326bb6e9a41e',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'is undertaking works to the services',
    'cleaning',
    NULL,
    NULL,
    NULL
);

-- Service Charge Accounts (1)
INSERT INTO service_charge_accounts (
    id, building_id, financial_year, year_end_date,
    approval_date, is_approved, total_expenditure
) VALUES (
    '40547013-f898-436e-98ab-92f2bee62cd2',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    '2031',
    'YEAR ENDED  31 MARCH  2022',
    NULL,
    TRUE,
    NULL
);

-- Contractors (7)
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'd3e893c3-36be-4f5c-b5dd-8cab110f93e5',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'New Step',
    '["cleaning"]',
    54000.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '290b6b7c-75b4-48d6-9125-9babfbecb084',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Crown Gas And Power',
    '["utilities"]',
    30000.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '04212a68-d7f7-49ec-86f5-5ebbaf576bbc',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Positive Energy',
    '["utilities"]',
    8000.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'ac7d13d4-4969-43e8-827a-51f88eca9e98',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Jacksons Lift',
    '["lifts"]',
    7000.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '319c1eb7-316e-473f-82c3-4c9064b01a2d',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'Water Hygiene Maintenance',
    '["utilities"]',
    4400.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '39529bde-10b1-4a8d-a9c8-a293abff4ebb',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'City Maintenance',
    '["repairs_maintenance"]',
    4000.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '4838c35a-aaf5-4bb4-bf96-7f1239544419',
    'b86b4935-83a0-4160-9e55-135f0c24b05a',
    'City Spec',
    '["other"]',
    1400.0,
    TRUE
);
