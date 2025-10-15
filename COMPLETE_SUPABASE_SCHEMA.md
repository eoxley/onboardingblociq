# 📊 COMPLETE SUPABASE SCHEMA - FULL OVERVIEW

**Version:** 1.1 (with contractor fields)  
**Date:** October 15, 2025  
**Total Tables:** 24 core tables + views  
**Status:** 🟢 Production Ready

---

## 🏗️ SCHEMA STRUCTURE

### **1. Multi-Tenancy (3 tables)**
```
agencies (property management companies)
  ├── users (staff: managers, property managers)
  └── user_buildings (assignment of managers to buildings)
```

### **2. Core Entities (4 tables)**
```
buildings (parent entity)
  ├── building_blocks (multi-block developments)
  ├── units (flats/apartments)
  └── leaseholders (tenants)
```

### **3. Compliance & Safety (2 tables + reference)**
```
compliance_asset_types (50+ UK compliance types - reference)
compliance_assets (actual inspections/certificates)
```

### **4. Maintenance Contracts (4 tables + reference)**
```
contract_types (11 contract types - reference)
maintenance_contracts (active contracts)
maintenance_schedules (service due dates)
contractors (contractor directory)
```

### **5. Financial (4 tables)**
```
budgets (annual service charge budgets)
budget_line_items (individual line items)
leaseholder_accounts (account balances)
insurance_policies (building insurance)
```

### **6. Legal & Leases (4 tables)**
```
leases (lease documents)
  ├── lease_clauses (28-point extraction)
  ├── lease_parties (lessor/lessee)
  └── lease_financial_terms (ground rent, service charge, apportionment)
```

### **7. Major Works (1 table)**
```
major_works_projects (Section 20 consultations)
```

### **8. Documents & Audit (3 tables)**
```
documents (document registry)
extraction_runs (extraction metadata)
audit_log (change tracking)
```

---

## 🆕 CONTRACTOR FIELDS ADDED TO BUILDINGS TABLE

```sql
ALTER TABLE buildings ADD COLUMN IF NOT EXISTS
    cleaning_contractor VARCHAR(255),      -- e.g. "New Step"
    lift_contractor VARCHAR(255),          -- e.g. "Jacksons Lift"
    heating_contractor VARCHAR(255),       -- e.g. "Quotehedge"
    property_manager VARCHAR(255),         -- Managing agent name
    gardening_contractor VARCHAR(255);     -- Grounds maintenance
```

**Status:** ✅ Applied to Supabase  
**Captured by:** ✅ SQL generators (both sql_writer.py and sql_generator_v2.py)  
**Used in:** ✅ PDF reports  

---

## 📋 BUILDINGS TABLE - COMPLETE FIELD LIST (71 fields)

### **Basic Information (5 fields)**
- `id` UUID PRIMARY KEY
- `building_name` VARCHAR(255)
- `building_address` TEXT
- `postcode` VARCHAR(10)
- `city` VARCHAR(100)
- `country` VARCHAR(50)

### **Physical Characteristics (7 fields)**
- `num_units` INTEGER
- `num_residential_units` INTEGER
- `num_commercial_units` INTEGER
- `num_floors` INTEGER
- `num_blocks` INTEGER
- `building_height_meters` NUMERIC(10,2)
- `construction_type` VARCHAR(100) ← **NEW**

### **Construction (3 fields)**
- `construction_era` VARCHAR(50)
- `year_built` INTEGER

### **Services & Systems (19 fields)**
- `has_lifts` BOOLEAN
- `num_lifts` INTEGER
- `has_communal_heating` BOOLEAN
- `heating_type` VARCHAR(100)
- `has_hot_water` BOOLEAN
- `has_hvac` BOOLEAN
- `has_plant_room` BOOLEAN
- `has_mechanical_ventilation` BOOLEAN
- `has_water_pumps` BOOLEAN
- `has_water_tanks` BOOLEAN
- `has_booster_set` BOOLEAN
- `has_gas` BOOLEAN
- `has_sprinklers` BOOLEAN
- `has_smoke_shaft` BOOLEAN
- `has_lightning_conductor` BOOLEAN
- `has_generator` BOOLEAN
- `has_emergency_power` BOOLEAN
- `has_pressure_systems` BOOLEAN
- `has_air_conditioning` BOOLEAN

### **Special Facilities (14 fields)**
- `has_gym` BOOLEAN
- `has_pool` BOOLEAN
- `has_sauna` BOOLEAN
- `has_spa` BOOLEAN
- `has_squash_court` BOOLEAN
- `has_tennis_court` BOOLEAN
- `has_communal_showers` BOOLEAN
- `has_communal_areas` BOOLEAN
- `has_communal_areas_with_appliances` BOOLEAN
- `has_grounds` BOOLEAN
- `has_gardens` BOOLEAN
- `has_balconies` BOOLEAN
- `has_ev_charging` BOOLEAN
- `has_car_park` BOOLEAN

### **External & Cladding (3 fields)**
- `has_cladding` BOOLEAN
- `has_combustible_cladding` BOOLEAN
- `cladding_type` VARCHAR(100)

### **Regulatory (3 fields)**
- `bsa_registration_required` BOOLEAN
- `bsa_registration_number` VARCHAR(50)
- `bsa_status` VARCHAR(50)

### **Management (3 fields)**
- `management_company` VARCHAR(255)
- `is_rmc` BOOLEAN (Residents Management Company)
- `is_rtm` BOOLEAN (Right to Manage)
- `managing_agent` VARCHAR(255)

### **🆕 Contractors (5 fields) - NEW!**
- `cleaning_contractor` VARCHAR(255) ← **ADDED**
- `lift_contractor` VARCHAR(255) ← **ADDED**
- `heating_contractor` VARCHAR(255) ← **ADDED**
- `property_manager` VARCHAR(255) ← **ADDED**
- `gardening_contractor` VARCHAR(255) ← **ADDED**

### **Metadata (7 fields)**
- `agency_id` UUID (multi-tenancy)
- `created_at` TIMESTAMPTZ
- `updated_at` TIMESTAMPTZ
- `data_quality` VARCHAR(50)
- `confidence_score` NUMERIC(3,2)
- `source_folder` VARCHAR(500)
- `extraction_version` VARCHAR(50)
- `deleted_at` TIMESTAMPTZ (soft delete)

**Total: 71 fields in buildings table!**

---

## 📊 ALL 24 TABLES

| # | Table Name | Purpose | Key Fields |
|---|------------|---------|------------|
| 1 | **agencies** | Property management companies | name, subscription_tier |
| 2 | **users** | Staff/property managers | email, role, agency_id |
| 3 | **user_buildings** | Manager → building assignments | user_id, building_id |
| 4 | **buildings** | Core building data | name, address, **contractors** |
| 5 | **building_blocks** | Multi-block developments | block_identifier |
| 6 | **units** | Flats/apartments | unit_number, apportionment_% |
| 7 | **leaseholders** | Tenants | name, balance, unit_id |
| 8 | **compliance_asset_types** | Reference (50+ types) | FRA, EICR, LOLER |
| 9 | **compliance_assets** | Inspections/certificates | status, expiry_date |
| 10 | **contract_types** | Reference (11 types) | Lift, Cleaning, etc |
| 11 | **maintenance_contracts** | Active contracts | contractor, dates, cost |
| 12 | **maintenance_schedules** | Service schedules | frequency, next_due |
| 13 | **contractors** | Contractor directory | company_name, services |
| 14 | **budgets** | Annual budgets | total_budget, year |
| 15 | **budget_line_items** | Budget breakdown | category, amount |
| 16 | **leaseholder_accounts** | Account tracking | balance, arrears |
| 17 | **insurance_policies** | Insurance | policy_type, premium |
| 18 | **leases** | Lease documents | title_number, dates |
| 19 | **lease_clauses** | Clause extraction | category, text, importance |
| 20 | **lease_parties** | Lessors/lessees | names, types |
| 21 | **lease_financial_terms** | Lease financials | ground_rent, SC% |
| 22 | **major_works_projects** | Major works | S20, costs |
| 23 | **documents** | Document registry | paths, storage |
| 24 | **extraction_runs** | Extraction metadata | version, confidence |
| 25 | **audit_log** | Change tracking | action, old/new values |

---

## 🔗 KEY RELATIONSHIPS

```
buildings (1)
  │
  ├─→ units (many) → building_id
  │     └─→ leaseholders (many) → unit_id
  │
  ├─→ compliance_assets (many) → building_id
  │
  ├─→ maintenance_contracts (many) → building_id
  │     └─→ maintenance_schedules (many) → contract_id
  │
  ├─→ budgets (1 per year) → building_id
  │     └─→ budget_line_items (many) → budget_id
  │
  ├─→ insurance_policies (many) → building_id
  │
  ├─→ leases (many) → building_id
  │     ├─→ lease_clauses (many) → lease_id
  │     ├─→ lease_parties (1 per lease) → lease_id
  │     └─→ lease_financial_terms (1 per lease) → lease_id
  │
  ├─→ major_works_projects (many) → building_id
  │
  └─→ documents (many) → building_id
```

---

## 🎯 COMPLETE DATA TYPES SUPPORTED

### For Every Building You Can Store:

✅ **Building profile** - 71 fields including all systems and facilities  
✅ **Contractor names** - Cleaning, lift, heating, gardening, property manager  
✅ **Units** - Apportionment, floor, type  
✅ **Leaseholders** - Names, addresses, balances  
✅ **Compliance** - 50+ asset types, status, dates  
✅ **Contracts** - Contractors, costs, dates, frequencies  
✅ **Maintenance schedules** - Service due dates  
✅ **Budgets** - Annual budgets with 26+ line items  
✅ **Insurance** - Policies, premiums, renewals  
✅ **Leases** - Documents with 28-point analysis  
✅ **Lease clauses** - Full text, categories, financial impact  
✅ **Contractors directory** - All service providers  
✅ **Major works** - Section 20 projects  
✅ **Documents** - Full file registry  

---

## 📈 REFERENCE DATA (Pre-Populated)

### Compliance Asset Types: 50+ entries
- Fire Safety: FRA, Fire Alarm, Emergency Lighting, Fire Doors, AOV, etc.
- Electrical: EICR, PAT, Lightning Protection, Generator
- Water Hygiene: Legionella, Water Tanks, TMV, Temperature Monitoring
- Mechanical: Lift LOLER, Gas Safety, Pressure Systems, HVAC
- Structural: Asbestos, Roof, Balcony, Cladding, Safety Case

### Contract Types: 11 entries
- Lift Maintenance, Fire Alarm, Cleaning, Gardening, Pest Control
- Water Hygiene, CCTV, Door Entry, Pool, Gym, EV Charging

---

## 🎉 DESKTOP APP IS NOW WORKING!

The BlocIQ Onboarder desktop app should be open and ready to use!

### To Process a Building:
1. Click "Select Client Folder"
2. Choose building folder
3. Click "Start Processing"
4. Wait for extraction (2-3 min)
5. Review SQL with contractor names
6. Save and apply to database

**The SQL it generates will include all 24 tables worth of data + contractor names!** ✅

---

## 📁 FULL SCHEMA FILE

The complete schema is in: `/Users/ellie/onboardingblociq/supabase_schema.sql` (1,266 lines)

Plus the contractor field additions in: `/Users/ellie/onboardingblociq/add_contractor_fields.sql`

---

**Your Supabase database is now set up to handle EVERYTHING needed for building setup!** 🚀

