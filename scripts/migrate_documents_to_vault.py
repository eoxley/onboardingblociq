#!/usr/bin/env python3
"""
Migrate existing documents to organized Document Vault
Moves all documents from local storage to Supabase Storage with proper folder structure
Each building gets its own folder hierarchy
"""
import os
import sys
from pathlib import Path
from typing import Dict, List

# Add parent to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from document_vault_manager import DocumentVaultManager, CATEGORY_MAPPING

# Environment
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ SUPABASE_URL and SUPABASE_SERVICE_KEY must be set")
    sys.exit(1)


def categorize_filename(filename: str) -> str:
    """
    Intelligent categorization based on filename patterns
    """
    filename_lower = filename.lower()

    # Insurance
    if any(x in filename_lower for x in ['insurance', 'policy', 'certificate']):
        if 'wording' in filename_lower or 'schedule' in filename_lower:
            return 'policy_wording'
        elif 'claim' in filename_lower:
            return 'insurance_claim'
        else:
            return 'insurance_certificate'

    # Compliance / Health & Safety
    if 'fire risk' in filename_lower or 'fra' in filename_lower:
        return 'fire_risk_assessment'
    if 'emergency light' in filename_lower or filename_lower.startswith('el_') or '_el_' in filename_lower:
        return 'emergency_lighting'
    if 'eicr' in filename_lower or 'electrical' in filename_lower:
        return 'eicr'
    if 'fire door' in filename_lower:
        return 'fire_doors'
    if 'loler' in filename_lower or 'lift' in filename_lower:
        return 'loler'
    if 'legionella' in filename_lower or 'water' in filename_lower:
        return 'legionella'
    if 'gas' in filename_lower:
        return 'gas_safety'
    if 'lightning' in filename_lower or 'lps' in filename_lower:
        return 'lightning_protection'
    if 'asbestos' in filename_lower:
        return 'asbestos'

    # Leases
    if 'lease' in filename_lower:
        if 'extension' in filename_lower:
            return 'lease_extension'
        elif 'variation' in filename_lower:
            return 'lease_variation_doc'
        else:
            return 'lease'

    # Finance
    if 'budget' in filename_lower:
        return 'budget'
    if 'account' in filename_lower:
        if 'year end' in filename_lower:
            return 'year_end_accounts'
        else:
            return 'accounts'
    if 'invoice' in filename_lower:
        if 'major work' in filename_lower:
            return 'major_works_invoice'
        else:
            return 'invoice'
    if 'audit' in filename_lower:
        return 'audit'

    # Major Works
    if 'section 20' in filename_lower or 's20' in filename_lower:
        return 'section_20'
    if 'quote' in filename_lower:
        return 'contractor_quote'
    if 'completion' in filename_lower:
        return 'completion_cert'

    # Contracts
    if 'contract' in filename_lower:
        if 'clean' in filename_lower:
            return 'cleaning_contract'
        elif 'garden' in filename_lower:
            return 'gardening_contract'
        elif 'lift' in filename_lower:
            return 'lift_contract'
        elif 'door' in filename_lower:
            return 'door_entry_contract'
        else:
            return 'contract_other'

    # Building Plans
    if any(x in filename_lower for x in ['drawing', 'plan', 'blueprint', 'dwg']):
        if 'architect' in filename_lower:
            return 'architectural_drawing'
        elif 'structural' in filename_lower:
            return 'structural_drawing'
        elif 'electrical' in filename_lower:
            return 'electrical_drawing'
        elif 'plumbing' in filename_lower:
            return 'plumbing_drawing'

    # Correspondence
    if any(x in filename_lower for x in ['email', 'letter', 'correspondence']):
        if 'leaseholder' in filename_lower:
            if 'complaint' in filename_lower:
                return 'complaint'
            elif 'enquiry' in filename_lower:
                return 'leaseholder_enquiry'
            else:
                return 'leaseholder_enquiry'
        else:
            return 'general_correspondence'

    # Default
    return 'general_correspondence'


def migrate_building_documents(building_folder: str, building_id: str, vault: DocumentVaultManager) -> Dict:
    """
    Migrate all documents for a building to the vault

    Args:
        building_folder: Local folder containing building documents
        building_id: UUID of building
        vault: DocumentVaultManager instance

    Returns:
        Migration statistics
    """
    print(f"\n📦 Migrating documents for building: {building_id}")
    print(f"   Source folder: {building_folder}")

    if not os.path.exists(building_folder):
        print(f"❌ Folder not found: {building_folder}")
        return {'success': False, 'error': 'Folder not found'}

    stats = {
        'total_files': 0,
        'uploaded': 0,
        'skipped': 0,
        'failed': 0,
        'by_category': {}
    }

    # Walk through all files
    for root, dirs, files in os.walk(building_folder):
        for filename in files:
            # Skip hidden files and temp files
            if filename.startswith('.') or filename.startswith('~'):
                continue

            stats['total_files'] += 1
            file_path = os.path.join(root, filename)

            # Categorize file
            category = categorize_filename(filename)

            # Track by category
            if category not in stats['by_category']:
                stats['by_category'][category] = 0

            print(f"\n📄 {filename}")
            print(f"   Category: {category}")

            # Upload to vault
            result = vault.upload_document(
                file_path=file_path,
                building_id=building_id,
                category=category
            )

            if result['success']:
                print(f"   ✅ Uploaded → {result['folder']}/")
                stats['uploaded'] += 1
                stats['by_category'][category] += 1
            else:
                if 'Unsupported file type' in result.get('error', ''):
                    print(f"   ⏭️  Skipped (unsupported file type)")
                    stats['skipped'] += 1
                else:
                    print(f"   ❌ Failed: {result.get('error', 'Unknown error')}")
                    stats['failed'] += 1

    return stats


def main():
    """Main migration script"""
    print("\n" + "="*60)
    print("📁 Document Vault Migration")
    print("="*60)

    # Initialize vault manager
    vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

    # Get building info
    if len(sys.argv) < 3:
        print("\nUsage: python migrate_documents_to_vault.py <building_id> <local_folder>")
        print("\nExample:")
        print("  python migrate_documents_to_vault.py 550e8400-... /path/to/building/documents")
        sys.exit(1)

    building_id = sys.argv[1]
    building_folder = sys.argv[2]

    # Migrate
    stats = migrate_building_documents(building_folder, building_id, vault)

    # Summary
    print("\n" + "="*60)
    print("📊 Migration Summary")
    print("="*60)
    print(f"\nBuilding ID: {building_id}")
    print(f"Total files processed: {stats['total_files']}")
    print(f"✅ Uploaded: {stats['uploaded']}")
    print(f"⏭️  Skipped: {stats['skipped']}")
    print(f"❌ Failed: {stats['failed']}")

    if stats['by_category']:
        print("\n📋 By Category:")
        for category, count in sorted(stats['by_category'].items(), key=lambda x: x[1], reverse=True):
            if category in CATEGORY_MAPPING:
                main_cat, sub_cat = CATEGORY_MAPPING[category]
                print(f"  {category:.<30} {count:>3} → {main_cat}/{sub_cat}")

    print("\n" + "="*60)

    # Access info
    print("\n📌 Documents are organized as:")
    print(f"   building_documents/{building_id}/<Category>/<Subfolder>/<filename>")
    print("\n   All documents belong exclusively to building: {building_id}")
    print("="*60 + "\n")

if __name__ == '__main__':
    main()
