"""
BlocIQ Onboarder - Supabase Storage Uploader
Automatically uploads files to Supabase Storage with proper organization
"""

import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import mimetypes


class SupabaseStorageUploader:
    """Handles file uploads to Supabase Storage with bucket management"""

    def __init__(self, supabase_client):
        """
        Initialize the uploader

        Args:
            supabase_client: Authenticated Supabase client from supabase-py
        """
        self.supabase = supabase_client
        self.uploaded_files = []

    def create_building_bucket(self, building_id: str) -> bool:
        """
        Create a storage bucket for a building if it doesn't exist

        Args:
            building_id: UUID of the building

        Returns:
            True if bucket exists or was created successfully
        """
        bucket_name = f"building-{building_id}"

        try:
            # Check if bucket already exists
            buckets = self.supabase.storage.list_buckets()
            existing = [b for b in buckets if b['name'] == bucket_name]

            if existing:
                print(f"  ✓ Bucket '{bucket_name}' already exists")
                return True

            # Create new bucket
            self.supabase.storage.create_bucket(
                bucket_name,
                options={
                    'public': False,  # Private by default
                    'file_size_limit': 52428800  # 50MB limit
                }
            )
            print(f"  ✓ Created bucket '{bucket_name}'")
            return True

        except Exception as e:
            # Bucket might already exist, which is fine
            if 'already exists' in str(e).lower():
                print(f"  ✓ Bucket '{bucket_name}' already exists")
                return True
            print(f"  ✗ Error creating bucket '{bucket_name}': {e}")
            return False

    def upload_file(self, local_file_path: str, building_id: str, category: str,
                   file_name: str = None) -> Optional[Dict]:
        """
        Upload a file to Supabase Storage

        Args:
            local_file_path: Path to the file on local filesystem
            building_id: UUID of the building
            category: Document category (compliance, finance, etc.)
            file_name: Optional custom filename (defaults to original filename)

        Returns:
            Dict with storage info or None if upload failed
        """
        if not os.path.exists(local_file_path):
            print(f"  ✗ File not found: {local_file_path}")
            return None

        # Use original filename if not provided
        if not file_name:
            file_name = os.path.basename(local_file_path)

        bucket_name = f"building-{building_id}"
        storage_path = f"{category}/{file_name}"

        try:
            # Read file content
            with open(local_file_path, 'rb') as f:
                file_content = f.read()

            # Detect mime type
            mime_type, _ = mimetypes.guess_type(local_file_path)
            if not mime_type:
                mime_type = 'application/octet-stream'

            # Upload to Supabase Storage
            result = self.supabase.storage.from_(bucket_name).upload(
                path=storage_path,
                file=file_content,
                file_options={
                    'content-type': mime_type,
                    'upsert': 'true'  # Overwrite if exists
                }
            )

            # Get public URL (will be private but accessible with auth)
            public_url = self.supabase.storage.from_(bucket_name).get_public_url(storage_path)

            upload_info = {
                'bucket': bucket_name,
                'storage_path': storage_path,
                'public_url': public_url,
                'file_name': file_name,
                'file_size': len(file_content),
                'mime_type': mime_type
            }

            self.uploaded_files.append(upload_info)
            return upload_info

        except Exception as e:
            print(f"  ✗ Error uploading {file_name}: {e}")
            return None

    def upload_building_documents(self, client_folder: str, building_id: str,
                                  categorized_files: Dict) -> Dict[str, Dict]:
        """
        Upload all documents for a building

        Args:
            client_folder: Path to the client folder containing all files
            building_id: UUID of the building
            categorized_files: Dictionary of categorized file metadata from classifier

        Returns:
            Dictionary mapping original file paths to upload info
        """
        print(f"\n📤 Uploading files to Supabase Storage...")

        # Create bucket for this building
        if not self.create_building_bucket(building_id):
            print("  ✗ Failed to create/access storage bucket")
            return {}

        upload_map = {}
        total_files = sum(len(files) for files in categorized_files.values())
        uploaded_count = 0

        # Upload files by category
        for category, files in categorized_files.items():
            if not files:
                continue

            print(f"\n  📁 Uploading {category} documents...")

            for file_data in files:
                file_name = file_data.get('file_name')
                if not file_name:
                    continue

                # Find the actual file in the client folder
                file_path = self._find_file_in_folder(client_folder, file_name)
                if not file_path:
                    print(f"    ✗ Could not find file: {file_name}")
                    continue

                # Upload file
                upload_info = self.upload_file(
                    local_file_path=file_path,
                    building_id=building_id,
                    category=category,
                    file_name=file_name
                )

                if upload_info:
                    upload_map[file_path] = upload_info
                    uploaded_count += 1
                    print(f"    ✓ Uploaded: {file_name} ({upload_info['file_size']:,} bytes)")

        print(f"\n  ✅ Uploaded {uploaded_count}/{total_files} files to Supabase Storage")
        return upload_map

    def _find_file_in_folder(self, folder: str, file_name: str) -> Optional[str]:
        """
        Find a file in a folder recursively

        Args:
            folder: Root folder path
            file_name: Name of the file to find

        Returns:
            Full path to the file or None if not found
        """
        folder_path = Path(folder)

        # Try direct match first
        direct_path = folder_path / file_name
        if direct_path.exists():
            return str(direct_path)

        # Search recursively
        for file_path in folder_path.rglob(file_name):
            if file_path.is_file():
                return str(file_path)

        return None

    def get_upload_summary(self) -> Dict:
        """
        Get summary of all uploaded files

        Returns:
            Dictionary with upload statistics
        """
        total_size = sum(f['file_size'] for f in self.uploaded_files)

        return {
            'total_files': len(self.uploaded_files),
            'total_size_bytes': total_size,
            'total_size_mb': round(total_size / (1024 * 1024), 2),
            'files': self.uploaded_files
        }

    def delete_building_bucket(self, building_id: str) -> bool:
        """
        Delete a building's storage bucket (use with caution!)

        Args:
            building_id: UUID of the building

        Returns:
            True if deleted successfully
        """
        bucket_name = f"building-{building_id}"

        try:
            # Empty bucket first
            files = self.supabase.storage.from_(bucket_name).list()
            for file in files:
                self.supabase.storage.from_(bucket_name).remove([file['name']])

            # Delete bucket
            self.supabase.storage.delete_bucket(bucket_name)
            print(f"  ✓ Deleted bucket '{bucket_name}'")
            return True

        except Exception as e:
            print(f"  ✗ Error deleting bucket '{bucket_name}': {e}")
            return False

    def upload_report_pdf(self, pdf_path: str, building_id: str, report_name: str = "building_health_check.pdf") -> Optional[Dict]:
        """
        Upload a report PDF to the reports bucket
        
        Args:
            pdf_path: Path to the PDF file
            building_id: UUID of the building
            report_name: Name of the report file
            
        Returns:
            Dict with upload info or None if failed
        """
        if not os.path.exists(pdf_path):
            print(f"  ✗ PDF not found: {pdf_path}")
            return None
            
        bucket_name = "reports"
        storage_path = f"{building_id}/{report_name}"
        
        try:
            # Ensure reports bucket exists (create if needed)
            try:
                buckets = self.supabase.storage.list_buckets()
                existing = [b for b in buckets if b['name'] == bucket_name]
                
                if not existing:
                    self.supabase.storage.create_bucket(
                        bucket_name,
                        options={'public': False, 'file_size_limit': 52428800}
                    )
                    print(f"  ✓ Created '{bucket_name}' bucket")
            except Exception as e:
                if 'already exists' not in str(e).lower():
                    print(f"  ⚠️  Bucket check: {e}")
            
            # Read PDF content
            with open(pdf_path, 'rb') as f:
                pdf_content = f.read()
            
            # Upload to Supabase Storage
            result = self.supabase.storage.from_(bucket_name).upload(
                path=storage_path,
                file=pdf_content,
                file_options={
                    'content-type': 'application/pdf',
                    'upsert': 'true'
                }
            )
            
            # Get public URL
            public_url = self.supabase.storage.from_(bucket_name).get_public_url(storage_path)
            
            upload_info = {
                'bucket': bucket_name,
                'path': storage_path,
                'url': public_url,
                'file_name': report_name,
                'building_id': building_id
            }
            
            print(f"  ✅ Uploaded report to: {bucket_name}/{storage_path}")
            return upload_info
            
        except Exception as e:
            print(f"  ✗ Error uploading report: {e}")
            return None
