-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T14:01:04.776319
-- Building: 144.01 PIMLICO PLACE

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    '38970b69-6269-448e-96f0-1bb663821604',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'item.',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7c07df21-31e2-4051-8061-db27eaa87285',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'weeks',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ade011b3-0ded-49bb-b5fe-751a621deb2e',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'nr',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1464871f-d0d7-4540-923e-f5ab493a2692',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Lm',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd4cd0b56-93ff-405d-8587-7a2318adb7fb',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '.',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f8d5e559-0c4f-47f3-ba41-a027206ea471',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'm2',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e43a402b-57bb-4a95-8e4e-be192ae352ad',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Labgour included in 3.3.1',
    NULL,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0d3afd56-bcce-4f2d-a5f8-f3d37ccdc9ac',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-001',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6e0e33ad-9adf-4dda-a071-637f2ca60b03',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-002',
    14,
    1.306,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3dfdcd63-c45d-480b-899c-557e26b9647d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-003',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7895ded6-4e0c-4a33-82d9-44550c1e0a67',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-004',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '445ff9a6-883f-48eb-b17f-1ecf330f97e5',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-005',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9b916d3c-a56c-4716-8755-b5b7141dc00f',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-006',
    14,
    1.306,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'eae29a27-b7a2-4aeb-91a5-0a705a5636a0',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-007',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1114e8aa-a6f6-4754-ab34-cb850eef748d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-008',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '857bee22-fc09-4a31-8b53-8df1cccc2abe',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-009',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1ab9d7d3-ef96-4eef-91e1-4b5cfb55f60f',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-010',
    14,
    0.942,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '39a4a436-1074-4107-8e38-3ff82ae5d50c',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-011',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6832054d-5a2b-4f90-a154-4aa4e8debed4',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-012',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '794bc0c3-6f44-428f-8e25-788608d552ba',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-013',
    14,
    1.25,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0ee4fead-4959-4782-83c9-eb54a7c7ab10',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-014',
    14,
    0.942,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '677dfee3-9e94-4ac3-9240-4c2f62a564d8',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-015',
    14,
    1.354,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bbd73d4f-9631-4474-8940-c4d4faf860ae',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-016',
    14,
    1.288,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '297fb75f-7ab9-47e4-ac9f-1a49e57f5353',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-017',
    14,
    1.814,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '21cf4f10-f932-422c-a442-6b375791c7d9',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-018',
    14,
    0.826,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ff8310d1-9502-48a7-bcfd-cca9dd493357',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-019',
    14,
    1.969,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ab1eedb4-b7ee-4d4d-884c-02f786c3c20b',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-020',
    14,
    2.028,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fe9ea9c4-0883-4440-97ba-1f5d80b5602b',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-021',
    14,
    1.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8eabea75-23db-4067-a780-a8b5dccfbe38',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-022',
    14,
    1.31,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9600f8b6-8e0a-4355-b844-8f6ee181092d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-023',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'abefb552-46d9-4e79-b763-2dcf79166d48',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-024',
    14,
    1.549,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '25ec06ba-228e-4af0-b4b1-7246d7bc8ca4',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-025',
    14,
    1.426,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '89676932-95f5-4022-b916-a789f44365b8',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-026',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2feb248a-0759-470a-b939-eb65ba9b57db',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-027',
    14,
    1.549,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f60f4a61-fa1b-424a-bd28-a3aa8ec2e2dc',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-028',
    14,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1b789eb4-0394-4587-a55c-58d4c305d3b9',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-029',
    14,
    1.548,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'be726516-19f3-4eb2-a574-0d254583c993',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-030',
    14,
    1.555,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd7b0b1b1-4efd-466e-b7e5-747f98872e18',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-031',
    14,
    1.64,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cc393f81-62d8-4b78-a2c1-8c49564abc1a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-032',
    14,
    1.614,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '30237d2b-dd30-41f1-bea5-db43a2d19d39',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-033',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '366ec8ff-cb7b-4a3f-b5d7-c0e986e8ab60',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-034',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3494b435-5cde-41a2-98b5-9fa035a684ec',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-035',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ae110b76-300d-403c-9458-825caf3f9c03',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-036',
    14,
    1.616,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7d518b9e-bd23-42b4-8f19-ca7485b3d500',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-037',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ffa6a4a0-3e13-4f2c-849c-7cc396644771',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-038',
    14,
    1.593,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '84c31d1d-5c53-4071-a2d6-7189ec270d73',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-039',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3c2aef46-aadc-487a-aeab-634fe2684d4d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-040',
    14,
    1.62,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '165837c6-5736-4781-9d99-cd2a32460989',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-041',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e72b1fad-e0a9-4219-a283-2314535b7054',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-042',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '65bb3193-05bc-40fe-8d8c-b034f51ea4bd',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-043',
    14,
    1.241,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b2d5a899-afff-4003-b6e2-3dc2fb7cf6e4',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-044',
    14,
    1.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ff2d2057-f2b7-415d-ac98-184cc7e16bb3',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-045',
    14,
    1.301,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5826ac71-cdf3-4a29-b885-ed344ca95db2',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-046',
    14,
    1.301,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '79ff58a0-7b85-4432-ace2-f0a3b7bea10d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-047',
    14,
    1.497,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '85c81f19-93b0-4690-a61c-70cef7dd57fb',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-048',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '60f20608-7a1c-4ef3-8336-0920628bb054',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-049',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '23dede6c-d625-473c-b271-73b1f89e3612',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-050',
    14,
    0.715,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '93d71930-6e44-4faa-960b-40c432279d38',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-051',
    14,
    0.715,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '706b12fc-a30d-4e26-b9b2-47a8ae771568',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-052',
    14,
    0.919,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '65b8d79e-099b-495c-981a-563c01b1ab87',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-053',
    14,
    1.325,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7cca5b3f-cd96-4aef-a3cf-459da54fad29',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-054',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '15ab8231-cca5-433d-8702-1710aadc594a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-055',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3177fc7f-4baa-4338-a4af-027093fd498a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-056',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7c67148e-7a18-426e-91bb-ecbba0fa2cee',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-057',
    14,
    1.064,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd9738f79-d2e3-4f0a-9de1-269db9721ea4',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-058',
    14,
    1.22,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9ee31444-b364-4470-9369-d7dcadc9069c',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-059',
    14,
    1.357,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '14e1526d-291b-43ae-af7a-fb930287cec6',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-060',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '82a399f7-dce7-4de6-8cd1-e904d5227b9f',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-061',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8fd51667-e35f-4102-85ab-b77ee4831f03',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-062',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'df2cf251-f5e3-42bf-8e91-fc301ca0c117',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-063',
    14,
    0.707,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3cd54728-bc6c-488e-9ecb-f0c6fb04ab18',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-064',
    14,
    1.935,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8fc0783f-6b48-402f-909a-2e8fd29c40ea',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-065',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '97459dc3-22aa-4473-86f9-12d1ea020165',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-066',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ef309a9f-43dd-4bf4-a165-08143b28014f',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-067',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '326a29c5-0257-40f2-885e-e1156a5adc17',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-068',
    14,
    0.707,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0da7e97c-8a8e-4558-be6b-32a60ccea98f',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-069',
    14,
    1.935,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5d9b552a-7d2b-40f3-a251-8fbc800c228c',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-070',
    14,
    0.842,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '54e5c75e-5636-419a-8b4b-4b5cae7f079e',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-071',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3bf2617b-2145-4acc-a658-652717ba059a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-072',
    14,
    0.853,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'de57b7fe-7f66-44e5-9206-1670acd5efa5',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-073',
    14,
    2.174,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ba3e722d-adc8-483b-aa41-23b8c3e156f3',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-074',
    14,
    1.399,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8fc0f3cc-8f24-47a1-bf33-2c2357771e78',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-075',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f71e8c96-d0f5-4a23-baa5-6b1af50f8eb7',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-076',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cd9a56c5-b182-468a-846d-f863b3c02790',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-077',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '334a7977-7cbb-4e9e-ad68-01e8c104597a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-078',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4b7c04a4-487f-46f5-8015-942f0b221151',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-079',
    14,
    0.979,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1e9d9a04-38df-41fd-ac3a-20b7ad9c9b7d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-080',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1e3124c0-e7ed-43cd-ae38-eecc3c29bd0a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-081',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4cd0f7b2-4cee-43eb-8ec4-f584e9dd9f0b',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '144-01-082',
    14,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (82)
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '38d846e0-1afc-4ca6-b19f-368b325bf124',
    '0d3afd56-bcce-4f2d-a5f8-f3d37ccdc9ac',
    'Derek Mason & Peter Hayward, acting as',
    'Ethlope Property Ltd Acting by his, LPA Fixed Charge Receivers, C/O MDT Property Consultants, 5 Coppice Drive, Putney, London, SW15 5BW',
    NULL,
    '07836 284269 (Derek)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '28961ec8-f55a-4e91-988a-000a06c3f1a3',
    '6e0e33ad-9adf-4dda-a071-637f2ca60b03',
    'Jasmine Chan',
    'Pimlico Place - Flat A2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c99b73ce-6599-4819-b244-d69106d81734',
    '3dfdcd63-c45d-480b-899c-557e26b9647d',
    'Ms S Brown',
    'C/O Hoffen West Ltd, 16 Lower Belgrave Street, London, SW1W 0LN',
    NULL,
    '07449 938 888'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3827a43c-f900-4e6d-b3c0-84170ff58174',
    '7895ded6-4e0c-4a33-82d9-44550c1e0a67',
    'Nicholas Ingram, Mark Ingram & Elaine Ingram',
    'Pimlico Place - Flat A4, 28 Guildhouse Street, London, SW1V 1JJ',
    NULL,
    '07814155215'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'dd7f4366-d464-4cb2-8a33-a5e0d412b7ce',
    '445ff9a6-883f-48eb-b17f-1ecf330f97e5',
    'The Roman Catholic Diocese of Westminster',
    'Finance Office, 46 Francis Street, London, SW1P 1QN',
    NULL,
    '02077989169'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'dfeb869e-b447-45e8-b6c7-76630ec0c31d',
    '9b916d3c-a56c-4716-8755-b5b7141dc00f',
    'Elena Margaret Eu',
    '46 E Peninsula Centre, DR APT 259, Rllng Hls Est, California 90274, USA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0627a547-d21d-4a8d-9a2e-05b717fed81b',
    'eae29a27-b7a2-4aeb-91a5-0a705a5636a0',
    'Mr AJ and Mrs AM Hampson',
    'Crossbow House, Hillhouse Lane, Rudgwick, West Sussex, RH12 3BD',
    NULL,
    '077889966118'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd245cbe1-e673-410c-a167-093426d13024',
    '1114e8aa-a6f6-4754-ab34-cb850eef748d',
    'Mr B Kinane',
    'Pimlico Place - Flat A8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e60bc68b-13f1-4d66-b5a2-967b5be556d2',
    '857bee22-fc09-4a31-8b53-8df1cccc2abe',
    'Christopher & Clare Roberts',
    'Pimlico Place - Flat A9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '198693cd-685c-4401-90eb-e4651b34a5b2',
    '1ab9d7d3-ef96-4eef-91e1-4b5cfb55f60f',
    'Jessica Louise Brady',
    'Pimlico Place - Flat A10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '640c254b-723b-4462-9988-6db650cb8bb9',
    '39a4a436-1074-4107-8e38-3ff82ae5d50c',
    'D McCormick',
    '2 Rathfarnham Wood, Dublin 14, EIRE',
    NULL,
    '0353872482013'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '324a1751-099f-4d65-adf8-4b2b49a32af8',
    '6832054d-5a2b-4f90-a154-4aa4e8debed4',
    'Ms Rachael Noble',
    'Pimlico Place - Flat A12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '39713b6c-f34a-4be0-88ff-e1018e522468',
    '794bc0c3-6f44-428f-8e25-788608d552ba',
    'Dr A G Ward',
    'Pimlico Place - Flat A13, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ab86454a-e040-4021-8148-06183d4bf198',
    '0ee4fead-4959-4782-83c9-eb54a7c7ab10',
    'Mr Gary & Mrs Kim Risley',
    '5 Popes Wood, Thurnham, Kent, ME14 3PW',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7d8f9deb-04ef-4d15-8055-9dcfe6e5dab0',
    '677dfee3-9e94-4ac3-9240-4c2f62a564d8',
    'Mr J & Mrs D P Reidy',
    '19 Cumberland Street, London, SW1V 4LS',
    NULL,
    '02078343021'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b8fe5f82-955e-411c-8996-71d7014cdc6e',
    'bbd73d4f-9631-4474-8940-c4d4faf860ae',
    'Christopher P Ennals and Elizaveta Taubes',
    'Pimlico Place - Flat A16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3c4bfc08-2e53-42aa-b8f2-921580241180',
    '297fb75f-7ab9-47e4-ac9f-1a49e57f5353',
    'Vincenzo Catanese & Manola De Vincentis',
    'Pimlico Place - Flat A17, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2a9ad753-c2ed-4e1a-915c-d331fd66adc7',
    '21cf4f10-f932-422c-a442-6b375791c7d9',
    'Shenwei Zhu',
    'Pimlico Place - Flat A18, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7bb31dfe-1ed9-4345-827d-bbe2e5ff22ec',
    'ff8310d1-9502-48a7-bcfd-cca9dd493357',
    'Mr Bernd Freier',
    'c/o S Oliver Gmbh & Co KG, Ostring, 97228 Rottendorf, GERMANY',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6e2349bc-d517-4443-b2c9-0553e49459a6',
    'ab1eedb4-b7ee-4d4d-884c-02f786c3c20b',
    'Mr T Izmaylov',
    'Pimlico Place - Flat A20, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a2a9e73d-b71e-4e78-a645-c4a8d3529aee',
    'fe9ea9c4-0883-4440-97ba-1f5d80b5602b',
    'Dr Simon Ostlere',
    'Pimlico Place - Flat A21, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '47fd316e-d992-442c-8e1f-0413401ec279',
    '8eabea75-23db-4067-a780-a8b5dccfbe38',
    'Ms Catherine Ercilla',
    'Prestwood, 8 Rowley Green Road, Barnet, EN5 3HJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c4d0f24c-bedf-4acf-b2b3-a30f31e694ce',
    '9600f8b6-8e0a-4355-b844-8f6ee181092d',
    'H E Tortoishell',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '810f50f9-3445-4026-8a5b-85633979b6bf',
    'abefb552-46d9-4e79-b763-2dcf79166d48',
    'Mr Dario Striano',
    '66 Ashley Gardens, Ambrosden Avenue, London, SW1P 1QG',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'dc7a38c8-2e76-46cb-9c59-57785f05bb74',
    '25ec06ba-228e-4af0-b4b1-7246d7bc8ca4',
    'The Estate of the Late Rogdre Juer',
    'C/O Kerensa Cooper, Foot Anstey, Senate Court, Southernhay Gardens, Exeter, EX1 1NT',
    NULL,
    '+441392685216'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '474a3e96-3671-4725-a3ec-257bc6cf6ddd',
    '89676932-95f5-4022-b916-a789f44365b8',
    'A Protasova, T Protasova, V Damaskinskiy',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '02a52587-a46e-48de-88b5-dda15906f129',
    '2feb248a-0759-470a-b939-eb65ba9b57db',
    'Mr R Markham',
    '23 Stoke Park Road, Stoke Bishop, Bristol, BS9 1JF',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2ae9789d-d2b1-4c00-aaa5-8a6bfeac759f',
    'f60f4a61-fa1b-424a-bd28-a3aa8ec2e2dc',
    'Mr N Stone, Mr K Stone & Mr Stone',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '1f7c4954-9875-416d-adbe-7d43fdaa4b24',
    '1b789eb4-0394-4587-a55c-58d4c305d3b9',
    'T E Hohler',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    NULL,
    '020 7622 6914'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6da2cc96-eee9-4bc2-9bb6-c6c3c3f084d6',
    'be726516-19f3-4eb2-a574-0d254583c993',
    'T E Hohler',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    NULL,
    '020 7622 6914'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2e5966db-4eb8-49b9-a56c-ab95ee94861b',
    'd7b0b1b1-4efd-466e-b7e5-747f98872e18',
    'Aquitania Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f811a90c-f992-4a84-96c8-811eca3ad251',
    'cc393f81-62d8-4b78-a2c1-8c49564abc1a',
    'Dr B K Vekaria',
    '32 Totteridge Common, London, N20 8NE',
    NULL,
    '02076300782'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '86201265-8e67-4d0e-af92-7e1b751e75a1',
    '30237d2b-dd30-41f1-bea5-db43a2d19d39',
    'Mr F A Iannello',
    'Pimlico Place - Flat D1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02078349148 (rarely a'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'dfe979b7-ad9f-41c2-bb36-2b2d3422176b',
    '366ec8ff-cb7b-4a3f-b5d7-c0e986e8ab60',
    'Kwok Hing Lam & Choi Joecy Lee',
    'Pimlico Place - Flat D2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '85226280077'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '96fe7fc6-213c-4a2f-b91f-6e29dc584131',
    '3494b435-5cde-41a2-98b5-9fa035a684ec',
    'Shashank Chahar & Monica Lalwani',
    'Pimlico Place - Flat D3, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a6cbb17e-5167-43b1-82bb-c251530c1323',
    'ae110b76-300d-403c-9458-825caf3f9c03',
    'Mr B J A Hutt',
    '33 Radnor Mews, London, W2 2SA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2e02989b-6fab-4e95-be35-ba58e6cc3b72',
    '7d518b9e-bd23-42b4-8f19-ca7485b3d500',
    'Silversands Resources LLC',
    'c/o Vuna Capital Trustees (Mauritius), Level 10, NeXTeracom, Tower 1, Cybercity, Ebene, MAURITIUS, 72201',
    NULL,
    '02304278343'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5cd0c216-a235-48a9-ad88-94cc51162e0f',
    'ffa6a4a0-3e13-4f2c-849c-7cc396644771',
    'Thracia Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2e7b7ab3-de0d-4cd1-b770-73f182a44741',
    '84c31d1d-5c53-4071-a2d6-7189ec270d73',
    'T C Hill & L Hill',
    'NO CORRESPONDECE TO BE SENT VIA POST, D3, La Clare Mansion, 92, Pokfulam Road, Hong Kong',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a360c838-c1bc-4f55-bdb7-d65dcf4c0ee4',
    '3c2aef46-aadc-487a-aeab-634fe2684d4d',
    'V, J, A, & Apipu Phataraprasit',
    'Pimlico Place - Flat D8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '42c27c6d-d32c-418a-936e-f566950ff5d8',
    '165837c6-5736-4781-9d99-cd2a32460989',
    'C S Shaftesley',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b5ec4893-b8c8-4c29-9a47-6663b96304e4',
    'e72b1fad-e0a9-4219-a283-2314535b7054',
    'M Kohli',
    'Pimlico Place - Flat D10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c9f2f4f8-cb79-4f60-b9a7-dfec38d4ca18',
    '65bb3193-05bc-40fe-8d8c-b034f51ea4bd',
    'Mr Deepak Sabnani',
    'Pimlico Place - Flat D11, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07768 997 276-Soni'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '25bd6d77-8785-4691-bc6d-27598132e913',
    'b2d5a899-afff-4003-b6e2-3dc2fb7cf6e4',
    'Qu Wang',
    'Pimlico Place - Flat E1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bddeecba-4afb-4603-b5c1-63d8917835a3',
    'ff2d2057-f2b7-415d-ac98-184cc7e16bb3',
    'Mr Mikhel Chandra Pipariya & Ms Sonam Lalwani Lalwani',
    'Pimlico Place - Flat E2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a80d0061-2caa-4721-80a4-5cfc27661fe7',
    '5826ac71-cdf3-4a29-b885-ed344ca95db2',
    'Peter Sten Bertelsen',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '763e6e94-c8e6-4a94-9d08-7dcd98b3b64e',
    '79ff58a0-7b85-4432-ace2-f0a3b7bea10d',
    'Peter Sten Bertelsen',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '323e5816-4783-49dd-939e-d4f3f286b59e',
    '85c81f19-93b0-4690-a61c-70cef7dd57fb',
    'Andrew Brown',
    'c/o Ms Asami Miyoshi, c/o London Tokyo Property Services, Central London Office, 115 Baker Street, London, W1U 6RT',
    NULL,
    '07464 093011'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c5997687-8383-4db3-977f-d89ea799d846',
    '60f20608-7a1c-4ef3-8336-0920628bb054',
    'Mr S Nassiri-Shahroudi',
    'Pimlico Place - Flat E6, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b190e55d-7297-4653-83f9-787c3aad16b9',
    '23dede6c-d625-473c-b271-73b1f89e3612',
    'Chawki Karam',
    'Pimlico Place - Flat E7, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7fdea631-201c-42ce-a6b8-ba53f2dd158a',
    '93d71930-6e44-4faa-960b-40c432279d38',
    'Dalmatia Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b7d08702-bbe9-4c58-8f54-722b325412dc',
    '706b12fc-a30d-4e26-b9b2-47a8ae771568',
    'Miss Elizaveta Kolesnikova',
    'Pimlico Place - Flat E9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7f823a7b-5ac3-456d-b3a6-398edc3e8665',
    '65b8d79e-099b-495c-981a-563c01b1ab87',
    'Julia Sz-Hing Hunt Chan',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '25e866f1-f3f3-4b97-8980-0b2325f77d62',
    '7cca5b3f-cd96-4aef-a3cf-459da54fad29',
    'F Steadman',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'be774e0c-6265-4b39-884c-9266c357b008',
    '15ab8231-cca5-433d-8702-1710aadc594a',
    'Shen Xiangjun',
    'Pimlico Place - Flat E12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '+86 183 7679 8776'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '10ee0ce8-af0a-4dd0-afbb-3c12e36bf52a',
    '3177fc7f-4baa-4338-a4af-027093fd498a',
    'Mr Andrew D Archibald',
    'C/O JLL, Unit C1, 4 Riverlight Quay, London, SW11 8DG',
    NULL,
    '02078524582 - agent'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0ad8fd21-0d24-4ad6-bf36-bf2794b5ae08',
    '7c67148e-7a18-426e-91bb-ecbba0fa2cee',
    'A S Bailey',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b41d16b5-fad6-416a-9929-2b4c451345b2',
    'd9738f79-d2e3-4f0a-9de1-269db9721ea4',
    'T Steadman',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd6a1cfd1-3d62-471a-b154-05af71f808b2',
    '9ee31444-b364-4470-9369-d7dcadc9069c',
    'Mr & Mrs P Cleary',
    'Pimlico Place - Flat E16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07590 010 555(Sally)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b5a6b47f-d251-4a1a-99fa-6b1806333a60',
    '14e1526d-291b-43ae-af7a-fb930287cec6',
    'G & L Property Partnership LLP',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ac381c9c-9b5f-4e11-a934-c48abe2260b6',
    '82a399f7-dce7-4de6-8cd1-e904d5227b9f',
    'Mr Hugo & Mrs Emma Brown',
    'The Old Rectory, Stoke Lyne, Oxfordshire, OX27 8RU',
    NULL,
    '01869345293'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c817b306-fd13-42af-9918-2cec5b48e68c',
    '8fd51667-e35f-4102-85ab-b77ee4831f03',
    'Mr Andrew Peter Dent',
    'Pimlico Place - Flat E19, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '07901513559'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'cc378d93-989d-451f-9e72-2a396152acc3',
    'df2cf251-f5e3-42bf-8e91-fc301ca0c117',
    'D & M T O''Brien',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3596b217-7c11-44b4-981a-aab036aa1547',
    '3cd54728-bc6c-488e-9ecb-f0c6fb04ab18',
    'Aquitania Investment Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4d8cbc9d-6890-4d4e-9905-000c79f8b6fb',
    '8fc0783f-6b48-402f-909a-2e8fd29c40ea',
    'H E Tortoishell',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'cc22e801-3222-4007-869c-e95dc3140dbc',
    '97459dc3-22aa-4473-86f9-12d1ea020165',
    'Mr P E Morris',
    'Pimlico Place - Flat E23, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '45e87cd6-67c2-45a0-ba1a-0eb9e6c8624e',
    'ef309a9f-43dd-4bf4-a165-08143b28014f',
    'J S & M P Ogilve',
    'c/o Chestertons, 26 Clifton Road, London, W9 1SX',
    NULL,
    '020 7357 6911'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '391bede9-30c9-4fe4-8282-f19b735fe0e3',
    '326a29c5-0257-40f2-885e-e1156a5adc17',
    'Kristina Stowasserova',
    'Pimlico Place - Flat E25, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8ae10059-3ee1-413e-8bcc-16256635c268',
    '0da7e97c-8a8e-4558-be6b-32a60ccea98f',
    'J Harries & E Choi hung Lee',
    'c/o Andrew Reeves, 81 Rochester Row, London, SW1P 1LJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2ae1aa34-7352-46a7-bf65-270a5f8efb66',
    '5d9b552a-7d2b-40f3-a251-8fbc800c228c',
    'Mr N Sapuric',
    'Pimlico Place - Flat E27, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '27f55d6b-a223-457e-a617-e60cd3d10f47',
    '54e5c75e-5636-419a-8b4b-4b5cae7f079e',
    'Mrs F Meneghel, Mr M and Mr L Frattini',
    'Pimlico Place - Flat E28, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02076308227'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '41e53b20-68ed-435b-8cce-0830acd13b26',
    '3bf2617b-2145-4acc-a658-652717ba059a',
    'David Chi Leung Tong',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '17e8529c-8dcd-411e-b18e-7fbb58ca488f',
    'de57b7fe-7f66-44e5-9206-1670acd5efa5',
    'Dalmatia Investments Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bea9e940-a11f-4219-ae27-b47225a52880',
    'ba3e722d-adc8-483b-aa41-23b8c3e156f3',
    'Mr S & Mrs G Evans',
    'The Manor House, Adwincle, Nr Oundle, Northamptonshire, NN14 3EA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4c348ca2-1702-4d33-ae23-215fb9f491c9',
    '8fc0f3cc-8f24-47a1-bf33-2c2357771e78',
    'James Luke Holdsworth',
    'Lowick, Lincombe Lane, Oxford, OX1 5DZ',
    NULL,
    '0208 6754349'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fbe112d9-8549-432d-995d-5b9b3ed730d3',
    'f71e8c96-d0f5-4a23-baa5-6b1af50f8eb7',
    'Hibiscus Investment Holding Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '59219cf0-6053-4d80-972e-d2bc2b6840d6',
    'cd9a56c5-b182-468a-846d-f863b3c02790',
    'Hibiscus Investment Holding Ltd',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c052c836-63b1-45c5-be30-191ec3ba8aa0',
    '334a7977-7cbb-4e9e-ad68-01e8c104597a',
    'Mr & Mrs A Aglionby',
    'c/o JMW Property Management, 71-75 Shelton Street, London, WC2H 9JQ',
    NULL,
    '020 8012 7965 (JMW)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7d505ac2-27ff-4f21-bfae-a53758fa1498',
    '4b7c04a4-487f-46f5-8015-942f0b221151',
    'Karen Alexandra Hamilton Hobson',
    'Flat F5, Pimlico Place, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    NULL,
    '02077319820'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '92b8fbc4-da6e-47c6-97db-b3c3b1ae26d0',
    '1e9d9a04-38df-41fd-ac3a-20b7ad9c9b7d',
    'Yaroslav Kukharev & Kateryna Potapova',
    'Apartment 70, Consort Rise House, 203 Buckingham Palace Road, London, SW1W 9TB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd6462115-5cd3-4fc1-8e58-ab93d5a6459c',
    '1e3124c0-e7ed-43cd-ae38-eecc3c29bd0a',
    'A Protasova, T Protasova, V Damaskinskiy',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '59422734-1847-4cb2-89cd-9c4038bbeecc',
    '4cd0f7b2-4cee-43eb-8ec4-f584e9dd9f0b',
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
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    2026,
    1105576.0900000003,
    '2025-04-01',
    '2026-03-31',
    'final'
) ON CONFLICT (building_id, budget_year) DO UPDATE SET total_budget = EXCLUDED.total_budget;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ebc1b44a-c993-4c8a-823f-13d444a724a8',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Porters salaries and expenses',
    120000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'eb13c594-9b65-47a0-aa32-0bb55b848d1f',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Relief cover - weekend shift',
    38000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8771e49b-5155-4a55-800c-dec7dbb0bc37',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Relief cover - holiday',
    4000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cd8e51d4-cd2e-4c0a-819b-ee4abad55554',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Cleaner',
    0.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a923496d-7875-4297-b5c0-09a87947a99d',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Relief cover - sickness',
    1250.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'b2495cd1-9d6e-4d36-baf0-674eda002f70',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Sundries and petty cash',
    500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '4ec7ea2d-8523-4f29-8a8d-f55c3c83343f',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Telephone - main reception and internet',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '63d1fc64-569a-4362-95ce-16399d37fd7e',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Uniform',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'b6db890d-c603-42dd-9624-b6bb6b3d4498',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Staff',
    165850.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '8ffe1f2f-dfa9-478b-8c01-46f674e37ef5',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Cleaning materials and light bulbs',
    1000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e6434711-441d-46c4-b0b0-5135807e76cc',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Cleaning',
    32760.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '7bd8a8c4-a605-40ef-b2bf-c5ff430edbd8',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Carpet/floor cleaning',
    1584.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '7be102ca-6b0d-4500-9ddd-57802b41bed8',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'Car park repairs',
    500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '13a8afae-5f19-4edb-88bb-b8990a49ac4b',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'Gate maintenance',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '7d11f763-9ac9-4f3c-8950-ae2541d1a235',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'CCTV',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '06370578-2bca-4535-b401-1a6ef1b2731c',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Door entry system',
    1800.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '3b4f3082-d8e0-4b45-b52d-b55d41779c02',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Fire alarm/extinguishers/emergency lights',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'b3372400-9e2c-4273-b16d-3952227271d4',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Roller shutter',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e583db02-841f-4c14-83d8-38260c36dae0',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'gardening',
    'Gardening',
    5075.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'baf4de7c-da70-4eeb-a6a3-945f03b1fa32',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'General repairs',
    24000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '54a5b28b-b593-41c8-bb6d-0157d3927766',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Back up generator',
    1200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '666cd8b4-a01d-4d38-a4b4-dc085ea1f4df',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'Gym maintenance',
    6000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '61348c55-52fc-4aa6-ad58-a11a0431edd6',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'compliance',
    'Health and safety',
    1600.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '91e29a30-f542-4711-a69d-d36d2053f3a3',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'lifts',
    'Lift contract and repairs',
    15000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '488170a5-8e0c-4a54-b1f8-e63949248f55',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'lifts',
    'Lift telephones',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f56dd84f-4fe3-4e6a-bc67-0b90283325b7',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Lightning protection',
    324.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '71ec6a42-65b8-4efe-a067-5f8de63beb5b',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Mechanical and engineering plant',
    3000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cf47c965-63c6-481d-8f31-338a87e1ad28',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Pest control',
    1760.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'fc283730-b3fe-4507-9d4d-cfc2388c4ef7',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'Redecorating common parts',
    2000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'bf0c872c-7ed9-4a25-81c6-ffb319fff150',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Refuse',
    1650.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '6d78f65a-ce0c-41c3-8c34-fa55ca9370d3',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'TV and satellite',
    250.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '0594741a-2d98-480a-9bb3-139a16d4292e',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'utilities',
    'Water feature maintenance',
    6570.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '88ef2555-a210-46e5-9443-a010e8817c01',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'utilities',
    'Water hygiene testing',
    3650.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'bd3cb469-0911-423e-ac48-40a0fdb57d23',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'cleaning',
    'Window cleaning',
    1500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '48842d27-ee55-43ca-a4ec-5592f90cd9f1',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'repairs_maintenance',
    'Contract, Maintenance and Services',
    122223.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '63b80a28-6ff6-4a97-aa0a-526741397e3d',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'utilities',
    'Electricity',
    80463.62
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '224c0391-c431-40a5-9fc9-188ace6ff5c7',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'utilities',
    'Water rates',
    27000.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '10474187-031e-4c2e-93f3-a670627f3700',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Utilities',
    107463.62
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e0403921-74a1-48f6-ac37-e4e15a6553ce',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Buildings and terrorism',
    88633.42
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e40fbb60-8f07-4370-b5a5-d9a1bedd1589',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Directors and officers and employee protection',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a405d5d9-0372-459f-bca1-6423e26eddbb',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'insurance',
    'Management Liability Insurance',
    1100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '176fdb04-597e-44f5-8595-70c720720568',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Engineering',
    3100.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'e2df9d66-c7d6-495d-8c66-e427b5ba9c37',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Contents inc. gym and office',
    3300.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a88071e8-73e0-4608-8eea-334c5a52c6bc',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'insurance',
    'Insurance excesses',
    1400.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'a2488d46-265e-494e-81e0-2d3c5dab53ec',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'insurance',
    'Insurance',
    98633.42
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'ea53590d-52e4-44d9-933d-a5c50d0d4753',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'professional_fees',
    'Accountancy',
    2200.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '97514b40-8845-495c-bef9-f5e9d62ac3e9',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Legal and professional fees',
    2500.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'f8b6a773-93c1-4912-8b79-1559015614b9',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'management',
    'Management',
    25642.8
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'dd393426-fc4b-4e72-b152-2749e95c4928',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'management',
    'Vat of Management Fees',
    5128.5599999999995
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cf962de1-be3c-4f32-8006-8e71094ceb2f',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Bank Charges',
    280.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '84d3f511-79cb-4fd8-b82e-666bd0e3e89e',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'professional_fees',
    'Company secretarial fees',
    480.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    'cb17d051-7165-4f10-accf-17ed415007e4',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'compliance',
    'Building Safety Act',
    11940.0
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '229835ce-c939-4694-ad73-246ea00eba74',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'other',
    'Professional Fees',
    48171.36
) ON CONFLICT DO NOTHING;
INSERT INTO budget_line_items (
    id, budget_id, category, description, budgeted_amount
) VALUES (
    '86103285-effc-45a7-a976-9791f3cc914d',
    'dca7c631-55c7-461f-9f22-9d14a27b29ca',
    'reserve_fund',
    'Reserve fund',
    20893.29
) ON CONFLICT DO NOTHING;

-- Compliance Assets (4)
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '54e8160d-93f9-4b6f-8571-111d313d6587',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Fire Door Inspection',
    'fire_door_inspection',
    NULL,
    NULL,
    'Unknown',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '75a8ae45-14ea-47f1-ba23-c4346a58ccf5',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Fire Risk Assessment',
    'fire_risk_assessment',
    '2025-01-07',
    '2026-01-07',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'ae4de8ec-c177-4062-846c-77350d076db5',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Legionella Risk Assessment',
    'legionella',
    '2025-08-18',
    '2027-08-18',
    'Unknown',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '1cddfa10-c7f6-487d-933e-b1ff7d7b7cce',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'EICR',
    'eicr',
    '2022-11-30',
    '2027-11-30',
    'Unknown',
    NULL
);

-- Maintenance Contracts (28)
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '1f3e7bd3-bcfb-491e-ab47-885002bfbee9',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    's or consultants are used to carry out work which we 
are required to sign off prior to the completion of the Services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '86c71d3d-093d-49f3-8510-a5c3ae7d9f53',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'must consult Polyroof Technical Services',
    'lifts',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '5945df69-1d00-453f-822c-8150c0820943',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'should take the necessary steps to identify the location of each of these 
services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '96afa7bd-fa0b-4971-9995-be55b2943b25',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'asked voestalpine Metsec plc',
    'lifts',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'bb6701ab-6f11-4c80-8dc8-07718fe70937',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Iden tification  Thermoguard Limited',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'e5bcf1b7-74c9-4c3a-be9b-10b12150d376',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'has installed and applied 
PermaRock materials in accordance with the specification prepared or agreed in writing by PermaRock     
Products Ltd',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '401f9c29-1d92-4eb9-a092-a1daf2401dc8',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    'f597bfa4-eb11-4cdc-a182-1dece967b45e',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    '000632d6-c816-44ef-81fc-e6ae2019e0e9',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    'b5565757-966b-4f1b-90db-66e8d97690e3',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    'fc1d311c-fd0a-42e2-b1f6-9206eb943156',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    '365e2256-193c-4790-a6e0-1e24ca972dee',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
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
    'f04bb158-4f96-43a3-ad54-52a71af0d9cb',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'to whom 
Urban Rope Access Ltd  is to provide  services',
    'security',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '9eb1519b-1060-4446-b3e3-e0725d8641d6',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'will provide the services',
    'pest_control',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'c84f7c14-cef7-4896-bdbe-e2f550fa00f0',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'will provide the services',
    'pest_control',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '71d1ae98-5f9f-4f29-bdef-30432a280a7b',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'for all purposes relating to the performance of the contract of

employment including but not limited',
    'security',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '8f1d3da9-0c2a-4bf8-8a91-c1fec4bc4a22',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'shall provide in respect of the S ystem the additional services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '061109df-4d5f-45f2-827f-071dceae73cf',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'shall provide in res pect of the System the additional services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'a5d95ccf-3ff5-44c0-8fa0-72ff9890ea74',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'shall provide in res pect of the System the additional services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'b22352ac-5cf6-4548-9234-58c9f3382379',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'shall provide in respect of the S ystem the additional services',
    'mne',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '9273b682-b7b0-44a5-bee5-d314ec711d54',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'is agreeable to providing such services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '8cee28db-5b6e-4170-824a-9136d2a26aaa',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Ltd
Grainger Pimlico Management 
Limited',
    'fire',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '897d3682-9402-4b11-9705-87c85c547811',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Ltd
Grainger Pimlico Management Limited',
    'general',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'e00c6a22-fe67-4a27-9b7c-0530e9462ecf',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    'fire',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'a9f8c32b-9fcf-49d3-b4e5-95cd5448aa22',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Ltd
Grainger Pimlico Management 
Limited',
    'fire',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '766c4947-a2d3-4589-8f7c-c4b32a1d766a',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Ltd
Grainger Pimlico Management 
Limited',
    'general',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '033d379f-ce26-4192-be39-597f15214512',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Target Lifts Ltd',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'c83a95b4-81e6-41dc-8e66-66c46c643275',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'NAME  Grainger Pimlico Management Company Ltd',
    'security',
    NULL,
    NULL,
    720.0
);

-- Service Charge Accounts (1)
INSERT INTO service_charge_accounts (
    id, building_id, financial_year, year_end_date,
    approval_date, is_approved, total_expenditure
) VALUES (
    '683558ae-ef55-42e8-821b-ea05c1b7bbf2',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    '2024',
    NULL,
    NULL,
    FALSE,
    NULL
);

-- Leases (1)
INSERT INTO leases (
    id, building_id, title_number, term_years, ground_rent
) VALUES (
    '954c31f6-567c-46dd-968f-88f8e1f907b8',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    NULL,
    NULL,
    NULL
);

-- Contractors (5)
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '613f5390-3e0a-43de-82c8-ebca02720cf7',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Maintenance and Services',
    '["repairs_maintenance"]',
    488892.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'cb4c8408-f6ca-4c2e-a77e-7e678d0106ef',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'NAME  Grainger Pimlico Management Company Ltd',
    '["security"]',
    720.0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'fd9ab35c-b1b4-4949-8a2c-883cb9f6e760',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Ltd
Grainger Pimlico Management 
Limited',
    '["fire", "general"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'b07c3956-aedb-48d9-9eee-197c9e21a96d',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Iden tification  Thermoguard Limited',
    '["cleaning"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    '1b10e929-8bcb-45fa-aa07-e9b5e1b9946e',
    'a4a40228-663a-4e4d-96bd-784ea85a70f5',
    'Target Lifts Ltd',
    '["cleaning"]',
    0,
    TRUE
);
