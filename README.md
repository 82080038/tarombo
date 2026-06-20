# 🌳 Tarombo Digital

## Sistem Silsilah Keluarga Batak Berbasis Web

**Versi:** 2.0.0  
**Status:** Development Active  
**Last Updated:** June 20, 2026

---

## 📁 Struktur Project

```
tarombo/
├── backend/               # PHP 8.3 REST API (Slim 4 + Eloquent ORM)
│   ├── src/
│   │   ├── Controllers/   # 15 controllers (Auth, Person, Marriage, dll.)
│   │   ├── Models/        # Eloquent models (Person, Marga, User, dll.)
│   │   ├── Services/      # PartuturanService, AuditService, EmailService, GedcomService
│   │   ├── Middleware/    # Auth, CORS, RateLimit, Admin
│   │   └── Traits/        # ApiResponse trait
│   ├── tests/             # PHPUnit (51 tests, 133 assertions)
│   ├── public/index.php   # Entry point + route definitions
│   ├── .env               # Environment config (COMMITTED untuk development)
│   └── composer.json
├── frontend/              # PHP templates + Bootstrap 5 + jQuery
│   ├── includes/          # header.php, footer.php, menu.php, config.php
│   ├── js/                # api.js, auth-nav.js, finance.js, login.js
│   ├── *.php              # persons.php, family-tree.php, partuturan.php, dll.
│   └── .htaccess
├── database/
│   ├── schema_updated.sql     # Full schema (38 tabel, InnoDB, utf8mb4)
│   ├── tarombo_full_export.sql # Export database lengkap dengan data
│   └── migrations/            # 012+ migration files
├── tests/                 # Playwright E2E tests
│   ├── e2e/               # 5 spec files
│   └── playwright.config.ts
├── docs/                  # 18+ dokumentasi lengkap
├── .devin/workflows/      # Workflow untuk AI assistant
├── .github/workflows/ci.yml # CI/CD
├── ANALISIS_MENDALAM_APLIKASI.md  # Analisis 45 issue + status perbaikan
├── DEVELOPER_GUIDE.md     # Panduan lengkap untuk developer baru
└── README.md              # File ini
```

---

## 🚀 Quick Start

### Prerequisites
- **PHP 8.3+** with Composer (XAMPP PHP 8.2 tidak cukup — gunakan system PHP atau update XAMPP)
- **MariaDB 10.4+** (XAMPP) atau MySQL 8.0+
- **Node.js 18+** with npm (untuk Playwright E2E)
- **XAMPP** (Apache + MariaDB)
- Modern web browser

### 1. Clone & Install

```bash
# Clone repository
git clone <repo-url> /opt/lampp/htdocs/tarombo
cd /opt/lampp/htdocs/tarombo

# Install backend dependencies
cd backend && composer install && cd ..

# Install test dependencies
cd tests && npm install && cd ..
```

### 2. Database Setup

```bash
# Start XAMPP MySQL
sudo /opt/lampp/lampp start

# Create database
mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Option A: Import full export (schema + data)
mysql -u root -proot tarombo < database/tarombo_full_export.sql

# Option B: Fresh schema only (no data)
mysql -u root -proot tarombo < database/schema_updated.sql
# Then run all migrations:
for f in database/migrations/*.sql; do mysql -u root -proot tarombo < "$f"; done
```

### 3. Backend Configuration

File `.env` sudah committed dengan konfigurasi default XAMPP:
```
DB_HOST=localhost
DB_NAME=tarombo
DB_USER=root
DB_PASS=root
DB_UNIX_SOCKET=/opt/lampp/var/mysql/mysql.sock
JWT_SECRET=<already set>
APP_ENV=development
```

Untuk produksi: ganti `JWT_SECRET` dengan `openssl rand -base64 32`, set `APP_ENV=production`.

### 4. Run Application

```bash
# Start backend API (port 8000)
php -S localhost:8000 -t backend/public backend/public/index.php

# Start Apache for frontend
sudo /opt/lampp/lampp startapache

# Access frontend: http://localhost/tarombo/
# API health: http://localhost:8000/health
```

> **Penting:** Gunakan system PHP 8.3+ untuk backend, BUKAN XAMPP PHP 8.2 (composer.json requires >= 8.3)

---

## 🧪 Testing

### PHPUnit (Backend)
```bash
cd backend
vendor/bin/phpunit --testsuite Unit          # 51 unit tests
vendor/bin/phpunit --filter SecurityFixesTest # Security tests
vendor/bin/phpunit --testsuite Integration     # Integration tests
```

### Playwright (E2E)
```bash
cd tests
npm install              # Install dependencies
npx playwright install   # Install browsers
npx playwright test      # Run all E2E tests
npx playwright test --headed  # With browser UI
npx playwright test home.spec.ts  # Specific file
```

### Test Files
```
tests/e2e/
├── home.spec.ts              # Homepage + API tests
├── full-e2e.spec.ts          # Comprehensive E2E
├── comprehensive.spec.ts     # Full feature test
├── role-navigation.spec.ts   # RBAC navigation
└── role-simulation.spec.ts   # RBAC access simulation
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

**Base URL:** `http://localhost:8000/api/v1`

**Response format (konsisten di semua endpoint):**
```json
// Success: {"success": true, "data": {...}, "meta": {...}}
// Error:   {"success": false, "error": {"code": "ERROR_CODE", "message": "..."}}
```

### Auth
| Method | Path | Auth | Deskripsi |
|--------|------|------|-----------|
| POST | `/auth/login` | No | Login → JWT |
| POST | `/auth/register` | No | Register |
| POST | `/auth/quick-login` | No | Quick login (localhost only) |
| GET | `/auth/me` | JWT | Info user |
| POST | `/auth/logout` | JWT | Logout |
| POST | `/auth/forgot-password` | No | Request reset |
| POST | `/auth/reset-password` | No | Reset password |
| POST | `/auth/verify-email` | No | Verify email |

### Persons, Marga, Marriage, Partuturan
| Method | Path | Auth | Deskripsi |
|--------|------|------|-----------|
| GET | `/persons` | No | List (pagination) |
| GET | `/persons/{id}` | No | Detail + relationships |
| POST/PUT/DELETE | `/persons/{id}` | JWT | CRUD |
| GET | `/marga` | No | List marga |
| GET | `/marga/{id}/can-marry/{target_id}` | No | Check marriage |
| GET/POST/PUT/DELETE | `/marriages` | JWT | Marriage CRUD |
| GET | `/partuturan/calculate?from={id}&to={id}` | No | Hitung hubungan |

### Lainnya
- `/ceremonies` — Acara adat
- `/punguan` — Punguan & iuran
- `/documents` — Dokumen
- `/makam` — Makam
- `/geo/*` — Geografis/peta
- `/assets` — Harta warisan
- `/finance/*` — Keuangan
- `/events` — Events
- `/heritage` — Tradisi & stories
- `/communication` — Announcements & messages
- `/admin/*` — Admin (JWT + admin role)
- `/backup/*` — Backup/restore (admin)
- `/reports/*` — Export PDF/Excel/CSV
- `/gedcom/*` — GEDCOM import/export (JWT)

---

## 🏗️ Tech Stack

### Backend
- **PHP 8.3+** dengan Slim Framework 4
- **Eloquent ORM** (Illuminate Database 10) untuk database
- **JWT** (firebase/php-jwt) untuk authentication
- **PhpSpreadsheet** untuk Excel export
- **mPDF** untuk PDF export

### Frontend
- **PHP templates** dengan Bootstrap 5.3
- **jQuery 3.7** untuk AJAX
- **Leaflet.js** untuk peta

### Database
- **MariaDB 10.4** (XAMPP) — 38 tabel, 25+ FK constraints, 14+ indexes
- **InnoDB** engine, **utf8mb4_unicode_ci** collation

### Testing
- **PHPUnit 10** — 51 unit tests, 133 assertions
- **Playwright** — E2E tests
- **GitHub Actions** — CI/CD

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

### Backend: "Composer detected issues — PHP version"
XAMPP PHP 8.2 tidak cukup. Gunakan system PHP 8.3+:
```bash
php -v  # Pastikan 8.3+
php -S localhost:8000 -t backend/public backend/public/index.php
```

### Database: Import export
```bash
# Import full export (schema + data)
mysql -u root -proot tarombo < database/tarombo_full_export.sql

# Export ulang
mysqldump -u root -proot tarombo --routines --triggers > database/tarombo_full_export.sql
```

### Frontend: Apache tidak jalan
```bash
sudo /opt/lampp/lampp startapache
# Akses: http://localhost/tarombo/
```

### Test: Playwright browser error
```bash
cd tests && npx playwright install --force chromium
```

---

## 📖 Dokumentasi Penting

| File | Deskripsi |
|------|-----------|
| `DEVELOPER_GUIDE.md` | Panduan lengkap setup, arsitektur, API, testing |
| `ANALISIS_MENDALAM_APLIKASI.md` | Analisis 45 issue + status perbaikan (✅/⚠️) |
| `.devin/workflows/setup.md` | Workflow setup untuk AI assistant |
| `docs/BUSINESS_RULE.md` | 100+ aturan bisnis adat Batak |
| `docs/API_SPECIFICATION.md` | REST API specification |
| `docs/DATABASE_DESIGN.md` | Database design & ERD |
| `docs/IMPLEMENTATION_GUIDE.md` | Panduan implementasi |

## 🤝 Contributing

1. Baca `DEVELOPER_GUIDE.md` untuk memahami arsitektur
2. Baca `ANALISIS_MENDALAM_APLIKASI.md` untuk status current
3. Pastikan `vendor/bin/phpunit` pass sebelum commit
4. Jalankan `npx playwright test` untuk E2E
5. Commit dengan format: `feat:` / `fix:` / `docs:` / `refactor:`

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
