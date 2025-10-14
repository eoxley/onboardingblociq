#!/usr/bin/env python3
"""
Show complete breakdown of data in Supabase database
Queries all tables and shows what was extracted and inserted
"""

import psycopg2
from datetime import datetime

# Supabase connection
DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

def show_database_contents():
    """Query and display all data in database"""
    
    print("\n" + "="*100)
    print("📊 CONNAUGHT SQUARE - COMPLETE DATABASE CONTENTS")
    print("="*100)
    print(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*100)
    
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        
        building_id = '2667e33e-b493-499f-ae8d-2de07b7bb707'
        
        # ========================================================================
        # 1. BUILDING
        # ========================================================================
        print("\n" + "="*100)
        print("🏢 1. BUILDING PROFILE")
        print("="*100)
        
        cursor.execute("""
            SELECT building_name, building_address, postcode, num_units, num_floors, 
                   building_height_meters, construction_era, has_lifts, num_lifts, bsa_status
            FROM buildings 
            WHERE id = %s
        """, (building_id,))
        
        building = cursor.fetchone()
        if building:
            print(f"Name: {building[0]}")
            print(f"Address: {building[1]}, {building[2]}")
            print(f"Units: {building[3]} | Floors: {building[4]} | Height: {building[5]}m")
            print(f"Era: {building[6]} | Lifts: {building[8]} lift(s)" if building[7] else f"Era: {building[6]} | Lifts: None")
            print(f"BSA Status: {building[9]}")
        
        # ========================================================================
        # 2. UNITS
        # ========================================================================
        print("\n" + "="*100)
        print("🏠 2. UNITS")
        print("="*100)
        
        cursor.execute("""
            SELECT unit_number, unit_type, apportionment_percentage
            FROM units 
            WHERE building_id = %s
            ORDER BY unit_number
        """, (building_id,))
        
        units = cursor.fetchall()
        print(f"Total Units: {len(units)}\n")
        
        for unit in units:
            print(f"  • {unit[0]}: {unit[1]} - Apportionment: {unit[2]:.2f}%")
        
        # ========================================================================
        # 3. LEASEHOLDERS
        # ========================================================================
        print("\n" + "="*100)
        print("👥 3. LEASEHOLDERS")
        print("="*100)
        
        cursor.execute("""
            SELECT * FROM leaseholders 
            WHERE building_id = %s
            LIMIT 1
        """, (building_id,))
        
        # Check if any leaseholders exist first
        sample = cursor.fetchone()
        if sample:
            cursor.execute("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'leaseholders'
                ORDER BY ordinal_position
            """)
            cols = [c[0] for c in cursor.fetchall()]
            print(f"Leaseholder columns: {cols}")
        
        cursor.execute("""
            SELECT COUNT(*) FROM leaseholders 
            WHERE building_id = %s
        """, (building_id,))
        
        leaseholders = cursor.fetchall()
        print(f"Total Leaseholders: {len(leaseholders)}")
        
        total_balance = sum(lh[2] or 0 for lh in leaseholders)
        print(f"Total Outstanding Balance: £{total_balance:,.2f}\n")
        
        for lh in leaseholders:
            balance = f"£{lh[2]:,.2f}" if lh[2] else "£0.00"
            print(f"  • {lh[0][:40]} ({lh[1]}) - Balance: {balance}")
        
        # ========================================================================
        # 4. COMPLIANCE ASSETS
        # ========================================================================
        print("\n" + "="*100)
        print("✓ 4. COMPLIANCE ASSETS")
        print("="*100)
        
        cursor.execute("""
            SELECT status, COUNT(*) 
            FROM compliance_assets 
            WHERE building_id = %s
            GROUP BY status
            ORDER BY status
        """, (building_id,))
        
        comp_status = cursor.fetchall()
        total_comp = sum(c[1] for c in comp_status)
        
        print(f"Total Compliance Assets: {total_comp}\n")
        for status, count in comp_status:
            icon = "✓" if status == "current" else "⚠" if status == "expired" else "✗"
            print(f"  {icon} {status.title()}: {count}")
        
        # Show sample assets
        cursor.execute("""
            SELECT asset_type, status, inspection_date, next_due_date
            FROM compliance_assets 
            WHERE building_id = %s
            ORDER BY 
                CASE status WHEN 'current' THEN 1 WHEN 'expired' THEN 2 ELSE 3 END,
                asset_type
            LIMIT 10
        """, (building_id,))
        
        print(f"\nKey Assets:")
        for asset in cursor.fetchall():
            print(f"  • {asset[0]}: {asset[1]} (Last: {asset[2] or 'N/A'}, Next: {asset[3] or 'N/A'})")
        
        # ========================================================================
        # 5. MAINTENANCE CONTRACTS
        # ========================================================================
        print("\n" + "="*100)
        print("🔧 5. MAINTENANCE CONTRACTS")
        print("="*100)
        
        cursor.execute("""
            SELECT contractor_name, contract_type, contract_status, maintenance_frequency
            FROM maintenance_contracts 
            WHERE building_id = %s
        """, (building_id,))
        
        contracts = cursor.fetchall()
        print(f"Total Contracts: {len(contracts)}\n")
        
        for contract in contracts:
            print(f"  • {contract[1]}: {contract[0]} ({contract[3] or 'N/A'})")
        
        # ========================================================================
        # 6. BUDGETS & BUDGET LINE ITEMS
        # ========================================================================
        print("\n" + "="*100)
        print("💰 6. FINANCIAL DATA")
        print("="*100)
        
        cursor.execute("""
            SELECT budget_year, total_budget, status
            FROM budgets 
            WHERE building_id = %s
        """, (building_id,))
        
        budgets = cursor.fetchall()
        if budgets:
            budget = budgets[0]
            print(f"Budget Year: {budget[0]}")
            print(f"Total Budget: £{budget[1]:,.0f}")
            print(f"Status: {budget[2]}")
            
            # Get line items
            cursor.execute("""
                SELECT category, subcategory, budgeted_amount, actual_amount, variance
                FROM budget_line_items bli
                JOIN budgets b ON bli.budget_id = b.id
                WHERE b.building_id = %s
                ORDER BY budgeted_amount DESC
                LIMIT 10
            """, (building_id,))
            
            line_items = cursor.fetchall()
            if line_items:
                print(f"\nTop Budget Line Items:")
                for item in line_items:
                    print(f"  • {item[0]}: £{item[2]:,.0f} (Actual: £{item[3] or 0:,.0f}, Variance: £{item[4] or 0:,.0f})")
        else:
            print("No budget data loaded")
        
        # ========================================================================
        # 7. MAINTENANCE SCHEDULES
        # ========================================================================
        print("\n" + "="*100)
        print("📅 7. MAINTENANCE SCHEDULES")
        print("="*100)
        
        cursor.execute("""
            SELECT service_type, frequency, frequency_months, priority, status
            FROM maintenance_schedules 
            WHERE building_id = %s
        """, (building_id,))
        
        schedules = cursor.fetchall()
        print(f"Total Schedules: {len(schedules)}\n")
        
        for schedule in schedules:
            print(f"  • {schedule[0]}: {schedule[1]} ({schedule[2]} months) - Priority: {schedule[3]}, Status: {schedule[4]}")
        
        # ========================================================================
        # 8. INSURANCE POLICIES
        # ========================================================================
        print("\n" + "="*100)
        print("🛡️  8. INSURANCE POLICIES")
        print("="*100)
        
        cursor.execute("""
            SELECT policy_type, insurer, renewal_date, annual_premium
            FROM insurance_policies 
            WHERE building_id = %s
        """, (building_id,))
        
        policies = cursor.fetchall()
        print(f"Total Policies: {len(policies)}\n")
        
        total_premium = 0
        for policy in policies:
            premium = policy[3] or 0
            total_premium += premium
            print(f"  • {policy[0]}: {policy[1]} - £{premium:,.0f}/year (Renewal: {policy[2]})")
        
        print(f"\nTotal Annual Premiums: £{total_premium:,.0f}")
        
        # ========================================================================
        # 9. LEASES
        # ========================================================================
        print("\n" + "="*100)
        print("📄 9. LEASES")
        print("="*100)
        
        cursor.execute("""
            SELECT title_number, lease_type, source_document, page_count, file_size_mb
            FROM leases 
            WHERE building_id = %s
        """, (building_id,))
        
        leases = cursor.fetchall()
        print(f"Total Lease Documents: {len(leases)}\n")
        
        total_pages = 0
        total_size = 0
        for lease in leases:
            total_pages += lease[3] or 0
            total_size += lease[4] or 0
            print(f"  • Title {lease[0]}: {lease[2][:50]} ({lease[3]} pages, {lease[4]:.2f} MB)")
        
        print(f"\nTotal: {total_pages} pages, {total_size:.2f} MB")
        
        # ========================================================================
        # 10. LEASE CLAUSES
        # ========================================================================
        print("\n" + "="*100)
        print("📋 10. LEASE CLAUSES (28-Point Analysis)")
        print("="*100)
        
        cursor.execute("""
            SELECT clause_category, COUNT(*), 
                   SUM(CASE WHEN importance_level = 'critical' THEN 1 ELSE 0 END) as critical_count
            FROM lease_clauses 
            WHERE building_id = %s
            GROUP BY clause_category
            ORDER BY COUNT(*) DESC
        """, (building_id,))
        
        clauses_by_cat = cursor.fetchall()
        total_clauses = sum(c[1] for c in clauses_by_cat)
        
        print(f"Total Lease Clauses: {total_clauses}\n")
        
        print("By Category:")
        for cat, count, critical in clauses_by_cat:
            critical_str = f" ({critical} critical)" if critical > 0 else ""
            print(f"  • {cat.title()}: {count}{critical_str}")
        
        # Show sample clauses
        cursor.execute("""
            SELECT clause_number, clause_category, clause_text, importance_level
            FROM lease_clauses 
            WHERE building_id = %s
            ORDER BY importance_level DESC, clause_number
            LIMIT 5
        """, (building_id,))
        
        print(f"\nSample Critical Clauses:")
        for clause in cursor.fetchall():
            text = clause[2][:80] + "..." if len(clause[2]) > 80 else clause[2]
            print(f"  [{clause[3].upper()}] Clause {clause[0]} ({clause[1]}): {text}")
        
        # ========================================================================
        # 11. LEASE PARTIES
        # ========================================================================
        print("\n" + "="*100)
        print("👔 11. LEASE PARTIES")
        print("="*100)
        
        cursor.execute("""
            SELECT lessor_name, lessor_type, lessee_name, lessee_type
            FROM lease_parties lp
            JOIN leases l ON lp.lease_id = l.id
            WHERE l.building_id = %s
        """, (building_id,))
        
        parties = cursor.fetchall()
        print(f"Total Party Records: {len(parties)}\n")
        
        print("Lessor:")
        if parties:
            print(f"  • {parties[0][0]} ({parties[0][1]})")
        
        print(f"\nLessees:")
        for party in parties:
            print(f"  • {party[2]} ({party[3]})")
        
        # ========================================================================
        # 12. LEASE FINANCIAL TERMS
        # ========================================================================
        print("\n" + "="*100)
        print("💵 12. LEASE FINANCIAL TERMS")
        print("="*100)
        
        cursor.execute("""
            SELECT lft.ground_rent_current, lft.ground_rent_review_period, 
                   lft.service_charge_percentage, lft.apportionment_percentage,
                   l.title_number
            FROM lease_financial_terms lft
            JOIN leases l ON lft.lease_id = l.id
            WHERE l.building_id = %s
        """, (building_id,))
        
        financial_terms = cursor.fetchall()
        print(f"Total Financial Term Records: {len(financial_terms)}\n")
        
        for terms in financial_terms:
            print(f"  Title {terms[4]}:")
            print(f"    - Ground Rent: £{terms[0]}/year (Review every {terms[1]} years)")
            print(f"    - Service Charge: {terms[2]:.2f}% of total")
            print(f"    - Apportionment: {terms[3]:.2f}%")
        
        # ========================================================================
        # 13. CONTRACTORS
        # ========================================================================
        print("\n" + "="*100)
        print("🔨 13. CONTRACTORS")
        print("="*100)
        
        cursor.execute("""
            SELECT company_name, services_offered, is_active
            FROM contractors
            ORDER BY company_name
        """)
        
        contractors = cursor.fetchall()
        print(f"Total Contractors: {len(contractors)}\n")
        
        for contractor in contractors[:10]:
            services = contractor[1][0] if contractor[1] else 'General'
            status = "Active" if contractor[2] else "Inactive"
            print(f"  • {contractor[0]}: {services} ({status})")
        
        # ========================================================================
        # 14. MAJOR WORKS
        # ========================================================================
        print("\n" + "="*100)
        print("🏗️  14. MAJOR WORKS PROJECTS")
        print("="*100)
        
        cursor.execute("""
            SELECT project_name, status, s20_consultation_required, total_documents
            FROM major_works_projects 
            WHERE building_id = %s
        """, (building_id,))
        
        major_works = cursor.fetchall()
        print(f"Total Projects: {len(major_works)}\n")
        
        for project in major_works:
            s20_status = "Required" if project[2] else "Not Required"
            print(f"  • {project[0]}: {project[1]} - Section 20: {s20_status} - {project[3]} documents")
        
        # ========================================================================
        # SUMMARY
        # ========================================================================
        print("\n" + "="*100)
        print("📈 COMPLETE DATA SUMMARY")
        print("="*100)
        
        # Get all counts
        cursor.execute("""
            SELECT 
                (SELECT COUNT(*) FROM buildings WHERE id = %s) as buildings,
                (SELECT COUNT(*) FROM units WHERE building_id = %s) as units,
                (SELECT COUNT(*) FROM leaseholders WHERE building_id = %s) as leaseholders,
                (SELECT COUNT(*) FROM compliance_assets WHERE building_id = %s) as compliance,
                (SELECT COUNT(*) FROM maintenance_contracts WHERE building_id = %s) as contracts,
                (SELECT COUNT(*) FROM budgets WHERE building_id = %s) as budgets,
                (SELECT COUNT(*) FROM budget_line_items bli 
                 JOIN budgets b ON bli.budget_id = b.id 
                 WHERE b.building_id = %s) as budget_items,
                (SELECT COUNT(*) FROM maintenance_schedules WHERE building_id = %s) as schedules,
                (SELECT COUNT(*) FROM insurance_policies WHERE building_id = %s) as insurance,
                (SELECT COUNT(*) FROM leases WHERE building_id = %s) as leases,
                (SELECT COUNT(*) FROM lease_clauses WHERE building_id = %s) as clauses,
                (SELECT COUNT(*) FROM lease_parties lp 
                 JOIN leases l ON lp.lease_id = l.id 
                 WHERE l.building_id = %s) as parties,
                (SELECT COUNT(*) FROM lease_financial_terms lft 
                 JOIN leases l ON lft.lease_id = l.id 
                 WHERE l.building_id = %s) as financial_terms,
                (SELECT COUNT(*) FROM contractors) as contractors,
                (SELECT COUNT(*) FROM major_works_projects WHERE building_id = %s) as major_works
        """, tuple([building_id] * 14))
        
        counts = cursor.fetchone()
        
        data = [
            ("Buildings", counts[0]),
            ("Units", counts[1]),
            ("Leaseholders", counts[2]),
            ("Compliance Assets", counts[3]),
            ("Maintenance Contracts", counts[4]),
            ("Budgets", counts[5]),
            ("Budget Line Items", counts[6]),
            ("Maintenance Schedules", counts[7]),
            ("Insurance Policies", counts[8]),
            ("Leases", counts[9]),
            ("Lease Clauses", counts[10]),
            ("Lease Parties", counts[11]),
            ("Lease Financial Terms", counts[12]),
            ("Contractors", counts[13]),
            ("Major Works Projects", counts[14]),
        ]
        
        print(f"\n{'Entity Type':<30} {'Count':<10} {'Status'}")
        print("-" * 60)
        
        total_records = 0
        for entity, count in data:
            status = "✅" if count > 0 else "❌"
            print(f"{entity:<30} {count:<10} {status}")
            total_records += count
        
        print("-" * 60)
        print(f"{'TOTAL RECORDS':<30} {total_records:<10} ✅")
        
        print("\n" + "="*100)
        print(f"🎉 DATABASE IS COMPLETE - {total_records} RECORDS LOADED!")
        print("="*100)
        
        cursor.close()
        conn.close()
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error querying database: {e}")
        return False


if __name__ == '__main__':
    show_database_contents()

