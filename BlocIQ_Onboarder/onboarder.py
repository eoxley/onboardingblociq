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
import uuid
from pathlib import Path
from datetime import datetime
from typing import List, Dict

from parsers import parse_file
from classifier import DocumentClassifier
from mapper import SupabaseMapper
from schema_mapper import SupabaseSchemaMapper
from sql_writer import SQLWriter, generate_document_log_csv
from compliance_extractor import ComplianceAssetExtractor
from major_works_extractor import MajorWorksExtractor
from financial_extractor import FinancialExtractor
from validate_schema import SchemaValidator
from validators import BlockValidator
from matchers import file_sha256
from data_collator import DataCollator
from storage_uploader import SupabaseStorageUploader

# Import new extractors
from extractors.insurance_extractor import InsuranceExtractor
from extractors.contracts_extractor import ContractsExtractor
from extractors.utilities_extractor import UtilitiesExtractor
from extractors.meetings_extractor import MeetingsExtractor
from extractors.client_money_extractor import ClientMoneyExtractor


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
        # Pass folder name to mapper for building name extraction
        self.mapper = SupabaseMapper(folder_name=self.client_folder.name)
        self.schema_mapper = SupabaseSchemaMapper(folder_name=self.client_folder.name)
        self.sql_writer = SQLWriter()
        self.compliance_extractor = ComplianceAssetExtractor()
        self.major_works_extractor = MajorWorksExtractor()
        self.financial_extractor = FinancialExtractor()
        self.validator = SchemaValidator()
        self.block_validator = BlockValidator()

        # Initialize new extractors
        self.insurance_extractor = InsuranceExtractor()
        self.contracts_extractor = ContractsExtractor()
        self.utilities_extractor = UtilitiesExtractor()
        self.meetings_extractor = MeetingsExtractor()
        self.client_money_extractor = ClientMoneyExtractor()

        # Results storage
        self.parsed_files = []
        self.categorized_files = {}
        self.mapped_data = {}
        self.audit_log = []
        self.validation_report = {}
        self.confidence_report = []
        self.enrichment_data = {}
        self.enrichment_stats = {}
        self.folder_name = self.client_folder.name

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

        # Step 4.55: Extract financial & compliance intelligence
        print("\n💼 Extracting financial & compliance intelligence...")
        self._extract_financial_intelligence()

        # Step 4.555: Extract financial data from Excel files (no OCR)
        print("\n📊 Extracting financial data from Excel files...")
        self._extract_excel_financial_data()

        # Step 4.56: Extract staffing data
        print("\n👤 Extracting building staffing data...")
        self._extract_staffing_data()

        # Step 4.57: Extract lease information with OCR
        print("\n📜 Extracting lease information...")
        self._extract_lease_data()

        # Step 4.6: Extract insurance, contracts, utilities, meetings, client money
        print("\n🔍 Extracting additional handover intelligence...")
        self._extract_handover_intelligence()

        # Step 4.7: Validate data against business rules
        print("\n✅ Validating data against UK block management rules...")
        self._validate_data()

        # Step 4.8: Upload files to Supabase Storage
        print("\n📤 Uploading files to Supabase Storage...")
        self._upload_to_storage()

        # Step 5: Generate SQL
        print("\n📝 Generating SQL migration...")
        self._generate_sql()

        # Step 5.5: Execute SQL migration to Supabase
        print("\n🚀 Executing SQL migration to Supabase...")
        self._execute_sql_migration()

        # Step 6: Generate logs and reports
        print("\n📊 Generating audit logs and confidence report...")
        self._generate_logs()
        self._generate_confidence_report()

        # Step 7: Generate classification summary PDF
        print("\n📄 Generating classification summary PDF...")
        self._generate_classification_summary()

        # Summary
        self._print_summary()

        # Step 8: Cleanup large objects from memory
        self._cleanup_parsed_data()

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
        # DEBUG: Write categorized_files state to log immediately
        import json
        debug_log_path = f"{self.output_dir}/categorized_files_debug.json"
        with open(debug_log_path, 'w') as f:
            debug_state = {}
            for cat, files in self.categorized_files.items():
                if files:
                    debug_state[cat] = {
                        'count': len(files),
                        'files': [{'file_name': f.get('file_name', 'unknown'),
                                   'has_data_key': 'data' in f,
                                   'has_raw_data_key': 'raw_data' in f,
                                   'top_level_keys': list(f.keys())} for f in files]
                    }
            json.dump(debug_state, f, indent=2)

        print("\n  🔍 DEBUG: Categorized files state saved to:", debug_log_path)
        print("  Categories with files:")
        for cat, info in debug_state.items():
            print(f"    {cat}: {info['count']} files")

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

        # Detect and create schedules for this building
        print(f"\n  📋 Detecting service charge schedules...")
        schedule_names = self.schema_mapper.detect_schedules(
            property_form_data=property_form,
            folder_name=self.folder_name
        )
        schedules = self.schema_mapper.map_schedules(building_id, schedule_names)
        self.mapped_data['schedules'] = schedules
        print(f"     ✓ Created {len(schedules)} schedule(s): {', '.join(schedule_names)}")

        # Extract property form structured data (contractors, utilities, insurance, etc.)
        if property_form:
            print(f"\n  📋 Extracting property form structured data...")
            property_form_data = self.schema_mapper.extract_property_form_data(property_form, building_id)

            # Add extracted data to mapped_data
            if property_form_data['contractors']:
                self.mapped_data['building_contractors'] = property_form_data['contractors']
                print(f"     ✓ {len(property_form_data['contractors'])} contractors")

            if property_form_data['utilities']:
                self.mapped_data['building_utilities'] = property_form_data['utilities']
                print(f"     ✓ {len(property_form_data['utilities'])} utilities")

            if property_form_data['insurance']:
                self.mapped_data['building_insurance'] = property_form_data['insurance']
                print(f"     ✓ {len(property_form_data['insurance'])} insurance records")

            if property_form_data['legal']:
                self.mapped_data['building_legal'] = property_form_data['legal']
                print(f"     ✓ {len(property_form_data['legal'])} legal records")

            if property_form_data['statutory_reports']:
                self.mapped_data['building_statutory_reports'] = property_form_data['statutory_reports']
                print(f"     ✓ {len(property_form_data['statutory_reports'])} statutory reports")

            if property_form_data['keys_access']:
                self.mapped_data['building_keys_access'] = property_form_data['keys_access']
                print(f"     ✓ {len(property_form_data['keys_access'])} keys/access records")

            if property_form_data['warranties']:
                self.mapped_data['building_warranties'] = property_form_data['warranties']
                print(f"     ✓ {len(property_form_data['warranties'])} warranties")

            if property_form_data['company_secretary']:
                self.mapped_data['company_secretary'] = property_form_data['company_secretary']
                print(f"     ✓ Company secretary data")

            if property_form_data['title_deeds']:
                self.mapped_data['building_title_deeds'] = property_form_data['title_deeds']
                print(f"     ✓ {len(property_form_data['title_deeds'])} title deed records")

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
            print(f"  → Extracting units from {len(self.categorized_files['units_leaseholders'])} leaseholder files")
            for file_data in self.categorized_files['units_leaseholders']:
                fname = file_data.get('file_name', '')
                has_full_text = 'full_text' in file_data
                print(f"     Processing: {fname} (has_full_text: {has_full_text})")
                if has_full_text and 'tenancy schedule' in fname.lower():
                    print(f"       → Tenancy Schedule detected, full_text length: {len(file_data['full_text'])}")
                units = self.mapper.map_units(file_data, building_id)
                print(f"       → Extracted {len(units)} units")
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
        budget_debug_log = []
        if self.categorized_files.get('budgets'):
            print(f"  → Found {len(self.categorized_files['budgets'])} budget files")
            budget_debug_log.append(f"Found {len(self.categorized_files['budgets'])} budget files")
            for file_data in self.categorized_files['budgets']:
                fname = file_data.get('file_name', 'unknown')
                has_data = 'data' in file_data
                print(f"     Processing: {fname}")
                print(f"     Has 'data' key: {has_data}")
                budget_debug_log.append(f"Processing: {fname}, has_data: {has_data}")

                units = self.mapper.map_units(file_data, building_id)
                print(f"     → Extracted {len(units)} units")
                budget_debug_log.append(f"  Extracted: {len(units)} units from {fname}")
                if units:
                    collator.add_units_source(
                        units,
                        file_data['file_name'],
                        'budget',
                        confidence=0.75
                    )
                    sources_found += 1
                    print(f"     ✓ {file_data['file_name']} - {len(units)} units (budget)")

        # Save budget debug log
        if budget_debug_log:
            debug_file = self.output_dir / 'budget_extraction_debug.log'
            with open(debug_file, 'w') as f:
                f.write('\n'.join(budget_debug_log))

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
                print(f"  → Extracting leaseholders from {len(self.categorized_files['units_leaseholders'])} files")
                for file_data in self.categorized_files['units_leaseholders']:
                    # Debug: check if Tenancy Schedule has full_text
                    if 'tenancy schedule' in file_data.get('file_name', '').lower():
                        print(f"     DEBUG: Tenancy Schedule has full_text: {'full_text' in file_data}")
                        if 'full_text' in file_data:
                            print(f"     DEBUG: full_text length: {len(file_data['full_text'])}")

                    leaseholders = self.mapper.map_leaseholders(file_data, unit_map, building_id)
                    print(f"     {file_data['file_name']}: {len(leaseholders)} leaseholders")
                    if leaseholders:
                        print(f"     → Adding {len(leaseholders)} leaseholders to collator")
                        collator.add_leaseholders_source(
                            leaseholders,
                            file_data['file_name'],
                            'leaseholder_list',
                            confidence=0.90
                        )
                    else:
                        print(f"     → Skipping (empty list)")

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
            self.collation_report = collator.generate_data_quality_report()

            # Show conflicts if any
            if self.collation_report.get('conflicts_count', 0) > 0:
                print(f"\n  ⚠️  {self.collation_report['conflicts_count']} conflicts detected and resolved")
        else:
            print("  ⚠️  No unit data found in any files")
            self.mapped_data['units'] = []
            self.mapped_data['leaseholders'] = []
            self.mapped_data['unit_leaseholder_links'] = []
            self.collation_report = None

        # Map building documents - DUAL-WRITE PATTERN
        documents = []
        compliance_assets = []
        major_works = []
        finances = []

        for category, files in self.categorized_files.items():
            for file_data in files:
                # Use dual-write pattern for compliance, major_works, and budgets
                if category in ['compliance', 'major_works', 'budgets']:
                    records = self.mapper.map_document_with_entities(file_data, building_id, category)
                    for table_name, record in records:
                        if table_name == 'building_documents':
                            documents.append(record)
                        elif table_name == 'compliance_assets':
                            compliance_assets.append(record)
                        elif table_name == 'major_works_projects':
                            major_works.append(record)
                        elif table_name == 'finances':
                            finances.append(record)
                else:
                    # Regular document mapping for other categories
                    doc = self.mapper.map_building_documents(file_data, building_id, category)
                    documents.append(doc)

        self.mapped_data['building_documents'] = documents
        if compliance_assets:
            self.mapped_data['compliance_assets'] = self.mapped_data.get('compliance_assets', []) + compliance_assets
        if major_works:
            self.mapped_data['major_works_projects'] = self.mapped_data.get('major_works_projects', []) + major_works
        if finances:
            self.mapped_data['finances'] = self.mapped_data.get('finances', []) + finances

        print(f"  Documents: {len(documents)}")
        if compliance_assets:
            print(f"  Compliance Assets (from docs): {len(compliance_assets)}")
        if major_works:
            print(f"  Major Works Projects (from docs): {len(major_works)}")
        if finances:
            print(f"  Finance Records (from docs): {len(finances)}")

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

    def _upload_to_storage(self):
        """Upload files to Supabase Storage"""
        try:
            # Load Supabase credentials from environment
            from dotenv import load_dotenv
            from supabase import create_client

            # Load .env.local
            env_path = Path(__file__).parent / '.env.local'
            load_dotenv(env_path)

            supabase_url = os.getenv('SUPABASE_URL')
            supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

            if not supabase_url or not supabase_key:
                print("  ⚠️  Supabase credentials not found in .env.local")
                print("  ℹ️  Files will not be uploaded. Storage paths will be placeholders.")
                self.upload_map = {}
                return

            # Initialize Supabase client
            supabase = create_client(supabase_url, supabase_key)

            # Initialize uploader
            uploader = SupabaseStorageUploader(supabase)

            # Get building ID from mapped data
            building_id = self.mapped_data.get('building', {}).get('id')
            if not building_id:
                print("  ⚠️  No building ID found, skipping upload")
                self.upload_map = {}
                return

            # Upload all files
            self.upload_map = uploader.upload_building_documents(
                client_folder=str(self.client_folder),
                building_id=building_id,
                categorized_files=self.categorized_files
            )

            # Update storage paths in building_documents with actual uploaded paths
            if 'building_documents' in self.mapped_data:
                for doc in self.mapped_data['building_documents']:
                    file_name = doc.get('file_name')
                    # Find matching upload
                    for file_path, upload_info in self.upload_map.items():
                        if upload_info['file_name'] == file_name:
                            doc['storage_path'] = upload_info['storage_path']
                            break

            # Print summary
            summary = uploader.get_upload_summary()
            print(f"\n  ✅ Uploaded {summary['total_files']} files ({summary['total_size_mb']} MB)")

        except Exception as e:
            print(f"  ⚠️  Error uploading to Supabase Storage: {e}")
            print("  ℹ️  Continuing with local file paths...")
            self.upload_map = {}

    def _generate_sql(self):
        """Generate SQL migration script with enrichment"""
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

        # ============================================================
        # POST-PROCESSING ENRICHMENT
        # ============================================================
        print("\n🧠 Running post-processing enrichment...")
        from enrichment_processor import EnrichmentProcessor

        enrichment_processor = EnrichmentProcessor()
        enrichment_data = enrichment_processor.process(
            mapped_data=self.mapped_data,
            parsed_files=self.parsed_files,
            folder_name=self.folder_name
        )

        # Append enrichment SQL to migration script
        if enrichment_data.get('sql_statements'):
            enrichment_sql = '\n'.join(enrichment_data['sql_statements'])
            sql_script += f"\n\n-- ============================================================\n"
            sql_script += f"-- POST-PROCESSING ENRICHMENT\n"
            sql_script += f"-- Auto-generated corrections and enhancements\n"
            sql_script += f"-- ============================================================\n\n"
            sql_script += enrichment_sql

        # Get enrichment stats
        enrichment_stats = enrichment_processor.get_stats()

        # Display enrichment summary
        print(f"\n  📊 Enrichment Summary:")
        if enrichment_stats.get('addresses_extracted', 0) > 0:
            print(f"     ✅ Addresses extracted: {enrichment_stats['addresses_extracted']}")
        if enrichment_stats.get('addresses_skipped', 0) > 0:
            print(f"     ⚠️  Addresses skipped: {enrichment_stats['addresses_skipped']}")
        if enrichment_stats.get('major_works_tagged', 0) > 0:
            print(f"     ✅ Major works tagged: {enrichment_stats['major_works_tagged']}")
        if enrichment_stats.get('budget_placeholders_created', 0) > 0:
            print(f"     ✅ Budget placeholders: {enrichment_stats['budget_placeholders_created']}")
        if enrichment_stats.get('building_intelligence_entries', 0) > 0:
            print(f"     🧠 Building knowledge entries: {enrichment_stats['building_intelligence_entries']}")

        # Store enrichment data for summary
        self.enrichment_data = enrichment_data
        self.enrichment_stats = enrichment_stats

        # Update validation report with enrichment summary
        validation_result['enrichment_summary'] = enrichment_processor.get_validation_summary()
        with open(validation_file, 'w') as f:
            json.dump(validation_result, f, indent=2)

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
            'validation_passed': validation_result['valid'],
            'enrichment_stats': enrichment_stats
        })

    def _execute_sql_migration(self):
        """Execute SQL migration to Supabase"""
        import os
        from supabase import create_client

        # Get Supabase credentials
        supabase_url = os.getenv('SUPABASE_URL')
        supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_KEY')

        if not supabase_url or not supabase_key:
            print("  ⚠️  Supabase credentials not found in environment")
            print("  ℹ️  Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY to auto-execute migrations")
            print("  📝 SQL migration saved to output/migration.sql - execute manually")
            return

        try:
            # Read SQL migration file
            sql_file = self.output_dir / 'migration.sql'
            if not sql_file.exists():
                print("  ⚠️  SQL migration file not found")
                return

            with open(sql_file, 'r') as f:
                sql_script = f.read()

            # Connect to Supabase
            supabase = create_client(supabase_url, supabase_key)
            print("  ✅ Connected to Supabase")

            # Split SQL into individual statements
            # Remove comments and split by semicolon
            statements = []
            current_statement = []

            for line in sql_script.split('\n'):
                # Skip comment-only lines
                if line.strip().startswith('--'):
                    continue

                current_statement.append(line)

                # If line ends with semicolon, it's end of statement
                if line.strip().endswith(';'):
                    statement = '\n'.join(current_statement).strip()
                    if statement and not statement.startswith('--'):
                        statements.append(statement)
                    current_statement = []

            print(f"  📝 Executing {len(statements)} SQL statements...")

            # Execute statements
            executed = 0
            failed = 0

            for i, statement in enumerate(statements, 1):
                try:
                    # Execute via Supabase RPC or direct SQL
                    # Note: Supabase Python client doesn't support direct SQL execution
                    # We need to use the PostgREST API or psycopg2

                    # For now, use psycopg2 if available
                    import psycopg2
                    from urllib.parse import urlparse

                    # Parse database URL from Supabase URL
                    # Supabase format: https://xxx.supabase.co
                    # We need the direct Postgres connection

                    db_url = os.getenv('DATABASE_URL')
                    if not db_url:
                        print("  ⚠️  DATABASE_URL not found - cannot execute SQL directly")
                        print("  ℹ️  Set DATABASE_URL for direct Postgres connection")
                        print("  📝 Execute migration.sql manually via Supabase SQL Editor")
                        return

                    # Connect to Postgres
                    conn = psycopg2.connect(db_url)
                    cursor = conn.cursor()

                    # Execute statement
                    cursor.execute(statement)
                    conn.commit()

                    executed += 1
                    if executed % 10 == 0:
                        print(f"     Progress: {executed}/{len(statements)} statements")

                except Exception as e:
                    failed += 1
                    print(f"  ⚠️  Statement {i} failed: {str(e)[:100]}")
                    continue

            # Close connection
            if 'cursor' in locals():
                cursor.close()
            if 'conn' in locals():
                conn.close()

            print(f"\n  ✅ Migration complete!")
            print(f"     Executed: {executed}")
            if failed > 0:
                print(f"     Failed: {failed}")

            self.audit_log.append({
                'timestamp': datetime.now().isoformat(),
                'action': 'execute_sql_migration',
                'executed': executed,
                'failed': failed
            })

        except ImportError as e:
            print(f"  ⚠️  psycopg2 not installed: {e}")
            print(f"  ℹ️  Install with: pip install psycopg2-binary")
            print(f"  📝 Execute migration.sql manually via Supabase SQL Editor")
        except Exception as e:
            print(f"  ⚠️  Error executing migration: {e}")
            print(f"  📝 Execute migration.sql manually via Supabase SQL Editor")
            import traceback
            traceback.print_exc()

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
            print(f"\n  📊 Data Collation Summary:")
            print(f"     • Units: {len(self.mapped_data.get('units', []))}")
            print(f"     • Leaseholders: {len(self.mapped_data.get('leaseholders', []))}")
            print(f"     • Conflicts resolved: {self.collation_report.get('conflicts_count', 0)}")
            print(f"     • Merges performed: {self.collation_report.get('merges_count', 0)}")

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

        # Add enrichment summary if available
        if hasattr(self, 'enrichment_stats'):
            summary['post_processing_summary'] = {
                'building_metadata_filled': self.enrichment_stats.get('building_metadata_filled', 0),
                'addresses_extracted': self.enrichment_stats.get('addresses_extracted', 0),
                'major_works_tagged': self.enrichment_stats.get('major_works_tagged', 0),
                'budget_placeholders_created': self.enrichment_stats.get('budget_placeholders_created', 0),
                'building_intelligence_entries': self.enrichment_stats.get('building_intelligence_entries', 0)
            }

        # Add building knowledge details if available
        if hasattr(self, 'enrichment_data') and self.enrichment_data.get('building_knowledge'):
            summary['building_intelligence'] = {
                'total_entries': len(self.enrichment_data['building_knowledge']),
                'by_category': {}
            }
            for entry in self.enrichment_data['building_knowledge']:
                category = entry.get('category', 'unknown')
                summary['building_intelligence']['by_category'][category] = \
                    summary['building_intelligence']['by_category'].get(category, 0) + 1

        # Add detailed compliance assets breakdown
        compliance_assets = self.mapped_data.get('compliance_assets', [])
        if compliance_assets:
            from datetime import timedelta

            today = datetime.now().date()

            # Group by asset type
            by_type = {}
            by_status = {'compliant': 0, 'overdue': 0, 'due_soon': 0, 'unknown': 0}

            detailed_assets = []

            for asset in compliance_assets:
                asset_type = asset.get('asset_type', 'unknown')
                asset_name = asset.get('asset_name', 'Unknown Asset')
                status = asset.get('compliance_status', 'unknown')
                next_due = asset.get('next_due_date')
                last_inspection = asset.get('last_inspection_date')

                # Count by type
                by_type[asset_type] = by_type.get(asset_type, 0) + 1

                # Count by status
                by_status[status] = by_status.get(status, 0) + 1

                # Add to detailed list
                asset_detail = {
                    'name': asset_name,
                    'type': asset_type,
                    'status': status,
                    'last_inspection': last_inspection,
                    'next_due': next_due,
                    'location': asset.get('location'),
                    'responsible_party': asset.get('responsible_party')
                }
                detailed_assets.append(asset_detail)

            summary['compliance_assets'] = {
                'total': len(compliance_assets),
                'by_type': by_type,
                'by_status': by_status,
                'details': detailed_assets
            }

        # Add detailed contractor contracts summary
        contractors = self.mapped_data.get('building_contractors', [])
        if contractors:
            from datetime import timedelta

            total_contracts = len(contractors)
            expiring_next_90_days = 0
            retenders_pending = 0
            budget_review_links = 0

            # Group by contractor type
            by_type = {}
            detailed_contracts = []

            today = datetime.now().date()
            ninety_days_from_now = today + timedelta(days=90)

            for contractor in contractors:
                contractor_type = contractor.get('contractor_type', 'unknown')
                company_name = contractor.get('company_name', 'Unknown Company')
                contract_start = contractor.get('contract_start')
                contract_end = contractor.get('contract_end')
                retender_status = contractor.get('retender_status', 'not_scheduled')
                retender_due = contractor.get('retender_due_date')
                next_review = contractor.get('next_review_date')

                # Count by type
                by_type[contractor_type] = by_type.get(contractor_type, 0) + 1

                # Count expiring contracts
                if contract_end:
                    try:
                        end_date = datetime.fromisoformat(contract_end).date() if isinstance(contract_end, str) else contract_end
                        if today <= end_date <= ninety_days_from_now:
                            expiring_next_90_days += 1
                    except:
                        pass

                # Count pending retenders
                if retender_status in ['pending', 'in_progress']:
                    retenders_pending += 1

                # Count budget review links
                if next_review:
                    budget_review_links += 1

                # Add to detailed list
                contract_detail = {
                    'company': company_name,
                    'type': contractor_type,
                    'start_date': contract_start,
                    'end_date': contract_end,
                    'retender_status': retender_status,
                    'retender_due_date': retender_due,
                    'next_review_date': next_review,
                    'contact_person': contractor.get('contact_person'),
                    'phone': contractor.get('phone'),
                    'email': contractor.get('email')
                }
                detailed_contracts.append(contract_detail)

            summary['contractor_contracts'] = {
                'total': total_contracts,
                'expiring_next_90_days': expiring_next_90_days,
                'retenders_pending': retenders_pending,
                'budget_review_links': budget_review_links,
                'by_type': by_type,
                'details': detailed_contracts
            }

        summary_file = self.output_dir / 'summary.json'
        with open(summary_file, 'w') as f:
            json.dump(summary, f, indent=2)

        print(f"  ✅ Summary: {summary_file}")

        # Save mapped_data.json for health check generator
        mapped_data_file = self.output_dir / 'mapped_data.json'
        with open(mapped_data_file, 'w') as f:
            json.dump(self.mapped_data, f, indent=2, default=str)

        print(f"  ✅ Mapped Data: {mapped_data_file}")

        # Generate Building Health Check Report from extraction data (no database query)
        try:
            # Get building_id for optional upload
            building_id = self.mapped_data.get('building', {}).get('id')
            if not building_id:
                import uuid
                building_id = 'temp-building-id'

            print("\n📊 Generating Building Health Check Report (V3 - From Extraction)...")
            from generate_health_check_from_extraction import generate_health_check
            import os

            # ALWAYS use local extracted data for onboarding health check
            # This is a snapshot of what was found in the documents
            print("  ℹ️  Using local extracted data (onboarding snapshot)")

            if not self.mapped_data or not isinstance(self.mapped_data, dict):
                print("  ⚠️  No valid mapped data available, skipping health check")
            else:
                # Generate V3 professional health check report using extraction data
                print(f"  📊 Generating V3 professional report from extraction data...")
                report_file = generate_health_check(
                    output_dir=str(self.output_dir),
                    output_pdf=str(self.output_dir / 'building_health_check.pdf')
                )

                if report_file:
                    print(f"\n  ✅ Building Health Check V3 PDF Generated Successfully!")
                    print(f"  📄 Location: {report_file}")
                    print(f"\n  📊 Report includes:")
                    print(f"     • Cover Page with Health Score & Rating")
                    print(f"     • Executive Summary with weighted scoring (Compliance 40%, Insurance 20%, Budget 20%, Lease 10%, Contractor 10%)")
                    print(f"     • Building Overview with full address")
                    print(f"     • Lease Summary with term dates & ground rent")
                    print(f"     • Budget Summary with periods & amounts")
                    print(f"     • Compliance Overview by category with inspection dates")
                    print(f"     • Insurance Policies with expiry tracking")
                    print(f"     • Contractors & Contracts")
                    print(f"     • Major Works Projects")
                    print(f"     • Generated from extraction data (no database query required)")
                    print(f"     • Professional BlocIQ branding")
                    
                    # Upload PDF to Supabase reports bucket if configured
                    if self.config.get('upload_to_supabase') and hasattr(self, 'supabase') and self.supabase:
                        print(f"\n  📤 Uploading PDF to Supabase reports bucket...")
                        uploader = SupabaseStorageUploader(self.supabase)
                        upload_result = uploader.upload_report_pdf(
                            pdf_path=str(report_file),
                            building_id=building_id,
                            report_name=f"building_health_check_{datetime.now().strftime('%Y%m%d')}.pdf"
                        )
                        if upload_result:
                            print(f"  ✅ PDF uploaded to: {upload_result['bucket']}/{upload_result['path']}")
                        else:
                            print(f"  ⚠️  PDF upload failed, but local copy is available")
                else:
                    print("  ⚠️  PDF generation returned no file path")

        except ImportError as e:
            print(f"  ⚠️  Could not generate Building Health Check report: {e}")
            print(f"  ℹ️  Install dependencies: pip install reportlab>=4.0.0 PyPDF2>=3.0.0")
        except Exception as e:
            print(f"  ⚠️  Error generating Building Health Check report: {e}")
            import traceback
            traceback.print_exc()

    def _extract_compliance_data(self):
        """Extract compliance assets and inspections from parsed files"""
        # NOTE: Compliance assets are now extracted via the new mapper.process_file()
        # This legacy extractor is disabled as it uses the old schema
        print("  ℹ️  Compliance extraction now handled by document mapper (BlocIQ V2)")

        # Get compliance assets that were already extracted by the mapper
        assets = self.mapped_data.get('compliance_assets', [])
        inspections = self.mapped_data.get('compliance_inspections', [])

        print(f"  ✅ Found {len(assets)} compliance assets")
        if inspections:
            print(f"  ✅ Found {len(inspections)} inspection records")

        # Log compliance asset types
        if assets:
            asset_types = {}
            for asset in assets:
                asset_type = asset.get('name', 'Unknown')  # Changed from asset_name to name
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
        # NOTE: Major works are now extracted via the new mapper.process_file()
        # This legacy extractor is disabled as it uses the old schema
        print("  ℹ️  Major works extraction now handled by document mapper (BlocIQ V2)")

        # Get major works that were already extracted by the mapper
        projects = self.mapped_data.get('major_works_projects', [])

        print(f"  ✅ Found {len(projects)} major works projects")

        # Log project types
        if projects:
            project_types = {}
            for project in projects:
                proj_name = project.get('project_name', 'Unknown')
                # Extract first word as type
                if isinstance(proj_name, str) and proj_name:
                    proj_type = proj_name.split()[0]
                else:
                    proj_type = 'Unknown'
                project_types[proj_type] = project_types.get(proj_type, 0) + 1

            print("\n  📋 Major Works Projects Detected:")
            for proj_type, count in sorted(project_types.items()):
                print(f"     - {proj_type}: {count}")

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_major_works',
            'projects_found': len(projects)
        })

    def _extract_financial_data(self):
        """Extract budgets and service charge accounts from parsed files"""
        # NOTE: Budgets are now extracted via the new mapper.process_file()
        # This legacy extractor is disabled as it uses the old schema
        print("  ℹ️  Financial extraction now handled by document mapper (BlocIQ V2)")

        # Get budgets that were already extracted by the mapper
        budgets = self.mapped_data.get('budgets', [])
        service_charge_years = self.mapped_data.get('service_charge_years', [])

        print(f"  ✅ Found {len(budgets)} budgets")
        if service_charge_years:
            print(f"  ✅ Found {len(service_charge_years)} service charge accounts")

        # Extract apportionments from apportionment files
        self._extract_apportionments()

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_financial',
            'budgets_found': len(budgets),
            'accounts_found': len(service_charge_years)
        })

    def _extract_financial_intelligence(self):
        """Extract financial & compliance intelligence using new AI-powered extractor"""
        from financial_intelligence_extractor import FinancialIntelligenceExtractor

        extractor = FinancialIntelligenceExtractor(
            parsed_files=self.parsed_files,
            mapped_data=self.mapped_data
        )

        # Extract all financial & compliance data
        results = extractor.extract_all()

        # Merge extracted data into mapped_data
        # Note: Apportionments and budgets may already exist from mapper
        # We append new ones found by the intelligence extractor

        if results['apportionments']:
            existing = self.mapped_data.get('apportionments', [])
            self.mapped_data['apportionments'] = existing + results['apportionments']

        if results['budgets']:
            existing = self.mapped_data.get('budgets', [])
            self.mapped_data['budgets'] = existing + results['budgets']

        if results['insurance']:
            existing = self.mapped_data.get('building_insurance', [])
            self.mapped_data['building_insurance'] = existing + results['insurance']

        # Fire door inspections - new table
        self.mapped_data['fire_door_inspections'] = results['fire_door_inspections']

        # Store alerts for reporting
        self.financial_intelligence_alerts = results['alerts']

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_financial_intelligence',
            'apportionments': len(results['apportionments']),
            'budgets': len(results['budgets']),
            'insurance': len(results['insurance']),
            'fire_door_inspections': len(results['fire_door_inspections']),
            'alerts': len(results['alerts'])
        })

    def _extract_staffing_data(self):
        """Extract building staffing data using staffing extractor"""
        from staffing_extractor import StaffingExtractor

        extractor = StaffingExtractor(
            parsed_files=self.parsed_files,
            mapped_data=self.mapped_data
        )

        # Extract all staffing data
        results = extractor.extract_all()

        # Add to mapped_data
        self.mapped_data['building_staff'] = results['staff_members']

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_staffing_data',
            'staff_members': len(results['staff_members'])
        })

    def _extract_excel_financial_data(self):
        """Extract financial data directly from Excel files (no OCR)"""
        from excel_financial_extractor import ExcelFinancialExtractor

        # Initialize extractor
        extractor = ExcelFinancialExtractor(
            parsed_files=self.parsed_files,
            mapped_data=self.mapped_data
        )

        # Extract all financial data
        results = extractor.extract_all()

        # Merge budgets (avoid duplicates from different extraction methods)
        existing_budgets = self.mapped_data.get('budgets', [])
        new_budgets = results['budgets']

        # Add new budgets that don't already exist
        for new_budget in new_budgets:
            # Check for duplicates by source document
            is_duplicate = any(
                b.get('source_document') == new_budget.get('source_document')
                for b in existing_budgets
            )
            if not is_duplicate:
                existing_budgets.append(new_budget)

        self.mapped_data['budgets'] = existing_budgets

        # Merge apportionments (avoid duplicates)
        existing_apportionments = self.mapped_data.get('apportionments', [])
        new_apportionments = results['apportionments']

        for new_app in new_apportionments:
            # Check for duplicates by unit_id
            is_duplicate = any(
                a.get('unit_id') == new_app.get('unit_id') and
                a.get('source_document') == new_app.get('source_document')
                for a in existing_apportionments
            )
            if not is_duplicate:
                existing_apportionments.append(new_app)

        self.mapped_data['apportionments'] = existing_apportionments

        # Merge insurance records (avoid duplicates)
        existing_insurance = self.mapped_data.get('building_insurance', [])
        new_insurance = results['building_insurance']

        for new_ins in new_insurance:
            # Check for duplicates by source document
            is_duplicate = any(
                i.get('source_document') == new_ins.get('source_document')
                for i in existing_insurance
            )
            if not is_duplicate:
                existing_insurance.append(new_ins)

        self.mapped_data['building_insurance'] = existing_insurance

        # Convert errors to timeline events for logging
        if results['errors']:
            timeline_events = self.mapped_data.get('timeline_events', [])

            for error in results['errors']:
                event = {
                    'id': str(__import__('uuid').uuid4()),
                    'building_id': self.mapped_data.get('building', {}).get('id'),
                    'event_type': 'import_error',
                    'description': error.get('error', 'Unknown error'),
                    'metadata': {
                        'file': error.get('file'),
                        'error_type': error.get('type')
                    },
                    'severity': 'warning'
                }
                timeline_events.append(event)

            self.mapped_data['timeline_events'] = timeline_events

        # Store summary for Building Health Check
        self.excel_financial_summary = {
            'budgets_detected': len(new_budgets),
            'apportionments_mapped': len(new_apportionments),
            'insurance_detected': len(new_insurance),
            'errors': len(results['errors']),
            'missing_totals': sum(1 for e in results['errors'] if e.get('type') == 'budget_missing_total')
        }

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_excel_financial_data',
            'budgets': len(new_budgets),
            'apportionments': len(new_apportionments),
            'insurance': len(new_insurance),
            'errors': len(results['errors'])
        })

    def _extract_lease_data(self):
        """Extract lease information from documents using OCR"""
        from lease_extractor import LeaseExtractor
        from comprehensive_lease_extractor import ComprehensiveLeaseExtractor

        # Initialize lease extractor
        extractor = LeaseExtractor(
            parsed_files=self.parsed_files,
            mapped_data=self.mapped_data
        )

        # Extract all lease data
        results = extractor.extract_all()

        # Add basic leases to mapped_data
        self.mapped_data['leases'] = results['leases']

        # Now extract comprehensive lease data for each lease with OCR text
        comprehensive_data = {
            'document_texts': [],
            'lease_parties': [],
            'lease_demise': [],
            'lease_financial_terms': [],
            'lease_insurance_terms': [],
            'lease_covenants': [],
            'lease_restrictions': [],
            'lease_rights': [],
            'lease_enforcement': [],
            'lease_clauses': []
        }

        # Extract comprehensive data from each lease
        for lease in results['leases']:
            if lease.get('ocr_text'):
                try:
                    comp_extractor = ComprehensiveLeaseExtractor(
                        lease_text=lease['ocr_text'],
                        lease_id=lease.get('id'),
                        unit_id=lease.get('unit_id')
                    )
                    comp_result = comp_extractor.extract_comprehensive_lease()

                    # Add document_texts entry
                    if comp_result.get('document_text'):
                        comprehensive_data['document_texts'].append(comp_result['document_text'])

                    # Add parties
                    if comp_result.get('parties'):
                        comprehensive_data['lease_parties'].extend(comp_result['parties'])

                    # Add demise
                    if comp_result.get('demise'):
                        comprehensive_data['lease_demise'].append(comp_result['demise'])

                    # Add financial terms
                    if comp_result.get('financial_terms'):
                        comprehensive_data['lease_financial_terms'].append(comp_result['financial_terms'])

                    # Add insurance terms
                    if comp_result.get('insurance_terms'):
                        comprehensive_data['lease_insurance_terms'].append(comp_result['insurance_terms'])

                    # Add covenants
                    if comp_result.get('covenants'):
                        comprehensive_data['lease_covenants'].extend(comp_result['covenants'])

                    # Add restrictions
                    if comp_result.get('restrictions'):
                        comprehensive_data['lease_restrictions'].extend(comp_result['restrictions'])

                    # Add rights
                    if comp_result.get('rights'):
                        comprehensive_data['lease_rights'].extend(comp_result['rights'])

                    # Add enforcement
                    if comp_result.get('enforcement'):
                        comprehensive_data['lease_enforcement'].extend(comp_result['enforcement'])

                    # Add clause references
                    if comp_result.get('clause_references'):
                        comprehensive_data['lease_clauses'].extend(comp_result['clause_references'])

                except Exception as e:
                    print(f"     ⚠️  Comprehensive extraction failed for lease {lease.get('id')}: {str(e)}")

        # Add comprehensive data to mapped_data (only if we have data)
        for key, value in comprehensive_data.items():
            if value:  # Only add if not empty
                self.mapped_data[key] = value
                print(f"     ✅ Extracted {len(value)} {key} records")

        # Convert errors to timeline events
        if results['errors']:
            timeline_events = self.mapped_data.get('timeline_events', [])

            for error in results['errors']:
                event = {
                    'id': str(__import__('uuid').uuid4()),
                    'building_id': self.mapped_data.get('building', {}).get('id'),
                    'event_type': 'import_error',
                    'description': f"Lease extraction error: {error.get('error', 'Unknown error')}",
                    'metadata': {
                        'file': error.get('file'),
                        'error_type': error.get('type')
                    },
                    'severity': 'warning'
                }
                timeline_events.append(event)

            self.mapped_data['timeline_events'] = timeline_events

        # Store statistics
        stats = results.get('statistics', {})

        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_lease_data',
            'leases_extracted': stats.get('leases_extracted', 0),
            'files_processed': stats.get('files_processed', 0),
            'files_with_ocr': stats.get('files_with_ocr', 0),
            'errors': len(results['errors'])
        })

    def _extract_apportionments(self):
        """Extract apportionments from apportionment files and link to budgets and units"""
        if not self.categorized_files.get('apportionments'):
            print("  ℹ️  No apportionment files found")
            return

        # Get unit map for linking
        units = self.mapped_data.get('units', [])
        if not units:
            print("  ⚠️  No units found - cannot extract apportionments")
            return

        unit_map = {unit['unit_number']: unit['id'] for unit in units}

        # Get budgets for linking
        budgets = self.mapped_data.get('budgets', [])
        if not budgets:
            print("  ℹ️  No budgets found - creating default budget for apportionments")
            # Create a default budget to link apportionments to
            building_id = self.mapped_data['building']['id']
            default_budget = {
                'id': str(__import__('uuid').uuid4()),
                'building_id': building_id,
                'year_start_date': None,
                'year_end_date': None,
                'total_amount': None,
                'budget_type': 'service_charge'
            }
            budgets = [default_budget]
            self.mapped_data['budgets'] = budgets

        all_apportionments = []

        for file_data in self.categorized_files['apportionments']:
            file_name = file_data.get('file_name', 'unknown')

            # Try to match apportionment file to a specific budget by year or use the most recent budget
            budget_id = budgets[0]['id']  # Default to first/most recent budget

            # Extract year from filename if present (e.g., "Apportionments 2024.xlsx")
            import re
            year_match = re.search(r'20\d{2}', file_name)
            if year_match:
                file_year = int(year_match.group())
                # Try to find matching budget by year
                for budget in budgets:
                    if budget.get('year_start_date'):
                        budget_year = int(budget['year_start_date'][:4])
                        if budget_year == file_year:
                            budget_id = budget['id']
                            break

            # Extract apportionments
            apportionments = self.mapper.map_apportionments(file_data, unit_map, budget_id, building_id)

            if apportionments:
                all_apportionments.extend(apportionments)
                print(f"  ✅ Extracted {len(apportionments)} apportionments from {file_name}")
            else:
                print(f"  ⚠️  No apportionments extracted from {file_name}")

        if all_apportionments:
            self.mapped_data['apportionments'] = all_apportionments
            print(f"\n  💰 Total apportionments extracted: {len(all_apportionments)}")
        else:
            print("  ⚠️  No apportionments extracted from any files")

    def _extract_handover_intelligence(self):
        """Extract insurance, contracts, utilities, meetings, and client money data"""
        building_id = self.mapped_data['building']['id']

        # Extract insurance policies
        insurance_policies = []
        if self.categorized_files.get('insurance'):
            print(f"  📋 Processing {len(self.categorized_files['insurance'])} insurance documents...")
            for file_data in self.categorized_files['insurance']:
                result = self.insurance_extractor.extract(file_data, building_id)
                if result and result.get('policy'):
                    insurance_policies.append(result['policy'])
                    print(f"     ✓ {file_data['file_name']}: Policy #{result['policy'].get('policy_number', 'N/A')}")

        if insurance_policies:
            self.mapped_data['insurance_policies'] = insurance_policies
            print(f"  ✅ Extracted {len(insurance_policies)} insurance policies")

        # Extract contracts and contractors
        contracts = []
        contractors = []
        maintenance_schedules = []

        if self.categorized_files.get('contracts'):
            print(f"  📋 Processing {len(self.categorized_files['contracts'])} contract documents...")
            for file_data in self.categorized_files['contracts']:
                result = self.contracts_extractor.extract(file_data, building_id)
                if result:
                    if result.get('contract'):
                        contracts.append(result['contract'])
                        print(f"     ✓ {file_data['file_name']}: {result['contract'].get('service_type', 'N/A')}")

                        # Extract contractor details if present
                        if result.get('contractor'):
                            contractors.append(result['contractor'])

                        # Generate maintenance schedules from contract frequency
                        contract = result['contract']
                        if contract.get('frequency'):
                            from extractors.maintenance_schedule_generator import MaintenanceScheduleGenerator
                            schedule_gen = MaintenanceScheduleGenerator()
                            schedules = schedule_gen.generate_from_contract(contract)
                            maintenance_schedules.extend(schedules)

        if contracts:
            self.mapped_data['contracts'] = contracts
            print(f"  ✅ Extracted {len(contracts)} service contracts")

        if contractors:
            # Deduplicate contractors
            from db.contractor_deduplicator import ContractorDeduplicator
            deduplicator = ContractorDeduplicator()
            dedup_result = deduplicator.deduplicate(contractors)
            self.mapped_data['contractors'] = dedup_result['new']
            print(f"  ✅ Extracted {len(dedup_result['new'])} unique contractors ({len(dedup_result['existing'])} duplicates skipped)")

        if maintenance_schedules:
            self.mapped_data['maintenance_schedules'] = maintenance_schedules
            print(f"  ✅ Generated {len(maintenance_schedules)} maintenance schedules")

        # Extract utilities
        utilities = []
        if self.categorized_files.get('utilities'):
            print(f"  📋 Processing {len(self.categorized_files['utilities'])} utility documents...")
            for file_data in self.categorized_files['utilities']:
                result = self.utilities_extractor.extract(file_data, building_id)
                if result and result.get('utility'):
                    utilities.append(result['utility'])
                    print(f"     ✓ {file_data['file_name']}: {result['utility'].get('utility_type', 'N/A')}")

        if utilities:
            self.mapped_data['utilities'] = utilities
            print(f"  ✅ Extracted {len(utilities)} utility accounts")

        # Extract meetings
        meetings = []
        if self.categorized_files.get('meetings'):
            print(f"  📋 Processing {len(self.categorized_files['meetings'])} meeting documents...")
            for file_data in self.categorized_files['meetings']:
                result = self.meetings_extractor.extract(file_data, building_id)
                if result and result.get('meeting'):
                    meetings.append(result['meeting'])
                    print(f"     ✓ {file_data['file_name']}: {result['meeting'].get('meeting_type', 'N/A')}")

        if meetings:
            self.mapped_data['meetings'] = meetings
            print(f"  ✅ Extracted {len(meetings)} meeting records")

        # Extract client money snapshots
        client_money = []
        if self.categorized_files.get('client_money'):
            print(f"  📋 Processing {len(self.categorized_files['client_money'])} client money documents...")
            for file_data in self.categorized_files['client_money']:
                result = self.client_money_extractor.extract(file_data, building_id)
                if result and result.get('snapshot'):
                    client_money.append(result['snapshot'])
                    print(f"     ✓ {file_data['file_name']}: Balance £{result['snapshot'].get('balance', 0):,.2f}")

        if client_money:
            self.mapped_data['client_money_snapshots'] = client_money
            print(f"  ✅ Extracted {len(client_money)} client money snapshots")

        # Extract assets from all documents
        assets = []
        print(f"  📋 Scanning all documents for building assets...")
        from extractors.assets_extractor import AssetsExtractor
        assets_extractor = AssetsExtractor()

        # Scan compliance, contracts, and other documents for asset mentions
        all_docs = []
        for category in ['compliance', 'contracts', 'insurance', 'legal']:
            if self.categorized_files.get(category):
                all_docs.extend(self.categorized_files[category])

        for file_data in all_docs:
            detected_assets = assets_extractor.extract(file_data, building_id)
            if detected_assets:
                assets.extend(detected_assets)
                print(f"     ✓ {file_data['file_name']}: Found {len(detected_assets)} asset(s)")

        if assets:
            # Link assets to compliance records if available
            compliance_assets = self.mapped_data.get('compliance_assets', [])
            for asset in assets:
                if compliance_assets:
                    compliance_id = assets_extractor.link_to_compliance(asset, compliance_assets)
                    if compliance_id:
                        asset['compliance_asset_id'] = compliance_id

            self.mapped_data['assets'] = assets
            print(f"  ✅ Extracted {len(assets)} building assets")

        # Create building-contractor links
        if contractors:
            building_contractor_links = []
            for contractor in contractors:
                link = {
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'contractor_id': contractor['id'],
                    'relationship_type': 'service_provider',
                    'is_preferred': False,
                    'notes': None
                }
                building_contractor_links.append(link)

            if building_contractor_links:
                self.mapped_data['building_contractor_links'] = building_contractor_links
                print(f"  ✅ Created {len(building_contractor_links)} building-contractor links")

        # Log audit
        self.audit_log.append({
            'timestamp': datetime.now().isoformat(),
            'action': 'extract_handover_intelligence',
            'insurance_policies': len(insurance_policies),
            'contracts': len(contracts),
            'contractors': len(contractors),
            'utilities': len(utilities),
            'meetings': len(meetings),
            'client_money_snapshots': len(client_money),
            'assets': len(assets),
            'maintenance_schedules': len(maintenance_schedules)
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

        # Print financial documents summary
        financial_docs = [doc for doc in self.mapped_data.get('building_documents', []) if doc.get('category') == 'finance']
        if financial_docs:
            print("\n" + "=" * 60)
            print("💰 FINANCIAL DOCUMENTS SUMMARY")
            print("=" * 60)
            print(f"\nDetected {len(financial_docs)} financial documents")

            # Collect financial years and periods
            financial_years = set()
            period_labels = set()
            for doc in financial_docs:
                if doc.get('financial_year'):
                    financial_years.add(doc['financial_year'])
                if doc.get('period_label'):
                    period_labels.add(doc['period_label'])

            if financial_years:
                years_sorted = sorted(list(financial_years))
                print(f"Financial Years Found: {', '.join(years_sorted)}")

            if period_labels:
                periods_sorted = sorted(list(period_labels))
                print(f"Period Labels Found: {', '.join(periods_sorted)}")

            print(f"\nInserted {len(financial_docs)} entries into building_documents ✅")
            print("\nFinancial Document Types:")

            # Categorize by type
            doc_types = {}
            for doc in financial_docs:
                filename_lower = doc['file_name'].lower()
                doc_type = 'Other'

                if 'budget' in filename_lower:
                    doc_type = 'Budget'
                elif 'variance' in filename_lower:
                    doc_type = 'Variance Report'
                elif 'apportionment' in filename_lower:
                    doc_type = 'Apportionment Schedule'
                elif 'account' in filename_lower:
                    doc_type = 'Service Charge Account'
                elif 'demand' in filename_lower:
                    doc_type = 'Service Charge Demand'

                doc_types[doc_type] = doc_types.get(doc_type, 0) + 1

            for doc_type, count in sorted(doc_types.items()):
                print(f"  • {doc_type}: {count}")

            print("=" * 60)

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

    def _generate_classification_summary(self):
        """Generate branded PDF summary of document classification"""
        from generate_classification_summary import generate_classification_summary

        try:
            result = generate_classification_summary(
                self.categorized_files,
                output_dir=str(self.output_dir)
            )

            if result.get('pdf_path'):
                print(f"  ✅ Classification summary PDF: {result['pdf_path']}")
            else:
                print(f"  ✅ Classification summary HTML: {result['html_path']}")
                print(f"     (Install wkhtmltopdf for PDF export)")

        except Exception as e:
            print(f"  ⚠️  Error generating classification summary: {e}")

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

    def _cleanup_parsed_data(self):
        """Clear large parsed data objects from memory"""
        print("\n🧹 Cleaning up memory...")

        # Clear parsed files data (largest memory consumer)
        if hasattr(self, 'parsed_files'):
            self.parsed_files.clear()

        # Clear categorized files
        if hasattr(self, 'categorized_files'):
            self.categorized_files.clear()

        # Clear raw data from mapped_data
        if hasattr(self, 'mapped_data'):
            for key in list(self.mapped_data.keys()):
                if key.endswith('_raw'):
                    del self.mapped_data[key]

        print("   ✓ Large objects cleared from memory")


def cleanup_memory():
    """Force garbage collection and clear memory"""
    import gc
    gc.collect()
    print("🧹 Memory cleaned")


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

    try:
        # Run onboarder
        onboarder = BlocIQOnboarder(args.client_folder, args.building_name)
        onboarder.run()
    finally:
        # Always cleanup memory on exit (success or error)
        cleanup_memory()


if __name__ == '__main__':
    main()
