"""
SQL Generator - Financial Metadata Extractor
Extracts static financial context (structure, not balances)
Captures service charge years, schedules, policies, and management structure
"""

import re
from datetime import datetime, date
from dateutil import parser as date_parser
from typing import Dict, List, Optional, Set, Tuple
from collections import Counter


class FinancialMetadataExtractor:
    """Extract static financial metadata from budget and financial documents"""

    # Month names for date parsing
    MONTHS = [
        'january', 'february', 'march', 'april', 'may', 'june',
        'july', 'august', 'september', 'october', 'november', 'december',
        'jan', 'feb', 'mar', 'apr', 'may', 'jun',
        'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ]

    # Common schedule indicators
    SCHEDULE_PATTERNS = [
        r'(?i)Schedule\s*([A-Z])\s*[–\-]?\s*([^\n]{0,50})',
        r'(?i)Schedule\s*(\d+)\s*[–\-]?\s*([^\n]{0,50})',
        r'(?i)(Residential|Commercial|Car\s*Park)\s*Schedule',
    ]

    # Major cost category keywords
    COST_CATEGORIES = [
        'cleaning', 'repairs', 'maintenance', 'insurance', 'lift', 'lifts',
        'concierge', 'fire', 'electrical', 'garden', 'gardening', 'grounds',
        'pest control', 'security', 'management', 'water', 'waste',
        'utilities', 'heating', 'communal', 'repairs', 'decoration',
        'professional fees', 'legal', 'accountancy', 'audit',
        'reserve', 'contingency', 'health & safety', 'door entry',
        'intercom', 'cctv', 'alarm', 'emergency', 'window cleaning'
    ]

    # Budget status/version keywords
    VERSION_KEYWORDS = [
        'draft', 'revised', 'final', 'approved', 'adopted',
        'version', 'issue', 'amendment'
    ]

    def __init__(self):
        """Initialize extractor"""
        pass

    def extract_from_documents(self, documents: List[Dict]) -> Dict:
        """
        Extract financial metadata from all financial documents

        Args:
            documents: List of document dicts with 'text', 'document_type', 'file_name'

        Returns:
            Dictionary with financial metadata
        """
        # Aggregate data from all documents
        years = []
        year_ranges = []
        schedules = set()
        versions = []
        preparers = []
        approvals = []
        reserve_policies = []
        management_fees = []
        insurance_notes = []
        inflation_notes = []
        cost_categories = set()

        confidence_signals = {
            'year_found': False,
            'schedules_found': False,
            'preparer_found': False,
            'cost_categories': False,
            'policies_found': False
        }

        # Process each document
        for doc in documents:
            text = doc.get('text', '')
            doc_type = doc.get('document_type', '')
            file_name = doc.get('file_name', '')

            if not text:
                continue

            # Only process financial documents
            if doc_type not in ['Budget', 'Lease', 'Major_Works'] and \
               'budget' not in file_name.lower() and \
               'service charge' not in text.lower()[:500]:
                continue

            # Extract financial year/range
            year_data = self._extract_financial_year(text, file_name)
            if year_data:
                if year_data.get('year_range'):
                    year_ranges.append(year_data['year_range'])
                    confidence_signals['year_found'] = True
                if year_data.get('reference_year'):
                    years.append(year_data['reference_year'])

            # Extract schedules
            found_schedules = self._extract_schedules(text)
            if found_schedules:
                schedules.update(found_schedules)
                confidence_signals['schedules_found'] = True

            # Extract version/status
            version = self._extract_version(text, file_name)
            if version:
                versions.append(version)

            # Extract preparer
            preparer = self._extract_preparer(text, file_name)
            if preparer:
                preparers.append(preparer)
                confidence_signals['preparer_found'] = True

            # Extract approval notes
            approval = self._extract_approval_notes(text)
            if approval:
                approvals.append(approval)

            # Extract reserve policy
            reserve = self._extract_reserve_policy(text)
            if reserve:
                reserve_policies.append(reserve)
                confidence_signals['policies_found'] = True

            # Extract management fee basis
            mgmt_fee = self._extract_management_fee(text)
            if mgmt_fee:
                management_fees.append(mgmt_fee)

            # Extract insurance basis
            insurance = self._extract_insurance_basis(text)
            if insurance:
                insurance_notes.append(insurance)

            # Extract inflation assumption
            inflation = self._extract_inflation(text)
            if inflation:
                inflation_notes.append(inflation)

            # Extract cost categories
            categories = self._extract_cost_categories(text)
            cost_categories.update(categories)

        # Check cost categories signal
        if len(cost_categories) >= 3:
            confidence_signals['cost_categories'] = True

        # Aggregate results
        result = {}

        # Financial year
        if year_ranges:
            # Use most common year range
            year_range = Counter(year_ranges).most_common(1)[0][0]
            result['service_charge_year_start'] = year_range[0]
            result['service_charge_year_end'] = year_range[1]
        else:
            result['service_charge_year_start'] = None
            result['service_charge_year_end'] = None

        # Budget reference year
        result['budget_reference_year'] = Counter(years).most_common(1)[0][0] if years else None

        # Schedules
        schedule_list = sorted(list(schedules))
        result['num_schedules'] = len(schedule_list)
        result['schedule_names'] = schedule_list if schedule_list else None

        # Version
        result['budget_revision_version'] = Counter(versions).most_common(1)[0][0] if versions else None

        # Preparer
        result['budget_prepared_by'] = Counter(preparers).most_common(1)[0][0] if preparers else None

        # Approval
        result['budget_approval_notes'] = Counter(approvals).most_common(1)[0][0] if approvals else None

        # Reserve policy (use longest/most detailed)
        if reserve_policies:
            reserve_policies.sort(key=len, reverse=True)
            result['reserve_policy'] = reserve_policies[0]
        else:
            result['reserve_policy'] = None

        # Management fee
        result['management_fee_basis'] = Counter(management_fees).most_common(1)[0][0] if management_fees else None

        # Insurance
        result['insurance_basis'] = Counter(insurance_notes).most_common(1)[0][0] if insurance_notes else None

        # Inflation
        result['inflation_assumption'] = Counter(inflation_notes).most_common(1)[0][0] if inflation_notes else None

        # Cost categories
        result['major_cost_categories'] = sorted(list(cost_categories)) if cost_categories else None

        # Confidence
        result['confidence'] = self._calculate_confidence(confidence_signals)

        return result

    def _extract_financial_year(self, text: str, file_name: str) -> Optional[Dict]:
        """Extract financial year or range"""
        result = {}

        # Pattern 1: "2025/26" format
        pattern1 = r'(?i)(?:budget|service\s*charge|financial|year)?\s*(?:year|period)?\s*(\d{4})[\/\-](\d{2,4})'
        match = re.search(pattern1, text)

        if match:
            year1 = int(match.group(1))
            year2_str = match.group(2)

            # Handle 2-digit year
            if len(year2_str) == 2:
                year2 = 2000 + int(year2_str)
            else:
                year2 = int(year2_str)

            result['reference_year'] = f"{year1}/{year2_str}"

            # Assume UK financial year (April to March)
            result['year_range'] = (
                f"{year1}-04-01",
                f"{year2}-03-31"
            )
            return result

        # Pattern 2: "1 April 2025 to 31 March 2026"
        pattern2 = r'(?i)(\d{1,2}\s+(?:' + '|'.join(self.MONTHS) + r')[a-z]*\s+\d{4})\s+(?:to|-|–)\s+(\d{1,2}\s+(?:' + '|'.join(self.MONTHS) + r')[a-z]*\s+\d{4})'
        match = re.search(pattern2, text)

        if match:
            try:
                start_date = date_parser.parse(match.group(1), dayfirst=True)
                end_date = date_parser.parse(match.group(2), dayfirst=True)

                result['year_range'] = (
                    start_date.strftime('%Y-%m-%d'),
                    end_date.strftime('%Y-%m-%d')
                )
                result['reference_year'] = f"{start_date.year}/{str(end_date.year)[-2:]}"
                return result
            except:
                pass

        # Pattern 3: Infer from filename "Budget_2025.xlsx"
        filename_pattern = r'(\d{4})[\/\-]?(\d{2,4})?'
        match = re.search(filename_pattern, file_name)

        if match:
            year1 = int(match.group(1))

            if match.group(2):
                year2_str = match.group(2)
                if len(year2_str) == 2:
                    year2 = 2000 + int(year2_str)
                else:
                    year2 = int(year2_str)

                result['reference_year'] = f"{year1}/{year2_str}"
                result['year_range'] = (
                    f"{year1}-04-01",
                    f"{year2}-03-31"
                )
            else:
                # Single year - assume April to March
                result['reference_year'] = f"{year1}/{str(year1+1)[-2:]}"
                result['year_range'] = (
                    f"{year1}-04-01",
                    f"{year1+1}-03-31"
                )

            return result

        return None

    def _extract_schedules(self, text: str) -> Set[str]:
        """Extract schedule names"""
        schedules = set()

        for pattern in self.SCHEDULE_PATTERNS:
            matches = re.finditer(pattern, text)

            for match in matches:
                if len(match.groups()) == 2:
                    schedule_id = match.group(1)
                    schedule_desc = match.group(2).strip()

                    # Clean up description
                    schedule_desc = re.sub(r'\s+', ' ', schedule_desc)
                    schedule_desc = schedule_desc.strip(':-–—')

                    if schedule_desc:
                        schedule_name = f"Schedule {schedule_id} – {schedule_desc}"
                    else:
                        schedule_name = f"Schedule {schedule_id}"

                    # Limit length
                    if len(schedule_name) <= 80:
                        schedules.add(schedule_name)
                elif len(match.groups()) == 1:
                    # "Residential Schedule" format
                    schedule_type = match.group(1)
                    schedules.add(f"{schedule_type} Schedule")

        return schedules

    def _extract_version(self, text: str, file_name: str) -> Optional[str]:
        """Extract budget version/status"""
        # Look in text first
        for keyword in self.VERSION_KEYWORDS:
            pattern = f'(?i)({keyword})\\s*(budget|version|issue)?\\s*(\\d+)?'
            match = re.search(pattern, text[:2000])  # Check first 2000 chars

            if match:
                version = ' '.join(g for g in match.groups() if g).title()
                return version

        # Check filename
        for keyword in self.VERSION_KEYWORDS:
            if keyword.lower() in file_name.lower():
                return f"{keyword.title()} Budget"

        return None

    def _extract_preparer(self, text: str, file_name: str) -> Optional[str]:
        """Extract budget preparer/managing agent"""
        patterns = [
            r'(?i)(?:prepared|issued|compiled)\s*by[:\-]?\s*([A-Z][A-Za-z\s,&\.]+(?:Ltd|LLP|Limited|Management)?)',
            r'(?i)managing\s*agent[:\-]?\s*([A-Z][A-Za-z\s,&\.]+(?:Ltd|LLP|Limited|Management)?)',
            r'(?i)property\s*manager[:\-]?\s*([A-Z][A-Za-z\s,&\.]+(?:Ltd|LLP|Limited|Management)?)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                preparer = match.group(1).strip()
                # Clean up
                preparer = re.sub(r'\s+', ' ', preparer)
                preparer = preparer.strip(',;:')

                if 3 < len(preparer) < 100:
                    return preparer

        return None

    def _extract_approval_notes(self, text: str) -> Optional[str]:
        """Extract budget approval information"""
        pattern = r'(?i)(approved|agreed|ratified|adopted)\s+(?:by\s+)?(?:the\s+)?(board|directors|committee|agm|meeting)?\s*(?:on|at)?\s*(\d{1,2}\s+\w+\s+\d{4})?'
        match = re.search(pattern, text)

        if match:
            approval_text = ' '.join(g for g in match.groups() if g).strip()
            # Capitalize properly
            approval_text = approval_text[0].upper() + approval_text[1:]

            if len(approval_text) > 10:
                return f"{approval_text}"

        return None

    def _extract_reserve_policy(self, text: str) -> Optional[str]:
        """Extract reserve fund policy (not balance)"""
        patterns = [
            r'(?i)(reserve\s*(?:fund|policy|provision|contribution))[:\-]?\s*([^\n]{20,200})',
            r'(?i)(sinking\s*fund)[:\-]?\s*([^\n]{20,200})',
            r'(?i)(major\s*works\s*fund)[:\-]?\s*([^\n]{20,200})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                policy_text = match.group(0).strip()

                # Clean up
                policy_text = re.sub(r'\s+', ' ', policy_text)

                # Ensure it's a policy statement, not just a balance
                if any(keyword in policy_text.lower() for keyword in [
                    'contribution', 'policy', 'provision', 'annual', 'towards',
                    'allocated', 'budgeted', 'planned'
                ]):
                    return policy_text[:300]

        return None

    def _extract_management_fee(self, text: str) -> Optional[str]:
        """Extract management fee basis"""
        patterns = [
            r'(?i)management\s*fee[:\-]?\s*([^\n]{10,150})',
            r'(?i)managing\s*agent[:\-]?\s*fee[:\-]?\s*([^\n]{10,150})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                fee_text = match.group(0).strip()

                # Clean up
                fee_text = re.sub(r'\s+', ' ', fee_text)

                # Look for percentage or amount
                if re.search(r'\d+\.?\d*\s*%', fee_text) or \
                   re.search(r'£\s*[\d,]+', fee_text) or \
                   'percentage' in fee_text.lower() or \
                   'fixed' in fee_text.lower():
                    return fee_text[:200]

        return None

    def _extract_insurance_basis(self, text: str) -> Optional[str]:
        """Extract insurance charging basis"""
        pattern = r'(?i)insurance[:\-]?\s*(?:is\s*)?(charged|billed|recovered|recharged|apportioned)[^\n\.]{10,150}'
        match = re.search(pattern, text)

        if match:
            insurance_text = match.group(0).strip()

            # Clean up
            insurance_text = re.sub(r'\s+', ' ', insurance_text)

            # Ensure it ends at sentence boundary
            sentence_end = re.search(r'[\.;]', insurance_text)
            if sentence_end:
                insurance_text = insurance_text[:sentence_end.end()]

            return insurance_text[:200]

        return None

    def _extract_inflation(self, text: str) -> Optional[str]:
        """Extract inflation assumption"""
        pattern = r'(?i)(inflation|uplift|increase)[:\-]?\s*(\d{1,2}(?:\.\d+)?)\s*(%|percent|uplift|applied)'
        match = re.search(pattern, text)

        if match:
            # Extract the percentage
            percent = match.group(2)

            # Ensure it has % sign
            if not re.search(r'%', match.group(0)):
                percent += '%'
            else:
                percent = match.group(2) + '%'

            return percent

        return None

    def _extract_cost_categories(self, text: str) -> Set[str]:
        """Extract major cost category headings"""
        found = set()
        text_lower = text.lower()

        for category in self.COST_CATEGORIES:
            # Look for category as a heading or label
            pattern = f'(?i)\\b{re.escape(category)}\\b'

            if re.search(pattern, text_lower):
                # Normalize name
                found.add(category.title())

        return found

    def _calculate_confidence(self, signals: Dict[str, bool]) -> float:
        """Calculate confidence score"""
        score = 0.0

        if signals['year_found']:
            score += 0.4
        if signals['cost_categories']:
            score += 0.2
        if signals['schedules_found'] or signals['preparer_found']:
            score += 0.2
        if signals['policies_found']:
            score += 0.1

        return round(score, 2)


# Test function
if __name__ == '__main__':
    extractor = FinancialMetadataExtractor()

    # Test data
    test_budget_text = """
    SERVICE CHARGE BUDGET 2025/26

    Prepared by: MIH Property Management Ltd

    Period: 1 April 2025 to 31 March 2026

    SCHEDULE A – RESIDENTIAL UNITS
    SCHEDULE B – CAR PARK

    BUDGET SUMMARY

    Cleaning                £12,500
    Repairs & Maintenance   £8,000
    Insurance               £15,000
    Lift Servicing          £6,000
    Management Fee          £9,500 (10% of expenditure)
    Fire Alarm Maintenance  £3,200
    Concierge               £45,000

    Reserve Fund: Annual contribution of £24,000 towards long-term roof works

    Insurance: Recharged via separate block policy at actual cost

    Inflation: 5% uplift applied to prior year figures

    This Revised Budget was approved by the Board on 9 October 2025.
    """

    test_doc = {
        'text': test_budget_text,
        'document_type': 'Budget',
        'file_name': 'Budget_2025_26_Revised.xlsx'
    }

    result = extractor.extract_from_documents([test_doc])

    print("Financial Metadata Extraction Results:")
    print("=" * 60)
    for key, value in result.items():
        print(f"{key}: {value}")
