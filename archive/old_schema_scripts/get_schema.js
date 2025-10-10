#!/usr/bin/env node
/**
 * Fetch exact column schema from Supabase using REST API
 */

const https = require('https');

const SUPABASE_URL = 'https://aewixchhykxyhqjvqoek.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o';

const tables = [
    'buildings',
    'units',
    'leaseholders',
    'compliance_assets',
    'building_compliance_assets',
    'building_documents',
    'major_works_projects'
];

async function getTableSchema(tableName) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'aewixchhykxyhqjvqoek.supabase.co',
            path: `/rest/v1/${tableName}?select=*&limit=1`,
            method: 'GET',
            headers: {
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`
            }
        };

        const req = https.request(options, (res) => {
            let data = '';

            res.on('data', (chunk) => {
                data += chunk;
            });

            res.on('end', () => {
                try {
                    const json = JSON.parse(data);
                    if (json.length > 0) {
                        const columns = Object.keys(json[0]);
                        resolve({ table: tableName, columns, hasData: true });
                    } else {
                        // No data, but table exists - get from OPTIONS or schema
                        resolve({ table: tableName, columns: [], hasData: false });
                    }
                } catch (e) {
                    reject(e);
                }
            });
        });

        req.on('error', (e) => {
            reject(e);
        });

        req.end();
    });
}

async function main() {
    console.log('='.repeat(80));
    console.log('FETCHING ACTUAL SUPABASE SCHEMA');
    console.log('='.repeat(80));

    for (const table of tables) {
        try {
            const result = await getTableSchema(table);
            console.log(`\n📋 ${table.toUpperCase()}`);
            console.log('-'.repeat(80));

            if (result.columns.length > 0) {
                console.log(`Columns (${result.columns.length}):`);
                result.columns.sort().forEach(col => {
                    console.log(`  • ${col}`);
                });
            } else {
                console.log('  (No data in table - columns not available via this method)');
            }
        } catch (e) {
            console.log(`\n📋 ${table.toUpperCase()}`);
            console.log('-'.repeat(80));
            console.log(`  ✗ Error: ${e.message}`);
        }
    }

    console.log('\n' + '='.repeat(80));
}

main().catch(console.error);
