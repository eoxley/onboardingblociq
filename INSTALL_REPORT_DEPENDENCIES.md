# 📦 Install Report Generation Dependencies

## Quick Install

```bash
cd /Users/ellie/onboardingblociq
pip3 install reportlab>=4.0.0
```

**Or install all requirements:**

```bash
pip3 install -r BlocIQ_Onboarder/requirements.txt
```

---

## Verification

```bash
python3 -c "import reportlab; print('✅ reportlab installed:', reportlab.__version__)"
python3 -c "from docx import Document; print('✅ python-docx installed')"
```

**Expected output:**
```
✅ reportlab installed: 4.0.7
✅ python-docx installed
```

---

## Test Report Generation

```bash
# Navigate to test directory
cd /Users/ellie/onboardingblociq

# Run test (creates example report from existing summary.json if available)
python3 -c "
from BlocIQ_Onboarder.report_generator import export_summary_report
import json
from pathlib import Path

# Create test summary
test_summary = {
    'timestamp': '2025-10-05T14:30:00',
    'building_name': 'Test Building',
    'statistics': {
        'files_parsed': 10,
        'buildings': 1,
        'units': 5,
        'leaseholders': 3,
        'documents': 10
    },
    'categories': {
        'compliance': 3,
        'finance': 5,
        'lease': 2
    }
}

# Save test summary
Path('test_output').mkdir(exist_ok=True)
with open('test_output/summary.json', 'w') as f:
    json.dump(test_summary, f, indent=2)

# Generate PDF
pdf = export_summary_report('test_output/summary.json', 'test_output', 'pdf')
print(f'✅ Test PDF created: {pdf}')

# Generate Word
word = export_summary_report('test_output/summary.json', 'test_output', 'word')
print(f'✅ Test Word doc created: {word}')
"
```

**Expected output:**
```
✅ Summary PDF created: test_output/summary_report.pdf
✅ Test PDF created: test_output/summary_report.pdf
✅ Summary Word doc created: test_output/summary_report.docx
✅ Test Word doc created: test_output/summary_report.docx
```

**Files created:**
```
test_output/
├── summary.json
├── summary_report.pdf
└── summary_report.docx
```

---

## Cleanup Test Files

```bash
rm -rf test_output
```

---

## Common Issues

### Issue: `pip3: command not found`

**Solution:**
```bash
# Use pip instead
pip install reportlab>=4.0.0
```

### Issue: `ModuleNotFoundError: No module named 'reportlab'`

**Solution:**
```bash
# Check Python version
python3 --version

# Install for specific Python version
python3.11 -m pip install reportlab>=4.0.0
```

### Issue: Permission denied

**Solution:**
```bash
# Install for user only
pip3 install --user reportlab>=4.0.0
```

### Issue: SSL certificate error

**Solution:**
```bash
# Use trusted host
pip3 install --trusted-host pypi.org --trusted-host files.pythonhosted.org reportlab>=4.0.0
```

---

## Next Steps

After successful installation:

1. ✅ Dependencies installed
2. ✅ Test report generated
3. 🚀 Ready to use with onboarding

**Try it:**
```bash
python3 BlocIQ_Onboarder/onboarder.py "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/"
```

**Output will include:**
```
✅ Summary: output/summary.json
✅ Summary PDF created: output/summary_report.pdf
```
