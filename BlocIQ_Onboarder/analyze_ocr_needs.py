#!/usr/bin/env python3
"""
Analyze OCR needs for Connaught Square documents
Using presence-first categorization
"""

import sys
from pathlib import Path
from collections import defaultdict
import pdfplumber

from document_categories import (
    classify_document, needs_ocr, get_ocr_priority,
    CATEGORIES
)


def analyze_folder(folder_path: str):
    """Analyze all PDFs in folder and determine OCR needs"""

    folder = Path(folder_path)
    pdf_files = list(folder.rglob("*.pdf"))

    print(f"📁 Analyzing: {folder_path}")
    print(f"📄 Found {len(pdf_files)} PDF files\n")

    # Track stats
    category_counts = defaultdict(int)
    ocr_needed = defaultdict(list)
    ocr_not_needed = defaultdict(list)
    total_ocr_required = 0

    for pdf_path in pdf_files:
        try:
            # Extract first 2 pages for classification
            text_sample = ""
            with pdfplumber.open(pdf_path) as pdf:
                num_pages = min(2, len(pdf.pages))
                for i in range(num_pages):
                    page_text = pdf.pages[i].extract_text()
                    if page_text:
                        text_sample += page_text + "\n"

            # Classify
            category = classify_document(pdf_path.name, text_sample)
            category_counts[category] += 1

            # Check if OCR needed
            if needs_ocr(text_sample, category):
                ocr_needed[category].append(pdf_path.name)
                total_ocr_required += 1
            else:
                ocr_not_needed[category].append(pdf_path.name)

        except Exception as e:
            print(f"   ⚠️  Error processing {pdf_path.name}: {e}")
            continue

    # Print summary
    print("="*80)
    print("📊 DOCUMENT CATEGORIZATION")
    print("="*80)

    for category in sorted(category_counts.keys(), key=lambda c: get_ocr_priority(c)):
        count = category_counts[category]
        config = CATEGORIES[category]
        priority = get_ocr_priority(category)
        ocr_count = len(ocr_needed[category])

        score_marker = "✅" if config.score_relevant else "⏭️ "

        print(f"\n{score_marker} {category.upper().replace('_', ' ')}")
        print(f"   Total: {count} files")
        print(f"   OCR needed: {ocr_count} files")
        print(f"   OCR priority: {priority} (1=highest, 5=lowest)")

        if config.score_relevant:
            print(f"   Fields to extract: {', '.join(config.fields)}")

    # Print OCR summary
    print("\n" + "="*80)
    print("🔍 OCR REQUIREMENTS SUMMARY")
    print("="*80)

    print(f"\n📄 Total PDFs: {len(pdf_files)}")
    print(f"🔎 Require OCR: {total_ocr_required}")
    print(f"✅ Already have text: {len(pdf_files) - total_ocr_required}")

    print("\n📈 OCR PRIORITY BREAKDOWN:")

    priority_groups = {
        1: "🔴 CRITICAL (Leases)",
        2: "🟠 HIGH (Insurance Certs, Compliance)",
        3: "🟡 MEDIUM (Budgets, Accounts)",
        4: "🟢 LOW (Contracts)",
        5: "⚪ SKIP (Policy docs, Correspondence)"
    }

    for priority_level in sorted(priority_groups.keys()):
        label = priority_groups[priority_level]
        count = sum(
            len(files) for cat, files in ocr_needed.items()
            if get_ocr_priority(cat) == priority_level
        )
        if count > 0:
            print(f"   {label}: {count} files")

    # Detailed breakdown
    print("\n" + "="*80)
    print("📋 DETAILED OCR LIST (by priority)")
    print("="*80)

    for priority_level in [1, 2, 3, 4]:
        categories_at_priority = [
            cat for cat in ocr_needed.keys()
            if get_ocr_priority(cat) == priority_level
        ]

        if not categories_at_priority:
            continue

        print(f"\n{priority_groups[priority_level]}")
        print("-" * 80)

        for category in sorted(categories_at_priority):
            files = ocr_needed[category]
            if files:
                print(f"\n{category.upper().replace('_', ' ')} ({len(files)} files):")
                for filename in sorted(files)[:5]:  # Show first 5
                    print(f"   - {filename}")
                if len(files) > 5:
                    print(f"   ... and {len(files) - 5} more")

    # Recommendations
    print("\n" + "="*80)
    print("💡 RECOMMENDATIONS")
    print("="*80)

    lease_ocr = len(ocr_needed.get('lease', []))
    insurance_cert_ocr = len(ocr_needed.get('insurance_certificate', []))
    compliance_ocr = len(ocr_needed.get('compliance_certificate', []))
    budget_ocr = len(ocr_needed.get('budget_pdf', []))

    print(f"\n**Phase 1 (Immediate - Maximum Health Score Impact):**")
    print(f"   - {lease_ocr} Leases (15% weight, currently 0%)")
    print(f"   - {insurance_cert_ocr} Insurance Certificates (20% weight, currently 0%)")
    print(f"   - {compliance_ocr} Compliance Certificates (40% weight, currently 5.4%)")
    print(f"   **Total: {lease_ocr + insurance_cert_ocr + compliance_ocr} PDFs**")
    print(f"   Expected health score: 13.7 → 40-50/100 (+27-36 points)")

    if budget_ocr > 0:
        print(f"\n**Phase 2 (Medium Priority):**")
        print(f"   - {budget_ocr} Budget PDFs (15% weight, currently 10%)")
        print(f"   Expected health score: +5-10 points")

    # Files to SKIP
    skip_categories = ['insurance_policy', 'correspondence', 'other', 'contract']
    skip_count = sum(category_counts.get(cat, 0) for cat in skip_categories)

    print(f"\n**Skip OCR (not score-relevant):**")
    print(f"   - {skip_count} files (policy wordings, correspondence, contracts)")
    print(f"   These will be stored with metadata only")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 analyze_ocr_needs.py <folder_path>")
        print("Example: python3 analyze_ocr_needs.py '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE'")
        sys.exit(1)

    folder_path = sys.argv[1]
    analyze_folder(folder_path)
