"""
BlocIQ Onboarder - Data Collator
Intelligently merges data from multiple sources with conflict resolution
"""

from typing import Dict, List, Any, Optional, Tuple
from datetime import datetime
import hashlib
import re


class DataCollator:
    """Merges and reconciles data from multiple file sources"""

    def __init__(self):
        self.conflicts = []
        self.merge_log = []
        self.unit_sources = []
        self.leaseholder_sources = []

    @staticmethod
    def normalize_unit_number(unit_number: str) -> str:
        """
        Normalize unit numbers to a consistent format for deduplication.

        Examples:
            "Flat A1" -> "A1"
            "A1" -> "A1"
            "Flat 1" -> "Flat 1"
            "Pimlico Place - Flat A1" -> "A1"
        """
        if not unit_number:
            return unit_number

        # Remove building name prefixes (e.g., "Pimlico Place - ")
        unit_number = re.sub(r'^.*?\s*-\s*', '', unit_number)

        # For "Flat A1" style, extract just "A1"
        match = re.search(r'Flat\s+([A-Z]\d+)', unit_number, re.IGNORECASE)
        if match:
            return match.group(1).upper()

        # For "Flat 1" (numeric only), keep as is
        match = re.search(r'Flat\s+(\d+)', unit_number, re.IGNORECASE)
        if match:
            return f"Flat {match.group(1)}"

        # Already in clean format like "A1"
        return unit_number.strip()

    def add_units_source(self, units: List[Dict], source_file: str, source_type: str, confidence: float = 0.90):
        """Add a source of unit data for collation"""
        for unit in units:
            unit['_source'] = source_file
            unit['_source_type'] = source_type
            unit['_confidence'] = confidence
        self.unit_sources.append({
            'source_file': source_file,
            'units': units,
            'confidence': confidence
        })

    def add_leaseholders_source(self, leaseholders: List[Dict], source_file: str, source_type: str, confidence: float = 0.90):
        """Add a source of leaseholder data for collation"""
        for lh in leaseholders:
            lh['_source'] = source_file
            lh['_source_type'] = source_type
            lh['_confidence'] = confidence
        self.leaseholder_sources.append({
            'source_file': source_file,
            'leaseholders': leaseholders,
            'confidence': confidence
        })

    def get_merged_units(self) -> List[Dict]:
        """Get merged units from all sources"""
        if not self.unit_sources:
            return []
        merged_units, _ = self.collate_units(self.unit_sources)
        return merged_units

    def get_merged_leaseholders(self) -> List[Dict]:
        """Get merged leaseholders from all sources"""
        if not self.leaseholder_sources:
            return []
        merged_leaseholders, _ = self.collate_leaseholders(self.leaseholder_sources)
        return merged_leaseholders

    def collate_units(self, unit_sources: List[Dict]) -> Tuple[List[Dict], Dict]:
        """
        Collate units from multiple sources, merging by normalized unit_number

        Args:
            unit_sources: List of {'source_file': str, 'units': List[Dict]}

        Returns:
            Tuple of (merged_units, collation_report)
        """
        # Group units by normalized unit_number
        units_by_number = {}

        for source in unit_sources:
            source_file = source.get('source_file', 'unknown')
            units = source.get('units', [])

            for unit in units:
                unit_number = unit.get('unit_number')
                if not unit_number:
                    continue

                # Normalize the unit number for deduplication
                normalized_number = self.normalize_unit_number(unit_number)

                # Store original unit_number but group by normalized
                unit['_original_unit_number'] = unit_number
                unit['unit_number'] = normalized_number  # Update to normalized version

                if normalized_number not in units_by_number:
                    units_by_number[normalized_number] = []

                # Add source tracking
                unit['_source'] = source_file
                unit['_extracted_at'] = datetime.now().isoformat()
                units_by_number[normalized_number].append(unit)

        # Merge each group
        merged_units = []
        for unit_number, unit_list in units_by_number.items():
            merged = self._merge_unit_records(unit_number, unit_list)
            merged_units.append(merged)

        # Generate report
        report = {
            'total_units': len(merged_units),
            'source_count': len(unit_sources),
            'conflicts': self.conflicts,
            'merge_log': self.merge_log
        }

        return merged_units, report

    def collate_leaseholders(self, leaseholder_sources: List[Dict]) -> Tuple[List[Dict], Dict]:
        """
        Collate leaseholders from multiple sources, merging by unit_id

        Args:
            leaseholder_sources: List of {'source_file': str, 'leaseholders': List[Dict]}

        Returns:
            Tuple of (merged_leaseholders, collation_report)
        """
        # Group leaseholders by unit_id
        leaseholders_by_unit = {}

        for source in leaseholder_sources:
            source_file = source.get('source_file', 'unknown')
            leaseholders = source.get('leaseholders', [])

            for lh in leaseholders:
                unit_id = lh.get('unit_id')
                if not unit_id:
                    continue

                if unit_id not in leaseholders_by_unit:
                    leaseholders_by_unit[unit_id] = []

                # Add source tracking
                lh['_source'] = source_file
                lh['_extracted_at'] = datetime.now().isoformat()
                leaseholders_by_unit[unit_id].append(lh)

        # Merge each group
        merged_leaseholders = []
        for unit_id, lh_list in leaseholders_by_unit.items():
            merged = self._merge_leaseholder_records(unit_id, lh_list)
            merged_leaseholders.append(merged)

        # Generate report
        report = {
            'total_leaseholders': len(merged_leaseholders),
            'source_count': len(leaseholder_sources),
            'conflicts': self.conflicts,
            'merge_log': self.merge_log
        }

        return merged_leaseholders, report

    def _merge_unit_records(self, unit_number: str, unit_list: List[Dict]) -> Dict:
        """
        Merge multiple unit records into one, preferring most complete data
        """
        if len(unit_list) == 1:
            return unit_list[0]

        # Start with first record
        merged = unit_list[0].copy()
        sources = [unit_list[0].get('_source', 'unknown')]

        # Merge additional records
        for unit in unit_list[1:]:
            sources.append(unit.get('_source', 'unknown'))

            # Merge each field, preferring non-null values
            for key, value in unit.items():
                if key.startswith('_'):
                    continue  # Skip metadata

                existing_value = merged.get(key)

                # If current value is None/empty, use new value
                if existing_value is None or existing_value == '':
                    merged[key] = value
                # If new value is None/empty, keep existing
                elif value is None or value == '':
                    continue
                # Both have values - check for conflict
                elif existing_value != value:
                    # Special handling for apportionment_percent
                    if key == 'apportionment_percent':
                        # Use the more precise value (more decimal places)
                        if self._decimal_places(value) > self._decimal_places(existing_value):
                            merged[key] = value
                            self.merge_log.append({
                                'unit': unit_number,
                                'field': key,
                                'action': 'used_more_precise',
                                'old': existing_value,
                                'new': value
                            })
                    else:
                        # Log conflict
                        self.conflicts.append({
                            'type': 'unit',
                            'unit_number': unit_number,
                            'field': key,
                            'values': [existing_value, value],
                            'sources': sources,
                            'resolution': 'kept_first'
                        })

        # Add metadata about merge
        merged['_merged_from'] = sources
        merged['_merge_count'] = len(unit_list)

        return merged

    def _merge_leaseholder_records(self, unit_id: str, lh_list: List[Dict]) -> Dict:
        """
        Merge multiple leaseholder records, combining contact info
        """
        if len(lh_list) == 1:
            return lh_list[0]

        # Start with first record
        merged = lh_list[0].copy()
        sources = [lh_list[0].get('_source', 'unknown')]

        # Merge additional records
        for lh in lh_list[1:]:
            sources.append(lh.get('_source', 'unknown'))

            # Merge contact fields - prefer non-empty values
            for key in ['phone', 'phone_number', 'email', 'correspondence_address']:
                existing = merged.get(key)
                new_value = lh.get(key)

                if new_value and (not existing or len(str(new_value)) > len(str(existing))):
                    if existing and existing != new_value:
                        # Log when we're replacing a value
                        self.merge_log.append({
                            'unit_id': unit_id,
                            'field': key,
                            'action': 'replaced',
                            'old': existing,
                            'new': new_value,
                            'sources': sources
                        })
                    merged[key] = new_value

            # Name conflict handling
            if lh.get('name') and merged.get('name') != lh.get('name'):
                self.conflicts.append({
                    'type': 'leaseholder',
                    'unit_id': unit_id,
                    'field': 'name',
                    'values': [merged.get('name'), lh.get('name')],
                    'sources': sources,
                    'resolution': 'kept_first'
                })

        # Add metadata
        merged['_merged_from'] = sources
        merged['_merge_count'] = len(lh_list)

        return merged

    def collate_financials(self, financial_sources: List[Dict]) -> Dict:
        """
        Collate financial data (budgets, accounts) from multiple sources
        Prefers most recent data
        """
        if not financial_sources:
            return {}

        # Sort by year/date if available
        sorted_sources = sorted(
            financial_sources,
            key=lambda x: x.get('year', 0),
            reverse=True
        )

        # Start with most recent
        merged = sorted_sources[0].copy()
        merged['_sources'] = [s.get('source_file', 'unknown') for s in sorted_sources]

        # Merge budget items from other years
        all_budget_items = merged.get('budget_items', [])

        for source in sorted_sources[1:]:
            source_items = source.get('budget_items', [])
            for item in source_items:
                # Add if not already present
                if item not in all_budget_items:
                    all_budget_items.append(item)

        merged['budget_items'] = all_budget_items

        return merged

    def generate_data_quality_report(self) -> Dict:
        """
        Generate comprehensive data quality report
        """
        return {
            'conflicts_count': len(self.conflicts),
            'conflicts': self.conflicts,
            'merges_count': len(self.merge_log),
            'merge_log': self.merge_log[:50],  # Limit to first 50
            'recommendations': self._generate_recommendations()
        }

    def _generate_recommendations(self) -> List[str]:
        """Generate recommendations based on collation results"""
        recommendations = []

        if len(self.conflicts) > 0:
            recommendations.append(
                f"Found {len(self.conflicts)} conflicts that need manual review"
            )

        # Check for name conflicts
        name_conflicts = [c for c in self.conflicts if c.get('field') == 'name']
        if name_conflicts:
            recommendations.append(
                f"{len(name_conflicts)} leaseholder name conflicts - verify correct names"
            )

        # Check for apportionment issues
        apportion_conflicts = [c for c in self.conflicts if c.get('field') == 'apportionment_percent']
        if apportion_conflicts:
            recommendations.append(
                f"{len(apportion_conflicts)} apportionment conflicts - verify correct percentages"
            )

        if len(self.merge_log) > 0:
            recommendations.append(
                f"Successfully merged data from {len(self.merge_log)} fields"
            )

        return recommendations

    def _decimal_places(self, value) -> int:
        """Count decimal places in a number"""
        try:
            s = str(float(value))
            if '.' in s:
                return len(s.split('.')[1])
            return 0
        except (ValueError, TypeError):
            return 0

    def export_conflicts_csv(self) -> str:
        """Export conflicts to CSV format for review"""
        if not self.conflicts:
            return "type,identifier,field,values,sources,resolution\n"

        lines = ["type,identifier,field,values,sources,resolution"]

        for conflict in self.conflicts:
            identifier = conflict.get('unit_number') or conflict.get('unit_id')
            values_str = ' vs '.join(str(v) for v in conflict.get('values', []))
            sources_str = '; '.join(conflict.get('sources', []))

            line = ','.join([
                conflict.get('type', ''),
                identifier,
                conflict.get('field', ''),
                f'"{values_str}"',
                f'"{sources_str}"',
                conflict.get('resolution', '')
            ])
            lines.append(line)

        return '\n'.join(lines)
