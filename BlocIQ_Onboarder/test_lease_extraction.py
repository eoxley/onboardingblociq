#!/usr/bin/env python3
"""
Test lease extraction on actual Connaught Square lease PDFs
"""

import sys
from pathlib import Path
import pdfplumber
from deep_parser.extractors.lease_extractor import LeaseExtractor

def extract_text_from_pdf(pdf_path: Path) -> str:
    """Extract text from PDF using pdfplumber (better for scanned docs)"""
    text = ""
    try:
        with pdfplumber.open(pdf_path) as pdf:
            num_pages = len(pdf.pages)
            print(f"   Pages: {num_pages}")

            for i, page in enumerate(pdf.pages):
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"

                # Show sample from page 3-4 (skip cover pages)
                if i == 2 and page_text and len(page_text) > 200:
                    print(f"   Sample from page 3: {page_text[:400].replace(chr(10), ' ')[:400]}...")

    except Exception as e:
        print(f"   ❌ Error reading PDF: {e}")
    return text


def test_lease_extraction(folder_path: str):
    """Test lease extraction on all lease PDFs in folder"""

    folder = Path(folder_path)

    # Find lease PDFs
    lease_files = list(folder.rglob("*Official Copy*Lease*.pdf"))

    if not lease_files:
        print(f"❌ No lease files found in {folder_path}")
        return

    print(f"📄 Found {len(lease_files)} lease files\n")

    extractor = LeaseExtractor()
    all_leases = []

    for pdf_path in lease_files:
        print(f"Processing: {pdf_path.name}")

        # Extract text
        text = extract_text_from_pdf(pdf_path)

        if not text:
            print(f"   ⚠️  No text extracted\n")
            continue

        print(f"   Text length: {len(text)} chars")

        # Extract lease data
        leases = extractor.extract(text, pdf_path.name)

        if not leases:
            print(f"   ⚠️  No lease data extracted")
            print(f"   Sample text: {text[:500]}...\n")
            continue

        for lease in leases:
            print(f"   ✅ Unit: {lease.unit_ref}")
            print(f"      Lessees: {', '.join(lease.lessee_names) if lease.lessee_names else 'None'}")
            print(f"      Term: {lease.term_years} years" if lease.term_years else "      Term: Not found")
            print(f"      Start: {lease.start_date}" if lease.start_date else "      Start: Not found")
            print(f"      End: {lease.end_date}" if lease.end_date else "      End: Not found")
            print(f"      Ground Rent: {lease.ground_rent_text}" if lease.ground_rent_text else "      Ground Rent: Not found")
            print(f"      Apportionment: {lease.apportionment_pct}%" if lease.apportionment_pct else "      Apportionment: Not found")
            print(f"      Confidence: {lease.confidence:.1%}")
            all_leases.append(lease)

        print()

    print(f"\n{'='*80}")
    print(f"📊 SUMMARY")
    print(f"{'='*80}")
    print(f"Total lease files: {len(lease_files)}")
    print(f"Leases extracted: {len(all_leases)}")
    print(f"Success rate: {len(all_leases)/len(lease_files)*100:.0f}%")

    if all_leases:
        print(f"\nUnits covered: {', '.join(sorted(set(l.unit_ref for l in all_leases)))}")
        avg_confidence = sum(l.confidence for l in all_leases) / len(all_leases)
        print(f"Average confidence: {avg_confidence:.1%}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 test_lease_extraction.py <folder_path>")
        print("Example: python3 test_lease_extraction.py '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE'")
        sys.exit(1)

    folder_path = sys.argv[1]
    test_lease_extraction(folder_path)
