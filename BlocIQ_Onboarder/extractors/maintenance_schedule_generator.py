"""
BlocIQ Onboarder - Maintenance Schedule Generator
Generates maintenance schedule entries from recurring contract patterns
"""

import re
import uuid
from typing import Dict, List, Optional
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta


class MaintenanceScheduleGenerator:
    """Generates maintenance schedule entries from contract frequency patterns"""

    FREQUENCY_PATTERNS = {
        'daily': {'interval': '1 day', 'months': 0, 'days': 1},
        'weekly': {'interval': '7 days', 'months': 0, 'days': 7},
        'fortnightly': {'interval': '14 days', 'months': 0, 'days': 14},
        '2-weekly': {'interval': '14 days', 'months': 0, 'days': 14},
        '4-weekly': {'interval': '28 days', 'months': 0, 'days': 28},
        '6-weekly': {'interval': '42 days', 'months': 0, 'days': 42},
        'monthly': {'interval': '1 month', 'months': 1, 'days': 0},
        'bi-monthly': {'interval': '2 months', 'months': 2, 'days': 0},
        'quarterly': {'interval': '3 months', 'months': 3, 'days': 0},
        'semi-annual': {'interval': '6 months', 'months': 6, 'days': 0},
        'annual': {'interval': '12 months', 'months': 12, 'days': 0},
        'yearly': {'interval': '12 months', 'months': 12, 'days': 0},
        '6-monthly': {'interval': '6 months', 'months': 6, 'days': 0},
        '12-monthly': {'interval': '12 months', 'months': 12, 'days': 0}
    }

    def __init__(self):
        pass

    def generate_from_contract(self, contract_data: Dict) -> List[Dict]:
        """
        Generate maintenance schedules from contract frequency

        Args:
            contract_data: Dict containing contract details

        Returns:
            List of maintenance schedule records
        """
        schedules = []

        frequency = contract_data.get('frequency')
        if not frequency:
            return schedules

        # Normalize frequency
        frequency_normalized = frequency.lower().strip()

        # Check if it's a known frequency pattern
        frequency_info = None
        for pattern, info in self.FREQUENCY_PATTERNS.items():
            if pattern in frequency_normalized:
                frequency_info = info
                break

        if not frequency_info:
            # Try to extract numeric patterns like "every 3 months"
            frequency_info = self._parse_custom_frequency(frequency_normalized)

        if not frequency_info:
            return schedules

        # Generate schedule entry
        schedule = self._create_schedule_entry(contract_data, frequency_info)
        if schedule:
            schedules.append(schedule)

        return schedules

    def _create_schedule_entry(self, contract_data: Dict, frequency_info: Dict) -> Optional[Dict]:
        """Create a single maintenance schedule entry"""

        # Determine next due date
        start_date = contract_data.get('start_date')
        last_service = contract_data.get('last_completed_date')

        next_due = self._calculate_next_due_date(
            start_date=start_date,
            last_service=last_service,
            frequency_info=frequency_info
        )

        if not next_due:
            return None

        # Determine priority based on service type
        priority = self._determine_priority(contract_data.get('service_type'))

        schedule = {
            'id': str(uuid.uuid4()),
            'building_id': contract_data.get('building_id'),
            'contract_id': contract_data.get('id'),
            'contractor_id': None,  # Will be linked later
            'service_type': contract_data.get('service_type'),
            'description': f"{contract_data.get('service_type', 'Service')} - {contract_data.get('contractor_name', 'Contractor')}",
            'frequency': contract_data.get('frequency'),
            'frequency_interval': frequency_info['interval'],
            'next_due_date': next_due,
            'last_completed_date': last_service,
            'estimated_duration': self._estimate_duration(contract_data.get('service_type')),
            'cost_estimate': contract_data.get('value'),
            'priority': priority,
            'status': 'scheduled',
            'notes': None
        }

        return schedule

    def _calculate_next_due_date(self, start_date: Optional[str], last_service: Optional[str],
                                  frequency_info: Dict) -> Optional[str]:
        """Calculate the next due date based on frequency"""

        # Use last_service if available, otherwise start_date
        base_date_str = last_service or start_date

        if not base_date_str:
            # Use today as fallback
            base_date = datetime.now().date()
        else:
            try:
                base_date = datetime.fromisoformat(base_date_str).date()
            except (ValueError, TypeError):
                base_date = datetime.now().date()

        # Calculate next due
        months = frequency_info.get('months', 0)
        days = frequency_info.get('days', 0)

        if months > 0:
            next_due = base_date + relativedelta(months=months)
        elif days > 0:
            next_due = base_date + timedelta(days=days)
        else:
            return None

        return next_due.isoformat()

    def _parse_custom_frequency(self, frequency_text: str) -> Optional[Dict]:
        """Parse custom frequency patterns like 'every 3 months'"""

        # Pattern: "every X days/weeks/months/years"
        patterns = [
            (r'every\s+(\d+)\s+days?', 'days'),
            (r'every\s+(\d+)\s+weeks?', 'weeks'),
            (r'every\s+(\d+)\s+months?', 'months'),
            (r'every\s+(\d+)\s+years?', 'years'),
            (r'(\d+)\s*times?\s+per\s+year', 'times_per_year'),
            (r'(\d+)x\s+(?:per\s+)?year', 'times_per_year')
        ]

        for pattern, unit in patterns:
            match = re.search(pattern, frequency_text, re.IGNORECASE)
            if match:
                number = int(match.group(1))

                if unit == 'days':
                    return {'interval': f'{number} days', 'months': 0, 'days': number}
                elif unit == 'weeks':
                    return {'interval': f'{number * 7} days', 'months': 0, 'days': number * 7}
                elif unit == 'months':
                    return {'interval': f'{number} months', 'months': number, 'days': 0}
                elif unit == 'years':
                    return {'interval': f'{number * 12} months', 'months': number * 12, 'days': 0}
                elif unit == 'times_per_year':
                    # Convert times per year to months interval
                    months_interval = 12 // number if number > 0 else 12
                    return {'interval': f'{months_interval} months', 'months': months_interval, 'days': 0}

        return None

    def _determine_priority(self, service_type: Optional[str]) -> str:
        """Determine priority level based on service type"""
        if not service_type:
            return 'medium'

        service_lower = service_type.lower()

        # High priority services (safety-critical)
        high_priority = ['fire_alarm', 'emergency_lighting', 'lifts', 'sprinkler', 'aov']
        if any(p in service_lower for p in high_priority):
            return 'high'

        # Low priority services
        low_priority = ['cleaning', 'window_cleaning', 'grounds_maintenance']
        if any(p in service_lower for p in low_priority):
            return 'low'

        # Default to medium
        return 'medium'

    def _estimate_duration(self, service_type: Optional[str]) -> Optional[str]:
        """Estimate service duration based on type"""
        if not service_type:
            return None

        service_lower = service_type.lower()

        # Duration estimates in PostgreSQL INTERVAL format
        durations = {
            'fire_alarm': '2 hours',
            'emergency_lighting': '2 hours',
            'lifts': '4 hours',
            'cleaning': '3 hours',
            'pest_control': '1 hour',
            'window_cleaning': '4 hours',
            'cctv': '2 hours',
            'door_entry': '1 hour',
            'security': '8 hours'
        }

        for service_key, duration in durations.items():
            if service_key in service_lower:
                return duration

        return '2 hours'  # Default

    def detect_recurring_dates(self, text: str, contract_data: Dict) -> List[Dict]:
        """
        Detect recurring date patterns in document text

        Args:
            text: Document text to analyze
            contract_data: Contract context

        Returns:
            List of detected schedule entries
        """
        schedules = []

        # Look for schedule tables or lists
        # Pattern: dates in sequence with regular intervals
        date_pattern = r'\b(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\b'
        dates = re.findall(date_pattern, text)

        if len(dates) >= 3:
            # Analyze intervals between dates
            parsed_dates = []
            for date_str in dates:
                try:
                    parsed = self._parse_date(date_str)
                    if parsed:
                        parsed_dates.append(parsed)
                except:
                    continue

            if len(parsed_dates) >= 3:
                # Calculate intervals
                intervals = []
                for i in range(len(parsed_dates) - 1):
                    delta = parsed_dates[i + 1] - parsed_dates[i]
                    intervals.append(delta.days)

                # Check if intervals are consistent (±7 days tolerance)
                if intervals:
                    avg_interval = sum(intervals) / len(intervals)
                    consistent = all(abs(interval - avg_interval) <= 7 for interval in intervals)

                    if consistent:
                        # Determine frequency from average interval
                        frequency_info = self._interval_to_frequency(avg_interval)
                        if frequency_info:
                            schedule = self._create_schedule_entry(contract_data, frequency_info)
                            if schedule:
                                schedules.append(schedule)

        return schedules

    def _parse_date(self, date_str: str) -> Optional[datetime]:
        """Parse date string to datetime object"""
        for sep in ['/', '-']:
            pattern = f'(\\d{{1,2}}){sep}(\\d{{1,2}}){sep}(\\d{{2,4}})'
            match = re.match(pattern, date_str)
            if match:
                day, month, year = match.groups()
                if len(year) == 2:
                    year = f"20{year}"
                try:
                    return datetime(int(year), int(month), int(day))
                except ValueError:
                    continue
        return None

    def _interval_to_frequency(self, days: float) -> Optional[Dict]:
        """Convert days interval to frequency info"""

        # Round to nearest standard interval
        if 25 <= days <= 35:
            return self.FREQUENCY_PATTERNS['monthly']
        elif 85 <= days <= 95:
            return self.FREQUENCY_PATTERNS['quarterly']
        elif 175 <= days <= 185:
            return self.FREQUENCY_PATTERNS['semi-annual']
        elif 355 <= days <= 375:
            return self.FREQUENCY_PATTERNS['annual']
        elif 12 <= days <= 16:
            return self.FREQUENCY_PATTERNS['fortnightly']
        elif 5 <= days <= 9:
            return self.FREQUENCY_PATTERNS['weekly']

        return None
