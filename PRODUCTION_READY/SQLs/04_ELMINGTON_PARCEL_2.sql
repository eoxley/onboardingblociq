-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T16:19:44.248706
-- Building: 254.01 ELMINGTON PARCEL 2

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    '5209d414-f09e-4292-8a47-b8d39225a37c',
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
    'a722f810-1d5d-48f4-9a64-4adafbd42e00',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    'Reference',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8caefcb0-e842-4e8b-8dc6-5da24750e44e',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    'These are missing from FirstPort',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5e0b7238-9bd6-4fce-be48-b265c1e18cb6',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    'Produced 12:55 13 Jun 2025',
    1,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ed635cfc-9b49-4c18-a4e8-ec174c02423c',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    'Produced 12:10 15 May 2025',
    1,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '549514dd-63e2-4072-a983-98340963e3e1',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640A',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '04055872-15d3-437f-a079-72b75a5ee9b6',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640B',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '18da83cb-43cf-4571-8a1e-d434c2d60fea',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640C',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '55c2a3ec-a3b1-4b02-a9ee-b521dafa520d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640D',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2b0df216-a335-45a7-ac06-cb943d6a0767',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640E',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6f36f72a-888d-43a3-b646-095ecbc4bd7b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640F',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fd2a8c3a-680b-47b1-94ac-82b4d748ba26',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640G',
    2764,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e79b110f-6e51-4b2f-8636-46923ad86873',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000301',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '98bfb4ab-eef6-4e7b-a4df-ca5f48eeda25',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000302',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5bb319de-aa77-49d9-ab1f-aedd2022ecfe',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000303',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e90cfb1b-860f-4479-b800-70b2a0074646',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000304',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '63a03f12-9400-426f-a948-e6bb8b3ea564',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000306',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1f5dd515-d194-4cb5-b011-cd0fb005b429',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000308',
    2764000030,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '268bf71e-3fd1-4514-968a-3fc23bbc2057',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000310',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '15cb5a7b-83af-4fa6-8e0e-0892375140b2',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000312',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '91bb55b9-31c0-4e77-bb56-8ccf9762c1de',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000314',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '59398941-73c1-4cff-906a-9505b7634b36',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000316',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8bfdab79-1cbe-4139-b0e1-15b17c2fc6c1',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640000318',
    2764000031,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bb29fa0d-cbb6-4491-94b2-934ef44a1e0b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640001102',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dec038bd-2937-4fd9-aea2-cc45e5e8dc2b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640001104',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '854772d1-2c38-4166-8399-a63e83baa4d3',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640001106',
    2764000110,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '532abcf1-bd41-45ed-bf8f-fa9c814d199a',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010001',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '96b9044f-abb7-40cc-98a8-8434cf7ca201',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010002',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6dc98f2e-5355-4d08-9dc3-0abeabaa50a0',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010003',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '218edcef-71c9-4b40-adfb-85fdadaa07c0',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010004',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '28bb2cac-e3e5-4264-81d5-7f31cbfe7976',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010005',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'be89a8b2-84f6-4de5-9f70-17b63fc91b4b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010006',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8e17b891-8c2b-41f0-8ab3-c35a9ab3a322',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010007',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0b90c265-debf-4c4f-9fe2-eb5bb639292b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010008',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c1bc525a-74aa-4c90-b1da-47f86af65404',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010009',
    2764001000,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6d796acb-6901-4909-89f6-65fabe726d48',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010010',
    2764001001,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1830bb11-4391-42df-aaf4-ec2796c68eac',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640010011',
    2764001001,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1a40f284-d15d-4f9b-9c66-ec179e976ec3',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020101',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'aa9cce1e-8f99-4869-9bc7-74c7092557e9',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020102',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e334c0ce-e2e5-40c7-8d95-e2c128633e00',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020103',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0f2d950c-7efd-48da-ab75-31cc51cf4503',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020104',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c801b657-5bdd-441f-907e-1418a7ea6087',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020105',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f9a1c232-c7bf-4bb3-8942-14097619499a',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020106',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bdcee340-af55-460f-a097-ee6cd1906a90',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020107',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1a5fb2be-230a-4e11-be5a-b537bf0ad85f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020108',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd5625678-9a4d-45bf-84fb-0577c7f76dca',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020109',
    2764002010,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fc842bb5-51e8-4c9a-a8f7-dbfcf63b2426',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640020110',
    2764002011,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '20af07fc-26bf-4c64-98bf-0dca15e9780b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030201',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b63c52cb-f7c2-45c5-b05b-ea1f7840456d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030202',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8fb24ad2-eea7-4ab9-8e7a-6c6668d7fa32',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030203',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8317e0b2-7a90-4d41-943b-1aca5f7c8813',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030204',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2f4585fc-3025-4960-b16f-4ea37f8a299a',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030205',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '197f0293-717e-4439-b986-483e784a743e',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030206',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '741b396c-41a9-4f07-a8e9-fb972a0c0dc5',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030207',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '89d13b9e-c03e-46cd-b8e2-26e6578e3123',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030208',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9d8c340f-7fc6-4a8d-ad3e-6092cf0ec734',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030209',
    2764003020,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '866be99e-8e19-4739-8f1f-80a754c1a895',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030210',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd4d1c211-5163-41ad-b7d6-b66570f1f00e',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030211',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6ef87b63-24a6-42da-8671-f15105c6da29',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640030212',
    2764003021,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd553273f-e313-461f-9e93-53412bedc161',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640031008',
    2764003100,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cab1bcf1-cb27-47a2-b263-190eff6c839f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640031012',
    2764003101,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2d292833-963f-449c-9931-2618a47e6cb9',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040401',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f8dd8e58-bc8c-4b68-86bc-5b09eb860fd8',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040402',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bed3d2e5-6a5a-49eb-ab13-bdb787ae109b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040403',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '72669212-5c0b-473f-aee3-0d3be052195f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040404',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c375c7e6-aaae-4d01-a9bb-0e722f0a001b',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040405',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4aa7ab11-b258-4ccb-be26-1b8748944b0c',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040406',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '647cbb89-bcb5-4abe-a5b9-46cac636896f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040407',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8ef21436-2ed9-4db6-9206-557dd449adcf',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040408',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '66c2250d-6a28-4068-989f-f866d832be7d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040409',
    2764004040,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'eef0ab73-0c64-4f1a-9fc2-0e99040031e2',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040410',
    2764004041,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1a2eb531-f53c-429c-9384-dcaf355e6355',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640040411',
    2764004041,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '47e1e2e5-c7b7-4cd5-ad8a-acaeed7c0220',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640041404',
    2764004140,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '39089666-38b6-4bfa-826f-60569b546d7a',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640041408',
    2764004140,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8b36a6df-e6f4-41d0-a93a-51883d0a0fd9',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050501',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f5b194b3-7ace-455e-8de6-2872ac23fde7',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050502',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3606b634-8957-4a40-8c56-8aa4e3a9cf60',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050503',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '71b91cd6-8638-42ff-b383-89931e2c593a',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050504',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bede1c71-1524-419e-8d63-257c96044b15',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050505',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dc476cb6-f2e7-4cc2-b956-eb904b5701ed',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050506',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4eab1fcc-a7fb-437f-8f74-e523af776b48',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050507',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e71dda5e-9398-4893-a0d3-581f77be2206',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050508',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f01533c3-3336-46bc-8580-203c34b2b4ae',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050509',
    2764005050,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fe1c9b77-b0f2-452b-9ccd-21349ef7836d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050510',
    2764005051,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a3048218-da6b-4ae9-9ce8-3008bfb84a28',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640050511',
    2764005051,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'df0899bb-1256-4a20-8526-19d69c6676ea',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060601',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dcacf08a-b9bd-4ed3-b061-bab71fbe0847',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060602',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5341ec31-30dc-4eb0-8a31-ad8d3e75fff9',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060603',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6f57c160-f4c8-4834-8e30-97ee1ef68251',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060604',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c13db7f6-7543-4a68-bd1e-903dba401752',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060605',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd53f2a71-f531-4718-b938-ead2a44f81dd',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060606',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6dbffd57-5846-4a22-b06c-d7cc0de24670',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640060607',
    2764006060,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1e2d17db-48ca-4d60-8eae-b95f160503e3',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070701',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '64f2179a-4555-4e2c-9c9c-1c9abd0e5f83',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070702',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ff81dac9-1a69-4e3a-83f2-e59e458dbc28',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070703',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bf8b7b22-55aa-4c30-9972-06de7a6ee6b8',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070704',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fb541160-90d8-43fa-aa4e-24bcfef9539d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070705',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7a49f7a8-6f81-40f8-a054-e4a28a62c9b2',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070706',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '60bcdb31-d822-499a-b909-48e52c04df4f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070707',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '551cc64a-ee9c-4de6-b538-dad1541523f7',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070708',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '950b5527-1122-49db-a769-192952aab47d',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070709',
    2764007070,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '85a18f43-a9a2-4c77-a4a6-2b2d1f3ee537',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070710',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8eb4e545-98ef-4d32-8400-2944214271b8',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070711',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '243453c5-d51e-4059-b8ff-1f5be7485cca',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070712',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4a33de12-babf-4bcd-8534-913e9d3cf713',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    '27640070713',
    2764007071,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (93)
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'bf187eef-a552-4ba5-ab99-13bfccb1ed2a',
    'e79b110f-6e51-4b2f-8636-46923ad86873',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '8f55268d-daed-44c9-b5c9-6c9dbf91d1ea',
    '98bfb4ab-eef6-4e7b-a4df-ca5f48eeda25',
    'Oliver Johnstone & Rachel Harris',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '85df0c5e-2931-45af-83dd-972c94ed89ea',
    '5bb319de-aa77-49d9-ab1f-aedd2022ecfe',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'be203747-8d90-4420-b944-ce0475d24340',
    'e90cfb1b-860f-4479-b800-70b2a0074646',
    'Anna F & Laura D & Alice N Russell',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'e448249a-14c7-4da1-b41d-979e2d15631b',
    '63a03f12-9400-426f-a948-e6bb8b3ea564',
    'Lucinda Marshall',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0dcee11b-d06a-41c6-b793-237d0cfbe1a6',
    '1f5dd515-d194-4cb5-b011-cd0fb005b429',
    'Mr L J Lee & Miss J H Bentley',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5fa9fa5e-09df-4d6b-80e6-594a6a026ce0',
    '268bf71e-3fd1-4514-968a-3fc23bbc2057',
    'Gareth Briggs & Claire Maddocks',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd60900cd-ea1c-4512-ab2d-225d0d24cd50',
    '15cb5a7b-83af-4fa6-8e0e-0892375140b2',
    'Mohamed Shaikh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'af873f20-c3bf-47fd-932f-5cc3ce9bb856',
    '91bb55b9-31c0-4e77-bb56-8ccf9762c1de',
    'Katherine Stirrup',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4a148f49-b8e4-492a-be08-6b4e6a366ccb',
    '59398941-73c1-4cff-906a-9505b7634b36',
    'Jacob Miles Davis',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'f1ad11dc-d2b0-4041-b779-8fa0551d200d',
    '8bfdab79-1cbe-4139-b0e1-15b17c2fc6c1',
    'David Tamal Zentler-Munro',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a6f2ee6d-777e-473a-bf63-c09afd569385',
    'bb29fa0d-cbb6-4491-94b2-934ef44a1e0b',
    'Toby William Weston',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ff31a6a5-92ec-4789-9b1f-2e89a5bdf25b',
    'dec038bd-2937-4fd9-aea2-cc45e5e8dc2b',
    'David John Glover',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '68038a66-2db3-40c6-8c0b-1737cdac93e0',
    '854772d1-2c38-4166-8399-a63e83baa4d3',
    'Bernard Asiedu & Akua Domfeh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'be60c8c6-5f0a-4c55-9d7a-dc0771d778a7',
    '532abcf1-bd41-45ed-bf8f-fa9c814d199a',
    'Mr J P Miller & Ms L F Miller',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0a2aacd4-f482-426c-91c1-ea4d8af3559c',
    '96b9044f-abb7-40cc-98a8-8434cf7ca201',
    'Sarah Brereton & Michael Ward',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c3e9d48e-c078-439a-b5da-156ab204b60c',
    '6dc98f2e-5355-4d08-9dc3-0abeabaa50a0',
    'Robyn Hodson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2a5e4f51-33fb-453e-b9db-70f6dd18c294',
    '218edcef-71c9-4b40-adfb-85fdadaa07c0',
    'Sophie Goddard',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5d9a092a-fcb0-4445-b653-9057d2f1e5ac',
    '28bb2cac-e3e5-4264-81d5-7f31cbfe7976',
    'Kathleen Elizabeth Ward',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '712cd2b4-3221-49d6-8e5d-57ffe0314935',
    'be89a8b2-84f6-4de5-9f70-17b63fc91b4b',
    'Jaspreet Singh Gill',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fd9651a1-28a5-4946-9c82-4fbbeea4f004',
    '8e17b891-8c2b-41f0-8ab3-c35a9ab3a322',
    'Luca Montalto Giampaoli and Federica Michelin',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b54b41ba-eee4-484d-a729-aac7354e4d08',
    '0b90c265-debf-4c4f-9fe2-eb5bb639292b',
    'Malcolm Shaw',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '79d125b2-3e22-42ed-8861-d37aa6d64c2d',
    'c1bc525a-74aa-4c90-b1da-47f86af65404',
    'Edward & Alice O''Connell',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1132ccd9-b1c0-40ea-a057-974097d56e3b',
    '6d796acb-6901-4909-89f6-65fabe726d48',
    'Bram Wal & Chin Tay',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6c216e11-132b-4552-95df-10371b38c6a4',
    '1830bb11-4391-42df-aaf4-ec2796c68eac',
    'Jack Howse',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'c95845ab-80c8-4e05-865a-c90d35a87bb4',
    '1a40f284-d15d-4f9b-9c66-ec179e976ec3',
    'Swati Ahuja',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '185e0818-8327-4b64-96ec-32a190e7f41e',
    'aa9cce1e-8f99-4869-9bc7-74c7092557e9',
    'Zerrne Henderson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '35763c58-28e1-49b3-8cf7-c05fd1a1540f',
    'e334c0ce-e2e5-40c7-8d95-e2c128633e00',
    'Symone Krimowa & James Zuccollo',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '59ea0a98-3ff2-4b33-9096-7198715f5ede',
    '0f2d950c-7efd-48da-ab75-31cc51cf4503',
    'Stephen Pearson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fc3da1f6-47cf-4729-a691-3912ed1ed0c7',
    'c801b657-5bdd-441f-907e-1418a7ea6087',
    'Thomas & Henrietta Scrope',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5b498b60-9ac2-4d9d-a7f1-c98830b1bb01',
    'f9a1c232-c7bf-4bb3-8942-14097619499a',
    'William James Underwood',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '22d8dd91-3df7-44d3-b4ab-2f7ead448462',
    'bdcee340-af55-460f-a097-ee6cd1906a90',
    'Helena Varley',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '30b3962b-dffd-4c7d-95d4-16e1927c48a5',
    '1a5fb2be-230a-4e11-be5a-b537bf0ad85f',
    'Claudia Lauren Ballard',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '756e090a-399d-46ed-a912-be70af3bbd46',
    'd5625678-9a4d-45bf-84fb-0577c7f76dca',
    'Francis Powell Smith and Amanda Nicola Chetwynd- Cowieson',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4b8457b1-a57b-4a64-a26d-7991f5dc39ce',
    'fc842bb5-51e8-4c9a-a8f7-dbfcf63b2426',
    'Nicolas Harvey',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '23c0da02-f7c5-428a-adfe-2ec55409c0fd',
    '20af07fc-26bf-4c64-98bf-0dca15e9780b',
    'Anas Nader & Yasmin Maksousa',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '393d0781-156a-4a84-8574-ae370ffffe99',
    'b63c52cb-f7c2-45c5-b05b-ea1f7840456d',
    'Ellen Brown',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fbdd5116-1ae9-4d84-a51c-9058e4c3f5a9',
    '8fb24ad2-eea7-4ab9-8e7a-6c6668d7fa32',
    'Michael Walsh',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b69e7b37-fab8-472e-af0a-f3516c95db48',
    '8317e0b2-7a90-4d41-943b-1aca5f7c8813',
    'Holly Power',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3d9803f0-4ed9-4b4d-b828-50fe7fb3822d',
    '2f4585fc-3025-4960-b16f-4ea37f8a299a',
    'Emma Powell & Daniel KC Wong',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '63e2871d-6d3c-4071-955d-7ca05e16c9a9',
    '197f0293-717e-4439-b986-483e784a743e',
    'V Z Zlatanov & L A J Simon-Dufis',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '5aed79c7-64c0-4182-9085-cdfe23672dfe',
    '741b396c-41a9-4f07-a8e9-fb972a0c0dc5',
    'Amy Cheung',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ab22281c-b1c1-493f-a4f6-1cbc3a99761d',
    '89d13b9e-c03e-46cd-b8e2-26e6578e3123',
    'Miss C I Patel & Mr C L Gilbert',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '02fe75fa-ca55-43f3-b993-3eba9917c7c7',
    '9d8c340f-7fc6-4a8d-ad3e-6092cf0ec734',
    'Roxane Barsky',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4068b1dc-65f9-48ea-8f77-f230be5249ef',
    '866be99e-8e19-4739-8f1f-80a754c1a895',
    'Joseph Christopher Butler',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a19ff63e-227f-4860-8ad9-fe10d1341efe',
    'd4d1c211-5163-41ad-b7d6-b66570f1f00e',
    'Diederik Winershoven & Gabriela Patrikova',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3001a0c4-e43d-4485-9ce0-bde636fa8476',
    '6ef87b63-24a6-42da-8671-f15105c6da29',
    'Laura Smith',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '17c90db0-937d-446c-9a12-39531859249c',
    'd553273f-e313-461f-9e93-53412bedc161',
    'Andrew Miller',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '88077dc8-1711-4f95-8b83-f2a8a2d6258c',
    'cab1bcf1-cb27-47a2-b263-190eff6c839f',
    'Nivardo De Amorim Gallo',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a5d1cc47-10d7-4d5e-a669-2758195ae9f1',
    '2d292833-963f-449c-9931-2618a47e6cb9',
    'Jordan Corner & Edward Ince',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ed533ad8-ebb1-41f0-b484-aa8adb120360',
    'f8dd8e58-bc8c-4b68-86bc-5b09eb860fd8',
    'Nicola Mooney',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3c118d45-7673-4cda-84e3-09de394a4df4',
    'bed3d2e5-6a5a-49eb-ab13-bdb787ae109b',
    'Manuela Hernandez',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ba4f13d7-6993-4a6c-a8a4-8c5b74332f19',
    '72669212-5c0b-473f-aee3-0d3be052195f',
    'Edwin Henry Malins',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '39495c4a-5947-40ab-8550-afc251b97a39',
    'c375c7e6-aaae-4d01-a9bb-0e722f0a001b',
    'Andreas Papamichail & Alasdair Anderson Craig Falcon',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fa2e65c7-2746-40d0-9be9-f36f8585f7a4',
    '4aa7ab11-b258-4ccb-be26-1b8748944b0c',
    'Bruno Andrade de Lyra',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2f0b7a40-8ef4-4732-8096-2565c329a42e',
    '647cbb89-bcb5-4abe-a5b9-46cac636896f',
    'Christopher L Davey and Wallis C McKendry',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1c6a9209-962b-4eef-93fe-f50071a9fa2e',
    '8ef21436-2ed9-4db6-9206-557dd449adcf',
    'Samuel Gulliver Naish',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '265f26b6-a950-4f21-86db-169aac362c2c',
    '66c2250d-6a28-4068-989f-f866d832be7d',
    'Rose Moncrieff & Charles Cooke',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'bcf181f7-9e54-4289-8037-9ff86476e224',
    'eef0ab73-0c64-4f1a-9fc2-0e99040031e2',
    'T A M Revell & I E Steinmark',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '272c2fab-e29e-4b85-a0e7-c672a7d50858',
    '1a2eb531-f53c-429c-9384-dcaf355e6355',
    'Mr. George Frederick Bray & Ms. Alice Marie-Grace Panton',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2f67bd0f-2bfc-4952-b1be-484181de43ba',
    '47e1e2e5-c7b7-4cd5-ad8a-acaeed7c0220',
    'Julia Dianne Harrowsmith',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '31826127-1dca-4693-b5bd-a52661fc26ef',
    '39089666-38b6-4bfa-826f-60569b546d7a',
    'Natalia Tothova',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7c196a90-367d-428a-ae49-eb4b30173ca4',
    '8b36a6df-e6f4-41d0-a93a-51883d0a0fd9',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '36fc0282-7102-41c3-a77b-c1b63feb4470',
    'f5b194b3-7ace-455e-8de6-2872ac23fde7',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '117d77a7-3cf0-4fbb-8429-b9ebff2e826f',
    '3606b634-8957-4a40-8c56-8aa4e3a9cf60',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b7295933-a3ea-4f97-9a3f-aaa76de05649',
    '71b91cd6-8638-42ff-b383-89931e2c593a',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '3285b255-27aa-4874-85f9-8812ebf4b97b',
    'bede1c71-1524-419e-8d63-257c96044b15',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd664f86c-4483-4d61-bba6-a570ce423d4f',
    'dc476cb6-f2e7-4cc2-b956-eb904b5701ed',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'a82b8005-a512-48af-b146-8809ec504339',
    '4eab1fcc-a7fb-437f-8f74-e523af776b48',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '2df36ded-a04e-4cb1-9051-87c1e4efc936',
    'e71dda5e-9398-4893-a0d3-581f77be2206',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ecade547-c25b-45a8-b01c-5a74aedf99b3',
    'f01533c3-3336-46bc-8580-203c34b2b4ae',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b99f170c-ff67-46b9-b975-7bd01b9a7101',
    'fe1c9b77-b0f2-452b-9ccd-21349ef7836d',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '62ab3840-f92b-4875-9e7f-85db51d63d78',
    'a3048218-da6b-4ae9-9ce8-3008bfb84a28',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7a70ca35-5bd9-4e22-ac9e-173f6fe25606',
    'df0899bb-1256-4a20-8526-19d69c6676ea',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '94b68c18-e85a-4aac-9d5f-9083aae5e87d',
    'dcacf08a-b9bd-4ed3-b061-bab71fbe0847',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '306d3c70-1a74-47f6-8239-04a3e6cc0362',
    '5341ec31-30dc-4eb0-8a31-ad8d3e75fff9',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '1e09897a-2d5e-4b53-9277-e9cca3238387',
    '6f57c160-f4c8-4834-8e30-97ee1ef68251',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'eedd609b-1858-4a95-84f5-c7efa19953b5',
    'c13db7f6-7543-4a68-bd1e-903dba401752',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '7114acf1-9de7-4787-950f-1a2115c4066f',
    'd53f2a71-f531-4718-b938-ead2a44f81dd',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4638532c-06f9-4702-af7d-2736e884630c',
    '6dbffd57-5846-4a22-b06c-d7cc0de24670',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0f7fd78d-dd32-4551-8d43-6261476782c6',
    '1e2d17db-48ca-4d60-8eae-b95f160503e3',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'ad28a154-02f1-458a-8247-1c2f0305fe55',
    '64f2179a-4555-4e2c-9c9c-1c9abd0e5f83',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '70188f0e-a994-469a-a27d-03fdbc3a20d1',
    'ff81dac9-1a69-4e3a-83f2-e59e458dbc28',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '100e30db-6276-4e34-8bd7-afd094f5dd2c',
    'bf8b7b22-55aa-4c30-9972-06de7a6ee6b8',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '0f7e8412-108f-4baf-bdc1-331e2540619c',
    'fb541160-90d8-43fa-aa4e-24bcfef9539d',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'fc575af0-4caf-495a-b210-1fb05b0687b8',
    '7a49f7a8-6f81-40f8-a054-e4a28a62c9b2',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '65d45588-b375-4896-9099-e94a6ed71a89',
    '60bcdb31-d822-499a-b909-48e52c04df4f',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'd38683ca-8643-4d8b-aeb9-86165ef72f2f',
    '551cc64a-ee9c-4de6-b538-dad1541523f7',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    'b9166c68-fc58-4125-a09d-79022dffb2ae',
    '950b5527-1122-49db-a769-192952aab47d',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '96fcf151-30c5-4064-b983-3f07b182a539',
    '85a18f43-a9a2-4c77-a4a6-2b2d1f3ee537',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '6c65db27-c7f7-4a52-b27a-823200c3bec6',
    '8eb4e545-98ef-4d32-8400-2944214271b8',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '40a62018-deb3-4109-ad0e-096b28ce7ad2',
    '243453c5-d51e-4059-b8ff-1f5be7485cca',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name,
    correspondence_address, email, telephone
) VALUES (
    '4cbb51a7-511d-4744-8c0b-f19c4f3d41dc',
    '4a33de12-babf-4bcd-8534-913e9d3cf713',
    'Peabody Trust',
    'United Kingdom',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Compliance Assets (2)
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '75105488-12bb-4e65-b57b-99a7d160923f',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    id,
    '2023-02-24',
    '2024-02-24',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'FRA';
INSERT INTO compliance_assets (
    id, building_id, asset_type_id,
    inspection_date, next_due_date,
    status, inspection_company
) 
SELECT
    '7d5d4df1-9e60-4d24-b2de-a60227079bed',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    id,
    '2024-11-10',
    '2029-11-10',
    'Pass',
    NULL
FROM compliance_asset_types WHERE asset_type_code = 'EICR';

-- Maintenance Contracts (2)
INSERT INTO maintenance_contracts (
    id, building_id, contract_type_id, contractor_name,
    contract_start_date, contract_end_date, contract_value_annual
) 
SELECT
    'ad97d778-a870-4cbe-8d11-9d41762bcd3e',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
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
    '0d4a683e-c1be-40d7-bdeb-efe8f585d1c8',
    '5209d414-f09e-4292-8a47-b8d39225a37c',
    id,
    's and each contractor engaged to provide services',
    NULL,
    NULL,
    NULL
FROM contract_types WHERE contract_type_code = 'CCTV';
