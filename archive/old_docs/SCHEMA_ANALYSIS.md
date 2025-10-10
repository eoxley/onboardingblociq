# Supabase Schema Analysis - Actual vs Generated

## 🔍 Schema Mismatches Found

### **budgets** table
**Our SQL** → **Your Actual Schema**
- ❌ `year_start` → ✅ `start_date`
- ❌ `year_end` → ✅ `end_date`
- ❌ `status` → Missing (we have it, you don't)
- ❌ `source_document` → Missing (we have it, you don't)
- ✅ `period` → ✅ `period` (NOT NULL - we fixed!)
- ✅ `total_amount` → ✅ `total_amount`
- Missing from our SQL: `document_id`, `demand_date_1`, `demand_date_2`, `year_end_date`, `budget_type`, `agency_id`, `schedule_id`, `year`, `name`, `confidence_score`

### **building_insurance** table
**Our SQL** → **Your Actual Schema**
- ❌ `provider` → ✅ `broker_name` or `insurer_name`
- ❌ `expiry_date` → ✅ `renewal_date`
- ❌ `source_document` → Missing (we have it, you don't)
- ✅ `insurance_type` → ✅ `insurance_type` (NOT NULL - we fixed!)
- ✅ `policy_number` → ✅ `policy_number`
- ✅ `premium_amount` → ✅ `premium_amount`
- Missing from our SQL: `coverage_amount`, `document_id`

### **building_staff** table
**Our SQL** → **Your Actual Schema**
- ❌ `name` → ✅ `employee_name`
- ❌ `role` → ✅ `position` (we removed role, but need position!)
- ❌ `contact_info` → Missing (we have it, you don't)
- ❌ `hours` → Missing (we have it, you don't)
- ❌ `company_name` → Missing (we have it, you don't)
- ❌ `contractor_id` → Missing (we have it, you don't)
- ❌ `source_document` → Missing (we have it, you don't)
- Missing from our SQL: `staff_type`, `description`, `start_date`, `end_date`, `document_id`

### **contractors** table
**Our SQL** → **Your Actual Schema**
- ❌ We insert `company_name` first, but schema expects `name` as NOT NULL!
- ✅ `email`, `phone`, `address` → ✅ Match
- Missing from our SQL: `mobile`, `city`, `postcode`, `trade`, `services` (ARRAY), `hourly_rate`, `payment_terms_days`, `insurance_provider`, `insurance_expiry`, `public_liability_amount`, `rating`, `total_jobs`, `is_active`, `updated_at`

### **compliance_assets** table
**Our SQL** → **Your Actual Schema**
- ✅ Most columns match
- ✅ `asset_name`, `asset_type` → NOT NULL (good!)
- We have: `inspection_date` but schema shows: `reinspection_date` and `inspection_contractor`

## 🎯 Action Plan

I'll now rebuild:
1. SQL generator with CORRECT column names
2. Extractors to populate correct fields
3. migration.sql with proper schema
4. PDF generator with BlocIQ branding

This will fix ALL schema issues at once!
