"""BlocIQ Onboarder - Meetings Extractor"""
import re, uuid
from typing import Dict, Optional
from datetime import datetime

class MeetingsExtractor:
    MEETING_TYPES = {'agm': 'AGM', 'egm': 'EGM', 'board': 'Board', 'handover': 'Handover'}

    def extract(self, file_data: Dict, building_id: str) -> Optional[Dict]:
        text = file_data.get('full_text', '')
        fname = file_data.get('file_name', '')
        if not text or len(text) < 50:
            return None

        return {
            'meeting': {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'meeting_type': self._detect_type(text, fname),
                'meeting_date': self._extract_date(text),
                'attendees': self._extract_attendees(text),
                'key_decisions': self._extract_decisions(text),
                'minutes_url': None
            },
            'metadata': {'extracted_from': fname}
        }

    def _detect_type(self, text: str, filename: str) -> Optional[str]:
        search = f"{filename} {text}".lower()
        for key, mtype in self.MEETING_TYPES.items():
            if key in search:
                return mtype
        return 'General'

    def _extract_date(self, text: str) -> Optional[str]:
        patterns = [r'(?:meeting\s*date|held\s*on)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
                   r'(\d{1,2}[/-]\d{1,2}[/-]\d{4})']
        for p in patterns:
            m = re.search(p, text, re.I)
            if m:
                return self._normalize_date(m.group(1))
        return None

    def _extract_attendees(self, text: str) -> Optional[str]:
        m = re.search(r'(?:attendees?|present)[:\s]*([^\n]{20,200})', text, re.I)
        return m.group(1).strip()[:200] if m else None

    def _extract_decisions(self, text: str) -> Optional[str]:
        patterns = [r'(?:resolved|decisions?|agreed)[:\s]*([^\n]{30,500})']
        decisions = []
        for p in patterns:
            matches = re.findall(p, text, re.I | re.DOTALL)
            decisions.extend([re.sub(r'\s+', ' ', m.strip())[:300] for m in matches[:5]])
        return ' | '.join(decisions) if decisions else None

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
