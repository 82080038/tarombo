# 🌳 Tarombo Digital

## Sistem Silsilah Keluarga Batak Berbasis Web

**Versi:** 1.0.0  
**Status:** Development Ready

---

## 📁 Struktur Project

```
tarombo/
├── backend/           # PHP 8.x REST API
│   ├── src/
│   │   ├── Controllers/
│   │   ├── Models/
│   │   ├── Services/
│   │   └── Middleware/
│   ├── config/
│   ├── public/       # Entry point (index.php)
│   └── composer.json
├── frontend/          # React + TypeScript + Vite
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   └── hooks/
│   ├── package.json
│   └── vite.config.ts
├── database/          # SQL migrations & seeds
├── docker/            # Docker configuration
├── tests/             # Playwright E2E tests
└── docs/              # 18 dokumentasi lengkap
```

---

## 🚀 Quick Start

### Prerequisites
- PHP 8.1+ with Composer
- Node.js 18+ with npm
- MySQL 8.0+
- Docker & Docker Compose (optional)

### 1. Setup Environment

```bash
# Clone repository
cd /opt/lampp/htdocs/tarombo

# Run setup script
chmod +x setup.sh
./setup.sh
```

### 2. Manual Setup (Alternative)

**Backend:**
```bash
cd backend
composer install
cp .env.example .env
# Edit .env with your database credentials
php -S localhost:8000 -t public/
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

**Database:**
```bash
# Using MySQL
mysql -u root -p < database/schema.sql
mysql -u root -p < database/seeds.sql
```

### 3. Docker Setup (Recommended)

```bash
docker-compose up -d
```

Services:
- Backend API: http://localhost:8000
- Frontend Dev: http://localhost:3000
- MySQL: localhost:3306
- phpMyAdmin: http://localhost:8080

---

## 🧪 Testing dengan Playwright

### Setup Playwright
```bash
cd tests
npm install -D @playwright/test
npx playwright install
```

### Run Tests
```bash
# Headless mode
npx playwright test

# Headed mode (untuk debugging)
npx playwright test --headed

# Specific test file
npx playwright test person.spec.ts --headed

# With UI mode
npx playwright test --ui
```

### Test Structure
```
tests/
├── e2e/
│   ├── person.spec.ts      # Person CRUD tests
│   ├── tree.spec.ts        # Family tree tests
│   └── partuturan.spec.ts  # Partuturan calculation tests
├── fixtures/
│   └── test-data.json
└── playwright.config.ts
```

---

## 📚 Dokumentasi

Semua dokumentasi tersedia di folder `docs/`:

| Dokumen | Deskripsi |
|---------|-----------|
| [ANALISIS_BUDAYA_BATAK.md](docs/ANALISIS_BUDAYA_BATAK.md) | Fondasi budaya Batak |
| [BUSINESS_RULE.md](docs/BUSINESS_RULE.md) | 100+ aturan bisnis |
| [USE_CASE.md](docs/USE_CASE.md) | 50 Use Cases |
| [API_SPECIFICATION.md](docs/API_SPECIFICATION.md) | REST API spec |
| [IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md) | Panduan implementasi |
| [LEARNING_GUIDE.md](docs/LEARNING_GUIDE.md) | Kurikulum pembelajaran |
| [MASTER_INDEX.md](docs/MASTER_INDEX.md) | Konsolidasi dokumen |

---

## 🔧 API Endpoints

### Persons
```
GET    /api/v1/persons           # List all persons
GET    /api/v1/persons/{id}      # Get person detail
POST   /api/v1/persons           # Create person (auth required)
PUT    /api/v1/persons/{id}      # Update person (auth required)
DELETE /api/v1/persons/{id}      # Delete person (auth required)
```

### Marga
```
GET /api/v1/marga                # List all marga
GET /api/v1/marga/{id}           # Get marga detail
```

### Partuturan
```
GET /api/v1/partuturan/calculate?from={id}&to={id}
```

---

## 🏗️ Tech Stack

### Backend
- **PHP 8.1+** dengan Slim Framework
- **Eloquent ORM** untuk database
- **JWT** untuk authentication
- **Neo4j** untuk graph relationships (optional)

### Frontend
- **React 18** dengan TypeScript
- **Vite** untuk build tool
- **TailwindCSS** untuk styling
- **D3.js** untuk family tree visualization
- **React Query** untuk data fetching

### Testing
- **Playwright** untuk E2E testing
- **PHPUnit** untuk backend unit tests
- **Vitest** untuk frontend unit tests

---

## 🎯 Business Rules Implemented

| BR Code | Rule | Status |
|---------|------|--------|
| BR-MRG-001 | Marga patrilineal | ✅ Implemented |
| BR-MRG-002 | Uniqueness validation | ✅ Implemented |
| BR-PRK-006 | Same marga marriage forbidden | ✅ Implemented |
| BR-PRK-007 | Forbidden pairs | ✅ Implemented |
| BR-TUL-001 | Tulang calculation | ✅ Implemented |
| BR-NBR-001 | Namboru calculation | ✅ Implemented |
| BR-HIS-001 | Audit logging | ✅ Implemented |

---

## 📝 Development Workflow

### 1. Feature Development
```bash
# Create feature branch
git checkout -b feature/nama-fitur

# Develop with tests
npm run test:e2e:headed  # Untuk visual feedback

# Commit
git add .
git commit -m "feat: deskripsi fitur"

# Push & PR
git push origin feature/nama-fitur
```

### 2. Code Quality
```bash
# Backend
./vendor/bin/phpstan analyse src --level=8
./vendor/bin/phpcs

# Frontend
npm run lint
npm run test
```

### 3. Testing Before Commit
```bash
# Run all tests
./vendor/bin/phpunit          # Backend
npm test                      # Frontend
npx playwright test           # E2E
```

---

## 🐛 Troubleshooting

### Backend Issues
```bash
# Check logs
tail -f backend/logs/error.log

# Reset database
docker-compose down -v
docker-compose up -d
```

### Frontend Issues
```bash
# Clear cache
rm -rf frontend/node_modules
rm frontend/package-lock.json
cd frontend && npm install

# Check types
npx tsc --noEmit
```

### Database Issues
```bash
# Check connection
docker exec -it tarombo-mysql mysql -u root -p

# Reset data
mysql -u root -p tarombo < database/schema.sql
```

---

## 🤝 Contributing

1. Baca dokumentasi di folder `docs/`
2. Follow [IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md)
3. Pastikan test pass sebelum commit
4. Request review dari Tetua untuk fitur adat

---

## 📄 License

Proprietary - Tarombo Digital Project  
© 2026 Tarombo Digital

---

## 🆘 Support

Jika ada pertanyaan:
1. Check dokumentasi di `docs/`
2. Lihat [LEARNING_GUIDE.md](docs/LEARNING_GUIDE.md)
3. Tanya di channel development

---

**Motto:** *"Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."*
