-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T16:19:18.172478
-- Building: 162.01 48-49 GLOUCESTER SQUARE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
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
    '7d08c5a6-afcc-4d99-b8b7-29a52f37273d',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    '162-01-001',
    16,
    14.29,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9837a755-75f9-4797-a457-f8f27aa7bdde',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    '162-01-001A',
    16,
    16.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '420af571-58f6-4949-b526-16ed808ca102',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    '162-01-002',
    16,
    33.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '362f0cf7-584c-47b5-926f-2115c0bee20d',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    '162-01-003',
    16,
    19.18,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e1ffcce9-f7f6-4ab3-9f23-985d724d54ba',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    '162-01-004',
    16,
    16.91,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (5)
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7365e421-927e-4f41-8570-7ec8e779728a',
    '7d08c5a6-afcc-4d99-b8b7-29a52f37273d',
    'Ms H Boy',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '28c7fbae-49ab-4e21-b0ad-40ef48ae3a35',
    '9837a755-75f9-4797-a457-f8f27aa7bdde',
    'Michael Menaged',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd6c331c7-80de-4272-a6b0-8c554cbc1401',
    '420af571-58f6-4949-b526-16ed808ca102',
    'Mrs Mei Ling Lee',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '77be1375-f203-45a1-bd50-aff8cd3c1c53',
    '362f0cf7-584c-47b5-926f-2115c0bee20d',
    'Mr P Gullestrup and Mrs H Gullestrup',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7778e311-eaf6-46d6-a8aa-45d7ab5ed197',
    'e1ffcce9-f7f6-4ab3-9f23-985d724d54ba',
    'Mr S C Hopkins and Ms W L Hopkins',
    NULL,
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Compliance Assets (6)
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '231a019f-47ba-4a99-bc02-63bf38415645',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    '2025-04-08',
    '2026-04-08',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '0df96856-42ea-49b8-b0b5-912cb0b40c41',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    '2011-07-27',
    '2013-07-27',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'cc37c81e-2d5f-43de-adbb-66d27068c31d',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    '2023-09-05',
    '2028-09-05',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'EICR';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '0a28fc20-7033-48b7-a68b-64f87f098285',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    NULL,
    NULL,
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '579e13b8-8a8a-46a7-8ed2-8e78eb9406c9',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    NULL,
    NULL,
    'Advisories',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '6cc44617-bbbd-416f-9c94-53cd08d1d3f6',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    '2023-04-19',
    '2024-04-19',
    'Advisories',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';

-- Maintenance Contracts (14)
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'dc68901a-2d85-4c55-a6b9-2da096a9f708',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'HESKETH STEEL FABRICATIONS LIMITED',
    '16/10/23',
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'LIFT_MAINTENANCE';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '336639d9-bec0-432a-bc77-2e5463bf99e0',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'Ltd via Corin Underwriting Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'bb63909e-a779-4b02-aa56-0acc7418a6ea',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'Manchester Galvanizing Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '867418e0-bf4d-4625-9bb8-70a7ca3a6396',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'HESKETH STEEL FABRICATIONS LIMITED',
    '11/10/23',
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'LIFT_MAINTENANCE';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '9d8833f4-a151-47bb-be4e-d50761af3648',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
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
    '177f8163-a8ca-40e2-a9f7-0a40400ca8e5',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'be69b79c-4a65-4d31-a12f-7e2a93ba0930',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '010ad444-f5a5-4477-9bb4-340d446b5a4f',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'shall provide in respect o f the System the additional services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '4ce1cb28-881e-401e-acee-885441bf2627',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'reserve the right to withdraw at its sole discretion all services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '45019481-447b-4752-805d-890f3272636b',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'reserve the right to withdraw at its sole discretion all services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'e7d18bd7-1f1e-41be-a4fa-595b6538b939',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'Blenheim House Construction Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '08d25f78-75eb-4e8d-9a0b-929eca54a906',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    's  
 
Harbrine Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '22b06ffb-c484-4ab2-9c08-c7eb8b222e00',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'Details Product Name & Code Location of Installation 
 
Mundy Veneer Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '52bf0a92-526a-414c-b9b4-0875ac52ee04',
    'a4eae0ec-c2e0-4090-9cf3-627848004611',
    id,
    'Morrells Woodfinishes Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';

-- Contractors (6)
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'ae8c6743-0964-4fb6-9b9a-7720834d2a93',
    'HESKETH STEEL FABRICATIONS LIMITED',
    {"lifts"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '770a548e-7ba8-4062-9be7-3c95d5b53c6d',
    'Ltd via Corin Underwriting Limited',
    {"general"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'dbe31af3-32d3-45e6-9c96-11df51269511',
    'Manchester Galvanizing Ltd',
    {"fire"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '60e011f8-b7a1-4657-8795-0a3e5677cff4',
    'Blenheim House Construction Ltd',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '72083b4f-5a90-4233-aa9a-d51a7f12d651',
    'Details Product Name & Code Location of Installation 
 
Mundy Veneer Ltd',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '5e162956-2d68-4b0d-a140-70aea929f6af',
    'Morrells Woodfinishes Ltd',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
