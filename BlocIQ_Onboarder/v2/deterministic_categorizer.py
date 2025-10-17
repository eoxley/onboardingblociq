"""
BlocIQ Deterministic File Categorizer
======================================
Rule-based categorization with confidence scores
AI optional (only when confidence < 0.60)

Uses exact taxonomy mapping with regex patterns
"""

import re
from typing import Dict, List, Tuple, Optional


class FilingTaxonomy:
    """Authoritative filing taxonomy - exact mapping"""
    
    CATEGORIES = {
        'Client Information': {
            'subcategories': [
                'Management Agreements',
                'Company Secretarial',
                'Board/AGM/EGM Minutes',
                'Leases (Master)',
                'Deeds',
                'Meeting Packs'
            ]
        },
        'Finance': {
            'subcategories': [
                'Budgets',
                'Year-End Accounts',
                'Bank Statements',
                'Expenditure/Invoice Lists'
            ]
        },
        'General Correspondence': {
            'subcategories': [
                'Leaseholder Correspondence',
                'Client/Director Correspondence'
            ]
        },
        'Health & Safety': {
            'subcategories': [
                'Fire/FRA',
                'Fire/Fire Door Inspections',
                'Fire/Alarm Detection',
                'Fire/Extinguishers',
                'Electrical/EICR',
                'Electrical/Emergency Lighting',
                'Water/Legionella',
                'Asbestos',
                'Lifts',
                'Plant/Heating',
                'Other Assessments'
            ]
        },
        'Insurance': {
            'subcategories': [
                'Buildings & Terrorism',
                'D&O',
                'Engineering (LOLER)'
            ]
        },
        'Major Works': {
            'subcategories': [
                'S20 Notices',
                'Tenders',
                'Contracts',
                'Progress Reports',
                'Certificates'
            ]
        },
        'Contracts': {
            'subcategories': [
                'Cleaning',
                'Gardening',
                'M&E',
                'Lifts',
                'Security',
                'Concierge/Staff'
            ]
        },
        'Building Drawings & Plans': {
            'subcategories': [
                'GA Drawings',
                'Fire Strategy',
                'O&Ms'
            ]
        },
        'Leaseholders': {
            'subcategories': [
                'Apportionments',
                'NOATTs/Transfers',
                'Correspondence'
            ]
        }
    }


class DeterministicCategorizer:
    """
    Deterministic file categorization using rules
    Transparent, debuggable, no AI required
    """
    
    def __init__(self):
        self.taxonomy = FilingTaxonomy()
        self._compile_patterns()
    
    def _compile_patterns(self):
        """Compile regex patterns for each category"""
        
        # Year-End Accounts
        self.patterns = {
            'Finance/Year-End Accounts': {
                'filename': [
                    r'\baccounts?\b',
                    r'\bye\s*\d{2}',
                    r'\byear.?end\b',
                    r'\bstatements? of accounts?\b',
                    r'\bservice charge accounts?\b'
                ],
                'content': [
                    r'\bstatements? of accounts?\b',
                    r'\byear ended\s+\d{1,2}\s+\w+\s+\d{4}',
                    r'\bapproved by the board\b',
                    r'\baccountant.?s report\b',
                    r'\bfinal accounts?\b'
                ],
                'weight': 1.0
            },
            
            # Budgets
            'Finance/Budgets': {
                'filename': [
                    r'\bbudget\b',
                    r'\bestimate\b',
                    r'\bservice charge\s+budget\b'
                ],
                'content': [
                    r'\bbudget\b',
                    r'\bbudgeted\s+expenditure\b',
                    r'\bservice charge\s+estimate\b',
                    r'\bproposed\s+budget\b'
                ],
                'weight': 0.9
            },
            
            # Fire Risk Assessment
            'Health & Safety/Fire/FRA': {
                'filename': [
                    r'\bfra\b',
                    r'\bfire\s*risk\s*assessment\b'
                ],
                'content': [
                    r'\bfire\s+risk\s+assessment\b',
                    r'\brisk\s+rating\b',
                    r'\bfire\s+safety\s+order\b',
                    r'\brrfso\b'
                ],
                'weight': 1.0
            },
            
            # EICR
            'Health & Safety/Electrical/EICR': {
                'filename': [
                    r'\beicr\b',
                    r'\belectrical\s*installation\b',
                    r'\bcondition\s*report\b'
                ],
                'content': [
                    r'\belectrical\s+installation\s+condition\s+report\b',
                    r'\bbs\s*7671\b',
                    r'\b18th\s+edition\b',
                    r'\binspection\s+and\s+testing\b'
                ],
                'weight': 1.0
            },
            
            # Legionella
            'Health & Safety/Water/Legionella': {
                'filename': [
                    r'\blegionella\b',
                    r'\bwater\s*risk\b',
                    r'\bl8\b'
                ],
                'content': [
                    r'\blegionella\b',
                    r'\bwater\s+hygiene\b',
                    r'\blegionella\s+risk\s+assessment\b',
                    r'\bacop\s*l8\b'
                ],
                'weight': 1.0
            },
            
            # Section 20
            'Major Works/S20 Notices': {
                'filename': [
                    r'\bs20\b',
                    r'\bsection\s*20\b',
                    r'\bnotice\s+of\s+intention\b',
                    r'\bnotice\s+of\s+estimates\b'
                ],
                'content': [
                    r'\bsection\s+20\b',
                    r'\bleaseholder\s+consultation\b',
                    r'\bnotice\s+of\s+intention\b',
                    r'\bnotice\s+of\s+estimates\b'
                ],
                'weight': 1.0
            },
            
            # Insurance
            'Insurance/Buildings & Terrorism': {
                'filename': [
                    r'\binsurance\b',
                    r'\bpolicy\s*schedule\b',
                    r'\bcertificate\b',
                    r'\ballianz\b',
                    r'\baviva\b',
                    r'\bzurich\b'
                ],
                'content': [
                    r'\bpolicy\s+schedule\b',
                    r'\bsum\s+insured\b',
                    r'\bpremium\b',
                    r'\bbuildings?\s+insurance\b',
                    r'\bterrorism\b'
                ],
                'weight': 0.8
            },
            
            # Contracts
            'Contracts/General': {
                'filename': [
                    r'\bcontract\b',
                    r'\bagreement\b',
                    r'\bsla\b',
                    r'\bscope\s+of\s+works\b'
                ],
                'content': [
                    r'\bthis\s+agreement\b',
                    r'\bterm\s+of\s+contract\b',
                    r'\bcommencement\s+date\b',
                    r'\bexpiry\s+date\b',
                    r'\bcontractor\b',
                    r'\bscope\s+of\s+works\b'
                ],
                'weight': 0.7
            },
            
            # Leases
            'Client Information/Leases (Master)': {
                'filename': [
                    r'\blease\b',
                    r'\btitle\s+number\b',
                    r'\bofficial\s+copy\b'
                ],
                'content': [
                    r'\bthis\s+lease\b',
                    r'\bdemised\s+premises\b',
                    r'\btitle\s+plan\b',
                    r'\bschedule\s+of\s+apportionment\b',
                    r'\bground\s+rent\b',
                    r'\bservice\s+charge\b'
                ],
                'weight': 0.9
            },
            
            # Apportionments
            'Leaseholders/Apportionments': {
                'filename': [
                    r'\bapportionment\b',
                    r'\bservice\s+charge\s+%\b'
                ],
                'content': [
                    r'\bapportionment\b',
                    r'\bpercentage\s+share\b',
                    r'\bservice\s+charge\s+percentage\b'
                ],
                'weight': 1.0
            },
        }
    
    def categorize(self, document: Dict[str, Any]) -> Tuple[str, str, float]:
        """
        Categorize document using deterministic rules
        
        Args:
            document: Document dict with filename, content, etc.
        
        Returns:
            (primary_category, subcategory, confidence_score)
        """
        filename = document.get('filename', '').lower()
        content = (document.get('extracted_text') or '').lower()
        primary_folder = document.get('primary_folder', '')
        
        # Score all patterns
        scores = {}
        
        for category, pattern_set in self.patterns.items():
            score = 0.0
            matches = []
            
            # Filename patterns
            filename_patterns = pattern_set.get('filename', [])
            for pattern in filename_patterns:
                if re.search(pattern, filename, re.IGNORECASE):
                    score += 0.3
                    matches.append(f"filename:{pattern}")
            
            # Content patterns (if text available)
            if content:
                content_patterns = pattern_set.get('content', [])
                for pattern in content_patterns:
                    if re.search(pattern, content, re.IGNORECASE):
                        score += 0.15
                        matches.append(f"content:{pattern}")
            
            # Location bonus (if file is in matching folder)
            if primary_folder and any(part in category for part in primary_folder.split()):
                score += 0.2
                matches.append(f"location:{primary_folder}")
            
            # Apply weight
            score *= pattern_set.get('weight', 1.0)
            
            if score > 0:
                scores[category] = {
                    'score': min(score, 1.0),  # Cap at 1.0
                    'matches': matches
                }
        
        # Get best match
        if scores:
            best_category = max(scores.items(), key=lambda x: x[1]['score'])
            category = best_category[0]
            confidence = best_category[1]['score']
            
            # Split into primary/subcategory
            if '/' in category:
                parts = category.split('/')
                primary = parts[0]
                subcategory = '/'.join(parts[1:])
            else:
                primary = category
                subcategory = 'General'
            
            return primary, subcategory, confidence
        
        # Fallback to folder structure
        return primary_folder or 'Uncategorized', 'General', 0.3
    
    def categorize_all(self, documents: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Categorize all documents"""
        print("\n🏷️  Phase 3: Categorizing documents...")
        
        categorized = []
        low_confidence = []
        
        for doc in documents:
            # Skip duplicates
            if doc.get('is_duplicate_of'):
                doc['category'] = 'DUPLICATE'
                doc['subcategory'] = 'N/A'
                doc['confidence'] = 1.0
                categorized.append(doc)
                continue
            
            primary, subcategory, confidence = self.categorize(doc)
            
            doc['category'] = primary
            doc['subcategory'] = subcategory
            doc['confidence'] = confidence
            
            if confidence < 0.60:
                low_confidence.append(doc)
            
            categorized.append(doc)
        
        print(f"   ✅ Categorized {len(categorized)} documents")
        print(f"   ⚠️  Low confidence (< 0.60): {len(low_confidence)} files")
        
        if low_confidence:
            print(f"\n   Low confidence files (may need AI or manual review):")
            for doc in low_confidence[:10]:
                print(f"      • {doc['filename'][:50]:50s} confidence: {doc['confidence']:.2f}")
        
        return categorized

