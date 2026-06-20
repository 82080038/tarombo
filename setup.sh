#!/bin/bash
# Setup script for Tarombo Digital Development Environment

echo "🌳 Setting up Tarombo Digital Development Environment..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Setting up Backend...${NC}"
cd backend
if [ ! -f "composer.json" ]; then
    echo "❌ composer.json not found in backend/"
    exit 1
fi

# Install PHP dependencies (if composer is available)
if command -v composer &> /dev/null; then
    echo "Installing PHP dependencies..."
    composer install
else
    echo "⚠️ Composer not found. Skipping PHP dependency installation."
    echo "   Run 'composer install' manually in the backend/ directory."
fi

echo -e "${BLUE}Step 2: Setting up Database...${NC}"
cd ..
if [ ! -f "database/schema.sql" ]; then
    echo "❌ database/schema.sql not found"
    exit 1
fi

echo "Importing database schema and seeds..."
mysql --socket=/opt/lampp/var/mysql/mysql.sock -u root -proot < database/schema.sql

echo -e "${BLUE}Step 3: Setting up Playwright...${NC}"
cd tests
if [ ! -f "package.json" ]; then
    npm init -y
fi
npm install -D @playwright/test
npx playwright install

echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "📋 Next steps:"
echo "   1. Backend API: cd backend && php -S localhost:8000 -t public/"
echo "   2. Frontend: cd frontend && python3 -m http.server 8080"
echo "   3. Run tests: cd tests && npm run test:headed"
echo ""
echo "📚 Documentation:"
echo "   - API Docs: docs/API_SPECIFICATION.md"
echo "   - Implementation: docs/IMPLEMENTATION_GUIDE.md"
echo ""
echo "🚀 Happy coding!"
