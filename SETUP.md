# Setup Guide for Production Check

## Prerequisites

### 1. Install Python Dependencies

```bash
pip3 install -r requirements.txt
```

This installs:
- `psycopg2-binary` - PostgreSQL database adapter
- Core BlocIQ dependencies (pandas, pdfplumber, reportlab, etc.)
- Supabase client

### 2. Install PostgreSQL Client (psql)

#### macOS
```bash
# Using Homebrew
brew install postgresql@15

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Reload shell
source ~/.zshrc  # or source ~/.bash_profile
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install postgresql-client
```

#### Verify Installation
```bash
psql --version
# Should show: psql (PostgreSQL) 15.x
```

### 3. Set Environment Variables

Create a `.env` file or export directly:

```bash
# Required for schema checks
export DATABASE_URL="postgresql://postgres:password@db.xxx.supabase.co:5432/postgres"
export SUPABASE_URL="https://xxx.supabase.co"
export SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Optional (for smoke tests)
export BUILDING_ID="550e8400-e29b-41d4-a716-446655440000"
```

#### Using .env file

Create `.env`:
```bash
DATABASE_URL=postgresql://postgres:password@db.xxx.supabase.co:5432/postgres
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
BUILDING_ID=550e8400-e29b-41d4-a716-446655440000
```

Load it:
```bash
export $(cat .env | xargs)
```

Or add to your shell profile (`~/.zshrc` or `~/.bash_profile`):
```bash
export DATABASE_URL="..."
export SUPABASE_URL="..."
export SUPABASE_SERVICE_KEY="..."
export BUILDING_ID="..."
```

### 4. Verify Setup

```bash
# Check Python dependencies
python3 -c "import psycopg2; print('psycopg2:', psycopg2.__version__)"

# Check psql
psql --version

# Check environment variables
echo $DATABASE_URL
echo $SUPABASE_URL
echo $SUPABASE_SERVICE_KEY
echo $BUILDING_ID
```

## Running Production Check

Once setup is complete:

```bash
python3 prod_check.py
```

Expected output:
```
============================================================
🚀 BlocIQ Production Readiness Check
============================================================

📋 Checking environment variables...
✅ All required environment variables present

🔄 Running: Schema export...
✅ Schema export: PASSED

🔄 Running: Schema validate...
✅ Schema validate: PASSED

...

============================================================
📊 RESULT
============================================================
Status: ✅ Production-ready

Passed:  10 ✅
Failed:  0 ❌
Skipped: 0 ⏭️
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'psycopg2'"

```bash
pip3 install psycopg2-binary
```

### "psql: command not found"

macOS:
```bash
brew install postgresql@15
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
```

Linux:
```bash
sudo apt-get install postgresql-client
```

### "Missing environment variables"

```bash
# Check what's set
env | grep -E "DATABASE_URL|SUPABASE"

# Set missing ones
export DATABASE_URL="..."
export SUPABASE_URL="..."
export SUPABASE_SERVICE_KEY="..."
```

### "Connection refused" or "could not connect to server"

Check your DATABASE_URL:
1. Verify credentials are correct
2. Check network connectivity
3. Verify Supabase project is running
4. Test connection:
   ```bash
   psql "$DATABASE_URL" -c "SELECT 1;"
   ```

### Database connection issues

If you can't connect to the database, you can still run some checks:

```bash
# Run unit tests only (no database required)
python3 -m unittest discover tests/unit -v
```

## Quick Setup Script

Create `setup.sh`:

```bash
#!/bin/bash

# Install Python dependencies
echo "Installing Python dependencies..."
pip3 install -r requirements.txt

# Check for psql
if ! command -v psql &> /dev/null; then
    echo "psql not found. Please install PostgreSQL client:"
    echo "  macOS: brew install postgresql@15"
    echo "  Linux: sudo apt-get install postgresql-client"
    exit 1
fi

# Check for .env file
if [ ! -f .env ]; then
    echo "Creating .env template..."
    cat > .env <<EOF
DATABASE_URL=postgresql://postgres:password@db.xxx.supabase.co:5432/postgres
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
BUILDING_ID=550e8400-e29b-41d4-a716-446655440000
EOF
    echo "✅ Created .env template. Please fill in your actual credentials."
    exit 0
fi

# Load environment
export $(cat .env | xargs)

echo "✅ Setup complete. Run: python3 prod_check.py"
```

Run it:
```bash
chmod +x setup.sh
./setup.sh
```

## Running Without Database

If you want to test the system without database access:

```bash
# Run unit tests only (uses fixtures)
python3 -m unittest tests/unit/test_lease_extractor.py
python3 -m unittest tests/unit/test_insurance_extractor.py
python3 -m unittest tests/unit/test_compliance_extractor.py
```

## CI/CD Setup

For GitHub Actions, add secrets:
- `DATABASE_URL`
- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY`
- `TEST_BUILDING_ID` (optional)

Workflow:
```yaml
- name: Install dependencies
  run: |
    pip install -r requirements.txt
    sudo apt-get install postgresql-client

- name: Run production check
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
    SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}
    BUILDING_ID: ${{ secrets.TEST_BUILDING_ID }}
  run: python3 prod_check.py
```

## Next Steps

1. Complete setup steps above
2. Run `python3 prod_check.py`
3. Review `docs/PROD_READINESS_CHECKLIST.md`
4. Fix any failures
5. Re-run until all checks pass
6. Deploy with confidence!

## Getting Help

- **Setup issues**: Check this file
- **Usage**: See `README_PROD_CHECK.md`
- **Full guide**: See `docs/PRODUCTION_READINESS_GUIDE.md`
- **SQL details**: See `docs/SQL_GENERATION_LOGIC.md`
