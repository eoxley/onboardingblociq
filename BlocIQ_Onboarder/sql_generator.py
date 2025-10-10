#!/usr/bin/env python3
"""
BlocIQ SQL Generator - MVP for Block Management
Produces COMPLETE, MINIMAL dataset for property managers to start work
"""

import json
import uuid
from datetime import datetime, date
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass, asdict


@dataclass
class SQLGeneratorOutput:
    """Output from SQL generator"""
    migration_sql: str
    qa_report: str
    summary: Dict


class SQLGenerator:
    """Generate SQL migration from parsed building data"""

    def __init__(self, building_name: str, output_dir: Path):
        self.building_name = building_name
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True, parents=True)

        # Track what we insert
        self.stats = {
            'buildings': 0,
            'units': 0,
            'leaseholders': 0,
            'leases': 0,
            'insurance_policies': 0,
            'compliance_assets': 0,
            'compliance_requirements_status': 0,
            'contractors': 0,
            'contracts': 0,
            'budget_items': 0,
            'documents': 0
        }

        self.warnings = []

    def generate(
        self,
        building_data: Dict,
        parsed_bundle: Optional[Dict] = None
    ) -> SQLGeneratorOutput:
        """
        Generate complete SQL migration

        Args:
            building_data: Building metadata
            parsed_bundle: Optional parsed data from deep parser

        Returns:
            SQLGeneratorOutput with migration, QA report, and summary
        """

        sql_parts = []

        # Header
        sql_parts.append(self._generate_header())

        # Schema (DDL)
        sql_parts.append(self._generate_schema())

        # Views
        sql_parts.append(self._generate_views())

        # Data (DML)
        sql_parts.append(self._generate_data_inserts(building_data, parsed_bundle))

        # Combine SQL
        migration_sql = "\n\n".join(sql_parts)

        # Generate QA report
        qa_report = self._generate_qa_report(building_data)

        # Generate summary JSON
        summary = self._generate_summary(building_data)

        return SQLGeneratorOutput(
            migration_sql=migration_sql,
            qa_report=qa_report,
            summary=summary
        )

    def _generate_header(self) -> str:
        """Generate SQL file header"""
        return f"""-- BlocIQ SQL Generator - {self.building_name}
-- Generated: {datetime.now().isoformat()}
-- Purpose: Complete, minimal dataset for block management

BEGIN;
"""

    def _generate_schema(self) -> str:
        """Generate DDL for all tables"""
        return """
-- ============================================================================
-- SCHEMA (DDL)
-- ============================================================================

-- Buildings
CREATE TABLE IF NOT EXISTS buildings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    full_address TEXT,
    address_line1 TEXT,
    address_line2 TEXT,
    city TEXT,
    postcode TEXT,
    region TEXT,
    total_units INTEGER DEFAULT 0,
    year_built INTEGER,
    managing_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (name, postcode)
);

-- Units
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    unit_ref TEXT NOT NULL,
    level TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, unit_ref)
);

-- Leaseholders
CREATE TABLE IF NOT EXISTS leaseholders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    display_name TEXT NOT NULL,
    email TEXT,
    phone TEXT,
    unit_id UUID REFERENCES units(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, display_name)
);

-- Leases
CREATE TABLE IF NOT EXISTS leases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id),
    unit_ref TEXT,  -- For reconciliation if unit_id is null
    start_date DATE,
    end_date DATE,
    term_years INTEGER,
    ground_rent_text TEXT,
    source_file TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, COALESCE(unit_id::text, unit_ref), COALESCE(start_date, '1900-01-01'))
);

-- Insurance Policies (CERTIFICATES ONLY)
CREATE TABLE IF NOT EXISTS insurance_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    provider TEXT,
    policy_number TEXT,
    policy_type TEXT,
    period_start DATE,
    period_end DATE,
    sum_insured NUMERIC(14,2),
    premium_amount NUMERIC(14,2),
    source_file TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, COALESCE(policy_number, ''), COALESCE(period_start, '1900-01-01'))
);

-- Compliance Assets
CREATE TABLE IF NOT EXISTS compliance_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    category TEXT,
    name TEXT NOT NULL,
    last_inspection DATE,
    next_due DATE,
    status TEXT DEFAULT 'Unknown',
    confidence NUMERIC(3,2) DEFAULT 1.00,
    provenance TEXT,
    has_evidence BOOLEAN DEFAULT FALSE,
    dates_missing BOOLEAN DEFAULT FALSE,
    source_file TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, name, COALESCE(next_due, '9999-12-31'::date))
);

-- Compliance Requirements Status (Required-Only Score)
CREATE TABLE IF NOT EXISTS compliance_requirements_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    requirement_key TEXT NOT NULL,
    evidence_date DATE,
    expiry_date DATE,
    points NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    source_doc_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, requirement_key)
);

-- Contractors
CREATE TABLE IF NOT EXISTS contractors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    service_type TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, name)
);

-- Contracts
CREATE TABLE IF NOT EXISTS contracts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    contractor_id UUID REFERENCES contractors(id),
    description TEXT,
    start_date DATE,
    end_date DATE,
    status TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, description, COALESCE(start_date, '1900-01-01'::date))
);

-- Budget Items (Year Presence Only)
CREATE TABLE IF NOT EXISTS budget_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    service_charge_year TEXT NOT NULL,
    heading TEXT DEFAULT '(Total PDF)',
    schedule TEXT,
    amount NUMERIC(14,2),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, service_charge_year, heading, COALESCE(schedule, ''))
);

-- Documents (Index of what exists)
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    category TEXT NOT NULL,
    filename TEXT NOT NULL,
    path TEXT,
    has_text BOOLEAN DEFAULT FALSE,
    needs_ocr BOOLEAN DEFAULT FALSE,
    indexed_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (building_id, filename)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_units_building ON units(building_id);
CREATE INDEX IF NOT EXISTS idx_leases_building ON leases(building_id);
CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);
CREATE INDEX IF NOT EXISTS idx_insurance_building ON insurance_policies(building_id);
CREATE INDEX IF NOT EXISTS idx_compliance_building ON compliance_assets(building_id);
CREATE INDEX IF NOT EXISTS idx_compliance_req_building ON compliance_requirements_status(building_id);
CREATE INDEX IF NOT EXISTS idx_contractors_building ON contractors(building_id);
CREATE INDEX IF NOT EXISTS idx_documents_building ON documents(building_id);
CREATE INDEX IF NOT EXISTS idx_documents_category ON documents(category);
"""

    def _generate_views(self) -> str:
        """Generate SQL views"""
        return """
-- ============================================================================
-- VIEWS (for PDF/UI simplicity)
-- ============================================================================

-- Insurance Certificates Only
CREATE OR REPLACE VIEW v_insurance_certificates AS
SELECT ip.*
FROM insurance_policies ip
JOIN documents d ON d.building_id = ip.building_id
  AND d.category = 'insurance_certificate'
  AND d.filename = ip.source_file;

-- Compliance Rollup
CREATE OR REPLACE VIEW v_compliance_rollup AS
SELECT
    building_id,
    COUNT(*) as total_assets,
    COUNT(*) FILTER (WHERE status = 'OK') as ok_count,
    COUNT(*) FILTER (WHERE status = 'Overdue') as overdue_count,
    COUNT(*) FILTER (WHERE status = 'Unknown') as unknown_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'OK') / NULLIF(COUNT(*), 0), 1) as ok_pct
FROM compliance_assets
GROUP BY building_id;

-- Lease Coverage
CREATE OR REPLACE VIEW v_lease_coverage AS
SELECT
    b.id as building_id,
    b.total_units,
    COUNT(DISTINCT COALESCE(l.unit_id, l.unit_ref)) as leased_units,
    ROUND(
        100.0 * COUNT(DISTINCT COALESCE(l.unit_id, l.unit_ref)) / NULLIF(b.total_units, 0),
        1
    ) as lease_pct
FROM buildings b
LEFT JOIN leases l ON l.building_id = b.id
GROUP BY b.id, b.total_units;

-- Budget Years Present
CREATE OR REPLACE VIEW v_budget_years AS
SELECT
    building_id,
    service_charge_year,
    COUNT(*) as line_items,
    SUM(amount) as total_amount
FROM budget_items
GROUP BY building_id, service_charge_year
ORDER BY
    building_id,
    SUBSTRING(service_charge_year FROM '\\d{4}')::int DESC;

-- Required Compliance Score
CREATE OR REPLACE VIEW v_required_compliance_score AS
SELECT
    building_id,
    ROUND(100.0 * SUM(points) / NULLIF(COUNT(*), 0), 1) as req_score,
    COUNT(*) as total_requirements,
    SUM(points) as points_earned
FROM compliance_requirements_status
GROUP BY building_id;
"""

    def _generate_data_inserts(
        self,
        building_data: Dict,
        parsed_bundle: Optional[Dict]
    ) -> str:
        """Generate INSERT statements for data"""

        sql_parts = []
        sql_parts.append("-- " + "="*76)
        sql_parts.append("-- DATA (DML)")
        sql_parts.append("-- " + "="*76)

        # Building
        building_sql = self._insert_building(building_data)
        sql_parts.append(building_sql)

        # Units
        if building_data.get('units'):
            units_sql = self._insert_units(building_data['units'])
            sql_parts.append(units_sql)

        # Leaseholders
        if building_data.get('leaseholders'):
            leaseholders_sql = self._insert_leaseholders(building_data['leaseholders'])
            sql_parts.append(leaseholders_sql)

        # Leases
        if building_data.get('leases'):
            leases_sql = self._insert_leases(building_data['leases'])
            sql_parts.append(leases_sql)

        # Insurance (certificates only)
        if building_data.get('insurance_policies'):
            insurance_sql = self._insert_insurance(building_data['insurance_policies'])
            sql_parts.append(insurance_sql)

        # Compliance assets
        if building_data.get('compliance_assets'):
            compliance_sql = self._insert_compliance(building_data['compliance_assets'])
            sql_parts.append(compliance_sql)

        # Contractors
        if building_data.get('building_contractors'):
            contractors_sql = self._insert_contractors(building_data['building_contractors'])
            sql_parts.append(contractors_sql)

        # Budget items
        if building_data.get('budgets'):
            budgets_sql = self._insert_budgets(building_data['budgets'])
            sql_parts.append(budgets_sql)

        # Documents index
        if parsed_bundle and parsed_bundle.get('documents'):
            documents_sql = self._insert_documents(parsed_bundle['documents'])
            sql_parts.append(documents_sql)

        sql_parts.append("\nCOMMIT;")

        return "\n\n".join(sql_parts)

    def _insert_building(self, building_data: Dict) -> str:
        """Generate building INSERT"""
        building = building_data.get('building', {})

        name = building.get('name', self.building_name)
        address = building.get('address', building.get('full_address', ''))
        postcode = building.get('postcode', building.get('post_code', ''))
        total_units = len(building_data.get('units', []))

        self.stats['buildings'] += 1

        return f"""-- Building
INSERT INTO buildings (name, full_address, postcode, total_units)
VALUES (
    {self._sql_str(name)},
    {self._sql_str(address)},
    {self._sql_str(postcode)},
    {total_units}
)
ON CONFLICT (name, postcode) DO UPDATE SET
    full_address = EXCLUDED.full_address,
    total_units = EXCLUDED.total_units,
    updated_at = NOW();"""

    def _insert_units(self, units: List[Dict]) -> str:
        """Generate units INSERTs"""
        if not units:
            return ""

        sql = ["-- Units"]

        for unit in units:
            unit_ref = unit.get('unit_number', unit.get('unit_ref', ''))
            if not unit_ref:
                continue

            self.stats['units'] += 1

            sql.append(f"""INSERT INTO units (building_id, unit_ref)
SELECT id, {self._sql_str(unit_ref)}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, unit_ref) DO NOTHING;""")

        return "\n".join(sql)

    def _insert_leaseholders(self, leaseholders: List[Dict]) -> str:
        """Generate leaseholders INSERTs"""
        if not leaseholders:
            return ""

        sql = ["-- Leaseholders"]

        for lh in leaseholders:
            name = lh.get('name', lh.get('full_name', lh.get('display_name', '')))
            if not name:
                continue

            email = lh.get('email')
            phone = lh.get('phone')

            self.stats['leaseholders'] += 1

            sql.append(f"""INSERT INTO leaseholders (building_id, display_name, email, phone)
SELECT id, {self._sql_str(name)}, {self._sql_str(email)}, {self._sql_str(phone)}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, display_name) DO UPDATE SET
    email = COALESCE(EXCLUDED.email, leaseholders.email),
    phone = COALESCE(EXCLUDED.phone, leaseholders.phone);""")

        return "\n".join(sql)

    def _insert_leases(self, leases: List[Dict]) -> str:
        """Generate leases INSERTs"""
        if not leases:
            return ""

        sql = ["-- Leases"]

        for lease in leases:
            unit_ref = lease.get('unit_number', lease.get('unit_ref', ''))
            start_date = lease.get('start_date', lease.get('term_start'))
            end_date = lease.get('end_date', lease.get('term_end'))
            term_years = lease.get('term_years')
            ground_rent = lease.get('ground_rent_text', lease.get('ground_rent'))
            source_file = lease.get('source_file', '')

            if not unit_ref:
                self.warnings.append(f"Lease without unit_ref: {source_file}")
                continue

            self.stats['leases'] += 1

            # Try to match to unit_id, but allow null
            sql.append(f"""INSERT INTO leases (
    building_id, unit_id, unit_ref, start_date, end_date, term_years, ground_rent_text, source_file
)
SELECT
    b.id,
    u.id,
    {self._sql_str(unit_ref)},
    {self._sql_date(start_date)},
    {self._sql_date(end_date)},
    {term_years if term_years else 'NULL'},
    {self._sql_str(ground_rent)},
    {self._sql_str(source_file)}
FROM buildings b
LEFT JOIN units u ON u.building_id = b.id AND u.unit_ref = {self._sql_str(unit_ref)}
WHERE b.name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, COALESCE(unit_id::text, unit_ref), COALESCE(start_date, '1900-01-01'::date))
DO NOTHING;""")

        return "\n".join(sql)

    def _insert_insurance(self, policies: List[Dict]) -> str:
        """Generate insurance INSERTs (certificates only)"""
        if not policies:
            return ""

        sql = ["-- Insurance Policies (Certificates Only)"]

        for policy in policies:
            provider = policy.get('provider', policy.get('insurer_name', policy.get('broker_name')))
            policy_number = policy.get('policy_number')
            policy_type = policy.get('insurance_type', policy.get('policy_type'))
            period_start = policy.get('period_start', policy.get('renewal_date'))
            period_end = policy.get('period_end', policy.get('expiry_date'))
            source_file = policy.get('source_file', '')

            # Skip if no policy number (likely not a certificate)
            if not policy_number:
                continue

            self.stats['insurance_policies'] += 1

            sql.append(f"""INSERT INTO insurance_policies (
    building_id, provider, policy_number, policy_type, period_start, period_end, source_file
)
SELECT id, {self._sql_str(provider)}, {self._sql_str(policy_number)}, {self._sql_str(policy_type)},
    {self._sql_date(period_start)}, {self._sql_date(period_end)}, {self._sql_str(source_file)}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, COALESCE(policy_number, ''), COALESCE(period_start, '1900-01-01'::date))
DO UPDATE SET
    period_end = EXCLUDED.period_end,
    provider = COALESCE(EXCLUDED.provider, insurance_policies.provider);""")

        return "\n".join(sql)

    def _insert_compliance(self, assets: List[Dict]) -> str:
        """Generate compliance INSERTs"""
        if not assets:
            return ""

        sql = ["-- Compliance Assets"]

        for asset in assets:
            name = asset.get('asset_name', asset.get('name', ''))
            category = asset.get('asset_type', asset.get('category', asset.get('compliance_category')))
            last_inspection = asset.get('last_inspection_date', asset.get('last_inspection'))
            next_due = asset.get('next_due_date', asset.get('next_due'))
            status = asset.get('compliance_status', asset.get('status', 'Unknown'))
            source_file = asset.get('source_file', '')

            if not name:
                continue

            has_evidence = bool(last_inspection or next_due)
            dates_missing = not has_evidence

            self.stats['compliance_assets'] += 1

            sql.append(f"""INSERT INTO compliance_assets (
    building_id, category, name, last_inspection, next_due, status, has_evidence, dates_missing, source_file
)
SELECT id, {self._sql_str(category)}, {self._sql_str(name)}, {self._sql_date(last_inspection)},
    {self._sql_date(next_due)}, {self._sql_str(status)}, {has_evidence}, {dates_missing}, {self._sql_str(source_file)}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, name, COALESCE(next_due, '9999-12-31'::date))
DO UPDATE SET
    last_inspection = COALESCE(EXCLUDED.last_inspection, compliance_assets.last_inspection),
    next_due = COALESCE(EXCLUDED.next_due, compliance_assets.next_due),
    status = EXCLUDED.status;""")

        return "\n".join(sql)

    def _insert_contractors(self, contractors: List[Dict]) -> str:
        """Generate contractors INSERTs"""
        if not contractors:
            return ""

        sql = ["-- Contractors"]

        for contractor in contractors:
            name = contractor.get('company_name', contractor.get('contractor_name', contractor.get('name', '')))
            service_type = contractor.get('service_type', contractor.get('contractor_type'))

            if not name or name == '—':
                continue

            self.stats['contractors'] += 1

            sql.append(f"""INSERT INTO contractors (building_id, name, service_type)
SELECT id, {self._sql_str(name)}, {self._sql_str(service_type)}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, name) DO UPDATE SET
    service_type = COALESCE(EXCLUDED.service_type, contractors.service_type);""")

        return "\n".join(sql)

    def _insert_budgets(self, budgets: List[Dict]) -> str:
        """Generate budget INSERTs (year presence only)"""
        if not budgets:
            return ""

        sql = ["-- Budget Items (Year Presence)"]

        # Group by service charge year
        years = set()
        for budget in budgets:
            year = budget.get('period', budget.get('year', budget.get('service_charge_year')))
            if year:
                years.add(year)

        for year in sorted(years, reverse=True):
            self.stats['budget_items'] += 1

            sql.append(f"""INSERT INTO budget_items (building_id, service_charge_year, heading, amount)
SELECT id, {self._sql_str(year)}, '(Total PDF)', NULL
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, service_charge_year, heading, COALESCE(schedule, ''))
DO NOTHING;""")

        return "\n".join(sql)

    def _insert_documents(self, documents: List[Dict]) -> str:
        """Generate documents INSERTs"""
        if not documents:
            return ""

        sql = ["-- Documents Index"]

        for doc in documents:
            filename = doc.get('filename', '')
            category = doc.get('category', 'other')
            path = doc.get('path', '')
            has_text = doc.get('has_text', False)
            needs_ocr = doc.get('needs_ocr', False)

            if not filename:
                continue

            self.stats['documents'] += 1

            sql.append(f"""INSERT INTO documents (building_id, category, filename, path, has_text, needs_ocr)
SELECT id, {self._sql_str(category)}, {self._sql_str(filename)}, {self._sql_str(path)}, {has_text}, {needs_ocr}
FROM buildings WHERE name = {self._sql_str(self.building_name)}
ON CONFLICT (building_id, filename) DO UPDATE SET
    category = EXCLUDED.category,
    needs_ocr = EXCLUDED.needs_ocr;""")

        return "\n".join(sql)

    def _generate_qa_report(self, building_data: Dict) -> str:
        """Generate QA markdown report"""

        report = [
            f"# Building Import QA Report - {self.building_name}",
            f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            "",
            "---",
            "",
            "## Table Counts",
            ""
        ]

        for table, count in self.stats.items():
            if count > 0:
                report.append(f"- **{table}:** {count} rows")

        # Critical fields
        report.extend([
            "",
            "## Missing Critical Fields",
            ""
        ])

        leases_no_unit = len([
            l for l in building_data.get('leases', [])
            if not l.get('unit_id')
        ])
        if leases_no_unit > 0:
            report.append(f"⚠️  **{leases_no_unit} leases** without matched unit_id")

        compliance_no_dates = len([
            c for c in building_data.get('compliance_assets', [])
            if not c.get('last_inspection_date') and not c.get('next_due_date')
        ])
        if compliance_no_dates > 0:
            report.append(f"⚠️  **{compliance_no_dates} compliance assets** missing dates")

        # Warnings
        if self.warnings:
            report.extend([
                "",
                "## Warnings",
                ""
            ])
            for warning in self.warnings:
                report.append(f"- {warning}")

        return "\n".join(report)

    def _generate_summary(self, building_data: Dict) -> Dict:
        """Generate JSON summary"""

        return {
            'building_name': self.building_name,
            'generated_at': datetime.now().isoformat(),
            'stats': self.stats,
            'derived': {
                'total_units': len(building_data.get('units', [])),
                'leased_units': len(building_data.get('leases', [])),
                'lease_coverage_pct': round(
                    len(building_data.get('leases', [])) / max(len(building_data.get('units', [])), 1) * 100,
                    1
                ),
                'compliance_ok': len([
                    c for c in building_data.get('compliance_assets', [])
                    if c.get('compliance_status') == 'OK'
                ]),
                'compliance_total': len(building_data.get('compliance_assets', [])),
                'budget_years': list(set(
                    b.get('period', b.get('year', ''))
                    for b in building_data.get('budgets', [])
                    if b.get('period') or b.get('year')
                ))
            },
            'warnings': self.warnings
        }

    def _sql_str(self, value: Optional[str]) -> str:
        """Convert to SQL string literal"""
        if value is None or value == '':
            return 'NULL'
        # Escape single quotes
        escaped = str(value).replace("'", "''")
        return f"'{escaped}'"

    def _sql_date(self, value) -> str:
        """Convert to SQL date literal"""
        if value is None:
            return 'NULL'
        if isinstance(value, str):
            return f"'{value}'::date"
        if isinstance(value, date):
            return f"'{value.isoformat()}'::date"
        return 'NULL'

    def save(self, output: SQLGeneratorOutput):
        """Save output files"""

        # Save migration SQL
        sql_file = self.output_dir / f"{self.building_name.replace(' ', '_').lower()}_migration.sql"
        sql_file.write_text(output.migration_sql)
        print(f"✅ SQL Migration: {sql_file}")

        # Save QA report
        qa_file = self.output_dir / f"{self.building_name.replace(' ', '_')}_Import_QA.md"
        qa_file.write_text(output.qa_report)
        print(f"✅ QA Report: {qa_file}")

        # Save JSON summary
        json_file = self.output_dir / f"{self.building_name.replace(' ', '_').lower()}_seed_summary.json"
        json_file.write_text(json.dumps(output.summary, indent=2))
        print(f"✅ JSON Summary: {json_file}")
