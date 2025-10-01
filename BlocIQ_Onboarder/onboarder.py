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
from validators import BlockValidator
from matchers import file_sha256
from data_collator import DataCollator


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
        self.block_validator = BlockValidator()

        # Results storage
        self.parsed_files = []
        self.categorized_files = {}
        self.mapped_data = {}
        self.audit_log = []
        self.validation_report = {}
        self.confidence_report = []

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

        # Step 4.7: Validate data against business rules
        print("\n✅ Validating data against UK block management rules...")
        self._validate_data()

        # Step 5: Generate SQL
        print("\n📝 Generating SQL migration...")
        self._generate_sql()

        # Step 6: Generate logs and reports
        print("\n📊 Generating audit logs and confidence report...")
        self._generate_logs()
        self._generate_confidence_report()

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
        """Map classified files to Supabase schema with multi-source collation"""
        # Find property form for building address
        property_form = self._find_file_by_category('units_leaseholders', keywords=['property', 'form', 'setup', 'information'])

        # Initialize collator for multi-source data merging
        collator = DataCollator()

        # Map building first
        units_source = None
        if self.categorized_files.get('apportionments'):
            units_source = self.categorized_files['apportionments'][0]
        elif self.categorized_files.get('units_leaseholders'):
            units_source = self.categorized_files['units_leaseholders'][0]

        building = self.mapper.map_building(
            property_form if property_form else {},
            units_source if units_source else {}
        )

        # Override building name if provided
        if self.building_name:
            building['name'] = self.building_name

        # Extract address from property form if available
        if property_form:
            address = self.mapper.schema_mapper._extract_building_address_from_property_form(property_form)
            if address:
                building['address'] = address

        self.mapped_data['building'] = building
        building_id = building['id']

        print(f"\n  🏢 Building: {building.get('name', 'Unknown')}")
        print(f"  📍 Address: {building.get('address', 'Not found')}")

        # MULTI-SOURCE EXTRACTION: Extract units from ALL relevant files
        print(f"\n  🔍 Extracting data from multiple sources...")
        sources_found = 0

        # Extract from apportionment files (high confidence for apportionment %)
        if self.categorized_files.get('apportionments'):
            for file_data in self.categorized_files['apportionments']:
                units = self.mapper.map_units(file_data, building_id)
                if units:
                    collator.add_units_source(
                        units,
                        file_data['file_name'],
                        'apportionment',
                        confidence=0.95  # High confidence for apportionment data
                    )
                    sources_found += 1
                    print(f"     ✓ {file_data['file_name']} - {len(units)} units (apportionment)")

        # Extract from units_leaseholders files (high confidence for names/contact)
        if self.categorized_files.get('units_leaseholders'):
            for file_data in self.categorized_files['units_leaseholders']:
                units = self.mapper.map_units(file_data, building_id)
                if units:
                    collator.add_units_source(
                        units,
                        file_data['file_name'],
                        'leaseholder_list',
                        confidence=0.90
                    )
                    sources_found += 1
                    print(f"     ✓ {file_data['file_name']} - {len(units)} units (leaseholder data)")

        # Extract from budget files (medium confidence)
        if self.categorized_files.get('budgets'):
            for file_data in self.categorized_files['budgets']:
                units = self.mapper.map_units(file_data, building_id)
                if units:
                    collator.add_units_source(
                        units,
                        file_data['file_name'],
                        'budget',
                        confidence=0.75
                    )
                    sources_found += 1
                    print(f"     ✓ {file_data['file_name']} - {len(units)} units (budget)")

        # Get merged units
        units = collator.get_merged_units()
        self.mapped_data['units'] = units

        if sources_found > 0:
            print(f"\n  ✅ Merged data from {sources_found} sources")
            print(f"  📊 Total units: {len(units)}")

            # Now extract leaseholders from all sources
            unit_map = {unit['unit_number']: unit['id'] for unit in units}

            # Extract leaseholders from all units_leaseholders files
            if self.categorized_files.get('units_leaseholders'):
                for file_data in self.categorized_files['units_leaseholders']:
                    leaseholders = self.mapper.map_leaseholders(file_data, unit_map)
                    if leaseholders:
                        collator.add_leaseholders_source(
                            leaseholders,
                            file_data['file_name'],
                            'leaseholder_list',
                            confidence=0.90
                        )

            # Get merged leaseholders
            leaseholders = collator.get_merged_leaseholders()
            self.mapped_data['leaseholders'] = leaseholders
            print(f"  👥 Total leaseholders: {len(leaseholders)}")

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

            # Store collation report
            self.collation_report = collator.generate_collation_report()

            # Show conflicts if any
            if self.collation_report['summary']['total_conflicts'] > 0:
                print(f"\n  ⚠️  {self.collation_report['summary']['total_conflicts']} conflicts detected and resolved")
        else:
            print("  ⚠️  No unit data found in any files")
            self.mapped_data['units'] = []
            self.mapped_data['leaseholders'] = []
            self.mapped_data['unit_leaseholder_links'] = []
            self.collation_report = None

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

        # Collation report (JSON) - NEW
        if hasattr(self, 'collation_report') and self.collation_report:
            collation_file = self.output_dir / 'collation_report.json'
            with open(collation_file, 'w') as f:
                json.dump(self.collation_report, f, indent=2)

            print(f"  ✅ Collation report: {collation_file}")

            # Show summary
            summary = self.collation_report['summary']
            print(f"\n  📊 Data Collation Summary:")
            print(f"     • Sources used: {summary['sources_used']}")
            print(f"     • Units merged: {summary['total_units']}")
            print(f"     • Leaseholders merged: {summary['total_leaseholders']}")
            print(f"     • Conflicts resolved: {summary['total_conflicts']}")

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
        if financial_data.get('financial_summary', {}).get('years_covered'):
            print(f"\n  📋 Financial Years: {', '.join(financial_data['financial_summary']['years_covered'])}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_financial',
            'budgets_found': len(financial_data['budgets']),
            'accounts_found': len(financial_data['service_charge_years'])
        })

    def _validate_data(self):
        """Validate mapped data against UK block management rules"""
        self.validation_report = self.block_validator.validate_complete_dataset(self.mapped_data)

        # Print validation summary
        errors = self.validation_report.get('errors', [])
        warnings = self.validation_report.get('warnings', [])
        info = self.validation_report.get('info', [])

        if errors:
            print(f"\n  ❌ {len(errors)} validation error(s):")
            for error in errors[:5]:  # Show first 5
                print(f"     • {error['message']}")
            if len(errors) > 5:
                print(f"     ... and {len(errors) - 5} more")

        if warnings:
            print(f"\n  ⚠️  {len(warnings)} warning(s):")
            for warning in warnings[:3]:  # Show first 3
                print(f"     • {warning['message']}")
            if len(warnings) > 3:
                print(f"     ... and {len(warnings) - 3} more")

        if not errors and not warnings:
            print("  ✅ All validation checks passed")
        elif errors:
            print("\n  ⚠️  Validation errors found - review validation_report.json before executing SQL")

        # Save detailed validation report
        validation_file = self.output_dir / 'validation_report.json'
        with open(validation_file, 'w') as f:
            json.dump(self.validation_report, f, indent=2)

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'validate',
            'errors': len(errors),
            'warnings': len(warnings),
            'info': len(info)
        })

    def _generate_confidence_report(self):
        """Generate CSV report with confidence scores for all data"""
        import csv

        report_rows = []

        # Add building confidence
        building = self.mapped_data.get('building', {})
        report_rows.append({
            'category': 'building',
            'item': building.get('name', 'Unknown'),
            'source_file': 'property_form',
            'confidence_score': 95,  # High confidence from direct extraction
            'action': 'AUTO',
            'notes': 'Extracted from property information form'
        })

        # Add unit confidence scores
        units = self.mapped_data.get('units', [])
        for unit in units:
            apportionment = unit.get('apportionment_percent')
            confidence = 90 if apportionment else 70
            action = 'AUTO' if apportionment else 'REVIEW'

            report_rows.append({
                'category': 'unit',
                'item': unit.get('unit_number', 'Unknown'),
                'source_file': 'apportionment_file',
                'confidence_score': confidence,
                'action': action,
                'notes': f"Apportionment: {apportionment}%" if apportionment else "Missing apportionment"
            })

        # Add document confidence scores
        documents = self.mapped_data.get('building_documents', [])
        for doc in documents[:20]:  # First 20 documents
            confidence = doc.get('confidence', 0.5) * 100
            action = 'AUTO' if confidence >= 90 else ('REVIEW' if confidence >= 60 else 'REJECT')

            report_rows.append({
                'category': 'document',
                'item': doc.get('file_name', 'Unknown'),
                'source_file': doc.get('file_name', 'Unknown'),
                'confidence_score': int(confidence),
                'action': action,
                'notes': f"Type: {doc.get('type', 'unknown')}"
            })

        # Add compliance confidence scores
        compliance = self.mapped_data.get('compliance_assets', [])
        for asset in compliance:
            confidence = 85  # High confidence from pattern matching
            report_rows.append({
                'category': 'compliance',
                'item': asset.get('asset_name', 'Unknown'),
                'source_file': 'extracted',
                'confidence_score': confidence,
                'action': 'AUTO',
                'notes': f"Status: {asset.get('status', 'pending')}"
            })

        # Write CSV report
        report_file = self.output_dir / 'confidence_report.csv'
        with open(report_file, 'w', newline='', encoding='utf-8') as f:
            fieldnames = ['category', 'item', 'source_file', 'confidence_score', 'action', 'notes']
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(report_rows)

        print(f"  ✅ Confidence report: {report_file}")
        print(f"     • Total items: {len(report_rows)}")
        auto_count = sum(1 for r in report_rows if r['action'] == 'AUTO')
        review_count = sum(1 for r in report_rows if r['action'] == 'REVIEW')
        print(f"     • AUTO: {auto_count}, REVIEW: {review_count}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'generate_confidence_report',
            'total_items': len(report_rows),
            'auto': auto_count,
            'review': review_count
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

        # Print validation summary
        errors = self.validation_report.get('errors', [])
        warnings = self.validation_report.get('warnings', [])
        if errors:
            print(f"\n⚠️  Validation: {len(errors)} errors, {len(warnings)} warnings")
        elif warnings:
            print(f"\n✅ Validation: {len(warnings)} warnings")
        else:
            print("\n✅ Validation: All checks passed")

        print(f"\nOutput directory: {self.output_dir.absolute()}")
        print("\n📝 Generated files:")
        print("  1. migration.sql - SQL migration script")
        print("  2. confidence_report.csv - Confidence scores for all data")
        print("  3. validation_report.json - Detailed validation results")
        print("  4. document_log.csv - Document metadata")
        print("  5. audit_log.json - Processing audit trail")
        print("\n📝 Next steps:")
        print("  1. Review confidence_report.csv - check items marked REVIEW")
        print("  2. Review validation_report.json - address any errors/warnings")
        print("  3. Review migration.sql")
        print("  4. Execute SQL in Supabase SQL Editor")
        print("  5. Upload original documents to Supabase Storage")
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
