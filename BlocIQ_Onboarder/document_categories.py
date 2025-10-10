"""
Document Categories - Presence-First Classification
Determines which documents need OCR and which fields to extract
"""

from typing import Dict, List, Optional
from dataclasses import dataclass


@dataclass
class CategoryConfig:
    """Configuration for a document category"""
    score_relevant: bool
    fields: List[str]
    filename_hints: List[str]
    content_hints: List[str]


# Document category definitions
CATEGORIES = {
    'insurance_certificate': CategoryConfig(
        score_relevant=True,
        fields=['provider', 'policy_number', 'period_start', 'period_end', 'cover_types'],
        filename_hints=[
            'certificate', 'schedule of insurance', 'cert of insurance',
            'evidence of insurance', 'policy schedule', 'certificate of insurance'
        ],
        content_hints=[
            'This is to certify', 'period of insurance', 'policy number',
            'insurer', 'certificate number', 'cover note'
        ]
    ),

    'insurance_policy': CategoryConfig(
        score_relevant=False,  # Don't parse for scoring
        fields=[],
        filename_hints=[
            'policy wording', 'policy document', 'policy booklet',
            'terms and conditions', 'policy conditions', 'policy terms'
        ],
        content_hints=[
            'policy wording', 'definitions', 'exclusions',
            'conditions precedent', 'general conditions'
        ]
    ),

    'compliance_certificate': CategoryConfig(
        score_relevant=True,
        fields=['name', 'last_inspection', 'next_due', 'status'],
        filename_hints=[
            'FRA', 'EICR', 'Emergency Lighting', 'Fire Door', 'AOV',
            'Lightning', 'Legionella', 'LOLER', 'Sprinkler', 'Dry Riser',
            'Wet Riser', 'PAT', 'Fire Alarm', 'Asbestos', 'Lift',
            'Gas Safety', 'CP12', 'Boiler'
        ],
        content_hints=[
            'inspection', 'certificate', 'next due', 'valid until',
            'assessment', 'inspection date', 'expiry', 'certification'
        ]
    ),

    'lease': CategoryConfig(
        score_relevant=True,
        fields=['unit_ref', 'lessee_names', 'term_years', 'start_date', 'end_date', 'ground_rent_text'],
        filename_hints=['lease', 'long lease', 'underlease', 'official copy'],
        content_hints=['THIS LEASE', 'Between', 'Term:', 'peppercorn', 'demise', 'lessee']
    ),

    'budget_pdf': CategoryConfig(
        score_relevant=True,
        fields=['service_charge_year', 'total_amount'],
        filename_hints=['budget', 'estimate', 'service charge budget', 'sc budget'],
        content_hints=['Service Charge', 'Budget', 'Schedule', 'Summary', 'Estimate']
    ),

    'accounts_pdf': CategoryConfig(
        score_relevant=True,
        fields=['service_charge_year'],
        filename_hints=['accounts', 'year end', 'service charge accounts', 'YE'],
        content_hints=[
            'Statement of Income', 'Year End', 'Service Charge Accounts',
            'Income and Expenditure', 'Annual Accounts'
        ]
    ),

    'contract': CategoryConfig(
        score_relevant=False,  # Store metadata only
        fields=['contractor_name', 'service_type'],
        filename_hints=[
            'contract', 'agreement', 'service level', 'SLA',
            'management agreement', 'maintenance contract'
        ],
        content_hints=['Agreement', 'Contractor', 'Scope of Services', 'Contract', 'Terms']
    ),

    'correspondence': CategoryConfig(
        score_relevant=False,
        fields=[],
        filename_hints=['letter', 'email', 'memo', 'notice', 'notification'],
        content_hints=['Dear', 'Re:', 'Subject:', 'Yours sincerely']
    ),

    'other': CategoryConfig(
        score_relevant=False,
        fields=[],
        filename_hints=[],
        content_hints=[]
    )
}


# UK Insurance providers for detection
UK_INSURERS = [
    'Allianz', 'Aviva', 'Zurich', 'Arch', 'RSA', 'Hiscox',
    'QBE', 'Camberford', 'AIG', 'Ecclesiastical', 'NFU',
    'AXA', 'Direct Line', 'LV=', 'Ageas'
]


def classify_document(filename: str, text_sample: str = "") -> str:
    """
    Classify document based on filename and text sample

    Args:
        filename: Document filename
        text_sample: First 1-2 pages of text (optional)

    Returns:
        Category name (e.g., 'insurance_certificate', 'lease', etc.)
    """
    filename_lower = filename.lower()
    text_lower = text_sample.lower()

    # Score each category
    scores = {}

    for category, config in CATEGORIES.items():
        score = 0

        # Check filename hints
        for hint in config.filename_hints:
            if hint.lower() in filename_lower:
                score += 2

        # Check content hints (if text available)
        if text_sample:
            for hint in config.content_hints:
                if hint.lower() in text_lower:
                    score += 1

        scores[category] = score

    # Special case: If both certificate and policy match, prefer certificate
    if scores.get('insurance_certificate', 0) > 0 and scores.get('insurance_policy', 0) > 0:
        if 'period of insurance' in text_lower or 'certificate number' in text_lower:
            scores['insurance_policy'] = 0
        else:
            scores['insurance_certificate'] = 0

    # Return category with highest score
    best_category = max(scores.items(), key=lambda x: x[1])

    if best_category[1] > 0:
        return best_category[0]

    return 'other'


def needs_ocr(pdf_text: str, category: str) -> bool:
    """
    Determine if a PDF needs OCR

    Args:
        pdf_text: Extracted text from PDF
        category: Document category

    Returns:
        True if OCR is needed
    """
    # If category is not score-relevant, skip OCR
    if not CATEGORIES[category].score_relevant:
        return False

    # If text is very short (likely scanned image), needs OCR
    # Land Registry cover pages are ~1500-2000 chars
    # Actual lease documents should have much more text if not scanned
    if len(pdf_text) < 3000:
        return True

    # If text seems substantive, don't need OCR
    return False


def get_ocr_priority(category: str) -> int:
    """
    Get OCR priority for a category (lower = higher priority)

    Returns:
        Priority level (1=highest, 5=lowest)
    """
    priorities = {
        'lease': 1,                      # Highest priority (15% weight, 0% current)
        'insurance_certificate': 2,      # High priority (20% weight, 0% current)
        'compliance_certificate': 2,     # High priority (40% weight, 5.4% current)
        'budget_pdf': 3,                 # Medium priority (15% weight, 10% current)
        'accounts_pdf': 3,               # Medium priority
        'contract': 4,                   # Low priority (10% weight, 100% current)
        'insurance_policy': 5,           # Don't OCR (not score-relevant)
        'correspondence': 5,             # Don't OCR
        'other': 5                       # Don't OCR
    }
    return priorities.get(category, 5)


def get_extraction_summary() -> Dict[str, Dict]:
    """
    Get summary of what to extract from each category

    Returns:
        Dictionary mapping category to extraction config
    """
    return {
        category: {
            'score_relevant': config.score_relevant,
            'fields': config.fields,
            'ocr_priority': get_ocr_priority(category)
        }
        for category, config in CATEGORIES.items()
    }
