#!/usr/bin/env python3
"""
Quick test script to verify insurance document classification fix
"""

import sys
import os
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from classifier import DocumentClassifier
from parsers import PDFParser

def test_insurance_files():
    """Test insurance classification on specific files"""

    # Initialize classifier
    classifier = DocumentClassifier()

    # Test files that were being misclassified
    test_files = [
        "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/11. HANDOVER/Moved Over/Policy Limits Document.pdf",
        "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/11. HANDOVER/Moved Over/Real Estate Insurance NTP (01.23).pdf",
        "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/11. HANDOVER/Moved Over/Real Estate Policy (01.23).pdf",
        "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/11. HANDOVER/Moved Over/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf",
        "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/11. HANDOVER/Moved Over/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf",
    ]

    print("=" * 80)
    print("🧪 BlocIQ Insurance Classification Test")
    print("=" * 80)
    print()

    results = []

    for file_path in test_files:
        if not os.path.exists(file_path):
            print(f"⚠️  File not found: {file_path}")
            continue

        filename = os.path.basename(file_path)
        print(f"Testing: {filename}")

        # Parse the file using PDFParser
        try:
            parser = PDFParser(file_path)
            parsed_data = parser.parse()

            # Debug: Print first 200 chars of content
            content = classifier._extract_content(parsed_data)[:200]
            print(f"  Content preview: {content}")

            # Classify
            category, confidence = classifier.classify(parsed_data)

            # Check if it's correctly classified as insurance
            status = "✅ PASS" if category == "insurance" else "❌ FAIL"

            print(f"  {status} - Category: {category}, Confidence: {confidence:.2f}")

            results.append({
                'file': filename,
                'category': category,
                'confidence': confidence,
                'expected': 'insurance',
                'passed': category == 'insurance'
            })

        except Exception as e:
            print(f"  ❌ ERROR: {e}")
            results.append({
                'file': filename,
                'category': 'error',
                'confidence': 0.0,
                'expected': 'insurance',
                'passed': False
            })

        print()

    # Summary
    print("=" * 80)
    print("📊 Test Summary")
    print("=" * 80)
    print()

    total = len(results)
    passed = sum(1 for r in results if r['passed'])
    failed = total - passed

    print(f"Total Tests: {total}")
    print(f"✅ Passed: {passed}")
    print(f"❌ Failed: {failed}")
    print()

    if failed > 0:
        print("Failed Files:")
        for r in results:
            if not r['passed']:
                print(f"  • {r['file']} -> {r['category']} (expected: {r['expected']})")
        print()

    print("=" * 80)

    return passed == total

if __name__ == "__main__":
    success = test_insurance_files()
    sys.exit(0 if success else 1)
