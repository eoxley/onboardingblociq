# Supabase Schema Updates Required

## Overview
This document outlines all the schema changes needed in your Supabase database to support the enhanced property form extraction.

## 1. Update `buildings` Table

Add these columns to the existing `buildings` table:

```sql
-- Basic Info
ALTER TABLE buildings ADD COLUMN number_of_units INTEGER;
ALTER TABLE buildings ADD COLUMN previous_agents TEXT;

-- Accountants
ALTER TABLE buildings ADD COLUMN current_accountants TEXT;
ALTER TABLE buildings ADD COLUMN accountant_contact TEXT;

-- Financial Config
ALTER TABLE buildings ADD COLUMN demand_date_1 DATE;
ALTER TABLE buildings ADD COLUMN demand_date_2 DATE;
ALTER TABLE buildings ADD COLUMN year_end_date DATE;
ALTER TABLE buildings ADD COLUMN management_fee_ex_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN management_fee_inc_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN company_secretary_fee_ex_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN company_secretary_fee_inc_vat NUMERIC;

-- Ground Rent
ALTER TABLE buildings ADD COLUMN ground_rent_applicable BOOLEAN;
ALTER TABLE buildings ADD COLUMN ground_rent_charges TEXT;

-- Insurance
ALTER TABLE buildings ADD COLUMN insurance_broker TEXT;
ALTER TABLE buildings ADD COLUMN insurance_renewal_date DATE;

-- Section 20 Limits
ALTER TABLE buildings ADD COLUMN section_20_limit_inc_vat NUMERIC;
ALTER TABLE buildings ADD COLUMN expenditure_limit NUMERIC;

-- Other
ALTER TABLE buildings ADD COLUMN additional_info TEXT;
```

## 2. Update `compliance_assets` Table

**CRITICAL**: Add `building_id` to link compliance assets directly to buildings:

```sql
ALTER TABLE compliance_assets ADD COLUMN building_id UUID NOT NULL REFERENCES buildings(id);
CREATE INDEX idx_compliance_assets_building_id ON compliance_assets(building_id);
```

**Manual Fix Required**: You'll need to manually link existing `compliance_assets` records to their buildings via SQL:

```sql
-- Example: Link compliance assets to buildings based on building_compliance_assets junction table
UPDATE compliance_assets ca
SET building_id = bca.building_id
FROM building_compliance_assets bca
WHERE ca.id = bca.compliance_asset_id
AND ca.building_id IS NULL;
```

## 3. Update `budgets` Table

Add financial date fields:

```sql
ALTER TABLE budgets ADD COLUMN start_date DATE;
ALTER TABLE budgets ADD COLUMN end_date DATE;
ALTER TABLE budgets ADD COLUMN demand_date_1 DATE;
ALTER TABLE budgets ADD COLUMN demand_date_2 DATE;
ALTER TABLE budgets ADD COLUMN year_end_date DATE;
ALTER TABLE budgets ADD COLUMN budget_type TEXT;
```

## 4. Create New Table: `building_contractors`

```sql
CREATE TABLE building_contractors (
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

CREATE INDEX idx_building_contractors_building_id ON building_contractors(building_id);
CREATE INDEX idx_building_contractors_type ON building_contractors(contractor_type);
```

## 5. Create New Table: `building_utilities`

```sql
CREATE TABLE building_utilities (
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

CREATE INDEX idx_building_utilities_building_id ON building_utilities(building_id);
CREATE INDEX idx_building_utilities_type ON building_utilities(utility_type);
```

## 6. Create New Table: `building_insurance`

```sql
CREATE TABLE building_insurance (
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

CREATE INDEX idx_building_insurance_building_id ON building_insurance(building_id);
CREATE INDEX idx_building_insurance_type ON building_insurance(insurance_type);
```

## 7. Create New Table: `building_legal`

```sql
CREATE TABLE building_legal (
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

CREATE INDEX idx_building_legal_building_id ON building_legal(building_id);
CREATE INDEX idx_building_legal_type ON building_legal(record_type);
CREATE INDEX idx_building_legal_status ON building_legal(status);
```

## 8. Create New Table: `building_statutory_reports`

```sql
CREATE TABLE building_statutory_reports (
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

CREATE INDEX idx_building_statutory_reports_building_id ON building_statutory_reports(building_id);
CREATE INDEX idx_building_statutory_reports_type ON building_statutory_reports(report_type);
CREATE INDEX idx_building_statutory_reports_next_due ON building_statutory_reports(next_due_date);
```

## 9. Create New Table: `building_keys_access`

```sql
CREATE TABLE building_keys_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    access_type TEXT NOT NULL,
    description TEXT,
    code TEXT,  -- Consider encrypting this in production
    location TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_building_keys_access_building_id ON building_keys_access(building_id);
CREATE INDEX idx_building_keys_access_type ON building_keys_access(access_type);
```

## 10. Create New Table: `building_warranties`

```sql
CREATE TABLE building_warranties (
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

CREATE INDEX idx_building_warranties_building_id ON building_warranties(building_id);
CREATE INDEX idx_building_warranties_type ON building_warranties(item_type);
CREATE INDEX idx_building_warranties_expiry ON building_warranties(warranty_expiry);
```

## 11. Create New Table: `company_secretary`

```sql
CREATE TABLE company_secretary (
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

CREATE INDEX idx_company_secretary_building_id ON company_secretary(building_id);
```

## 12. Create New Table: `building_staff`

```sql
CREATE TABLE building_staff (
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

CREATE INDEX idx_building_staff_building_id ON building_staff(building_id);
CREATE INDEX idx_building_staff_type ON building_staff(staff_type);
```

## 13. Create New Table: `building_title_deeds`

```sql
CREATE TABLE building_title_deeds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    record_type TEXT NOT NULL,
    title_number TEXT,
    description TEXT,
    document_id UUID REFERENCES building_documents(id),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_building_title_deeds_building_id ON building_title_deeds(building_id);
CREATE INDEX idx_building_title_deeds_type ON building_title_deeds(record_type);
```

## Implementation Order

1. **First**: Update existing tables (`buildings`, `compliance_assets`, `budgets`)
2. **Second**: Create all new tables
3. **Third**: Run the manual fix for `compliance_assets` to link existing records

## Row Level Security (RLS)

Don't forget to add RLS policies for each new table. Example:

```sql
-- Enable RLS
ALTER TABLE building_contractors ENABLE ROW LEVEL SECURITY;

-- Policy for authenticated users
CREATE POLICY "Users can view contractors for their buildings"
ON building_contractors FOR SELECT
USING (
    building_id IN (
        SELECT id FROM buildings
        WHERE portfolio_id IN (
            SELECT id FROM portfolios WHERE agency_id = auth.uid()
        )
    )
);

-- Repeat similar policies for all new tables
```

## Testing

After running migrations:

1. Verify all columns were added successfully
2. Test that the onboarder can insert data into all new tables
3. Verify foreign key constraints are working
4. Test RLS policies with different user roles

## Notes

- All new tables use cascading deletes (`ON DELETE CASCADE`) so when a building is deleted, all related records are also deleted
- Consider adding CHECK constraints for enum-like fields (e.g., `status` columns)
- The `code` field in `building_keys_access` should be encrypted in production
- You may want to add more specific indexes based on your query patterns
