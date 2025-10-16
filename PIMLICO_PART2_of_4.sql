BEGIN;
-- ============================================================================
INSERT INTO extraction_runs (
    id, building_id, extraction_date, extraction_version,
    units_extracted, leaseholders_extracted,
    compliance_assets_extracted, contracts_extracted,
    data_quality, confidence_score,
    new_types_discovered, low_confidence_detections,
    source_folder, extraction_status
)
VALUES (
    '2069e3b7-ecde-4ae3-9976-65de0d11d3df',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    NOW(),
    '6.0',
    83,
    82,
    81,
    0,
    'production',
    0.99,
    0,
    0,
    '',
    'Success'
);



-- ============================================================
-- POST-PROCESSING ENRICHMENT
-- Auto-generated corrections and enhancements
-- ============================================================

-- ============================================================
-- Building Knowledge Enhancement
-- ============================================================
-- Note: Uses existing building_keys_access table with enhanced columns
-- This DDL ensures the table has the required columns for building knowledge

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add category column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'category'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN category text;
    END IF;

    -- Add label column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'label'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN label text;
    END IF;

    -- Add visibility column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'visibility'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN visibility text DEFAULT 'team';
    END IF;
END $$;

-- Create indexes if missing
CREATE INDEX IF NOT EXISTS idx_building_keys_access_category
    ON building_keys_access(building_id, category);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_search
    ON building_keys_access USING gin(
        to_tsvector('english',
            COALESCE(label, '') || ' ' ||
            COALESCE(description, '') || ' ' ||
            COALESCE(location, '')
        )
    );


-- Update building address
UPDATE buildings
SET address = '01 PIMLICO PLACE'
WHERE id = 'cd83b608-ee5a-4bcc-b02d-0bc65a477829';

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '673dd0ed-614e-4e66-9fae-3795f8287e3c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'fees and the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd6c7c622-326b-49e9-b1e8-9df2e6d630fa',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to allow Liftworks Ltd engineers',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '15a8157e-1124-4e0c-bff3-4b377769ae71',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces within Pimlico Place, number 1 (level 1) and',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1268a498-64e1-437e-9149-9cae398e4871',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces and the circumstances of their grant,',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1dc7b62b-cf19-4f75-a785-a5b97b929cd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 (level 1) 22.08.2017 NGL972412',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '665a901f-35b0-439e-992e-cdb8bf77a38e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 (level 1) 22.08.2017 NGL972412',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '82000dad-4983-4acd-81ab-ca47884c68ae',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, 29 Gillingham Street, London',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '92acc16a-364b-499e-96f2-eae992bca80d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, 29 Gillingham Street, London',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dc0a7187-8128-4444-801a-f265f9acdc7f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 was £1 and the price, other',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '624a4755-714c-4a07-9652-fe03eca58637',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 was £1.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9729a7ce-3456-49e0-b7cd-aa579fae7fe3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to be arranged for Excell vans for the period of works.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4a3a4d96-0993-4cb2-bd9c-2f45fea7b866',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to be provided for the installation team for the period of works',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6be02665-b793-460a-8d23-fce88bf3d612',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay suspensions 1 item. £ 7 ,765.36 1item. £10,511.55',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fb12a710-a832-442f-b5ee-03ab8e1447d4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay suspensions 1item. £9,344.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '671b7a1b-743a-4e95-8c38-aed4dadc590e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system within each flat although the extent of coverage is not specified. There is a communal',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9afc27dc-d9a1-4217-960b-870a1d737f66',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays may become apparent during the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3d55fa02-7ec4-4da4-ab87-c0596ebe9a55',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay(s):',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c2741100-00ec-453e-bb3c-4d4a7669c6a1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays:',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e6f9a4a4-ed07-48dc-938b-17ce35fb2294',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays. Five of these bays',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd7a38aed-2a1f-44f1-a41c-bdcb3258cc4a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '/ basement plant area.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '97d4384d-e71c-43aa-86ad-762b81b02f74',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'service £172.80 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1f4b04b2-de6e-4593-a8d4-6f7f380ab266',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'regulations or restrictions in Yes No',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '78890887-a085-4514-9451-f739203d1d96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '8 66 1 ,500 6 29',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f09f3100-2d51-41b9-b59e-b3c0838d09d8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£ 1,500.00 £ 629.00 £ 1,500.00 No increase from previous year- Provision allows for any repairs',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'abec8479-ac16-4ac2-8a06-126af3b4ddc1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'in the ground floor main entrance lobby',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8648c548-d45b-4dd8-a164-9db3e084321e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'for ease of reference.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b2814d2a-17c1-466a-a450-e5299d988d79',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'for',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f87710ef-98b9-4439-aaaf-55808e5fa30e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel; mains powered',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cb22cbd2-998e-44eb-ac80-e18fcca9830b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system within an apartment will raise an alarm within that apartment of fire origin only due to the “protect',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f491805e-6439-482d-95e3-b81e2a3d576a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel in the ground floor main entrance lobby',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5baffa3e-f3f3-4ea8-860a-15475f93e28c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation X Not checked.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20f1c6e6-0ee5-436d-8677-9b306e672fd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a7d75186-2fb8-4f0e-929a-d8b591ff039b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'in the commercial / retail units or car park. This also works in the reverse order.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f2c0db29-371d-489e-a69b-992796ac38c2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'frequently has the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8cfedeab-481d-4eb8-aaf0-e2aa10aa7bbe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'cables through',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8af59f5f-f4e6-4085-b55b-b4175d7d14ba',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'entrance - Reception. near the fire alarm panel. This system and locate on or adjacent to the fire',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3f5cbe21-c555-49de-8c60-4960c4fa65b5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel for ease of reference.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a54cae4-0f29-4da9-a65c-8159150aaebc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '2 1 L Train and utilise site based staff to carry out',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1df15dd6-5489-4d78-945c-bf3604f43eab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests. servicing / maintenance regular bell tests of the fire alarm system,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b3935cc2-5b1f-4845-bbb9-8c409966480f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, although these',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c7315b32-ced8-490f-8b19-a59765069bf4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Smoke vent switches for    Automatic operation also 1 2 L Replace smoke ventilation call points with',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '138e8292-b054-4052-bc76-55718bd9fd74',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call point near Flat 2 ',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6476bf47-e4bc-47ff-b7c1-58ae7dd736d7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call point near Flat',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2dc004a6-3241-40ee-8563-de3efa1589fc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'frequently has the following',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '78114eb1-6a98-4c3d-b6b4-a69854adfaf7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel for',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e2a80e3b-bda4-400d-b74e-e948c02da41c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, ensuring any manual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '04edd999-878e-4f47-93b6-afb6d3ce5fed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, although these can be',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fb1fbcf5-2891-4543-a825-8ecb53e3ab47',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Replace smoke ventilation call points',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a74f4d8b-9bbf-4361-8b68-a82b0e99dba4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '80c75a35-ed6d-4ffa-8d33-39e81a09139b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system covers a covered car park and partially escape corridors from the car park. The Estate',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '898abe0c-6eee-493e-a3c9-87714d83222c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system as they have',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cc6688e8-8c35-4439-81cd-73f79ee0785e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'control valves identified and  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a5dde4a-ebcc-4318-93ca-24dc2701d25a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition?  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a0b63472-dc63-46c5-92f9-bd49b8772fee',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system tested and maintained as N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '083667d9-8887-48e6-88e8-21ae905d1e3b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system relevant British Standard. Maintain up to date',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ab0ec1bc-9176-466c-9819-11a1c27edddf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Assembly Point
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '75c1dfd9-3d2e-4c99-b47e-962be5861824',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'assembly_point',
    'safety',
    'Fire Assembly Point',
    NULL,
    NULL,
    'identified?  Assembly point identified.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c72bb53a-42a3-4d14-b744-906cded6c598',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '- Internal courtyard / communal garden - Roof of Core A - External',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cf75a98b-9a8a-4025-852e-d689e60767ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'are located on the ground floor.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2ab3b7bd-07c4-4946-a97a-052212bb1247',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'are designed to operate the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cd550a27-6943-40b6-a789-888d050c6bd3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '27 M',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '111b3af3-ade1-4312-a3af-f9108ceecd53',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'Replace plastic cable ties with non-',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8936149-11fb-4551-8f02-2fa64389f702',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Security measures: 24 hour manned reception. CCTV. Security alarm. Intercom door entry. Fob',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '52f6556b-af20-4777-ad0c-5816ec220e59',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '2 ,387 1 ,500 8 66',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '540e64b6-9394-498b-a694-7548677f5152',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'via Gillingham Street.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3b46e64-a353-4326-90fd-5c60e2426602',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay area up the lift or staircase to the flat.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f5a56898-b3b0-406d-ac87-974f337d1dd0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'permits will need be applied for by',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f4527b5f-7e7b-4b13-aa66-4e2564a87b72',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'space for storage of',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0564a870-a147-4eec-88dc-5fdaad08acd1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay area and weekly from',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd3fece6f-5f65-4d9e-8c5b-a167dca0aa7d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay away.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68212fc4-ce7a-4b63-8395-b48c8d8bf4eb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay for vehicle parking of the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03a04341-f698-4967-88f4-ca76d10ae0c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'provided to Local Authority & owner on',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Electric Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8e0bfc2f-59b4-4719-b6d0-92bbf5de7dad',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'electric_meter_location',
    'utilities',
    'Electric Meter',
    NULL,
    'electrician.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'db82e50e-22f5-43dd-9beb-e3c483f3b564',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'is existing. § Fuses, RCDs and switches within consumer unit and remote fused switches',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '26746fa6-ba79-4248-8d91-3138f3ecb8c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'etc.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fe157f02-b63e-40f5-ab0d-1d82c8e9cb37',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to be removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '14c5fa4d-216c-49bc-9ead-4310c6c47be1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flues to be removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5e9240f4-229e-431c-917e-18519dd11f0d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Fireplace to',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '87bc03bb-d8ee-48b1-bf40-baea8ab87b84',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Systems 3mm skim finish',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a52157d7-fda5-40bf-8565-040dd8c01134',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '5 5A light switch Light pendant Towel rail / Radiator',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b15ba8f0-ab3d-42e9-bfce-23212b88827e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Detection Systems: Only applies to new dwellings.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5dc8c0f6-8945-4dc8-8971-ba10a318881b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'congestion). The site is',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6733b21c-7046-425b-bf12-71fb34be4fd4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Zone A1, applicable hours, Monday-Friday 8.30am - 6.30 pm.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f75d8958-956e-469d-b225-e758b9523ae0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays with a 4 hour stay limit. See',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '148fb908-7285-4a7a-ad96-fd1e22e5ac04',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Electric Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4439192d-81a4-4fa2-9995-b2756c1d1ab8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'electric_meter_location',
    'utilities',
    'Electric Meter',
    NULL,
    'Installers Electrical Installation Certificate to be',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2eb15e60-1d21-4968-a392-c11be11b7de2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'is existing. § Permanent labels to be fixed to earth connections & bonds',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8675f09f-5d55-44d3-9bc0-7673ab45cc76',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to be remain extractor to be redirected to rear wall',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c3b881b0-a765-4a64-9d9d-fa1beb9513b2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue to be re-routed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b53f407e-d68b-43ba-a914-044c162c93bb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue boxed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39068892-463d-40f3-b66e-491477e22281',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'condensing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8699c78b-fd8d-46ed-9648-e5e71c7af30c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue and kitchen Bellcast bead',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6a040229-a437-475d-b2f6-0ea4d1106cdb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue box Living room b o a p r e r n ie in rs g s around all 1 G y la p y s e u r m o f a 1 n 2 d .5mm FireLine duplex',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bd818129-a05b-462c-9b7a-3f5046bdebd7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Detection Systems: § Not applicable to this existing flat § Fuses, RCDs and switches within consumer unit and remote fused switches',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cd8d91b3-77e1-4b7f-ba72-78db5c52bb31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'ventilation systems, approved',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e9a74631-9b0d-403e-b330-ec6b639a7b06',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tools. Take action to',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c91a50b0-b316-41b0-a70c-6699639b3fbf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'ventilation systems, approved explosion-proof equipment, and',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '209daa4e-6f33-4166-8b30-315ac5cbf317',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tools.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '93064bb3-6c12-4e8e-99ae-94b723602b07',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'at the above property/address has been carried out by',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9d340274-8923-412b-bfce-f77d416dc356',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1bd8fcd-4dd3-4949-b7c2-a2fe4efe74ae',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to replace existing gas unit.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd90cff11-5942-4c77-9d77-517cd14f585e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'or air source heat pump panels. Allow to use 18mm',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68f46a31-5fc3-4918-93cc-627e7c04f709',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by the contractor for storage. The site',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f08ea377-ab0f-4a1a-b251-a0eeb904e3c0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Zone A1, applicable hours,',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f883b10f-c0ef-4d5b-bc9e-ae959ad739f7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'or skips changes',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41bc64f1-805c-4cd3-96df-61d360102d3e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e5c2d0fa-2f56-464a-9859-e8dbee0cf8c3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'a car. Note that this car park has limited headroom which will',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '59fa5f90-9856-41a7-ac45-38bf50527789',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Systems by British Gypsum with joints sealed as VCL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '38b779c7-2dca-49bf-b8fa-c4290167dedc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '& radiaotors',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6ca7aac9-84cf-4a83-aabe-2e31842b42bc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- 1 ,500 2 ,387',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c81db21f-7852-4d4a-9df8-3b23f9dedfc2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas N/A Unable to confirm due to the alarm not',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1c6a04c9-0408-4676-b03f-7e4c9f996800',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'in the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '69e32bcc-9f03-43d0-94ec-524f4447a4c1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'may not to date records in fire log book.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '110de3b1-5ac5-44d0-8a19-9455870ddf1b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9df1021a-da4f-4506-b4d9-e66e2853d8cd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Smoke vent switches for    Automatic operation also 1 2 L Replace smoke ventilation call points with',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'eaf29053-facb-4fed-9a22-6c5f88da7cb9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '* frequently has the following',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c55f04f3-79f0-4619-aa52-52515b58ef4c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems including any',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '31359b1d-cd6d-4c0d-bbd1-117a312d90de',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment;',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fa691abb-9961-4f73-92c1-60d25c76eb47',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system covers a covered car park and partially escape corridors from the car park which is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '06f77411-d33c-474a-8925-4e191fc39396',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'control valves identified and N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '88e4349a-661e-40af-a239-3838986a7fca',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition? N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68f416dd-b578-48e4-99e3-735d3ea9b7cf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system *Action outstanding from previous',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Assembly Point
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '717a5f57-07d0-4bcd-8518-e313870039f1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'assembly_point',
    'safety',
    'Fire Assembly Point',
    NULL,
    NULL,
    'identified? N/A Residential property - assembly point is',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '11dfd975-c681-4375-a877-a40042513f2b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '- Internal courtyard / communal garden - Roof of Core A - External elevations',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a3ead25-26cb-4620-98ae-9badd8942635',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1 ,576 1 ,500 -',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Sprinkler
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

-- Building knowledge: CCTV
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

-- Building knowledge: Boiler
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

-- Building knowledge: Sprinkler
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Post Room
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Alarm Panel
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Boiler
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

-- Building knowledge: Boiler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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
    'system to the relevant British Standards;',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Parking
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Parking
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Sprinkler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Alarm Panel
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Parking
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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
    'and smoke detection with AOVs; gas safety monitoring system; Gym; pond/water feature; communal water system',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Parking
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

-- Building knowledge: Stopcock
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

-- Building knowledge: Sprinkler
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

-- Building knowledge: Bin Store
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

-- Building knowledge: Parking
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

-- Building knowledge: Water Meter
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

-- Building knowledge: Boiler
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

-- Building knowledge: Boiler
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

-- Building knowledge: Stopcock
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

-- Building knowledge: Bin Store
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

-- Building knowledge: CCTV
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Boiler
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

-- Building knowledge: Boiler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Boiler
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

-- Building knowledge: Boiler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Bin Store
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Boiler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: Parking
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Caretaker
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: CCTV
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Caretaker
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

-- Building knowledge: Boiler
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: Fire Alarm
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

-- Building knowledge: CCTV
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

-- Building knowledge: Sprinkler
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

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a0ec7422-aa3e-4ba6-993c-38fa86aab969',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system is annually All persons within premises.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a5df7afd-2513-492b-bec8-6717291d1ce3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system identified within car park. maintained. Fire spread / smoke inhalation. medium',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'edaeb250-c928-4061-ab99-b29b9fdafc4b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'to Guildhouse Street (as indicated on Plan of Blocks above). AOV',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8a21e179-7518-4d61-9c43-d64d34f0fefb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'on Residents & visitors.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f9ef3594-7a29-46a4-bbf6-c65d39c0de90',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'Zoning. Your fire alarm panel does not Ensure that a floor map is devised highlighting all the zoned Urgent action Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a854dd04-270c-4682-9f1c-06fd0637b104',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Panel Zoning. Your fire alarm panel does not Ensure that a floor map is devised highlighting all the zoned Urgent action Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cf7347e7-dc6a-43e6-b004-52caf9fea347',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems must be tested weekly by a nominated 2-1 Six weeks Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '906afb4e-7676-408d-bb11-29133b87f0e2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'company. Keep service records on file.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd2253fd9-c698-464d-b46a-3c6ffee3cd25',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'operating points easily accessible? Automatic fire alarm operating points are all easily accessible throughout the building.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4ac56e8a-dd82-42f5-b0f2-e99a2ef2303e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system. The sprinkler Sprinkler systems provided within your premises require 2-1 Six weeks Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b4605e82-a25b-436d-9064-04f7bb2dd50b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces. The building has a gym with a Japanese court',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1669b175-1295-4e62-85d8-2011ab03a4db',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03575f9a-bdff-4528-8ed7-44c8d87f404d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'around the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f5065786-9a22-4ede-9c5b-b75de6fde2e5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'and residential blocks (private and atfordable housing) of varying heights. An existing',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '46b7e3cd-aaa9-4af3-bc02-4f1c109a41ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'and residential accommodation;',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '146fc88a-09e8-4c13-bf99-1b918ca96886',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1x Bib Tap - Low Use - - - -',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b21aa86d-6dd6-4f32-9e95-4555397e6c25',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'bib tap',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd83c0624-762a-4293-9f1b-01cdba5d9753',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel? *',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '65e6fe86-c84b-4bbd-90b8-7abb01f27364',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'in good, clean condition? *',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8a1627a-477b-4c8e-a5cc-2a9e9f24db5c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'issues on site, vehicles obstructing any roads/paths? Any abandoned vehicles? *',
    'team'
)
ON CONFLICT (id) DO NOTHING;


-- ============================================================================
-- Budgets (197 records) - Using actual schema fields
-- ============================================================================
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('48644340-b3c0-428a-9ed2-0cfc30cbaee4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('328531b8-0223-4c37-8859-235ffd2a3e91', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ab381e84-c7b1-45cc-8d92-3e8069933db1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4eba2c36-6583-44fc-bacb-da106032f943', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d64292fa-3218-4ebd-ba90-55d4cd9119d1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2bb1b832-0c70-4e31-8153-b252110babec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('14a0bd59-d564-4648-abea-13c95158cf7e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f54c33d4-24c1-46db-a51a-d25607553f33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bfe50d14-9637-4cb7-bb3d-fd9e114a4eed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7ebcab2c-b703-4c86-9570-dab0f03b09ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f19af977-4f6b-4d57-81fd-4c60a0c99a07', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('76ac2d00-7295-4df0-9c9f-b80a8d334d29', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('936a81fe-c67c-408b-b4c4-afe9fd1dabb9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a9cef3b7-bca4-4775-baec-fe4ba7220589', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('477df829-5564-42fb-830f-335f29400aa9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('218f45e0-df5f-44f5-ad52-b03fd35ea4ec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('267ffb7b-ee58-4524-90d3-82e3dba218a5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('149acd60-1321-4707-82bb-7694006ca024', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('24a2a4c7-4f9b-46eb-bebe-409b003ae7b9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f88d90da-9a98-4162-86c4-eaa79d3689fb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c6750e2b-5e33-45b3-8174-13758464a3db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4b776c5c-df58-4efd-9fda-07a689c606f5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b326324e-31c1-4ea7-a208-806c96ad61fa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bded0ba7-50a3-4a81-b3cd-2737039dadd9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('96184bc1-f874-4523-9d87-d25aa22dac4e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('94e59820-80d1-4d03-a358-56e3e692d9bf', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6b6cb19a-4e91-4d71-897a-08e15d72ac14', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9b6ad12c-de77-4632-8257-631a96d3bbef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a559091f-9a29-4838-b490-7dffd3e7c5c6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('380fbf85-142d-4e8b-886b-c3808751666b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3e5850d3-2722-465d-a977-9541c26da6e0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('802c90c1-4093-4c1d-8fa3-080d021e89ef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('07220bee-b769-4689-afc1-b65d778684b6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9617b587-d16c-47ac-81d8-150f09ad0dc2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8ea1e38e-59ea-426d-94c2-f6c5f9c0c8db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('80500bb6-aea9-4d75-8b75-7160c6ed16c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('91f326bd-1a67-4cc8-be67-4861ceede972', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('417477a0-8e9a-4b0c-9d6d-b0664c4ed313', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('642701e0-650c-40da-b6bc-475c185312a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('864fd0d9-893e-49e4-8483-253638ef003f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('15a1f751-a146-428c-a276-3b3b3a99beef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('126edfdc-5f05-43c5-a99d-7e936d5973c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0e7f187c-7661-481b-bd3e-55e303750cb8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('391b6462-512c-4915-b37a-7c51463decde', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8915356e-ba42-4e90-8812-7848cf28e669', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('31954276-bb81-4dc3-9255-564ca2d93735', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3bd9d799-0d96-4a7d-9e22-54b54d36aabc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a0664c14-ca29-47a3-b120-85dca2c55cd5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5835f74f-3ac3-4f41-9d3b-e23b68835c7e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5e280c86-0349-4482-9b83-f8adb7cfdb3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d3efd4b2-2375-4e79-94b8-6dbddfb6881e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('93f30d9f-b304-4d06-a8ca-1097f9a91a3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('82df1f2c-ac6a-47c2-b971-466bfb4663f2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('dee56b2b-fae6-4ed1-b917-dbf130870f6c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5a224399-4bec-420f-aef5-8978e65f25ea', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('eb39d946-ee39-4a7d-9ffd-e892ea50cce3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('48e8e323-cba0-40b4-aa2e-d3604d46a7be', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e8f874df-4321-44dd-b3aa-466d9b410352', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('972a268b-b7a0-4d79-abed-b43daff74626', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6deefb90-58c2-4b1c-b3ef-159338ab9c74', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('03b2e203-3b25-4b47-a8d8-28e7dc807e22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f7ee2140-e23e-4ac0-b559-9f30e52fed6a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d2ca62ae-0853-443f-ae80-69b9e868eb04', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('fbc88af4-94d4-48bd-b590-1d45b22b5872', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('931fb9f0-4cff-4f61-a337-0aeb56d578ff', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d7f7fc5f-da85-4784-af36-301090ec28cf', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5df96b24-b896-4afd-8e14-62fccfc4e0b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6a853233-5cad-4722-a95d-be52fc48818c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('322aef5e-0199-4d7e-8460-f97bd9e2006c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('49060206-a75d-4599-9f06-8ed6a9a3772d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('42f2ea96-bbba-450d-bc5e-3a1850b24150', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6cf43546-d6e7-4a89-a8f1-28ef4e6e777f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4873bd82-1309-47c2-bea6-c35da2f6a847', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8e085c88-cdcc-4bc2-a934-09992dcfbc9d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('1edba608-cc25-4313-8d44-501f815c925a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0b1978e0-772f-4288-a0b9-875b3b81c81a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f800e17a-1442-43e5-9527-fabc0b1ed5a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('68e5dd2b-38af-49c1-a5a4-783212881dd6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2a49cb4f-6121-40a0-ada3-56aee5ddbd08', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0fd5be90-abd8-4156-97dd-0cd92156f497', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('cff55c80-7e80-4373-be96-44654de68453', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8d13a380-c64b-434d-8314-7d7c6219de7d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bc1fbede-1da7-42a8-9a5b-c112bad0f363', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3c4859e4-068e-4cf2-86cf-3b3e2cc21b3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('af73ecc0-b17a-477b-8156-111155fd4c45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7d9106b8-09d6-4de4-9431-e175dad1b18b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5214ab5c-8fec-428e-84b8-8af9b8a76900', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c9660629-69c3-42bc-8ac1-c00b8f11a505', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5ca9fff7-1303-4729-a1e7-5e14131e7b31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6d5e0515-536d-46f9-a5be-e019ec10f853', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c867c165-dd1a-4c36-9197-8209be1289f0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0bbccc1f-d732-4967-bac5-5af74cf1c66c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('aa44dbc1-7e2a-4e42-bacf-f6df9117dd02', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f9761877-c8e0-4a99-9afb-7f66a542b45a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c84cb734-ae25-496f-a1e7-1d41528caa91', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0981ee27-b553-46c5-8b98-aeebf9521a64', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('31d76958-e82d-4340-aad0-c2009754affe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('89c41ddf-0a53-4bda-b599-9f0ba74b20bb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('72b135d8-6cb4-4983-bd7c-fc87d01b6b29', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a7346067-dd51-49a1-bc64-f6c1a0c272c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e51f7753-dfa7-4b3b-9d8c-9589b0c0d4bb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b52cc7f1-481a-4630-923a-20cebb3e7b97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7b8a3ff4-7231-4b60-bc61-108c011d1583', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('168c9331-d4cb-4fb8-b928-023f141b507c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a14bdc07-e5c5-4c61-9a67-17d9361cb378', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c47a4457-13bf-4a96-9e3f-b8dd3aed6981', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('adf5bfbb-dc45-43a6-a776-31e168c72d0b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e89339b2-1a20-4027-b3b9-5bea274b92c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b1e856c0-1345-4b26-97de-f9190995aa6a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('360a0811-d873-4dc8-b506-4d1e8f7719b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('fef81748-209f-4be7-88fb-58eff18542eb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bc9a2001-7684-4957-bf19-d0b85ad6b166', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('70e1e417-09fb-4b91-b05a-ece5e3b996e1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9cf3c018-f94a-419f-abae-ee2628a258a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('68941882-66e4-4c74-bb94-3a176a3eea42', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('dac1b0a3-73a2-474a-a371-522db1399cd4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('072cb06d-86fe-45ef-979b-413d7fa73504', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('214fc950-5495-4b21-8cd4-59f2b9e208d0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('1892d3c8-14fc-4daf-bc31-967d41959feb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0bb1179a-63ac-43e0-8788-02cb2cd7a5b9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8b93f9e4-3735-4760-9c2a-bf464049b711', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4581834e-0e64-4510-a9d3-5960c42a4fe6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c4ee8a4e-2ecb-437f-8121-f14d01a295e4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d5bdb848-2877-4343-8d74-a869f34c88a5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('61f045b3-f30a-4e9a-a4cd-579d679ae2de', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b56c9ea9-936b-4ed9-be5b-a2f562c2f89c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ef3eb4ef-260b-4eea-8e61-93c35534ca00', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('723129e3-08fe-406d-9241-98019746c287', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('15ddd29d-99cb-4bc1-b294-8a84af795625', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9f82590b-872f-4633-b111-d36fa7b3bf94', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b4fbef7e-ea9f-4c12-bc64-53ed8559da6d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('443af403-d614-4071-8850-cb335c17c3be', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('83d22746-b2f8-4a2f-ba18-fe9fa27892c4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('eeeaa73b-5ccd-4212-9781-07c5c65e6eb9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('03586119-9987-4d49-8020-dbf6b82b1c10', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('1d4fafd1-90b4-4c6e-af6d-775c0de1b120', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bd921e6c-4def-4d30-85aa-e00eba9182c6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e3e9588b-04e3-4d9b-8975-6992bfb660b7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8828d008-818a-44b1-8978-264afa7c7ddd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7bb16f75-8401-4794-b134-ddd0b35ee9c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9ccb2a8c-3559-4777-8eb1-fa947f450a4d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('28ea3d01-c153-448f-9bf0-ff3e4c5fecae', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('efd9fa4c-f671-4e07-ad06-688c5cf0bc3a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('566793cb-ba2d-4fbd-9c6d-2db8681dfcd2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6fd95288-1bef-45de-a6e1-227e0f0c3c63', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b5419b79-7c9f-48c9-8539-9340ae0d68fc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2be25334-39b7-4652-a25d-ac43afc17d4d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('85348be1-7fbd-477b-a931-421e4000f8fe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bbd5db27-38e6-4649-9d5b-343e9ed3071a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2f8c13a3-6407-43db-82a5-07b18333e00f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('86c8b93c-6532-4161-883f-a8616c055936', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b8454eb5-0e0d-40b4-856b-60493be0d006', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('59a04974-c0d4-4dfd-917a-89b561ac6c03', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d4e3b6e1-ace0-4a20-b48f-0eca630ee313', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5988996b-660a-452a-878b-3a279e253d19', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9fc15e86-b509-44bf-98dd-710b492f3160', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d1b42996-1d83-4333-8e7d-24e130b60c75', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('864a6270-bf64-4f33-8e8d-47bec80f656c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e83cf404-3d5c-4f68-905b-b837bf4a062b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f019a1f9-3c70-4763-8848-76adc73487f9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('99f599da-d93c-44ef-b00b-b1203110bd02', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a4507482-03cc-4028-a10e-2f5f32969eac', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e01b1013-6502-49b5-861c-049947606bc7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('cd8455a9-9ea5-4cd7-94e4-2c8fa7046de2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('37053aa5-16ea-479f-8f50-d1908cf1fadd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5c84c681-7db9-4697-8452-df4f059d4cbd', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a996dac2-0914-444d-bec7-a3b4b285384b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f04a3a3d-519a-435e-872d-ba6a6ea03845', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('81cdf7d7-db3b-46f8-850f-770cf31a984b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('30f315c9-ec9a-48f7-bbf2-8c51cc2e43b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ca816106-af10-4e7b-837c-9fba6e3bd90f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4cc269d8-8f57-49fa-815b-8652a8af404e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9d87916e-dacc-4850-8279-557764874bc5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('595fac88-7aa5-45a1-a988-f7cd494abb3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('caed5254-46f3-4da0-b442-d3a6cc6d5ae3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('77cb2526-aea6-4c52-9d50-0274f8e6eb15', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f237b354-7fa0-4a5d-a2be-822930bfd0c9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('551ef603-9b01-4d38-9588-aef279f0d29e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9dd12efe-246f-44f3-83a5-7fdaac0370a5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f5012783-85c0-48be-b087-cbbcf54bb341', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('fbfd02c8-b586-44be-be9f-e1ea4caa6882', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c19c2720-23c5-48c0-bf79-91b0173d3fd8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('57f57b41-ac60-4847-81b4-2e5b07cfcdd3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a07bd979-af00-4063-8550-8d0778568727', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9123d97e-6e27-4a6f-962d-40ed61bff3ee', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e97dc5a0-f02d-4fc8-8f60-67e764d9efa3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d8426300-28b8-45d0-bf60-d517bec6b104', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d6249536-61e6-4fa1-900c-2e3ca2ad3f09', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('62a252dd-264f-4f56-ade0-cdbe1dcf03bc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f3f06a94-500f-41bf-9da8-7134fc9da716', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4737d512-5106-4d44-b98f-f780a666b830', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('dfe4bae6-27b2-48e1-8d7c-7c85076b3fa7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('32bc1a3d-8708-47d6-b8e4-59422819281d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ce838579-01e8-42a5-8859-83b12795f2e5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('91d62062-7ff6-4d1b-ba1c-f8284ef01492', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b97b2283-a822-4ab6-9a8c-aae3c7aa358d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;
INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('04a9ad7d-13f1-4abb-9cb6-1dd4a6fe98ad', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

COMMIT;