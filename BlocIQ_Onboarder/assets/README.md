# Company Logo for Building Health Check Reports

## Logo Placement Instructions

Place your company logo in this directory as `logo-header.png` to include it in Building Health Check PDF reports.

### Requirements

**Format:**
- PNG (recommended) or JPEG
- Transparent background preferred

**Size:**
- Recommended: 400px × 160px (2:1 aspect ratio)
- Minimum: 200px × 80px
- Maximum: 800px × 320px

**File Name:**
- Must be: `logo-header.png`
- Alternative: Update `logo_path` in `config/branding.json`

### Display Size

Logo will be rendered at:
- **Width:** 2 inches (5.08 cm)
- **Height:** 0.8 inches (2.03 cm)
- **Position:** Top-left of first page

### Quick Test

After placing logo, test with:

```bash
cd /Users/ellie/onboardingblociq

python3 -c "
import os
from pathlib import Path

logo_path = Path('BlocIQ_Onboarder/assets/logo-header.png')

if logo_path.exists():
    size = logo_path.stat().st_size
    print(f'✅ Logo found: {size:,} bytes')
else:
    print('❌ Logo not found')
    print(f'Expected location: {logo_path.absolute()}')
"
```

### Example Logo Placement

```bash
# Copy your logo to assets directory
cp /path/to/your-company-logo.png BlocIQ_Onboarder/assets/logo-header.png

# Verify placement
ls -lh BlocIQ_Onboarder/assets/logo-header.png
```

### Troubleshooting

**Logo not appearing in PDF:**
1. Check filename is exactly `logo-header.png` (case-sensitive)
2. Verify file is in `BlocIQ_Onboarder/assets/` directory
3. Check file permissions (must be readable)
4. Confirm image format is valid PNG or JPEG

**Logo too large/small:**
1. Image will auto-scale to 2" × 0.8"
2. For best results, use recommended size
3. Maintain 2:1 aspect ratio

**Custom logo path:**
Edit `config/branding.json`:
```json
{
  "logo_path": "path/to/your/custom-logo.png"
}
```

---

For more information, see:
- `docs/Building_Health_Check_Enhanced.md`
- `config/branding.json`
