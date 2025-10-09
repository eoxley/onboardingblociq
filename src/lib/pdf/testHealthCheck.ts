/**
 * Test script for Building Health Check V2
 * Usage: ts-node src/lib/pdf/testHealthCheck.ts
 */

import * as fs from 'fs';
import * as path from 'path';
import { generateBuildingHealthCheck } from './buildingHealthCheckV2';

async function main() {
  try {
    console.log('🏗️  BlocIQ Building Health Check V2 Test\n');

    // Load sample data
    const sampleDataPath = path.join(__dirname, 'sampleData.json');
    const data = JSON.parse(fs.readFileSync(sampleDataPath, 'utf-8'));

    // Output path
    const outputDir = path.join(process.cwd(), 'output');
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    const outputPath = path.join(
      outputDir,
      `${data.building.name.replace(/\s+/g, '')}_HealthCheck_v2.pdf`
    );

    console.log(`📊 Generating report for: ${data.building.name}`);
    console.log(`📍 Address: ${data.building.address}`);
    console.log(`🔢 Units: ${data.building.units_count}\n`);

    // Generate PDF
    await generateBuildingHealthCheck(data, outputPath);

    console.log('\n✅ Test completed successfully!');
  } catch (error) {
    console.error('❌ Test failed:', error);
    process.exit(1);
  }
}

main();
