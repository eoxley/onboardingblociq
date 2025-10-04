const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
require('dotenv').config({ path: './BlocIQ_Onboarder/.env.local' });

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

async function runMigration() {
  const sql = fs.readFileSync('./SUPABASE_MIGRATION.sql', 'utf8');

  // Split by semicolons and execute each statement
  const statements = sql
    .split(';')
    .map(s => s.trim())
    .filter(s => s.length > 0);

  console.log(`🚀 Running ${statements.length} SQL statements...\n`);

  for (let i = 0; i < statements.length; i++) {
    const statement = statements[i] + ';';

    // Use fetch to execute raw SQL via PostgREST
    const response = await fetch(`${process.env.SUPABASE_URL}/rest/v1/rpc/exec`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': process.env.SUPABASE_SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${process.env.SUPABASE_SERVICE_ROLE_KEY}`,
        'Prefer': 'return=representation'
      },
      body: JSON.stringify({ sql: statement })
    });

    const result = await response.text();

    if (response.ok) {
      console.log(`✅ [${i + 1}/${statements.length}] ${statement.substring(0, 60)}...`);
    } else {
      console.log(`❌ [${i + 1}/${statements.length}] Error:`, result);
      console.log(`   SQL: ${statement}`);
    }
  }

  console.log('\n✨ Migration complete!');
}

runMigration();
