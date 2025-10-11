#!/usr/bin/env python3
"""
Document Vault Manager
Handles uploading and organizing documents in Supabase Storage with proper folder structure
"""
import os
import mimetypes
from pathlib import Path
from typing import Optional, Dict, List
from datetime import datetime

try:
    from supabase import create_client
except ImportError:
    print("Installing supabase client...")
    os.system("pip3 install supabase")
    from supabase import create_client

# Category mapping: document type -> (main_category, subfolder)
CATEGORY_MAPPING = {
    # Client Information
    'client_info': ('Client Information', 'General Admin'),
    'service_agreement': ('Client Information', 'Service Agreements'),
    'meeting_minutes': ('Client Information', 'Meeting Minutes'),

    # Finance
    'budget': ('Finance', 'Budgets'),
    'accounts': ('Finance', 'Service Charge Accounts'),
    'year_end_accounts': ('Finance', 'Year End Accounts'),
    'invoice': ('Finance', 'Invoices'),
    'audit': ('Finance', 'Audit Reports'),

    # Health & Safety / Compliance
    'fire_risk_assessment': ('Health and Safety', 'Fire Risk Assessments'),
    'fra': ('Health and Safety', 'Fire Risk Assessments'),
    'emergency_lighting': ('Health and Safety', 'Emergency Lighting'),
    'el': ('Health and Safety', 'Emergency Lighting'),
    'eicr': ('Health and Safety', 'EICR'),
    'electrical': ('Health and Safety', 'EICR'),
    'fire_doors': ('Health and Safety', 'Fire Door Inspections'),
    'loler': ('Health and Safety', 'LOLER'),
    'legionella': ('Health and Safety', 'Legionella'),
    'gas_safety': ('Health and Safety', 'Gas Safety'),
    'gas': ('Health and Safety', 'Gas Safety'),
    'lightning_protection': ('Health and Safety', 'Lightning Protection'),
    'lps': ('Health and Safety', 'Lightning Protection'),
    'asbestos': ('Health and Safety', 'Asbestos Surveys'),
    'compliance_other': ('Health and Safety', 'Other Compliance'),

    # Insurance
    'insurance_certificate': ('Insurance', 'Certificates'),
    'insurance_policy': ('Insurance', 'Current Policies'),
    'insurance_claim': ('Insurance', 'Claims'),
    'policy_wording': ('Insurance', 'Policy Wordings'),
    'previous_policy': ('Insurance', 'Previous Policies'),

    # Major Works
    'section_20': ('Major Works', 'Section 20 Notices'),
    'contractor_quote': ('Major Works', 'Contractor Quotes'),
    'major_works_invoice': ('Major Works', 'Invoices'),
    'completion_cert': ('Major Works', 'Completion Certificates'),

    # Contracts
    'cleaning_contract': ('Contracts', 'Cleaning'),
    'gardening_contract': ('Contracts', 'Gardening'),
    'lift_contract': ('Contracts', 'Lift Maintenance'),
    'door_entry_contract': ('Contracts', 'Door Entry'),
    'contract_other': ('Contracts', 'Other Contracts'),

    # Correspondence
    'general_correspondence': ('General Correspondence', 'Letters'),
    'email': ('General Correspondence', 'Emails'),
    'notice': ('General Correspondence', 'Notices'),
    'newsletter': ('General Correspondence', 'Newsletters'),

    # Leaseholder Correspondence
    'leaseholder_enquiry': ('Leaseholder Correspondence', 'General Enquiries'),
    'complaint': ('Leaseholder Correspondence', 'Complaints'),
    'lease_variation': ('Leaseholder Correspondence', 'Lease Variations'),
    'subletting': ('Leaseholder Correspondence', 'Subletting Notices'),

    # Building Plans
    'architectural_drawing': ('Building Drawings and Plans', 'Architectural'),
    'structural_drawing': ('Building Drawings and Plans', 'Structural'),
    'electrical_drawing': ('Building Drawings and Plans', 'Electrical'),
    'plumbing_drawing': ('Building Drawings and Plans', 'Plumbing'),

    # Leases
    'lease': ('Leases', 'Original Leases'),
    'lease_extension': ('Leases', 'Lease Extensions'),
    'lease_variation_doc': ('Leases', 'Variations'),
}

# Supported file types
SUPPORTED_MIMETYPES = {
    # Documents
    '.pdf': 'application/pdf',
    '.doc': 'application/msword',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.xls': 'application/vnd.ms-excel',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    '.txt': 'text/plain',

    # Images
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.bmp': 'image/bmp',
    '.tiff': 'image/tiff',

    # Other
    '.zip': 'application/zip',
    '.msg': 'application/vnd.ms-outlook',
    '.eml': 'message/rfc822'
}


class DocumentVaultManager:
    """Manages document uploads to Supabase Storage with organized folder structure"""

    def __init__(self, supabase_url: str, supabase_key: str, bucket_name: str = 'building_documents'):
        self.supabase = create_client(supabase_url, supabase_key)
        self.bucket = bucket_name

    def get_folder_path(self, category: str, building_id: str) -> str:
        """Get folder path for a document category"""
        mapping = CATEGORY_MAPPING.get(category.lower())

        if mapping:
            main_category, subfolder = mapping
            return f"{building_id}/{main_category}/{subfolder}"
        else:
            # Default to general correspondence if category not found
            return f"{building_id}/General Correspondence/Letters"

    def get_mime_type(self, filename: str) -> str:
        """Get MIME type for a file"""
        ext = Path(filename).suffix.lower()
        return SUPPORTED_MIMETYPES.get(ext, 'application/octet-stream')

    def is_supported_file(self, filename: str) -> bool:
        """Check if file type is supported"""
        ext = Path(filename).suffix.lower()
        return ext in SUPPORTED_MIMETYPES

    def upload_document(
        self,
        file_path: str,
        building_id: str,
        category: str,
        custom_filename: Optional[str] = None,
        metadata: Optional[Dict] = None
    ) -> Dict:
        """
        Upload a document to the vault with proper organization

        Args:
            file_path: Local path to file
            building_id: UUID of building
            category: Document category (e.g., 'insurance_certificate', 'lease', 'fra')
            custom_filename: Optional custom filename (otherwise uses original)
            metadata: Optional metadata dict

        Returns:
            Dict with upload status and storage path
        """

        # Validate file exists
        if not os.path.exists(file_path):
            return {'success': False, 'error': f"File not found: {file_path}"}

        # Validate file type
        filename = custom_filename or Path(file_path).name
        if not self.is_supported_file(filename):
            ext = Path(filename).suffix
            return {
                'success': False,
                'error': f"Unsupported file type: {ext}. Supported: {', '.join(SUPPORTED_MIMETYPES.keys())}"
            }

        # Get folder path
        folder_path = self.get_folder_path(category, building_id)
        storage_path = f"{folder_path}/{filename}"

        # Get MIME type
        mime_type = self.get_mime_type(filename)

        try:
            # Read file
            with open(file_path, 'rb') as f:
                file_data = f.read()

            # Upload to Supabase Storage
            response = self.supabase.storage.from_(self.bucket).upload(
                path=storage_path,
                file=file_data,
                file_options={
                    'content-type': mime_type,
                    'upsert': 'true'  # Overwrite if exists
                }
            )

            # Get public URL (if bucket is public) or signed URL
            try:
                # For private buckets, create a signed URL (expires in 1 year)
                signed_url = self.supabase.storage.from_(self.bucket).create_signed_url(
                    storage_path,
                    expires_in=31536000  # 1 year
                )
                url = signed_url['signedURL']
            except:
                # Fallback to public URL
                url = self.supabase.storage.from_(self.bucket).get_public_url(storage_path)

            # Get vault category and subfolder
            mapping = CATEGORY_MAPPING.get(category, ('General Correspondence', 'Letters'))
            vault_cat, vault_sub = mapping

            # Record in database
            document_record = {
                'building_id': building_id,
                'filename': filename,
                'file_size': len(file_data),
                'file_type': mime_type,
                'category': category,
                'vault_category': vault_cat,
                'vault_subfolder': vault_sub,
                'path': storage_path,
                'storage_url': url,
                'mime_type': mime_type,
                'status': 'active',
                'document_type': 'vault_upload',
                'uploaded_by': '938498a6-2906-4a75-bc91-5d0d586b227e'  # System user
            }

            if metadata:
                document_record['metadata'] = metadata

            # Insert into documents table (use insert, not upsert)
            self.supabase.table('documents').insert(document_record).execute()

            return {
                'success': True,
                'storage_path': storage_path,
                'url': url,
                'folder': folder_path,
                'category': category
            }

        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'storage_path': storage_path
            }

    def upload_folder(
        self,
        folder_path: str,
        building_id: str,
        category_mapping: Optional[Dict[str, str]] = None
    ) -> List[Dict]:
        """
        Upload entire folder to vault

        Args:
            folder_path: Local folder path
            building_id: UUID of building
            category_mapping: Optional dict mapping filename patterns to categories

        Returns:
            List of upload results
        """
        results = []

        for root, dirs, files in os.walk(folder_path):
            for filename in files:
                file_path = os.path.join(root, filename)

                # Determine category from mapping or filename
                category = 'general_correspondence'  # default

                if category_mapping:
                    for pattern, cat in category_mapping.items():
                        if pattern.lower() in filename.lower():
                            category = cat
                            break

                # Upload file
                result = self.upload_document(
                    file_path=file_path,
                    building_id=building_id,
                    category=category
                )

                results.append({
                    'filename': filename,
                    'category': category,
                    **result
                })

        return results

    def list_documents(self, building_id: str, category: Optional[str] = None) -> List[Dict]:
        """List all documents for a building (optionally filtered by category)"""
        query = self.supabase.table('documents').select('*').eq('building_id', building_id)

        if category:
            query = query.eq('category', category)

        response = query.execute()
        return response.data

    def get_document_url(self, building_id: str, filename: str) -> Optional[str]:
        """Get signed URL for a document"""
        result = self.supabase.table('documents').select('path').eq(
            'building_id', building_id
        ).eq('filename', filename).execute()

        if result.data:
            path = result.data[0]['path']
            signed = self.supabase.storage.from_(self.bucket).create_signed_url(
                path, expires_in=3600  # 1 hour
            )
            return signed['signedURL']

        return None


# Example usage
if __name__ == '__main__':
    import sys

    # Environment setup
    SUPABASE_URL = os.getenv('SUPABASE_URL')
    SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_KEY')

    if not SUPABASE_URL or not SUPABASE_KEY:
        print("❌ SUPABASE_URL and SUPABASE_SERVICE_KEY must be set")
        sys.exit(1)

    # Create manager
    vault = DocumentVaultManager(SUPABASE_URL, SUPABASE_KEY)

    print("Document Vault Manager Ready")
    print("\nSupported file types:")
    for ext, mime in SUPPORTED_MIMETYPES.items():
        print(f"  {ext} ({mime})")

    print("\nCategory mappings:")
    for category, (main, sub) in CATEGORY_MAPPING.items():
        print(f"  {category:.<30} → {main}/{sub}")
