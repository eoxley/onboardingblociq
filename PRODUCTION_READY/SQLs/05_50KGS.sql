-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T16:23:30.634299
-- Building: 50KGS

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '50KGS',
    NULL,
    NULL,
    112,
    6,
    NULL,
    FALSE,
    'Not HRB',
    ', or currently',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Units (112)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9a7e2f46-bac5-4c76-97fa-9f4446d128e2',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-001',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6ceb558c-5a12-4dad-9add-d8ba1b40fcc8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-002',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'afedeb23-a7c5-4055-9c02-e17f6de26757',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-003',
    18,
    0.43,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '729091a8-5add-418f-8bae-9b81563448cf',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-004',
    18,
    0.52,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '62a0a3ab-b1d8-438e-a7b0-d3b3321bc9ac',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-005',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5d3c84a0-3467-48bf-8911-252bae789246',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-006',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '026a8cc5-f766-42e0-8ed2-2d6df35c410f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-007',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '04030ecf-e945-40a0-ae59-c0e2ac69ccca',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-008',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bfa5bb1f-9f2b-424c-9d9f-761e5e2bf801',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-009',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2faae2ad-f8de-4f69-9a3d-f978b8762524',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-010',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'de18a7b1-040e-4832-bd1c-fc2852fa27e7',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-011',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9b33a84c-bd3f-4a6d-8555-987e792c97dd',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-012',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '58f00225-f033-4996-b23d-d08e6bd430c4',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-013',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4efe1e6c-4bd4-40e1-9917-45737fe11ad5',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-014',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e5fad7eb-8775-4bc9-87c0-718a54c74004',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-015',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '52b8a87d-fb48-4ae3-88f8-e2117df97a8e',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-016',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '31e7e47b-da75-4e5d-bd84-9a1f115d775a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-017',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'db532e15-c2f4-40a2-b728-d02d5aca9e0c',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-018',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '207ab478-0eb9-4ea5-836f-37b64c171f12',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-019',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '117374aa-228b-498d-995c-f6c7c300690d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-020',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0c5eb2c6-5a7f-4f2f-9b16-cad399ac1dc2',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-021',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7ac0137f-36a8-4a7a-b687-c48b3ac5fda7',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-022',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0fa8dca4-c843-4638-9e1b-c99b3986a7a5',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-023',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a2bf7583-5faf-4146-9e0a-68f28d42f381',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-024',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a2b42f73-1b15-4617-8957-d7c8061352cc',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-025',
    18,
    1.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c3ecd117-09b2-4175-bbac-ba730a03ea8a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-026',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'afb4a4a4-d8ed-4f21-b05f-992a243e8f4a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-027',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '42c495e0-6ef8-4521-ad26-3a288a68b971',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-028',
    18,
    1.69,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f63e81b4-ae06-4d51-9cdf-e1cb066f4807',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-029',
    18,
    0.68,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2028b74f-ca00-4030-b721-494f4fc674ef',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-030',
    18,
    0.86,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0b316fdb-58cc-424e-ad9f-73077eccd1e4',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-031',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '868209c6-ad45-4477-8a04-1647079bfb91',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-032',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '710abffd-5d01-4888-9eb2-31e8521a4b0f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-033',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd6675b08-2248-41ab-b0ab-3525ec71deca',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-034',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd948d1b3-6a89-483a-97c5-cf81c6460dca',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-035',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b9ea98bf-1dd6-4805-a808-f385c44e7e96',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-036',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b9816102-19b8-46c5-b84a-ae0e3579e63e',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-037',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0e270b97-af0f-46dd-ab54-9d34954f45b0',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-038',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '02fb4631-28f7-42e3-a428-e6e7fcf1de0a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-039',
    18,
    0.68,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bccb37e3-c3ae-4d0d-a800-012c50c6b34b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-040',
    18,
    0.91,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e49ca587-acf8-462e-b316-5dce2a810134',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-041',
    18,
    0.67,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cbdaacc4-6682-4cfb-be46-f1ffdd48eb34',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-042',
    18,
    0.7,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2d7a0da6-a99c-4382-9aca-38eebc7ccb45',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-043',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4c15346b-378b-4a2e-a74c-ee098d883e98',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-044',
    18,
    0.75,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9c2a1658-f728-4759-90ae-624afaa6a38b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-045',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3ec05da5-5594-4c86-bf95-651ad0049157',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-046',
    18,
    0.79,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b4df69dc-5741-4257-ab0c-f8ed31064006',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-047',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6a65617c-d960-4fcd-a5c7-1b9effc61cc8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-048',
    18,
    1.06,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ee3e5465-fb69-462c-9483-b0be22a06b30',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-049',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a3bf4973-36cd-4cdb-92c2-8e3913269135',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-050',
    18,
    0.63,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6f0a5966-3989-4b86-843c-86e56cbc6f7d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-051',
    18,
    0.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0c75be78-5907-4255-bb02-8c9decc08ad1',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-052',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '893098f6-7a41-49e0-a0ce-d7552930e204',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-053',
    18,
    0.77,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '62bcbb36-b563-46fb-84f6-d6c54c4b243f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-054',
    18,
    0.7,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4271f58c-3ada-43f2-985d-ff69f1aba601',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-055',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4b1ffea4-1678-420a-89b8-72c74a5a0158',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-056',
    18,
    0.75,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ab0846ab-b84b-4cbd-9c39-47f3c1008479',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-057',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6bd99ddd-f2e1-4e16-90de-1e168dc6a716',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-058',
    18,
    0.79,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1c4e960c-43e3-46bd-9f1c-bd4a8e57cb6d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-059',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd9c0f74e-94b6-48c3-afdf-ee9e3f2d8a6b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-060',
    18,
    1.06,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '49d085e2-5ef0-4f76-808a-e8a0b4010a81',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-061',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e899819d-68e6-4d91-bc03-fe248d48bc43',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-062',
    18,
    0.63,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '88dc10cf-66a5-4ffd-9410-2a405b3b05cf',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-063',
    18,
    0.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '577a2fc9-b59a-4383-a9fa-3422a0c61fc4',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-064',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '68159af7-612e-443a-a4f0-83aad00898ee',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-065',
    18,
    1.2,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd1585250-da7d-4209-b65f-8c9b1a1156c3',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-066',
    18,
    1.26,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '60e5e2ee-aa22-4fad-a676-ca821785688d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-067',
    18,
    1.26,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7296900f-45ce-4467-a06f-b53333846811',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-068',
    18,
    1.43,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9fca7769-d9e7-4582-aa18-c0338fec2246',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-069',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0a1ba000-0ac6-413c-8a0e-513abf71e1c0',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-070',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0f218b48-a5ab-47c1-8e75-5c14271983ef',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-071',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '35ac5650-d049-4a98-9df0-293773e51922',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-072',
    18,
    1.8,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '448f816f-facb-4bb1-8742-32a7f081a08c',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-073',
    18,
    1.86,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '69feb948-ea8a-4452-8613-c1518e810112',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-074',
    18,
    1.57,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a2e696e5-80e5-464b-9bac-0aaf7cb51dc2',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-075',
    18,
    1.58,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7e063ef5-ebff-4e0c-a09c-a6bf9da0f170',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-076',
    18,
    1.38,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'da19ad5f-1294-4d71-afc1-d7375b99c273',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-077',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a8381fd2-5f33-4289-850b-3f758433855b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-078',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4a59eeac-bde4-4f57-a7a4-027e7ca6f16f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-079',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd456b177-4c78-4c24-97e5-b067a1a156da',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-080',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2aaca812-80c3-4078-945c-7f479a213dde',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-081',
    18,
    0.77,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bbcaf5eb-21b9-4909-b5fb-d5d0df0651c7',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-082',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ea2452ba-a7aa-4b65-97b8-df88f171ceb8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-083',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '81c3bcae-3e98-49e0-8e73-7485bb0c63b1',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-084',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9f2859ab-083b-4da1-b533-1e7c132b9b55',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-085',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f6afa3ea-0747-4697-9986-c03a296d2460',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-086',
    18,
    0.95,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c4c6ef50-ed51-4049-b391-ef78476052db',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-087',
    18,
    0.95,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4d5e422e-73b6-4e18-81da-391011721ae8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-088',
    18,
    0.93,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1647d106-0f83-408b-a13b-5151815f4751',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-089',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9cfbc4b8-cb3b-4f50-a1eb-d3c7a980fc3c',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-090',
    18,
    1.22,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7533ae13-e058-4701-8e87-6f72f4cc915b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-091',
    18,
    1.67,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fa19195d-332c-47a3-8c72-631514509c33',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-092',
    18,
    1.35,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '63369ba0-096e-415e-8e45-e028b0ace87b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-093',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0a548bf3-fe3c-4ec9-8edb-3b71bf92debf',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-094',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6a5e8217-73a4-44f1-8d84-4d448cda166b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-095',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '82545c00-2b10-42bf-ab5f-2f9aa60767e5',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-096',
    18,
    1.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1cc3a1b9-cd10-466c-9153-cd81ce7845b8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-097',
    18,
    1.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3e02fe02-1549-4854-b58b-85099874e9ae',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-098',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c84a274c-6c1f-400e-a534-ccb8abda430d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-099',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd60260a9-591e-41f3-a81c-ca8371a59dab',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-100',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '830d5338-efe0-48df-be54-59c3dfebc72a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-101',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b9332cc8-7952-44e1-8c1c-19a3f280d499',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-102',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '36b6113a-1eb7-47f7-a96f-d51bc624a2e8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-103',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2feac447-85a1-4fd0-ad0b-d8845a05bf46',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-104',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a48b8c8c-f048-4a63-b279-40a8db1c5474',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-105',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6aaad810-ca1f-455a-a804-f8d22b52d723',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-106',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0608797b-069a-4e7d-81e3-8f3ee875b0af',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-107',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5e6430d3-917e-4b6e-9d26-649ff05a42e5',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-108',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '47234fa0-7556-4385-92c7-f809e16eb73a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-109',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '292fb086-2412-4324-8f88-8c1a8ae8a7dc',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-110',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a19372f2-1c8f-4a1a-a3a7-ae18bdabb132',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-111',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3ecac176-782a-4de7-b5e9-ae6538b0421f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    '189-01-112',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (111)
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8be24020-9a9e-4c76-8d9f-77fe61feb50f',
    '9a7e2f46-bac5-4c76-97fa-9f4446d128e2',
    'Mr & Mrs R Dunn',
    '16 Temple Fortue Lane, London, NW11 7UD',
    NULL,
    '0773 996 1484 Natasha'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '39cac0e8-20de-4a7b-b087-c056dec0d5ab',
    '6ceb558c-5a12-4dad-9add-d8ba1b40fcc8',
    'Mr Chee Teng Wah & Anthony Chee King Hock',
    '116 Jalan Tun Tan Cheng Lock, 75200 Melaka, Malaysia',
    NULL,
    'AgencyPM@eu.jll.com'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '49def3d6-0d08-4aa1-8b59-1f8dd03aca92',
    'afedeb23-a7c5-4055-9c02-e17f6de26757',
    'Bradshaw International Corp',
    'FAO Adrien Ng, Flat 3, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '00852 281 26682'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6805e973-43c9-44d5-9ac4-a220c0db9ffe',
    '729091a8-5add-418f-8bae-9b81563448cf',
    'Mr Wee Tong Yeow',
    '41 Hume Avenue, Apartment 02-08, Symphony Heights, Singapore, 598738',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '88b2749c-eb08-484a-86ee-39df7b92a160',
    '62a0a3ab-b1d8-438e-a7b0-d3b3321bc9ac',
    'Bradshaw International Corp',
    'FAO Simon Kwok Wing Ng, Flat 5, 50 Kensington Garden Sq,, London, W2 4BA',
    NULL,
    '07412 871 701 HK+7'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e93e5990-e4e3-41e1-9ea1-ce934bbdbbc1',
    '5d3c84a0-3467-48bf-8911-252bae789246',
    'Java Bridge Ltd',
    'c/o Excel Property Services Ltd, 146 Finchley Rd, London, NW3 5HS',
    NULL,
    '020 7691 9000'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6d6c61c2-ab1c-4dd2-8827-82c0355dee08',
    '026a8cc5-f766-42e0-8ed2-2d6df35c410f',
    'Miss V Chan',
    'c/c Karrylee Kelly, Marsh & Parsons, 80 Hammersmith Road, London, W14 8UD',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ddc49286-56e3-4faf-8830-ce244f6934eb',
    '04030ecf-e945-40a0-ae59-c0e2ac69ccca',
    'Java Bridge Ltd',
    'Flat 8, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07925 356932'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0d0483d9-b78c-4574-ac81-31458aea6c75',
    'bfa5bb1f-9f2b-424c-9d9f-761e5e2bf801',
    'Fiona Jane Many Paulus',
    'Upper Maisonette,, 155 Gloucester avenue, London, NW1 8LA',
    NULL,
    '07802 830012 - PM'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c31cae02-ffc2-432c-b314-57dcbaee6dae',
    '2faae2ad-f8de-4f69-9a3d-f978b8762524',
    'Mr C Tailor',
    'Flat 10, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '0207 221 4357'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6fd27004-9cc1-4cd8-b58b-4ea58123376c',
    'de18a7b1-040e-4832-bd1c-fc2852fa27e7',
    'Mr & Mrs Leong',
    '27 Cashew Crescent, Singapore, 679772',
    NULL,
    '0065 6468 1851'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'aee9891a-522c-45ba-9a14-db35d9868038',
    '9b33a84c-bd3f-4a6d-8555-987e792c97dd',
    'Donatella Cuocci',
    '5 Rue Cambon, Paris, France, 75001',
    NULL,
    '+337771788352'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ab639a9d-ff4d-4185-95a4-f3d1146b3ad6',
    '58f00225-f033-4996-b23d-d08e6bd430c4',
    'Mr N B Haftel',
    '213 Kensington Church Street, London, W8 7LX',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '46fadcfa-1650-42c7-ba9e-482a53bd4e70',
    '4efe1e6c-4bd4-40e1-9917-45737fe11ad5',
    'Mrs A Zheng & Mr F Li',
    '91 Belgrave Road, London, SW1V 2BQ',
    NULL,
    '07880 982 920'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4630e49e-4d3e-4468-a4ed-e6e84427588a',
    'e5fad7eb-8775-4bc9-87c0-718a54c74004',
    'Kensington Garden Properties Limited',
    'Flat 16, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c49229b3-2754-4c1c-8fa3-5ef0b6def767',
    '52b8a87d-fb48-4ae3-88f8-e2117df97a8e',
    'Kensington Gardens Properties Limited',
    'Flat 17, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2388a866-d741-48ac-bbfb-6529356844e5',
    '31e7e47b-da75-4e5d-bd84-9a1f115d775a',
    'Ms S E Wong',
    'C/O Aisha Ahmed, 56 Sloane Square, London, SW1W 8AX',
    NULL,
    '+6012-3058840'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5fbff65d-cc88-4ec7-8709-0158321c830f',
    'db532e15-c2f4-40a2-b728-d02d5aca9e0c',
    'Charalampos Tymvios',
    'Flat 19, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f4334c86-b0e6-4aff-9a4c-126d13ed21c8',
    '207ab478-0eb9-4ea5-836f-37b64c171f12',
    'Ms S C Tan & Mr L C Chen',
    '12 Lorong Cinta Alam B, Country Heights, 43000 Kajang, Selangor, Malaysia',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'cac900d3-c8ef-4564-b37f-10b7f86b5dab',
    '117374aa-228b-498d-995c-f6c7c300690d',
    'Kensington Gardens Properties Limited',
    'Flat 21, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7d1ac207-5df9-4859-acfd-56202960f44c',
    '0c5eb2c6-5a7f-4f2f-9b16-cad399ac1dc2',
    'Kensington Gardens Properties Limited',
    'Flat 22, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b7f20369-16c2-4929-87f1-e0849cc6459c',
    '7ac0137f-36a8-4a7a-b687-c48b3ac5fda7',
    'Bradshaw International Corp',
    'Simon Kwok Wing Ng, Flat 23, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ab4308f4-add3-4c04-9c66-e5eaabfa8c57',
    '0fa8dca4-c843-4638-9e1b-c99b3986a7a5',
    'Kensington Gardens Properties Limited',
    'Flat 24, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '80e73ba4-2069-48eb-bfa9-f475bda0456c',
    'a2bf7583-5faf-4146-9e0a-68f28d42f381',
    'Evangelia Ovale',
    '302 Blazer Court, St John’s Wood Road, London, NW8 7JY',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '636658b3-9292-44b6-860b-b704de992d56',
    'a2b42f73-1b15-4617-8957-d7c8061352cc',
    'Federal Government of United Arab Emirates',
    'Military Attaches Office, 6 Queens Gate Terrace, London, SW7 5PF',
    NULL,
    '020 7590 2379'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b0a29093-4ac7-4fe4-ac79-27085ec930bf',
    'c3ecd117-09b2-4175-bbac-ba730a03ea8a',
    'Ms M Kokkinou',
    'Flat 27, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3f7d8e72-4c58-49a6-899f-b45b6a093965',
    'afb4a4a4-d8ed-4f21-b05f-992a243e8f4a',
    'Lochan Investments Limited',
    'C/o Atlas Property Letting & Services Ltd, 51 The Grove, Ealing, London, W5 5DX',
    NULL,
    '020 7124 4046'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '741a8f7f-7423-45c1-803b-762582115355',
    '42c495e0-6ef8-4521-ad26-3a288a68b971',
    'Ace Alliance Associates Inc',
    '1 Raffles Place, 39-01 One Raffles Place, Singapore, 048616',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e99822a6-2a52-4da9-90c2-f93d353cea8e',
    'f63e81b4-ae06-4d51-9cdf-e1cb066f4807',
    'Mrs O Gonzalez',
    'Flat 30, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '+1 305 873 4483'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '72bcbbf4-53a2-4ca9-a549-aa72c04a5f92',
    '2028b74f-ca00-4030-b721-494f4fc674ef',
    'Abimbola Omotanwa Ayinde',
    'Flat 31, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'addfd10d-9ce0-4a6c-b9cc-c82b2bf74857',
    '0b316fdb-58cc-424e-ad9f-73077eccd1e4',
    'Miss L McBride',
    '4 Bridstow Place, London, W2 5AE',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2a7f47a6-b094-4c39-8cec-2a8a00fc3c03',
    '868209c6-ad45-4477-8a04-1647079bfb91',
    'Achille Del Pizzo & Elena Sophie Fabritius',
    'Flat 33, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0344cbd5-559f-4455-8208-1e1c109c6785',
    '710abffd-5d01-4888-9eb2-31e8521a4b0f',
    'The Executors of the Late Mr Leandro Delgado',
    'Maria Helena Vidal Delgado, C/O Vanessa Delgado, 2 Goshawk Rise, Hengoed, CF82 6BG',
    NULL,
    '0035 1213 872419'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '85c58401-3067-4645-bf7e-d8420bce6a26',
    'd6675b08-2248-41ab-b0ab-3525ec71deca',
    'See Yoon Chin & Moi Eng Chea',
    '276 Lorong Maarof, Bukit Bandaraya, 59100 Kuala Lumpur, Malaysia',
    NULL,
    '+6012 - 287 3638'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3e5db545-c7af-48e2-9a89-145316f35771',
    'd948d1b3-6a89-483a-97c5-cf81c6460dca',
    'Mr M Grigolin',
    'Flat 36, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    '+39 335 6399125'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e35b5f96-9b0d-405c-9fcc-68fe3e89c472',
    'b9ea98bf-1dd6-4805-a808-f385c44e7e96',
    'Mr A Zverev',
    'Flat 37, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07802 510 662'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '47630d75-c713-43fb-8edb-7017819bdca3',
    'b9816102-19b8-46c5-b84a-ae0e3579e63e',
    'Mr R Morley',
    'Flat 38, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8dcbf0ed-a8e3-4529-8023-f999ad52b5b3',
    '0e270b97-af0f-46dd-ab54-9d34954f45b0',
    'Mr DC Tsui',
    'Flat 39, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '852 2711 5500'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '884bc710-c883-4a35-924a-9bbfce7c32ff',
    '02fb4631-28f7-42e3-a428-e6e7fcf1de0a',
    'Mr Y Sovgyra',
    'Flat 40, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07983 014966'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0488e0a8-e55c-4c25-83a7-25109dac31ec',
    'bccb37e3-c3ae-4d0d-a800-012c50c6b34b',
    'Jayson Wang & Siew Teng Ng',
    '5 Tenniel Close, London, W2 3LE',
    NULL,
    '020 7221 3215'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'bcc1eb73-27d7-4a18-9094-915d5d8e5220',
    'e49ca587-acf8-462e-b316-5dce2a810134',
    'Deepside Ltd',
    '8 St Georges Street, Douglas, Isle of Man, IM1 1AH',
    NULL,
    '01624 665 100'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e00a986d-d561-45c0-9918-96537ec5b1a5',
    'cbdaacc4-6682-4cfb-be46-f1ffdd48eb34',
    'Bharat Bhundia',
    'Flat 43, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07768 906812'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c3806a9f-f803-4750-9316-9560f35ac20b',
    '2d7a0da6-a99c-4382-9aca-38eebc7ccb45',
    'Mr Faraz Alnur Ramji',
    'Flat 5, 22 St Pancras Chambers, Euston Road, London, Nw1 2AR',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6e3c3330-fc79-4a6f-b44e-2b07e86a93a3',
    '4c15346b-378b-4a2e-a74c-ee098d883e98',
    'Mrs V B Parker',
    '21 The Tramshed, Beehive Yard, Bath, BA1 5BB',
    NULL,
    '01225 462290'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5cc52519-14e9-4ecb-939e-40ea50f65b9d',
    '9c2a1658-f728-4759-90ae-624afaa6a38b',
    'Mr I McDonough',
    '3 Foster Road, London, W4 4NY',
    NULL,
    '07920 703 055 Ian'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '80840f63-1bd3-4ae2-8d3b-ca4ea23cc259',
    '3ec05da5-5594-4c86-bf95-651ad0049157',
    'Petros Alexandros Koumpas',
    'Flat 47, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8adaed1b-7479-4189-9b12-83a41b939633',
    'b4df69dc-5741-4257-ab0c-f8ed31064006',
    'Ms M Asaria',
    'Elysee, 25-26 Craven Terrace,, London, W2 3EL',
    NULL,
    '07740 107 005'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '15fa67cc-5d26-4d23-8f96-d9a6e367696a',
    '6a65617c-d960-4fcd-a5c7-1b9effc61cc8',
    'Tan Siew Chin & Chen Lee Chew',
    '12 Lorong Cinta Alam B,, Country Heights, 43000 Kajang, Selangor, Malaysia',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e8390c97-7800-4c58-97ee-5b8cec9a21f5',
    'ee3e5465-fb69-462c-9483-b0be22a06b30',
    'Ms M Asaria',
    'Elysee, 25-26 Craven Terrace, London, W2 3EL',
    NULL,
    '07740 107 005'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '95f21685-0fce-45b1-953f-898179b5283d',
    'a3bf4973-36cd-4cdb-92c2-8e3913269135',
    'Mr & Mrs L de Freitas',
    '11 Ickenham Road, Ruislip, Middlesex, HA4 7BT',
    NULL,
    '01895 638 689'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1542dff1-7d18-44ec-be61-be4cc75168b7',
    '6f0a5966-3989-4b86-843c-86e56cbc6f7d',
    'MedMon Limited',
    'Flat 6, Cranleigh Court, 4-5 Leinster Gardens, London, W2 6DP',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '77cd5c75-ea87-4b68-b5bf-8c8d79d1b056',
    '0c75be78-5907-4255-bb02-8c9decc08ad1',
    'Tan Chee Yi lilian & Lee Wai Ching',
    '21 Brookfield Avenue, London, W5 1LA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f0ae4fbf-5940-4e29-b85b-ec72b5d72581',
    '893098f6-7a41-49e0-a0ce-d7552930e204',
    'Mr P M Weil, Mr F A Lehmann & Ms L J Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd18815ef-4ca8-4576-902e-f338530ed7ba',
    '62bcbb36-b563-46fb-84f6-d6c54c4b243f',
    'Mr Peter Weil & Mr Freddy Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4ff14b80-3fc0-4a56-a6c3-2c86fb51679f',
    '4271f58c-3ada-43f2-985d-ff69f1aba601',
    'Mr EJ Reed',
    'Flat 56, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fd755ff4-dad8-4157-a07e-1af03485ff3f',
    '4b1ffea4-1678-420a-89b8-72c74a5a0158',
    'Karim Vellani',
    'Flat 57, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '30525ef1-7119-4ae3-86c2-d80d059a85d7',
    'ab0846ab-b84b-4cbd-9c39-47f3c1008479',
    'Kensington Gardens Properties Limited',
    'Flat 58, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'cec5171e-ad3d-44ca-9711-2ca7e2fb8bbc',
    '6bd99ddd-f2e1-4e16-90de-1e168dc6a716',
    'Ms I P Spyrou',
    'PO Box 25520, 1310, Nicosia, Cyprus',
    NULL,
    '+357 99352444'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fb3c5315-2e6c-4c5b-b8a7-2d84a8d7f50a',
    '1c4e960c-43e3-46bd-9f1c-bd4a8e57cb6d',
    'Gwee K Gwee & Goei KG',
    'C/O Wisteria, The Grange Barn, Pikes End, Pinner, Middlesex, HA5 2EX',
    NULL,
    '+44 20 7861 5528 Agt'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '241e9b89-16ac-40da-abbf-3fbebeac09ab',
    'd9c0f74e-94b6-48c3-afdf-ee9e3f2d8a6b',
    'Ms E Green',
    'Flat 61, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8fce0ec4-b9b7-494b-b5e0-22695ffa8d4c',
    '49d085e2-5ef0-4f76-808a-e8a0b4010a81',
    'Ms Moussavou',
    '48 Chiltern Court, Baker Street, London, NW1 5SP',
    NULL,
    '+352 621 458 236'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a75291b8-8d93-4595-8b14-a5810530b8b5',
    'e899819d-68e6-4d91-bc03-fe248d48bc43',
    'Mr & Mrs A Sahu',
    '10 Stoke Hill, Stoke Bishop, Bristol, BS9 1JH',
    NULL,
    '0117 968 5105'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '589cfb13-5c2b-4325-8c9f-aa1c864c4bb6',
    '88dc10cf-66a5-4ffd-9410-2a405b3b05cf',
    'Madam Tan Y H & Mr Wong Chig Meng',
    'C/O Knight Frank, 55 Baker Street, London, W1U 8AN',
    NULL,
    '+44 7814 215 190'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'df8353d3-ecb0-4e44-9f81-679a2666919e',
    '577a2fc9-b59a-4383-a9fa-3422a0c61fc4',
    'Mrs L Lehmann, Mr F Lehmann & Mr P Weil',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5b1a2142-2e9c-4063-8238-04b957a6292b',
    '68159af7-612e-443a-a4f0-83aad00898ee',
    'Mark Valenzia & Elias Lambrianios-Sabeh',
    'Flat 66, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '07004133-d023-4505-9d6c-b941c66f4281',
    'd1585250-da7d-4209-b65f-8c9b1a1156c3',
    'Ms Joanne Hole',
    '5908 141 Street NW, Edmonton, Alberta, Canada, T6H 4A5',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '99a60d71-7dbe-42ed-9693-f50df75d9406',
    '60e5e2ee-aa22-4fad-a676-ca821785688d',
    'Mr P Weil',
    'Flat 68, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '43f2043d-41ab-43f9-a7ed-345209cba605',
    '7296900f-45ce-4467-a06f-b53333846811',
    'Mr S Abletshauser',
    'Flat 69, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0bed16d6-55f2-4dc1-b496-32a70315914a',
    '9fca7769-d9e7-4582-aa18-c0338fec2246',
    'Ms Paola De Leo',
    'Flat 70, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '85de869a-85f3-4aa1-8652-7b349e5d47fb',
    '0a1ba000-0ac6-413c-8a0e-513abf71e1c0',
    'Dr J Perez',
    'Flat 71, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'dd4e5e63-ca3c-4fa4-a9c1-fd0268ca174a',
    '0f218b48-a5ab-47c1-8e75-5c14271983ef',
    'Dario Dias Cavalheiro & Anika Arya Cavalherio',
    'Flat 72, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '07379133760'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5f249b35-b602-4563-a705-2ee0276ef7e9',
    '35ac5650-d049-4a98-9df0-293773e51922',
    'Walter Cegarra & Nathalie Taube',
    'Flat 73, 50 Kensington garden Square, London, W2 4UA',
    NULL,
    '0207 985 0620'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c03b88a2-2f14-436a-b517-30343a1dcc79',
    '448f816f-facb-4bb1-8742-32a7f081a08c',
    'Mr E Barnes',
    'Flat 74, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    '01608 677768'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '35b3ba6f-77cc-46be-a7d1-5dd2320ab230',
    '69feb948-ea8a-4452-8613-c1518e810112',
    'Mr & Mrs C Simon',
    'Flat 75, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7221 4745'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '83041858-cb75-4cd7-b78c-81112f75c801',
    'a2e696e5-80e5-464b-9bac-0aaf7cb51dc2',
    'Mr Vinay Jayaram',
    'Flat 76, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b7406aa5-9c9a-4e5a-ba51-a1bba16e105f',
    '7e063ef5-ebff-4e0c-a09c-a6bf9da0f170',
    'Ms P Maleh',
    'Flat 77, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd473bd52-bbcf-497b-9e67-5cb144449a9a',
    'da19ad5f-1294-4d71-afc1-d7375b99c273',
    'Nuver Estates Ltd',
    'Rodion Panayi (Nuver Estates Ltd), P.Box 56965, 3311 Limassol, Cyprus',
    NULL,
    'none'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f7fac0c4-86b2-4c94-bd59-57be9281fd7b',
    'a8381fd2-5f33-4289-850b-3f758433855b',
    'Natasha Chrishausen Inc',
    'C/O Fraser & Co, Unit 12, West End Quay, 1 South Wharf Road, Paddington, London, W2 1JB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c61062b1-10c8-49cc-bc3a-d9e3a0e13bd5',
    '4a59eeac-bde4-4f57-a7a4-027e7ca6f16f',
    'SNR Property Limited',
    'Kubie Gold Associates Ltd, 36 Ivor Place, Regents Park, London, NW1 6EA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '957bdd2f-e7c1-4ec9-9e23-c563a50ccfe2',
    'd456b177-4c78-4c24-97e5-b067a1a156da',
    'SNR Property Limited',
    'Kubie Gold Associates Ltd, 36 Ivor Place, Regents Park, London, NW1 6EA',
    NULL,
    '07774 860 755 (mark)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e21e16c2-407f-43e8-af71-5c784c32a84a',
    '2aaca812-80c3-4078-945c-7f479a213dde',
    'Mr P M Weil & Mr F A & Ms L J Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '47363bc0-fcae-4c6d-b9c0-6cde3a3076ac',
    'bbcaf5eb-21b9-4909-b5fb-d5d0df0651c7',
    'Mr A I Boyne & Ms M A Boyne',
    'Apt 1.3 Compass House, 50 Kensington Gardens Square, Bayswater, London, W2 4AZ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0dfab1ba-7511-4ad4-a7a3-00490f7525c8',
    'ea2452ba-a7aa-4b65-97b8-df88f171ceb8',
    'Octavia Lucy Fleur Wyatt',
    'Mews Hse 84, 50 Kensington Gdn Sq, London, W2 4BA',
    NULL,
    '07768171545 (Lorren D'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e777e60d-3a96-4fff-88c2-a6f00b214958',
    '81c3bcae-3e98-49e0-8e73-7485bb0c63b1',
    'Khadijeh Rafi Haeri',
    'Flat 17, Saxon Hall, 16 Palace Court, London, W2 4JA',
    NULL,
    '020 7229 6335'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2c4a3371-41a7-4df9-b5e6-17bd41cd1057',
    '9f2859ab-083b-4da1-b533-1e7c132b9b55',
    'Meredith Estates Ltd',
    'c/o Regent Cofid Limited, 37 - 38 Long Acre, London, WC2E 9JT',
    NULL,
    '0203 2140442'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'df58e546-77bd-4e08-864f-5f0dd1d4f039',
    'f6afa3ea-0747-4697-9986-c03a296d2460',
    'Kathryn Estelle Williams',
    'Mews Hse 87, 50 Kensington Gdn Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '618316d4-8905-4e0b-a212-c1cb3488060f',
    'c4c6ef50-ed51-4049-b391-ef78476052db',
    'Chi Yan Kwan & Joseph Kwan',
    '88 Mews House, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07375313676'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ecd4f9ad-49b0-485b-ba0c-09c7d309ef91',
    '4d5e422e-73b6-4e18-81da-391011721ae8',
    'Mrs Dipti Singh',
    'Dipti Singh, C/O Minnie Frangiamore, 107 Victor Road, Kensal Green, London, NW10 5XB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c0502004-f43a-4886-bf03-fe5ae44ec011',
    '1647d106-0f83-408b-a13b-5151815f4751',
    'Tan Puay Chuan Annie',
    'Bismac Consultants Pte Ltd, 24 Fernhill Crescent, Singapore, 259178',
    NULL,
    '+65 97866923'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd4b10f28-b445-4bf0-9d99-21c1e74273f9',
    '9cfbc4b8-cb3b-4f50-a1eb-d3c7a980fc3c',
    'Ms C A O''Driscoll',
    'Mews House No 91, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7727 7059'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c9dbed0d-1902-413e-82e1-810a475ae5b1',
    '7533ae13-e058-4701-8e87-6f72f4cc915b',
    'Fausto Limited',
    'c/o Eduardo Bertao, 1 Thomas Place, London, W8 5UG',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '939fdfc8-3c32-423b-b8e7-7337113d2862',
    'fa19195d-332c-47a3-8c72-631514509c33',
    'Mr F O R Nashashibi & Mrs M Nashashibi',
    'Mews Hse 93, 50 kensington Garden Square, London, W2 4BA',
    NULL,
    '07877 44 12 31 Reza'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '43cbb7b0-50d3-4472-afcb-ac4b820492da',
    '63369ba0-096e-415e-8e45-e028b0ace87b',
    'Ms I Cosar',
    'Mews House No 94, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7727 4179'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e5f102dd-2089-45d0-a5db-35482788499e',
    '0a548bf3-fe3c-4ec9-8edb-3b71bf92debf',
    'Fergus Alexander Dixon & Georgia Karargyri',
    'Mews House 95, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07960 169252'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e8f53772-27f0-44c0-a6a9-2ef465aed863',
    '6a5e8217-73a4-44f1-8d84-4d448cda166b',
    'Mr & Mrs K Teasdale',
    'Mews House No 96, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '01235 528 299'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '67bb58ac-b29d-4cf4-ba4d-4aa20e1bb8bd',
    '82545c00-2b10-42bf-ab5f-2f9aa60767e5',
    'Mr C L H Clark',
    'Mews House 97, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4b599114-88a9-4d8c-ad1f-914f4c05dd77',
    '1cc3a1b9-cd10-466c-9153-cd81ce7845b8',
    'Aditi Ravi Kumar',
    '6 Hill Road, London, NW8 9QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4d8242b6-a034-4e41-aad1-9d7c865fc44e',
    '3e02fe02-1549-4854-b58b-85099874e9ae',
    'Mr R Jong',
    '3 Langside Avenue, London, SW15 5QT',
    NULL,
    '07788 416 195'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a791aee1-fd21-4e3d-b224-2d619fa28bfd',
    'c84a274c-6c1f-400e-a534-ccb8abda430d',
    'Mr & Mrs K Wildie',
    'Flat 100, 50 Kensington Gardens Square, London, W24BA',
    NULL,
    '020 7243 3377'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd9b6b587-4735-47ab-bfa3-35a3a2c583e2',
    'd60260a9-591e-41f3-a81c-ca8371a59dab',
    'Raptakos, Brett U.K Limited',
    'Third Floor, 126-134 Baker Street, London, W1U 6UE',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a60cc608-f7f9-4ce6-8bf3-ad04bb2e3ceb',
    '830d5338-efe0-48df-be54-59c3dfebc72a',
    'Raptakos, Brett U.K. Limited',
    'c/o Butler & Co LLP, Third Floor, 126-164 Baker Street, London, W1U 6UE',
    NULL,
    '020 7243 5260'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '238b8668-961b-42e1-8158-4b3d9e73aa9c',
    'b9332cc8-7952-44e1-8c1c-19a3f280d499',
    'Raptakos, Brett U.K. Limited',
    'c/o Butler & Co LLP, Third Floor, 126-164 Baker Street, London, W1U 6UE',
    NULL,
    '020 3195 1632'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'af3d1ab4-0b99-45e2-aec5-80205ae5920d',
    '36b6113a-1eb7-47f7-a96f-d51bc624a2e8',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '57a44b39-78f1-4fe3-80e5-039713bb583a',
    '2feac447-85a1-4fd0-ad0b-d8845a05bf46',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '68e9bc36-3fe7-47c9-9eb9-a5031ce5aa27',
    'a48b8c8c-f048-4a63-b279-40a8db1c5474',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '30bb48ed-3e02-42c3-b048-7d97975ee672',
    '6aaad810-ca1f-455a-a804-f8d22b52d723',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b2472cb1-59e7-4aeb-b637-ef4ab974332d',
    '0608797b-069a-4e7d-81e3-8f3ee875b0af',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'cb542356-0c86-486e-90a3-bebe99fb1311',
    '5e6430d3-917e-4b6e-9d26-649ff05a42e5',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3552ef38-9f14-474f-8b41-8584d5d86b4e',
    '47234fa0-7556-4385-92c7-f809e16eb73a',
    'Redan Place Management Company Ltd',
    '50 Kensington Gardens Square, London, W2 4AZ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a34af6cb-f711-42b6-b083-88820b128ac5',
    '292fb086-2412-4324-8f88-8c1a8ae8a7dc',
    'Redan Place',
    'Mr S Dear, Hillside House, Petworth Road, Haslemere, Surrey, GU27 2HZ',
    NULL,
    '01428 645721'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7d27df42-c0a5-4efd-aeb9-dfd0008848d7',
    'a19372f2-1c8f-4a1a-a3a7-ae18bdabb132',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
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
    'ea0df6bc-3584-474a-9c7d-1b8871a4e446',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    '2023-11-21',
    '2024-05-21',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '3d75b704-a8df-47e7-a32d-3d874477fa83',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    '2025-03-18',
    '2026-03-18',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '6f67e83d-d3a2-4a18-b89b-f88898768aa7',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    '2025-09-22',
    '2027-09-22',
    'Unknown',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '8acae435-f636-430d-843c-d36aefcf23c3',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    NULL,
    '2026-09-02',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'b4364cf4-1491-4ce5-a75a-73da6f105c00',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    '2021-11-05',
    '2026-11-05',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'EICR';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '64789edb-e9a6-4054-99f1-2ebf92147e7d',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    NULL,
    NULL,
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';

-- Maintenance Contracts (27)
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'a46514bd-8457-41ef-aa8a-4692b2dfbe35',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'b21e200c-d85f-4070-a6be-76774c5abb04',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'f4f4cf98-5140-457e-a8f6-b5dd13c0b8cc',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '76a25117-acd3-4aa6-9287-73bbbdc6168b',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '4b7557e9-61a2-481e-9623-a58b650d2eae',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '49e68956-9a69-4b01-a94a-e0def09cd18c',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'eb2e5acd-516b-4d99-859b-cc915d50288e',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'MIH Property Management Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '0c5b0bd8-a678-433b-b73a-afd53202e0ce',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '840fbbce-b398-43e7-9f47-c197d60133c1',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '0b692d9e-10b0-4fb0-ac23-b9179fe07d24',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '630c8321-2e18-4c7f-b494-bb5ef9a7c1fc',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
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
    'e23cfbe6-2d0d-4834-b17f-b166d31911b7',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '515ba20c-a241-4c7e-8819-867772ef5417',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'Number is
The Company is limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '185c63cf-cbf1-4a81-886d-7744aeeb9580',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'is limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'd23588bd-dd68-42aa-834e-f11e9fc2b5bd',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'will provide to the Customer payroll services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '07e943fa-f011-4014-b7e4-cc60dd167258',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'cannot be delegated and Zurich Insurance Group Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '59f4d859-b5cc-461b-b4a9-926d2f0cfedc',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'cannot be delegated and Zurich Insurance Group Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'aece1742-1fa0-4a0f-a54d-221c28502228',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'w ill provide the services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '6d78af20-e889-4383-9f13-2422b1581624',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'to prevent rodent 

Discreet Pest Control Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '83ee96c6-bb27-4716-8378-dbcc055f10e8',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'PTSG Electrical Services Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'ca47c885-08f1-461d-a56a-d71bb8da2b1f',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'acf03450-a01d-4734-bb1a-2e4df4470b8a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '86e8cfb4-c356-46e7-946a-672dd319e1cb',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '634f6559-e931-4dc3-baff-f3977b41873a',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'e3a27d63-df3f-4616-9105-ded07ab43940',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '2cb5d902-9bf1-4fe5-a32d-661d8289ea71',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '0fbc657b-8174-458d-b94d-7a6f12532c4e',
    'f0fdce30-612f-4659-8a6d-3612535ed541',
    id,
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';

-- Contractors (3)
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'eb4fb39d-b9fd-42c0-b933-7bb2b406fce2',
    'MIH Property Management Ltd',
    {"gardening"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'ced92d48-dacb-4900-9da2-83dad251e806',
    'Number is
The Company is limited',
    {"gardening"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'b971eef2-adb5-430e-8014-381292250a13',
    'PTSG Electrical Services Ltd',
    {"gardening"},
    TRUE
) ON CONFLICT DO NOTHING;
