#!/usr/bin/env python3
"""
Load building data from building.json into Supabase
"""
import os
import json
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_SERVICE_ROLE_KEY')
AGENCY_ID = '00000000-0000-0000-0000-000000000001'  # BlocIQ agency

def load_building_data():
    """Load building data from JSON and insert into Supabase"""

    # Load building.json
    json_path = '/Users/ellie/Desktop/BlocIQ_Output/building.json'

    print(f"📖 Reading {json_path}...")
    with open(json_path, 'r') as f:
        data = json.load(f)

    print(f"✅ Loaded building data")
    print(f"   Building: {data.get('name')}")
    print(f"   Units: {len(data.get('units', []))}")
    print(f"   Leases: {len(data.get('leases', []))}")
    print(f"   Leaseholders: {len(data.get('leaseholders', []))}")

    # Connect to Supabase
    print(f"\n🔌 Connecting to Supabase...")
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"✅ Connected!")

    # Insert building
    print(f"\n🏢 Inserting building...")
    building_data = {
        'id': data['id'],
        'name': data['name'],
        'address': data.get('address'),
        'unit_count': data.get('unit_count'),
        'agency_id': AGENCY_ID,
        'building_type': data.get('building_type'),
        'structure_type': data.get('structure_type'),
        'client_type': data.get('client_type'),
        'client_name': data.get('client_name'),
        'client_contact': data.get('client_contact'),
        'client_email': data.get('client_email'),
        'operational_notes': data.get('operational_notes'),
    }

    # Remove None values
    building_data = {k: v for k, v in building_data.items() if v is not None}

    result = supabase.table('buildings').insert(building_data).execute()
    print(f"✅ Building inserted: {data['name']}")

    building_id = data['id']

    # Insert units
    if 'units' in data and data['units']:
        print(f"\n🏠 Inserting {len(data['units'])} units...")
        for unit in data['units']:
            unit_data = {
                **unit,
                'building_id': building_id
            }
            supabase.table('units').insert(unit_data).execute()
        print(f"✅ Inserted {len(data['units'])} units")

    # Insert leaseholders
    if 'leaseholders' in data and data['leaseholders']:
        print(f"\n👥 Inserting {len(data['leaseholders'])} leaseholders...")
        for leaseholder in data['leaseholders']:
            leaseholder_data = {
                **leaseholder,
                'building_id': building_id
            }
            supabase.table('leaseholders').insert(leaseholder_data).execute()
        print(f"✅ Inserted {len(data['leaseholders'])} leaseholders")

    # Insert leases
    if 'leases' in data and data['leases']:
        print(f"\n📜 Inserting {len(data['leases'])} leases...")
        for lease in data['leases']:
            lease_data = {
                **lease,
                'building_id': building_id
            }
            # Remove ocr_text as it's not in the leases table
            lease_data.pop('ocr_text', None)
            supabase.table('leases').insert(lease_data).execute()
        print(f"✅ Inserted {len(data['leases'])} leases")

    # Insert comprehensive lease data
    if 'document_texts' in data and data['document_texts']:
        print(f"\n📄 Inserting {len(data['document_texts'])} document_texts...")
        for doc in data['document_texts']:
            supabase.table('document_texts').insert(doc).execute()
        print(f"✅ Inserted {len(data['document_texts'])} document_texts")

    if 'lease_parties' in data and data['lease_parties']:
        print(f"\n👥 Inserting {len(data['lease_parties'])} lease_parties...")
        for party in data['lease_parties']:
            supabase.table('lease_parties').insert(party).execute()
        print(f"✅ Inserted {len(data['lease_parties'])} lease_parties")

    if 'lease_demise' in data and data['lease_demise']:
        print(f"\n🏘️  Inserting {len(data['lease_demise'])} lease_demise...")
        for demise in data['lease_demise']:
            supabase.table('lease_demise').insert(demise).execute()
        print(f"✅ Inserted {len(data['lease_demise'])} lease_demise")

    if 'lease_financial_terms' in data and data['lease_financial_terms']:
        print(f"\n💰 Inserting {len(data['lease_financial_terms'])} lease_financial_terms...")
        for term in data['lease_financial_terms']:
            supabase.table('lease_financial_terms').insert(term).execute()
        print(f"✅ Inserted {len(data['lease_financial_terms'])} lease_financial_terms")

    if 'lease_insurance_terms' in data and data['lease_insurance_terms']:
        print(f"\n🛡️  Inserting {len(data['lease_insurance_terms'])} lease_insurance_terms...")
        for term in data['lease_insurance_terms']:
            supabase.table('lease_insurance_terms').insert(term).execute()
        print(f"✅ Inserted {len(data['lease_insurance_terms'])} lease_insurance_terms")

    if 'lease_covenants' in data and data['lease_covenants']:
        print(f"\n📋 Inserting {len(data['lease_covenants'])} lease_covenants...")
        for covenant in data['lease_covenants']:
            supabase.table('lease_covenants').insert(covenant).execute()
        print(f"✅ Inserted {len(data['lease_covenants'])} lease_covenants")

    if 'lease_restrictions' in data and data['lease_restrictions']:
        print(f"\n🚫 Inserting {len(data['lease_restrictions'])} lease_restrictions...")
        for restriction in data['lease_restrictions']:
            supabase.table('lease_restrictions').insert(restriction).execute()
        print(f"✅ Inserted {len(data['lease_restrictions'])} lease_restrictions")

    if 'lease_rights' in data and data['lease_rights']:
        print(f"\n✅ Inserting {len(data['lease_rights'])} lease_rights...")
        for right in data['lease_rights']:
            supabase.table('lease_rights').insert(right).execute()
        print(f"✅ Inserted {len(data['lease_rights'])} lease_rights")

    if 'lease_enforcement' in data and data['lease_enforcement']:
        print(f"\n⚖️  Inserting {len(data['lease_enforcement'])} lease_enforcement...")
        for enforcement in data['lease_enforcement']:
            supabase.table('lease_enforcement').insert(enforcement).execute()
        print(f"✅ Inserted {len(data['lease_enforcement'])} lease_enforcement")

    if 'lease_clauses' in data and data['lease_clauses']:
        print(f"\n📜 Inserting {len(data['lease_clauses'])} lease_clauses...")
        for clause in data['lease_clauses']:
            supabase.table('lease_clauses').insert(clause).execute()
        print(f"✅ Inserted {len(data['lease_clauses'])} lease_clauses")

    print(f"\n✅ All data loaded successfully!")

if __name__ == '__main__':
    load_building_data()
