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
├── frontend/          # HTML + Bootstrap + jQuery
│   ├── css/          # Custom CSS
│   ├── js/           # JavaScript files
│   ├── index.html    # Homepage
│   ├── persons.html  # Persons list
│   ├── person-detail.html
│   ├── family-tree.html
│   └── partuturan.html
├── database/          # SQL migrations & seeds
├── tests/             # Playwright E2E tests
└── docs/              # 18 dokumentasi lengkap
```

---

## 🚀 Quick Start

### Prerequisites
- PHP 8.1+ with Composer
- Python 3+ (for static file server)
- MySQL 8.0+

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
python3 -m http.server 8080
# Atau gunakan web server lain (Apache, Nginx, dll)
```

**Database:**
```bash
# Using MySQL
mysql -u root -p < database/init.sql
```

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

### Harta Warisan (Assets)
```
GET    /api/v1/assets            # List all assets
GET    /api/v1/assets/{id}       # Get asset detail
POST   /api/v1/assets            # Create asset (auth required)
PUT    /api/v1/assets/{id}       # Update asset (auth required)
DELETE /api/v1/assets/{id}       # Delete asset (auth required)
POST   /api/v1/assets/{id}/transfer   # Transfer ownership (auth required)
GET    /api/v1/assets/{id}/inheritance  # Get inheritance history
```

### Keuangan Punguan (Finance)
```
GET    /api/v1/finance/transactions   # List transactions
POST   /api/v1/finance/transactions   # Create transaction (auth required)
PUT    /api/v1/finance/transactions/{id}/verify  # Verify transaction (auth required)
GET    /api/v1/finance/budgets        # List budgets
POST   /api/v1/finance/budgets        # Create budget (auth required)
GET    /api/v1/finance/iuran          # List iuran
POST   /api/v1/finance/iuran          # Create iuran (auth required)
PUT    /api/v1/finance/iuran/{id}/pay  # Pay iuran (auth required)
GET    /api/v1/finance/summary       # Get financial summary
```

---

## 🏗️ Tech Stack

### Backend
- **PHP 8.1+** dengan Slim Framework
- **Eloquent ORM** untuk database
- **JWT** untuk authentication
- **Neo4j** untuk graph relationships (optional)

| BR-AST-001 | Asset inheritance tracking | ✅ Implemented |
| BR-FIN-001 | Financial transaction verification | ✅ Implemented |
| BR-TAN-001 | Customary land management | ✅ Implemented |
### Frontend
- **HTML 5** untuk struktur
- **Bootstrap 5.3** untuk styling
- **jQuery 3.7.0** untuk DOM manipulation dan AJAX
- **D3.js** untuk family tree visualization (optional)

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
