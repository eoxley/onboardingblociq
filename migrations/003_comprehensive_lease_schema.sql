-- ============================================================
-- BlocIQ Comprehensive Lease Extraction Schema
-- Migration: 003 - All 28 Index Points
-- ============================================================

-- =====================================
-- LEASE_PARTIES: Lessor, Lessee, Management Company
-- =====================================
CREATE TABLE IF NOT EXISTS lease_parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Party details
  party_type text CHECK (party_type IN ('lessor', 'lessee', 'management_company', 'landlord', 'freeholder', 'head_lessor', 'guarantor')),
  party_name text NOT NULL,
  party_address text,

  -- Multiple parties of same type
  is_joint_party boolean DEFAULT false,
  party_order integer, -- For ordering joint lessees

  -- Company details
  company_number text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_parties_lease ON lease_parties(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_parties_type ON lease_parties(party_type);

-- =====================================
-- LEASE_DEMISE: Detailed demise description
-- =====================================
CREATE TABLE IF NOT EXISTS lease_demise (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Property description
  property_description text, -- Full demise description
  floor_level text, -- "First Floor", "Ground Floor"

  -- Boundaries and inclusions
  includes_external_walls boolean,
  includes_windows boolean,
  includes_balcony boolean,
  includes_roof boolean,
  includes_letterbox boolean,
  includes_parking boolean,

  -- Additional inclusions/exclusions
  inclusions text[], -- Array of included items
  exclusions text[], -- Array of excluded items

  -- Raw clause
  raw_demise_clause text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_demise_lease ON lease_demise(lease_id);

-- =====================================
-- LEASE_RIGHTS: Easements, access rights, rights of way
-- =====================================
CREATE TABLE IF NOT EXISTS lease_rights (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Right classification
  right_type text CHECK (right_type IN ('access', 'right_of_way', 'service_media', 'parking', 'garden_use', 'emergency_access', 'other')),

  -- Right details
  right_description text NOT NULL,
  beneficiary text CHECK (beneficiary IN ('tenant', 'landlord', 'both', 'third_party')),

  -- Specific rights
  hallway_access boolean,
  garden_access boolean,
  parking_rights boolean,
  emergency_entry boolean,

  -- Conditions
  notice_required boolean,
  notice_period_days integer,

  -- Raw clause
  raw_rights_clause text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_rights_lease ON lease_rights(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_rights_type ON lease_rights(right_type);

-- =====================================
-- LEASE_ENFORCEMENT: Forfeiture, breach, landlord remedies
-- =====================================
CREATE TABLE IF NOT EXISTS lease_enforcement (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Enforcement type
  enforcement_type text CHECK (enforcement_type IN ('forfeiture', 'breach_notice', 'landlord_remedy', 're_entry', 'cost_recovery')),

  -- Notice requirements
  notice_period_days integer,
  notice_to_mortgagee_required boolean,
  mortgagee_notice_period_days integer,

  -- Forfeiture conditions
  forfeiture_permitted boolean,
  forfeiture_grounds text[], -- ["rent_arrears", "covenant_breach", "bankruptcy"]

  -- Landlord remedies
  landlord_can_enter_and_repair boolean,
  repair_notice_period_days integer,
  costs_recoverable_as_rent boolean,

  -- Raw clause
  raw_enforcement_clause text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_enforcement_lease ON lease_enforcement(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_enforcement_type ON lease_enforcement(enforcement_type);

-- =====================================
-- LEASE_CLAUSES: Structured clause references for traceability
-- =====================================
CREATE TABLE IF NOT EXISTS lease_clauses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),

  -- Clause identification
  clause_number text NOT NULL, -- e.g., "3(15)", "Schedule 4 Part 2"
  clause_title text, -- e.g., "Pets", "Service Charge"
  clause_category text CHECK (clause_category IN (
    'demise', 'term', 'rent', 'service_charge', 'insurance', 'repair',
    'alterations', 'use', 'assignment', 'subletting', 'forfeiture',
    'rights', 'covenants', 'parking', 'other'
  )),

  -- Clause content
  clause_text text,
  clause_summary text,

  -- References
  referenced_schedule text, -- e.g., "Schedule 3"
  cross_references text[], -- Other clause numbers referenced

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_clauses_lease ON lease_clauses(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_number ON lease_clauses(clause_number);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_category ON lease_clauses(clause_category);

-- =====================================
-- Update existing LEASES table with new fields
-- =====================================
ALTER TABLE leases ADD COLUMN IF NOT EXISTS title_number text;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS plot_number text;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS deed_date date;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS head_lease_reference text;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS is_underlease boolean DEFAULT false;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS property_address text;
ALTER TABLE leases ADD COLUMN IF NOT EXISTS floor_description text;

CREATE INDEX IF NOT EXISTS idx_leases_title_number ON leases(title_number);

-- =====================================
-- Update LEASE_FINANCIAL_TERMS with apportionments
-- =====================================
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS internal_apportionment_percentage numeric(5,4);
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS external_apportionment_percentage numeric(5,4);
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS apportionment_basis text; -- "per schedule", "equal shares", "floor area"
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS service_charge_year_start_month text; -- "January", "April"
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS service_charge_year_start_day integer;
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS payment_notice_days integer; -- Pay within X days of notice
ALTER TABLE lease_financial_terms ADD COLUMN IF NOT EXISTS monthly_instalments_permitted boolean;

-- =====================================
-- Update LEASE_RESTRICTIONS with additional fields
-- =====================================
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS parking_spaces_allocated integer;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS vehicle_roadworthy_requirement boolean;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS vehicle_time_limit_hours integer;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS washing_on_balcony_permitted boolean;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS signage_permitted boolean;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS for_sale_board_permitted boolean;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS music_noise_hours text; -- e.g., "No music after 11pm"
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS rmc_membership_required boolean;
ALTER TABLE lease_restrictions ADD COLUMN IF NOT EXISTS buyer_must_join_rmc boolean;

-- =====================================
-- Comments for documentation
-- =====================================
COMMENT ON TABLE lease_parties IS 'Lessor, lessee, management company details from lease (Index Point 3)';
COMMENT ON TABLE lease_demise IS 'Detailed description of demised premises including boundaries (Index Point 5)';
COMMENT ON TABLE lease_rights IS 'Access rights, easements, rights of way (Index Point 20)';
COMMENT ON TABLE lease_enforcement IS 'Forfeiture clauses, breach remedies, landlord powers (Index Points 15-16)';
COMMENT ON TABLE lease_clauses IS 'Structured clause references for audit traceability (Index Point 25)';

COMMENT ON COLUMN leases.title_number IS 'Land Registry title number (Index Point 2)';
COMMENT ON COLUMN leases.plot_number IS 'Development plot reference (Index Point 1)';
COMMENT ON COLUMN leases.deed_date IS 'Legal execution/deed date (Index Point 27)';
COMMENT ON COLUMN leases.head_lease_reference IS 'Reference to superior lease if underlease (Index Point 26)';

COMMENT ON COLUMN lease_financial_terms.internal_apportionment_percentage IS 'Internal service charge share % (Index Point 21)';
COMMENT ON COLUMN lease_financial_terms.external_apportionment_percentage IS 'External/estate service charge share % (Index Point 21)';
