#!/usr/bin/env python3
"""
Full onboarding with Document Vault integration
Runs onboarder and uploads all documents to vault
"""
import os
import sys
import subprocess
from pathlib import Path
from supabase import create_client

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

from document_vault_manager import DocumentVaultManager

# Environment
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY not set")
    sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 full_onboard_with_vault.py <folder_path>")
        print("\nExample:")
        print('  python3 full_onboard_with_vault.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"')
        sys.exit(1)

    folder_path = sys.argv[1]

    if not os.path.exists(folder_path):
        print(f"❌ Folder not found: {folder_path}")
        sys.exit(1)

    print("\n" + "="*70)
    print("🚀 FULL ONBOARDING WITH DOCUMENT VAULT")
    print("="*70)
    print(f"\n📁 Source folder: {folder_path}")

    # Step 1: Run onboarder
    print("\n" + "="*70)
    print("STEP 1: Running Onboarder")
    print("="*70 + "\n")

    onboarder_script = Path(__file__).parent / 'BlocIQ_Onboarder' / 'onboarder.py'

    try:
        result = subprocess.run(
            ['python3', str(onboarder_script), folder_path],
            timeout=600,  # 10 minute timeout
            capture_output=True,
            text=True,
            env={**os.environ,
                 'SUPABASE_URL': SUPABASE_URL,
                 'SUPABASE_SERVICE_KEY': SUPABASE_KEY}
        )

        print(result.stdout)
        if result.stderr:
            print("Warnings:", result.stderr)

        if result.returncode != 0:
            print(f"⚠️  Onboarder completed with status code: {result.returncode}")
    except subprocess.TimeoutExpired:
        print("⏱️  Onboarder timed out after 10 minutes")
        print("   Continuing with document upload anyway...")
    except Exception as e:
        print(f"⚠️  Onboarder error: {e}")
        print("   Continuing with document upload anyway...")

    # Step 2: Get or create building
    print("\n" + "="*70)
    print("STEP 2: Getting Building ID")
    print("="*70 + "\n")

    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

    # Try to find building by name
    building_name = Path(folder_path).name
    print(f"Looking for building: {building_name}")

    buildings = supabase.table('buildings').select('id, name').ilike('name', f'%{building_name}%').execute()

    if buildings.data:
        building_id = buildings.data[0]['id']
        print(f"✅ Found building: {buildings.data[0]['name']}")
        print(f"   ID: {building_id}")
    else:
        # Use the building ID from earlier or create new one
        building_id = 'ceec21e6-b91e-4c40-9a57-51994caf3ab7'
        print(f"⚠️  Building not found in database")
        print(f"   Using provided building_id: {building_id}")
        print(f"   (Onboarder should have created this)")

    # Step 3: Upload documents to vault
    print("\n" + "="*70)
    print("STEP 3: Uploading Documents to Vault")
    print("="*70 + "\n")

    vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

    # Map folder names to categories
    folder_mappings = {
        'CLIENT INFORMATION': 'client_info',
        'FINANCE': 'budget',
        'GENERAL CORRESPONDENCE': 'general_correspondence',
        'HEALTH & SAFETY': 'fire_risk_assessment',  # Will auto-categorize
        'INSURANCE': 'insurance_certificate',
        'MAJOR WORKS': 'section_20',
        'CONTRACTS': 'contract_other',
        'FLAT CORRESPONDENCE': 'leaseholder_enquiry',
        'BUILDING DRAWINGS': 'architectural_drawing',
        'LEASES': 'lease',
        'HANDOVER': 'general_correspondence'
    }

    stats = {
        'total': 0,
        'uploaded': 0,
        'skipped': 0,
        'failed': 0
    }

    # Walk through all files
    for root, dirs, files in os.walk(folder_path):
        for filename in files:
            # Skip hidden and temp files
            if filename.startswith('.') or filename.startswith('~') or filename == 'Icon\r':
                continue

            # Skip zip files (already extracted)
            if filename.endswith('.zip'):
                continue

            stats['total'] += 1
            file_path = os.path.join(root, filename)

            # Determine category from folder path
            relative_path = os.path.relpath(root, folder_path)
            folder_parts = relative_path.split(os.sep)
            first_folder = folder_parts[0] if folder_parts[0] != '.' else ''

            category = 'general_correspondence'  # default
            for folder_key, cat in folder_mappings.items():
                if folder_key in first_folder.upper():
                    category = cat
                    break

            # Auto-categorize based on filename
            filename_lower = filename.lower()
            if 'insurance' in filename_lower:
                category = 'insurance_certificate'
            elif 'lease' in filename_lower:
                category = 'lease'
            elif 'fire' in filename_lower or 'fra' in filename_lower:
                category = 'fire_risk_assessment'
            elif 'budget' in filename_lower or 'account' in filename_lower:
                category = 'budget'
            elif 'contract' in filename_lower:
                category = 'contract_other'

            print(f"\n📄 {filename}")
            print(f"   Folder: {first_folder or 'root'}")
            print(f"   Category: {category}")

            # Upload
            result = vault.upload_document(
                file_path=file_path,
                building_id=building_id,
                category=category
            )

            if result['success']:
                print(f"   ✅ Uploaded → {result['folder']}/")
                stats['uploaded'] += 1
            else:
                if 'Unsupported file type' in result.get('error', ''):
                    print(f"   ⏭️  Skipped (unsupported file type)")
                    stats['skipped'] += 1
                else:
                    print(f"   ❌ Failed: {result.get('error', 'Unknown')}")
                    stats['failed'] += 1

    # Summary
    print("\n" + "="*70)
    print("📊 ONBOARDING COMPLETE")
    print("="*70)
    print(f"\nBuilding ID: {building_id}")
    print(f"\nDocument Upload Statistics:")
    print(f"  Total files processed: {stats['total']}")
    print(f"  ✅ Uploaded: {stats['uploaded']}")
    print(f"  ⏭️  Skipped: {stats['skipped']}")
    print(f"  ❌ Failed: {stats['failed']}")

    print(f"\n📦 Documents organized in Supabase Storage:")
    print(f"   building_documents/{building_id}/")
    print(f"   └─ <Category>/<Subfolder>/<filename>")

    print("\n" + "="*70 + "\n")

if __name__ == '__main__':
    main()
