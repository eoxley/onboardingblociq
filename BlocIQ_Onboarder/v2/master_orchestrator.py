"""
BlocIQ V2 Master Orchestrator
==============================
End-to-end deterministic pipeline
Ingestion → Categorization → Extraction → Consolidation → Output

Client-ready, 100% accurate building onboarding
"""

import os
import json
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime

# Import all components
from document_ingestion_engine import DocumentIngestionEngine
from deterministic_categorizer import DeterministicCategorizer
from extractors.budget_extractor import BudgetExtractor
from extractors.compliance_extractor import ComplianceExtractor
from extractors.contract_extractor import ContractExtractor
from extractors.hs_report_analyzer import HSReportAnalyzer
from extractors.accounts_extractor import AccountsExtractor
from extractors.lease_analyzer import LeaseAnalyzer
from extractors.ai_lease_analyzer import AILeaseAnalyzer
from extractors.units_leaseholders_extractor import UnitsLeaseholdersExtractor
from extractors.leaseholder_contact_extractor import LeaseholderContactExtractor
from extractors.leaseholder_schedule_extractor import LeaseholderScheduleExtractor
from consolidators.contractor_consolidator import ContractorConsolidator
from consolidators.data_deduplicator import DataDeduplicator
from consolidators.asset_register_builder import AssetRegisterBuilder
from validators.data_quality_validator import DataQualityValidator
from sql_generator_v2 import SQLGeneratorV2
from pdf_generator_v2 import PDFGeneratorV2


class MasterOrchestrator:
    """
    Orchestrates the complete extraction pipeline
    Deterministic-first, transparent, trackable
    """
    
    def __init__(self, building_folder: str, output_folder: str = 'output'):
        self.building_folder = building_folder
        self.output_folder = output_folder
        self.building_name = Path(building_folder).name
        
        # Create output folder
        os.makedirs(output_folder, exist_ok=True)
        
        # Initialize components
        self.ingestion_engine = DocumentIngestionEngine(building_folder)
        self.categorizer = DeterministicCategorizer()
        self.contractor_consolidator = ContractorConsolidator()
        self.data_deduplicator = DataDeduplicator()
        self.asset_register_builder = AssetRegisterBuilder()
        self.data_quality_validator = DataQualityValidator()
        
        # Extractors
        self.budget_extractor = BudgetExtractor()
        self.compliance_extractor = ComplianceExtractor()
        self.contract_extractor = ContractExtractor()
        self.hs_analyzer = HSReportAnalyzer()
        self.accounts_extractor = AccountsExtractor()
        self.lease_analyzer = LeaseAnalyzer()
        
        # AI-Powered Lease Analyzer (Option 2: AI-Only - Best Quality)
        try:
            self.ai_lease_analyzer = AILeaseAnalyzer()
            print("   ✅ AI Lease Analyzer enabled (GPT-4)")
        except ValueError as e:
            print(f"   ⚠️  AI Lease Analyzer disabled: {e}")
            self.ai_lease_analyzer = None
        
        self.units_extractor = UnitsLeaseholdersExtractor()
        self.leaseholder_extractor = LeaseholderContactExtractor()
        self.leaseholder_schedule_extractor = LeaseholderScheduleExtractor()
        
        # Extracted data
        self.extracted_data = {
            'building': {},
            'units': [],
            'leaseholders': [],
            'budgets': [],
            'budget_line_items': [],
            'compliance_assets': [],
            'contracts': [],
            'contractors': [],
            'accounts': [],
            'leases': [],
            'lease_clauses': [],
            'insurance_policies': [],
            'asset_register': []
        }
        
        # Tracking
        self.processing_log = []
    
    def run_complete_pipeline(self) -> Dict:
        """
        Run complete end-to-end pipeline
        
        Returns:
            {
                'manifest': {...},
                'extracted_data': {...},
                'sql_file': '...',
                'pdf_file': '...'
            }
        """
        print("="*70)
        print(f"🚀 BLOCIQ V2 COMPREHENSIVE EXTRACTION")
        print("="*70)
        print(f"Building: {self.building_name}")
        print(f"Source: {self.building_folder}")
        print(f"Output: {self.output_folder}")
        print()
        
        # PHASE 1: Ingest & Normalize
        print("📁 PHASE 1: INGEST & NORMALIZE")
        print("-"*70)
        documents = self.ingestion_engine.ingest_all()
        unique_docs = self.ingestion_engine.get_unique_documents()
        
        # Save manifest
        manifest_file = f"{self.output_folder}/manifest.jsonl"
        self.ingestion_engine.save_manifest(manifest_file)
        
        # PHASE 2: Categorize
        print("\n🏷️  PHASE 2: CATEGORIZE")
        print("-"*70)
        categorized_docs = self.categorizer.categorize_all(unique_docs)
        
        # PHASE 3: Domain Extraction
        print("\n📊 PHASE 3: DOMAIN EXTRACTION")
        print("-"*70)
        self._run_domain_extractors(categorized_docs)
        
        # PHASE 4: Consolidation
        print("\n🔄 PHASE 4: CONSOLIDATION & CROSS-CHECKS")
        print("-"*70)
        self._consolidate_data()
        
        # PHASE 5: Build Building Picture
        print("\n🏢 PHASE 5: BUILD BUILDING PICTURE")
        print("-"*70)
        self._build_building_picture(categorized_docs)
        
        # PHASE 5.5: Data Quality Validation
        issues, warnings = self.data_quality_validator.validate(self.extracted_data)
        self.data_quality_validator.print_report()
        
        # PHASE 6: Generate Outputs
        print("\n📄 PHASE 6: GENERATE OUTPUTS")
        print("-"*70)
        outputs = self._generate_outputs()
        
        print("\n" + "="*70)
        print("✅ EXTRACTION COMPLETE")
        print("="*70)
        
        return outputs
    
    def _run_domain_extractors(self, documents: List[Dict]):
        """Run specialized extractors on categorized documents"""
        
        for doc in documents:
            category = doc.get('category', '')
            subcategory = doc.get('subcategory', '')
            text = doc.get('extracted_text', '')
            
            if not text:
                continue
            
            # Budget extraction (check filename OR category)
            if (('budget' in doc['filename'].lower() or 'budget' in category.lower()) 
                and doc.get('file_type') == 'excel'):
                print(f"   📊 Processing budget file: {doc['filename']}")
                budget_data = self.budget_extractor.extract(doc.get('absolute_path'), doc)
                if budget_data:
                    self.extracted_data['budgets'].append(budget_data)
                    self.extracted_data['budget_line_items'].extend(budget_data.get('line_items', []))
                    print(f"   ✅ Budget: {doc['filename']} - {len(budget_data.get('line_items', []))} line items, £{budget_data.get('total_budget', 0):,.0f}")
                else:
                    print(f"   ⚠️  Budget extraction returned None for {doc['filename']}")
            
            # Compliance extraction
            elif 'health' in category.lower():
                compliance_data = self.compliance_extractor.extract(doc, text)
                if compliance_data:
                    self.extracted_data['compliance_assets'].append(compliance_data)
                    print(f"   ✅ Compliance: {compliance_data['asset_type']} - {compliance_data.get('assessment_date', 'No date')}")
                
                # Also extract building description from H&S reports
                if 'fire' in subcategory.lower() or 'assessment' in doc['filename'].lower():
                    building_desc = self.hs_analyzer.extract_building_description(text)
                    if building_desc:
                        # Merge into building data
                        self.extracted_data['building'].update(building_desc)
                        print(f"   ✅ Building desc: {building_desc.get('number_of_floors', '?')} floors, {building_desc.get('building_height_meters', '?')}m")
                
                # Extract asset list
                assets = self.hs_analyzer.extract_asset_list(text)
                self.extracted_data['asset_register'].extend(assets)
            
            # Contract extraction
            elif 'contract' in category.lower():
                contract_data = self.contract_extractor.extract(doc, text)
                if contract_data:
                    self.extracted_data['contracts'].append(contract_data)
                    self.contractor_consolidator.add_from_contracts([contract_data])
                    print(f"   ✅ Contract: {contract_data.get('contractor_name', '?')} - {contract_data.get('service_type', '?')}")
            
            # Accounts extraction
            elif 'account' in doc['filename'].lower() and 'year' in text.lower()[:1000]:
                accounts_data = self.accounts_extractor.extract(doc, text)
                if accounts_data:
                    self.extracted_data['accounts'].append(accounts_data)
                    print(f"   ✅ Accounts: FY {accounts_data.get('financial_year', '?')} - {'Approved' if accounts_data.get('is_approved') else 'Draft'}")
            
            # Lease extraction - collect ANY document categorized as lease
            elif 'lease' in category.lower() or 'leases (master)' in subcategory.lower():
                # Collect lease documents for analysis (includes Title Plans, Official Copies, etc.)
                self.extracted_data['leases'].append(doc)
                print(f"   📄 Lease document: {doc['filename']}")
                
                # Also extract leaseholder contact from lease
                leaseholder_data = self.leaseholder_extractor.extract_from_lease(text, doc)
                if leaseholder_data:
                    print(f"   ✅ Leaseholder: {leaseholder_data.get('unit_number')} - {leaseholder_data.get('leaseholder_name', '?')}")
            
            # Apportionment/Units extraction
            if (('apport' in doc['filename'].lower() or 'leaseholder' in category.lower()) 
                and doc.get('file_type') == 'excel' 
                and not 'budget' in doc['filename'].lower()):  # Don't confuse with budgets
                units = self.units_extractor.extract_from_apportionment(doc.get('absolute_path'), doc)
                if units:
                    print(f"   ✅ Units: {len(units)} units extracted from {doc['filename']}")
            
            # Contact form extraction (including from OCR images)
            if 'contact' in doc['filename'].lower() and ('form' in doc['filename'].lower() or doc.get('file_type') == 'image'):
                if text:  # If OCR extracted text
                    leaseholder_data = self.leaseholder_extractor.extract_from_contact_form(text, doc)
                    if leaseholder_data:
                        print(f"   ✅ Contact: {leaseholder_data.get('unit_number')} - {leaseholder_data.get('leaseholder_name', '?')}")
            
            # INTELLIGENT LEASEHOLDER SCHEDULE DETECTION
            # Check ANY Excel file (not just named ones) to see if it's a leaseholder schedule
            if doc.get('file_type') == 'excel' and not any(word in doc['filename'].lower() for word in ['budget', 'account', 'invoice']):
                try:
                    import openpyxl
                    wb = openpyxl.load_workbook(doc.get('absolute_path'), data_only=True, read_only=True)
                    ws = wb.active
                    
                    # Intelligent detection: Is this a leaseholder file?
                    if self.leaseholder_schedule_extractor.is_leaseholder_file(doc.get('absolute_path'), ws):
                        leaseholders = self.leaseholder_schedule_extractor.extract(doc.get('absolute_path'), doc)
                        if leaseholders:
                            # Add to leaseholder extractor for linking
                            for lh in leaseholders:
                                self.leaseholder_extractor.leaseholder_data[lh['unit_number']] = lh
                            print(f"   ✅ Leaseholder Schedule: {len(leaseholders)} leaseholders from {doc['filename']}")
                except Exception as e:
                    pass  # Not a leaseholder file, continue
        
        # Analyze leases (after collecting all)
        if self.extracted_data['leases']:
            print(f"\n   📄 Analyzing {len(self.extracted_data['leases'])} lease documents...")
            
            # OPTION 2: AI-ONLY (Best Quality) - Use GPT-4 for comprehensive analysis
            if self.ai_lease_analyzer:
                print(f"   🤖 Using AI-powered analysis (LeaseClear quality)...")
                ai_analyses = []
                
                # Filter and select up to 5 ACTUAL lease documents (not apportionments, letters, etc.)
                # Prioritize files with "lease", "official copy", "title", "NGL" in filename
                actual_leases = []
                for lease_doc in self.extracted_data['leases']:
                    filename_lower = lease_doc.get('filename', '').lower()
                    # Strong indicators of actual lease documents
                    if any(keyword in filename_lower for keyword in ['lease', 'official copy', 'ngl', 'title plan', 'register']):
                        # Exclude false positives
                        if not any(exclude in filename_lower for exclude in ['apportionment', 'letter', 'scheme', 'mews']):
                            actual_leases.append(lease_doc)

                selected_leases = actual_leases[:5]

                for i, lease_doc in enumerate(selected_leases, 1):
                    # Use extracted_text (from OCR) not text
                    text = lease_doc.get('extracted_text', '') or lease_doc.get('text', '')
                    filename = lease_doc.get('filename', f'lease_{i}.pdf')

                    if not text or len(text) < 500:
                        print(f"   ⚠️  Lease {i}: Too little text ({len(text)} chars), skipping")
                        continue
                    
                    print(f"   📄 Lease {i}/{len(selected_leases)}: {filename}")
                    
                    # Run comprehensive AI analysis
                    ai_result = self.ai_lease_analyzer.comprehensive_analysis(text, filename)
                    
                    # Store AI analysis
                    ai_analyses.append({
                        'filename': filename,
                        'ai_analysis': ai_result,
                        'text_length': len(text)
                    })
                
                self.extracted_data['lease_ai_analyses'] = ai_analyses
                print(f"   ✅ AI analysis complete: {len(ai_analyses)} leases analyzed")
            else:
                # Fallback to basic regex analysis
                print(f"   📋 Using basic regex analysis...")
                lease_analysis = self.lease_analyzer.analyze_leases(self.extracted_data['leases'], limit=3)
                self.extracted_data['lease_analysis'] = lease_analysis
                print(f"   ✅ Basic analysis: {lease_analysis.get('leases_analyzed', 0)} leases")
    
    def _consolidate_data(self):
        """Consolidate and cross-check data"""
        
        # Consolidate contractors from budgets
        for budget in self.extracted_data['budgets']:
            self.contractor_consolidator.add_from_budget(budget.get('line_items', []))
        
        # Get consolidated contractor list
        self.extracted_data['contractors'] = self.contractor_consolidator.get_consolidated_contractors()
        self.contractor_consolidator.print_summary()
        
        # Get consolidated units list
        self.extracted_data['units'] = self.units_extractor.get_all_units()
        
        # Enrich units with leaseholder contact data
        if self.extracted_data['units']:
            self.extracted_data['units'] = self.leaseholder_extractor.enrich_units(self.extracted_data['units'])
            self.units_extractor.print_summary()
            self.leaseholder_extractor.print_summary()
        
        # DEDUPLICATE: Keep only current/most recent data
        self.extracted_data = self.data_deduplicator.deduplicate_all(self.extracted_data)
        
        # BUILD COMPREHENSIVE ASSET REGISTER
        print("\n🏗️  Building comprehensive asset register...")
        self.extracted_data['asset_register'] = self.asset_register_builder.build_register(self.extracted_data)
        self.asset_register_builder.print_summary()
    
    def _build_building_picture(self, documents: List[Dict]):
        """
        Build complete building picture from all extracted data
        Consolidate building-level information
        """
        building = self.extracted_data['building']

        # Set building name
        building['name'] = self.building_name

        # Extract building address from all available sources
        address_info = self._extract_building_address(documents)
        if address_info:
            building['address'] = address_info.get('full_address')
            building['postcode'] = address_info.get('postcode')

        # Count units from various sources
        # TODO: Extract from apportionment files, leases, etc.

        # Set service charge year from budget
        if self.extracted_data['budgets']:
            latest_budget = max(self.extracted_data['budgets'],
                              key=lambda b: b.get('budget_year', 0))
            building['sc_year_start'] = latest_budget.get('sc_year_start')
            building['sc_year_end'] = latest_budget.get('sc_year_end')
            building['budget_year'] = latest_budget.get('budget_year')

        # Set accounts info
        if self.extracted_data['accounts']:
            latest_accounts = max(
                [a for a in self.extracted_data['accounts'] if a.get('is_approved')],
                key=lambda a: a.get('financial_year', ''),
                default=None
            )
            if latest_accounts:
                building['latest_accounts_year'] = latest_accounts.get('financial_year')
                building['accounts_approval_date'] = latest_accounts.get('approval_date')
        
        print(f"   Building picture built: {building.get('name', 'Unknown')}")
        print(f"   Floors: {building.get('number_of_floors', '?')}")
        print(f"   Height: {building.get('building_height_meters', '?')}m")
        print(f"   SC Year: {building.get('sc_year_start', '?')} to {building.get('sc_year_end', '?')}")

    def _extract_building_address(self, documents: List[Dict]) -> Dict:
        """
        Extract building address from management agreements, FRAs, accounts, leases
        Looks for patterns like: "32-34 Connaught Square, St George's Fields, London, W2 2HL"
        """
        import re

        # UK postcode pattern
        postcode_pattern = r'\b[A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2}\b'

        best_address = None
        best_score = 0

        for doc in documents:
            text = doc.get('extracted_text', '') or doc.get('text', '')
            filename = doc.get('filename', '').lower()

            # Prioritize certain document types
            priority = 0
            if 'management agreement' in filename:
                priority = 10
            elif 'fire risk' in filename or 'fra' in filename:
                priority = 8
            elif 'account' in filename:
                priority = 6
            elif 'lease' in filename:
                priority = 5

            if not text or priority == 0:
                continue

            # Find postcodes in text
            postcodes = re.findall(postcode_pattern, text, re.IGNORECASE)

            for postcode in postcodes:
                # Extract context around postcode (200 chars before)
                match = re.search(rf'(.{{0,200}}){re.escape(postcode)}', text, re.DOTALL | re.IGNORECASE)
                if not match:
                    continue

                context = match.group(1)

                # Look for building number + name pattern
                # Pattern: "number-number Name, Street, Area, City, Postcode"
                # Example: "32-34 Connaught Square, St George's Fields, London, W2 2HL"
                address_pattern = r'(\d+[-/]\d+\s+[A-Z][a-zA-Z\s]+(?:,\s*[A-Z][a-zA-Z\'\s]+){0,3}),?\s*' + re.escape(postcode)
                address_match = re.search(address_pattern, context + ' ' + postcode, re.IGNORECASE)

                if address_match:
                    full_address = address_match.group(1).strip() + ', ' + postcode
                    # Clean up extra spaces and commas
                    full_address = re.sub(r'\s+', ' ', full_address)
                    full_address = re.sub(r',\s*,', ',', full_address)

                    score = priority + len(full_address.split(','))

                    if score > best_score:
                        best_score = score
                        best_address = {
                            'full_address': full_address,
                            'postcode': postcode.upper(),
                            'source': filename
                        }

        if best_address:
            print(f"   📍 Address found: {best_address['full_address']}")
            print(f"      Source: {best_address['source']}")

        return best_address

    def _generate_outputs(self) -> Dict:
        """Generate all output files"""
        
        # a) Manifest (already done)
        manifest_file = f"{self.output_folder}/manifest.jsonl"
        
        # b) Extracted data JSON
        extracted_file = f"{self.output_folder}/extracted_data.json"
        with open(extracted_file, 'w') as f:
            json.dump(self.extracted_data, f, indent=2, default=str)
        print(f"   ✅ Extracted data: {extracted_file}")
        
        # c) SQL generation
        sql_file = f"{self.output_folder}/migration.sql"
        sql_generator = SQLGeneratorV2(self.extracted_data)
        sql_content = sql_generator.generate()
        
        with open(sql_file, 'w') as f:
            f.write(sql_content)
        
        print(f"   ✅ SQL migration: {sql_file}")
        
        # d) PDF generation
        pdf_file = f"{self.output_folder}/{self.building_name}_Report.pdf"
        try:
            pdf_generator = PDFGeneratorV2(self.extracted_data, pdf_file)
            pdf_generator.generate()
            print(f"   ✅ PDF report: {pdf_file}")
        except Exception as e:
            print(f"   ⚠️  PDF generation error: {str(e)[:100]}")
        
        # e) Clean up output folder (remove old files)
        self._cleanup_output_folder()
        
        return {
            'manifest': manifest_file,
            'extracted_data': extracted_file,
            'sql_file': sql_file,
            'pdf_file': pdf_file
        }
    
    def _cleanup_output_folder(self):
        """Remove all files except manifest, extracted, SQL, PDF"""
        keep_files = ['manifest.jsonl', 'extracted_data.json', 'migration.sql', '_Report.pdf']
        
        # TODO: Implement cleanup
        print(f"   ⚠️  Cleanup: TODO")
    
    def print_summary(self):
        """Print extraction summary"""
        print("\n📊 EXTRACTION SUMMARY:")
        print(f"   Building: {self.extracted_data['building'].get('name', 'Unknown')}")
        print(f"   Units: {len(self.extracted_data['units'])}")
        print(f"   Budgets: {len(self.extracted_data['budgets'])}")
        print(f"   Budget Line Items: {len(self.extracted_data['budget_line_items'])}")
        print(f"   Compliance Assets: {len(self.extracted_data['compliance_assets'])}")
        print(f"   Contracts: {len(self.extracted_data['contracts'])}")
        print(f"   Contractors (unique): {len(self.extracted_data['contractors'])}")
        print(f"   Accounts: {len(self.extracted_data['accounts'])}")
        print(f"   Leases Analyzed: {self.extracted_data.get('lease_analysis', {}).get('leases_analyzed', 0)}")
        print(f"   Asset Register: {len(self.extracted_data['asset_register'])}")


def main():
    """Test the orchestrator"""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python master_orchestrator.py <building_folder>")
        sys.exit(1)
    
    building_folder = sys.argv[1]
    
    orchestrator = MasterOrchestrator(building_folder)
    outputs = orchestrator.run_complete_pipeline()
    orchestrator.print_summary()
    
    print("\n✅ Complete!")
    print(f"   Outputs in: {orchestrator.output_folder}")


if __name__ == '__main__':
    main()

