#!/usr/bin/env python3
"""
Schema Validation Tool
Validates that generated SQL matches Supabase schema requirements
"""

import re
from typing import Dict, List, Set
from schema_mapper import SupabaseSchemaMapper


class SchemaValidator:
    """Validates mapped data against Supabase schema"""

    def __init__(self):
        self.mapper = SupabaseSchemaMapper()
        self.validation_results = []
        self.errors = []
        self.warnings = []

    def validate_complete_migration(self, mapped_data: Dict) -> Dict:
        """
        Validate all mapped data before SQL generation

        Returns:
            Dict with validation results
        """
        print("🔍 Validating Schema Compliance\n")
        print("=" * 60)

        # Validate each table
        if 'building' in mapped_data:
            self._validate_building(mapped_data['building'])

        if 'units' in mapped_data:
            self._validate_units(mapped_data['units'])

        if 'leaseholders' in mapped_data:
            self._validate_leaseholders(mapped_data['leaseholders'])

        if 'building_documents' in mapped_data:
            self._validate_documents(mapped_data['building_documents'])

        if 'compliance_assets' in mapped_data:
            self._validate_compliance_assets(mapped_data['compliance_assets'])

        if 'compliance_inspections' in mapped_data:
            self._validate_compliance_inspections(mapped_data['compliance_inspections'])

        if 'major_works_projects' in mapped_data:
            self._validate_major_works(mapped_data['major_works_projects'])

        if 'budgets' in mapped_data:
            self._validate_budgets(mapped_data['budgets'])

        if 'service_charge_years' in mapped_data:
            self._validate_service_charge_years(mapped_data['service_charge_years'])

        # Check foreign key relationships
        self._validate_foreign_keys(mapped_data)

        # Print summary
        self._print_validation_summary()

        return {
            'valid': len(self.errors) == 0,
            'errors': self.errors,
            'warnings': self.warnings,
            'results': self.validation_results
        }

    def _validate_building(self, building: Dict):
        """Validate building record"""
        print("\n📋 Validating buildings table...")

        validated = self.mapper.validate_data('buildings', building)
        required_fields = ['id', 'name', 'address']

        for field in required_fields:
            if field not in validated or not validated[field]:
                self.errors.append(f"buildings: Missing required field '{field}'")
            else:
                self.validation_results.append(f"✅ buildings.{field}: {validated[field]}")

        # Check UUID format
        if 'id' in validated:
            if not self._is_valid_uuid(validated['id']):
                self.errors.append(f"buildings: Invalid UUID format for 'id'")

        print(f"  Found {len([k for k, v in validated.items() if v is not None])} populated fields")

    def _validate_units(self, units: List[Dict]):
        """Validate units records"""
        print(f"\n📋 Validating units table ({len(units)} records)...")

        if not units:
            self.warnings.append("units: No units found")
            return

        for idx, unit in enumerate(units):
            validated = self.mapper.validate_data('units', unit)
            required_fields = ['id', 'building_id', 'unit_number']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"units[{idx}]: Missing required field '{field}'")

            # Check UUIDs
            for uuid_field in ['id', 'building_id']:
                if uuid_field in validated and validated[uuid_field]:
                    if not self._is_valid_uuid(validated[uuid_field]):
                        self.errors.append(f"units[{idx}]: Invalid UUID for '{uuid_field}'")

        print(f"  Validated {len(units)} unit records")

    def _validate_leaseholders(self, leaseholders: List[Dict]):
        """Validate leaseholders records"""
        print(f"\n📋 Validating leaseholders table ({len(leaseholders)} records)...")

        if not leaseholders:
            self.warnings.append("leaseholders: No leaseholders found")
            return

        for idx, leaseholder in enumerate(leaseholders):
            validated = self.mapper.validate_data('leaseholders', leaseholder)
            required_fields = ['id', 'unit_id']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"leaseholders[{idx}]: Missing required field '{field}'")

            # Validate email if present
            if 'email' in validated and validated['email']:
                if not self._is_valid_email(validated['email']):
                    self.warnings.append(f"leaseholders[{idx}]: Invalid email format")

        print(f"  Validated {len(leaseholders)} leaseholder records")

    def _validate_documents(self, documents: List[Dict]):
        """Validate building_documents records"""
        print(f"\n📋 Validating building_documents table ({len(documents)} records)...")

        if not documents:
            self.warnings.append("building_documents: No documents found")
            return

        for idx, doc in enumerate(documents):
            validated = self.mapper.validate_data('building_documents', doc)
            required_fields = ['id', 'building_id', 'file_name', 'category']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"building_documents[{idx}]: Missing required field '{field}'")

        print(f"  Validated {len(documents)} document records")

    def _validate_compliance_assets(self, assets: List[Dict]):
        """Validate compliance_assets records"""
        print(f"\n📋 Validating compliance_assets table ({len(assets)} records)...")

        if not assets:
            self.warnings.append("compliance_assets: No assets found")
            return

        asset_types_found = set()

        for idx, asset in enumerate(assets):
            validated = self.mapper.validate_data('compliance_assets', asset)
            required_fields = ['id', 'building_id', 'asset_name', 'asset_type', 'inspection_frequency']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"compliance_assets[{idx}]: Missing required field '{field}'")

            # Track asset types
            if 'asset_type' in validated and validated['asset_type']:
                asset_types_found.add(validated['asset_type'])

        print(f"  Validated {len(assets)} compliance asset records")
        print(f"  Asset types found: {', '.join(sorted(asset_types_found))}")

    def _validate_compliance_inspections(self, inspections: List[Dict]):
        """Validate compliance_inspections records"""
        print(f"\n📋 Validating compliance_inspections table ({len(inspections)} records)...")

        if not inspections:
            self.warnings.append("compliance_inspections: No inspections found")
            return

        for idx, inspection in enumerate(inspections):
            validated = self.mapper.validate_data('compliance_inspections', inspection)
            required_fields = ['id', 'asset_id', 'inspection_date']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"compliance_inspections[{idx}]: Missing required field '{field}'")

            # Check for findings/actions
            if 'findings' in validated and validated['findings']:
                self.validation_results.append(f"✅ Inspection {idx}: Has findings extracted")

            if 'actions_required' in validated and validated['actions_required']:
                self.validation_results.append(f"✅ Inspection {idx}: Has actions required")

        print(f"  Validated {len(inspections)} inspection records")

    def _validate_major_works(self, projects: List[Dict]):
        """Validate major_works_projects records"""
        print(f"\n📋 Validating major_works_projects table ({len(projects)} records)...")

        if not projects:
            self.warnings.append("major_works_projects: No projects found")
            return

        project_types = set()

        for idx, project in enumerate(projects):
            validated = self.mapper.validate_data('major_works_projects', project)
            required_fields = ['id', 'building_id', 'project_name', 'project_type']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"major_works_projects[{idx}]: Missing required field '{field}'")

            if 'project_type' in validated and validated['project_type']:
                project_types.add(validated['project_type'])

        print(f"  Validated {len(projects)} major works projects")
        print(f"  Project types: {', '.join(sorted(project_types))}")

    def _validate_budgets(self, budgets: List[Dict]):
        """Validate budgets records"""
        print(f"\n📋 Validating budgets table ({len(budgets)} records)...")

        if not budgets:
            self.warnings.append("budgets: No budgets found")
            return

        for idx, budget in enumerate(budgets):
            validated = self.mapper.validate_data('budgets', budget)
            required_fields = ['id', 'building_id', 'financial_year']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"budgets[{idx}]: Missing required field '{field}'")

        print(f"  Validated {len(budgets)} budget records")

    def _validate_service_charge_years(self, accounts: List[Dict]):
        """Validate service_charge_years records"""
        print(f"\n📋 Validating service_charge_years table ({len(accounts)} records)...")

        if not accounts:
            self.warnings.append("service_charge_years: No accounts found")
            return

        for idx, account in enumerate(accounts):
            validated = self.mapper.validate_data('service_charge_years', account)
            required_fields = ['id', 'building_id', 'financial_year']

            for field in required_fields:
                if field not in validated or not validated[field]:
                    self.errors.append(f"service_charge_years[{idx}]: Missing required field '{field}'")

        print(f"  Validated {len(accounts)} service charge account records")

    def _validate_foreign_keys(self, mapped_data: Dict):
        """Validate foreign key relationships"""
        print("\n📋 Validating foreign key relationships...")

        building_id = mapped_data.get('building', {}).get('id')

        if not building_id:
            self.errors.append("Foreign keys: No building_id found")
            return

        # Check all records reference valid building_id
        for table in ['units', 'leaseholders', 'building_documents', 'compliance_assets', 'major_works_projects', 'budgets', 'service_charge_years']:
            if table in mapped_data:
                records = mapped_data[table] if isinstance(mapped_data[table], list) else [mapped_data[table]]
                for record in records:
                    if 'building_id' in record and record['building_id'] != building_id:
                        self.errors.append(f"{table}: building_id mismatch")

        # Check compliance_inspections reference valid asset_ids
        if 'compliance_inspections' in mapped_data and 'compliance_assets' in mapped_data:
            asset_ids = {asset['id'] for asset in mapped_data['compliance_assets']}
            for inspection in mapped_data['compliance_inspections']:
                if 'asset_id' in inspection and inspection['asset_id'] not in asset_ids:
                    self.errors.append(f"compliance_inspections: Invalid asset_id reference")

        # Check leaseholders reference valid unit_ids
        if 'leaseholders' in mapped_data and 'units' in mapped_data:
            unit_ids = {unit['id'] for unit in mapped_data['units']}
            for leaseholder in mapped_data['leaseholders']:
                if 'unit_id' in leaseholder and leaseholder['unit_id'] not in unit_ids:
                    self.errors.append(f"leaseholders: Invalid unit_id reference")

        print(f"  ✅ Foreign key relationships validated")

    def _print_validation_summary(self):
        """Print validation summary"""
        print("\n" + "=" * 60)
        print("VALIDATION SUMMARY")
        print("=" * 60)

        if self.errors:
            print(f"\n❌ ERRORS ({len(self.errors)}):")
            for error in self.errors:
                print(f"  - {error}")

        if self.warnings:
            print(f"\n⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"  - {warning}")

        if not self.errors:
            print("\n✅ ALL VALIDATIONS PASSED")
            print("\n📝 Next steps:")
            print("  1. Review generated migration.sql")
            print("  2. Test SQL in Supabase SQL Editor")
            print("  3. Verify data appears correctly in frontend")
        else:
            print("\n❌ VALIDATION FAILED - Fix errors before proceeding")

        print()

    def _is_valid_uuid(self, value: str) -> bool:
        """Check if value is valid UUID"""
        uuid_pattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        return bool(re.match(uuid_pattern, str(value), re.IGNORECASE))

    def _is_valid_email(self, email: str) -> bool:
        """Check if email format is valid"""
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(email_pattern, email))


if __name__ == '__main__':
    print("Schema Validator - Use this in onboarder.py before SQL generation")
