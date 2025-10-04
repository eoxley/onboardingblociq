const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function checkSchema() {
  const { data, error } = await supabase.rpc('exec_sql', {
    sql: `
      SELECT
        table_name,
        column_name,
        data_type,
        is_nullable
      FROM information_schema.columns
      WHERE table_schema = 'public'
      AND table_name IN (
        'buildings',
        'compliance_assets',
        'budgets',
        'units',
        'leaseholders',
        'building_documents',
        'compliance_inspections',
        'major_works_projects',
        'apportionments',
        'major_works_notices',
        'building_compliance_assets',
        'uncategorised_docs'
      )
      ORDER BY table_name, ordinal_position;
    `
  });

  if (error) {
    // Try direct query instead
    const query = `
      SELECT
        table_name,
        column_name,
        data_type,
        is_nullable
      FROM information_schema.columns
      WHERE table_schema = 'public'
      AND table_name IN (
        'buildings',
        'compliance_assets',
        'budgets',
        'units',
        'leaseholders',
        'building_documents',
        'compliance_inspections',
        'major_works_projects',
        'apportionments',
        'major_works_notices',
        'building_compliance_assets',
        'uncategorised_docs'
      )
      ORDER BY table_name, ordinal_position;
    `;

    const response = await fetch(`${process.env.SUPABASE_URL}/rest/v1/rpc/exec_sql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': process.env.SUPABASE_SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${process.env.SUPABASE_SERVICE_ROLE_KEY}`
      },
      body: JSON.stringify({ query })
    });

    console.log('Schema check (trying alternative method):', await response.text());
  } else {
    console.log('Current Schema:');
    console.table(data);
  }
}

checkSchema();
