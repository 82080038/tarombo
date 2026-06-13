#!/bin/bash
# Setup script for Tarombo Digital Development Environment

echo "🌳 Setting up Tarombo Digital Development Environment..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

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

echo -e "${BLUE}Step 2: Setting up Frontend...${NC}"
cd ../frontend
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in frontend/"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

echo "Installing Node.js dependencies..."
npm install

echo -e "${BLUE}Step 3: Setting up Docker Environment...${NC}"
cd ..
docker-compose up -d

echo -e "${BLUE}Step 4: Setting up Database...${NC}"
sleep 5  # Wait for containers to start

# Run database migrations
if command -v docker &> /dev/null; then
    docker exec tarombo-backend php /var/www/html/database/migrate.php
fi

echo -e "${BLUE}Step 5: Setting up Playwright...${NC}"
cd tests
npm init -y
npm install -D @playwright/test
npx playwright install

echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "📋 Next steps:"
echo "   1. Backend API: http://localhost:8000"
echo "   2. Frontend Dev: cd frontend && npm run dev"
echo "   3. Run tests: cd tests && npx playwright test --headed"
echo ""
echo "📚 Documentation:"
echo "   - API Docs: docs/API_SPECIFICATION.md"
echo "   - Implementation: docs/IMPLEMENTATION_GUIDE.md"
echo ""
echo "🚀 Happy coding!"
