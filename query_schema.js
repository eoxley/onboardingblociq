const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY,
  {
    db: { schema: 'public' }
  }
);

async function querySchema() {
  // Get all tables
  const { data: tables, error: tablesError } = await supabase
    .from('information_schema.tables')
    .select('table_name')
    .eq('table_schema', 'public')
    .in('table_name', [
      'buildings',
      'compliance_assets',
      'budgets',
      'units',
      'building_documents',
      'major_works_projects'
    ]);

  console.log('Tables query result:', { tables, tablesError });

  // Try PostgreSQL query directly
  const { data, error, count } = await supabase
    .from('buildings')
    .select('*', { count: 'exact', head: true });

  console.log('\nBuildings table check:', { count, error });

  // Try to get compliance_assets
  const { data: caData, error: caError, count: caCount } = await supabase
    .from('compliance_assets')
    .select('*', { count: 'exact', head: true });

  console.log('Compliance assets table check:', { count: caCount, error: caError });
}

querySchema();
