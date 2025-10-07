-- ============================================================
-- BlocIQ Onboarder - Schema Migration Suggestions
-- Generated: 2025-10-07T09:58:40.621118
-- ============================================================
-- IMPORTANT: Review carefully before executing!
-- This file contains suggestions based on schema introspection.
-- ============================================================


-- Create new table: compliance_assets
CREATE TABLE IF NOT EXISTS compliance_assets (
  inspection_contractor TEXT,
  inspection_date DATE,
  reinspection_date DATE,
  outcome TEXT,
  compliance_status TEXT,
  source_document_id UUID REFERENCES building_documents(id)
);

-- Create new table: insurance_policies
CREATE TABLE IF NOT EXISTS insurance_policies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  insurer TEXT,
  broker TEXT,
  policy_number TEXT,
  cover_type TEXT,
  sum_insured NUMERIC,
  reinstatement_value NUMERIC,
  valuation_date DATE,
  start_date DATE,
  end_date DATE,
  excess_json JSONB,
  endorsements TEXT,
  conditions TEXT,
  claims_json JSONB,
  evidence_url TEXT,
  policy_status TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_insurance_policies_building_id ON insurance_policies(building_id);
CREATE INDEX IF NOT EXISTS idx_insurance_policies_policy_number ON insurance_policies(policy_number);
CREATE INDEX IF NOT EXISTS idx_insurance_policies_dates ON insurance_policies(start_date, end_date);

-- Create new table: contracts
CREATE TABLE IF NOT EXISTS contracts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  contractor_name TEXT,
  service_type TEXT,
  start_date DATE,
  end_date DATE,
  renewal_date DATE,
  frequency TEXT,
  value NUMERIC,
  contract_status TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_contracts_building_id ON contracts(building_id);
CREATE INDEX IF NOT EXISTS idx_contracts_service_type ON contracts(service_type);
CREATE INDEX IF NOT EXISTS idx_contracts_renewal ON contracts(renewal_date);

-- Create new table: utilities
CREATE TABLE IF NOT EXISTS utilities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  supplier TEXT,
  utility_type TEXT,
  account_number TEXT,
  start_date DATE,
  end_date DATE,
  tariff TEXT,
  contract_status TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_utilities_building_id ON utilities(building_id);
CREATE INDEX IF NOT EXISTS idx_utilities_utility_type ON utilities(utility_type);

-- Create new table: meetings
CREATE TABLE IF NOT EXISTS meetings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  meeting_type TEXT,
  meeting_date DATE,
  attendees TEXT,
  key_decisions TEXT,
  minutes_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_meetings_building_id ON meetings(building_id);
CREATE INDEX IF NOT EXISTS idx_meetings_date ON meetings(meeting_date);

-- Create new table: client_money_snapshots
CREATE TABLE IF NOT EXISTS client_money_snapshots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  snapshot_date DATE,
  bank_name TEXT,
  account_identifier TEXT,
  balance NUMERIC,
  uncommitted_funds NUMERIC,
  arrears_total NUMERIC,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_client_money_snapshots_building_id ON client_money_snapshots(building_id);
CREATE INDEX IF NOT EXISTS idx_client_money_snapshots_snapshot_date ON client_money_snapshots(snapshot_date);

-- Create new table: building_documents
CREATE TABLE IF NOT EXISTS building_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  storage_path TEXT,
  category TEXT,
  document_type TEXT,
  ocr_text TEXT,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_documents_building_id ON building_documents(building_id);
CREATE INDEX IF NOT EXISTS idx_building_documents_category ON building_documents(category);
CREATE INDEX IF NOT EXISTS idx_building_documents_doc_type ON building_documents(document_type);