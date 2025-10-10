const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function fixDatabase() {
  console.log('🗑️  Deleting all data...\n');

  // Delete in correct order (respect foreign keys)
  const tables = [
    'uncategorised_docs',
    'major_works_notices',
    'building_compliance_assets',
    'apportionments',
    'budgets',
    'major_works_projects',
    'compliance_inspections',
    'compliance_assets',
    'building_documents',
    'leaseholders',
    'units',
    'buildings'
  ];

  for (const table of tables) {
    const { error, count } = await supabase
      .from(table)
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all

    if (error) {
      console.log(`❌ Error deleting from ${table}:`, error.message);
    } else {
      console.log(`✅ Deleted all from ${table}`);
    }
  }

  console.log('\n✨ All data deleted! Now run SUPABASE_MIGRATION.sql in Supabase SQL Editor.');
}

fixDatabase();
