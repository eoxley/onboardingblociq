#!/bin/bash

# BlocIQ Report Generator Setup Script
# Installs dependencies and PDF converters

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧱 BlocIQ Report Generator - Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm not found. Please install Node.js first."
    exit 1
fi

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

echo
echo "📄 Installing TypeScript dependencies..."
npm install --save-dev @types/node ts-node typescript

# Check OS and install PDF converter
echo
echo "🔍 Detecting operating system..."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "📱 macOS detected"

    if command -v brew &> /dev/null; then
        echo "📦 Installing wkhtmltopdf via Homebrew..."
        brew install wkhtmltopdf
    else
        echo "⚠️  Homebrew not found. Please install wkhtmltopdf manually:"
        echo "   brew install wkhtmltopdf"
    fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    echo "🐧 Linux detected"

    if command -v apt-get &> /dev/null; then
        echo "📦 Installing wkhtmltopdf via apt-get..."
        sudo apt-get update
        sudo apt-get install -y wkhtmltopdf
    else
        echo "⚠️  apt-get not found. Please install wkhtmltopdf manually:"
        echo "   sudo apt-get install wkhtmltopdf"
    fi

else
    echo "⚠️  Unknown OS. Please install wkhtmltopdf manually."
fi

# Check if Python is available for alternative PDF converters
if command -v pip3 &> /dev/null || command -v pip &> /dev/null; then
    echo
    echo "🐍 Python detected. Installing alternative PDF converters..."

    if command -v pip3 &> /dev/null; then
        pip3 install weasyprint pypandoc
    else
        pip install weasyprint pypandoc
    fi
fi

# Create .env template if it doesn't exist
if [ ! -f .env ]; then
    echo
    echo "📝 Creating .env template..."
    cat > .env << EOF
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
NODE_ENV=development
EOF
    echo "✅ Created .env file. Please update with your Supabase credentials."
else
    echo
    echo "ℹ️  .env file already exists"
fi

# Create reports directory
echo
echo "📁 Creating reports directory..."
mkdir -p diagnostics/reports

# Test installation
echo
echo "🧪 Testing installation..."
if command -v ts-node &> /dev/null; then
    echo "✅ ts-node installed"
else
    echo "⚠️  ts-node not found in PATH"
fi

if command -v wkhtmltopdf &> /dev/null; then
    echo "✅ wkhtmltopdf installed"
else
    echo "⚠️  wkhtmltopdf not found (HTML reports will still work)"
fi

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "📚 Next steps:"
echo "   1. Update .env with your Supabase credentials"
echo "   2. Run: ts-node generateReports.ts <building_id>"
echo "   3. Or: npm run report <building_id>"
echo
echo "📖 Documentation: REPORT_GENERATOR_README.md"
echo
