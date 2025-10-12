# Supabase Agency Onboarding Guide

## Complete Guide: Multi-Tenant Property Management with BlocIQ

This guide explains the complete flow for setting up an agency, creating users, and onboarding buildings with proper access control.

---

## Table of Contents
1. [Schema Overview](#schema-overview)
2. [Step-by-Step Agency Setup](#step-by-step-agency-setup)
3. [Building Onboarding Flow](#building-onboarding-flow)
4. [Access Control (RLS)](#access-control-rls)
5. [Common Scenarios](#common-scenarios)
6. [SQL Examples](#sql-examples)

---

## Schema Overview

### Core Hierarchy

```
agencies (Property Management Companies)
    ↓
users (Staff members - managers, property managers, etc.)
    ↓
buildings (Individual properties)
    ↓
units → leaseholders → apportionments
    ↓
budgets, leases, compliance_assets, contractors, etc.
```

### Key Tables & Relationships

#### 1. **agencies** (Top Level)
- Represents the property management company
- Contains: name, contact details, settings
- **One agency has many users**
- **One agency manages many buildings**

#### 2. **users** (Staff)
- Property managers, managers, admin staff
- Linked to: `agency_id`
- Has role: `manager`, `property_manager`, `admin`
- **Managers see ALL buildings in their agency**
- **Property managers see ONLY assigned buildings**

#### 3. **user_buildings** (Assignment Junction Table)
- Links users to specific buildings
- Only needed for `property_manager` role
- **Managers don't need entries here** (they see everything)

#### 4. **buildings** (Properties)
- Individual properties managed by the agency
- Linked to: `agency_id`
- Contains all property-specific data

---

## Step-by-Step Agency Setup

### Step 1: Create Agency

```sql
-- Create the property management company
INSERT INTO agencies (
    id,
    name,
    email,
    phone,
    address,
    website,
    logo_url,
    is_active
) VALUES (
    gen_random_uuid(),
    'MIH Property Management',
    'info@mihproperty.co.uk',
    '+44 20 1234 5678',
    '123 High Street, London, W1A 1AA',
    'https://mihproperty.co.uk',
    NULL,
    TRUE
)
RETURNING id, name;

-- Save the returned agency ID for next steps
-- Example: agency_id = '550e8400-e29b-41d4-a716-446655440000'
```

### Step 2: Create Manager User

**Managers can see ALL buildings in the agency - no assignment needed**

```sql
-- Create a manager who can see everything
INSERT INTO users (
    id,
    agency_id,
    email,
    full_name,
    role,
    is_active
) VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440000',  -- agency_id from Step 1
    'john.manager@mihproperty.co.uk',
    'John Manager',
    'manager',  -- Key: 'manager' role sees ALL buildings
    TRUE
)
RETURNING id, full_name, role;

-- No need to insert into user_buildings - managers see everything automatically!
```

### Step 3: Create Property Manager Users

**Property managers only see buildings explicitly assigned to them**

```sql
-- Create property manager 1
INSERT INTO users (
    id,
    agency_id,
    email,
    full_name,
    role,
    is_active
) VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440000',
    'sarah.pm@mihproperty.co.uk',
    'Sarah Property Manager',
    'property_manager',  -- Key: 'property_manager' sees only assigned buildings
    TRUE
)
RETURNING id, full_name, role;

-- Save the user ID for building assignment
-- Example: user_id = '123e4567-e89b-12d3-a456-426614174000'

-- Create property manager 2
INSERT INTO users (
    id,
    agency_id,
    email,
    full_name,
    role,
    is_active
) VALUES (
    gen_random_uuid(),
    '550e8400-e29b-41d4-a716-446655440000',
    'mike.pm@mihproperty.co.uk',
    'Mike Property Manager',
    'property_manager',
    TRUE
)
RETURNING id, full_name, role;

-- Example: user_id = '234e5678-e89b-12d3-a456-426614174001'
```

---

## Building Onboarding Flow

### Step 4: Run BlocIQ Onboarding

```bash
# Run the onboarding tool on a building folder
python3 onboarder.py '/path/to/48-49 Gloucester Square'

# Or use the app
open BlocIQOnboarder.app
# Drag and drop the building folder
```

**What happens:**
1. Documents are parsed and classified
2. Data is extracted: units, leaseholders, budgets, apportionments, etc.
3. A `migration.sql` file is generated
4. **Important**: The SQL includes a building record with a UUID

### Step 5: Update Building's Agency ID

**CRITICAL STEP**: The generated SQL doesn't know which agency owns the building. You must update it.

```sql
-- Find the building that was just inserted (check the migration.sql for the building UUID)
-- Or find by name
SELECT id, name, address
FROM buildings
WHERE name ILIKE '%Gloucester%';

-- Example result: building_id = '789e0123-e89b-12d3-a456-426614174002'

-- Update the building to belong to your agency
UPDATE buildings
SET agency_id = '550e8400-e29b-41d4-a716-446655440000'  -- Your agency ID
WHERE id = '789e0123-e89b-12d3-a456-426614174002';

-- Verify
SELECT
    b.name AS building_name,
    a.name AS agency_name
FROM buildings b
JOIN agencies a ON b.agency_id = a.id
WHERE b.id = '789e0123-e89b-12d3-a456-426614174002';
```

### Step 6: Assign Building to Property Manager

**Only needed for property_manager role users**

```sql
-- Assign 48-49 Gloucester Square to Sarah
INSERT INTO user_buildings (
    id,
    user_id,
    building_id
) VALUES (
    gen_random_uuid(),
    '123e4567-e89b-12d3-a456-426614174000',  -- Sarah's user_id
    '789e0123-e89b-12d3-a456-426614174002'   -- Building ID
);

-- Assign a different building to Mike
INSERT INTO user_buildings (
    id,
    user_id,
    building_id
) VALUES (
    gen_random_uuid(),
    '234e5678-e89b-12d3-a456-426614174001',  -- Mike's user_id
    '890e1234-e89b-12d3-a456-426614174003'   -- Different building ID
);
```

---

## Access Control (RLS)

### How Row-Level Security Works

Supabase uses PostgreSQL Row Level Security (RLS) policies to enforce access control.

#### For Managers (See Everything)

```sql
-- RLS Policy for managers
CREATE POLICY "Managers can see all agency buildings"
ON buildings
FOR SELECT
TO authenticated
USING (
    agency_id IN (
        SELECT agency_id
        FROM users
        WHERE id = auth.uid()
        AND role = 'manager'
    )
);
```

**Logic**: If the user's role is 'manager', they can see all buildings in their agency.

#### For Property Managers (See Only Assigned)

```sql
-- RLS Policy for property managers
CREATE POLICY "Property managers see assigned buildings"
ON buildings
FOR SELECT
TO authenticated
USING (
    id IN (
        SELECT building_id
        FROM user_buildings
        WHERE user_id = auth.uid()
    )
);
```

**Logic**: Property managers can only see buildings that have an entry in `user_buildings` linking them.

#### Combined Policy

```sql
-- Enable RLS on buildings table
ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;

-- Combined policy: Managers see all, PMs see assigned
CREATE POLICY "Building access control"
ON buildings
FOR SELECT
TO authenticated
USING (
    -- User is a manager in the same agency
    agency_id IN (
        SELECT agency_id
        FROM users
        WHERE id = auth.uid()
        AND role = 'manager'
    )
    OR
    -- User is a property manager assigned to this building
    id IN (
        SELECT building_id
        FROM user_buildings
        WHERE user_id = auth.uid()
    )
);
```

---

## Common Scenarios

### Scenario 1: Onboarding Multiple Buildings

```sql
-- 1. Run onboarding for Building A
python3 onboarder.py '/path/to/Building-A'

-- 2. Execute the generated migration.sql
-- 3. Update agency_id
UPDATE buildings
SET agency_id = 'YOUR_AGENCY_ID'
WHERE name = 'Building A';

-- 4. Assign to property manager
INSERT INTO user_buildings (id, user_id, building_id)
VALUES (gen_random_uuid(), 'SARAH_USER_ID', 'BUILDING_A_ID');

-- Repeat for Building B, C, etc.
```

### Scenario 2: Check What a User Can See

```sql
-- Check what buildings a specific user can access
WITH user_info AS (
    SELECT id, role, agency_id, full_name
    FROM users
    WHERE email = 'sarah.pm@mihproperty.co.uk'
)
SELECT
    b.id,
    b.name AS building_name,
    b.address,
    CASE
        WHEN ui.role = 'manager' THEN 'Full Agency Access'
        ELSE 'Assigned Building'
    END AS access_type
FROM buildings b
CROSS JOIN user_info ui
WHERE
    -- Manager sees all buildings in agency
    (ui.role = 'manager' AND b.agency_id = ui.agency_id)
    OR
    -- Property manager sees assigned buildings
    (ui.role = 'property_manager' AND b.id IN (
        SELECT building_id
        FROM user_buildings
        WHERE user_id = ui.id
    ));
```

### Scenario 3: Reassign Buildings

```sql
-- Remove Sarah from Building A
DELETE FROM user_buildings
WHERE user_id = 'SARAH_USER_ID'
AND building_id = 'BUILDING_A_ID';

-- Assign Building A to Mike instead
INSERT INTO user_buildings (id, user_id, building_id)
VALUES (gen_random_uuid(), 'MIKE_USER_ID', 'BUILDING_A_ID');
```

### Scenario 4: Promote Property Manager to Manager

```sql
-- Update Sarah's role to manager
UPDATE users
SET role = 'manager'
WHERE id = 'SARAH_USER_ID';

-- Remove all her building assignments (no longer needed)
DELETE FROM user_buildings
WHERE user_id = 'SARAH_USER_ID';

-- She now sees ALL buildings in the agency automatically
```

---

## SQL Examples

### Complete Setup Example

```sql
-- ============================================================
-- COMPLETE AGENCY SETUP SCRIPT
-- ============================================================

-- 1. CREATE AGENCY
INSERT INTO agencies (id, name, email, is_active)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'MIH Property', 'info@mih.com', TRUE);

-- 2. CREATE MANAGER (sees everything)
INSERT INTO users (id, agency_id, email, full_name, role, is_active)
VALUES (
    '111e1111-e11b-11d1-a111-111111111111',
    '550e8400-e29b-41d4-a716-446655440000',
    'manager@mih.com',
    'John Manager',
    'manager',
    TRUE
);

-- 3. CREATE PROPERTY MANAGERS (see only assigned)
INSERT INTO users (id, agency_id, email, full_name, role, is_active)
VALUES
    ('222e2222-e22b-22d2-a222-222222222222', '550e8400-e29b-41d4-a716-446655440000', 'sarah@mih.com', 'Sarah PM', 'property_manager', TRUE),
    ('333e3333-e33b-33d3-a333-333333333333', '550e8400-e29b-41d4-a716-446655440000', 'mike@mih.com', 'Mike PM', 'property_manager', TRUE);

-- 4. RUN ONBOARDING (generates migration.sql with building data)
-- Execute the migration.sql here...

-- 5. LINK BUILDINGS TO AGENCY
UPDATE buildings
SET agency_id = '550e8400-e29b-41d4-a716-446655440000'
WHERE name IN ('48-49 Gloucester Square', 'Another Building');

-- 6. ASSIGN BUILDINGS TO PROPERTY MANAGERS
-- Get building IDs
WITH building_ids AS (
    SELECT id, name FROM buildings WHERE agency_id = '550e8400-e29b-41d4-a716-446655440000'
)
-- Sarah gets first building
INSERT INTO user_buildings (id, user_id, building_id)
SELECT gen_random_uuid(), '222e2222-e22b-22d2-a222-222222222222', id
FROM building_ids WHERE name = '48-49 Gloucester Square';

-- Mike gets second building
INSERT INTO user_buildings (id, user_id, building_id)
SELECT gen_random_uuid(), '333e3333-e33b-33d3-a333-333333333333', id
FROM building_ids WHERE name = 'Another Building';
```

### Verification Queries

```sql
-- Check agency setup
SELECT
    a.name AS agency_name,
    COUNT(DISTINCT u.id) AS total_users,
    COUNT(DISTINCT b.id) AS total_buildings
FROM agencies a
LEFT JOIN users u ON a.id = u.agency_id
LEFT JOIN buildings b ON a.id = b.agency_id
WHERE a.id = '550e8400-e29b-41d4-a716-446655440000'
GROUP BY a.name;

-- Check user access
SELECT
    u.full_name,
    u.role,
    COUNT(DISTINCT b.id) AS accessible_buildings
FROM users u
LEFT JOIN user_buildings ub ON u.id = ub.user_id
LEFT JOIN buildings b ON
    (u.role = 'manager' AND b.agency_id = u.agency_id) OR
    (u.role = 'property_manager' AND b.id = ub.building_id)
WHERE u.agency_id = '550e8400-e29b-41d4-a716-446655440000'
GROUP BY u.full_name, u.role
ORDER BY u.role, u.full_name;

-- Check building assignments
SELECT
    b.name AS building_name,
    u.full_name AS assigned_to,
    u.role
FROM buildings b
LEFT JOIN user_buildings ub ON b.id = ub.building_id
LEFT JOIN users u ON ub.user_id = u.id
WHERE b.agency_id = '550e8400-e29b-41d4-a716-446655440000'
ORDER BY b.name;
```

---

## Best Practices

### 1. Always Set agency_id After Onboarding
```sql
-- Immediately after running migration.sql:
UPDATE buildings
SET agency_id = 'YOUR_AGENCY_ID'
WHERE agency_id IS NULL;
```

### 2. Use Descriptive User Emails
```sql
-- Good
'john.manager@mihproperty.co.uk'
'sarah.pm.central@mihproperty.co.uk'

-- Bad
'user1@gmail.com'
'temp@test.com'
```

### 3. Keep Managers Minimal
- Only give 'manager' role to senior staff
- Most staff should be 'property_manager' with specific assignments

### 4. Audit Access Regularly
```sql
-- Who can access each building?
SELECT
    b.name,
    STRING_AGG(u.full_name || ' (' || u.role || ')', ', ') AS access_list
FROM buildings b
JOIN agencies a ON b.agency_id = a.id
LEFT JOIN user_buildings ub ON b.id = ub.building_id
LEFT JOIN users u ON (ub.user_id = u.id) OR (u.agency_id = a.id AND u.role = 'manager')
GROUP BY b.name;
```

---

## Troubleshooting

### Issue: Property Manager Can't See Any Buildings

**Solution**: Check if they're assigned
```sql
SELECT * FROM user_buildings WHERE user_id = 'THEIR_USER_ID';
-- If empty, assign them to buildings
```

### Issue: Manager Can't See Buildings

**Solution**: Check agency_id matches
```sql
SELECT u.agency_id AS user_agency, b.agency_id AS building_agency
FROM users u, buildings b
WHERE u.id = 'MANAGER_USER_ID'
LIMIT 1;
-- agency_id must match!
```

### Issue: Building Has No Agency

**Solution**: Update it
```sql
UPDATE buildings
SET agency_id = 'CORRECT_AGENCY_ID'
WHERE id = 'BUILDING_ID';
```

---

## Summary Checklist

### Agency Setup
- [ ] Create agency record
- [ ] Create manager user(s) with role='manager'
- [ ] Create property manager users with role='property_manager'

### Per Building Onboarding
- [ ] Run BlocIQ onboarding tool
- [ ] Execute generated migration.sql
- [ ] Update building's agency_id
- [ ] Assign building to property manager(s) in user_buildings
- [ ] Verify access with test query

### Security
- [ ] Enable RLS on all tables
- [ ] Create policies for manager (see all) and property_manager (see assigned)
- [ ] Test access with different user roles

---

## Quick Reference

| Role | Sees | Needs Assignment? |
|------|------|-------------------|
| `manager` | ALL buildings in agency | ❌ No |
| `property_manager` | ONLY assigned buildings | ✅ Yes (user_buildings) |
| `admin` | System-wide | N/A |

**Key Tables:**
- `agencies` - Property management companies
- `users` - Staff (with role and agency_id)
- `buildings` - Properties (with agency_id)
- `user_buildings` - Building assignments for property managers

**Key Concept:**
- Managers are linked to agency → see all agency buildings
- Property managers are linked to specific buildings → see only those

---

*Generated: 2025-10-12*
*BlocIQ Onboarding System*
