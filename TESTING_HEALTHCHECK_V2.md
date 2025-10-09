# Testing Building Health Check V2

## Quick Start

### 1. Install Dependencies
```bash
npm install pdfkit dayjs
npm install --save-dev @types/pdfkit ts-node typescript
```

### 2. Test with Sample Data
```bash
# Run the test script
npx ts-node src/lib/pdf/testHealthCheck.ts
```

This will generate:
`output/ConnaughtSquare_HealthCheck_v2.pdf`

### 3. View the PDF
```bash
open output/ConnaughtSquare_HealthCheck_v2.pdf
```

## Using Real Data

### From summary.json
```typescript
import * as fs from 'fs';
import { generateBuildingHealthCheck } from './src/lib/pdf/buildingHealthCheckV2';

// Load your building data
const summaryData = JSON.parse(fs.readFileSync('output/summary.json', 'utf-8'));

// Transform to expected format
const healthCheckData = {
  building: {
    id: 'building-id',
    name: summaryData.building_name,
    address: 'Building Address',
    units_count: summaryData.statistics.units,
    last_updated: summaryData.timestamp
  },
  leases: [], // Map from your data
  insurance: [], // Map from your data
  budgets: [], // Map from your data
  compliance: summaryData.compliance_assets.details.map(asset => ({
    type: asset.name,
    date: asset.last_inspection,
    next_due: asset.next_due,
    status: asset.status,
    responsible: asset.responsible_party
  })),
  documents: [] // Map from your data
};

// Generate PDF
await generateBuildingHealthCheck(
  healthCheckData,
  'output/RealBuilding_HealthCheck_v2.pdf'
);
```

## What to Check

### ✅ Visual Elements
- [ ] Cover page displays correctly
- [ ] BlocIQ branding (Navy/Blue colors)
- [ ] Health score box is visible
- [ ] All sections render without overlap

### ✅ Data Display
- [ ] Tables are properly formatted
- [ ] Alternating row colors work
- [ ] Text doesn't overflow columns
- [ ] Progress bars show correct percentages

### ✅ Content
- [ ] All populated sections appear
- [ ] Empty sections are skipped
- [ ] Page breaks work correctly
- [ ] Footer disclaimer is present

## Troubleshooting

### "Cannot find module 'pdfkit'"
```bash
npm install pdfkit
```

### "Cannot find module 'dayjs'"
```bash
npm install dayjs
```

### TypeScript errors
```bash
npm install --save-dev @types/pdfkit typescript ts-node
```

### PDF not generating
Check console output for errors. Common issues:
- Missing output directory (created automatically)
- Invalid data format
- File permissions

## Next Steps

1. **Pull from GitHub**: `git pull origin main`
2. **Install deps**: `npm install`
3. **Run test**: `npx ts-node src/lib/pdf/testHealthCheck.ts`
4. **View PDF**: Check `output/` folder
5. **Integrate**: Use with your real data

## Files Location
```
src/lib/pdf/
├── buildingHealthCheckV2.ts   # Main generator
├── brand.ts                    # BlocIQ styles
├── sampleData.json             # Test data
├── testHealthCheck.ts          # Test script
└── README.md                   # Full docs
```

Happy testing! 🎉
