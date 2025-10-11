#!/usr/bin/env python3
"""
Document Vault Setup for Supabase Storage
Creates organized folder structure for all building documents
"""
import os
import sys

try:
    from supabase import create_client
except ImportError:
    print("Installing supabase client...")
    os.system("pip3 install supabase")
    from supabase import create_client

# Document vault folder structure
DOCUMENT_VAULT_STRUCTURE = {
    'Client Information': [
        'Contact Details',
        'Service Agreements',
        'Meeting Minutes',
        'General Admin'
    ],
    'Finance': [
        'Budgets',
        'Service Charge Accounts',
        'Invoices',
        'Payment Records',
        'Audit Reports',
        'Year End Accounts'
    ],
    'General Correspondence': [
        'Emails',
        'Letters',
        'Notices',
        'Newsletters'
    ],
    'Health and Safety': [
        'Fire Risk Assessments',
        'Emergency Lighting',
        'EICR',
        'Fire Door Inspections',
        'LOLER',
        'Legionella',
        'Gas Safety',
        'Lightning Protection',
        'Asbestos Surveys',
        'Other Compliance'
    ],
    'Insurance': [
        'Current Policies',
        'Certificates',
        'Claims',
        'Previous Policies',
        'Policy Wordings'
    ],
    'Major Works': [
        'Section 20 Notices',
        'Contractor Quotes',
        'Project Plans',
        'Completion Certificates',
        'Invoices',
        'Correspondence'
    ],
    'Contracts': [
        'Cleaning',
        'Gardening',
        'Lift Maintenance',
        'Door Entry',
        'Other Contracts'
    ],
    'Leaseholder Correspondence': [
        'General Enquiries',
        'Complaints',
        'Lease Variations',
        'Subletting Notices'
    ],
    'Building Drawings and Plans': [
        'Architectural',
        'Structural',
        'Electrical',
        'Plumbing',
        'Fire Safety'
    ],
    'Leases': [
        'Original Leases',
        'Lease Extensions',
        'Variations'
    ]
}

# Environment variables
SUPABASE_URL = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')
STORAGE_BUCKET = os.getenv('SUPABASE_STORAGE_BUCKET', 'building_documents')

if not SUPABASE_KEY:
    print("❌ SUPABASE_SERVICE_KEY environment variable not set")
    sys.exit(1)

def setup_document_vault():
    """Create document vault folder structure in Supabase Storage"""

    print("\n" + "="*60)
    print("📁 Setting Up Document Vault in Supabase Storage")
    print("="*60 + "\n")

    # Create Supabase client
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

    print(f"📦 Storage Bucket: {STORAGE_BUCKET}")
    print(f"🔗 Supabase URL: {SUPABASE_URL}\n")

    # Check if bucket exists
    try:
        buckets = supabase.storage.list_buckets()
        bucket_exists = any(b.name == STORAGE_BUCKET for b in buckets)

        if not bucket_exists:
            print(f"⚠️  Bucket '{STORAGE_BUCKET}' does not exist")
            print(f"   Creating bucket...")

            # Create bucket (public=false for security)
            supabase.storage.create_bucket(
                STORAGE_BUCKET,
                options={'public': False}
            )
            print(f"✅ Bucket '{STORAGE_BUCKET}' created\n")
        else:
            print(f"✅ Bucket '{STORAGE_BUCKET}' exists\n")

    except Exception as e:
        print(f"❌ Error checking/creating bucket: {e}")
        print("   You may need to create the bucket manually in Supabase dashboard")
        print("   Go to: Storage → Create a new bucket → 'building_documents'\n")

    # Note: Supabase Storage creates folders implicitly when files are uploaded
    # We'll document the structure here for reference

    print("📋 Document Vault Structure:\n")

    total_folders = 0
    for category, subfolders in DOCUMENT_VAULT_STRUCTURE.items():
        print(f"📂 {category}/")
        for subfolder in subfolders:
            print(f"   └─ {subfolder}/")
            total_folders += 1
        print()

    print(f"✅ Structure defined: {len(DOCUMENT_VAULT_STRUCTURE)} main categories, {total_folders} subfolders")

    print("\n" + "="*60)
    print("📝 Document Vault Setup Complete")
    print("="*60)
    print("\nFolder structure is ready. Files will be organized as:")
    print(f"  {STORAGE_BUCKET}/<building_id>/<category>/<subfolder>/<filename>")
    print("\nExample:")
    print(f"  {STORAGE_BUCKET}/550e8400-.../Insurance/Current Policies/Buildings_Insurance_2024.pdf")
    print()

if __name__ == '__main__':
    setup_document_vault()
