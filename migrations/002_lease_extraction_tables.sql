-- ============================================================
-- BlocIQ Lease Extraction & Document Storage Tables
-- Migration: 002
-- ============================================================

-- =====================================
-- DOCUMENT_TEXTS: Store all OCR results for reuse
-- =====================================
CREATE TABLE IF NOT EXISTS document_texts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  document_name text NOT NULL,
  document_path text,
  document_type text CHECK (document_type IN ('lease', 'head_lease', 'assignment', 'transfer', 'safety_report', 'fire_risk_assessment', 'other')),
  extracted_text text,
  character_count integer,
  ocr_method text CHECK (ocr_method IN ('tesseract', 'google_vision', 'native_pdf')),
  extraction_date timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_document_texts_building ON document_texts(building_id);
CREATE INDEX IF NOT EXISTS idx_document_texts_type ON document_texts(document_type);

-- =====================================
-- LEASE_FINANCIAL_TERMS: Financial obligations from leases
-- =====================================
CREATE TABLE IF NOT EXISTS lease_financial_terms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Ground rent
  ground_rent numeric(10,2),
  ground_rent_frequency text CHECK (ground_rent_frequency IN ('annual', 'semi_annual', 'quarterly', 'monthly')),
  ground_rent_due_dates jsonb, -- e.g., ["25 March", "29 September"]

  -- Service charge
  service_charge_year_start date,
  service_charge_year_end date,
  service_charge_frequency text CHECK (service_charge_frequency IN ('annual', 'quarterly', 'monthly')),
  service_charge_advance boolean DEFAULT true,

  -- Reserve fund
  reserve_fund_provided boolean,
  reserve_fund_percentage numeric(5,2),

  -- Interest on arrears
  interest_rate_type text, -- e.g., "4% above base rate"
  interest_rate_value numeric(5,2),

  -- Rent review
  rent_review_frequency_years integer,
  rent_review_basis text, -- e.g., "RPI-linked", "Open market", "Fixed increase"

  -- Raw text extracts
  raw_ground_rent_clause text,
  raw_service_charge_clause text,
  raw_review_clause text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_financial_terms_lease ON lease_financial_terms(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_financial_terms_building ON lease_financial_terms(building_id);

-- =====================================
-- LEASE_INSURANCE_TERMS: Insurance obligations
-- =====================================
CREATE TABLE IF NOT EXISTS lease_insurance_terms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Who insures
  landlord_insures boolean DEFAULT false,
  tenant_insures boolean DEFAULT false,
  shared_insurance boolean DEFAULT false,

  -- Coverage details
  coverage_types text[], -- e.g., ["fire", "flood", "public_liability"]
  tenant_contribution_method text, -- e.g., "via service charge", "direct payment"

  -- Excess
  excess_amount numeric(10,2),
  excess_currency text DEFAULT 'GBP',

  -- Additional requirements
  tenants_contents_insurance_required boolean,
  minimum_public_liability_cover numeric(12,2),

  -- Raw text
  raw_insurance_clause text,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_insurance_terms_lease ON lease_insurance_terms(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_insurance_terms_building ON lease_insurance_terms(building_id);

-- =====================================
-- LEASE_COVENANTS: Tenant obligations and landlord covenants
-- =====================================
CREATE TABLE IF NOT EXISTS lease_covenants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Covenant classification
  covenant_type text CHECK (covenant_type IN ('repair', 'alterations', 'use', 'nuisance', 'insurance', 'decoration', 'access', 'other')),
  obligated_party text CHECK (obligated_party IN ('tenant', 'landlord', 'both')),

  -- Covenant details
  covenant_summary text NOT NULL,
  covenant_full_text text,

  -- Specific flags for common covenants
  is_repairing_covenant boolean DEFAULT false,
  is_alteration_restriction boolean DEFAULT false,
  is_use_restriction boolean DEFAULT false,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_covenants_lease ON lease_covenants(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_covenants_type ON lease_covenants(covenant_type);
CREATE INDEX IF NOT EXISTS idx_lease_covenants_building ON lease_covenants(building_id);

-- =====================================
-- LEASE_RESTRICTIONS: Specific prohibitions and permissions
-- =====================================
CREATE TABLE IF NOT EXISTS lease_restrictions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),

  -- Restriction type
  restriction_category text CHECK (restriction_category IN ('pets', 'subletting', 'assignment', 'short_lets', 'business_use', 'alterations', 'parking', 'other')),

  -- Restriction details
  restriction_text text NOT NULL,
  is_absolute_prohibition boolean DEFAULT false,
  consent_required boolean DEFAULT false,
  consent_conditions text,

  -- Specific common restrictions
  pets_permitted boolean,
  subletting_permitted boolean,
  assignment_permitted boolean,
  assignment_consent_required boolean,
  short_lets_permitted boolean,
  business_use_permitted boolean,

  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lease_restrictions_lease ON lease_restrictions(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_restrictions_category ON lease_restrictions(restriction_category);
CREATE INDEX IF NOT EXISTS idx_lease_restrictions_building ON lease_restrictions(building_id);

-- =====================================
-- BUILDING_SAFETY_REPORTS: Fire safety and compliance documents
-- =====================================
CREATE TABLE IF NOT EXISTS building_safety_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),

  -- Report identification
  report_type text CHECK (report_type IN ('fire_risk_assessment', 'fire_safety_case', 'building_safety_certificate', 'gateway_3', 'eicr', 'gas_safety', 'other')),
  report_date date,
  completion_date date,
  next_review_date date,

  -- Responsible parties
  responsible_person text,
  principal_accountable_person text,
  assessor_name text,
  assessor_company text,

  -- Fire strategy details
  fire_strategy_date date,
  fire_strategy_compliant boolean,

  -- BSC details
  bsc_reference text,
  bsc_status text CHECK (bsc_status IN ('applied', 'granted', 'conditional', 'refused', 'not_applicable')),

  -- Action items (stored as JSONB array)
  action_items jsonb, -- [{"action": "Install fire doors", "priority": "high", "due_date": "2025-12-01", "status": "open"}]

  -- Overall status
  overall_risk_rating text CHECK (overall_risk_rating IN ('trivial', 'tolerable', 'moderate', 'substantial', 'intolerable')),
  compliance_status text CHECK (compliance_status IN ('compliant', 'minor_issues', 'major_issues', 'non_compliant', 'unknown')),

  -- Document reference
  document_id uuid REFERENCES document_texts(id),
  source_document_name text,

  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_safety_reports_building ON building_safety_reports(building_id);
CREATE INDEX IF NOT EXISTS idx_building_safety_reports_type ON building_safety_reports(report_type);
CREATE INDEX IF NOT EXISTS idx_building_safety_reports_status ON building_safety_reports(compliance_status);
CREATE INDEX IF NOT EXISTS idx_building_safety_reports_next_review ON building_safety_reports(next_review_date);

-- =====================================
-- Comments
-- =====================================
COMMENT ON TABLE document_texts IS 'Stores OCR extracted text from all documents for reuse and analysis';
COMMENT ON TABLE lease_financial_terms IS 'Financial obligations and terms extracted from lease documents';
COMMENT ON TABLE lease_insurance_terms IS 'Insurance requirements and responsibilities from lease documents';
COMMENT ON TABLE lease_covenants IS 'Tenant and landlord covenants extracted from leases';
COMMENT ON TABLE lease_restrictions IS 'Specific restrictions and permissions from lease documents';
COMMENT ON TABLE building_safety_reports IS 'Fire safety, BSC, and compliance reports for buildings';
