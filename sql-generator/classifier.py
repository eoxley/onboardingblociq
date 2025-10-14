"""
SQL Generator - Document Classification
Classifies documents based on filename and content patterns
"""

import re
from pathlib import Path
from typing import Dict, Optional, Tuple


class DocumentClassifier:
    """Classify documents into compliance and property management categories"""

    # Document type patterns based on keywords and content
    DOCUMENT_TYPES = {
        'FRA': {
            'keywords': ['fire risk', 'fra', 'fire assessment', 'fire safety'],
            'filename_patterns': [
                r'.*fra.*',
                r'.*fire.*risk.*',
                r'.*fire.*assess.*'
            ]
        },
        'EICR': {
            'keywords': ['electrical installation', 'eicr', 'electrical inspection',
                        'electrical condition', 'periodic inspection'],
            'filename_patterns': [
                r'.*eicr.*',
                r'.*electrical.*inspect.*',
                r'.*electrical.*condition.*',
                r'.*periodic.*inspection.*'
            ]
        },
        'Asbestos': {
            'keywords': ['asbestos', 'asbestos survey', 'asbestos register',
                        'asbestos management', 'acm'],
            'filename_patterns': [
                r'.*asbestos.*',
                r'.*acm.*'
            ]
        },
        'Legionella': {
            'keywords': ['legionella', 'water hygiene', 'water treatment',
                        'legionella risk', 'water testing'],
            'filename_patterns': [
                r'.*legionella.*',
                r'.*water.*hygiene.*',
                r'.*water.*risk.*'
            ]
        },
        'Lift_LOLER': {
            'keywords': ['lift', 'loler', 'lift inspection', 'lift examination',
                        'elevator', 'lifting equipment'],
            'filename_patterns': [
                r'.*lift.*',
                r'.*loler.*',
                r'.*elevator.*'
            ]
        },
        'Insurance': {
            'keywords': ['insurance', 'insurance policy', 'premium', 'policy schedule',
                        'insurance certificate', 'cover note', 'buildings insurance'],
            'filename_patterns': [
                r'.*insurance.*',
                r'.*policy.*',
                r'.*premium.*',
                r'.*cover.*note.*'
            ]
        },
        'Gas_Safety': {
            'keywords': ['gas safety', 'gas certificate', 'gas inspection',
                        'landlord gas', 'cp12'],
            'filename_patterns': [
                r'.*gas.*safety.*',
                r'.*gas.*cert.*',
                r'.*cp12.*'
            ]
        },
        'Emergency_Lighting': {
            'keywords': ['emergency lighting', 'emergency light test',
                        'emergency illumination'],
            'filename_patterns': [
                r'.*emergency.*light.*',
                r'.*emergency.*illum.*'
            ]
        },
        'Fire_Alarm': {
            'keywords': ['fire alarm', 'fire detection', 'smoke alarm',
                        'fire alarm test', 'fire alarm maintenance'],
            'filename_patterns': [
                r'.*fire.*alarm.*',
                r'.*smoke.*alarm.*',
                r'.*fire.*detect.*'
            ]
        },
        'Safety_Case': {
            'keywords': ['safety case', 'building safety case', 'bsr',
                        'building safety regulator'],
            'filename_patterns': [
                r'.*safety.*case.*',
                r'.*bsr.*'
            ]
        },
        'PAT_Testing': {
            'keywords': ['pat test', 'portable appliance', 'pat inspection'],
            'filename_patterns': [
                r'.*pat.*test.*',
                r'.*portable.*appliance.*'
            ]
        },
        'AOV_Systems': {
            'keywords': ['aov', 'automatic opening vent', 'smoke vent'],
            'filename_patterns': [
                r'.*aov.*',
                r'.*automatic.*vent.*',
                r'.*smoke.*vent.*'
            ]
        },
        'Dry_Riser': {
            'keywords': ['dry riser', 'dry rising main', 'fire main'],
            'filename_patterns': [
                r'.*dry.*riser.*',
                r'.*dry.*rising.*'
            ]
        },
        'Lightning_Protection': {
            'keywords': ['lightning protection', 'lightning conductor',
                        'earth bonding'],
            'filename_patterns': [
                r'.*lightning.*',
                r'.*conductor.*'
            ]
        },
        'Valuation': {
            'keywords': ['valuation', 'property valuation', 'reinstatement',
                        'rebuild cost', 'rics valuation'],
            'filename_patterns': [
                r'.*valuation.*',
                r'.*reinstatement.*',
                r'.*rebuild.*cost.*'
            ]
        },
        'Lease': {
            'keywords': ['lease', 'lease agreement', 'tenancy agreement',
                        'underlease', 'lease schedule'],
            'filename_patterns': [
                r'.*lease.*',
                r'.*tenancy.*agreement.*',
                r'.*underlease.*'
            ]
        },
        'Budget': {
            'keywords': ['budget', 'service charge', 'year end', 'accounts',
                        'expenditure', 'income', 'forecast', 'ye 20'],
            'filename_patterns': [
                r'.*budget.*',
                r'.*service.*charge.*',
                r'.*year.*end.*',
                r'.*ye\s*\d{2}.*',
                r'.*account.*'
            ]
        },
        'Major_Works': {
            'keywords': ['major works', 'section 20', 's20', 'project',
                        'remedial works', 'schedule of works'],
            'filename_patterns': [
                r'.*major.*works.*',
                r'.*section.*20.*',
                r'.*s20.*',
                r'.*remedial.*'
            ]
        },
        'Minutes': {
            'keywords': ['minutes', 'meeting minutes', 'agm', 'egm',
                        'annual general meeting'],
            'filename_patterns': [
                r'.*minutes.*',
                r'.*agm.*',
                r'.*egm.*',
                r'.*meeting.*'
            ]
        },
        'Contractor': {
            'keywords': ['contract', 'contractor', 'service agreement',
                        'maintenance contract', 'sla'],
            'filename_patterns': [
                r'.*contract.*',
                r'.*contractor.*',
                r'.*agreement.*',
                r'.*sla.*'
            ]
        },
        'H&S_Policy': {
            'keywords': ['health and safety', 'h&s policy', 'safety policy',
                        'health safety policy'],
            'filename_patterns': [
                r'.*health.*safety.*',
                r'.*h&s.*',
                r'.*safety.*policy.*'
            ]
        },
        'Building_Warranty': {
            'keywords': ['warranty', 'building warranty', 'nhbc', 'latent defects',
                        'structural warranty'],
            'filename_patterns': [
                r'.*warranty.*',
                r'.*nhbc.*',
                r'.*latent.*defect.*'
            ]
        }
    }

    def classify(self, file_path: str, text: str) -> Tuple[str, float]:
        """
        Classify document based on filename and content

        Args:
            file_path: Path to the file
            text: Extracted text content (first 1000 chars is sufficient)

        Returns:
            Tuple of (document_type, confidence_score)
        """
        filename = Path(file_path).name.lower()
        text_sample = text[:1000].lower() if text else ""

        best_match = None
        best_score = 0.0

        for doc_type, patterns in self.DOCUMENT_TYPES.items():
            score = 0.0

            # Check filename patterns
            for pattern in patterns.get('filename_patterns', []):
                if re.search(pattern, filename, re.IGNORECASE):
                    score += 3.0

            # Check keywords in filename
            for keyword in patterns.get('keywords', []):
                if keyword.lower() in filename:
                    score += 2.0

            # Check keywords in content (first 1000 chars)
            if text_sample:
                for keyword in patterns.get('keywords', []):
                    # Count occurrences (up to 3)
                    count = min(text_sample.count(keyword.lower()), 3)
                    score += count * 1.0

            # Normalize score
            if score > best_score:
                best_score = score
                best_match = doc_type

        # If no match found, classify as 'Other'
        if best_match is None or best_score < 2.0:
            return 'Other', 0.0

        # Normalize confidence score to 0-1 range
        confidence = min(best_score / 10.0, 1.0)

        return best_match, confidence

    def classify_document(self, file_path: str, text: str) -> Dict:
        """
        Classify document and return full result

        Args:
            file_path: Path to the file
            text: Extracted text content

        Returns:
            Dictionary with classification results
        """
        doc_type, confidence = self.classify(file_path, text)

        return {
            'file_name': Path(file_path).name,
            'file_path': file_path,
            'document_type': doc_type,
            'confidence': round(confidence, 2),
            'raw_text': text[:1000] if text else ""  # First 1000 chars for reference
        }


# Test function
if __name__ == '__main__':
    classifier = DocumentClassifier()

    # Test cases
    test_files = [
        ('FRA_2025_Report.pdf', 'This is a fire risk assessment for the building completed on 4th March 2025'),
        ('EICR_Report_2022.xlsx', 'Electrical Installation Condition Report periodic inspection'),
        ('Asbestos_Survey.pdf', 'Asbestos survey and management plan for the property'),
        ('Insurance_Policy_2025.pdf', 'Buildings insurance policy schedule premium £5000'),
        ('Meeting_Minutes_AGM.docx', 'Annual general meeting minutes from 15th January 2025')
    ]

    for filename, text in test_files:
        result = classifier.classify_document(filename, text)
        print(f"{filename}: {result['document_type']} (confidence: {result['confidence']})")
