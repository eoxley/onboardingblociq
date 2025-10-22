#!/usr/bin/env python3
"""
Supplier Onboarding Service - Pure Business Logic
==================================================
NO GUI - Just the core logic for supplier onboarding

This is the service layer extracted from the supplier app.
Use this in your live project without any UI dependencies.
"""

from pathlib import Path
from typing import Dict, List, Optional, Union, Tuple
import json
from datetime import datetime


class SupplierOnboardingService:
    """
    Core business logic for supplier onboarding
    
    No GUI, no CLI - just pure processing logic
    Use this in your live project's service layer
    """
    
    def __init__(self, output_dir: str = "output"):
        """
        Initialize service
        
        Args:
            output_dir: Directory for output files (JSON, SQL)
        """
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
        self.extracted_data: Optional[Dict] = None
        self.sql_content: Optional[str] = None
        self.supplier_id: Optional[str] = None
        self.json_file: Optional[Path] = None
        self.sql_file: Optional[Path] = None
    
    def process_supplier(
        self,
        path: Union[str, Path, List[Path]],
        name_hint: Optional[str] = None
    ) -> Dict:
        """
        Complete supplier onboarding process
        
        Args:
            path: Folder path, file path, or list of file paths
            name_hint: Optional supplier name hint for file naming
        
        Returns:
            Dict with:
                - success: bool
                - extracted_data: Dict
                - supplier_id: str
                - json_file: Path
                - sql_file: Path
                - confidence: float
                - errors: List[str]
        """
        errors = []
        
        try:
            # Step 1: Extract data
            extraction_result = self.extract_supplier_data(path)
            
            if not extraction_result['success']:
                return {
                    'success': False,
                    'errors': extraction_result.get('errors', ['Extraction failed']),
                    'extracted_data': None
                }
            
            self.extracted_data = extraction_result['data']
            
            # Step 2: Generate SQL
            generation_result = self.generate_sql(name_hint)
            
            if not generation_result['success']:
                return {
                    'success': False,
                    'errors': generation_result.get('errors', ['SQL generation failed']),
                    'extracted_data': self.extracted_data
                }
            
            # Step 3: Save files
            save_result = self.save_files(name_hint)
            
            if not save_result['success']:
                errors.extend(save_result.get('errors', []))
            
            # Return complete result
            return {
                'success': True,
                'extracted_data': self.extracted_data,
                'supplier_id': self.supplier_id,
                'json_file': str(self.json_file),
                'sql_file': str(self.sql_file),
                'confidence': self.extracted_data.get('extraction_confidence', 0),
                'contractor_name': self.extracted_data.get('contractor_name'),
                'errors': errors
            }
            
        except Exception as e:
            return {
                'success': False,
                'errors': [str(e)],
                'extracted_data': self.extracted_data
            }
    
    def extract_supplier_data(
        self,
        path: Union[str, Path, List[Path]]
    ) -> Dict:
        """
        Extract supplier data from documents
        
        Args:
            path: Folder, file, or list of files
        
        Returns:
            Dict with success, data, errors
        """
        try:
            # Import here to avoid circular dependencies
            from extractors.contractor_extractor import ContractorExtractor
            
            extractor = ContractorExtractor()
            
            # Determine input type
            if isinstance(path, list):
                # List of files
                data = extractor.extract_from_files(path)
            elif isinstance(path, (str, Path)):
                path_obj = Path(path)
                if path_obj.is_file():
                    # Single file
                    data = extractor.extract_from_files([path_obj])
                else:
                    # Folder
                    data = extractor.extract_from_folder(str(path))
            else:
                return {
                    'success': False,
                    'errors': [f'Invalid path type: {type(path)}']
                }
            
            return {
                'success': True,
                'data': data,
                'errors': []
            }
            
        except Exception as e:
            return {
                'success': False,
                'errors': [f'Extraction error: {str(e)}']
            }
    
    def generate_sql(
        self,
        name_hint: Optional[str] = None
    ) -> Dict:
        """
        Generate SQL INSERT statements
        
        Args:
            name_hint: Optional name for SQL file
        
        Returns:
            Dict with success, supplier_id, sql_content, errors
        """
        if not self.extracted_data:
            return {
                'success': False,
                'errors': ['No extracted data available']
            }
        
        try:
            from generators.supplier_sql_generator import SupplierSQLGenerator
            
            generator = SupplierSQLGenerator()
            self.supplier_id = generator.supplier_id
            self.sql_content = generator.generate_sql(self.extracted_data)
            
            return {
                'success': True,
                'supplier_id': self.supplier_id,
                'sql_content': self.sql_content,
                'errors': []
            }
            
        except Exception as e:
            return {
                'success': False,
                'errors': [f'SQL generation error: {str(e)}']
            }
    
    def save_files(
        self,
        name_hint: Optional[str] = None
    ) -> Dict:
        """
        Save JSON and SQL files
        
        Args:
            name_hint: Optional base name for files
        
        Returns:
            Dict with success, json_file, sql_file, errors
        """
        if not self.extracted_data or not self.sql_content:
            return {
                'success': False,
                'errors': ['Missing data or SQL content']
            }
        
        try:
            # Determine filename base
            if name_hint:
                base_name = name_hint
            elif self.extracted_data.get('contractor_name'):
                base_name = self.extracted_data['contractor_name'].replace(' ', '_')
            else:
                base_name = f"supplier_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
            
            # Save JSON
            self.json_file = self.output_dir / f"{base_name}_data.json"
            with open(self.json_file, 'w') as f:
                json.dump(self.extracted_data, f, indent=2)
            
            # Save SQL
            self.sql_file = self.output_dir / f"{base_name}_supplier.sql"
            with open(self.sql_file, 'w') as f:
                f.write(self.sql_content)
            
            return {
                'success': True,
                'json_file': str(self.json_file),
                'sql_file': str(self.sql_file),
                'errors': []
            }
            
        except Exception as e:
            return {
                'success': False,
                'errors': [f'File save error: {str(e)}']
            }
    
    def get_extraction_summary(self) -> Dict:
        """
        Get a summary of extracted data
        
        Returns:
            Dict with key fields and metadata
        """
        if not self.extracted_data:
            return {'error': 'No data extracted yet'}
        
        return {
            'contractor_name': self.extracted_data.get('contractor_name'),
            'email': self.extracted_data.get('email'),
            'telephone': self.extracted_data.get('telephone'),
            'postcode': self.extracted_data.get('postcode'),
            'services_provided': self.extracted_data.get('services_provided', []),
            'bank_sort_code': self.extracted_data.get('bank_sort_code'),
            'pli_expiry_date': self.extracted_data.get('pli_expiry_date'),
            'has_audited_accounts': self.extracted_data.get('has_audited_accounts', False),
            'has_certificate_of_incorporation': self.extracted_data.get('has_certificate_of_incorporation', False),
            'extraction_confidence': self.extracted_data.get('extraction_confidence', 0),
            'documents_count': len(self.extracted_data.get('documents_found', []))
        }
    
    def validate_extraction(self) -> Tuple[bool, List[str]]:
        """
        Validate extracted data quality
        
        Returns:
            Tuple of (is_valid, list_of_warnings)
        """
        if not self.extracted_data:
            return False, ['No data extracted']
        
        warnings = []
        
        # Required fields
        if not self.extracted_data.get('contractor_name'):
            warnings.append('Contractor name not found')
        
        # Important fields
        if not self.extracted_data.get('email'):
            warnings.append('Email not found')
        
        if not self.extracted_data.get('telephone'):
            warnings.append('Telephone not found')
        
        if not self.extracted_data.get('pli_expiry_date'):
            warnings.append('PLI expiry date not found (critical for compliance)')
        
        # Confidence check
        confidence = self.extracted_data.get('extraction_confidence', 0)
        if confidence < 0.6:
            warnings.append(f'Low extraction confidence: {confidence:.0%}')
        
        # Determine if valid
        is_valid = len(warnings) == 0 or (
            self.extracted_data.get('contractor_name') and confidence >= 0.5
        )
        
        return is_valid, warnings
    
    def apply_to_database(
        self,
        apply_script: str = "apply_with_new_credentials.py"
    ) -> Dict:
        """
        Apply generated SQL to database
        
        Args:
            apply_script: Path to SQL application script
        
        Returns:
            Dict with success, output, errors
        """
        if not self.sql_file or not self.sql_file.exists():
            return {
                'success': False,
                'errors': ['SQL file not found. Generate SQL first.']
            }
        
        try:
            import subprocess
            
            result = subprocess.run(
                ["python3", apply_script, str(self.sql_file)],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if result.returncode == 0:
                return {
                    'success': True,
                    'output': result.stdout,
                    'supplier_id': self.supplier_id,
                    'errors': []
                }
            else:
                return {
                    'success': False,
                    'output': result.stdout,
                    'errors': [result.stderr]
                }
                
        except subprocess.TimeoutExpired:
            return {
                'success': False,
                'errors': ['Database operation timed out after 60 seconds']
            }
        except Exception as e:
            return {
                'success': False,
                'errors': [f'Database application error: {str(e)}']
            }


class SupplierBatchService:
    """
    Batch processing service for multiple suppliers
    """
    
    def __init__(self, output_dir: str = "output"):
        self.output_dir = Path(output_dir)
        self.results: List[Dict] = []
    
    def process_folder_of_suppliers(
        self,
        parent_folder: Union[str, Path]
    ) -> Dict:
        """
        Process multiple supplier folders
        
        Args:
            parent_folder: Folder containing subfolders (one per supplier)
        
        Returns:
            Dict with success count, results, errors
        """
        parent = Path(parent_folder)
        
        if not parent.exists() or not parent.is_dir():
            return {
                'success': False,
                'errors': [f'Invalid parent folder: {parent_folder}']
            }
        
        results = []
        errors = []
        
        # Find all subfolders
        supplier_folders = [f for f in parent.iterdir() if f.is_dir()]
        
        if not supplier_folders:
            return {
                'success': False,
                'errors': ['No supplier folders found']
            }
        
        # Process each folder
        for folder in supplier_folders:
            service = SupplierOnboardingService(output_dir=self.output_dir)
            
            try:
                result = service.process_supplier(folder, name_hint=folder.name)
                results.append({
                    'folder': folder.name,
                    'result': result
                })
            except Exception as e:
                errors.append(f'{folder.name}: {str(e)}')
        
        self.results = results
        
        # Summary
        successful = sum(1 for r in results if r['result'].get('success'))
        
        return {
            'success': True,
            'total': len(supplier_folders),
            'successful': successful,
            'failed': len(supplier_folders) - successful,
            'results': results,
            'errors': errors
        }
    
    def get_batch_summary(self) -> str:
        """
        Get formatted batch processing summary
        
        Returns:
            String with summary statistics
        """
        if not self.results:
            return "No batch results available"
        
        total = len(self.results)
        successful = sum(1 for r in self.results if r['result'].get('success'))
        
        summary = f"\n{'='*70}\n"
        summary += f"BATCH PROCESSING SUMMARY\n"
        summary += f"{'='*70}\n\n"
        summary += f"Total suppliers: {total}\n"
        summary += f"Successful: {successful}\n"
        summary += f"Failed: {total - successful}\n\n"
        
        # Details
        for item in self.results:
            folder = item['folder']
            result = item['result']
            
            if result.get('success'):
                name = result.get('contractor_name', 'Unknown')
                conf = result.get('confidence', 0)
                summary += f"✅ {folder}: {name} ({conf:.0%})\n"
            else:
                errors = result.get('errors', [])
                summary += f"❌ {folder}: {errors[0] if errors else 'Unknown error'}\n"
        
        return summary


# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def quick_extract(path: Union[str, Path]) -> Dict:
    """
    Quick extraction without saving files
    
    Args:
        path: File or folder path
    
    Returns:
        Extracted data dict
    """
    service = SupplierOnboardingService()
    result = service.extract_supplier_data(path)
    return result.get('data') if result['success'] else {}


def extract_and_save(
    path: Union[str, Path],
    output_dir: str = "output"
) -> Dict:
    """
    Extract data and save to files
    
    Args:
        path: File or folder path
        output_dir: Output directory
    
    Returns:
        Result dict with file paths
    """
    service = SupplierOnboardingService(output_dir=output_dir)
    return service.process_supplier(path)


def validate_supplier_data(data: Dict) -> Tuple[bool, List[str]]:
    """
    Validate supplier data quality
    
    Args:
        data: Extracted supplier data
    
    Returns:
        Tuple of (is_valid, warnings)
    """
    warnings = []
    
    # Required
    if not data.get('contractor_name'):
        warnings.append('Missing contractor name')
    
    # Important
    if not data.get('email'):
        warnings.append('Missing email')
    if not data.get('telephone'):
        warnings.append('Missing telephone')
    if not data.get('pli_expiry_date'):
        warnings.append('Missing PLI expiry date')
    
    # Confidence
    confidence = data.get('extraction_confidence', 0)
    if confidence < 0.6:
        warnings.append(f'Low confidence: {confidence:.0%}')
    
    is_valid = bool(data.get('contractor_name')) and confidence >= 0.5
    
    return is_valid, warnings


# ============================================================================
# EXAMPLE USAGE
# ============================================================================

def example_basic_usage():
    """Example: Basic supplier onboarding"""
    
    # Create service
    service = SupplierOnboardingService(output_dir="output")
    
    # Process supplier
    result = service.process_supplier("/path/to/supplier/folder")
    
    if result['success']:
        print(f"✅ Success!")
        print(f"   Supplier: {result['contractor_name']}")
        print(f"   ID: {result['supplier_id']}")
        print(f"   Confidence: {result['confidence']:.0%}")
        print(f"   Files: {result['json_file']}, {result['sql_file']}")
    else:
        print(f"❌ Failed: {result['errors']}")


def example_with_validation():
    """Example: Extract and validate"""
    
    service = SupplierOnboardingService()
    
    # Extract
    extraction = service.extract_supplier_data("/path/to/supplier")
    
    if extraction['success']:
        # Validate
        is_valid, warnings = service.validate_extraction()
        
        if is_valid:
            print("✅ Data valid!")
        else:
            print(f"⚠️  Warnings: {warnings}")
        
        # Generate SQL if valid enough
        if is_valid or len(warnings) < 3:
            sql_result = service.generate_sql()
            service.save_files()


def example_batch_processing():
    """Example: Process multiple suppliers"""
    
    batch = SupplierBatchService(output_dir="output")
    
    # Process all suppliers in folder
    result = batch.process_folder_of_suppliers("/path/to/suppliers")
    
    print(batch.get_batch_summary())


if __name__ == '__main__':
    print(__doc__)
    print("\nThis is a service module - import and use in your code.")
    print("\nExample:")
    print("  from supplier_onboarding_service import SupplierOnboardingService")
    print("  service = SupplierOnboardingService()")
    print("  result = service.process_supplier('/path/to/supplier')")


