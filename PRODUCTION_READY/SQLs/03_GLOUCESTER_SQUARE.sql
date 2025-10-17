-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T14:09:02.660773
-- Building: 162.01 48-49 GLOUCESTER SQUARE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162.01 48-49 GLOUCESTER SQUARE',
    NULL,
    NULL,
    5,
    1,
    100.0,
    FALSE,
    'Not HRB',
    'effect and enforceability of the Agreement shall be governed by English Law, and the p arties agree',
    'Georgian'
) ON CONFLICT (id) DO NOTHING;

-- Units (5)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e954238c-6856-4cf4-9b66-da9206214589',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162-01-001',
    16,
    14.29,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4b47670e-f7e4-4d1d-ace0-176da0dff637',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162-01-001A',
    16,
    16.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f385b055-7f14-4373-8ded-6f45d11bfc5f',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162-01-002',
    16,
    33.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9d9dcae9-140b-491b-8ae9-5a1fbaa2339d',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162-01-003',
    16,
    19.18,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '62a2da48-fc69-412c-9372-c09ff7aef03a',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '162-01-004',
    16,
    16.91,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (5)
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '816da747-f952-47b2-a2ea-3332e696f735',
    'e954238c-6856-4cf4-9b66-da9206214589',
    'Ms H Boy',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6feaf438-2ce2-4b45-aab5-6c3f2cc4facf',
    '4b47670e-f7e4-4d1d-ace0-176da0dff637',
    'Michael Menaged',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '27dc8dba-c54e-468d-9f48-0859c11151fa',
    'f385b055-7f14-4373-8ded-6f45d11bfc5f',
    'Mrs Mei Ling Lee',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9d43085e-ad37-40b9-9167-788b21ba0313',
    '9d9dcae9-140b-491b-8ae9-5a1fbaa2339d',
    'Mr P Gullestrup and Mrs H Gullestrup',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '805643ef-92e9-45b2-8d77-c4b2e5b9db34',
    '62a2da48-fc69-412c-9372-c09ff7aef03a',
    'Mr S C Hopkins and Ms W L Hopkins',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Compliance Assets (6)
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '8df23ac2-1e8a-499e-91ec-02da162c8df6',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Fire Risk Assessment',
    'fire_risk_assessment',
    '2025-04-08',
    '2026-04-08',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '8dbeb63f-116e-4029-acea-471d8be2ee17',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Legionella Risk Assessment',
    'legionella',
    '2011-07-27',
    '2013-07-27',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '42d969fe-a634-440a-8691-063c31de4018',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'EICR',
    'eicr',
    '2023-09-05',
    '2028-09-05',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'd602cb9d-9e15-432b-8238-f0ed592c4a30',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Emergency Lighting Test',
    'emergency_lighting',
    NULL,
    NULL,
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'f7efc15b-9af1-4e84-9f7a-aeecd0bc24e3',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Lift LOLER Inspection',
    'lift_loler',
    NULL,
    NULL,
    'Advisories',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '04b1e0e9-ff85-457e-9299-a25a4f53aefe',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Asbestos Survey',
    'asbestos',
    '2023-04-19',
    '2024-04-19',
    'Advisories',
    NULL
);

-- Maintenance Contracts (14)
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '6f81941e-8add-47b8-9070-74c2c06b9056',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'HESKETH STEEL FABRICATIONS LIMITED',
    'lifts',
    '16/10/23',
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '44ac90f2-5384-4756-91cf-38333876348e',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Ltd via Corin Underwriting Limited',
    'general',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '565f4854-8bf7-4b0e-bfc9-d90c0e68a650',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Manchester Galvanizing Ltd',
    'fire',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '63c711b8-31b8-4edf-a2e3-5235382a0352',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'HESKETH STEEL FABRICATIONS LIMITED',
    'lifts',
    '11/10/23',
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '7ae24ccf-4bca-4876-a55b-4a98570ba8a4',
    'f1e076de-36ce-47bd-9891-42349df1791d',
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
    'fd59bf58-7791-4ae1-bafa-fdb03570af4e',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    's and each contractor engaged to provide services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '2d2c7587-0777-425b-b7f2-2804760f867b',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    's and each contractor engaged to provide services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'f2fa15e4-3f21-408d-ab45-d50ca48f6903',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'shall provide in respect o f the System the additional services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'f04466cd-96eb-425a-b752-cfbd3eeff905',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'reserve the right to withdraw at its sole discretion all services',
    'security',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'a5ccda2b-0dbd-4ec2-99fc-0c7bcf9d46d0',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'reserve the right to withdraw at its sole discretion all services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '5bbabdf0-420f-46ab-b225-7c2dee913cb9',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Blenheim House Construction Ltd',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '7c768166-0794-4cdc-8099-710ab9f9e1a4',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    's  
 
Harbrine Limited',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'd258cfe7-9486-49f6-9c73-2a084eb52971',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Details Product Name & Code Location of Installation 
 
Mundy Veneer Ltd',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'adf625ab-e3db-4f77-8e39-59d05f0910be',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Morrells Woodfinishes Ltd',
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
    '21deb749-2c33-41c4-ad74-5c96f28c4e9e',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    '2024',
    'YEAR ENDED 25 DECEMBER 2024',
    NULL,
    FALSE,
    46673.0
);

-- Leases (1)
INSERT INTO leases (
    id, building_id, title_number, term_years, ground_rent
) VALUES (
    'c6c2ddf3-5397-4344-a2fc-b37f0c0a94ca',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    NULL,
    NULL,
    NULL
);

-- Contractors (6)
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'b1b771d5-d9dc-4e03-a656-d48212db347a',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'HESKETH STEEL FABRICATIONS LIMITED',
    '["lifts"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '05565656-7fc8-4aa1-a27a-ee9cc883f903',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Ltd via Corin Underwriting Limited',
    '["general"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '58281560-12e0-4550-9d5e-8a20a1d4c8c2',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Manchester Galvanizing Ltd',
    '["fire"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'c1daea3e-4fc7-48cb-b547-a4e172a6855d',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Blenheim House Construction Ltd',
    '["cleaning"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '4c4925ea-5ce7-43ff-b09f-0f49af99234a',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Details Product Name & Code Location of Installation 
 
Mundy Veneer Ltd',
    '["cleaning"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '391bdf99-95d5-422e-a523-9ab32d182788',
    'f1e076de-36ce-47bd-9891-42349df1791d',
    'Morrells Woodfinishes Ltd',
    '["cleaning"]',
    0,
    TRUE
);
