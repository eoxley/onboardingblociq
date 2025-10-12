-- ============================================================
-- MIGRATION: Add Agency & User Management Structure
-- ============================================================
-- This adds multi-tenant agency support with role-based access control
-- Managers see all buildings, Property Managers see only assigned buildings

-- ============================================================
-- 1. CREATE AGENCIES TABLE
-- ============================================================

-- First, ensure agencies table exists with basic structure
CREATE TABLE IF NOT EXISTS agencies (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

-- Add missing columns to agencies table if they don't exist
DO $$
BEGIN
    -- Add email column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'email') THEN
        ALTER TABLE agencies ADD COLUMN email text;
    END IF;

    -- Add phone column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'phone') THEN
        ALTER TABLE agencies ADD COLUMN phone text;
    END IF;

    -- Add address column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'address') THEN
        ALTER TABLE agencies ADD COLUMN address text;
    END IF;

    -- Add website column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'website') THEN
        ALTER TABLE agencies ADD COLUMN website text;
    END IF;

    -- Add logo_url column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'logo_url') THEN
        ALTER TABLE agencies ADD COLUMN logo_url text;
    END IF;

    -- Add settings column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'settings') THEN
        ALTER TABLE agencies ADD COLUMN settings jsonb DEFAULT '{}'::jsonb;
    END IF;

    -- Add is_active column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'is_active') THEN
        ALTER TABLE agencies ADD COLUMN is_active boolean DEFAULT true;
    END IF;

    -- Add updated_at column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'agencies' AND column_name = 'updated_at') THEN
        ALTER TABLE agencies ADD COLUMN updated_at timestamp with time zone DEFAULT now();
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_agencies_name ON agencies(name);
CREATE INDEX IF NOT EXISTS idx_agencies_active ON agencies(is_active);

COMMENT ON TABLE agencies IS 'Property management companies/agencies that manage multiple buildings';
COMMENT ON COLUMN agencies.name IS 'Agency name (e.g., "MIH Property Management")';
COMMENT ON COLUMN agencies.settings IS 'Agency-specific settings and preferences';

-- ============================================================
-- 2. CREATE AGENCY_USERS TABLE
-- ============================================================
-- Note: Named 'agency_users' to avoid conflict with Supabase auth.users table

CREATE TABLE IF NOT EXISTS agency_users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    agency_id uuid NOT NULL REFERENCES agencies(id) ON DELETE CASCADE,
    email text UNIQUE NOT NULL,
    full_name text NOT NULL,
    role text NOT NULL CHECK (role IN ('admin', 'manager', 'property_manager', 'staff')),
    phone text,
    avatar_url text,
    settings jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    last_login timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_agency_users_agency ON agency_users(agency_id);
CREATE INDEX IF NOT EXISTS idx_agency_users_email ON agency_users(email);
CREATE INDEX IF NOT EXISTS idx_agency_users_role ON agency_users(role);
CREATE INDEX IF NOT EXISTS idx_agency_users_active ON agency_users(is_active);

COMMENT ON TABLE agency_users IS 'Agency staff members with role-based access control';
COMMENT ON COLUMN agency_users.role IS 'admin: system-wide, manager: all agency buildings, property_manager: assigned buildings only, staff: limited access';
COMMENT ON COLUMN agency_users.settings IS 'User preferences and permissions';

-- ============================================================
-- 3. CREATE USER_BUILDINGS TABLE (Assignment Junction)
-- ============================================================

-- First, ensure user_buildings table exists with basic structure
CREATE TABLE IF NOT EXISTS user_buildings (
    user_id uuid NOT NULL,
    building_id uuid NOT NULL,
    assigned_at timestamp with time zone DEFAULT now()
);

-- Add missing columns to user_buildings table if they don't exist
DO $$
BEGIN
    -- Add id column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_buildings' AND column_name = 'id') THEN
        ALTER TABLE user_buildings ADD COLUMN id uuid DEFAULT gen_random_uuid();
        -- Add primary key constraint only if no primary key exists
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.table_constraints
            WHERE table_name = 'user_buildings' AND constraint_type = 'PRIMARY KEY'
        ) THEN
            ALTER TABLE user_buildings ADD PRIMARY KEY (id);
        END IF;
    END IF;

    -- Add assigned_by column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'user_buildings' AND column_name = 'assigned_by') THEN
        ALTER TABLE user_buildings ADD COLUMN assigned_by uuid;
    END IF;

    -- Drop old foreign key if it exists (references old users table)
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'user_buildings'
        AND constraint_name LIKE '%user_id_fkey%'
        AND constraint_type = 'FOREIGN KEY'
    ) THEN
        ALTER TABLE user_buildings DROP CONSTRAINT IF EXISTS user_buildings_user_id_fkey;
    END IF;

    -- Clean up orphaned records before adding foreign key
    -- Delete rows where user_id doesn't exist in agency_users
    DELETE FROM user_buildings
    WHERE user_id NOT IN (SELECT id FROM agency_users WHERE id IS NOT NULL);

    -- Add foreign key to agency_users if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'user_buildings'
        AND constraint_name = 'user_buildings_user_id_agency_users_fkey'
    ) THEN
        -- Only add if agency_users table exists and has records
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'agency_users') THEN
            ALTER TABLE user_buildings ADD CONSTRAINT user_buildings_user_id_agency_users_fkey
                FOREIGN KEY (user_id) REFERENCES agency_users(id) ON DELETE CASCADE;
        END IF;
    END IF;

    -- Add foreign key to buildings if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'user_buildings'
        AND constraint_name = 'user_buildings_building_id_fkey'
    ) THEN
        ALTER TABLE user_buildings ADD CONSTRAINT user_buildings_building_id_fkey
            FOREIGN KEY (building_id) REFERENCES buildings(id) ON DELETE CASCADE;
    END IF;

    -- Add unique constraint if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'user_buildings'
        AND constraint_type = 'UNIQUE'
        AND constraint_name LIKE '%user_id%building_id%'
    ) THEN
        ALTER TABLE user_buildings ADD CONSTRAINT user_buildings_user_id_building_id_key UNIQUE(user_id, building_id);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_user_buildings_user ON user_buildings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_buildings_building ON user_buildings(building_id);

COMMENT ON TABLE user_buildings IS 'Assignment of property managers to specific buildings';
COMMENT ON COLUMN user_buildings.assigned_by IS 'Manager who made the assignment';

-- ============================================================
-- 4. ADD AGENCY_ID TO BUILDINGS TABLE
-- ============================================================

-- Add agency_id column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'buildings' AND column_name = 'agency_id'
    ) THEN
        ALTER TABLE buildings ADD COLUMN agency_id uuid REFERENCES agencies(id) ON DELETE SET NULL;
        CREATE INDEX idx_buildings_agency ON buildings(agency_id);
    END IF;
END $$;

COMMENT ON COLUMN buildings.agency_id IS 'Agency that manages this building';

-- ============================================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================

-- First check if buildings table already has RLS enabled
DO $$
BEGIN
    -- Only enable RLS if not already enabled
    IF NOT EXISTS (
        SELECT 1 FROM pg_tables
        WHERE schemaname = 'public'
        AND tablename = 'buildings'
        AND rowsecurity = true
    ) THEN
        ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
    END IF;
END $$;

-- Enable RLS on new tables
ALTER TABLE agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE agency_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_buildings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Agencies are viewable by authenticated users" ON agencies;
DROP POLICY IF EXISTS "Users can view their own agency" ON agencies;
DROP POLICY IF EXISTS "Users can view colleagues in same agency" ON users;
DROP POLICY IF EXISTS "Users can view their own record" ON users;
DROP POLICY IF EXISTS "Building access control" ON buildings;
DROP POLICY IF EXISTS "Managers see all agency buildings" ON buildings;
DROP POLICY IF EXISTS "Property managers see assigned buildings" ON buildings;

-- ============================================================
-- AGENCIES POLICIES
-- ============================================================

-- Master admin bypass - Ellie has full access
CREATE POLICY "Master admin full access"
ON agencies
FOR ALL
TO authenticated
USING (
    auth.jwt() ->> 'email' = 'elliemcarthur6@gmail.com'
);

-- Users can view their own agency
CREATE POLICY "Users can view their own agency"
ON agencies
FOR SELECT
TO authenticated
USING (
    id IN (
        SELECT agency_id FROM agency_users WHERE id = auth.uid()
    )
);

-- ============================================================
-- USERS POLICIES
-- ============================================================

-- Users can view their own record
CREATE POLICY "Users can view their own record"
ON users
FOR SELECT
TO authenticated
USING (id = auth.uid());

-- Users can view colleagues in same agency
CREATE POLICY "Users can view colleagues in same agency"
ON users
FOR SELECT
TO authenticated
USING (
    agency_id IN (
        SELECT agency_id FROM agency_users WHERE id = auth.uid()
    )
);

-- ============================================================
-- USER_BUILDINGS POLICIES
-- ============================================================

-- Users can view their own building assignments
CREATE POLICY "Users can view their assignments"
ON user_buildings
FOR SELECT
TO authenticated
USING (user_id = auth.uid());

-- Managers can view all assignments in their agency
CREATE POLICY "Managers can view agency assignments"
ON user_buildings
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM agency_users
        WHERE agency_users.id = auth.uid()
        AND agency_users.role IN ('manager', 'admin')
        AND agency_users.agency_id IN (
            SELECT u.agency_id
            FROM agency_users u
            WHERE u.id = user_buildings.user_id
        )
    )
);

-- ============================================================
-- BUILDINGS POLICIES
-- ============================================================

-- Combined policy: Managers see all, Property Managers see assigned
CREATE POLICY "Building access control"
ON buildings
FOR SELECT
TO authenticated
USING (
    -- Admin users see everything
    EXISTS (
        SELECT 1 FROM agency_users
        WHERE agency_users.id = auth.uid()
        AND agency_users.role = 'admin'
    )
    OR
    -- Managers see all buildings in their agency
    agency_id IN (
        SELECT agency_id FROM agency_users
        WHERE id = auth.uid()
        AND role = 'manager'
    )
    OR
    -- Property managers see only assigned buildings
    id IN (
        SELECT building_id
        FROM user_buildings
        WHERE user_id = auth.uid()
    )
);

-- ============================================================
-- RELATED TABLES: CASCADE ACCESS CONTROL
-- ============================================================

-- Units: Same access as buildings
ALTER TABLE units ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access units in accessible buildings" ON units;

CREATE POLICY "Users can access units in accessible buildings"
ON units
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
        -- RLS will automatically filter buildings based on user access
    )
);

-- Leaseholders: Same access as buildings
ALTER TABLE leaseholders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access leaseholders in accessible buildings" ON leaseholders;

CREATE POLICY "Users can access leaseholders in accessible buildings"
ON leaseholders
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
    )
);

-- Apportionments: Same access as buildings
ALTER TABLE apportionments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access apportionments in accessible buildings" ON apportionments;

CREATE POLICY "Users can access apportionments in accessible buildings"
ON apportionments
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
    )
);

-- Budgets: Same access as buildings
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access budgets in accessible buildings" ON budgets;

CREATE POLICY "Users can access budgets in accessible buildings"
ON budgets
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
    )
);

-- Compliance Assets: Same access as buildings
ALTER TABLE compliance_assets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access compliance assets in accessible buildings" ON compliance_assets;

CREATE POLICY "Users can access compliance assets in accessible buildings"
ON compliance_assets
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
    )
);

-- Contractors: Same access as buildings (via building_contractors junction)
ALTER TABLE building_contractors ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can access contractors in accessible buildings" ON building_contractors;

CREATE POLICY "Users can access contractors in accessible buildings"
ON building_contractors
FOR SELECT
TO authenticated
USING (
    building_id IN (
        SELECT id FROM buildings
    )
);

-- ============================================================
-- 6. HELPER FUNCTIONS
-- ============================================================

-- Function to check if user can access a building
CREATE OR REPLACE FUNCTION user_can_access_building(
    p_user_id uuid,
    p_building_id uuid
) RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM agency_users u
        JOIN buildings b ON b.id = p_building_id
        WHERE u.id = p_user_id
        AND (
            -- Admin sees everything
            u.role = 'admin'
            -- Manager sees all buildings in agency
            OR (u.role = 'manager' AND b.agency_id = u.agency_id)
            -- Property manager sees assigned buildings
            OR (u.role = 'property_manager' AND EXISTS (
                SELECT 1 FROM user_buildings ub
                WHERE ub.user_id = u.id
                AND ub.building_id = b.id
            ))
        )
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get all buildings accessible to a user
CREATE OR REPLACE FUNCTION get_user_accessible_buildings(p_user_id uuid)
RETURNS TABLE (building_id uuid, building_name text, access_type text) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id AS building_id,
        b.name AS building_name,
        CASE
            WHEN u.role = 'admin' THEN 'admin_access'
            WHEN u.role = 'manager' THEN 'full_agency_access'
            WHEN u.role = 'property_manager' THEN 'assigned_building'
            ELSE 'no_access'
        END AS access_type
    FROM agency_users u
    CROSS JOIN buildings b
    WHERE u.id = p_user_id
    AND (
        u.role = 'admin'
        OR (u.role = 'manager' AND b.agency_id = u.agency_id)
        OR (u.role = 'property_manager' AND EXISTS (
            SELECT 1 FROM user_buildings ub
            WHERE ub.user_id = u.id AND ub.building_id = b.id
        ))
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 7. UPDATED_AT TRIGGERS
-- ============================================================

-- Create trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add triggers
DROP TRIGGER IF EXISTS update_agencies_updated_at ON agencies;
CREATE TRIGGER update_agencies_updated_at
    BEFORE UPDATE ON agencies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_agency_users_updated_at ON agency_users;
CREATE TRIGGER update_agency_users_updated_at
    BEFORE UPDATE ON agency_users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- 8. SAMPLE DATA (OPTIONAL - COMMENT OUT IF NOT NEEDED)
-- ============================================================

-- Uncomment to create a sample agency and users for testing
/*
-- Create sample agency
INSERT INTO agencies (id, name, email, is_active)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'BlocIQ Demo Agency',
    'demo@blociq.com',
    true
)
ON CONFLICT (id) DO NOTHING;

-- Create sample manager
INSERT INTO users (id, agency_id, email, full_name, role, is_active)
VALUES (
    '11111111-1111-1111-1111-111111111111',
    '00000000-0000-0000-0000-000000000001',
    'manager@blociq.com',
    'Demo Manager',
    'manager',
    true
)
ON CONFLICT (email) DO NOTHING;

-- Create sample property manager
INSERT INTO users (id, agency_id, email, full_name, role, is_active)
VALUES (
    '22222222-2222-2222-2222-222222222222',
    '00000000-0000-0000-0000-000000000001',
    'pm@blociq.com',
    'Demo Property Manager',
    'property_manager',
    true
)
ON CONFLICT (email) DO NOTHING;
*/

-- ============================================================
-- MIGRATION COMPLETE
-- ============================================================

-- Verification queries
SELECT 'Migration completed successfully!' AS status;

-- Show table counts
SELECT
    'agencies' AS table_name,
    COUNT(*) AS row_count
FROM agencies
UNION ALL
SELECT 'users', COUNT(*) FROM agency_users
UNION ALL
SELECT 'user_buildings', COUNT(*) FROM user_buildings
ORDER BY table_name;
