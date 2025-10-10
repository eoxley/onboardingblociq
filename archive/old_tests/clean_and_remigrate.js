const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function cleanAndRemigrate() {
  console.log('🧹 Cleaning all data from Supabase...\n');

  const tables = [
    'building_title_deeds',
    'building_staff',
    'company_secretary',
    'building_warranties',
    'building_keys_access',
    'building_statutory_reports',
    'building_legal',
    'building_insurance',
    'building_utilities',
    'building_contractors',
    'uncategorised_docs',
    'major_works_notices',
    'building_compliance_assets',
    'apportionments',
    'budgets',
    'major_works_projects',
    'compliance_assets',
    'building_documents',
    'leaseholders',
    'units',
    'buildings'
  ];

  for (const table of tables) {
    const { error } = await supabase
      .from(table)
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000');

    if (error && !error.message.includes('not find the table')) {
      console.log(`❌ Error deleting from ${table}:`, error.message);
    } else if (!error) {
      console.log(`✅ Deleted all from ${table}`);
    }
  }

  console.log('\n✨ All data deleted!');
  console.log('\nNow:');
  console.log('1. Re-run the onboarder to generate fresh SQL');
  console.log('2. Run the new migration.sql in Supabase');
  console.log('3. Everything will have building_id! 🎉');
}

cleanAndRemigrate();
