#!/usr/bin/env python3
"""
Test script to generate SQL using the updated sql_writer.py
Uses sample data similar to your working SQL
"""

import sys
import uuid
from datetime import datetime
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

from sql_writer import SQLWriter

def generate_test_sql():
    """Generate test SQL migration with sample data"""

    # Initialize SQL writer
    writer = SQLWriter()

    # Sample building ID
    building_id = 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89'

    # Create mapped data structure
    mapped_data = {
        'building': {
            'id': building_id,
            'name': 'Connaught Square',
            'address': 'CONNAUGHT SQUARE',
        },

        'schedules': [{
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'name': 'Main Schedule',
            'description': 'Auto-detected schedule from onboarding'
        }],

        'units': [
            {'id': str(uuid.uuid4()), 'building_id': building_id, 'unit_number': 'Flat 1'},
            {'id': str(uuid.uuid4()), 'building_id': building_id, 'unit_number': 'Flat 2'},
            {'id': str(uuid.uuid4()), 'building_id': building_id, 'unit_number': 'Flat 3'},
        ],

        'leaseholders': [
            {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'unit_id': None,
                'unit_number': 'Flat 1',
                'name': 'Marmotte Holdings Limited'
            },
            {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'unit_id': None,
                'unit_number': 'Flat 2',
                'name': 'Ms V Rebulla'
            },
        ],

        'contractors': [
            {
                'id': '345f9497-5fd6-4cf6-a414-7244bb666112',
                'name': 'ISS',
                'phone': '083603538855',
                'address': 'London, We\'re available on Live Chat here., W1S 1RS'
            },
            {
                'id': '79797fdd-d52b-4ec1-92ac-61f37eb04f39',
                'name': 'Quotehedge',
                'email': 'info@quotehedge-heating.co.uk',
                'phone': '07801 799118',
                'address': '182 Revelstoke Road, Wandsworth, London, SW18 5NW'
            },
            {
                'id': 'cb72e610-a228-4827-8c91-e6897bb0cb29',
                'name': 'WHM',
                'email': 'enquiries@whmltd.org',
                'address': 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT'
            },
        ],

        'contractor_contracts': [
            # ISS - no service (should use 'unspecified')
            {
                'id': '05954c7c-b27d-40cf-99b6-1ec1730a7252',
                'building_id': building_id,
                'contractor_name': 'ISS',
                'service_category': None,  # Will default to 'unspecified'
                'payment_frequency': None,
                'contract_status': 'active'
            },
            # ISS - lifts monthly
            {
                'id': 'd4a4523c-9254-424f-8614-89eb55632496',
                'building_id': building_id,
                'contractor_name': 'ISS',
                'service_category': 'lifts',
                'payment_frequency': 'monthly',
                'contract_status': 'active'
            },
            # ISS - security quarterly
            {
                'id': '596fb01e-6dab-4522-acf6-df9f93eddb98',
                'building_id': building_id,
                'contractor_name': 'ISS',
                'service_category': 'security',
                'payment_frequency': 'quarterly',
                'contract_status': 'active'
            },
            # Quotehedge - no service specified
            {
                'id': 'd2a40592-3c0c-4bf7-ae66-16b4a0634fcc',
                'building_id': building_id,
                'contractor_name': 'Quotehedge',
                'service_category': None,
                'contract_status': 'active'
            },
            # WHM - monthly (no service)
            {
                'id': '792e267f-0838-4495-b327-185f7f2d2805',
                'building_id': building_id,
                'contractor_name': 'WHM',
                'payment_frequency': 'monthly',
                'contract_status': 'active'
            },
        ],

        'building_contractor_links': [
            {
                'id': '8d7a347c-801d-4efa-8648-f13e0fbb3643',
                'building_id': building_id,
                'company_name': 'ISS',
                'contractor_type': 'service_provider'
            },
            {
                'id': '7dd04a6c-7971-4182-abf5-30b19a5fa97c',
                'building_id': building_id,
                'company_name': 'Quotehedge',
                'email': 'info@quotehedge-heating.co.uk',
                'phone': '07801 799118',
                'contractor_type': 'service_provider'
            },
        ],

        'budgets': [
            {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'period': '2025',
                'year_start': '2025-01-01',
                'year_end': '2025-12-31',
                'total_amount': 50000.00
            }
        ]
    }

    # Generate SQL
    sql = writer.generate_migration(mapped_data)

    return sql

if __name__ == '__main__':
    print("Generating test SQL migration...")
    sql = generate_test_sql()

    # Write to file
    output_file = Path('output/test_migration_patched.sql')
    output_file.parent.mkdir(exist_ok=True)
    output_file.write_text(sql)

    print(f"\n✅ Generated SQL: {output_file}")
    print(f"📄 Total lines: {len(sql.splitlines())}")
    print(f"\n--- Preview (first 100 lines) ---")
    print('\n'.join(sql.splitlines()[:100]))
