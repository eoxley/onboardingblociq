-- BlocIQ SQL Generator Output
-- Generated: 2025-10-14T11:48:33.628987
-- Source: /handover/KGS
-- Tables affected: buildings, units, leases, compliance_assets, budgets, building_data_snapshots

BEGIN;

INSERT INTO buildings (name, address, postcode, year_built, num_floors, num_units, construction_type, has_lifts, num_lifts, fire_strategy, bsa_status, bsa_registration_number)
VALUES ('50 Kensington Gardens Square', '50 Kensington Gardens Square, London', 'W2 4BA', 1880, 6, 8, 'Victorian conversion', TRUE, 2, 'Stay Put', 'Registered', 'BSA-KGS-12345')
ON CONFLICT (name, address) DO UPDATE SET
  postcode = EXCLUDED.postcode,
  year_built = EXCLUDED.year_built,
  num_floors = EXCLUDED.num_floors,
  num_units = EXCLUDED.num_units,
  construction_type = EXCLUDED.construction_type,
  has_lifts = EXCLUDED.has_lifts,
  num_lifts = EXCLUDED.num_lifts,
  fire_strategy = EXCLUDED.fire_strategy,
  bsa_status = EXCLUDED.bsa_status,
  bsa_registration_number = EXCLUDED.bsa_registration_number;

INSERT INTO units (unit_number, floor_number, bedrooms, tenure_type, leaseholder_name, correspondence_address, is_resident_owner, apportionment_percentage)
VALUES ('Flat 4', 2, 2, 'Leasehold', 'John Smith', '42 High Street, Oxford OX1 1AB', FALSE, 12.45)
ON CONFLICT (building_id, unit_number) DO UPDATE SET
  floor_number = EXCLUDED.floor_number,
  bedrooms = EXCLUDED.bedrooms,
  tenure_type = EXCLUDED.tenure_type,
  leaseholder_name = EXCLUDED.leaseholder_name,
  correspondence_address = EXCLUDED.correspondence_address,
  is_resident_owner = EXCLUDED.is_resident_owner,
  apportionment_percentage = EXCLUDED.apportionment_percentage;

INSERT INTO leases (lease_date, term_years, start_date, end_date, ground_rent_amount, ground_rent_review_basis, service_charge_basis, title_number, landlord_name)
VALUES ('1996-03-25', 125, '1996-03-25', '2121-03-24', 250.0, 'Doubles every 25 years', 'Percentage', 'NGL123456', 'Connaught Estates Ltd')
ON CONFLICT (unit_id, start_date) DO UPDATE SET
  lease_date = EXCLUDED.lease_date,
  term_years = EXCLUDED.term_years,
  end_date = EXCLUDED.end_date,
  ground_rent_amount = EXCLUDED.ground_rent_amount,
  ground_rent_review_basis = EXCLUDED.ground_rent_review_basis,
  service_charge_basis = EXCLUDED.service_charge_basis,
  title_number = EXCLUDED.title_number,
  landlord_name = EXCLUDED.landlord_name;

INSERT INTO compliance_assets (inspection_date, next_due_date, status, risk_rating, assessor)
VALUES ('2022-06-22', '2027-06-22', 'current', 'Low', 'TriFire Safety Ltd')
ON CONFLICT (building_id, asset_type, inspection_date) DO UPDATE SET
  next_due_date = EXCLUDED.next_due_date,
  status = EXCLUDED.status,
  risk_rating = EXCLUDED.risk_rating,
  assessor = EXCLUDED.assessor;

INSERT INTO budgets (financial_year, budget_total, reserve_fund, schedule_letter)
VALUES ('2024/2025', 125000.0, 25000.0, 'A')
ON CONFLICT (building_id, financial_year) DO UPDATE SET
  budget_total = EXCLUDED.budget_total,
  reserve_fund = EXCLUDED.reserve_fund,
  schedule_letter = EXCLUDED.schedule_letter;

INSERT INTO building_data_snapshots (id, building_id, extracted_at, source_folder, raw_sql_json)
VALUES (
  'c71f9557-2115-4982-8c23-fc736daca724',
  '1f0a2596-c801-4a33-8459-793b8e37bbf0',
  '2025-10-14T11:48:33.628918',
  '/handover/KGS',
  '{"unknown_field_1": "Additional notes about the property", "custom_metadata": {"heating_system": "Central heating", "parking_spaces": 2, "garden_access": true}, "extraction_confidence": 0.92, "source_document": "Building_Summary_Complete.pdf"}'::jsonb
);

COMMIT;
