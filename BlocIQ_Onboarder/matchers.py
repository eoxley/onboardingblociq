"""
BlocIQ Onboarder - Fuzzy Matching Utilities
Deterministic matching with confidence scores for buildings, units, and people
"""

import hashlib
from typing import List, Optional, Tuple, Dict
from dataclasses import dataclass
from pathlib import Path

try:
    from rapidfuzz import process, fuzz
    RAPIDFUZZ_AVAILABLE = True
except ImportError:
    RAPIDFUZZ_AVAILABLE = False
    import difflib

from normalizers import norm_building_name, norm_unit_label, norm_name


@dataclass
class MatchResult:
    """Result of a fuzzy match operation"""
    matched_value: str
    original_value: str
    score: int  # 0-100
    confidence_level: str  # 'high', 'medium', 'low', 'poor'
    action: str  # 'AUTO', 'REVIEW', 'REJECT'


def file_sha256(path: str) -> str:
    """
    Calculate SHA-256 hash of file for idempotency

    Args:
        path: Path to file

    Returns:
        Hex digest of SHA-256 hash
    """
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def content_sha256(content: str) -> str:
    """
    Calculate SHA-256 hash of content string

    Args:
        content: String content to hash

    Returns:
        Hex digest of SHA-256 hash
    """
    return hashlib.sha256(content.encode('utf-8')).hexdigest()


class FuzzyMatcher:
    """
    Fuzzy matching with confidence-based decisions

    Thresholds:
        ≥ 90: AUTO (automatically link)
        60-89: REVIEW (stage for manual review)
        < 60: REJECT (do not link, create new)
    """

    def __init__(self, thresholds: Dict[str, int] = None):
        if thresholds is None:
            thresholds = {
                'auto_link': 90,
                'review': 60,
                'reject': 60
            }
        self.thresholds = thresholds

    def best_match(self,
                    query: str,
                    choices: List[str],
                    scorer: str = 'WRatio') -> Optional[MatchResult]:
        """
        Find best fuzzy match from list of choices

        Args:
            query: String to match
            choices: List of candidate strings
            scorer: Scoring algorithm ('WRatio', 'ratio', 'token_sort_ratio')

        Returns:
            MatchResult or None if no choices
        """
        if not query or not choices:
            return None

        if RAPIDFUZZ_AVAILABLE:
            # Use rapidfuzz (fast, accurate)
            scorer_func = getattr(fuzz, scorer, fuzz.WRatio)
            match, score, _ = process.extractOne(query, choices, scorer=scorer_func)
            score = int(score)
        else:
            # Fallback to difflib (slower, pure Python)
            matches = difflib.get_close_matches(query, choices, n=1, cutoff=0.0)
            if not matches:
                return None
            match = matches[0]
            score = int(difflib.SequenceMatcher(None, query, match).ratio() * 100)

        # Determine confidence level and action
        confidence_level, action = self._score_to_confidence(score)

        return MatchResult(
            matched_value=match,
            original_value=query,
            score=score,
            confidence_level=confidence_level,
            action=action
        )

    def match_building(self,
                       query: str,
                       existing_buildings: List[str]) -> Optional[MatchResult]:
        """
        Match building name with normalization

        Args:
            query: Building name to match
            existing_buildings: List of existing building names

        Returns:
            MatchResult or None
        """
        # Normalize query
        norm_query = norm_building_name(query)

        # Normalize choices
        norm_choices = [norm_building_name(b) for b in existing_buildings]

        # Find best match
        result = self.best_match(norm_query, norm_choices, scorer='token_sort_ratio')

        if result:
            # Map back to original building name
            original_idx = norm_choices.index(result.matched_value)
            result.matched_value = existing_buildings[original_idx]

        return result

    def match_unit(self,
                   query: str,
                   existing_units: List[str]) -> Optional[MatchResult]:
        """
        Match unit label with normalization

        Args:
            query: Unit label to match
            existing_units: List of existing unit labels

        Returns:
            MatchResult or None
        """
        # Normalize query
        norm_query = norm_unit_label(query)

        # Normalize choices
        norm_choices = [norm_unit_label(u) for u in existing_units]

        # Find best match
        result = self.best_match(norm_query, norm_choices, scorer='ratio')

        if result:
            # Map back to original unit label
            original_idx = norm_choices.index(result.matched_value)
            result.matched_value = existing_units[original_idx]

        return result

    def match_name(self,
                   query: str,
                   existing_names: List[str]) -> Optional[MatchResult]:
        """
        Match person name with normalization

        Args:
            query: Name to match
            existing_names: List of existing names

        Returns:
            MatchResult or None
        """
        # Normalize query
        norm_query = norm_name(query)

        # Normalize choices
        norm_choices = [norm_name(n) for n in existing_names]

        # Find best match
        result = self.best_match(norm_query, norm_choices, scorer='token_sort_ratio')

        if result:
            # Map back to original name
            original_idx = norm_choices.index(result.matched_value)
            result.matched_value = existing_names[original_idx]

        return result

    def _score_to_confidence(self, score: int) -> Tuple[str, str]:
        """
        Convert numeric score to confidence level and recommended action

        Args:
            score: Match score (0-100)

        Returns:
            Tuple of (confidence_level, action)
        """
        if score >= self.thresholds['auto_link']:
            return 'high', 'AUTO'
        elif score >= self.thresholds['review']:
            return 'medium', 'REVIEW'
        else:
            return 'low', 'REJECT'


class DeduplicationHelper:
    """Helper for detecting and handling duplicate documents"""

    def __init__(self):
        self.seen_hashes = set()
        self.hash_to_file = {}

    def is_duplicate(self, file_path: str) -> Tuple[bool, Optional[str]]:
        """
        Check if file is a duplicate based on content hash

        Args:
            file_path: Path to file

        Returns:
            Tuple of (is_duplicate, original_file_path)
        """
        file_hash = file_sha256(file_path)

        if file_hash in self.seen_hashes:
            original = self.hash_to_file.get(file_hash)
            return True, original

        self.seen_hashes.add(file_hash)
        self.hash_to_file[file_hash] = file_path
        return False, None

    def mark_as_processed(self, file_path: str, content_hash: str = None):
        """
        Mark file as processed

        Args:
            file_path: Path to file
            content_hash: Pre-calculated hash (optional)
        """
        if content_hash is None:
            content_hash = file_sha256(file_path)

        self.seen_hashes.add(content_hash)
        self.hash_to_file[content_hash] = file_path


def load_existing_buildings_csv(csv_path: str, col: str = 'name') -> List[str]:
    """
    Load existing buildings from CSV export

    Args:
        csv_path: Path to CSV file
        col: Column name containing building names

    Returns:
        List of building names
    """
    import csv
    buildings = []

    try:
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                if row.get(col):
                    buildings.append(row[col])
    except FileNotFoundError:
        pass  # Return empty list if file doesn't exist

    return buildings


def load_existing_units_csv(csv_path: str, col: str = 'unit_number') -> List[str]:
    """
    Load existing units from CSV export

    Args:
        csv_path: Path to CSV file
        col: Column name containing unit numbers

    Returns:
        List of unit numbers
    """
    import csv
    units = []

    try:
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                if row.get(col):
                    units.append(row[col])
    except FileNotFoundError:
        pass

    return units
