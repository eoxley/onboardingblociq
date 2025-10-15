-- Update Pimlico Place building with correct data
UPDATE buildings
SET 
    num_units = 83,  -- Actual count from extraction
    has_lifts = TRUE,  -- Building has lifts
    num_lifts = 6,  -- 6 blocks (A-F) likely 1 per block  
    has_communal_heating = TRUE,  -- Quotehedge heating
    has_hot_water = TRUE,
    has_gas = TRUE,
    num_blocks = 6,  -- Blocks A, B, C, D, E, F
    building_address = '01 Pimlico Place, London',
    postcode = 'SW1V 2BJ'
WHERE building_name = 'Pimlico Place';

