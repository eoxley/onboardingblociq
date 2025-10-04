"""
BlocIQ Onboarder - SQL Writer
Generates Supabase-ready SQL migration scripts with exact schema compliance
"""

from typing import Dict, List, Any
import json
from schema_mapper import SupabaseSchemaMapper


class SQLWriter:
    """Generates SQL INSERT statements for Supabase with exact schema compliance"""

    def __init__(self):
        self.sql_statements = []
        self.schema_mapper = SupabaseSchemaMapper()
        self.portfolio_id = None  # Will be generated per migration

    def generate_migration(self, mapped_data: Dict) -> str:
        """
        Generate complete SQL migration script

        Args:
            mapped_data: Dictionary containing mapped data for all tables

        Returns:
            SQL migration script as string
        """
        import uuid

        self.sql_statements = []
        # Generate unique portfolio ID for this migration
        self.portfolio_id = str(uuid.uuid4())

        # Header (includes agency placeholder)
        self._add_header()

        # Generate INSERTs in dependency order
        if 'building' in mapped_data:
            self._generate_building_insert(mapped_data['building'])

        if 'units' in mapped_data:
            self._generate_units_inserts(mapped_data['units'])

        if 'leaseholders' in mapped_data:
            self._generate_leaseholders_inserts(mapped_data['leaseholders'])

        # BlocIQ V2: Compliance assets (must be before building_compliance_assets)
        if 'compliance_assets' in mapped_data:
            self._generate_compliance_assets_inserts(mapped_data['compliance_assets'])

        # BlocIQ V2: Major works projects (must be before notices)
        if 'major_works_projects' in mapped_data:
            self._generate_major_works_inserts(mapped_data['major_works_projects'])

        # BlocIQ V2: Budgets (must be before documents)
        if 'budgets' in mapped_data:
            self._generate_budgets_inserts(mapped_data['budgets'])

        # BlocIQ V2: Building documents (includes all original files with category)
        if 'building_documents' in mapped_data:
            self._generate_documents_inserts(mapped_data['building_documents'])

        # BlocIQ V2: Building compliance assets (links building to compliance + document)
        if 'building_compliance_assets' in mapped_data:
            self._generate_building_compliance_assets_inserts(mapped_data['building_compliance_assets'])

        # BlocIQ V2: Major works notices (links project to document)
        if 'major_works_notices' in mapped_data:
            self._generate_major_works_notices_inserts(mapped_data['major_works_notices'])

        # BlocIQ V2: Apportionments (links units to budgets)
        if 'apportionments' in mapped_data:
            self._generate_apportionments_inserts(mapped_data['apportionments'])

        # BlocIQ V2: Uncategorised documents (for manual review)
        if 'uncategorised_docs' in mapped_data:
            self._generate_uncategorised_docs_inserts(mapped_data['uncategorised_docs'])

        # Compliance inspections (legacy)
        if 'compliance_inspections' in mapped_data:
            self._generate_compliance_inspections_inserts(mapped_data['compliance_inspections'])

        # Property form structured data tables
        if 'building_contractors' in mapped_data:
            self._generate_building_contractors_inserts(mapped_data['building_contractors'])

        if 'building_utilities' in mapped_data:
            self._generate_building_utilities_inserts(mapped_data['building_utilities'])

        if 'building_insurance' in mapped_data:
            self._generate_building_insurance_inserts(mapped_data['building_insurance'])

        if 'building_legal' in mapped_data:
            self._generate_building_legal_inserts(mapped_data['building_legal'])

        if 'building_statutory_reports' in mapped_data:
            self._generate_building_statutory_reports_inserts(mapped_data['building_statutory_reports'])

        if 'building_keys_access' in mapped_data:
            self._generate_building_keys_access_inserts(mapped_data['building_keys_access'])

        if 'building_warranties' in mapped_data:
            self._generate_building_warranties_inserts(mapped_data['building_warranties'])

        if 'company_secretary' in mapped_data and mapped_data['company_secretary']:
            self._generate_company_secretary_insert(mapped_data['company_secretary'])

        if 'building_staff' in mapped_data:
            self._generate_building_staff_inserts(mapped_data['building_staff'])

        if 'building_title_deeds' in mapped_data:
            self._generate_building_title_deeds_inserts(mapped_data['building_title_deeds'])

        # Footer
        self._add_footer()

        return '\n'.join(self.sql_statements)

    def _add_header(self):
        """Add migration header with agency placeholder block"""
        self.sql_statements.extend([
            "-- BlocIQ Onboarder - Auto-generated Migration",
            f"-- Generated at: {self._now()}",
            "-- Review this script before executing!",
            "",
            "-- =====================================",
            "-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID",
            "-- =====================================",
            "",
            "-- Example: INSERT INTO agencies (id, name) VALUES ('AGENCY_ID_PLACEHOLDER', 'My Agency')",
            "-- ON CONFLICT (id) DO NOTHING;",
            "",
            "INSERT INTO portfolios (id, agency_id, name)",
            f"VALUES ('{self.portfolio_id}', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')",
            "ON CONFLICT (id) DO NOTHING;",
            "",
            "BEGIN;",
            ""
        ])

    def _add_footer(self):
        """Add migration footer"""
        self.sql_statements.extend([
            "",
            "-- Migration complete",
            "COMMIT;",
            "",
            "-- Rollback command (if needed):",
            "-- ROLLBACK;"
        ])

    def _generate_building_insert(self, building: Dict):
        """Generate INSERT for buildings table with portfolio_id"""
        # Add portfolio_id to building data
        building_with_portfolio = building.copy()
        building_with_portfolio['portfolio_id'] = self.portfolio_id

        self.sql_statements.append("-- Insert building")
        self.sql_statements.append(
            self._create_insert_statement('buildings', building_with_portfolio, use_upsert=False)
        )
        self.sql_statements.append("")

    def _generate_units_inserts(self, units: List[Dict]):
        """Generate INSERTs for units table"""
        if not units:
            return

        self.sql_statements.append(f"-- Insert {len(units)} units")

        for unit in units:
            self.sql_statements.append(
                self._create_insert_statement('units', unit, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_leaseholders_inserts(self, leaseholders: List[Dict]):
        """Generate INSERTs for leaseholders table"""
        if not leaseholders:
            return

        self.sql_statements.append(f"-- Insert {len(leaseholders)} leaseholders")

        for leaseholder in leaseholders:
            self.sql_statements.append(
                self._create_insert_statement('leaseholders', leaseholder, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_documents_inserts(self, documents: List[Dict]):
        """Generate INSERTs for building_documents table"""
        if not documents:
            return

        self.sql_statements.append(f"-- Insert {len(documents)} document records")

        for doc in documents:
            self.sql_statements.append(
                self._create_insert_statement('building_documents', doc, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_compliance_assets_inserts(self, assets: List[Dict]):
        """Generate INSERTs for compliance_assets table"""
        if not assets:
            return

        self.sql_statements.append(f"-- Insert {len(assets)} compliance assets")

        # DEBUG: Check first asset
        if assets:
            print(f"\n🔍 DEBUG: First compliance_asset before SQL generation:")
            print(f"  Keys: {list(assets[0].keys())}")
            print(f"  building_id present: {'building_id' in assets[0]}")
            print(f"  building_id value: {assets[0].get('building_id')}")
            print()

        for asset in assets:
            self.sql_statements.append(
                self._create_insert_statement('compliance_assets', asset, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_compliance_inspections_inserts(self, inspections: List[Dict]):
        """Generate INSERTs for compliance_inspections table"""
        if not inspections:
            return

        self.sql_statements.append(f"-- Insert {len(inspections)} compliance inspections")

        for inspection in inspections:
            self.sql_statements.append(
                self._create_insert_statement('compliance_inspections', inspection, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_major_works_inserts(self, projects: List[Dict]):
        """Generate INSERTs for major_works_projects table"""
        if not projects:
            return

        self.sql_statements.append(f"-- Insert {len(projects)} major works projects")

        for project in projects:
            self.sql_statements.append(
                self._create_insert_statement('major_works_projects', project, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_budgets_inserts(self, budgets: List[Dict]):
        """Generate INSERTs for budgets table"""
        if not budgets:
            return

        self.sql_statements.append(f"-- Insert {len(budgets)} budgets")

        for budget in budgets:
            self.sql_statements.append(
                self._create_insert_statement('budgets', budget, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_apportionments_inserts(self, apportionments: List[Dict]):
        """Generate INSERTs for apportionments table"""
        if not apportionments:
            return

        self.sql_statements.append(f"-- Insert {len(apportionments)} apportionments")

        for apportionment in apportionments:
            self.sql_statements.append(
                self._create_insert_statement('apportionments', apportionment, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_compliance_assets_inserts(self, assets: List[Dict]):
        """Generate INSERTs for building_compliance_assets table"""
        if not assets:
            return

        self.sql_statements.append(f"-- Insert {len(assets)} building compliance asset links")

        for asset in assets:
            self.sql_statements.append(
                self._create_insert_statement('building_compliance_assets', asset, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_major_works_notices_inserts(self, notices: List[Dict]):
        """Generate INSERTs for major_works_notices table"""
        if not notices:
            return

        self.sql_statements.append(f"-- Insert {len(notices)} major works notices")

        for notice in notices:
            self.sql_statements.append(
                self._create_insert_statement('major_works_notices', notice, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_uncategorised_docs_inserts(self, docs: List[Dict]):
        """Generate INSERTs for uncategorised_docs table - BlocIQ V2"""
        if not docs:
            return

        self.sql_statements.append(f"-- Insert {len(docs)} uncategorised documents for manual review")

        for doc in docs:
            self.sql_statements.append(
                self._create_insert_statement('uncategorised_docs', doc, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_contractors_inserts(self, contractors: List[Dict]):
        """Generate INSERTs for building_contractors table"""
        if not contractors:
            return

        self.sql_statements.append(f"-- Insert {len(contractors)} building contractors")

        for contractor in contractors:
            self.sql_statements.append(
                self._create_insert_statement('building_contractors', contractor, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_utilities_inserts(self, utilities: List[Dict]):
        """Generate INSERTs for building_utilities table"""
        if not utilities:
            return

        self.sql_statements.append(f"-- Insert {len(utilities)} building utilities")

        for utility in utilities:
            self.sql_statements.append(
                self._create_insert_statement('building_utilities', utility, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_insurance_inserts(self, insurance_records: List[Dict]):
        """Generate INSERTs for building_insurance table"""
        if not insurance_records:
            return

        self.sql_statements.append(f"-- Insert {len(insurance_records)} insurance records")

        for record in insurance_records:
            self.sql_statements.append(
                self._create_insert_statement('building_insurance', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_legal_inserts(self, legal_records: List[Dict]):
        """Generate INSERTs for building_legal table"""
        if not legal_records:
            return

        self.sql_statements.append(f"-- Insert {len(legal_records)} legal records")

        for record in legal_records:
            self.sql_statements.append(
                self._create_insert_statement('building_legal', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_statutory_reports_inserts(self, reports: List[Dict]):
        """Generate INSERTs for building_statutory_reports table"""
        if not reports:
            return

        self.sql_statements.append(f"-- Insert {len(reports)} statutory reports")

        for report in reports:
            self.sql_statements.append(
                self._create_insert_statement('building_statutory_reports', report, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_keys_access_inserts(self, access_records: List[Dict]):
        """Generate INSERTs for building_keys_access table"""
        if not access_records:
            return

        self.sql_statements.append(f"-- Insert {len(access_records)} keys/access records")

        for record in access_records:
            self.sql_statements.append(
                self._create_insert_statement('building_keys_access', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_warranties_inserts(self, warranties: List[Dict]):
        """Generate INSERTs for building_warranties table"""
        if not warranties:
            return

        self.sql_statements.append(f"-- Insert {len(warranties)} warranties")

        for warranty in warranties:
            self.sql_statements.append(
                self._create_insert_statement('building_warranties', warranty, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_company_secretary_insert(self, company_secretary: Dict):
        """Generate INSERT for company_secretary table"""
        if not company_secretary:
            return

        self.sql_statements.append("-- Insert company secretary data")
        self.sql_statements.append(
            self._create_insert_statement('company_secretary', company_secretary, use_upsert=False)
        )
        self.sql_statements.append("")

    def _generate_building_staff_inserts(self, staff_records: List[Dict]):
        """Generate INSERTs for building_staff table"""
        if not staff_records:
            return

        self.sql_statements.append(f"-- Insert {len(staff_records)} staff records")

        for record in staff_records:
            self.sql_statements.append(
                self._create_insert_statement('building_staff', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_title_deeds_inserts(self, title_deeds: List[Dict]):
        """Generate INSERTs for building_title_deeds table"""
        if not title_deeds:
            return

        self.sql_statements.append(f"-- Insert {len(title_deeds)} title deed records")

        for record in title_deeds:
            self.sql_statements.append(
                self._create_insert_statement('building_title_deeds', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _create_insert_statement(self, table: str, data: Dict, use_upsert: bool = True) -> str:
        """
        Create an INSERT or UPSERT statement with schema validation

        Args:
            table: Table name
            data: Dictionary of column: value pairs
            use_upsert: If True, generate UPSERT (INSERT ... ON CONFLICT DO UPDATE)

        Returns:
            SQL INSERT/UPSERT statement
        """
        # Validate data against schema
        validated_data = self.schema_mapper.validate_data(table, data)

        # DEBUG: Print for compliance_assets
        if table == 'compliance_assets':
            print(f"DEBUG compliance_assets:")
            print(f"  Original data: {data}")
            print(f"  Validated data: {validated_data}")

        # Define required NOT NULL columns per table
        required_columns = {
            'buildings': ['id', 'name'],
            'units': ['id', 'building_id', 'unit_number'],
            'leaseholders': ['id', 'unit_id', 'name'],
            'building_documents': ['id', 'building_id', 'category', 'file_name', 'storage_path'],
            'compliance_assets': ['id', 'building_id', 'name', 'category'],
            'budgets': ['id', 'building_id', 'period'],
            'major_works_projects': ['id', 'building_id', 'project_name']
        }

        # Filter out None values, but keep required columns even if None (will error early)
        table_required = required_columns.get(table, [])
        filtered_data = {
            k: v for k, v in validated_data.items()
            if v is not None or k in table_required
        }

        if table == 'compliance_assets':
            print(f"  Filtered data: {filtered_data}")
            print()

        if not filtered_data:
            return f"-- Skipped empty insert for {table}"

        columns = ', '.join(filtered_data.keys())
        values = ', '.join(self._format_value(v) for v in filtered_data.values())

        # Basic INSERT statement
        insert_sql = f"INSERT INTO {table} ({columns}) VALUES ({values})"

        # Add UPSERT clause if requested and we have a unique constraint
        if use_upsert and table == 'building_documents':
            # For documents, use id for idempotency (content_hash not yet in schema)
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'created_at']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        elif use_upsert and table == 'buildings':
            # For buildings, update on ID conflict (re-running onboarding)
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'created_at', 'agency_id']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        elif use_upsert and table == 'units':
            # For units, update on building_id + unit_number
            # Requires: CREATE UNIQUE INDEX ON units(building_id, unit_number);
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'building_id', 'unit_number', 'created_at']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (building_id, unit_number) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (building_id, unit_number) DO NOTHING"

        elif use_upsert and table == 'compliance_assets':
            # For compliance assets, update on building_id + compliance_asset_id
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'building_id', 'created_at']]
            if update_cols:
                # Update next_due_date to earliest date
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols if col != 'next_due_date')
                if 'next_due_date' in update_cols:
                    updates += ", next_due_date = LEAST(COALESCE(compliance_assets.next_due_date, '9999-12-31'), COALESCE(EXCLUDED.next_due_date, '9999-12-31'))"
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        insert_sql += ";"
        return insert_sql

    def _format_value(self, value: Any) -> str:
        """Format a value for SQL with proper type handling"""
        if value is None:
            return 'NULL'

        if isinstance(value, bool):
            return 'TRUE' if value else 'FALSE'

        if isinstance(value, (int, float)):
            return str(value)

        if isinstance(value, str):
            # Handle UUID strings - don't quote them
            if self._is_uuid_string(value):
                return f"'{value}'"
            
            # Handle timestamps - ensure proper format
            if self._is_timestamp_string(value):
                return f"'{value}'"
            
            # Escape single quotes for regular strings
            escaped = value.replace("'", "''")
            return f"'{escaped}'"

        # JSON for complex types
        return f"'{json.dumps(value)}'"
    
    def _is_uuid_string(self, value: str) -> bool:
        """Check if string is a valid UUID format"""
        import re
        uuid_pattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        return bool(re.match(uuid_pattern, value, re.IGNORECASE))
    
    def _is_timestamp_string(self, value: str) -> bool:
        """Check if string is a timestamp format"""
        import re
        timestamp_pattern = r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'
        return bool(re.match(timestamp_pattern, value))

    def _now(self) -> str:
        """Get current timestamp"""
        from datetime import datetime
        return datetime.now().isoformat()


def generate_document_log_csv(documents: List[Dict]) -> str:
    """
    Generate CSV log of all documents

    Args:
        documents: List of document metadata dictionaries

    Returns:
        CSV string
    """
    if not documents:
        return "file_name,category,confidence,file_size,file_path,notes\n"

    # CSV header
    csv_lines = ["file_name,category,confidence,file_size,file_path,notes"]

    # CSV rows
    for doc in documents:
        row = [
            _csv_escape(doc.get('file_name', '')),
            _csv_escape(doc.get('category', '')),
            str(doc.get('confidence', 0.0)),
            str(doc.get('file_size', 0)),
            _csv_escape(doc.get('file_path', '')),
            _csv_escape(doc.get('notes', ''))
        ]
        csv_lines.append(','.join(row))

    return '\n'.join(csv_lines)


def _csv_escape(value: str) -> str:
    """Escape value for CSV"""
    if not value:
        return ''

    # Quote if contains comma, quote, or newline
    if ',' in value or '"' in value or '\n' in value:
        return f'"{value.replace(chr(34), chr(34)+chr(34))}"'

    return value
