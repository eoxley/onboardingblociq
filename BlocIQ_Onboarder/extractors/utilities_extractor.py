"""BlocIQ Onboarder - Utilities Extractor"""
import re, uuid
from typing import Dict, Optional
from datetime import datetime

class UtilitiesExtractor:
    UTILITY_TYPES = ['electricity', 'gas', 'water', 'waste', 'telecommunications']

    def extract(self, file_data: Dict, building_id: str) -> Optional[Dict]:
        text = file_data.get('full_text', '')
        if not text or len(text) < 50:
            return None

        return {
            'utility': {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'supplier': self._extract_supplier(text),
                'utility_type': self._detect_type(text, file_data.get('file_name', '')),
                'account_number': self._extract_account(text),
                'start_date': self._extract_date(text, 'start'),
                'end_date': self._extract_date(text, 'end'),
                'tariff': self._extract_tariff(text),
                'contract_status': 'active'
            },
            'metadata': {'extracted_from': file_data.get('file_name', '')}
        }

    def _extract_supplier(self, text: str) -> Optional[str]:
        for supplier in ['British Gas', 'EDF', 'E.ON', 'Scottish Power', 'Thames Water', 'Veolia']:
            if supplier.lower() in text.lower():
                return supplier
        match = re.search(r'(?:supplier|provider)[:\s]*([A-Z][A-Za-z\s]+)', text, re.I)
        return match.group(1).strip() if match else None

    def _detect_type(self, text: str, filename: str) -> Optional[str]:
        search = f"{filename} {text}".lower()
        for utype in self.UTILITY_TYPES:
            if utype in search:
                return utype
        return None

    def _extract_account(self, text: str) -> Optional[str]:
        patterns = [r'(?:account\s*(?:no|number))[:\s]*([A-Z0-9]{6,})', r'(?:mpan|mprn)[:\s]*([0-9]{10,})']
        for p in patterns:
            m = re.search(p, text, re.I)
            if m:
                return m.group(1)
        return None

    def _extract_date(self, text: str, dtype: str) -> Optional[str]:
        patterns = {'start': r'(?:start\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
                   'end': r'(?:end\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'}
        m = re.search(patterns.get(dtype, ''), text, re.I)
        return self._normalize_date(m.group(1)) if m else None

    def _extract_tariff(self, text: str) -> Optional[str]:
        m = re.search(r'(?:tariff|rate)[:\s]*([^\n]{10,100})', text, re.I)
        return m.group(1).strip() if m else None

    def _normalize_date(self, ds: str) -> Optional[str]:
        for sep in ['/', '-']:
            m = re.match(f'(\\d{{1,2}}){sep}(\\d{{1,2}}){sep}(\\d{{2,4}})', ds)
            if m:
                d, mo, y = m.groups()
                if len(y) == 2:
                    y = f"20{y}"
                try:
                    return datetime(int(y), int(mo), int(d)).date().isoformat()
                except:
                    pass
        return None
