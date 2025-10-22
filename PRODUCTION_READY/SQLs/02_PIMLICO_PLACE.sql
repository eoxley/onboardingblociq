-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T16:11:58.949422
-- Building: 144.01 PIMLICO PLACE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144.01 PIMLICO PLACE',
    NULL,
    NULL,
    89,
    7,
    18.0,
    TRUE,
    'HRB',
    'drawings / floor plans / As-builts etc',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Units (89)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4f745ea6-c1b3-44dd-90cb-c02b62f76bde',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'item.',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '370cad48-8789-4d97-be7f-08b171e3a892',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'weeks',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5ff3946a-4647-4452-8784-c8b827177a5c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'nr',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ab4c386b-0fea-4484-8fb1-6c5d7b196e0f',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'Lm',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '705c636d-764e-42b5-a19c-a7565bab6081',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '.',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '09f2adb3-f1bb-475f-a325-dad17a28a59d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'm2',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '01a29344-8aef-4b5e-8d18-5e671cb26cfb',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    'Labgour included in 3.3.1',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cccc26b8-c8f2-459f-b947-dfe5fd859cb6',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-001',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd22a7c35-e185-4a89-8ac2-d99c0bdfffd1',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-002',
    14,
    1.306,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8185a702-6183-4785-a50d-517feb03a62a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-003',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'aac483a6-06ab-441f-8c1f-3967f8c610e9',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-004',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '242de532-bb3d-4e68-8d5b-5d94a77237d4',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-005',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '245e003c-a5ef-43d8-89ec-c0d8d226e845',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-006',
    14,
    1.306,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1a6a3006-0210-4831-8336-b29a1e1b960d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-007',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bc1f080b-a273-424a-8e30-6f2de0ff02a5',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-008',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e7cbb69e-8cb7-4368-8181-08d9cfba1681',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-009',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3c642bfe-7cbb-491b-90e4-cdb4957ef6d5',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-010',
    14,
    0.942,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f606a141-abd9-47d9-9644-e9614c549434',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-011',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0d709bcc-c21d-4b1b-8f39-bd3ae526836b',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-012',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2b2950c7-dba9-462f-87d0-72c4a647224f',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-013',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5fdecd14-7824-4da8-864d-bf9b32af6d64',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-014',
    14,
    0.942,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '51786cce-8fc6-4e7f-82be-e26fc26c39a5',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-015',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9c712f87-3b92-4a39-96b5-5b2d63133033',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-016',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '45d4ecbe-e4f8-43fd-9f4d-d1bf0afc38a7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-017',
    14,
    1.814,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7e1fb224-b204-4dfd-881b-dbf347c8fcc7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-018',
    14,
    0.826,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b4653529-24aa-4e0c-8c1b-4d77011b3e37',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-019',
    14,
    1.969,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ebc6a31f-fbd8-41e3-9a7c-d9709de646da',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-020',
    14,
    2.028,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '28bd21d7-6fa0-4666-905f-2585bc53fa96',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-021',
    14,
    1.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b01ae928-2c6d-4876-8bb7-62df81297fdb',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-022',
    14,
    1.31,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '911e77e0-092f-4362-a092-bac710ee9d93',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-023',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'de3956e6-99f9-4a89-bc2f-86c0a6f2f3f5',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-024',
    14,
    1.549,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '603ef270-fbe7-4f72-9285-4d0629333172',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-025',
    14,
    1.426,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8266b411-61b0-4e89-ad52-12f1627113b9',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-026',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1e7b1b3f-c149-40e5-9e3d-0b85b90eca6e',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-027',
    14,
    1.549,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'effd1332-7630-4f9d-a09a-b1d091c62d0a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-028',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '31fe8cc6-fb42-4fef-89c4-cf7ae4cc7a4d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-029',
    14,
    1.548,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7c9487be-58d7-43fd-85fe-21df809e4503',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-030',
    14,
    1.555,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4d31e91e-456d-42f1-8d3d-a38ea605b799',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-031',
    14,
    1.64,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2da287b8-9635-40e0-8e3c-6a32fe0eab6e',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-032',
    14,
    1.614,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '68ca2207-9531-4d9e-addb-24d081b7d2b9',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-033',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ec646585-336a-43a4-9020-f767664b99cd',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-034',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7688a5ac-b9be-4f06-ae5b-8d62d46131aa',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-035',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'faed24ad-7e9b-4802-8e61-cb74928f40ad',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-036',
    14,
    1.616,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3c4eae3a-b67c-4486-8c37-914575dbeb2f',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-037',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2c4dc7ff-3f7b-44b4-8e3f-e446a7a756c7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-038',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ffd0c546-7dd4-4d4d-b794-abb7537895be',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-039',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e20e2460-08c8-4027-b4b1-b05adf60e3d4',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-040',
    14,
    1.62,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a41d1d4f-1baa-4656-9ec4-1553de9a7112',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-041',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a4c6cb79-1838-4343-86ac-9d9b2be363e6',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-042',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '45fa9523-e355-4162-b1ee-6e50013c077c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-043',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '04470d49-420b-44b6-a228-c6572118e726',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-044',
    14,
    1.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b036457f-4631-4b95-a3fb-4bdf73f912d3',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-045',
    14,
    1.301,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0f767c54-707f-4ba7-b508-c3ccdc286c73',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-046',
    14,
    1.301,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '30a23e4b-d230-4b79-a73d-de112a07b97c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-047',
    14,
    1.497,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '01ea6816-6638-4cbe-88d0-666aa70d1c21',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-048',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '623602e9-37ba-4ddb-93fb-8992ce9781d7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-049',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '58808cd4-8468-4d05-a8cf-1513fbd4d51a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-050',
    14,
    0.715,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '055d81f2-5147-44d0-92ee-34ec05ff675d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-051',
    14,
    0.715,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ec09a59e-b94a-4c8f-8ab2-a54020c01f7a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-052',
    14,
    0.919,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '450dace9-a4b1-4c90-b67c-935ea531912b',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-053',
    14,
    1.325,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'eed1b0b3-b713-4a94-bd2b-f46f5284db4a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-054',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd5f08c50-c73a-40dc-a2b3-8fc8e71ed5a5',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-055',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5fac633d-729b-458a-968d-2cbd7dbfdfef',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-056',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'aef466c8-b2a6-41a4-8b76-1ff0ce5b1b6d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-057',
    14,
    1.064,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ebeed557-bd5e-40fc-8a2a-64a633c2b468',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-058',
    14,
    1.22,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '975ea509-7fc1-4a5a-8160-4418ee66bbec',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-059',
    14,
    1.357,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1435de2b-35a8-453e-b2eb-facdea5be10a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-060',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '43dea602-8531-4ea2-953e-f00ef7a590d1',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-061',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '77892e99-8788-4a06-8000-9d6b14c7f802',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-062',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e968d099-7d06-4708-ba5e-a05008d54d14',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-063',
    14,
    0.707,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3022ee23-b78b-428c-b8fd-d267081f679d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-064',
    14,
    1.935,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fd3bf276-31f3-44bd-8f0f-c97101f92932',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-065',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '506526bc-db6b-48df-8569-8149670364b7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-066',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '22c64ad4-8bfb-48fb-ac77-6383950ebbd8',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-067',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '71ef69d5-e4c5-414c-a1ef-0c6e4ff321e8',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-068',
    14,
    0.707,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ad38ae69-d81c-4953-98ff-b1cbdf57aea4',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-069',
    14,
    1.935,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '39ebcbc0-a2fc-4541-b3b8-c51b42bd844d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-070',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b7cd4c72-e584-4fb0-a503-0e3a277a1672',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-071',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4ac24ebe-3ac6-4e5c-b3c5-a2294d9669f1',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-072',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '478c7061-9094-49af-9130-2698645863d8',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-073',
    14,
    2.174,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e21cca98-abb3-4601-a1f5-4f77bc7ab030',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-074',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '46cd3ea0-af30-4fc8-a73e-24d57143607c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-075',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4d185389-cd70-4f46-b58b-828f560237e1',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-076',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6853fa14-9b87-48f5-b507-d5bea0eb0194',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-077',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '781515e2-4996-49e8-b28f-d8fbd5c676cf',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-078',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9d08a983-38b1-4222-a918-f48a82d6816f',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-079',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '72216c0d-a687-4b35-a477-79ae112bc2e1',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-080',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c8f4a7e0-8f4a-4316-84ca-12b3d8788847',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-081',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '65012b45-fc4a-4081-a27b-b1c46c66fa8a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    '144-01-082',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (82)
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5144dd2b-812f-4bfe-99f2-30ddd4393eb7',
    'cccc26b8-c8f2-459f-b947-dfe5fd859cb6',
    'Derek Mason & Peter Hayward, acting as',
    'Ethlope Property Ltd Acting by his, LPA Fixed Charge Receivers, C/O MDT Property Consultants, 5 Coppice Drive, Putney, London, SW15 5BW',
    NULL,
    '07836 284269 (Derek)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3a7fd6b1-98a0-42be-bfca-a73f8e7832c7',
    'd22a7c35-e185-4a89-8ac2-d99c0bdfffd1',
    'Jasmine Chan',
    'Pimlico Place - Flat A2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b5202c13-85a3-4d28-952c-7858d06b8f72',
    '8185a702-6183-4785-a50d-517feb03a62a',
    'Ms S Brown',
    'C/O Hoffen West Ltd, 16 Lower Belgrave Street, London, SW1W 0LN',
    NULL,
    '07449 938 888'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '47a98973-7c87-43e5-a178-8f0a0165ec42',
    'aac483a6-06ab-441f-8c1f-3967f8c610e9',
    'Nicholas Ingram, Mark Ingram & Elaine Ingram',
    'Pimlico Place - Flat A4, 28 Guildhouse Street, London, SW1V 1JJ',
    NULL,
    '07814155215'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '36bbfccb-405f-4c7b-a548-5e4a83dc9381',
    '242de532-bb3d-4e68-8d5b-5d94a77237d4',
    'The Roman Catholic Diocese of Westminster',
    'Finance Office, 46 Francis Street, London, SW1P 1QN',
    NULL,
    '02077989169'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '963d3844-d916-480d-877f-7737ac734640',
    '245e003c-a5ef-43d8-89ec-c0d8d226e845',
    'Elena Margaret Eu',
    '46 E Peninsula Centre, DR APT 259, Rllng Hls Est, California 90274, USA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '96aa90c8-49f0-41f0-8c92-31f33e7ac3aa',
    '1a6a3006-0210-4831-8336-b29a1e1b960d',
    'Mr AJ and Mrs AM Hampson',
    'Crossbow House, Hillhouse Lane, Rudgwick, West Sussex, RH12 3BD',
    NULL,
    '077889966118'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '25e49580-53f9-4b03-893e-28d1d040b33c',
    'bc1f080b-a273-424a-8e30-6f2de0ff02a5',
    'Mr B Kinane',
    'Pimlico Place - Flat A8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a716ed07-3710-4ebb-a345-6a6b1e58f787',
    'e7cbb69e-8cb7-4368-8181-08d9cfba1681',
    'Christopher & Clare Roberts',
    'Pimlico Place - Flat A9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '01a53b12-510d-4367-9399-2263b26e674b',
    '3c642bfe-7cbb-491b-90e4-cdb4957ef6d5',
    'Jessica Louise Brady',
    'Pimlico Place - Flat A10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '68944dc6-9bfd-4460-af90-63417c4d16b1',
    'f606a141-abd9-47d9-9644-e9614c549434',
    'D McCormick',
    '2 Rathfarnham Wood, Dublin 14, EIRE',
    NULL,
    '0353872482013'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1918c0a2-0e86-492a-8869-7a9f9859e280',
    '0d709bcc-c21d-4b1b-8f39-bd3ae526836b',
    'Ms Rachael Noble',
    'Pimlico Place - Flat A12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7c8aa55e-2a7e-4e3f-aeeb-49cfae189e2e',
    '2b2950c7-dba9-462f-87d0-72c4a647224f',
    'Dr A G Ward',
    'Pimlico Place - Flat A13, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '18a98c04-8275-46cd-a2e3-528220b721ea',
    '5fdecd14-7824-4da8-864d-bf9b32af6d64',
    'Mr Gary & Mrs Kim Risley',
    '5 Popes Wood, Thurnham, Kent, ME14 3PW',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '13adbb26-f2f4-4b0f-a998-1399860d1c35',
    '51786cce-8fc6-4e7f-82be-e26fc26c39a5',
    'Mr J & Mrs D P Reidy',
    '19 Cumberland Street, London, SW1V 4LS',
    NULL,
    '02078343021'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c9e2c108-98a1-4205-baec-b7da451e05f5',
    '9c712f87-3b92-4a39-96b5-5b2d63133033',
    'Christopher P Ennals and Elizaveta Taubes',
    'Pimlico Place - Flat A16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a9388328-1767-4edd-a500-acabba5b2ab6',
    '45d4ecbe-e4f8-43fd-9f4d-d1bf0afc38a7',
    'Vincenzo Catanese & Manola De Vincentis',
    'Pimlico Place - Flat A17, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6d2f7376-8eab-48fc-b557-32377d77190d',
    '7e1fb224-b204-4dfd-881b-dbf347c8fcc7',
    'Shenwei Zhu',
    'Pimlico Place - Flat A18, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '662106e1-08d6-47d8-9d61-14c9a789a887',
    'b4653529-24aa-4e0c-8c1b-4d77011b3e37',
    'Mr Bernd Freier',
    'c/o S Oliver Gmbh & Co KG, Ostring, 97228 Rottendorf, GERMANY',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3f3ca9f4-38e0-47d8-aaea-99da49148b30',
    'ebc6a31f-fbd8-41e3-9a7c-d9709de646da',
    'Mr T Izmaylov',
    'Pimlico Place - Flat A20, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e63c8d72-ec04-4fe5-a1a9-7b988740c491',
    '28bd21d7-6fa0-4666-905f-2585bc53fa96',
    'Dr Simon Ostlere',
    'Pimlico Place - Flat A21, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '20bfceee-3f67-4da9-83f7-d9511c63ab14',
    'b01ae928-2c6d-4876-8bb7-62df81297fdb',
    'Ms Catherine Ercilla',
    'Prestwood, 8 Rowley Green Road, Barnet, EN5 3HJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f9e79876-c72e-4346-a5e1-16ca3593c84a',
    '911e77e0-092f-4362-a092-bac710ee9d93',
    'H E Tortoishell',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '20d614d0-637f-4d36-9c43-09dd9b9cb63f',
    'de3956e6-99f9-4a89-bc2f-86c0a6f2f3f5',
    'Mr Dario Striano',
    '66 Ashley Gardens, Ambrosden Avenue, London, SW1P 1QG',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd863e0ee-3da0-4af0-94bf-363edf435f74',
    '603ef270-fbe7-4f72-9285-4d0629333172',
    'The Estate of the Late Rogdre Juer',
    'C/O Kerensa Cooper, Foot Anstey, Senate Court, Southernhay Gardens, Exeter, EX1 1NT',
    NULL,
    '+441392685216'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c4ea032c-bfe9-421a-80ae-e8b15b0d40f0',
    '8266b411-61b0-4e89-ad52-12f1627113b9',
    'A Protasova, T Protasova, V Damaskinskiy',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3ddd39ca-6ee7-4d3b-be24-83baebab1e57',
    '1e7b1b3f-c149-40e5-9e3d-0b85b90eca6e',
    'Mr R Markham',
    '23 Stoke Park Road, Stoke Bishop, Bristol, BS9 1JF',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b0473de5-bd79-4bc3-b552-455991de63ff',
    'effd1332-7630-4f9d-a09a-b1d091c62d0a',
    'Mr N Stone, Mr K Stone & Mr Stone',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4d8763f8-7e83-4b8d-a777-e5c548444e31',
    '31fe8cc6-fb42-4fef-89c4-cf7ae4cc7a4d',
    'T E Hohler',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    NULL,
    '020 7622 6914'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '200dc9ea-b41c-480a-b87d-ec0a8743fa78',
    '7c9487be-58d7-43fd-85fe-21df809e4503',
    'T E Hohler',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    NULL,
    '020 7622 6914'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '863ead85-9129-4e58-9e7a-73bdecc5582f',
    '4d31e91e-456d-42f1-8d3d-a38ea605b799',
    'Aquitania Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b129d381-c016-47fc-b542-0b06ca3f41bd',
    '2da287b8-9635-40e0-8e3c-6a32fe0eab6e',
    'Dr B K Vekaria',
    '32 Totteridge Common, London, N20 8NE',
    NULL,
    '02076300782'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8713513e-b492-4c8e-9cac-56dc54499893',
    '68ca2207-9531-4d9e-addb-24d081b7d2b9',
    'Mr F A Iannello',
    'Pimlico Place - Flat D1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02078349148 (rarely a'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8b475b5f-676c-4272-bdd3-0823f544d22f',
    'ec646585-336a-43a4-9020-f767664b99cd',
    'Kwok Hing Lam & Choi Joecy Lee',
    'Pimlico Place - Flat D2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '85226280077'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '069acf88-ccf0-49e0-8332-88f89d91b282',
    '7688a5ac-b9be-4f06-ae5b-8d62d46131aa',
    'Shashank Chahar & Monica Lalwani',
    'Pimlico Place - Flat D3, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '508b9efd-944e-4569-8223-862745e260c5',
    'faed24ad-7e9b-4802-8e61-cb74928f40ad',
    'Mr B J A Hutt',
    '33 Radnor Mews, London, W2 2SA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'be766de9-8c51-4f56-b2e5-9588a4f70b50',
    '3c4eae3a-b67c-4486-8c37-914575dbeb2f',
    'Silversands Resources LLC',
    'c/o Vuna Capital Trustees (Mauritius), Level 10, NeXTeracom, Tower 1, Cybercity, Ebene, MAURITIUS, 72201',
    NULL,
    '02304278343'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '66723219-bfbc-4ce3-8ac9-46455cc162f7',
    '2c4dc7ff-3f7b-44b4-8e3f-e446a7a756c7',
    'Thracia Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e6a9fde6-8905-4fb2-8213-60f8e69aafe8',
    'ffd0c546-7dd4-4d4d-b794-abb7537895be',
    'T C Hill & L Hill',
    'NO CORRESPONDECE TO BE SENT VIA POST, D3, La Clare Mansion, 92, Pokfulam Road, Hong Kong',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e3d9fd2e-96da-4737-9847-0a48f9d1f92f',
    'e20e2460-08c8-4027-b4b1-b05adf60e3d4',
    'V, J, A, & Apipu Phataraprasit',
    'Pimlico Place - Flat D8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ceaae7af-3274-45b8-98e2-92862b0add10',
    'a41d1d4f-1baa-4656-9ec4-1553de9a7112',
    'C S Shaftesley',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6946e0cd-373c-42c4-9e02-d3c57435a068',
    'a4c6cb79-1838-4343-86ac-9d9b2be363e6',
    'M Kohli',
    'Pimlico Place - Flat D10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b1b3d2b3-bfb7-4394-9c45-b6e2b5ca29f6',
    '45fa9523-e355-4162-b1ee-6e50013c077c',
    'Mr Deepak Sabnani',
    'Pimlico Place - Flat D11, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07768 997 276-Soni'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '542c5104-cf0a-4114-aa74-9332e7032fc2',
    '04470d49-420b-44b6-a228-c6572118e726',
    'Qu Wang',
    'Pimlico Place - Flat E1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6b98f1d1-6162-4be6-9e99-3e84fc445bb4',
    'b036457f-4631-4b95-a3fb-4bdf73f912d3',
    'Mr Mikhel Chandra Pipariya & Ms Sonam Lalwani Lalwani',
    'Pimlico Place - Flat E2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '821ee30e-6de2-40fe-9ff0-d9782e1d0fb3',
    '0f767c54-707f-4ba7-b508-c3ccdc286c73',
    'Peter Sten Bertelsen',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3fb673af-2baf-4b8f-91d1-c068e8ecca29',
    '30a23e4b-d230-4b79-a73d-de112a07b97c',
    'Peter Sten Bertelsen',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a237ce9c-aae2-41cb-a883-7ea4051c9345',
    '01ea6816-6638-4cbe-88d0-666aa70d1c21',
    'Andrew Brown',
    'c/o Ms Asami Miyoshi, c/o London Tokyo Property Services, Central London Office, 115 Baker Street, London, W1U 6RT',
    NULL,
    '07464 093011'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a89a8ae0-714a-4bfc-b33d-296b5fd9f719',
    '623602e9-37ba-4ddb-93fb-8992ce9781d7',
    'Mr S Nassiri-Shahroudi',
    'Pimlico Place - Flat E6, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd3eaf715-d116-4fef-ba91-6b14f916ee5a',
    '58808cd4-8468-4d05-a8cf-1513fbd4d51a',
    'Chawki Karam',
    'Pimlico Place - Flat E7, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '744646a6-7137-4129-a2e0-20c5ca733c71',
    '055d81f2-5147-44d0-92ee-34ec05ff675d',
    'Dalmatia Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fab76972-c806-4616-b70c-18d7c84157a0',
    'ec09a59e-b94a-4c8f-8ab2-a54020c01f7a',
    'Miss Elizaveta Kolesnikova',
    'Pimlico Place - Flat E9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a57b63d7-f624-4be1-be85-db40ee1555cd',
    '450dace9-a4b1-4c90-b67c-935ea531912b',
    'Julia Sz-Hing Hunt Chan',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8833e313-651a-47a0-8306-3386ae8c291d',
    'eed1b0b3-b713-4a94-bd2b-f46f5284db4a',
    'F Steadman',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fafc3aaa-0665-4a3c-ac17-6107c6ce83e9',
    'd5f08c50-c73a-40dc-a2b3-8fc8e71ed5a5',
    'Shen Xiangjun',
    'Pimlico Place - Flat E12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '+86 183 7679 8776'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd3ec6e15-f9fe-49d0-85a3-d39d81c1eab9',
    '5fac633d-729b-458a-968d-2cbd7dbfdfef',
    'Mr Andrew D Archibald',
    'C/O JLL, Unit C1, 4 Riverlight Quay, London, SW11 8DG',
    NULL,
    '02078524582 - agent'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ccd642c8-9e52-458c-80d6-326ae5bf2d14',
    'aef466c8-b2a6-41a4-8b76-1ff0ce5b1b6d',
    'A S Bailey',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'cd3e2c05-0919-4323-b677-ef3a793990a8',
    'ebeed557-bd5e-40fc-8a2a-64a633c2b468',
    'T Steadman',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3a1b4ed8-8ab5-481e-ab8d-e3634d2a86c5',
    '975ea509-7fc1-4a5a-8160-4418ee66bbec',
    'Mr & Mrs P Cleary',
    'Pimlico Place - Flat E16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07590 010 555(Sally)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7fe72fb3-5d4d-4bed-9338-6edc9457680e',
    '1435de2b-35a8-453e-b2eb-facdea5be10a',
    'G & L Property Partnership LLP',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '946d7dd7-a13c-47b1-a175-12a27ddf8c9a',
    '43dea602-8531-4ea2-953e-f00ef7a590d1',
    'Mr Hugo & Mrs Emma Brown',
    'The Old Rectory, Stoke Lyne, Oxfordshire, OX27 8RU',
    NULL,
    '01869345293'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1c35c439-97d2-43e9-8ba3-cce86ea079ed',
    '77892e99-8788-4a06-8000-9d6b14c7f802',
    'Mr Andrew Peter Dent',
    'Pimlico Place - Flat E19, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07901513559'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '640a69f7-8af1-4ffa-a263-ca85b97a0824',
    'e968d099-7d06-4708-ba5e-a05008d54d14',
    'D & M T O''Brien',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b903586c-b81f-419c-96a0-543096067af6',
    '3022ee23-b78b-428c-b8fd-d267081f679d',
    'Aquitania Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1e3b140c-7638-45c4-943e-fa6213196a2b',
    'fd3bf276-31f3-44bd-8f0f-c97101f92932',
    'H E Tortoishell',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'efae7f21-4b05-4229-ae01-d5a421a89323',
    '506526bc-db6b-48df-8569-8149670364b7',
    'Mr P E Morris',
    'Pimlico Place - Flat E23, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0f515275-4e1d-4b2a-9523-00027b01f2ab',
    '22c64ad4-8bfb-48fb-ac77-6383950ebbd8',
    'J S & M P Ogilve',
    'c/o Chestertons, 26 Clifton Road, London, W9 1SX',
    NULL,
    '020 7357 6911'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '09e0ba6e-b908-4fdd-9714-b5e7b1cfff4c',
    '71ef69d5-e4c5-414c-a1ef-0c6e4ff321e8',
    'Kristina Stowasserova',
    'Pimlico Place - Flat E25, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c64e8f7b-ae5b-4e96-b8be-14ce326410bf',
    'ad38ae69-d81c-4953-98ff-b1cbdf57aea4',
    'J Harries & E Choi hung Lee',
    'c/o Andrew Reeves, 81 Rochester Row, London, SW1P 1LJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1e0ffd9d-9c24-4c09-98b9-7167b558cc16',
    '39ebcbc0-a2fc-4541-b3b8-c51b42bd844d',
    'Mr N Sapuric',
    'Pimlico Place - Flat E27, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3d4a59d6-76a5-47bc-9c61-1d5afdc45bdf',
    'b7cd4c72-e584-4fb0-a503-0e3a277a1672',
    'Mrs F Meneghel, Mr M and Mr L Frattini',
    'Pimlico Place - Flat E28, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02076308227'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '799d8e33-336d-4c8c-96dd-446fc9057b48',
    '4ac24ebe-3ac6-4e5c-b3c5-a2294d9669f1',
    'David Chi Leung Tong',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5283769b-3690-4a07-a93e-fecedc3cf755',
    '478c7061-9094-49af-9130-2698645863d8',
    'Dalmatia Investments Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '95d209f5-9d48-4f86-a61f-7c0a01442e0b',
    'e21cca98-abb3-4601-a1f5-4f77bc7ab030',
    'Mr S & Mrs G Evans',
    'The Manor House, Adwincle, Nr Oundle, Northamptonshire, NN14 3EA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6247fe04-4897-4450-8a50-b8246ab06ed8',
    '46cd3ea0-af30-4fc8-a73e-24d57143607c',
    'James Luke Holdsworth',
    'Lowick, Lincombe Lane, Oxford, OX1 5DZ',
    NULL,
    '0208 6754349'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ca85902e-c88c-4d83-8025-d7e42bbee7ca',
    '4d185389-cd70-4f46-b58b-828f560237e1',
    'Hibiscus Investment Holding Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '23cdeb2f-8aa1-4fc7-be96-a210b59bd475',
    '6853fa14-9b87-48f5-b507-d5bea0eb0194',
    'Hibiscus Investment Holding Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '97ab2fcc-ecc9-40ce-a910-fd28fb4b5116',
    '781515e2-4996-49e8-b28f-d8fbd5c676cf',
    'Mr & Mrs A Aglionby',
    'c/o JMW Property Management, 71-75 Shelton Street, London, WC2H 9JQ',
    NULL,
    '020 8012 7965 (JMW)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '825926e3-ee89-4a9d-b583-175b2ccd81ca',
    '9d08a983-38b1-4222-a918-f48a82d6816f',
    'Karen Alexandra Hamilton Hobson',
    'Flat F5, Pimlico Place, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c9d0d4d6-988c-4a93-ad72-d284707e2366',
    '72216c0d-a687-4b35-a477-79ae112bc2e1',
    'Yaroslav Kukharev & Kateryna Potapova',
    'Apartment 70, Consort Rise House, 203 Buckingham Palace Road, London, SW1W 9TB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '93a6ffdb-addd-4f96-adaf-7ea7bcbbc868',
    'c8f4a7e0-8f4a-4316-84ca-12b3d8788847',
    'A Protasova, T Protasova, V Damaskinskiy',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f5af4af5-9018-4d5c-b9bf-821d72baaf0e',
    '65012b45-fc4a-4081-a27b-b1c46c66fa8a',
    'Network Homes',
    'Pimlico Place - Hindon Court Shared Costs, Olympic Office Centre, 8 Fulton Road, Wembley, HA9 0NU',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Budgets (1)
INSERT INTO budgets (
    id, building_id, budget_year, total_budget,
    budget_period_start, budget_period_end, status
) VALUES (
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    2026,
    1105576.0900000003,
    '2025-04-01',
    '2026-03-31',
    'final'
) ON CONFLICT (building_id, budget_year) DO UPDATE SET total_budget = EXCLUDED.total_budget;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '99ea1045-1fe1-4346-8b22-e36a866d5a8c',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Porters salaries and expenses',
    120000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8de0525a-48b0-41a7-bf36-8d8fcb7f7c29',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Relief cover - weekend shift',
    38000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '912040a5-27fa-49fb-84ab-38559d960101',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Relief cover - holiday',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cbe1a122-88ca-43a6-a109-a00a05d31a9f',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Cleaner',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8c9c0efb-dc7b-4815-a77d-c44912765053',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Relief cover - sickness',
    1250.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'fa72b58d-0999-46e4-8acb-41a650e071b0',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Sundries and petty cash',
    500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e45422ec-cd2e-44eb-b2b8-134a81eb628e',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Telephone - main reception and internet',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '34d3e5ba-a066-4b27-aa83-af82553cbf7a',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Uniform',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '00f62ff5-a669-4cc8-a53a-50c1c142ab5a',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Staff',
    165850.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'b1f94d31-ae9c-4038-9b78-08cd25339453',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Cleaning materials and light bulbs',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'eefa4d3e-cb02-4c6d-91a2-e53675e9c7aa',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Cleaning',
    32760.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f80acf98-4fe5-492f-9776-73a64ae7ac1d',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Carpet/floor cleaning',
    1584.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '80c32989-e94f-4247-89ac-9f3a5de936fd',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'Car park repairs',
    500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '1851ced7-2f2f-4d19-b77c-7a54757ed898',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'Gate maintenance',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '69dd34d2-23e7-4812-867c-6670358e1b60',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'CCTV',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a3fe8506-b19d-4edd-9882-e4b60be906c0',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Door entry system',
    1800.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '3dea2668-5384-4e01-b7a3-fbcf54e0c4b0',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Fire alarm/extinguishers/emergency lights',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '27cab3bc-6ed8-4237-a68c-0c4ee84aba3d',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Roller shutter',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '6abf7891-9511-4c80-96d6-1fb80f19e7f6',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'gardening',
    'Gardening',
    5075.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '98be823e-9f38-4db0-a802-fa0f6a11637c',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'General repairs',
    24000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cb383047-d0c9-4878-858c-ee2e55b9bacc',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Back up generator',
    1200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '3cec6206-1ca3-4383-971f-4479ba9f05bf',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'Gym maintenance',
    6000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8a01f1b4-1ec8-4e64-b7bb-d488ace8d8a0',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'compliance',
    'Health and safety',
    1600.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4d404dcf-a8a5-4700-847a-d8eb59e67e7c',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'lifts',
    'Lift contract and repairs',
    15000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'bce0ec5f-4e18-4462-904f-34d4589c7ce2',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'lifts',
    'Lift telephones',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '13f177d3-c37c-4419-8c8a-7bca6c7a435d',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Lightning protection',
    324.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '09cc9f87-3101-4b05-a9df-ef923f38844c',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Mechanical and engineering plant',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'c20b76e4-31a3-44af-a314-12b96e328d53',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Pest control',
    1760.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'db62f804-8885-47dd-8e0a-ff31f668ab68',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'Redecorating common parts',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '6c887d83-edda-46ab-a23d-a4490da7172e',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Refuse',
    1650.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '19ad2a06-24da-4667-b058-1a9e72d7ab58',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'TV and satellite',
    250.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '6c8a8366-432e-47c1-9b64-ae7247d85b11',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'utilities',
    'Water feature maintenance',
    6570.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '3d2ae4f6-3017-4b8d-8d7d-b0e6cc094f49',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'utilities',
    'Water hygiene testing',
    3650.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4ee199f6-8b42-4b0f-8a90-4c0a1f0721ef',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'cleaning',
    'Window cleaning',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'be0920ed-ec71-44df-8c37-5930c3524cf7',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'repairs_maintenance',
    'Contract, Maintenance and Services',
    122223.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '41468449-e32b-4f8a-bf40-5d9adfc33df7',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'utilities',
    'Electricity',
    80463.62
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4d80c4bc-22cf-469d-a139-a69b4a73696f',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'utilities',
    'Water rates',
    27000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a6f4f950-596f-48fd-9422-66e9d37447ac',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Utilities',
    107463.62
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '0ec84b57-313a-4785-ac1f-14fd1c02c974',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Buildings and terrorism',
    88633.42
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '5c168a66-595d-4066-9694-5271e425a379',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Directors and officers and employee protection',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '683e81c7-0ebd-43e1-92bd-ecc8978b0b22',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'insurance',
    'Management Liability Insurance',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '701f6311-43f6-4f0c-8719-8cfbd62772b6',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Engineering',
    3100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '11dbacc2-5349-4e0a-bd00-152c25138d78',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Contents inc. gym and office',
    3300.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'db65ef0a-1bc4-4181-9f3c-66d059e24c0f',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'insurance',
    'Insurance excesses',
    1400.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'aa2a49ea-272c-4aa9-a204-3d8e1930ea95',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'insurance',
    'Insurance',
    98633.42
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f66aed31-b074-4b37-aee7-7f9798328d39',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'professional_fees',
    'Accountancy',
    2200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e2ebd966-d65a-4525-9091-e5ee3b44c475',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Legal and professional fees',
    2500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '5e76c059-ca42-4617-ab63-976525b50d6a',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'management',
    'Management',
    25642.8
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '662cc068-4a5b-4e85-a0ca-65a0a8c2fa98',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'management',
    'Vat of Management Fees',
    5128.5599999999995
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'aede6e37-edda-472d-b524-7193d7b66ada',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Bank Charges',
    280.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '93f230b6-f859-4d2e-868f-406e690b6025',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'professional_fees',
    'Company secretarial fees',
    480.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e6d65c81-74ac-4956-b82c-c61911c0a2e2',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'compliance',
    'Building Safety Act',
    11940.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4f525074-493d-40f8-9e66-21ce8f0e678f',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'other',
    'Professional Fees',
    48171.36
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f1d5d0fb-e85e-4d47-b8ae-f44e6e48a5e4',
    '6885449e-1a3b-4c71-924b-7b378b8c16ba',
    'reserve_fund',
    'Reserve fund',
    20893.29
) ON CONFLICT DO NOTHING;

-- Compliance Assets (4)
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '632bd94f-39c6-40a9-b43c-cd69be850404',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    NULL,
    NULL,
    'Unknown',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '5ea1b181-e9f5-4497-9b67-2c07b42ddd7d',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    '2025-01-07',
    '2026-01-07',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    'b0cfd01e-5f56-44a7-b509-672ba64839a3',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    '2025-08-18',
    '2027-08-18',
    'Unknown',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '35564cc6-1c4a-4a4c-907f-5e3bfdbe5801',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    '2022-11-30',
    '2027-11-30',
    'Unknown',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'EICR';

-- Maintenance Contracts (28)
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '5496b9f0-09ac-4810-8497-502aaf1dca02',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    's or consultants are used to carry out work which we 
are required to sign off prior to the completion of the Services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'c5a6d315-1787-4ec4-a8db-522c6c47c727',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'must consult Polyroof Technical Services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'LIFT_MAINTENANCE';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '46bb4a32-b1bc-4e21-be60-b827f456bd26',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'should take the necessary steps to identify the location of each of these 
services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'GARDENING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '22b7936f-c085-49fb-a04d-af18e07a2b69',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'asked voestalpine Metsec plc',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'LIFT_MAINTENANCE';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'e06dfd94-c2f2-48d3-9917-26e7b99a8e24',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Iden tification  Thermoguard Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '0649ba52-edde-4654-ae04-e85afa3efc4a',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'has installed and applied 
PermaRock materials in accordance with the specification prepared or agreed in writing by PermaRock     
Products Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '9eadeaf4-d6c0-40f8-a080-f84b30fe5438',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    'c3c7e111-4a4e-4ce3-9566-ae0badbcd740',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    'aa113c8a-a18c-4529-a848-b6f052362224',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    '7e39f318-1fb1-4218-a6ff-1fe900052065',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    'd1b9ad69-a922-48be-be3f-76240906d064',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    '445db329-0a17-43c3-98a9-5889d80ce792',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
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
    '12d0eabb-d014-4113-86a3-d9f53475247b',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'to whom 
Urban Rope Access Ltd  is to provide  services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '7887a233-18d1-4ec9-b6f6-d3e7ba9fcc94',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'will provide the services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'PEST_CONTROL';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '50c3a896-0119-44f0-8521-944dba8bf63b',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'will provide the services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'PEST_CONTROL';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'c0673ba0-cddd-4567-85c0-2940f0a98e86',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'for all purposes relating to the performance of the contract of

employment including but not limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '8600926b-c6c0-4012-83b2-c286b13cf43c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'shall provide in respect of the S ystem the additional services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '78633036-0499-4cd8-b495-9a5e417c37d8',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'shall provide in res pect of the System the additional services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '5c757c58-f1b9-4055-8ee9-abb2acb5e7a9',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'shall provide in res pect of the System the additional services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'd4fdb6ac-2704-4e81-85c0-9f9098ebe2ed',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'shall provide in respect of the S ystem the additional services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '40d5f6c7-6aa1-4af2-bba9-f15416f67177',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'is agreeable to providing such services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'db718cc9-4a64-408c-a042-9185fbbd9b9f',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Ltd
Grainger Pimlico Management 
Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'c85c6223-6a6e-43a9-8aa4-dbaf4fd616c8',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Ltd
Grainger Pimlico Management Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '1ddfbe1e-accc-433f-a467-c9dd0fb3bf39',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'e72f4bf7-d147-41c8-808b-b7cc55f7b198',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Ltd
Grainger Pimlico Management 
Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '3e2fd77f-73bd-4921-b4d7-1e1294217d2c',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Ltd
Grainger Pimlico Management 
Limited',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '4c3b99a5-a3a5-4fa4-bea8-3e1c50176b31',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'Target Lifts Ltd',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CLEANING';
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    '607a7a77-b1d3-404f-8005-11f368be11e7',
    '6d96c322-3f31-4e6c-a8a7-bd6d814e5bfb',
    id,
    'NAME  Grainger Pimlico Management Company Ltd',
    NULL,
    NULL,
    720.0
FROM contract_types WHERE contract_type_code = 'CCTV';

-- Contractors (5)
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'ee9a959c-3316-4d40-a62e-dec299aeb1c0',
    'Maintenance and Services',
    {"repairs_maintenance"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'b7628f1c-52c0-4b1b-b4a0-17d761963192',
    'NAME  Grainger Pimlico Management Company Ltd',
    {"security"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '4c62551f-bdbe-4a2a-9cf4-8b2e1079cf02',
    'Ltd
Grainger Pimlico Management 
Limited',
    {"fire","general"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    'a3631081-8480-49c1-9ad6-2f721df2884f',
    'Iden tification  Thermoguard Limited',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
INSERT INTO contractors (
    id, company_name, services_offered,
    is_active
) VALUES (
    '81da152b-2764-4baf-9f0f-2ce8b40b972b',
    'Target Lifts Ltd',
    {"cleaning"},
    TRUE
) ON CONFLICT DO NOTHING;
