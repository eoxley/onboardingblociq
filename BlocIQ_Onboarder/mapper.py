"""
BlocIQ Onboarder - Data Mapper
Maps parsed data to Supabase schema using exact column names and relationships
"""

import re
from typing import Dict, List, Optional, Any
from datetime import datetime
import uuid
from schema_mapper import SupabaseSchemaMapper


class SupabaseMapper:
    """Maps raw data to Supabase table schemas with exact column compliance"""

    def __init__(self, agency_id: str = '00000000-0000-0000-0000-000000000001', folder_name: str = None):
        self.agency_id = agency_id
        self.schema_mapper = SupabaseSchemaMapper(agency_id, folder_name)

    def map_building(self, property_form_data: Dict, leaseholder_data: Dict = None) -> Dict:
        """
        Map property form and leaseholder data to buildings table using exact schema
        """
        return self.schema_mapper.map_building(property_form_data, leaseholder_data)

    def map_units(self, leaseholder_data: Dict, building_id: str) -> List[Dict]:
        """
        Map leaseholder data to units table using exact schema
        """
        return self.schema_mapper.map_units(leaseholder_data, building_id)

    def map_leaseholders(self, leaseholder_data: Dict, unit_map: Dict[str, str]) -> List[Dict]:
        """
        Map leaseholder data to leaseholders table using exact schema
        """
        return self.schema_mapper.map_leaseholders(leaseholder_data, unit_map)

    def map_building_documents(self, file_metadata: Dict, building_id: str, category: str = 'uncategorized',
                               linked_entity_id: str = None, entity_type: str = None) -> Dict:
        """
        Map file metadata to building_documents table using exact schema - ENHANCED with linkage
        """
        return self.schema_mapper.map_building_documents(file_metadata, building_id, category,
                                                          linked_entity_id, entity_type)

    def map_document_with_entities(self, file_metadata: Dict, building_id: str, category: str) -> List[tuple]:
        """
        BlocIQ V2 DUAL-WRITE PATTERN
        Always inserts original document into building_documents with proper category
        Inserts structured data into specialist tables where applicable
        Tracks uncategorised documents for manual review
        Returns: [(table_name, record_dict), ...]
        """
        records = []
        raw_category = category  # Store original category before normalization

        # Step 1: ALWAYS create building_documents record first
        doc_record = self.schema_mapper.map_building_documents(
            file_metadata, building_id, category
        )
        doc_id = doc_record['id']
        normalized_category = doc_record['category']  # Get normalized category from doc_record

        # Step 2: Track uncategorised documents for manual review
        if normalized_category == 'uncategorised':
            uncategorised_record = self.schema_mapper.map_uncategorised_doc(
                building_id=building_id,
                document_id=doc_id,
                file_name=file_metadata['file_name'],
                storage_path=doc_record['storage_path'],
                raw_category=raw_category
            )
            records.append(('uncategorised_docs', uncategorised_record))

        # Step 3: Create specialized table records based on category
        if normalized_category == 'compliance':
            # Compliance: document + compliance_asset + building_compliance_asset link
            compliance_asset = self.schema_mapper.map_compliance_asset(file_metadata, building_id, normalized_category)
            records.append(('compliance_assets', compliance_asset))

            # Link building to compliance asset with document reference - BlocIQ V2
            # Includes: last_test_date, next_due_date (calculated), status (compliant/overdue/due_soon), frequency
            compliance_link = self.schema_mapper.map_building_compliance_asset(
                building_id=building_id,
                compliance_asset_id=compliance_asset['id'],
                document_id=doc_id,
                last_test_date=compliance_asset.get('last_inspection_date'),  # from compliance_asset
                next_due_date=compliance_asset.get('next_due_date'),  # auto-calculated
                status=compliance_asset.get('status', 'pending'),  # compliant/overdue/due_soon/pending
                frequency=compliance_asset.get('inspection_frequency', 'annual')  # annual/biannual/quinquennial
            )
            records.append(('building_compliance_assets', compliance_link))

            # Update document with linkage
            doc_record['linked_entity_id'] = compliance_asset['id']
            doc_record['entity_type'] = 'compliance_asset'
            doc_record['document_id'] = compliance_asset['id']

        elif normalized_category == 'major_works':
            # Major works: document + project + notice link
            major_works_data, notice_type = self.schema_mapper.map_major_works(file_metadata, building_id)
            records.append(('major_works_projects', major_works_data))

            # Create notice linking project to document
            if notice_type:
                notice = self.schema_mapper.map_major_works_notice(
                    project_id=major_works_data['id'],
                    document_id=doc_id,
                    notice_type=notice_type
                )
                records.append(('major_works_notices', notice))

            # Update document with linkage
            doc_record['linked_entity_id'] = major_works_data['id']
            doc_record['entity_type'] = 'major_works_project'
            doc_record['document_id'] = major_works_data['id']

        elif normalized_category == 'finance':
            # Finance: document + budget (apportionments handled separately)
            budget = self.schema_mapper.map_budget(file_metadata, building_id, doc_id)
            records.append(('budgets', budget))

            # Update document with linkage
            doc_record['linked_entity_id'] = budget['id']
            doc_record['entity_type'] = 'budget'
            doc_record['document_id'] = budget['id']

        # All categories get a building_documents record
        records.append(('building_documents', doc_record))

        return records

