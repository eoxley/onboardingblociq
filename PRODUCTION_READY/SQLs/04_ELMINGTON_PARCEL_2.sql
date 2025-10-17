-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T14:10:26.415562
-- Building: 254.01 ELMINGTON PARCEL 2

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '254.01 ELMINGTON PARCEL 2',
    NULL,
    NULL,
    104,
    1,
    NULL,
    FALSE,
    'Not HRB',
    'and general arrangements are based on a visual inspection only with no intrusive surveys being',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Units (104)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'db16a4ac-f0ce-491d-ad46-1a89dafe43a9',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'Reference',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0c271bcf-1360-4876-8031-dd50390a4463',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'These are missing from FirstPort',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e1dac738-c017-45dc-bf60-f2c640587703',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'Produced 12:55 13 Jun 2025',
    1,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5924e579-67db-49b3-993d-960e86ae1aac',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'Produced 12:10 15 May 2025',
    1,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '54310214-fd24-41ec-81bd-ea4119aa154a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640A',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '501bf761-9eba-49be-9519-ee60443ab149',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640B',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '438b9641-b515-43bd-b0a8-443600d6cee6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640C',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4214f11c-9aa6-4cd4-bd92-67f40b3ba829',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640D',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2fa328af-fcc0-4171-951e-3c7c3391e56f',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640E',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '33ba7c8b-c65f-408c-8e06-2fa23432a60a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640F',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '45e36337-f36a-48aa-85e9-4bb8d38172b2',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640G',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bb39f356-169b-4555-b9df-5e30bd7edde6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000301',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2b27f0f9-f0b3-4575-8171-937ac67730c8',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000302',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '37291fbe-df5a-4303-8985-63264cc7c69c',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000303',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '42f775ce-1b3a-4768-be25-13fbd46bd776',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000304',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a5acba18-034b-4bb3-a31b-1df92d9bd3d5',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000306',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5f7efa6f-42d9-4455-a8e3-979fa68d5580',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000308',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bc6fb82c-eb3e-4298-9b45-3bd30eb5851a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000310',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e9ad3aa2-358c-424e-9511-172a7cd1c4d8',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000312',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '84760ac4-37d1-49a4-83a0-1fc83c0f546b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000314',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9a3ce5d1-c280-4593-a1c0-3b1bc60ac253',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000316',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'df8191d6-3416-473a-9e38-6674953d04c6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640000318',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '953c7e76-765e-497d-a5f6-1bd718281ca9',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640001102',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5c7df824-ac01-4bf8-933c-4f8854f7e7d7',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640001104',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '454ed4ae-c911-4226-8438-5bcc43ba510e',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640001106',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '49d9fd28-0b57-423e-b2b4-d1a76fb0bbe3',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010001',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4fbb6d7b-2245-4f95-a0c4-7487f152a375',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010002',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '95617a20-f9ab-4d4e-bd02-99274fd51922',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010003',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7c2b19d7-b5f0-4b3d-9878-922dce107ef3',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010004',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '629159c8-b28d-4b79-950d-b739f3720656',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010005',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2b72e129-9aee-4c43-ac41-a0a6031df3a0',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010006',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f97619c7-2703-445a-bc41-ba8e8db3b16d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010007',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c6377ffe-26da-437e-9935-ce329ab5cd13',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010008',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '03b941e1-f526-4fe7-ad3a-56ac7e1d8e02',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010009',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '92ac7cc6-270f-4ed1-9888-274262c649c2',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010010',
    2764001001,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a83891f4-1916-4e79-a022-a808185fc35e',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640010011',
    2764001001,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2468b62d-ec42-43b4-9080-2e1bf46c26b6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020101',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5630e66b-5bee-4220-90a8-8fc8e7b9eb61',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020102',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8af7068a-bed4-4595-b1f4-d1e5d6e53300',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020103',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4484dde8-3e07-4186-8f66-d62f9b7676eb',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020104',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '31a8a78d-c8ff-4f24-b272-2035152fb195',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020105',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '89ee63b9-4adf-43f1-8cb9-b0d742a688e5',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020106',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ac6b38c6-20d2-4da9-9589-7cf16d480a5e',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020107',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4d89c85b-92f5-4823-b031-5c70a4528f33',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020108',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a0d34724-dd00-4ce1-a56d-edbcfc840850',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020109',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'adc7c5bb-f890-4bb1-9c69-69cd28938a0a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640020110',
    2764002011,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '11d0ae19-a093-4593-b307-d992ded392a6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030201',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8263a4a3-037d-491b-9c6e-b0b02c424541',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030202',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '07700578-35c4-4f21-9adb-b31bd779125c',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030203',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1bb30a8b-679f-4c68-8b37-4aedb6b99b25',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030204',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b6fb741a-3752-4d7c-bbdc-ac57bf248962',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030205',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b1911ba6-cec3-4cfb-a8c5-754ea6d6c012',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030206',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '69a33511-9d21-4025-aaaa-c95a6f27ba1a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030207',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '45b79a51-132c-4ac1-add7-e26d7ffbe0e3',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030208',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ec65dcb1-5d4c-4013-ad4a-744b2d0f2573',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030209',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e0090bea-d1b2-4c94-b929-207339f0c30a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030210',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '39c30557-f69d-4e73-996c-49b0d07d74e1',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030211',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '66aec674-445d-4291-84b9-800314c2d55a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640030212',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '23ee0490-52b1-444d-b128-a84ba676ed2b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640031008',
    2764003100,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3eab1994-d3af-4750-a275-3b7c19ee149d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640031012',
    2764003101,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '50082988-1677-412e-876d-87c0852d727b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040401',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c12ad235-2da1-479e-8070-f9bf6f40d8a1',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040402',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'beeff3fd-3f83-4dc8-8fe2-6ccea0f71fe9',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040403',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4bdfbad5-cafc-411c-bea1-ee85bd939b7d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040404',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4235264c-77e4-46c7-a711-21e82e05106a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040405',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '23e97311-152e-4615-b71c-a32c6659394d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040406',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f9b3d939-f770-4241-bf74-03478f36fcfd',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040407',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '015998a5-f5d6-45b9-86ac-478c42029d04',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040408',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5e731609-84fe-4912-80ba-f7e03b0a7f28',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040409',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b75f1384-6edc-4df8-adf1-1f71b095ffb5',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040410',
    2764004041,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '99e501bf-31ec-474f-944c-0b685e6dcbb6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640040411',
    2764004041,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '47c62530-89b9-4b12-81d9-5a07c232336d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640041404',
    2764004140,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '12789f90-25b8-405b-bb7c-a6d11616709d',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640041408',
    2764004140,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'edc2d687-cd44-41f3-b9dc-0e75d0e0925f',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050501',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '62f3ee5a-d870-4d6f-9d41-4005bb77997a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050502',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ff34f6bf-32a1-43c7-bc5c-7f24ccd81497',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050503',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6cd29421-ddb5-42ef-a987-b2d7c2eae523',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050504',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '43566e0c-1e1a-4cf4-92ef-fec190d90923',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050505',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a22b080f-43f0-4a17-b97d-6cc25ee2c409',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050506',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '80c4d92b-0a51-430e-aa74-5980eeb16a18',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050507',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '420cadf3-47ba-4e20-a6e2-28540e81d798',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050508',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b9c1f100-9ab8-4c49-ae08-dedf97803c4e',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050509',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4f0b0cb1-39f2-4a29-b88a-647346c4b452',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050510',
    2764005051,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f2a90b0b-77f4-4e4b-a48e-455984e42170',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640050511',
    2764005051,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6db7733c-7911-4fce-8595-017bbeef16e2',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060601',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1a794a75-500d-45e8-a299-1bc3d19647e6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060602',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f7a04304-57d4-47b5-9725-1fdfe33d9afb',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060603',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1481440b-e080-419d-95d8-745f4f8a85d9',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060604',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '946cf58d-94f8-4a7c-96c8-8591ef2b71de',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060605',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd1790e92-bbd3-49ed-b945-2e2beafe5982',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060606',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '78f602ca-0415-4ef4-bc57-3215c85435f5',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640060607',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ab24f9aa-0660-4352-ad2e-97ae7accb942',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070701',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7353c8e3-62ba-4f75-af57-c3aac8a06106',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070702',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '83e78f5d-d3ee-426c-9062-a389ac06719b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070703',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '639b3b45-d207-4080-b47a-b98df85bdf0a',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070704',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '097e6be7-d834-405e-b5c1-6cd63e3db9ea',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070705',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3967fc21-8df8-41c5-8867-cf9a80020a9b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070706',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c12ffebf-0387-4b93-9913-47ef9bd7c721',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070707',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ad2f6fdf-ae5a-41d5-85de-966fbf8398fd',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070708',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '70b8143e-f9e0-4bc1-9f45-4fd48b36baaa',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070709',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '500fc539-a7ba-42c0-a343-ba0d0c4fc697',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070710',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '949a852b-8d58-463a-a51d-28247c3b35d6',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070711',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2989e10d-6155-47e5-be05-a5af1fd857eb',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070712',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e76d9850-91dc-4067-9a86-8483dffb340b',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '27640070713',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (93)
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2d1c2822-7946-4961-b808-74831bacffc1',
    'bb39f356-169b-4555-b9df-5e30bd7edde6',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '75cfc707-ceff-4dcb-a788-a3c0d623e526',
    '2b27f0f9-f0b3-4575-8171-937ac67730c8',
    'Oliver Johnstone & Rachel Harris',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ce3689e4-4a04-457f-90da-6ddf1d78a72e',
    '37291fbe-df5a-4303-8985-63264cc7c69c',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4c883046-7b4f-4e0c-b237-7801b12e207a',
    '42f775ce-1b3a-4768-be25-13fbd46bd776',
    'Anna F & Laura D & Alice N Russell',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '800a314d-eaca-41bc-96e1-a7305789707e',
    'a5acba18-034b-4bb3-a31b-1df92d9bd3d5',
    'Lucinda Marshall',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c88e6d8c-850f-4e82-9a28-854dbc498d0c',
    '5f7efa6f-42d9-4455-a8e3-979fa68d5580',
    'Mr L J Lee & Miss J H Bentley',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f857cbb1-dec8-4b31-8e04-1ac36ee06a0a',
    'bc6fb82c-eb3e-4298-9b45-3bd30eb5851a',
    'Gareth Briggs & Claire Maddocks',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7efca9e2-1b7b-414b-b8f8-10ab2594aa9a',
    'e9ad3aa2-358c-424e-9511-172a7cd1c4d8',
    'Mohamed Shaikh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '24f05c39-2923-4d76-89ee-afd49863b06d',
    '84760ac4-37d1-49a4-83a0-1fc83c0f546b',
    'Katherine Stirrup',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '97f2a7c3-85b7-4417-be7d-493a7b5fb348',
    '9a3ce5d1-c280-4593-a1c0-3b1bc60ac253',
    'Jacob Miles Davis',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8127898d-ddb7-4252-95da-5c0f519ecca0',
    'df8191d6-3416-473a-9e38-6674953d04c6',
    'David Tamal Zentler-Munro',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8ddf7eab-5044-4b7d-ac5b-bbcedd10e19e',
    '953c7e76-765e-497d-a5f6-1bd718281ca9',
    'Toby William Weston',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '01b4bb32-0060-4056-bd0f-83ac02732e09',
    '5c7df824-ac01-4bf8-933c-4f8854f7e7d7',
    'David John Glover',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '14ae82f7-a248-4b8b-a53b-801cbdbf5056',
    '454ed4ae-c911-4226-8438-5bcc43ba510e',
    'Bernard Asiedu & Akua Domfeh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7715b987-1283-4c3e-ad9a-42406fd5e54f',
    '49d9fd28-0b57-423e-b2b4-d1a76fb0bbe3',
    'Mr J P Miller & Ms L F Miller',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e869177b-a708-444f-82ca-94f2c28ae555',
    '4fbb6d7b-2245-4f95-a0c4-7487f152a375',
    'Sarah Brereton & Michael Ward',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b9e11679-83be-4dde-8d74-a4b174f9648d',
    '95617a20-f9ab-4d4e-bd02-99274fd51922',
    'Robyn Hodson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4608557e-b8f2-4158-81ca-da803983c2c4',
    '7c2b19d7-b5f0-4b3d-9878-922dce107ef3',
    'Sophie Goddard',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '029d45a7-c920-4931-9a2d-a496a80c05dd',
    '629159c8-b28d-4b79-950d-b739f3720656',
    'Kathleen Elizabeth Ward',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b458d522-2c97-43b8-aef9-0a8c9568ba5e',
    '2b72e129-9aee-4c43-ac41-a0a6031df3a0',
    'Jaspreet Singh Gill',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '24e7a404-28fe-4629-a9a7-8805a55f26e7',
    'f97619c7-2703-445a-bc41-ba8e8db3b16d',
    'Luca Montalto Giampaoli and Federica Michelin',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '1dec4ea9-0e1c-4bb6-9f75-d47b1cceacde',
    'c6377ffe-26da-437e-9935-ce329ab5cd13',
    'Malcolm Shaw',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3bee47fa-fa81-4321-8bdf-fa5e8b711d14',
    '03b941e1-f526-4fe7-ad3a-56ac7e1d8e02',
    'Edward & Alice O''Connell',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '70777196-d04d-4891-9df4-2d68c8eb8cb3',
    '92ac7cc6-270f-4ed1-9888-274262c649c2',
    'Bram Wal & Chin Tay',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9c163620-f481-405d-9aa5-454790ca4727',
    'a83891f4-1916-4e79-a022-a808185fc35e',
    'Jack Howse',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '26b2cd9a-d866-493c-a77b-48441803db62',
    '2468b62d-ec42-43b4-9080-2e1bf46c26b6',
    'Swati Ahuja',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7432c333-13fa-48f0-aa57-8c86bec6f175',
    '5630e66b-5bee-4220-90a8-8fc8e7b9eb61',
    'Zerrne Henderson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a595b33f-f191-4115-b933-fd044d451583',
    '8af7068a-bed4-4595-b1f4-d1e5d6e53300',
    'Symone Krimowa & James Zuccollo',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0f863600-47ff-491e-8a67-0f1b9a9e1f61',
    '4484dde8-3e07-4186-8f66-d62f9b7676eb',
    'Stephen Pearson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a7422d03-76b2-459e-8118-30a9f125c5f9',
    '31a8a78d-c8ff-4f24-b272-2035152fb195',
    'Thomas & Henrietta Scrope',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '08d467a2-4e7e-4fba-b1c3-d67c1c5188e5',
    '89ee63b9-4adf-43f1-8cb9-b0d742a688e5',
    'William James Underwood',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '02b26937-9edd-4be2-ad68-9167efdb8a7f',
    'ac6b38c6-20d2-4da9-9589-7cf16d480a5e',
    'Helena Varley',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '77b77cb0-4f9c-4bef-950f-83e0f4619b2b',
    '4d89c85b-92f5-4823-b031-5c70a4528f33',
    'Claudia Lauren Ballard',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4a8bbaf3-d527-4e74-8ef5-3e71ce3a0456',
    'a0d34724-dd00-4ce1-a56d-edbcfc840850',
    'Francis Powell Smith and Amanda Nicola Chetwynd- Cowieson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0b2d0d9a-f749-4848-929c-cda5393186a7',
    'adc7c5bb-f890-4bb1-9c69-69cd28938a0a',
    'Nicolas Harvey',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'cd5818d5-91b9-4b16-b2a8-4e0ce7bc6195',
    '11d0ae19-a093-4593-b307-d992ded392a6',
    'Anas Nader & Yasmin Maksousa',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4068464d-45e8-4b50-aefe-b571961be0e2',
    '8263a4a3-037d-491b-9c6e-b0b02c424541',
    'Ellen Brown',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '59d6836b-6032-4645-a232-d021b2ecc9ab',
    '07700578-35c4-4f21-9adb-b31bd779125c',
    'Michael Walsh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7d8d3fbd-a7ee-40f5-831c-11af725cee91',
    '1bb30a8b-679f-4c68-8b37-4aedb6b99b25',
    'Holly Power',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0522f6be-dde6-4b55-9248-f5942262b324',
    'b6fb741a-3752-4d7c-bbdc-ac57bf248962',
    'Emma Powell & Daniel KC Wong',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7cfb81e8-2e2f-4ea5-85be-3be87affd37d',
    'b1911ba6-cec3-4cfb-a8c5-754ea6d6c012',
    'V Z Zlatanov & L A J Simon-Dufis',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '27e632ff-677d-4d31-841c-6b162f9ee84c',
    '69a33511-9d21-4025-aaaa-c95a6f27ba1a',
    'Amy Cheung',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9cdbc33e-edd9-4750-b09b-2dab21ac2a84',
    '45b79a51-132c-4ac1-add7-e26d7ffbe0e3',
    'Miss C I Patel & Mr C L Gilbert',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '741141bc-bd51-41a0-8203-078774236adc',
    'ec65dcb1-5d4c-4013-ad4a-744b2d0f2573',
    'Roxane Barsky',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '85d1e5ce-583b-46e8-a255-e17ee7b5db72',
    'e0090bea-d1b2-4c94-b929-207339f0c30a',
    'Joseph Christopher Butler',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5fe00c92-5f5c-4574-b318-e0d6bbdfffe3',
    '39c30557-f69d-4e73-996c-49b0d07d74e1',
    'Diederik Winershoven & Gabriela Patrikova',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9fd13ba8-4893-4de9-851e-b6c0a2922c14',
    '66aec674-445d-4291-84b9-800314c2d55a',
    'Laura Smith',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f81c9aa8-6e9b-4c28-9786-aab3a25ddd99',
    '23ee0490-52b1-444d-b128-a84ba676ed2b',
    'Andrew Miller',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e68b8932-268f-46b4-8496-5031f3cd5d31',
    '3eab1994-d3af-4750-a275-3b7c19ee149d',
    'Nivardo De Amorim Gallo',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bf9eb1a5-f0a5-4c0e-aaac-eb6c5c385209',
    '50082988-1677-412e-876d-87c0852d727b',
    'Jordan Corner & Edward Ince',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ca978610-0af3-46a1-9a82-96f0d6dd9f0f',
    'c12ad235-2da1-479e-8070-f9bf6f40d8a1',
    'Nicola Mooney',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd10143b9-2a81-443f-aa7e-bc58461421dd',
    'beeff3fd-3f83-4dc8-8fe2-6ccea0f71fe9',
    'Manuela Hernandez',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'eb90ea56-939f-4f9b-950a-6cf263ca0ab9',
    '4bdfbad5-cafc-411c-bea1-ee85bd939b7d',
    'Edwin Henry Malins',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5d9d426d-f093-4d74-9991-de8f5738f332',
    '4235264c-77e4-46c7-a711-21e82e05106a',
    'Andreas Papamichail & Alasdair Anderson Craig Falcon',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '894f482d-64dc-45a0-8e71-58341c882d44',
    '23e97311-152e-4615-b71c-a32c6659394d',
    'Bruno Andrade de Lyra',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fcf2365b-0e60-4a8a-94fd-fd40bbca27b5',
    'f9b3d939-f770-4241-bf74-03478f36fcfd',
    'Christopher L Davey and Wallis C McKendry',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a1b6bdca-2fab-4683-9c9b-bfb977c3ad77',
    '015998a5-f5d6-45b9-86ac-478c42029d04',
    'Samuel Gulliver Naish',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e237f892-caa4-4156-93f7-735cd90af7f2',
    '5e731609-84fe-4912-80ba-f7e03b0a7f28',
    'Rose Moncrieff & Charles Cooke',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '56f436f1-5b78-48ff-9bba-64804d618609',
    'b75f1384-6edc-4df8-adf1-1f71b095ffb5',
    'T A M Revell & I E Steinmark',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b6f33f79-a43b-42d1-9535-39d9eb9aeac3',
    '99e501bf-31ec-474f-944c-0b685e6dcbb6',
    'Mr. George Frederick Bray & Ms. Alice Marie-Grace Panton',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '41e5cf67-51d2-49e9-b982-4c0e185ed616',
    '47c62530-89b9-4b12-81d9-5a07c232336d',
    'Julia Dianne Harrowsmith',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7ea4e707-4ead-45fe-8c92-23ed635ddfe0',
    '12789f90-25b8-405b-bb7c-a6d11616709d',
    'Natalia Tothova',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2e7f0a17-c236-41d1-8c52-bc461c5171f8',
    'edc2d687-cd44-41f3-b9dc-0e75d0e0925f',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4640145f-9d3f-4682-94fd-f2e1ea15e7ca',
    '62f3ee5a-d870-4d6f-9d41-4005bb77997a',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '575ab865-0fb7-41b0-b159-89a867f4237e',
    'ff34f6bf-32a1-43c7-bc5c-7f24ccd81497',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd2920a26-7eb3-40bd-9bbe-c9bff1bd1f82',
    '6cd29421-ddb5-42ef-a987-b2d7c2eae523',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '22bc0dfc-8a09-4573-9dcb-44a07f1a871c',
    '43566e0c-1e1a-4cf4-92ef-fec190d90923',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ac1c329d-e631-40b3-b90b-fa38361dffca',
    'a22b080f-43f0-4a17-b97d-6cc25ee2c409',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6afe49f9-ac41-4a58-9602-49e015808c54',
    '80c4d92b-0a51-430e-aa74-5980eeb16a18',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f28bbe3e-606e-4e3e-aaf7-76af28849fa3',
    '420cadf3-47ba-4e20-a6e2-28540e81d798',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5b143914-b594-4c28-958c-0046a5976161',
    'b9c1f100-9ab8-4c49-ae08-dedf97803c4e',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5e96d010-9d36-41f5-9272-eddebba953bd',
    '4f0b0cb1-39f2-4a29-b88a-647346c4b452',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '83f01e87-c05c-430e-86a8-df9c9ee4c880',
    'f2a90b0b-77f4-4e4b-a48e-455984e42170',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9a1942e8-b321-4d4d-a5ad-0757a3f435a5',
    '6db7733c-7911-4fce-8595-017bbeef16e2',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bb09768e-499d-4872-8a05-70c82ab5579a',
    '1a794a75-500d-45e8-a299-1bc3d19647e6',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c3b41bc1-ae1f-451c-950e-b5235e16fc38',
    'f7a04304-57d4-47b5-9725-1fdfe33d9afb',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b4c47ec2-9213-4876-9b6c-d364702bbede',
    '1481440b-e080-419d-95d8-745f4f8a85d9',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b2cfa3b3-aec0-4f91-8b40-0d42b0925bca',
    '946cf58d-94f8-4a7c-96c8-8591ef2b71de',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8db7c44c-c038-4038-9294-796bae6969d2',
    'd1790e92-bbd3-49ed-b945-2e2beafe5982',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '26ce7c42-1a49-4571-9b19-1e1e08ece0d1',
    '78f602ca-0415-4ef4-bc57-3215c85435f5',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'df071d57-07ff-466d-ad86-8ac19e8f7084',
    'ab24f9aa-0660-4352-ad2e-97ae7accb942',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '562f544c-f40d-4fa8-84ae-717b19228a07',
    '7353c8e3-62ba-4f75-af57-c3aac8a06106',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '55e6cda4-c835-4e9b-b316-89c1d17fb094',
    '83e78f5d-d3ee-426c-9062-a389ac06719b',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5c829562-f435-463e-a8d6-1bb6ac8ee707',
    '639b3b45-d207-4080-b47a-b98df85bdf0a',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '123125f4-d81e-4ee7-8b15-eac321d72718',
    '097e6be7-d834-405e-b5c1-6cd63e3db9ea',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9daee992-767d-4374-87ce-0533a10fc8af',
    '3967fc21-8df8-41c5-8867-cf9a80020a9b',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'eb3e4217-c6a6-4e2b-8d4c-93b8540db651',
    'c12ffebf-0387-4b93-9913-47ef9bd7c721',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0b39af9c-a4c5-47a8-b7c7-8f2d17259817',
    'ad2f6fdf-ae5a-41d5-85de-966fbf8398fd',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '571dad21-3251-411c-846a-090d01c19988',
    '70b8143e-f9e0-4bc1-9f45-4fd48b36baaa',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3d03e50b-4836-49d3-8206-853d58cc8f0c',
    '500fc539-a7ba-42c0-a343-ba0d0c4fc697',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b4759cc4-a584-4b84-bda9-4037c5aa7f6c',
    '949a852b-8d58-463a-a51d-28247c3b35d6',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fd876e0d-8928-4351-89f0-df2c02ef2031',
    '2989e10d-6155-47e5-be05-a5af1fd857eb',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'dcff49ba-8da9-4236-afd6-7aad8cd0a2d5',
    'e76d9850-91dc-4067-9a86-8483dffb340b',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Compliance Assets (2)
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'cdff1ee3-8d36-4d82-afed-09da28e1a448',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'Fire Risk Assessment',
    'fire_risk_assessment',
    '2023-02-24',
    '2024-02-24',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '8d7107b8-1004-4abf-8a2f-7a6d4ccb6c17',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    'EICR',
    'eicr',
    '2024-11-10',
    '2029-11-10',
    'Pass',
    NULL
);

-- Maintenance Contracts (2)
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '24771cf8-cb5d-4504-8881-187229bac1a5',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
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
    'c2844016-3522-4ba7-b889-97e14d074d41',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    's and each contractor engaged to provide services',
    'security',
    NULL,
    NULL,
    NULL
);

-- Service Charge Accounts (1)
INSERT INTO service_charge_accounts (
    id, building_id, financial_year, year_end_date,
    approval_date, is_approved, total_expenditure
) VALUES (
    '4cd6154b-7280-4615-8896-713c97285f32',
    'ecf0b4c5-c7b2-4a0e-aa06-d8a740643a80',
    '2023',
    NULL,
    NULL,
    FALSE,
    NULL
);
