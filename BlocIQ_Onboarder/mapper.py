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

    def map_document_with_entities(self, file_metadata: Dict, building_id: str, category: str) -> List[Dict]:
        """
        DUAL-WRITE PATTERN: Map document to both specialized table AND building_documents
        Returns list of records to insert: [specialized_record, document_record]
        """
        records = []

        if category == 'compliance':
            # Create compliance asset record
            compliance_asset = self.schema_mapper.map_compliance_asset(file_metadata, building_id, category)
            records.append(('compliance_assets', compliance_asset))

            # Create linked building_documents record
            doc_record = self.schema_mapper.map_building_documents(
                file_metadata, building_id, category,
                linked_entity_id=compliance_asset['id'],
                entity_type='compliance_asset'
            )
            records.append(('building_documents', doc_record))

        elif category == 'major_works':
            # Create major works project record
            major_works = self.schema_mapper.map_major_works(file_metadata, building_id)
            records.append(('major_works_projects', major_works))

            # Create linked building_documents record
            doc_record = self.schema_mapper.map_building_documents(
                file_metadata, building_id, category,
                linked_entity_id=major_works['id'],
                entity_type='major_works'
            )
            records.append(('building_documents', doc_record))

        elif category == 'budgets':
            # Create finance record
            finance = self.schema_mapper.map_finance(file_metadata, building_id)
            records.append(('finances', finance))

            # Create linked building_documents record
            doc_record = self.schema_mapper.map_building_documents(
                file_metadata, building_id, category,
                linked_entity_id=finance['id'],
                entity_type='finance'
            )
            records.append(('building_documents', doc_record))

        else:
            # For other categories, just create building_documents record
            doc_record = self.schema_mapper.map_building_documents(
                file_metadata, building_id, category
            )
            records.append(('building_documents', doc_record))

        return records

