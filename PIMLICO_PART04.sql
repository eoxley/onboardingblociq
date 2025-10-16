BEGIN;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ea915074-1c95-4bdb-8e20-33852f9f7746',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'may not log book.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dc009dc5-7628-4dac-8bb7-00a8d09764ea',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests. regular bell tests of the fire alarm system,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c30e95c8-125c-42c9-85a8-9f424850a60b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '30b57f09-99c0-4d18-aa0c-8961baf851d4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition?  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '05831ef4-091f-4086-8aab-41a67b6d5fa7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- SCHEDULE A £1,500.00 £1,500.00Maintained as prev',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4ee1a310-2c65-4577-a407-e30f12979662',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'within the flat is to be relocated to a position adjacent to the existing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ced75d4-bfa2-41b7-b917-dbc613d2cafd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems—minimising consequential water damage, whilst providing the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '306c8b1c-d0b1-42b7-bced-38fc900440df',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'space numbered XX for the parking of a private motor vehicle. The Lessor reserves the right to reallocate spaces from time to time. The occupier of the flat has right of access between his car and his...',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '691d5db7-a0fc-403b-8a7a-c793818e8e0f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '© 2020 The Association of Residential Managing Agents Ltd',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6cb508f3-1769-47d4-bc2e-538afd79e22a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Signed on behalf of the Client …………………………………………………',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a892cf11-cd86-41d3-9931-46715847d318',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'costs and equipment hire costs.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8c2194a5-291d-43f0-8c49-044f40d7617a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'post_room',
    'general',
    'Post Room',
    NULL,
    NULL,
    'and bin areas.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2508eb59-dfc6-4dae-8df2-5c361760e187',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'monitor 19.99m 0.10ma Pass – visual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3878748-1800-45bd-8866-be1aec9faccb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'recorder 19.99m 0.10ma Pass – visual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'be62ed8a-8112-41c0-8807-3736d9901218',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'and patrols the building has been kept secure from unauthorised entry',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8bec17ea-de4d-4485-85c4-2989931ca3e7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit Routine Fire Alarm Service Visit - System Satisfactory',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e11f0dfa-43c5-495d-9d37-18f81a2d77af',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit per block £40.00 £240.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0fdec51a-b8a8-4e0d-a8d8-1aaa10a1e563',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'at the concierge desk.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41a91a4c-084c-461e-b792-2a3db7d1685e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system: Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1fdef4d-4216-49bf-8113-19c6db98aad6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System, the Customer shall, in the event of the System operating, forthwith notify the Company thereof by telephone: the Company',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2ed6e491-22c2-4bcc-a37a-c14fb7322b33',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'rooms etc',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '97977211-0a49-4449-b9b7-6e9f642e4805',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'rooms etc. Thereafter for the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4927a91e-75b6-492e-b514-5b660bc82c61',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system & Smoke Ventilation Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'aa73bbce-b459-4659-be59-92586324ba64',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system & Smoke Ventilation systems Equipment Schedule',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'af8eede1-3766-46c5-b9a0-370b5bae20cd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Equipment Schedule',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '463e77f0-f7a7-4add-bc47-d51ee4497304',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Panels',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '234f7d97-1d30-4820-b016-5c125c6d144f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System – 2 visits per year',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b9a3f202-6220-42b7-9c54-1e32a4b9efbe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System £2,135.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'baf78ba7-8b43-4f80-8992-231c1942085f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system logbook for each system will be completed and any defect logged and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ae491b7-2b78-4d20-aa8a-f8877d473c7a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Periodic Maintenance',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '31d02fbb-2207-488d-9c88-91a4133bacfd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems for buildings —Part 1: Code of practice for system design, installation,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0e55ccb1-97a9-4185-99f9-f57b00defeed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel. Should these not be available our engineer will',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e4793d04-c37d-41e1-a211-38ce7f21492e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system to the relevant British Standards;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e558a4b1-ce64-4c53-9b3d-b7ade7001e02',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Servicing will be undertaken either quarterly or Bi-annually dependent on the size',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b7a734f8-306f-4ab6-be79-2349ace39f8b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ae8bd47c-0c75-445b-9824-719a8c03f4d0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and detection system is carried out. All 2-hour response. Our standard response is 4 hour',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b01480d3-6a5c-45fc-ba1f-c5ba73415303',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and detection',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b610cf25-de08-4abc-abba-812f9b474dff',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '• CCTV • Intruder Alarm • Communications • Networked Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e35d6817-96c6-482b-bb5f-ce978574e6e7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '• Intruder Alarm • Communications • Networked Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bcaa66d2-c13a-4c79-b70b-0b9aa82c1d55',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'or congestion charges',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2d7b6a0f-0904-40be-9099-2c953964fc2a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'accf11b2-e409-4bfe-b47a-1a9294085fcf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Congestion Charge',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8b533d80-0675-46bd-ad40-ebdeadb86b5d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Systems of the type(s) we have identified below, certify that the maintenance work identifield below complies',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7f6d4291-127b-4c27-a9e2-4ef177628038',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Contractor Certificate No. 323',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3f85ee0e-05c0-4b3f-a22e-7144e6fe3abf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '(L4)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '35447414-b897-47a5-8cff-fad27cebff84',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c5f5da29-bd27-49bc-9503-e94ecb1b2052',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System at Pimlico Place, as detailed in 1 2,087.00 2,087.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '324b674b-cba6-4af6-8a6f-0c1e028caca7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems there.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'eaa33763-8bcf-4c9c-b1c4-2767572cd85a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'DateofTest-06/06/2025',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '06696fc3-2e4d-476f-b436-847d870fedfd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'MAINTENANCE REPORT',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fe30cd0b-b107-4f21-9be1-6c6a710cea1b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SERVICE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5ee8e86-bd01-418b-9560-7d63428cb14b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit - Routine Fire Alarm Service Visit - System Satisfactory',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e016f864-830d-4866-85f8-4fc70caa165c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit £240.00 £240.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd616e2f9-9a9c-48cf-a483-94078ce4ce4e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'procedures to control',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '44a96a19-d307-44c4-920a-1965049b2aed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and will need to be closed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5fbbac7a-1394-471d-bb3c-e1d9eabb57f0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'reset.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3bb5631e-d124-4b6d-9ab4-4470ebf63d91',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and smoke detection with AOVs;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ac1f30c7-afb4-4752-8325-ffba4a850735',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Smoke Detection & AOVs Fidelity 1 Stables Court High Street Orpington BR5 3NL 0844 800 9960 service@fidelityintegrated.com',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2c25303c-291c-4df8-b8f7-0e74ac479035',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'Seecam 20 Market Hill Southam CV47 0HF 07917 508961 info@seecam.co.uk',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c8c76db6-626e-4db1-8ffa-773c16aa088f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1bdda66-e457-4c26-94c9-6be217551174',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'and is insulated. From',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5d34f2e0-a60e-4f75-85c8-dbbe840565d5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'and When witnessing tests of sprinkler blow-down and hose reels ensure that there is minimum risk As directed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '124e7db3-1699-4922-a1d2-3d09778b927f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1x Bib Tap - Low Use 24.9',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '01e48747-b772-432d-b6b8-bef9dbf21f0f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'areas for the flats and commercial units.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b5a62009-ea69-451d-820e-6e4b2b929b46',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'water_meter_location',
    'utilities',
    'Water Meter',
    NULL,
    'NON-RETURN DOUBLE CHECK VALVE TEMPERATURE PRESSURE GAUGE IWH: INSTANTANEOUS WATER HEATER PRESSURE RELIEF VALVE H PO IU U : W HE H A : T P O IN IN TE T R O F F A U C S E E U W NI A T TER HEATER CWH COM...',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'efb17eec-f270-47f0-9518-5905393de3ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'MIXER TAP EXPANSION VESSEL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'db610bff-407b-43b2-895f-89caf0a82a6d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'WM WASHING MACHINE WATER SOFTENER IM ICE MACHINE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '02532c01-e40c-4b57-94c0-7613f3eae243',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'and is insulated.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '95bf01be-b4e7-4550-bb84-6d3546bb42c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1 x Bib Tap - Low Use 19.9',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20df1777-e504-45b8-9beb-a3455e818e95',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 144.00 -231.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bfacb5f2-727a-4b77-af1b-cb6e0b96110c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, Pimlico Place Last In None',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '43c16134-7a3c-44cf-a9c6-bad5323f8a59',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, Pimlico Place Last In None',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ccd16d6e-15a6-413d-ae61-c2c9e1197ded',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Service £172.80 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0b982912-7d94-4539-b777-f9742ac9d862',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'service £259.20 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c1460a3d-6159-4321-9ce5-be1815fe82b9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation by E6£174.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '61b5b42d-d74c-4e23-808c-c9b63c20e924',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service £4,500.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '75525fc6-7ded-484a-8e44-345ccc510a31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service £6,000.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ac2f4361-0a78-4be8-b6db-cee08f2ca21c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service-£6,000.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a7b7179e-293a-4bb7-9ec3-ad87b6e09cba',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, Pimlico Place',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5f38f46c-a1c8-4988-bec5-00a7191673cb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, Pimlico Place',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a019376-38aa-42a0-a19a-b64317e96ebe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service and Maintenance - 4,698.00 4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5cdcf2d-e597-4ed9-a2a7-6cee866fc6bb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service" - -4,698.00 -4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '74050cdf-9347-490e-80fd-3062772c5322',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'maintenance - Jul 24 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '66e9f370-0093-49d4-84d6-3bb9bb0eae90',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - Apr 25 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ad66404-986a-4aa5-a91d-236565fd9b40',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and smoke vent - 2,796.00 2,796.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '16904be1-49c5-483e-9fd2-20fa46ce6864',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'light which is - 752.40 752.40',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fc16f55c-ac48-48e1-a40d-2296ad8bb3a2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 1,000.00 235.20 -764.80',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '309a9bad-e622-4da2-b63d-d1f09cbc421e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 -375.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1284b788-b904-449e-9f7e-c93f2d06556c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 2,000.00 3,499.35 1,499.35',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4dc48b2c-b778-4a11-8c4b-d12260b2b680',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 750.00 -750.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2024c469-80ff-469e-91da-7fc7f1bee341',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 3,000.00 2,262.60 -737.40',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68a1b920-58c8-436a-94ea-329375146eb1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,125.00 1,482.24 357.24',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '458e34c3-af9f-48ba-8cb3-fb16b353eef9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 3,000.00 6,827.14 3,827.14',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4a708475-13e0-477a-b2df-a616f8d3bf5b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,125.00 -1,125.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '989cc2fc-9ca6-4ba7-be12-10eb04117c31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 2,000.00 2,070.60 70.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b45f5079-ae4f-44ff-88d1-95d25ced90c0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 750.00 72.00 -678.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6f19369a-9bb0-413a-be49-0e45efaeafd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '72.00 72.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4feb1e56-67b2-480b-b5f8-a217f750ebef',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 1,000.00 1,248.60 248.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ec2543d9-e1fb-4607-8499-db9f24c86a85',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 72.00 -303.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '45c03281-b662-4e2f-84d5-cbafef0a761e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service" - 4,698.00 4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '19e5a709-51ed-415d-82e5-0ab9cb54e672',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - Jan 24 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2eddcff8-dcc6-4c29-8471-101e5e569ef5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- SCHEDULE A',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b262a5cb-6a45-4432-88ea-b48b5cda6ff8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'battery - 312.00 312.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3c8b4418-f291-4cf2-9afd-901c5031f580',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- 1,263.60 1,263.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e538ce0e-3fb1-453d-a839-dfaacea1a468',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'Supplies - 92.41 92.41',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '69a64964-12fd-488a-8c3b-02c379efafc4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'Supplies - 3.85 3.85',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '826918b3-b981-44a3-a250-40de2b9d3d16',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 - Current',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5c088b9-1435-44c2-ab4e-bbd0c6856f7c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 551.81 551.81',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0bd8350e-e564-4954-8756-c64abd722a77',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 - Current',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a565a8e-715d-46c4-a503-dc31deee3b20',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 551.81 551.81',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dfd84d97-f2e9-4ead-b2af-149e32f52336',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c65f1a5a-d08e-4bf5-8e0d-205ee53aef24',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4626c917-312d-40f0-9716-eb0df23d5153',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 239.00 25.00 264.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '649daaa6-c3af-41c1-a7fe-a5274b259dcc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 - Previous',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bada6c1a-9bd3-48b7-9ce2-72f3c162fa41',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 239.00 239.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39250db8-99e7-41b5-bbfd-a712969670c2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 239.00 25.00 264.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9da0ea3e-4100-4dee-b05a-f6545bd6d090',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 239.00 239.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a9e1a09f-5919-432f-8ab1-4f7bd82cf25d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 25.00 25.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4afa0c0f-47c2-4bee-9fa5-10181bf35142',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 25.00 25.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '627f742b-3828-42a9-93e9-c86461c7f609',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cb0b8790-7c17-40b9-ad0f-a832994780e2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£ 2,768.00 £ 2,000.00 £ 1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3bcdd00c-ab0c-41f5-ae20-8fd72da50570',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8570a5e4-3e72-40ed-9ac1-9c72a0daa7b9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 397.07 397.07',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '000b5727-6198-4636-8fb1-5279b2a36f70',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 463.61 463.61',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a1c83a4-78b8-441c-aa27-0be5068dd121',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'cleaning supplies - 206.76 206.76',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cc134e3e-4001-45c3-8ee3-a8a7bc0206e1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 97.26 97.26',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '50c3e068-d79c-4496-badf-e72969f72569',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'have been evaluated for cost-effectiveness while ensuring statutory compliance.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e67a5915-c958-4795-ba4f-f2756c8f3e36',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 £ 8 33.40 £1,000.00Maintained by Fidelity on ad hoc basis, no formal contract reduced inline with Actual costs',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'acc0a090-0e27-40e8-9ff7-679239b7e15e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '6 MONTHLY MAINTENANCE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '17923b56-c69d-44b3-81ae-a4b6a4a5c045',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SERVICE 2.00 £280.00 20% £560.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9a765180-8b04-45a3-8fe3-0620b9492df3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service £480.00 + VAT per annum',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9ec4fb43-a1ca-4741-ad7c-791be069725f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights £4,000.00 £2,930.00 £3,000.00Plus repair cost allowance',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a5aebcb5-80a9-4c32-adcc-084d629b9401',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£1,500.00 £1,575.60 £1,500.00Maintained by Fidelity on ad hoc basis, no formal contract',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b973c99a-50a1-46e0-9330-8d5b61350f4d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£1,500.00 £1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f4b15f41-ff63-4014-ba26-300b062d3a67',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'at Pimlico Place - 1,410.24 1,410.24',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '99186458-2ab3-4791-8b94-b88ad59ba555',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 152.10 152.10',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03f4799f-f065-424e-9235-3bc71a60bf3f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '- 435.00 435.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '462c62ba-6687-4eef-9bf9-4285736c3cbb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - 444.84 444.84',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b9bead04-84a5-4629-a09d-727824f4be96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 261.93 261.93',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bc1c21d9-6ef3-4bf1-aaa3-6268a897063d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'on site and - 168.00 168.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f19fb25b-43f9-4b0b-afcc-8a96ce7a4d96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Present? n/a n/a n/a n/a',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a26146c4-211c-479d-9dcd-1de3866f4843',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system with a suitable Smoke detectors have been installed to Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e63937c2-3664-44d7-ad6c-ac2ae516f9eb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system identified as being in good Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bc2c8aad-49fe-4f71-b7b9-0fb9ea6c02a3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'confirmed as being adequately place, and given the presence of Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '793ac39f-63ea-41f3-a48a-2b7752b8d563',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system plus AOV Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20c24a45-c943-4107-89e1-f63fd9deff40',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests carried out on a weekly',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b544bf82-ec45-4d4a-8651-f02b2303b046',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests (at Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4c450734-2625-4cdb-acb6-5ebb1dea6202',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, a full evacuation policy',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a088c4a-21d1-49c2-8792-e9a5e1a00cd6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'yes Continue to maintain Attack / theft / fire. low',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1c2dc287-b934-4828-87b1-692687151770',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'in car park, staff kitchen & w.c. in block F ground floor, CCTV.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

COMMIT;