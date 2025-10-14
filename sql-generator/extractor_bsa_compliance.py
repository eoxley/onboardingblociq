"""
SQL Generator - BSA & Compliance Intelligence Extractor
Extracts Building Safety Act registration, safety case, and all statutory compliance data
Creates comprehensive Building Safety File automatically
"""

import re
from datetime import datetime, timedelta
from dateutil import parser as date_parser
from dateutil.relativedelta import relativedelta
from typing import Dict, List, Optional, Set, Tuple
from collections import defaultdict


class BSAComplianceExtractor:
    """Extract Building Safety Act and statutory compliance information"""

    # Compliance document types with renewal periods (months)
    COMPLIANCE_TYPES = {
        'FRA': {
            'keywords': ['fire risk assessment', 'fra', 'fire risk appraisal'],
            'renewal_months': 12
        },
        'FRAEW': {
            'keywords': ['fraew', 'fire risk appraisal external walls', 'external wall fire'],
            'renewal_months': 12
        },
        'EWS1': {
            'keywords': ['ews1', 'external wall system'],
            'renewal_months': None  # One-off
        },
        'EICR': {
            'keywords': ['eicr', 'electrical installation condition', 'electrical inspection'],
            'renewal_months': 60
        },
        'Asbestos': {
            'keywords': ['asbestos survey', 'asbestos register', 'asbestos management'],
            'renewal_months': 12
        },
        'Legionella': {
            'keywords': ['legionella', 'water hygiene', 'water risk'],
            'renewal_months': 24
        },
        'LOLER': {
            'keywords': ['loler', 'lift examination', 'thorough examination lift'],
            'renewal_months': 6
        },
        'Gas_Safety': {
            'keywords': ['gas safety', 'landlord gas', 'cp12'],
            'renewal_months': 12
        },
        'Fire_Doors': {
            'keywords': ['fire door', 'fire door inspection', 'fire door survey'],
            'renewal_months': 12
        },
        'Water_Hygiene': {
            'keywords': ['water hygiene', 'water tank', 'water system'],
            'renewal_months': 12
        }
    }

    # Risk rating keywords
    RISK_RATINGS = ['low', 'medium', 'high', 'intolerable', 'tolerable', 'trivial']

    # Evacuation strategies
    EVACUATION_STRATEGIES = [
        'stay put', 'simultaneous evacuation', 'phased evacuation',
        'progressive horizontal evacuation'
    ]

    def __init__(self):
        """Initialize extractor"""
        pass

    def extract_from_documents(self, documents: List[Dict]) -> Dict:
        """
        Extract BSA and compliance data from all documents

        Args:
            documents: List of document dicts with 'text', 'document_type', 'file_name'

        Returns:
            Dictionary with complete Building Safety File data
        """
        # Initialize results
        result = {
            # BSA Registration
            'bsa_registration_number': None,
            'bsa_registration_status': None,
            'registration_date': None,
            'accountable_person': None,
            'principal_accountable_person': None,
            'safety_case_required': None,

            # Safety Case
            'safety_case_report_date': None,
            'safety_case_prepared_by': None,
            'safety_case_findings': None,
            'golden_thread_references': [],

            # Fire Safety
            'fra_type': None,
            'fra_date': None,
            'fra_next_due': None,
            'fra_risk_rating': None,
            'fra_assessor': None,
            'fra_status': None,

            # FRAEW/EWS1
            'fraew_date': None,
            'fraew_outcome': None,
            'fraew_assessor': None,
            'ews1_status': None,
            'cladding_status': None,

            # Electrical
            'eicr_date': None,
            'eicr_next_due': None,
            'eicr_result': None,
            'eicr_status': None,

            # Asbestos
            'asbestos_date': None,
            'asbestos_next_due': None,
            'asbestos_status': None,

            # Legionella
            'legionella_date': None,
            'legionella_next_due': None,
            'legionella_status': None,

            # LOLER
            'loler_date': None,
            'loler_next_due': None,
            'loler_status': None,

            # Gas Safety
            'gas_safety_date': None,
            'gas_safety_next_due': None,
            'gas_safety_status': None,

            # Fire Doors
            'fire_doors_date': None,
            'fire_doors_next_due': None,
            'fire_doors_status': None,

            # Water Hygiene
            'water_hygiene_date': None,
            'water_hygiene_next_due': None,
            'water_hygiene_status': None,

            # Building Systems
            'evacuation_strategy': None,
            'fire_alarm_tested': None,
            'sprinklers_installed': None,
            'structural_review_date': None,

            # Responsible Persons
            'responsible_persons': [],
            'last_responsible_person_check': None,

            # Metadata
            'confidence': 0.0
        }

        confidence_signals = {
            'bsa_detected': False,
            'safety_case_found': False,
            'fra_found': False,
            'assessor_found': False,
            'accountable_person_found': False,
            'risk_rating_found': False
        }

        # Process each document
        for doc in documents:
            text = doc.get('text', '')
            doc_type = doc.get('document_type', '')
            file_name = doc.get('file_name', '')

            if not text:
                continue

            # Extract BSA registration info
            bsa_data = self._extract_bsa_registration(text)
            if bsa_data:
                result.update(bsa_data)
                confidence_signals['bsa_detected'] = True
                confidence_signals['accountable_person_found'] = bsa_data.get('accountable_person') is not None

            # Extract safety case info
            safety_case = self._extract_safety_case(text)
            if safety_case:
                result.update(safety_case)
                confidence_signals['safety_case_found'] = True

            # Extract FRA
            fra = self._extract_fra(text, doc_type, file_name)
            if fra:
                self._update_if_newer(result, fra, 'fra_date')
                if fra.get('fra_risk_rating'):
                    confidence_signals['risk_rating_found'] = True
                if fra.get('fra_assessor'):
                    confidence_signals['assessor_found'] = True
                confidence_signals['fra_found'] = True

            # Extract FRAEW/EWS1
            fraew = self._extract_fraew_ews1(text, doc_type, file_name)
            if fraew:
                self._update_if_newer(result, fraew, 'fraew_date')

            # Extract EICR
            eicr = self._extract_eicr(text, doc_type, file_name)
            if eicr:
                self._update_if_newer(result, eicr, 'eicr_date')

            # Extract other compliance
            for comp_type, config in self.COMPLIANCE_TYPES.items():
                if comp_type in ['FRA', 'FRAEW', 'EWS1', 'EICR']:
                    continue  # Already handled

                comp_data = self._extract_compliance_type(text, comp_type, config, file_name)
                if comp_data:
                    prefix = comp_type.lower()
                    date_key = f'{prefix}_date'
                    self._update_if_newer(result, comp_data, date_key)

            # Extract evacuation strategy
            evac = self._extract_evacuation_strategy(text)
            if evac:
                result['evacuation_strategy'] = evac

            # Extract fire systems
            fire_systems = self._extract_fire_systems(text)
            result.update(fire_systems)

            # Extract responsible persons
            persons = self._extract_responsible_persons(text)
            if persons:
                result['responsible_persons'].extend(persons)

            # Extract golden thread references
            golden_thread = self._extract_golden_thread_refs(text, file_name)
            if golden_thread:
                result['golden_thread_references'].extend(golden_thread)

        # Deduplicate responsible persons
        if result['responsible_persons']:
            result['responsible_persons'] = self._deduplicate_persons(result['responsible_persons'])

        # Calculate confidence
        result['confidence'] = self._calculate_confidence(confidence_signals)

        return result

    def _extract_bsa_registration(self, text: str) -> Optional[Dict]:
        """Extract BSA registration information"""
        data = {}

        # BSA registration number
        pattern = r'(?i)(building\s*safety\s*registration\s*number|bsa\s*registration)[:\-]?\s*(BSA[\-–]?\d{4,8})'
        match = re.search(pattern, text)
        if match:
            data['bsa_registration_number'] = match.group(2)
            data['bsa_registration_status'] = 'Registered'

        # Check for pending status
        if re.search(r'(?i)(not\s*yet\s*registered|registration\s*pending|awaiting\s*registration)', text):
            data['bsa_registration_status'] = 'Pending'

        # Registration date
        reg_date_pattern = r'(?i)(registration\s*date|registered\s*on)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})'
        match = re.search(reg_date_pattern, text)
        if match:
            try:
                dt = date_parser.parse(match.group(2), dayfirst=True)
                data['registration_date'] = dt.strftime('%Y-%m-%d')
            except:
                pass

        # Accountable person
        ap_patterns = [
            r'(?i)(principal\s*accountable\s*person|pap)[:\-]?\s*([A-Z][A-Za-z\s\-]+?)(?:,|\n|$)',
            r'(?i)(accountable\s*person)[:\-]?\s*([A-Z][A-Za-z\s&\.\-]+(Ltd|Limited|LLP)?)',
        ]

        for pattern in ap_patterns:
            match = re.search(pattern, text)
            if match:
                name = match.group(2).strip()
                name = re.sub(r'\s+', ' ', name)

                if 'principal' in match.group(1).lower():
                    data['principal_accountable_person'] = name
                else:
                    data['accountable_person'] = name

        # Safety case required
        if re.search(r'(?i)(safety\s*case\s*required|higher\s*risk\s*building)', text):
            data['safety_case_required'] = True

        return data if data else None

    def _extract_safety_case(self, text: str) -> Optional[Dict]:
        """Extract safety case report information"""
        # Check if this is a safety case document
        if not re.search(r'(?i)(safety\s*case(\s*report)?|building\s*safety\s*case)', text):
            return None

        data = {}

        # Safety case report date
        date_patterns = [
            r'(?i)(report\s*date|issued\s*on|dated)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'(?i)(safety\s*case\s*date)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})'
        ]

        for pattern in date_patterns:
            match = re.search(pattern, text)
            if match:
                try:
                    dt = date_parser.parse(match.group(2), dayfirst=True)
                    data['safety_case_report_date'] = dt.strftime('%Y-%m-%d')
                    break
                except:
                    continue

        # Prepared by
        prep_pattern = r'(?i)(prepared\s*by|author|consultant)[:\-]?\s*([A-Z][A-Za-z\s&\.]+(Ltd|Limited|LLP)?)'
        match = re.search(prep_pattern, text)
        if match:
            data['safety_case_prepared_by'] = match.group(2).strip()

        # Key findings
        findings_patterns = [
            r'(?i)(key\s*findings|residual\s*risk|recommendations)[:\-]?\s*([^\n]{50,300})',
            r'(?i)(summary\s*of\s*risks)[:\-]?\s*([^\n]{50,300})'
        ]

        for pattern in findings_patterns:
            match = re.search(pattern, text)
            if match:
                findings = match.group(2).strip()
                findings = re.sub(r'\s+', ' ', findings)
                data['safety_case_findings'] = findings[:300]
                break

        return data if data else None

    def _extract_fra(self, text: str, doc_type: str, file_name: str) -> Optional[Dict]:
        """Extract Fire Risk Assessment data"""
        # Check if this is an FRA
        if doc_type != 'FRA' and not any(kw in text.lower() for kw in ['fire risk assessment', 'fra']):
            return None

        data = {}

        # FRA Type
        type_match = re.search(r'(?i)type\s*(\d)', text)
        if type_match:
            data['fra_type'] = f"Type {type_match.group(1)}"

        # Assessment date
        date_patterns = [
            r'(?i)(assessment\s*date|survey\s*date|inspection\s*date)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'(?i)(carried\s*out\s*on|completed\s*on)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})'
        ]

        for pattern in date_patterns:
            match = re.search(pattern, text)
            if match:
                try:
                    dt = date_parser.parse(match.group(2), dayfirst=True)
                    data['fra_date'] = dt.strftime('%Y-%m-%d')

                    # Calculate next due (12 months)
                    next_due = dt + relativedelta(months=12)
                    data['fra_next_due'] = next_due.strftime('%Y-%m-%d')

                    # Determine status
                    if next_due.date() >= datetime.now().date():
                        data['fra_status'] = 'current'
                    else:
                        data['fra_status'] = 'expired'

                    break
                except:
                    continue

        # Risk rating
        risk_pattern = r'(?i)(overall\s*risk\s*rating|risk\s*level)[:\-]?\s*(' + '|'.join(self.RISK_RATINGS) + ')'
        match = re.search(risk_pattern, text)
        if match:
            data['fra_risk_rating'] = match.group(2).capitalize()

        # Assessor
        assessor_pattern = r'(?i)(assessor|carried\s*out\s*by|surveyor)[:\-]?\s*([A-Z][A-Za-z\s&\.]+(Ltd|Limited)?)'
        match = re.search(assessor_pattern, text)
        if match:
            data['fra_assessor'] = match.group(2).strip()

        return data if data else None

    def _extract_fraew_ews1(self, text: str, doc_type: str, file_name: str) -> Optional[Dict]:
        """Extract FRAEW and EWS1 data"""
        data = {}

        # Check for FRAEW
        if re.search(r'(?i)(fraew|fire\s*risk\s*appraisal.*external\s*wall)', text):
            # FRAEW date
            date_match = re.search(r'(?i)(assessment\s*date|survey\s*date)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})', text)
            if date_match:
                try:
                    dt = date_parser.parse(date_match.group(2), dayfirst=True)
                    data['fraew_date'] = dt.strftime('%Y-%m-%d')
                except:
                    pass

            # Outcome
            if re.search(r'(?i)pas\s*9980', text):
                if re.search(r'(?i)(low\s*risk|minimal\s*risk)', text):
                    data['fraew_outcome'] = 'PAS 9980 – Low Risk'
                elif re.search(r'(?i)(medium\s*risk|requires\s*mitigation)', text):
                    data['fraew_outcome'] = 'PAS 9980 – Medium Risk'

            # Assessor
            assessor_match = re.search(r'(?i)(assessor|surveyor)[:\-]?\s*([A-Z][A-Za-z\s&\.]+(Ltd|Limited)?)', text)
            if assessor_match:
                data['fraew_assessor'] = assessor_match.group(2).strip()

        # Check for EWS1
        ews1_match = re.search(r'(?i)ews1\s*form\s*([AB])(\d)?', text)
        if ews1_match:
            form_type = ews1_match.group(1)
            form_num = ews1_match.group(2) or ''
            data['ews1_status'] = f"Form {form_type}{form_num}"

        # Cladding status
        if re.search(r'(?i)(no\s*combustible\s*cladding|non[\-\s]?acm|limited\s*combustibility)', text):
            data['cladding_status'] = 'Non-ACM – Safe'
        elif re.search(r'(?i)(acm|combustible\s*cladding)', text):
            data['cladding_status'] = 'ACM Present – Mitigation Required'

        return data if data else None

    def _extract_eicr(self, text: str, doc_type: str, file_name: str) -> Optional[Dict]:
        """Extract EICR data"""
        if doc_type != 'EICR' and not any(kw in text.lower() for kw in ['eicr', 'electrical installation condition']):
            return None

        data = {}

        # Inspection date
        date_match = re.search(r'(?i)(inspection\s*date|date\s*of\s*inspection)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})', text)
        if date_match:
            try:
                dt = date_parser.parse(date_match.group(2), dayfirst=True)
                data['eicr_date'] = dt.strftime('%Y-%m-%d')

                # Next due (60 months)
                next_due = dt + relativedelta(months=60)
                data['eicr_next_due'] = next_due.strftime('%Y-%m-%d')

                # Status
                if next_due.date() >= datetime.now().date():
                    data['eicr_status'] = 'current'
                else:
                    data['eicr_status'] = 'expired'
            except:
                pass

        # Result
        if re.search(r'(?i)(satisfactory|no\s*defects)', text):
            data['eicr_result'] = 'Satisfactory'
        elif re.search(r'(?i)(unsatisfactory|c[123]\s*code)', text):
            data['eicr_result'] = 'Unsatisfactory'

        return data if data else None

    def _extract_compliance_type(self, text: str, comp_type: str, config: Dict, file_name: str) -> Optional[Dict]:
        """Extract generic compliance document data"""
        # Check if this document matches the compliance type
        if not any(kw in text.lower() for kw in config['keywords']):
            return None

        data = {}
        prefix = comp_type.lower()

        # Extract date
        date_match = re.search(r'(?i)(inspection\s*date|survey\s*date|test\s*date|assessment\s*date)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})', text)
        if date_match:
            try:
                dt = date_parser.parse(date_match.group(2), dayfirst=True)
                data[f'{prefix}_date'] = dt.strftime('%Y-%m-%d')

                # Calculate next due if renewal period exists
                if config['renewal_months']:
                    next_due = dt + relativedelta(months=config['renewal_months'])
                    data[f'{prefix}_next_due'] = next_due.strftime('%Y-%m-%d')

                    # Status
                    if next_due.date() >= datetime.now().date():
                        data[f'{prefix}_status'] = 'current'
                    else:
                        data[f'{prefix}_status'] = 'expired'

            except:
                pass

        return data if data else None

    def _extract_evacuation_strategy(self, text: str) -> Optional[str]:
        """Extract evacuation strategy"""
        text_lower = text.lower()

        for strategy in self.EVACUATION_STRATEGIES:
            if strategy in text_lower:
                return strategy.title()

        return None

    def _extract_fire_systems(self, text: str) -> Dict:
        """Extract fire system information"""
        data = {}

        # Fire alarm tested
        alarm_match = re.search(r'(?i)(fire\s*alarm.*tested|alarm\s*test\s*date)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})', text)
        if alarm_match:
            try:
                dt = date_parser.parse(alarm_match.group(2), dayfirst=True)
                data['fire_alarm_tested'] = dt.strftime('%Y-%m-%d')
            except:
                pass

        # Sprinklers
        if re.search(r'(?i)(sprinkler.*installed|sprinkler\s*system)', text):
            data['sprinklers_installed'] = True
        elif re.search(r'(?i)(no\s*sprinkler|sprinkler.*not\s*installed)', text):
            data['sprinklers_installed'] = False

        # Structural review
        struct_match = re.search(r'(?i)(structural\s*review|structural\s*survey)[:\-]?\s*(\d{1,2}\s+\w+\s+\d{4})', text)
        if struct_match:
            try:
                dt = date_parser.parse(struct_match.group(2), dayfirst=True)
                data['structural_review_date'] = dt.strftime('%Y-%m-%d')
            except:
                pass

        return data

    def _extract_responsible_persons(self, text: str) -> List[Dict]:
        """Extract responsible persons and dutyholders"""
        persons = []

        patterns = [
            r'(?i)(principal\s*accountable\s*person|pap)[:\-]?\s*([A-Z][A-Za-z\s\-]+?)(?:,|\(|$)',
            r'(?i)(building\s*safety\s*manager|bsm)[:\-]?\s*([A-Z][A-Za-z\s\-]+?)(?:,|\(|$)',
            r'(?i)(responsible\s*person|dutyholder)[:\-]?\s*([A-Z][A-Za-z\s\-]+?)(?:,|\(|$)',
            r'(?i)(fire\s*warden)[:\-]?\s*([A-Z][A-Za-z\s\-]+?)(?:,|\(|$)',
        ]

        for pattern in patterns:
            matches = re.finditer(pattern, text)
            for match in matches:
                role = match.group(1).strip()
                name = match.group(2).strip()

                # Clean up
                name = re.sub(r'\s+', ' ', name)
                name = name.strip(',;:()')

                if len(name) > 3:
                    persons.append({
                        'name': name,
                        'role': role.title()
                    })

        return persons

    def _extract_golden_thread_refs(self, text: str, file_name: str) -> List[str]:
        """Extract golden thread document references"""
        refs = []

        if re.search(r'(?i)(golden\s*thread|building\s*safety\s*file|information\s*management)', text):
            refs.append(file_name)

        return refs

    def _update_if_newer(self, result: Dict, new_data: Dict, date_key: str):
        """Update result with new data if it's more recent"""
        if date_key not in new_data:
            return

        new_date = new_data[date_key]

        # If no existing date, use new data
        if not result.get(date_key):
            result.update(new_data)
            return

        # Compare dates
        try:
            existing_dt = datetime.strptime(result[date_key], '%Y-%m-%d')
            new_dt = datetime.strptime(new_date, '%Y-%m-%d')

            if new_dt > existing_dt:
                result.update(new_data)
        except:
            pass

    def _deduplicate_persons(self, persons: List[Dict]) -> List[Dict]:
        """Deduplicate responsible persons by name"""
        seen = set()
        unique = []

        for person in persons:
            name = person['name'].lower()
            if name not in seen:
                seen.add(name)
                unique.append(person)

        return unique

    def _calculate_confidence(self, signals: Dict[str, bool]) -> float:
        """Calculate confidence score"""
        score = 0.0

        if signals['bsa_detected']:
            score += 0.3
        if signals['safety_case_found'] or signals['fra_found']:
            score += 0.2
        if signals['assessor_found']:
            score += 0.2
        if signals['accountable_person_found']:
            score += 0.2
        if signals['risk_rating_found']:
            score += 0.1

        return round(score, 2)


# Test function
if __name__ == '__main__':
    extractor = BSAComplianceExtractor()

    # Test data
    test_text = """
    BUILDING SAFETY ACT REGISTRATION CONFIRMATION

    Building Safety Registration Number: BSA-002143-LHR
    Registration Date: 28 March 2024
    Principal Accountable Person: John Doe, Director
    Accountable Person: MIH Property Management Ltd

    SAFETY CASE REPORT

    Report Date: 10 June 2024
    Prepared by: GDA Surveying Ltd

    Key Findings: Residual risk identified - façade cavity barriers incomplete.
    Remediation works scheduled for Q3 2024.

    FIRE RISK ASSESSMENT (Type 1)

    Assessment Date: 4 March 2025
    Overall Risk Rating: Low
    Assessor: TriFire Safety Ltd
    Next Review: 4 March 2026

    FIRE RISK APPRAISAL OF EXTERNAL WALLS (FRAEW)

    Assessment Date: 12 October 2022
    Outcome: PAS 9980 – Low Risk
    EWS1 Form: B1
    Cladding Status: Non-ACM – Limited combustibility materials confirmed

    ELECTRICAL INSTALLATION CONDITION REPORT

    Inspection Date: 22 June 2022
    Result: Satisfactory - No remedial works required
    Next Inspection Due: June 2027

    EVACUATION STRATEGY: Stay Put

    Building Safety Manager: Sarah Clarke
    Fire Warden: Michael Johnson
    """

    test_doc = {
        'text': test_text,
        'document_type': 'FRA',
        'file_name': 'Building_Safety_File_2024.pdf'
    }

    result = extractor.extract_from_documents([test_doc])

    print("BSA & Compliance Extraction Results:")
    print("=" * 60)
    for key, value in result.items():
        if value:
            print(f"{key}: {value}")
