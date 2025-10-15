#!/usr/bin/env python3
"""
Supplier SQL Generator
======================
Generates Supabase INSERT statements for supplier onboarding data

Input: JSON with extracted supplier/contractor data
Output: SQL file ready to apply to Supabase
Note: Uses "suppliers" table to avoid conflict with "contractors" table
"""

import json
import uuid
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime


class SupplierSQLGenerator:
    """Generate SQL INSERT statements for supplier onboarding"""
    
    def __init__(self):
        self.supplier_id = str(uuid.uuid4())
        self.storage_bucket = "supplier_documents"
    
    def generate_sql(self, contractor_data: Dict, output_file: str = None) -> str:
        """
        Generate SQL INSERT statement for contractor
        
        Args:
            contractor_data: Dictionary with extracted contractor data
            output_file: Optional output file path
            
        Returns:
            SQL string
        """
        sql_parts = []
        
        # Header
        sql_parts.append(self._generate_header(contractor_data))
        
        # Main contractor INSERT
        sql_parts.append(self._generate_contractor_insert(contractor_data))
        
        # Documents INSERT (if applicable)
        if contractor_data.get('documents_found'):
            sql_parts.append(self._generate_documents_insert(contractor_data))
        
        # Footer
        sql_parts.append(self._generate_footer())
        
        sql = '\n\n'.join(sql_parts)
        
        # Save to file if specified
        if output_file:
            with open(output_file, 'w') as f:
                f.write(sql)
            print(f"\n✅ SQL generated: {output_file}")
        
        return sql
    
    def _generate_header(self, data: Dict) -> str:
        """Generate SQL header"""
        contractor_name = data.get('contractor_name', 'Unknown Supplier')
        
        return f"""-- ============================================================================
-- Supplier Onboarding: {contractor_name}
-- ============================================================================
-- Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
-- Supplier ID: {self.supplier_id}
-- Storage: {self.storage_bucket}/{self.supplier_id}/
-- ============================================================================

BEGIN;"""
    
    def _generate_contractor_insert(self, data: Dict) -> str:
        """Generate main contractor INSERT statement"""
        
        def sql_escape(val):
            if val is None:
                return 'NULL'
            if isinstance(val, bool):
                return 'TRUE' if val else 'FALSE'
            if isinstance(val, (int, float)):
                return str(val)
            if isinstance(val, list):
                # Convert array to PostgreSQL array format
                if not val:
                    return 'NULL'
                escaped_items = [f"'{str(item).replace(chr(39), chr(39)+chr(39))}'" for item in val]
                return f"ARRAY[{', '.join(escaped_items)}]"
            # String
            return f"'{str(val).replace(chr(39), chr(39)+chr(39))}'"
        
        # Parse PLI expiry date if present
        pli_expiry = data.get('pli_expiry_date')
        if pli_expiry and isinstance(pli_expiry, str):
            # Try to parse date
            try:
                # Try different formats
                for fmt in ['%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d', '%d/%m/%y']:
                    try:
                        dt = datetime.strptime(pli_expiry, fmt)
                        pli_expiry = dt.strftime('%Y-%m-%d')
                        break
                    except:
                        continue
            except:
                pli_expiry = None
        
        return f"""
-- ============================================================================
-- Supplier Onboarding Record
-- ============================================================================

INSERT INTO suppliers (
    id,
    contractor_name,
    address,
    postcode,
    email,
    telephone,
    services_provided,
    bank_account_name,
    bank_sort_code,
    pli_expiry_date,
    has_audited_accounts,
    has_certificate_of_incorporation,
    source_document,
    extraction_method,
    extraction_confidence,
    onboarding_status,
    total_documents_uploaded,
    documents_storage_folder
)
VALUES (
    '{self.supplier_id}',
    {sql_escape(data.get('contractor_name'))},
    {sql_escape(data.get('address'))},
    {sql_escape(data.get('postcode'))},
    {sql_escape(data.get('email'))},
    {sql_escape(data.get('telephone'))},
    {sql_escape(data.get('services_provided'))},
    {sql_escape(data.get('bank_account_name'))},
    {sql_escape(data.get('bank_sort_code'))},
    {f"'{pli_expiry}'" if pli_expiry else 'NULL'},
    {sql_escape(data.get('has_audited_accounts', False))},
    {sql_escape(data.get('has_certificate_of_incorporation', False))},
    {sql_escape(data.get('source_document'))},
    {sql_escape(data.get('extraction_method'))},
    {sql_escape(data.get('extraction_confidence', 0))},
    'pending',
    {len(data.get('documents_found', []))},
    '{self.storage_bucket}/{self.supplier_id}/'
);"""
    
    def _generate_documents_insert(self, data: Dict) -> str:
        """Generate document tracking INSERT statements"""
        
        documents = data.get('documents_found', [])
        if not documents:
            return ""
        
        sql_parts = ["""
-- ============================================================================
-- Supplier Documents
-- ============================================================================"""]
        
        for doc in documents:
            doc_id = str(uuid.uuid4())
            doc_name = doc.get('file_name', 'Unknown')
            
            # Infer document type from filename
            name_lower = doc_name.lower()
            if 'pli' in name_lower or 'liability' in name_lower or 'insurance' in name_lower:
                doc_type = 'PLI Certificate'
            elif 'accounts' in name_lower or 'financial' in name_lower:
                doc_type = 'Audited Accounts'
            elif 'incorporation' in name_lower or 'companies house' in name_lower:
                doc_type = 'Certificate of Incorporation'
            elif 'bank' in name_lower:
                doc_type = 'Bank Details'
            else:
                doc_type = 'Other'
            
            storage_path = f"{self.storage_bucket}/{self.supplier_id}/{doc_name}"
            
            sql_parts.append(f"""
INSERT INTO supplier_documents (
    id,
    supplier_id,
    document_type,
    document_name,
    file_name,
    file_size_bytes,
    storage_bucket,
    storage_path,
    document_status
)
VALUES (
    '{doc_id}',
    '{self.supplier_id}',
    '{doc_type}',
    '{doc_name.replace(chr(39), chr(39)+chr(39))}',
    '{doc_name.replace(chr(39), chr(39)+chr(39))}',
    {doc.get('file_size', 0)},
    '{self.storage_bucket}',
    '{storage_path}',
    'pending_review'
);""")
        
        return '\n'.join(sql_parts)
    
    def _generate_footer(self) -> str:
        """Generate SQL footer"""
        return f"""
COMMIT;

-- ============================================================================
-- Verification Query
-- ============================================================================

SELECT 
    contractor_name,
    email,
    telephone,
    postcode,
    services_provided,
    onboarding_status,
    extraction_confidence,
    total_documents_uploaded
FROM suppliers 
WHERE id = '{self.supplier_id}';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: {self.storage_bucket}/{self.supplier_id}/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier
"""


def main():
    """CLI entry point"""
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python3 contractor_sql_generator.py <supplier_data.json> [-o output.sql]")
        sys.exit(1)
    
    json_file = sys.argv[1]
    output_file = sys.argv[3] if len(sys.argv) > 3 and sys.argv[2] == '-o' else None
    
    if not output_file:
        output_file = json_file.replace('.json', '_supplier.sql')
    
    # Load data
    with open(json_file, 'r') as f:
        data = json.load(f)
    
    # Generate SQL
    generator = SupplierSQLGenerator()
    sql = generator.generate_sql(data, output_file)
    
    print(f"\n📊 Generated SQL for: {data.get('contractor_name', 'Unknown')}")
    print(f"   Supplier ID: {generator.supplier_id}")
    print(f"   Storage path: {generator.storage_bucket}/{generator.supplier_id}/")
    print(f"\n✅ Ready to apply to Supabase!")


if __name__ == '__main__':
    main()

