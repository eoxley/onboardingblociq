#!/usr/bin/env python3
"""
SQL Generator - Main Orchestrator
Process folder of documents and generate metadata JSON + SQL outputs
"""

import sys
import argparse
import logging
from pathlib import Path
from datetime import datetime
from typing import Dict, List

from reader import FileReader, scan_folder
from classifier import DocumentClassifier
from extractor import MetadataExtractor
from extractor_building_description import BuildingDescriptionExtractor
from time_utils import (
    RenewalCalculator,
    DocumentStatusManager,
    load_expected_documents
)
from reporter import ReportGenerator


class SQLGenerator:
    """Main orchestrator for SQL generation process"""

    def __init__(self, output_dir: str = None):
        """
        Initialize SQL Generator

        Args:
            output_dir: Directory for outputs (default: ./outputs)
        """
        self.reader = FileReader(ocr_enabled=True)
        self.classifier = DocumentClassifier()
        self.extractor = MetadataExtractor()
        self.building_extractor = BuildingDescriptionExtractor()
        self.renewal_calc = RenewalCalculator()
        self.status_manager = DocumentStatusManager(self.renewal_calc)
        self.reporter = ReportGenerator()

        # Setup output directory
        if output_dir:
            self.output_dir = Path(output_dir)
        else:
            self.output_dir = Path(__file__).parent / 'outputs'

        self.output_dir.mkdir(parents=True, exist_ok=True)

        # Setup logging
        self.log_dir = Path(__file__).parent / 'logs'
        self.log_dir.mkdir(parents=True, exist_ok=True)

    def setup_logging(self, building_name: str):
        """Setup logging for this run"""
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        log_file = self.log_dir / f"{building_name}_{timestamp}.log"

        logging.basicConfig(
            level=logging.INFO,
            format='[%(asctime)s] %(message)s',
            datefmt='%H:%M:%S',
            handlers=[
                logging.FileHandler(log_file),
                logging.StreamHandler(sys.stdout)
            ]
        )

        return log_file

    def process_folder(
        self,
        folder_path: str,
        building_name: str = None,
        building_config: Dict = None
    ) -> Dict:
        """
        Process entire folder and generate outputs

        Args:
            folder_path: Path to folder containing documents
            building_name: Name of building (default: folder name)
            building_config: Building configuration (e.g., has_lifts, over_11m)

        Returns:
            Dictionary with processing results
        """
        # Use folder name as building name if not provided
        if not building_name:
            building_name = Path(folder_path).name

        # Setup logging
        log_file = self.setup_logging(building_name)
        logging.info(f"Starting SQL Generator for: {building_name}")
        logging.info(f"Folder: {folder_path}")
        logging.info("")

        # Step 1: Scan folder
        logging.info("Step 1: Scanning folder...")
        files = scan_folder(folder_path, recursive=True)
        logging.info(f"Found {len(files)} files")
        logging.info("")

        # Step 2: Process each file
        logging.info("Step 2: Reading and classifying files...")
        documents = []

        for i, file_path in enumerate(files, 1):
            try:
                # Read file
                file_data = self.reader.read_file(file_path)

                if not file_data.get('success'):
                    logging.warning(f"  [{i}/{len(files)}] ⚠️  Failed to read: {file_data['file_name']}")
                    continue

                text = file_data.get('text', '')

                # Classify document
                classification = self.classifier.classify_document(file_path, text)

                # Extract metadata
                metadata = self.extractor.extract_all(
                    text,
                    classification['document_type']
                )

                # Combine data
                doc = {
                    'file_name': file_data['file_name'],
                    'file_path': file_path,
                    'document_type': classification['document_type'],
                    'classification_confidence': classification['confidence'],
                    **metadata
                }

                documents.append(doc)

                # Log progress
                doc_type = classification['document_type']
                conf = classification['confidence']
                logging.info(f"  [{i}/{len(files)}] {file_data['file_name'][:50]:<50} → {doc_type} ({conf:.2f})")

            except Exception as e:
                logging.error(f"  [{i}/{len(files)}] ❌ Error processing {Path(file_path).name}: {e}")

        logging.info("")
        logging.info(f"Successfully processed {len(documents)} documents")
        logging.info("")

        # Step 3: Calculate renewal dates and status
        logging.info("Step 3: Calculating renewal dates and status...")
        documents = self.status_manager.process_documents(documents)

        # Count statuses
        status_counts = {}
        for doc in documents:
            status = doc.get('status', 'unknown')
            status_counts[status] = status_counts.get(status, 0) + 1

        for status, count in status_counts.items():
            logging.info(f"  {status.replace('_', ' ').title()}: {count}")

        logging.info("")

        # Step 3.5: Extract building description (aggregate across all docs)
        logging.info("Step 3.5: Extracting building description...")

        # Prepare document data with text for building extractor
        docs_for_building = []
        for doc in documents:
            file_path = doc.get('file_path')
            doc_type = doc.get('document_type')

            # Re-read text if needed (it might not be in doc dict)
            try:
                file_data = self.reader.read_file(file_path)
                text = file_data.get('text', '')
                docs_for_building.append({
                    'text': text,
                    'document_type': doc_type
                })
            except:
                pass

        building_profile = self.building_extractor.extract_from_documents(docs_for_building)

        # Log building description summary
        logging.info(f"  Building Type: {building_profile.get('building_age_or_type', 'Unknown')}")
        if building_profile.get('num_floors'):
            logging.info(f"  Floors: {building_profile['num_floors']}")
        if building_profile.get('num_lifts'):
            logging.info(f"  Lifts: {building_profile['num_lifts']}")
        if building_profile.get('amenities'):
            logging.info(f"  Amenities: {', '.join(building_profile['amenities'][:3])}")
        logging.info(f"  Confidence: {building_profile.get('confidence', 0.0)}")

        logging.info("")

        # Step 4: Identify missing documents
        logging.info("Step 4: Checking for missing documents...")
        expected_docs = load_expected_documents(building_config=building_config)
        missing_docs = self.status_manager.identify_missing_documents(
            documents,
            expected_docs
        )

        if missing_docs:
            logging.info(f"  Found {len(missing_docs)} missing documents:")
            for doc in missing_docs:
                logging.info(f"    • {doc['document_type']}")
            # Add missing documents to the list
            documents.extend(missing_docs)
        else:
            logging.info("  All required documents present")

        logging.info("")

        # Step 5: Generate outputs
        logging.info("Step 5: Generating outputs...")

        # Clean building name for filenames
        safe_name = "".join(c for c in building_name if c.isalnum() or c in (' ', '-', '_')).strip()
        safe_name = safe_name.replace(' ', '_')

        # Generate JSON metadata (with building profile)
        json_path = self.output_dir / f"{safe_name}_metadata.json"
        self.reporter.generate_json_report(building_name, documents, str(json_path), building_profile)
        logging.info(f"  ✓ JSON metadata: {json_path}")

        # Generate SQL
        sql_path = self.output_dir / f"{safe_name}_generated.sql"
        self.reporter.generate_sql_file(building_name, documents, str(sql_path))
        logging.info(f"  ✓ SQL file: {sql_path}")

        # Generate CSV summary
        csv_path = self.output_dir / f"{safe_name}_summary.csv"
        self.reporter.generate_summary_csv(documents, str(csv_path))
        logging.info(f"  ✓ CSV summary: {csv_path}")

        # Generate HTML report
        html_path = self.output_dir / f"{safe_name}_report.html"
        self.reporter.generate_html_report(building_name, documents, str(html_path))
        logging.info(f"  ✓ HTML report: {html_path}")

        logging.info("")
        logging.info(f"✅ Complete! Log saved to: {log_file}")
        logging.info("")

        return {
            'building_name': building_name,
            'total_files': len(files),
            'processed_documents': len(documents),
            'missing_documents': len(missing_docs),
            'outputs': {
                'json': str(json_path),
                'sql': str(sql_path),
                'csv': str(csv_path),
                'html': str(html_path),
                'log': str(log_file)
            }
        }


def main():
    """CLI entry point"""
    parser = argparse.ArgumentParser(
        description='SQL Generator - Process building documents and generate metadata'
    )
    parser.add_argument(
        'folder',
        help='Path to folder containing building documents'
    )
    parser.add_argument(
        '--building-name',
        help='Name of the building (default: folder name)'
    )
    parser.add_argument(
        '--output-dir',
        help='Output directory for generated files (default: ./outputs)'
    )
    parser.add_argument(
        '--has-lifts',
        action='store_true',
        help='Building has lifts (requires LOLER)'
    )
    parser.add_argument(
        '--over-11m',
        action='store_true',
        help='Building is over 11m tall (requires Safety Case)'
    )
    parser.add_argument(
        '--has-gas',
        action='store_true',
        help='Building has gas supply (requires Gas Safety)'
    )

    args = parser.parse_args()

    # Validate folder
    if not Path(args.folder).exists():
        print(f"❌ Error: Folder not found: {args.folder}")
        sys.exit(1)

    # Build configuration
    building_config = {
        'has_lifts': args.has_lifts,
        'over_11m': args.over_11m,
        'has_gas': args.has_gas,
        'has_communal_electrics': True  # Default assumption
    }

    # Initialize generator
    generator = SQLGenerator(output_dir=args.output_dir)

    # Process folder
    try:
        result = generator.process_folder(
            args.folder,
            building_name=args.building_name,
            building_config=building_config
        )

        print("\n" + "="*60)
        print("📊 PROCESSING SUMMARY")
        print("="*60)
        print(f"Building: {result['building_name']}")
        print(f"Files scanned: {result['total_files']}")
        print(f"Documents processed: {result['processed_documents']}")
        print(f"Missing documents: {result['missing_documents']}")
        print("\n📁 Output Files:")
        for output_type, path in result['outputs'].items():
            print(f"  • {output_type.upper()}: {path}")
        print("="*60)

    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
