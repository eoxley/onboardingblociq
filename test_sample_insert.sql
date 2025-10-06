-- Sample INSERT Test for BlocIQ V2 Migration
-- This tests a small subset of the migration to verify SQL syntax

-- Test agency UUID (replace with real one)
DO $$
DECLARE
  test_agency_id uuid := '00000000-0000-0000-0000-000000000001';
  test_portfolio_id uuid := gen_random_uuid();
  test_building_id uuid := gen_random_uuid();
BEGIN

  -- Test 1: Insert portfolio
  INSERT INTO portfolios (id, agency_id, name)
  VALUES (test_portfolio_id, test_agency_id, 'Test Portfolio - Connaught Square')
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Portfolio insert syntax valid';

  -- Test 2: Insert building
  INSERT INTO buildings (id, portfolio_id, name, address, postcode, building_type, year_built, number_of_units, total_floor_area)
  VALUES (
    test_building_id,
    test_portfolio_id,
    'Connaught Square Test',
    '32-34 Connaught Square',
    'W2 2HL',
    'Residential',
    NULL,
    8,
    NULL
  )
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Building insert syntax valid';

  -- Test 3: Insert compliance asset with category field
  INSERT INTO compliance_assets (
    id,
    building_id,
    category,
    asset_name,
    asset_type,
    inspection_frequency,
    description,
    last_inspection_date,
    next_due_date,
    compliance_status
  ) VALUES (
    gen_random_uuid(),
    test_building_id,
    'compliance',
    'Fire Door Inspection Test',
    'fire_safety',
    '12 months',
    'Test compliance record',
    '2024-01-24',
    '2025-01-24',
    'overdue'
  )
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Compliance asset insert syntax valid (with category field)';

  -- Test 4: Insert unit
  INSERT INTO units (id, building_id, unit_number, floor_number, unit_type, bedrooms, square_footage)
  VALUES (
    gen_random_uuid(),
    test_building_id,
    'Flat 1',
    NULL,
    'Flat',
    NULL,
    NULL
  )
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Unit insert syntax valid';

  -- Test 5: Insert leaseholder
  INSERT INTO leaseholders (id, building_id, unit_number, first_name, last_name, email, phone, move_in_date)
  VALUES (
    gen_random_uuid(),
    test_building_id,
    'Flat 1',
    'Test',
    'Leaseholder',
    'test@example.com',
    NULL,
    NULL
  )
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Leaseholder insert syntax valid';

  -- Test 6: Insert document
  INSERT INTO building_documents (id, building_id, category, file_name, file_path, file_type, uploaded_at)
  VALUES (
    gen_random_uuid(),
    test_building_id,
    'insurance',
    'Test Insurance Certificate.pdf',
    '/test/path/cert.pdf',
    'pdf',
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  RAISE NOTICE '✓ Document insert syntax valid';

  -- Cleanup test data
  DELETE FROM building_documents WHERE building_id = test_building_id;
  DELETE FROM leaseholders WHERE building_id = test_building_id;
  DELETE FROM units WHERE building_id = test_building_id;
  DELETE FROM compliance_assets WHERE building_id = test_building_id;
  DELETE FROM buildings WHERE id = test_building_id;
  DELETE FROM portfolios WHERE id = test_portfolio_id;

  RAISE NOTICE '✓ Test data cleaned up';
  RAISE NOTICE '';
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ ALL SQL SYNTAX TESTS PASSED';
  RAISE NOTICE '========================================';

END $$;
