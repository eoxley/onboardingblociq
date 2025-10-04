ALTER TABLE buildings ADD COLUMN IF NOT EXISTS number_of_units INTEGER;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS previous_agents TEXT;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS current_accountants TEXT;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS accountant_contact TEXT;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS demand_date_1 DATE;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS demand_date_2 DATE;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS year_end_date DATE;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS management_fee_ex_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS management_fee_inc_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS company_secretary_fee_ex_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS company_secretary_fee_inc_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS ground_rent_applicable BOOLEAN;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS ground_rent_charges TEXT;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS insurance_broker TEXT;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS insurance_renewal_date DATE;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS section_20_limit_inc_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS expenditure_limit NUMERIC;
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS additional_info TEXT;

ALTER TABLE compliance_assets DROP COLUMN IF EXISTS building_id;
ALTER TABLE compliance_assets ADD COLUMN building_id UUID REFERENCES buildings(id);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_building_id ON compliance_assets(building_id);

UPDATE compliance_assets ca
SET building_id = bca.building_id
FROM building_compliance_assets bca
WHERE ca.id = bca.compliance_asset_id
AND ca.building_id IS NULL;

DELETE FROM compliance_assets WHERE building_id IS NULL;

ALTER TABLE compliance_assets ALTER COLUMN building_id SET NOT NULL;

ALTER TABLE budgets ADD COLUMN IF NOT EXISTS start_date DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS end_date DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS demand_date_1 DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS demand_date_2 DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS year_end_date DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS budget_type TEXT;

CREATE TABLE IF NOT EXISTS building_contractors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    contractor_type TEXT NOT NULL,
    company_name TEXT,
    contact_person TEXT,
    phone TEXT,
    email TEXT,
    contract_start DATE,
    contract_end DATE,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_contractors_building_id ON building_contractors(building_id);
CREATE INDEX IF NOT EXISTS idx_building_contractors_type ON building_contractors(contractor_type);

CREATE TABLE IF NOT EXISTS building_utilities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    utility_type TEXT NOT NULL,
    provider_name TEXT,
    account_number TEXT,
    meter_numbers TEXT,
    contact_phone TEXT,
    location TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_utilities_building_id ON building_utilities(building_id);
CREATE INDEX IF NOT EXISTS idx_building_utilities_type ON building_utilities(utility_type);

CREATE TABLE IF NOT EXISTS building_insurance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    insurance_type TEXT NOT NULL,
    broker_name TEXT,
    insurer_name TEXT,
    policy_number TEXT,
    renewal_date DATE,
    coverage_amount NUMERIC,
    premium_amount NUMERIC,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_insurance_building_id ON building_insurance(building_id);
CREATE INDEX IF NOT EXISTS idx_building_insurance_type ON building_insurance(insurance_type);

CREATE TABLE IF NOT EXISTS building_legal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL,
    description TEXT,
    party_name TEXT,
    solicitor_name TEXT,
    solicitor_contact TEXT,
    status TEXT,
    date_opened DATE,
    date_closed DATE,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_legal_building_id ON building_legal(building_id);
CREATE INDEX IF NOT EXISTS idx_building_legal_type ON building_legal(record_type);
CREATE INDEX IF NOT EXISTS idx_building_legal_status ON building_legal(status);

CREATE TABLE IF NOT EXISTS building_statutory_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    report_type TEXT NOT NULL,
    document_id UUID REFERENCES building_documents(id),
    report_date DATE,
    next_due_date DATE,
    status TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_statutory_reports_building_id ON building_statutory_reports(building_id);
CREATE INDEX IF NOT EXISTS idx_building_statutory_reports_type ON building_statutory_reports(report_type);
CREATE INDEX IF NOT EXISTS idx_building_statutory_reports_next_due ON building_statutory_reports(next_due_date);

CREATE TABLE IF NOT EXISTS building_keys_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    access_type TEXT NOT NULL,
    description TEXT,
    code TEXT,
    location TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_building_id ON building_keys_access(building_id);
CREATE INDEX IF NOT EXISTS idx_building_keys_access_type ON building_keys_access(access_type);

CREATE TABLE IF NOT EXISTS building_warranties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    item_type TEXT NOT NULL,
    supplier TEXT,
    installation_date DATE,
    warranty_expiry DATE,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_warranties_building_id ON building_warranties(building_id);
CREATE INDEX IF NOT EXISTS idx_building_warranties_type ON building_warranties(item_type);
CREATE INDEX IF NOT EXISTS idx_building_warranties_expiry ON building_warranties(warranty_expiry);

CREATE TABLE IF NOT EXISTS company_secretary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    company_house_filing_code TEXT,
    memorandum_articles TEXT,
    stock_transfer_forms BOOLEAN,
    certificate_of_incorporation BOOLEAN,
    seal_available BOOLEAN,
    audited_accounts_years INTEGER,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_company_secretary_building_id ON company_secretary(building_id);

CREATE TABLE IF NOT EXISTS building_staff (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    staff_type TEXT,
    description TEXT,
    employee_name TEXT,
    position TEXT,
    start_date DATE,
    end_date DATE,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_staff_building_id ON building_staff(building_id);
CREATE INDEX IF NOT EXISTS idx_building_staff_type ON building_staff(staff_type);

CREATE TABLE IF NOT EXISTS building_title_deeds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL,
    title_number TEXT,
    description TEXT,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_building_title_deeds_building_id ON building_title_deeds(building_id);
CREATE INDEX IF NOT EXISTS idx_building_title_deeds_type ON building_title_deeds(record_type);
