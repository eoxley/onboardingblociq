"""BlocIQ Onboarder - Client Money Extractor"""
import re, uuid
from typing import Dict, Optional
from datetime import datetime

class ClientMoneyExtractor:
    def extract(self, file_data: Dict, building_id: str) -> Optional[Dict]:
        text = file_data.get('full_text', '')
        if not text or len(text) < 50:
            return None

        return {
            'snapshot': {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'snapshot_date': self._extract_date(text),
                'bank_name': self._extract_bank(text),
                'account_identifier': self._extract_account(text),
                'balance': self._extract_balance(text),
                'uncommitted_funds': self._extract_uncommitted(text),
                'arrears_total': self._extract_arrears(text),
                'notes': f"Imported from {file_data.get('file_name', '')}"
            },
            'metadata': {'extracted_from': file_data.get('file_name', '')}
        }

    def _extract_date(self, text: str) -> Optional[str]:
        m = re.search(r'(?:as\s*(?:at|of)|date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})', text, re.I)
        return self._normalize_date(m.group(1)) if m else None

    def _extract_bank(self, text: str) -> Optional[str]:
        banks = ['Barclays', 'HSBC', 'Lloyds', 'NatWest', 'Santander', 'Metro Bank']
        for bank in banks:
            if bank.lower() in text.lower():
                return bank
        return None

    def _extract_account(self, text: str) -> Optional[str]:
        m = re.search(r'(?:account\s*(?:no|number))[:\s]*([0-9]{8})', text, re.I)
        return m.group(1) if m else None

    def _extract_balance(self, text: str) -> Optional[float]:
        m = re.search(r'(?:balance|total)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)', text, re.I)
        if m:
            try:
                return float(m.group(1).replace(',', ''))
            except:
                pass
        return None

    def _extract_uncommitted(self, text: str) -> Optional[float]:
        m = re.search(r'(?:uncommitted\s*funds?)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)', text, re.I)
        if m:
            try:
                return float(m.group(1).replace(',', ''))
            except:
                pass
        return None

    def _extract_arrears(self, text: str) -> Optional[float]:
        m = re.search(r'(?:arrears|outstanding)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)', text, re.I)
        if m:
            try:
                return float(m.group(1).replace(',', ''))
            except:
                pass
        return None

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
