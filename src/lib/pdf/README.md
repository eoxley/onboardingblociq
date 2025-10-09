# BlocIQ Building Health Check V2

Professional, brand-aligned PDF report generator for building health assessments.

## Overview

The Building Health Check V2 generator creates comprehensive property reports featuring:
- **BlocIQ Brand Compliance**: Official colors, typography, and styling
- **Modular Architecture**: Clean, component-based structure
- **Data-Driven**: Automatically adapts to available data
- **Professional Output**: Executive-level PDF reports

## Features

### Report Sections
1. **Cover Page** - Building info, health score, disclaimer
2. **Executive Summary** - Key metrics and health breakdown
3. **Building Overview** - Property details
4. **Lease Summary** - Tenant and lease data
5. **Insurance Summary** - Policy information
6. **Budget Summary** - Financial overview
7. **Compliance Overview** - Regulatory status
8. **Contractors** - Service providers
9. **Major Works** - Active projects
10. **Document Index** - Appendix of files

### Health Score Calculation
```
Score = (Compliance% × 0.4) + (Insurance% × 0.2) + (Budgets% × 0.2) + (Leases% × 0.2)
```

**Ratings:**
- 🟢 80-100: Excellent
- 🟡 60-79: Satisfactory
- 🔴 <60: Requires Attention

## Installation

### Prerequisites
```bash
npm install pdfkit dayjs
npm install --save-dev @types/pdfkit ts-node typescript
```

### Project Structure
```
src/lib/pdf/
├── buildingHealthCheckV2.ts   # Main generator
├── brand.ts                    # Brand style guide
├── sampleData.json             # Test data
├── testHealthCheck.ts          # Test script
└── README.md                   # This file
```

## Usage

### Basic Usage
```typescript
import { generateBuildingHealthCheck } from './buildingHealthCheckV2';

const data = {
  building: {
    id: "uuid",
    name: "Connaught Square",
    address: "219.01 Connaught Square, London W2 2HL",
    units_count: 8,
    last_updated: "2025-10-09T10:00:00Z"
  },
  leases: [...],
  insurance: [...],
  budgets: [...],
  compliance: [...],
  contractors: [...],
  majorWorks: [...],
  documents: [...]
};

await generateBuildingHealthCheck(data, './output/report.pdf');
```

### Test with Sample Data
```bash
# Run test script
npm run generate:healthcheck -- --sample

# Or with ts-node
ts-node src/lib/pdf/testHealthCheck.ts
```

## Data Schema

### Building (Required)
```typescript
{
  id: string;
  name: string;
  address: string;
  year_built?: number;
  units_count: number;
  portfolio?: string;
  last_updated: string;
}
```

### Leases (Optional)
```typescript
{
  unit: string;
  term_start: string;
  term_years: number;
  expiry: string;
  ground_rent: number;
  sc_year: string;
}
```

### Insurance (Optional)
```typescript
{
  provider: string;
  policy_number: string;
  period: string;
  sum_insured: number;
  premium: number;
  status: string;
}
```

### Compliance (Optional)
```typescript
{
  type: string;
  date: string;
  next_due: string;
  status: 'compliant' | 'due_soon' | 'overdue' | 'unknown';
  responsible: string;
}
```

## Brand Guidelines

### Colors
- **Primary**: `#1A2E6C` (BlocIQ Navy)
- **Secondary**: `#00B6F0` (BlocIQ Blue)
- **Background**: `#F5F6F7` (Light Grey)
- **Success**: `#10B981` (Green)
- **Warning**: `#F59E0B` (Amber)
- **Danger**: `#EF4444` (Red)

### Typography
- **Font Family**: Inter (fallback: Helvetica)
- **Title**: 28pt Bold
- **Heading 1**: 22pt Bold
- **Heading 2**: 18pt Medium
- **Body**: 10pt Regular
- **Small**: 8pt Regular

## Output

### File Naming
```
{building_code}_{building_name}_HealthCheck_v2.pdf
```

Example: `21901_ConnaughtSquare_HealthCheck_v2.pdf`

### PDF Metadata
- **Title**: BlocIQ Building Health Check
- **Author**: BlocIQ Property Intelligence
- **Version**: 2.0.0
- **Creation Date**: Auto-generated

## API Reference

### `generateBuildingHealthCheck(data, outputPath)`

**Parameters:**
- `data: BuildingData` - Building and property data object
- `outputPath: string` - Full path for PDF output

**Returns:**
- `Promise<void>`

**Example:**
```typescript
await generateBuildingHealthCheck(data, '/output/report.pdf');
// Console: ✅ BlocIQ Health Check generated for Connaught Square
// Console: Output: /output/report.pdf
```

## Development

### Adding New Sections
1. Create new render method in `BuildingHealthCheckV2` class
2. Add to `generate()` method with conditional logic
3. Follow existing patterns for styling and layout

### Customizing Styles
Edit `brand.ts` to modify:
- Colors
- Font sizes
- Spacing
- Status indicators

### Testing
```bash
# Run test with sample data
npm run generate:healthcheck -- --sample

# Check output
open output/ConnaughtSquare_HealthCheck_v2.pdf
```

## Version History

### v2.0.0 (2025-10-09)
- Complete rebuild from scratch
- BlocIQ brand compliance
- Modular architecture
- Health score algorithm
- Professional table layouts
- Progress bars and visualizations

## License

© 2025 BlocIQ Property Intelligence. All rights reserved.
