-- Create building_keys_access table if it doesn't exist
CREATE TABLE IF NOT EXISTS building_keys_access (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
    access_type text,
    category text,
    label text,
    code text,
    location text,
    description text,
    visibility text DEFAULT 'team',
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_building_keys_access_building_id
    ON building_keys_access(building_id);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_category
    ON building_keys_access(building_id, category);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_search
    ON building_keys_access USING gin(
        to_tsvector('english',
            COALESCE(label, '') || ' ' ||
            COALESCE(description, '') || ' ' ||
            COALESCE(code, '')
        )
    );

