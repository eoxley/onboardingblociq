"""
BlocIQ Onboarder - Document Classifier
Intelligently classifies parsed files into categories based on content and filename
"""

import re
from typing import Dict, List, Optional, Tuple


class DocumentClassifier:
    """Classifies documents into BlocIQ categories"""

    # Category patterns based on Pimlico Place data structure
    CATEGORIES = {
        'units_leaseholders': {
            'keywords': ['leaseholder', 'unit', 'tenant', 'flat', 'owner', 'lease list'],
            'filename_patterns': [
                r'.*leaseholder.*list.*',
                r'.*unit.*list.*',
                r'.*tenant.*list.*',
                r'.*property.*form.*'
            ],
            'column_patterns': ['unit', 'flat', 'leaseholder', 'owner', 'tenant', 'name', 'address']
        },
        'budgets': {
            'keywords': ['budget', 'service charge', 'expenditure', 'income', 'year end', 'ye 20'],
            'filename_patterns': [
                r'.*budget.*',
                r'.*ye\s*\d{2}.*',
                r'.*year\s*end.*',
                r'.*accounts.*'
            ],
            'column_patterns': ['budget', 'expenditure', 'income', 'total', 'ye', 'year']
        },
        'arrears': {
            'keywords': ['arrears', 'aged debtors', 'demand', 'balance', 'outstanding'],
            'filename_patterns': [
                r'.*arrears.*',
                r'.*aged.*debtor.*',
                r'.*demand.*',
                r'.*balance.*'
            ],
            'column_patterns': ['arrears', 'balance', 'debt', 'outstanding', 'current charge']
        },
        'compliance': {
            'keywords': ['fra', 'fire risk', 'certificate', 'inspection', 'compliance',
                        'asbestos', 'electrical', 'gas', 'lift', 'legionella', 'eicr'],
            'filename_patterns': [
                r'.*fra.*',
                r'.*fire.*risk.*',
                r'.*certificate.*',
                r'.*inspection.*',
                r'.*compliance.*',
                r'.*eicr.*',
                r'.*asbestos.*',
                r'.*gas.*safety.*',
                r'.*lift.*report.*'
            ],
            'content_patterns': ['fire risk assessment', 'compliance', 'certificate',
                               'inspection date', 'expiry', 'valid until']
        },
        'contracts': {
            'keywords': ['contract', 'contractor', 'service agreement', 'sla', 'supplier'],
            'filename_patterns': [
                r'.*contract.*',
                r'.*contractor.*',
                r'.*agreement.*',
                r'.*supplier.*'
            ],
            'content_patterns': ['contract', 'service provider', 'agreement', 'renewal date']
        },
        'major_works': {
            'keywords': ['major works', 'project', 'schedule of works', 'estimate',
                        'quote', 'tender', 'section 20'],
            'filename_patterns': [
                r'.*major.*works.*',
                r'.*schedule.*works.*',
                r'.*estimate.*',
                r'.*quote.*',
                r'.*tender.*',
                r'.*section.*20.*',
                r'.*s20.*'
            ],
            'content_patterns': ['major works', 'schedule of works', 'project',
                               'estimated cost', 'tender']
        },
        'staff': {
            'keywords': ['staff', 'payroll', 'salary', 'employee', 'porter', 'building manager'],
            'filename_patterns': [
                r'.*staff.*',
                r'.*payroll.*',
                r'.*salary.*',
                r'.*employee.*',
                r'.*time.*table.*'
            ],
            'column_patterns': ['staff', 'employee', 'name', 'salary', 'rate']
        },
        'apportionments': {
            'keywords': ['apportionment', 'percentage', 'share', 'allocation', 'sq footage'],
            'filename_patterns': [
                r'.*apportion.*',
                r'.*percentage.*',
                r'.*sq.*footage.*'
            ],
            'column_patterns': ['unit', 'flat', '%', 'percentage', 'share', 'apportionment']
        },
        'insurance': {
            'keywords': ['insurance', 'policy', 'claim', 'premium', 'cover'],
            'filename_patterns': [
                r'.*insurance.*',
                r'.*policy.*',
                r'.*claim.*'
            ],
            'content_patterns': ['insurance', 'policy', 'premium', 'insurer']
        }
    }

    def classify(self, parsed_data: Dict) -> Tuple[str, float]:
        """
        Classify a parsed document

        Args:
            parsed_data: Dictionary from parsers.py

        Returns:
            Tuple of (category, confidence_score)
        """
        filename = parsed_data.get('file_name', '').lower()
        scores = {}

        # Score each category
        for category, patterns in self.CATEGORIES.items():
            score = 0.0

            # Check filename patterns (weight: 0.4)
            for pattern in patterns.get('filename_patterns', []):
                if re.search(pattern, filename, re.IGNORECASE):
                    score += 0.4
                    break

            # Check keywords in filename (weight: 0.2)
            for keyword in patterns.get('keywords', []):
                if keyword.lower() in filename:
                    score += 0.2
                    break

            # Check content if available
            content = self._extract_content(parsed_data)

            # Check content patterns (weight: 0.3)
            for pattern in patterns.get('content_patterns', []):
                if pattern.lower() in content.lower():
                    score += 0.3
                    break

            # Check column patterns for Excel/CSV (weight: 0.1)
            columns = self._extract_columns(parsed_data)
            for col_pattern in patterns.get('column_patterns', []):
                if any(col_pattern.lower() in col.lower() for col in columns):
                    score += 0.1
                    break

            scores[category] = min(score, 1.0)  # Cap at 1.0

        # Get highest scoring category
        if not scores or max(scores.values()) < 0.2:
            return 'uncategorized', 0.0

        best_category = max(scores, key=scores.get)
        confidence = scores[best_category]

        return best_category, confidence

    def _extract_content(self, parsed_data: Dict) -> str:
        """Extract text content from parsed data"""
        if 'full_text' in parsed_data:
            return parsed_data['full_text'][:1000]  # First 1000 chars

        if 'paragraphs' in parsed_data:
            return ' '.join(parsed_data['paragraphs'][:5])

        if 'text_content' in parsed_data:
            texts = [t.get('text', '') for t in parsed_data['text_content'][:3]]
            return ' '.join(texts)

        return ''

    def _extract_columns(self, parsed_data: Dict) -> List[str]:
        """Extract column names from Excel/CSV data"""
        columns = []

        # Direct columns field
        if 'columns' in parsed_data:
            return [str(c).lower() for c in parsed_data['columns']]

        # Excel sheets
        if 'data' in parsed_data and isinstance(parsed_data['data'], dict):
            for sheet_data in parsed_data['data'].values():
                if 'columns' in sheet_data:
                    columns.extend([str(c).lower() for c in sheet_data['columns']])

        return columns

    def classify_folder(self, parsed_files: List[Dict]) -> Dict[str, List[Dict]]:
        """
        Classify multiple parsed files

        Args:
            parsed_files: List of parsed file dictionaries

        Returns:
            Dictionary mapping categories to lists of files
        """
        categorized = {
            'units_leaseholders': [],
            'budgets': [],
            'arrears': [],
            'compliance': [],
            'contracts': [],
            'major_works': [],
            'staff': [],
            'apportionments': [],
            'insurance': [],
            'uncategorized': []
        }

        for parsed_file in parsed_files:
            category, confidence = self.classify(parsed_file)

            categorized[category].append({
                **parsed_file,
                'category': category,
                'confidence': confidence
            })

        return categorized
