"""
SQL Generator - Major Works & Reserve Fund Extractor
Extracts capital project history and reserve fund policies
Captures static project data (not live accounting balances)
"""

import re
from datetime import datetime
from dateutil import parser as date_parser
from typing import Dict, List, Optional, Set, Tuple
from collections import defaultdict


class MajorWorksExtractor:
    """Extract major works projects and reserve fund policies"""

    # Project type keywords
    PROJECT_TYPES = {
        'Fabric – Roof': ['roof', 'gutter', 'drain', 'rainwater', 'parapet'],
        'Fabric – External': ['paint', 'redecoration', 'decoration', 'render', 'facade', 'external'],
        'M&E – Lifts': ['lift', 'elevator', 'passenger lift', 'lift modernisation'],
        'Fire Safety': ['fire alarm', 'compartmentation', 'fraew', 'fire door', 'fire safety', 'fire stopping'],
        'Façade': ['cladding', 'balcony', 'balconies', 'facade', 'external wall'],
        'M&E – Mechanical': ['boiler', 'plant', 'tank', 'heating', 'mechanical', 'hvac'],
        'M&E – Electrical': ['electrical', 'rewire', 'consumer unit', 'distribution'],
        'Safety/Remediation': ['asbestos', 'insulation', 'remediation', 'safety works'],
        'Windows/Doors': ['window', 'door', 'door entry', 'glazing'],
        'Communal Areas': ['communal', 'common parts', 'hallway', 'stairwell'],
        'Grounds/Landscaping': ['garden', 'landscaping', 'grounds', 'fencing'],
        'Other': []
    }

    # Project status keywords
    STATUS_KEYWORDS = {
        'Planned': ['planned', 'proposed', 'future', 'anticipated', 'scheduled'],
        'In Progress': ['in progress', 'ongoing', 'underway', 'commenced', 'started'],
        'Completed': ['completed', 'finished', 'concluded', 'delivered', 'handed over'],
        'On Hold': ['on hold', 'paused', 'deferred', 'postponed'],
        'Cancelled': ['cancelled', 'abandoned', 'withdrawn']
    }

    # Section 20 stage mapping
    SECTION20_STAGES = {
        'Stage 1 – Notice of Intention': [
            'notice of intention', 'stage 1', 'preliminary notice', 'initial notice'
        ],
        'Stage 2 – Statement of Estimates': [
            'statement of estimates', 'stage 2', 'tender stage', 'estimates'
        ],
        'Stage 3 – Award of Contract': [
            'award of contract', 'stage 3', 'contract award', 'appointment'
        ],
        'Stage 4 – Final Account': [
            'final account', 'stage 4', 'completion', 'final costs'
        ]
    }

    # Funding source keywords
    FUNDING_SOURCES = {
        'Reserve Fund': ['reserve fund', 'sinking fund', 'reserve', 'reserves'],
        'Special Levy': ['special levy', 'one-off charge', 'special charge'],
        'Loan': ['loan', 'borrowing', 'finance'],
        'Service Charge': ['service charge', 'annual charge'],
        'Grant': ['grant', 'funding', 'subsidy']
    }

    def __init__(self):
        """Initialize extractor"""
        pass

    def extract_from_documents(self, documents: List[Dict]) -> Dict:
        """
        Extract major works projects and reserve policies from documents

        Args:
            documents: List of document dicts with 'text', 'document_type', 'file_name'

        Returns:
            Dictionary with major_works_projects and reserve_policies
        """
        projects = []
        reserve_policies = []

        confidence_signals = {
            'major_works_detected': False,
            'contractor_or_value': False,
            'dates_found': False,
            'funding_source': False
        }

        # Process each document
        for doc in documents:
            text = doc.get('text', '')
            doc_type = doc.get('document_type', '')
            file_name = doc.get('file_name', '')

            if not text:
                continue

            # Check if document is relevant
            if not self._is_relevant_document(text, doc_type, file_name):
                continue

            # Extract projects from this document
            doc_projects = self._extract_projects(text, file_name)

            if doc_projects:
                projects.extend(doc_projects)
                confidence_signals['major_works_detected'] = True

                # Check for contractor or value
                for project in doc_projects:
                    if project.get('contractor_name') or project.get('contract_value'):
                        confidence_signals['contractor_or_value'] = True
                    if project.get('project_start_date') or project.get('project_end_date'):
                        confidence_signals['dates_found'] = True
                    if project.get('funding_source'):
                        confidence_signals['funding_source'] = True

            # Extract reserve policies
            policies = self._extract_reserve_policies(text, file_name)
            if policies:
                reserve_policies.extend(policies)
                confidence_signals['funding_source'] = True

        # Deduplicate projects
        projects = self._deduplicate_projects(projects)

        # Deduplicate reserve policies
        reserve_policies = self._deduplicate_policies(reserve_policies)

        # Calculate confidence
        confidence = self._calculate_confidence(confidence_signals)

        return {
            'major_works_projects': projects,
            'reserve_policies': reserve_policies,
            'confidence': confidence
        }

    def _is_relevant_document(self, text: str, doc_type: str, file_name: str) -> bool:
        """Check if document is relevant for major works extraction"""
        text_lower = text.lower()
        file_lower = file_name.lower()

        # Document type indicators
        if doc_type in ['Major_Works', 'Budget']:
            return True

        # Filename indicators
        if any(keyword in file_lower for keyword in [
            'major works', 'section 20', 'capital', 'reserve',
            'roof', 'lift', 'refurbishment', 'redecoration'
        ]):
            return True

        # Content indicators
        if any(keyword in text_lower for keyword in [
            'major works', 'section 20', 'capital project',
            'refurbishment', 'roof replacement', 'lift modernisation'
        ]):
            return True

        return False

    def _extract_projects(self, text: str, file_name: str) -> List[Dict]:
        """Extract major works projects from text"""
        projects = []

        # Try to find explicit project sections
        project_sections = self._split_into_projects(text)

        if not project_sections:
            # Treat entire document as one project
            project_sections = [(text, file_name)]

        for section_text, reference in project_sections:
            project = self._extract_single_project(section_text, reference)

            if project:
                projects.append(project)

        return projects

    def _split_into_projects(self, text: str) -> List[Tuple[str, str]]:
        """Split text into individual project sections"""
        sections = []

        # Look for project headers/titles
        pattern = r'(?i)(?:^|\n)((?:project|works|scheme|contract)[:\-]?\s*([^\n]{10,100}))'
        matches = list(re.finditer(pattern, text))

        if not matches:
            return []

        for i, match in enumerate(matches):
            start_pos = match.start()
            end_pos = matches[i + 1].start() if i + 1 < len(matches) else len(text)

            section_text = text[start_pos:end_pos]
            project_title = match.group(2).strip()

            sections.append((section_text, project_title))

        return sections

    def _extract_single_project(self, text: str, reference: str) -> Optional[Dict]:
        """Extract a single project's details"""
        project = {
            'project_reference_file': reference
        }

        # Extract project name
        project_name = self._extract_project_name(text, reference)
        if not project_name:
            return None  # Must have a project name

        project['project_name'] = project_name

        # Extract project type
        project['project_type'] = self._extract_project_type(text)

        # Extract project status
        project['project_status'] = self._extract_project_status(text)

        # Extract dates
        dates = self._extract_project_dates(text)
        if dates.get('start_date'):
            project['project_start_date'] = dates['start_date']
        if dates.get('end_date'):
            project['project_end_date'] = dates['end_date']

        # Extract contract value
        value = self._extract_contract_value(text)
        if value:
            project['contract_value'] = value

        # Extract contractor name
        contractor = self._extract_contractor_name(text)
        if contractor:
            project['contractor_name'] = contractor

        # Extract contract admin
        admin = self._extract_contract_admin(text)
        if admin:
            project['contract_admin'] = admin

        # Extract Section 20 stage
        s20_stage = self._extract_section20_stage(text)
        if s20_stage:
            project['section20_stage'] = s20_stage
            project['section20_reference'] = self._extract_section20_reference(text)

        # Extract funding source
        funding = self._extract_funding_source(text)
        if funding:
            project['funding_source'] = funding

        # Extract notes summary
        notes = self._extract_notes_summary(text)
        if notes:
            project['notes_summary'] = notes

        # Extract reserve policy reference
        reserve_ref = self._extract_reserve_policy_reference(text)
        if reserve_ref:
            project['reserve_policy_reference'] = reserve_ref

        return project

    def _extract_project_name(self, text: str, reference: str) -> Optional[str]:
        """Extract project name/title"""
        # Try explicit patterns first
        patterns = [
            r'(?i)(?:project|works|scheme|contract)\s*(?:title|name)?[:\-]?\s*([A-Z][^\n]{10,150})',
            r'(?i)(?:^|\n)([A-Z][A-Za-z\s&\-–—]+(?:Works|Project|Scheme|Refurbishment|Replacement|Renewal|Modernisation))',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                name = match.group(1).strip()
                # Clean up
                name = re.sub(r'\s+', ' ', name)
                name = name.strip(':;,.-–—')

                if 10 < len(name) < 150:
                    return name

        # Try to extract from filename
        if reference:
            # Clean filename
            name = reference.replace('_', ' ').replace('-', ' ')
            name = re.sub(r'\.(pdf|docx?|xlsx?)$', '', name, flags=re.IGNORECASE)

            # Remove common prefixes
            name = re.sub(r'^(major works|section 20|s20|project)\s*', '', name, flags=re.IGNORECASE)

            if 10 < len(name) < 150:
                return name.strip()

        return None

    def _extract_project_type(self, text: str) -> str:
        """Determine project type from keywords"""
        text_lower = text.lower()

        # Score each type
        scores = defaultdict(int)

        for proj_type, keywords in self.PROJECT_TYPES.items():
            for keyword in keywords:
                count = text_lower.count(keyword)
                scores[proj_type] += count

        # Return highest scoring type
        if scores:
            return max(scores.items(), key=lambda x: x[1])[0]

        return 'Other'

    def _extract_project_status(self, text: str) -> str:
        """Extract project status"""
        text_lower = text.lower()

        for status, keywords in self.STATUS_KEYWORDS.items():
            for keyword in keywords:
                if keyword in text_lower:
                    return status

        return 'Unknown'

    def _extract_project_dates(self, text: str) -> Dict[str, Optional[str]]:
        """Extract start and end dates"""
        dates = {'start_date': None, 'end_date': None}

        # Patterns for date extraction with context
        start_patterns = [
            r'(?i)(start|commencement|commence|begin)\s*(?:date|on)?[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'(?i)(tender|award)\s*(?:date)?[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})'
        ]

        end_patterns = [
            r'(?i)(completion|finish|end|due)\s*(?:date|on)?[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'(?i)(practical completion|handover)\s*[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})'
        ]

        # Extract start date
        for pattern in start_patterns:
            match = re.search(pattern, text)
            if match:
                try:
                    date_str = match.group(2)
                    dt = date_parser.parse(date_str, dayfirst=True)
                    dates['start_date'] = dt.strftime('%Y-%m-%d')
                    break
                except:
                    continue

        # Extract end date
        for pattern in end_patterns:
            match = re.search(pattern, text)
            if match:
                try:
                    date_str = match.group(2)
                    dt = date_parser.parse(date_str, dayfirst=True)
                    dates['end_date'] = dt.strftime('%Y-%m-%d')
                    break
                except:
                    continue

        return dates

    def _extract_contract_value(self, text: str) -> Optional[float]:
        """Extract contract value"""
        # Look for amounts with context
        patterns = [
            r'(?i)(?:estimated|contract|project|tender|total)\s*(?:value|cost|sum|amount)[:\-]?\s*£?\s?([\d,]+(?:\.\d{2})?)',
            r'£\s?([\d,]+(?:\.\d{2})?)'
        ]

        amounts = []

        for pattern in patterns:
            matches = re.finditer(pattern, text)
            for match in matches:
                amount_str = match.group(1).replace(',', '')
                try:
                    amount = float(amount_str)
                    # Reasonable range check
                    if 1000 < amount < 10000000:
                        amounts.append(amount)
                except:
                    continue

        if not amounts:
            return None

        # If multiple amounts, prefer one near "contract" or "tender"
        # For now, return largest
        return max(amounts)

    def _extract_contractor_name(self, text: str) -> Optional[str]:
        """Extract contractor or consultant name"""
        patterns = [
            r'(?i)(?:contractor|builder|consultant|surveyor|tenderer)[:\-]?\s*([A-Z][A-Za-z\s&\.\']+?(?:Ltd|Limited|LLP|PLC))',
            r'(?i)(?:undertaken|managed|carried out)\s*by[:\-]?\s*([A-Z][A-Za-z\s&\.\']+?(?:Ltd|Limited|LLP))',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                name = match.group(1).strip()
                # Clean up
                name = re.sub(r'\s+', ' ', name)
                name = name.strip(',;:')

                # Remove anything after newline
                name = name.split('\n')[0].strip()

                if 3 < len(name) < 100:
                    return name

        return None

    def _extract_contract_admin(self, text: str) -> Optional[str]:
        """Extract contract administrator"""
        patterns = [
            r'(?i)(?:contract administrator|project manager|quantity surveyor)[:\-]?\s*([A-Z][A-Za-z\s&\.\']+?(?:Ltd|Limited|LLP))',
            r'(?i)(?:administered|managed)\s*by[:\-]?\s*([A-Z][A-Za-z\s&\.\']+?(?:Ltd|Limited|LLP))',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                name = match.group(1).strip()
                name = re.sub(r'\s+', ' ', name)
                name = name.strip(',;:')

                # Remove anything after newline
                name = name.split('\n')[0].strip()

                if 3 < len(name) < 100:
                    return name

        return None

    def _extract_section20_stage(self, text: str) -> Optional[str]:
        """Extract Section 20 consultation stage"""
        text_lower = text.lower()

        for stage, keywords in self.SECTION20_STAGES.items():
            for keyword in keywords:
                if keyword in text_lower:
                    return stage

        return None

    def _extract_section20_reference(self, text: str) -> Optional[str]:
        """Extract Section 20 notice reference"""
        pattern = r'(?i)(section\s*20\s*(?:notice|consultation|reference))[:\-]?\s*([^\n]{10,100})'
        match = re.search(pattern, text)

        if match:
            reference = match.group(0).strip()
            return reference[:150]

        return None

    def _extract_funding_source(self, text: str) -> Optional[str]:
        """Extract funding source"""
        text_lower = text.lower()

        for source, keywords in self.FUNDING_SOURCES.items():
            for keyword in keywords:
                # Look for context around keyword
                pattern = f'(?i)(?:funded|charged|paid).*?{re.escape(keyword)}'
                if re.search(pattern, text_lower):
                    return source

        return None

    def _extract_notes_summary(self, text: str) -> Optional[str]:
        """Extract summary or scope notes"""
        patterns = [
            r'(?i)(?:scope\s*of\s*works|summary|overview|description)[:\-]?\s*([^\n]{50,500})',
            r'(?i)(?:the\s*works\s*comprise|the\s*project\s*involves)[:\-]?\s*([^\n]{50,500})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                notes = match.group(1).strip()
                # Clean up
                notes = re.sub(r'\s+', ' ', notes)

                # End at sentence boundary
                sentence_end = re.search(r'[.!?]', notes[50:])
                if sentence_end:
                    notes = notes[:50 + sentence_end.end()]

                if len(notes) > 50:
                    return notes[:500]

        return None

    def _extract_reserve_policy_reference(self, text: str) -> Optional[str]:
        """Extract reference to reserve policy"""
        pattern = r'(?i)(?:reserve\s*(?:fund|policy)|annual\s*contribution)[:\-]?\s*([^\n]{20,200})'
        match = re.search(pattern, text)

        if match:
            reference = match.group(0).strip()
            return reference[:250]

        return None

    def _extract_reserve_policies(self, text: str, file_name: str) -> List[Dict]:
        """Extract reserve fund policies"""
        policies = []

        patterns = [
            r'(?i)(reserve\s*(?:fund|policy)[:\-]?\s*[^\n]{30,300})',
            r'(?i)(sinking\s*fund[:\-]?\s*[^\n]{30,300})',
            r'(?i)(annual\s*contribution[:\-]?\s*[^\n]{30,300})',
        ]

        for pattern in patterns:
            matches = re.finditer(pattern, text)
            for match in matches:
                policy_text = match.group(1).strip()

                # Ensure it's a policy statement, not just a balance
                if any(keyword in policy_text.lower() for keyword in [
                    'contribution', 'policy', 'annual', 'allocated', 'budgeted'
                ]):
                    policy = {
                        'policy_reference': policy_text[:300],
                        'source_file': file_name
                    }

                    # Try to extract review date
                    date_match = re.search(r'(\d{1,2}\s+\w+\s+\d{4})', policy_text)
                    if date_match:
                        try:
                            dt = date_parser.parse(date_match.group(1), dayfirst=True)
                            policy['last_reviewed'] = dt.strftime('%Y-%m-%d')
                        except:
                            pass

                    policies.append(policy)

        return policies

    def _deduplicate_projects(self, projects: List[Dict]) -> List[Dict]:
        """Deduplicate projects by name and similarity"""
        if not projects:
            return []

        # Simple deduplication by exact name match
        seen = set()
        unique = []

        for project in projects:
            name = project.get('project_name', '')
            if name and name not in seen:
                seen.add(name)
                unique.append(project)

        return unique

    def _deduplicate_policies(self, policies: List[Dict]) -> List[Dict]:
        """Deduplicate reserve policies"""
        if not policies:
            return []

        # Deduplicate by policy text
        seen = set()
        unique = []

        for policy in policies:
            ref = policy.get('policy_reference', '')
            # Normalize for comparison
            ref_norm = re.sub(r'\s+', ' ', ref.lower())

            if ref_norm and ref_norm not in seen:
                seen.add(ref_norm)
                unique.append(policy)

        return unique

    def _calculate_confidence(self, signals: Dict[str, bool]) -> float:
        """Calculate confidence score"""
        score = 0.0

        if signals['major_works_detected']:
            score += 0.4
        if signals['contractor_or_value']:
            score += 0.2
        if signals['dates_found']:
            score += 0.2
        if signals['funding_source']:
            score += 0.2

        return round(score, 2)


# Test function
if __name__ == '__main__':
    extractor = MajorWorksExtractor()

    # Test data
    test_text = """
    SECTION 20 CONSULTATION
    ROOF REPLACEMENT AND RAINWATER GOODS RENEWAL

    Notice of Intention – Stage 1

    Project: Roof Replacement and Rainwater Goods Renewal – Blocks A to D

    Scope of Works:
    Full replacement of roof coverings and associated drainage to Blocks A–D,
    including new gutters, downpipes, and parapet wall repairs.

    Estimated Contract Value: £187,400.00

    Contractor: Ardent Lift Consultancy Ltd
    Contract Administrator: MIH Property Management Ltd

    Project Start Date: 15 May 2024
    Project Completion Date: 30 September 2024

    Funding Source: To be funded from the Reserve Fund

    Reserve Policy: Annual contribution of £25,000 towards roof reserve fund

    Status: Completed
    """

    test_doc = {
        'text': test_text,
        'document_type': 'Major_Works',
        'file_name': 'Section_20_Roof_Works_2024.pdf'
    }

    result = extractor.extract_from_documents([test_doc])

    print("Major Works Extraction Results:")
    print("=" * 60)
    print("\nProjects:")
    for project in result['major_works_projects']:
        print(f"\nProject: {project.get('project_name')}")
        for key, value in project.items():
            if key != 'project_name':
                print(f"  {key}: {value}")

    print("\nReserve Policies:")
    for policy in result['reserve_policies']:
        print(f"\n{policy}")

    print(f"\nConfidence: {result['confidence']}")
