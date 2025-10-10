DROP TABLE IF EXISTS building_title_deeds CASCADE;
DROP TABLE IF EXISTS building_staff CASCADE;
DROP TABLE IF EXISTS company_secretary CASCADE;
DROP TABLE IF EXISTS building_warranties CASCADE;
DROP TABLE IF EXISTS building_keys_access CASCADE;
DROP TABLE IF EXISTS building_statutory_reports CASCADE;
DROP TABLE IF EXISTS building_legal CASCADE;
DROP TABLE IF EXISTS building_insurance CASCADE;
DROP TABLE IF EXISTS building_utilities CASCADE;
DROP TABLE IF EXISTS building_contractors CASCADE;

ALTER TABLE buildings DROP COLUMN IF EXISTS number_of_units;
ALTER TABLE buildings DROP COLUMN IF EXISTS previous_agents;
ALTER TABLE buildings DROP COLUMN IF EXISTS current_accountants;
ALTER TABLE buildings DROP COLUMN IF EXISTS accountant_contact;
ALTER TABLE buildings DROP COLUMN IF EXISTS demand_date_1;
ALTER TABLE buildings DROP COLUMN IF EXISTS demand_date_2;
ALTER TABLE buildings DROP COLUMN IF EXISTS year_end_date;
ALTER TABLE buildings DROP COLUMN IF EXISTS management_fee_ex_vat;
ALTER TABLE buildings DROP COLUMN IF EXISTS management_fee_inc_vat;
ALTER TABLE buildings DROP COLUMN IF EXISTS company_secretary_fee_ex_vat;
ALTER TABLE buildings DROP COLUMN IF EXISTS company_secretary_fee_inc_vat;
ALTER TABLE buildings DROP COLUMN IF EXISTS ground_rent_applicable;
ALTER TABLE buildings DROP COLUMN IF EXISTS ground_rent_charges;
ALTER TABLE buildings DROP COLUMN IF EXISTS insurance_broker;
ALTER TABLE buildings DROP COLUMN IF EXISTS insurance_renewal_date;
ALTER TABLE buildings DROP COLUMN IF EXISTS section_20_limit_inc_vat;
ALTER TABLE buildings DROP COLUMN IF EXISTS expenditure_limit;
ALTER TABLE buildings DROP COLUMN IF EXISTS additional_info;

ALTER TABLE compliance_assets DROP COLUMN IF EXISTS building_id;

ALTER TABLE budgets DROP COLUMN IF EXISTS start_date;
ALTER TABLE budgets DROP COLUMN IF EXISTS end_date;
ALTER TABLE budgets DROP COLUMN IF EXISTS demand_date_1;
ALTER TABLE budgets DROP COLUMN IF EXISTS demand_date_2;
ALTER TABLE budgets DROP COLUMN IF EXISTS year_end_date;
ALTER TABLE budgets DROP COLUMN IF EXISTS budget_type;
