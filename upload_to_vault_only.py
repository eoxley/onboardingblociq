#!/usr/bin/env python3
"""
Upload documents to vault only (skip onboarder)
Fast document organization and upload to Supabase Storage
"""
import os
import sys
from pathlib import Path

# Add current dir to path
sys.path.insert(0, str(Path(__file__).parent))

from document_vault_manager import DocumentVaultManager, CATEGORY_MAPPING
from scripts.migrate_documents_to_vault import categorize_filename

# Environment
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

def main():
    if len(sys.argv) < 3:
        print("\nUsage: python3 upload_to_vault_only.py <building_id> <folder_path>")
        print("\nExample:")
        print('  python3 upload_to_vault_only.py ceec21e6-b91e-4c40-9a57-51994caf3ab7 "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"')
        sys.exit(1)

    building_id = sys.argv[1]
    folder_path = sys.argv[2]

    if not os.path.exists(folder_path):
        print(f"❌ Folder not found: {folder_path}")
        sys.exit(1)

    if not SUPABASE_KEY:
        print("❌ SUPABASE_SERVICE_KEY not set")
        sys.exit(1)

    print("\n" + "="*70)
    print("📦 DOCUMENT VAULT UPLOAD")
    print("="*70)
    print(f"\n📁 Source: {folder_path}")
    print(f"🏢 Building ID: {building_id}")
    print(f"☁️  Destination: building_documents/{building_id}/")

    # Initialize vault
    vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

    stats = {
        'total': 0,
        'uploaded': 0,
        'skipped': 0,
        'failed': 0,
        'by_category': {}
    }

    print("\n" + "="*70)
    print("📄 Processing documents...")
    print("="*70 + "\n")

    # Walk through all files
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            # Skip hidden/temp/system files
            if (filename.startswith('.') or
                filename.startswith('~') or
                filename == 'Icon\r' or
                filename.endswith('.zip')):  # Skip zips
                continue

            stats['total'] += 1
            file_path = os.path.join(root, filename)

            # Auto-categorize
            category = categorize_filename(filename)

            # Track by category
            if category not in stats['by_category']:
                stats['by_category'][category] = 0

            # Get folder for display
            relative_path = os.path.relpath(root, folder_path)
            folder_name = relative_path.split(os.sep)[0] if relative_path != '.' else 'root'

            print(f"📄 {filename}")
            print(f"   Source folder: {folder_name}")
            print(f"   Category: {category}", end=" ")

            # Upload
            result = vault.upload_document(
                file_path=file_path,
                building_id=building_id,
                category=category
            )

            if result['success']:
                mapping = CATEGORY_MAPPING.get(category, ('General', 'Admin'))
                main_cat, sub_cat = mapping
                print(f"→ {main_cat}/{sub_cat}")
                print(f"   ✅ Uploaded")
                stats['uploaded'] += 1
                stats['by_category'][category] += 1
            else:
                if 'Unsupported file type' in result.get('error', ''):
                    print()
                    print(f"   ⏭️  Skipped (unsupported type)")
                    stats['skipped'] += 1
                else:
                    print()
                    print(f"   ❌ Failed: {result.get('error', 'Unknown')[:50]}")
                    stats['failed'] += 1

            print()  # Blank line between files

    # Summary
    print("="*70)
    print("📊 UPLOAD COMPLETE")
    print("="*70)
    print(f"\nBuilding ID: {building_id}")
    print(f"\n📈 Statistics:")
    print(f"  Total files processed: {stats['total']}")
    print(f"  ✅ Uploaded: {stats['uploaded']}")
    print(f"  ⏭️  Skipped: {stats['skipped']}")
    print(f"  ❌ Failed: {stats['failed']}")

    if stats['by_category']:
        print(f"\n📋 By Category:")
        for category, count in sorted(stats['by_category'].items(), key=lambda x: x[1], reverse=True):
            if category in CATEGORY_MAPPING:
                main_cat, sub_cat = CATEGORY_MAPPING[category]
                print(f"  {category:.<35} {count:>3} → {main_cat}/{sub_cat}")

    print(f"\n🔗 Access documents in Supabase:")
    print(f"   Storage → building_documents → {building_id}")
    print(f"   Database → documents table (building_id = '{building_id}')")

    print("\n" + "="*70 + "\n")

if __name__ == '__main__':
    main()
