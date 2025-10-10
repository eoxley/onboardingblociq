const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function verifyMigration() {
  console.log('🔍 Verifying migration...\n');

  const tables = [
    'buildings',
    'compliance_assets',
    'budgets',
    'building_contractors',
    'building_utilities',
    'building_insurance',
    'building_legal',
    'building_statutory_reports',
    'building_keys_access',
    'building_warranties',
    'company_secretary',
    'building_staff',
    'building_title_deeds'
  ];

  for (const table of tables) {
    const { error, count } = await supabase
      .from(table)
      .select('*', { count: 'exact', head: true });

    if (error) {
      console.log(`❌ ${table}: ${error.message}`);
    } else {
      console.log(`✅ ${table}: exists (${count} rows)`);
    }
  }

  console.log('\n✨ Verification complete!');
}

verifyMigration();
