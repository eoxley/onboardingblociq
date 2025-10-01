"""
BlocIQ Onboarder - Data Normalizers
UK-aware normalization utilities for deterministic data processing
"""

import re
from datetime import datetime
from typing import Optional


# UK Postcode normalization
POSTCODE_RE = re.compile(r"\b([A-Z]{1,2}\d[A-Z\d]?)\s?(\d[A-Z]{2})\b", re.IGNORECASE)


def norm_postcode(s: str) -> Optional[str]:
    """
    Normalize UK postcode to standard format: 'SW1A 1AA'

    Examples:
        'sw1a1aa' -> 'SW1A 1AA'
        'W2 2HL' -> 'W2 2HL'
        'invalid' -> None
    """
    if not s:
        return None
    m = POSTCODE_RE.search(s)
    if not m:
        return None
    return f"{m.group(1).upper()} {m.group(2).upper()}"


def norm_unit_label(s: str) -> str:
    """
    Normalize unit labels to consistent format

    Examples:
        'Apartment 5' -> 'UNIT 5'
        'Flat A1' -> 'UNIT A1'
        'apt. 3b' -> 'UNIT 3B'
    """
    if not s:
        return ""

    s = s.strip().upper()

    # Normalize variations to UNIT
    s = s.replace("APARTMENT", "UNIT")
    s = s.replace("APART.", "UNIT")
    s = s.replace("APART", "UNIT")
    s = s.replace("APT.", "UNIT")
    s = s.replace("APT", "UNIT")
    s = re.sub(r"\bFLAT\b", "UNIT", s)

    # Collapse whitespace
    s = re.sub(r"\s+", " ", s)

    # Remove trailing dots
    s = s.rstrip(".")

    return s.strip()


def norm_date(s: str) -> Optional[str]:
    """
    Parse date from various UK formats and return ISO format (YYYY-MM-DD)

    Supported formats:
        - DD/MM/YYYY
        - DD-MM-YYYY
        - YYYY-MM-DD
        - DD Mon YYYY
        - DD Month YYYY

    Returns:
        ISO format string (YYYY-MM-DD) or None if unparseable
    """
    if not s:
        return None

    s = str(s).strip()

    # Try common UK formats
    formats = [
        "%d/%m/%Y",     # 31/12/2024
        "%d-%m-%Y",     # 31-12-2024
        "%Y-%m-%d",     # 2024-12-31 (ISO)
        "%d %b %Y",     # 31 Dec 2024
        "%d %B %Y",     # 31 December 2024
        "%d/%m/%y",     # 31/12/24
        "%d-%m-%y",     # 31-12-24
        "%d.%m.%Y",     # 31.12.2024
        "%Y/%m/%d",     # 2024/12/31
    ]

    for fmt in formats:
        try:
            dt = datetime.strptime(s, fmt)
            # Handle 2-digit years
            if dt.year < 100:
                dt = dt.replace(year=dt.year + 2000 if dt.year < 50 else dt.year + 1900)
            return dt.date().isoformat()
        except ValueError:
            continue

    return None


def norm_currency(s: str) -> Optional[float]:
    """
    Extract and normalize currency amount

    Examples:
        '£1,234.56' -> 1234.56
        '$1234.56' -> 1234.56
        '1,234' -> 1234.0
    """
    if not s:
        return None

    s = str(s).strip()

    # Remove currency symbols and commas
    cleaned = re.sub(r'[£$€,\s]', '', s)

    # Extract numeric value
    match = re.search(r'[\d.]+', cleaned)
    if not match:
        return None

    try:
        return float(match.group())
    except ValueError:
        return None


def norm_percentage(s: str) -> Optional[float]:
    """
    Extract and normalize percentage value

    Examples:
        '12.5%' -> 12.5
        '12.5 %' -> 12.5
        '0.125' -> 0.125
    """
    if not s:
        return None

    s = str(s).strip()

    # Remove % sign and whitespace
    cleaned = re.sub(r'[%\s]', '', s)

    # Extract numeric value
    match = re.search(r'[\d.]+', cleaned)
    if not match:
        return None

    try:
        return float(match.group())
    except ValueError:
        return None


def norm_phone(s: str) -> Optional[str]:
    """
    Normalize UK phone numbers

    Examples:
        '020 7123 4567' -> '02071234567'
        '+44 20 7123 4567' -> '02071234567'
        '07700 900123' -> '07700900123'
    """
    if not s:
        return None

    s = str(s).strip()

    # Remove common separators
    s = re.sub(r'[\s\-().]', '', s)

    # Handle international format
    if s.startswith('+44'):
        s = '0' + s[3:]
    elif s.startswith('0044'):
        s = '0' + s[4:]

    # Validate UK phone number pattern
    if re.match(r'^0\d{9,10}$', s):
        return s

    return None


def norm_email(s: str) -> Optional[str]:
    """
    Normalize and validate email address
    """
    if not s:
        return None

    s = str(s).strip().lower()

    # Basic email validation
    if re.match(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$', s):
        return s

    return None


def norm_building_name(s: str) -> str:
    """
    Normalize building name for consistent matching

    Examples:
        'The Connaught Square Freehold Ltd' -> 'CONNAUGHT SQUARE FREEHOLD'
        '32-34 Connaught Sq' -> '32-34 CONNAUGHT SQUARE'
    """
    if not s:
        return ""

    s = str(s).strip().upper()

    # Remove common prefixes
    s = re.sub(r'^\s*THE\s+', '', s)

    # Remove legal suffixes
    s = re.sub(r'\s+(LIMITED|LTD|LTD\.|PLC|LLP)$', '', s)

    # Expand common abbreviations
    s = re.sub(r'\bSQ\b', 'SQUARE', s)
    s = re.sub(r'\bST\b', 'STREET', s)
    s = re.sub(r'\bRD\b', 'ROAD', s)
    s = re.sub(r'\bAVE\b', 'AVENUE', s)
    s = re.sub(r'\bGDNS?\b', 'GARDENS', s)

    # Collapse whitespace
    s = re.sub(r'\s+', ' ', s)

    return s.strip()


def norm_name(s: str) -> str:
    """
    Normalize person name for consistent matching

    Examples:
        'JOHN SMITH' -> 'John Smith'
        'smith, john' -> 'John Smith'
    """
    if not s:
        return ""

    s = str(s).strip()

    # Handle "Last, First" format
    if ',' in s:
        parts = s.split(',', 1)
        if len(parts) == 2:
            s = f"{parts[1].strip()} {parts[0].strip()}"

    # Title case
    s = s.title()

    # Fix common abbreviations
    s = re.sub(r'\bMr\b', 'Mr', s)
    s = re.sub(r'\bMrs\b', 'Mrs', s)
    s = re.sub(r'\bMs\b', 'Ms', s)
    s = re.sub(r'\bDr\b', 'Dr', s)

    return s.strip()


def extract_unit_number_from_text(text: str) -> Optional[str]:
    """
    Extract unit number from free text

    Examples:
        'Flat 5, 32 Connaught Square' -> 'UNIT 5'
        'Apartment A1' -> 'UNIT A1'
    """
    if not text:
        return None

    # Try various patterns
    patterns = [
        r'\b(?:Flat|Apartment|Apt|Unit)\s+([A-Z]?\d+[A-Z]?)\b',
        r'\b([A-Z]\d+)\b',
        r'\bFlat\s+([A-Z]+)\b',
    ]

    for pattern in patterns:
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return norm_unit_label(f"Unit {match.group(1)}")

    return None
