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

    def __init__(self, agency_id: str = '00000000-0000-0000-0000-000000000001'):
        self.agency_id = agency_id
        self.schema_mapper = SupabaseSchemaMapper(agency_id)

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

    def map_building_documents(self, file_metadata: Dict, building_id: str, category: str = 'uncategorized') -> Dict:
        """
        Map file metadata to building_documents table using exact schema
        """
        return self.schema_mapper.map_building_documents(file_metadata, building_id, category)

