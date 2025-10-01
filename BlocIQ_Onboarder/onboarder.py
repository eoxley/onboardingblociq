#!/usr/bin/env python3
"""
BlocIQ Onboarder - Main Entry Point
CLI tool for onboarding client data into Supabase

Usage:
    python onboarder.py /path/to/client/folder
    python onboarder.py /path/to/client/folder --building-name "Client Name"
"""

import os
import sys
import shutil
import json
import argparse
from pathlib import Path
from datetime import datetime
from typing import List, Dict

from parsers import parse_file
from classifier import DocumentClassifier
from mapper import SupabaseMapper
from sql_writer import SQLWriter, generate_document_log_csv
from compliance_extractor import ComplianceAssetExtractor
from major_works_extractor import MajorWorksExtractor
from financial_extractor import FinancialExtractor
from validate_schema import SchemaValidator


class BlocIQOnboarder:
    """Main onboarding orchestrator"""

    def __init__(self, client_folder: str, building_name: str = None, output_dir: str = None):
        self.client_folder = Path(client_folder)
        self.building_name = building_name

        # Use user's home directory for output if running as packaged app
        if output_dir:
            self.output_dir = Path(output_dir)
        else:
            # Default to current directory, or home directory if not writable
            try:
                test_dir = Path('output')
                test_dir.mkdir(exist_ok=True)
                self.output_dir = test_dir
            except (PermissionError, OSError):
                # Fallback to user's home directory
                self.output_dir = Path.home() / 'BlocIQ_Output'

        # Initialize components
        self.classifier = DocumentClassifier()
        self.mapper = SupabaseMapper()
        self.sql_writer = SQLWriter()
        self.compliance_extractor = ComplianceAssetExtractor()
        self.major_works_extractor = MajorWorksExtractor()
        self.financial_extractor = FinancialExtractor()
        self.validator = SchemaValidator()

        # Results storage
        self.parsed_files = []
        self.categorized_files = {}
        self.mapped_data = {}
        self.audit_log = []

    def run(self):
        """Execute the onboarding process"""
        print("🏢 BlocIQ Onboarder")
        print(f"📁 Client Folder: {self.client_folder}")
        print()

        # Step 1: Setup
        self._setup_output_directories()

        # Step 2: Parse all files
        print("📄 Parsing files...")
        self._parse_all_files()

        # Step 3: Classify files
        print("\n🏷️  Classifying documents...")
        self._classify_files()

        # Step 4: Map to Supabase schema
        print("\n🗺️  Mapping to Supabase schema...")
        self._map_to_schema()

        # Step 4.5: Extract compliance assets and major works
        print("\n🔍 Extracting compliance assets...")
        self._extract_compliance_data()

        print("\n🏗️  Extracting major works projects...")
        self._extract_major_works()

        print("\n💰 Extracting financial data...")
        self._extract_financial_data()

        # Step 5: Generate SQL
        print("\n📝 Generating SQL migration...")
        self._generate_sql()

        # Step 6: Generate logs
        print("\n📊 Generating audit logs...")
        self._generate_logs()

        # Summary
        self._print_summary()

    def _setup_output_directories(self):
        """Create output directories"""
        self.output_dir.mkdir(exist_ok=True)

    def _parse_all_files(self):
        """Parse all supported files in client folder"""
        supported_extensions = {'.xlsx', '.xls', '.pdf', '.docx', '.doc', '.csv'}

        file_count = 0
        for file_path in self.client_folder.rglob('*'):
            if file_path.is_file() and file_path.suffix.lower() in supported_extensions:
                # Skip system files
                if file_path.name.startswith('.') or '__MACOSX' in str(file_path):
                    continue

                print(f"  Parsing: {file_path.name}")

                parsed = parse_file(str(file_path))
                self.parsed_files.append(parsed)

                self.audit_log.append({
                    'timestamp': datetime.now().isoformat(),
                    'action': 'parse',
                    'file': file_path.name,
                    'success': parsed.get('parsed', False),
                    'error': parsed.get('error')
                })

                file_count += 1

        print(f"\n  ✅ Parsed {file_count} files")

    def _classify_files(self):
        """Classify all parsed files"""
        self.categorized_files = self.classifier.classify_folder(self.parsed_files)

        # Print classification summary
        for category, files in self.categorized_files.items():
            if files:
                print(f"  {category}: {len(files)} files")
                for f in files:
                    confidence = f.get('confidence', 0)
                    print(f"    - {f['file_name']} (confidence: {confidence:.2f})")

                self.audit_log.append({
                    'timestamp': datetime.now().isoformat(),
                    'action': 'classify',
                    'category': category,
                    'file_count': len(files)
                })

    def _map_to_schema(self):
        """Map classified files to Supabase schema"""
        # Find property form and leaseholder list
        property_form = self._find_file_by_category('units_leaseholders', keywords=['property', 'form', 'setup'])
        leaseholder_list = self._find_file_by_category('units_leaseholders', keywords=['leaseholder', 'list'])

        if not leaseholder_list:
            print("  ⚠️  No leaseholder list found - using first units_leaseholders file")
            if self.categorized_files['units_leaseholders']:
                leaseholder_list = self.categorized_files['units_leaseholders'][0]

        # Map building
        building = self.mapper.map_building(
            property_form if property_form else {},
            leaseholder_list if leaseholder_list else {}
        )

        # Override building name if provided
        if self.building_name:
            building['name'] = self.building_name

        self.mapped_data['building'] = building
        building_id = building['id']

        print(f"  Building: {building.get('name', 'Unknown')}")

        # Map units
        if leaseholder_list:
            units = self.mapper.map_units(leaseholder_list, building_id)
            self.mapped_data['units'] = units
            print(f"  Units: {len(units)}")

            # Create unit_id map for leaseholder mapping
            unit_map = {unit['unit_number']: unit['id'] for unit in units}

            # Map leaseholders
            leaseholders = self.mapper.map_leaseholders(leaseholder_list, unit_map)
            self.mapped_data['leaseholders'] = leaseholders
            print(f"  Leaseholders: {len(leaseholders)}")

            # Create unit-leaseholder links
            links = []
            for leaseholder in leaseholders:
                for unit in units:
                    if unit['id'] == leaseholder['unit_id']:
                        links.append({
                            'unit_id': unit['id'],
                            'leaseholder_id': leaseholder['id']
                        })
            self.mapped_data['unit_leaseholder_links'] = links

        # Map building documents
        documents = []
        for category, files in self.categorized_files.items():
            for file_data in files:
                doc = self.mapper.map_building_documents(file_data, building_id, category)
                documents.append(doc)

        self.mapped_data['building_documents'] = documents
        print(f"  Documents: {len(documents)}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'map',
            'tables': ['buildings', 'units', 'leaseholders', 'building_documents'],
            'record_counts': {
                'buildings': 1,
                'units': len(self.mapped_data.get('units', [])),
                'leaseholders': len(self.mapped_data.get('leaseholders', [])),
                'building_documents': len(documents)
            }
        })

    def _generate_sql(self):
        """Generate SQL migration script"""
        # Validate schema before generating SQL
        print("\n🔍 Validating data against Supabase schema...")
        validation_result = self.validator.validate_complete_migration(self.mapped_data)

        # Save validation report
        validation_file = self.output_dir / 'validation_report.json'
        with open(validation_file, 'w') as f:
            json.dump(validation_result, f, indent=2)

        print(f"\n  ✅ Validation report: {validation_file}")

        # Only generate SQL if validation passed
        if not validation_result['valid']:
            print("\n  ⚠️  Validation errors found - review validation_report.json")
            print("  SQL generation will continue, but review errors before executing")

        # Generate SQL
        sql_script = self.sql_writer.generate_migration(self.mapped_data)

        # Write to file
        sql_file = self.output_dir / 'migration.sql'
        with open(sql_file, 'w') as f:
            f.write(sql_script)

        print(f"\n  ✅ SQL migration: {sql_file}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'generate_sql',
            'file': str(sql_file),
            'lines': len(sql_script.split('\n')),
            'validation_passed': validation_result['valid']
        })

    # Backup functionality removed - files will be uploaded directly to Supabase

    def _generate_logs(self):
        """Generate audit logs and document log CSV"""
        # Audit log (JSON)
        audit_file = self.output_dir / 'audit_log.json'
        with open(audit_file, 'w') as f:
            json.dump(self.audit_log, f, indent=2)

        print(f"  ✅ Audit log: {audit_file}")

        # Document log (CSV)
        documents = self.mapped_data.get('building_documents', [])
        csv_content = generate_document_log_csv(documents)

        csv_file = self.output_dir / 'document_log.csv'
        with open(csv_file, 'w') as f:
            f.write(csv_content)

        print(f"  ✅ Document log: {csv_file}")

        # Summary JSON
        summary = {
            'timestamp': datetime.now().isoformat(),
            'client_folder': str(self.client_folder),
            'building_name': self.mapped_data.get('building', {}).get('name'),
            'statistics': {
                'files_parsed': len(self.parsed_files),
                'buildings': 1,
                'units': len(self.mapped_data.get('units', [])),
                'leaseholders': len(self.mapped_data.get('leaseholders', [])),
                'documents': len(documents)
            },
            'categories': {
                category: len(files)
                for category, files in self.categorized_files.items()
                if files
            }
        }

        summary_file = self.output_dir / 'summary.json'
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)

        print(f"  ✅ Summary: {summary_file}")

    def _extract_compliance_data(self):
        """Extract compliance assets and inspections from parsed files"""
        building_id = self.mapped_data.get('building', {}).get('id')
        if not building_id:
            print("  ⚠️  No building ID found - skipping compliance extraction")
            return

        # Extract compliance data
        assets, inspections = self.compliance_extractor.detect_compliance_assets(
            self.parsed_files,
            building_id
        )

        self.mapped_data['compliance_assets'] = assets
        self.mapped_data['compliance_inspections'] = inspections

        print(f"  ✅ Found {len(assets)} compliance assets")
        print(f"  ✅ Found {len(inspections)} inspection records")

        # Log compliance asset types
        if assets:
            asset_types = {}
            for asset in assets:
                asset_type = asset.get('asset_name', 'Unknown')
                asset_types[asset_type] = asset_types.get(asset_type, 0) + 1

            print("\n  📋 Compliance Assets Detected:")
            for asset_type, count in sorted(asset_types.items()):
                print(f"     - {asset_type}: {count}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_compliance',
            'assets_found': len(assets),
            'inspections_found': len(inspections)
        })

    def _extract_major_works(self):
        """Extract major works projects from parsed files"""
        building_id = self.mapped_data.get('building', {}).get('id')
        if not building_id:
            print("  ⚠️  No building ID found - skipping major works extraction")
            return

        # Extract major works
        projects = self.major_works_extractor.detect_major_works(
            self.parsed_files,
            building_id
        )

        self.mapped_data['major_works_projects'] = projects

        print(f"  ✅ Found {len(projects)} major works projects")

        # Log project types
        if projects:
            project_types = {}
            for project in projects:
                proj_type = project.get('project_type', 'Unknown')
                project_types[proj_type] = project_types.get(proj_type, 0) + 1

            print("\n  📋 Major Works Projects Detected:")
            for proj_type, count in sorted(project_types.items()):
                print(f"     - {proj_type.replace('_', ' ').title()}: {count}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_major_works',
            'projects_found': len(projects)
        })

    def _extract_financial_data(self):
        """Extract budgets and service charge accounts from parsed files"""
        building_id = self.mapped_data.get('building', {}).get('id')
        building_name = self.mapped_data.get('building', {}).get('name')

        if not building_id:
            print("  ⚠️  No building ID found - skipping financial extraction")
            return

        # Extract financial data
        financial_data = self.financial_extractor.extract_financial_data(
            self.parsed_files,
            building_id,
            building_name
        )

        # Store in mapped_data
        self.mapped_data['budgets'] = financial_data['budgets']
        self.mapped_data['service_charge_years'] = financial_data['service_charge_years']

        print(f"  ✅ Found {len(financial_data['budgets'])} budgets")
        print(f"  ✅ Found {len(financial_data['service_charge_years'])} service charge accounts")

        # Log years covered
        if financial_data['financial_summary']['years_covered']:
            print(f"\n  📋 Financial Years: {', '.join(financial_data['financial_summary']['years_covered'])}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_financial',
            'budgets_found': len(financial_data['budgets']),
            'accounts_found': len(financial_data['service_charge_years'])
        })

    def _print_summary(self):
        """Print final summary"""
        print("\n" + "=" * 60)
        print("✅ ONBOARDING COMPLETE")
        print("=" * 60)
        print(f"\nBuilding: {self.mapped_data.get('building', {}).get('name', 'Unknown')}")
        print(f"Units: {len(self.mapped_data.get('units', []))}")
        print(f"Leaseholders: {len(self.mapped_data.get('leaseholders', []))}")
        print(f"Documents: {len(self.mapped_data.get('building_documents', []))}")
        print(f"Compliance Assets: {len(self.mapped_data.get('compliance_assets', []))}")
        print(f"Compliance Inspections: {len(self.mapped_data.get('compliance_inspections', []))}")
        print(f"Major Works Projects: {len(self.mapped_data.get('major_works_projects', []))}")
        print(f"Budgets: {len(self.mapped_data.get('budgets', []))}")
        print(f"Service Charge Years: {len(self.mapped_data.get('service_charge_years', []))}")
        print(f"\nOutput directory: {self.output_dir.absolute()}")
        print("\n📝 Next steps:")
        print("  1. Review migration.sql")
        print("  2. Check document_log.csv")
        print("  3. Execute SQL in Supabase SQL Editor")
        print("  4. Upload original documents to Supabase Storage")
        print()

    def _find_file_by_category(self, category: str, keywords: List[str] = None) -> Dict:
        """Find first file matching category and keywords"""
        files = self.categorized_files.get(category, [])

        if not keywords:
            return files[0] if files else None

        for f in files:
            filename = f.get('file_name', '').lower()
            if any(keyword.lower() in filename for keyword in keywords):
                return f

        return None


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description='BlocIQ Onboarder - Import client data into Supabase'
    )
    parser.add_argument(
        'client_folder',
        help='Path to client onboarding folder'
    )
    parser.add_argument(
        '--building-name',
        help='Override building name'
    )

    args = parser.parse_args()

    # Validate folder
    if not os.path.isdir(args.client_folder):
        print(f"❌ Error: {args.client_folder} is not a directory")
        sys.exit(1)

    # Run onboarder
    onboarder = BlocIQOnboarder(args.client_folder, args.building_name)
    onboarder.run()


if __name__ == '__main__':
    main()
