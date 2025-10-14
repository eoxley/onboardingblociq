#!/usr/bin/env python3
"""
Test script for SQL Generator modules
"""

import sys
from pathlib import Path

# Add current directory to path
sys.path.insert(0, str(Path(__file__).parent))

def test_classifier():
    """Test document classifier"""
    print("Testing Classifier...")
    from classifier import DocumentClassifier

    classifier = DocumentClassifier()

    test_cases = [
        ('FRA_Report_2025.pdf', 'This is a fire risk assessment report completed on 4th March 2025'),
        ('EICR_2022.xlsx', 'Electrical Installation Condition Report periodic inspection'),
        ('Asbestos_Survey.pdf', 'Asbestos survey and management plan'),
        ('Insurance_Policy.pdf', 'Buildings insurance policy premium £5000'),
        ('Lift_Inspection.pdf', 'LOLER lift examination report'),
    ]

    for filename, text in test_cases:
        result = classifier.classify_document(filename, text)
        print(f"  ✓ {filename}: {result['document_type']} (confidence: {result['confidence']})")

    print()


def test_extractor():
    """Test metadata extractor"""
    print("Testing Extractor...")
    from extractor import MetadataExtractor

    extractor = MetadataExtractor()

    test_text = """
    Fire Risk Assessment Report

    Inspection Date: 4th March 2025
    Carried out by: TriFire Safety Ltd

    Overall Risk Rating: Low

    Next Inspection Due: 4th March 2026

    Reference Number: FRA-2025-001
    """

    result = extractor.extract_all(test_text, 'FRA')
    print("  Extracted metadata:")
    for key, value in result.items():
        if value:
            print(f"    • {key}: {value}")

    print()


def test_time_utils():
    """Test time utilities"""
    print("Testing Time Utilities...")
    from time_utils import RenewalCalculator

    calculator = RenewalCalculator()

    # Test FRA renewal (12 months)
    next_due = calculator.calculate_next_due('2025-03-04', 'FRA')
    print(f"  ✓ FRA next due: {next_due}")

    # Test EICR renewal (60 months)
    next_due = calculator.calculate_next_due('2022-01-15', 'EICR')
    print(f"  ✓ EICR next due: {next_due}")

    # Test status
    status = calculator.determine_status('2026-12-01')
    print(f"  ✓ Status for 2026-12-01: {status}")

    status = calculator.determine_status('2024-01-01')
    print(f"  ✓ Status for 2024-01-01: {status}")

    print()


def test_reporter():
    """Test report generator"""
    print("Testing Reporter...")
    from reporter import ReportGenerator

    generator = ReportGenerator()

    test_docs = [
        {
            'document_type': 'FRA',
            'file_name': 'FRA_2025.pdf',
            'inspection_date': '2025-03-04',
            'next_due_date': '2026-03-04',
            'status': 'current',
            'is_current': True,
            'contractor': 'TriFire Safety Ltd',
            'risk_rating': 'Low'
        },
        {
            'document_type': 'EICR',
            'file_name': 'EICR_2022.pdf',
            'inspection_date': '2022-01-15',
            'next_due_date': '2027-01-15',
            'status': 'current',
            'is_current': True
        }
    ]

    # Test JSON generation
    json_path = '/tmp/test_metadata.json'
    generator.generate_json_report('Test Building', test_docs, json_path)
    print(f"  ✓ Generated JSON: {json_path}")

    # Test SQL generation
    sql_path = '/tmp/test_generated.sql'
    generator.generate_sql_file('Test Building', test_docs, sql_path)
    print(f"  ✓ Generated SQL: {sql_path}")

    print()


def main():
    """Run all tests"""
    print("="*60)
    print("SQL Generator - Module Tests")
    print("="*60)
    print()

    try:
        test_classifier()
        test_extractor()
        test_time_utils()
        test_reporter()

        print("="*60)
        print("✅ All tests passed!")
        print("="*60)

    except Exception as e:
        print(f"\n❌ Test failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
