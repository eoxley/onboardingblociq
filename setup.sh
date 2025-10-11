#!/bin/bash
# BlocIQ Production Check Setup Script

set -e

echo "============================================================"
echo "🚀 BlocIQ Production Check Setup"
echo "============================================================"

# 1. Install Python dependencies
echo ""
echo "📦 Installing Python dependencies..."
if pip3 install -r requirements.txt; then
    echo "✅ Python dependencies installed"
else
    echo "❌ Failed to install Python dependencies"
    exit 1
fi

# 2. Check for psql
echo ""
echo "🔍 Checking for PostgreSQL client (psql)..."
if command -v psql &> /dev/null; then
    PSQL_VERSION=$(psql --version)
    echo "✅ Found: $PSQL_VERSION"
else
    echo "⚠️  psql not found"
    echo ""
    echo "Please install PostgreSQL client:"
    echo "  macOS:  brew install postgresql@15"
    echo "  Linux:  sudo apt-get install postgresql-client"
    echo ""
    echo "After installation, add to PATH (macOS):"
    echo "  export PATH=\"/opt/homebrew/opt/postgresql@15/bin:\$PATH\""
    echo ""
fi

# 3. Check for .env file
echo ""
echo "🔐 Checking environment configuration..."
if [ -f .env ]; then
    echo "✅ Found .env file"

    # Load and check variables
    export $(cat .env | xargs)

    MISSING=""
    [ -z "$DATABASE_URL" ] && MISSING="$MISSING DATABASE_URL"
    [ -z "$SUPABASE_URL" ] && MISSING="$MISSING SUPABASE_URL"
    [ -z "$SUPABASE_SERVICE_KEY" ] && MISSING="$MISSING SUPABASE_SERVICE_KEY"

    if [ -n "$MISSING" ]; then
        echo "⚠️  Missing variables in .env:$MISSING"
        echo "   Please add them to .env file"
    else
        echo "✅ All required environment variables present"

        if [ -z "$BUILDING_ID" ]; then
            echo "⚠️  Optional: BUILDING_ID not set (smoke tests will be skipped)"
        else
            echo "✅ BUILDING_ID is set"
        fi
    fi
else
    echo "⚠️  No .env file found"
    echo ""
    echo "Creating .env template..."
    cat > .env <<'EOF'
# BlocIQ Production Check Environment Variables
# Fill in your actual credentials below

DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@db.xxx.supabase.co:5432/postgres
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...YOUR_KEY
BUILDING_ID=550e8400-e29b-41d4-a716-446655440000
EOF
    echo "✅ Created .env template"
    echo ""
    echo "📝 Please edit .env and add your actual credentials:"
    echo "   1. Get DATABASE_URL from Supabase project settings"
    echo "   2. Get SUPABASE_URL from Supabase project settings"
    echo "   3. Get SUPABASE_SERVICE_KEY from Supabase project API settings"
    echo "   4. Get BUILDING_ID from your database (optional)"
    echo ""
    echo "Then run: source .env && python3 prod_check.py"
    exit 0
fi

# 4. Test database connection (if psql available and env vars set)
if command -v psql &> /dev/null && [ -n "$DATABASE_URL" ]; then
    echo ""
    echo "🔌 Testing database connection..."
    if psql "$DATABASE_URL" -c "SELECT 1;" > /dev/null 2>&1; then
        echo "✅ Database connection successful"
    else
        echo "⚠️  Could not connect to database"
        echo "   Please verify DATABASE_URL is correct"
    fi
fi

# 5. Summary
echo ""
echo "============================================================"
echo "✅ Setup Complete!"
echo "============================================================"
echo ""
echo "Next steps:"
echo "1. Verify environment variables in .env"
echo "2. Load environment: export \$(cat .env | xargs)"
echo "3. Run production check: python3 prod_check.py"
echo ""
echo "Documentation:"
echo "- Setup guide:   SETUP.md"
echo "- Usage:         README_PROD_CHECK.md"
echo "- Quick start:   QUICKSTART.md"
echo ""
