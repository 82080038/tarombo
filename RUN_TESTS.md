# RUN TESTS GUIDE
## Panduan Menjalankan Playwright Tests

**Versi:** 1.0 | **Status:** Ready

---

## PREREQUISITES

Pastikan semua software berikut sudah terinstall:
- PHP 8.1+ dengan Composer
- Node.js 18+ dengan npm
- MySQL 8.0+
- Browser (Chrome/Firefox)

---

## STEP 1: INSTALL DEPENDENCIES

### Backend Dependencies
```bash
cd /opt/lampp/htdocs/tarombo/backend
composer install
cp .env.example .env
# Edit .env dengan kredensial database Anda
```

### Frontend Dependencies
```bash
cd /opt/lampp/htdocs/tarombo/frontend
npm install
```

### Test Dependencies
```bash
cd /opt/lampp/htdocs/tarombo/tests
npm install
npx playwright install
```

---

## STEP 2: SETUP DATABASE

```bash
# Import schema
mysql -u root -p < /opt/lampp/htdocs/tarombo/database/schema.sql

# Import seed data
mysql -u root -p tarombo < /opt/lampp/htdocs/tarombo/database/seeds.sql
```

---

## STEP 3: START SERVERS

### Terminal 1 - Backend API
```bash
cd /opt/lampp/htdocs/tarombo/backend
php -S localhost:8000 -t public/
```

Backend akan berjalan di: http://localhost:8000

### Terminal 2 - Frontend Dev Server
```bash
cd /opt/lampp/htdocs/tarombo/frontend
npm run dev
```

Frontend akan berjalan di: http://localhost:3000

---

## STEP 4: RUN PLAYWRIGHT TESTS

### Headed Mode (Browser Terlihat)
```bash
cd /opt/lampp/htdocs/tarombo/tests
npm run test:headed
```

### Headless Mode (Background)
```bash
cd /opt/lampp/htdocs/tarombo/tests
npm run test
```

### UI Mode (Interactive)
```bash
cd /opt/lampp/htdocs/tarombo/tests
npm run test:ui
```

### View Test Report
```bash
cd /opt/lampp/htdocs/tarombo/tests
npm run report
```

---

## TEST FILES

| File | Description |
|------|-------------|
| `e2e/home.spec.ts` | Homepage tests (navigation, welcome message) |
| `e2e/persons.spec.ts` | Persons page tests (list, search, pagination) |

---

## EXPECTED RESULTS

### Successful Test Run
```
Running 2 tests using 2 workers

  ✓  [chromium] › home.spec.ts:3:1 › Homepage › should display welcome message (2s)
  ✓  [chromium] › home.spec.ts:11:1 › Homepage › should have navigation links (1s)
  ✓  [chromium] › home.spec.ts:20:1 › Homepage › should navigate to Persons page (1s)
  ✓  [chromium] › persons.spec.ts:7:1 › Persons Page › should display persons list (2s)
  ✓  [chromium] › persons.spec.ts:14:1 › Persons Page › should have search functionality (1s)
  ✓  [chromium] › persons.spec.ts:23:1 › Persons Page › should have pagination (1s)
  ✓  [chromium] › persons.spec.ts:32:1 › Persons Page › should navigate to person detail (1s)

  7 passed (10s)
```

---

## TROUBLESHOOTING

### Error: "Cannot find module 'react'"
**Solution:** Jalankan `npm install` di folder `frontend/`

### Error: "Cannot find module '@playwright/test'"
**Solution:** Jalankan `npm install` di folder `tests/`

### Error: "Connection refused"
**Solution:** Pastikan backend server berjalan di port 8000

### Error: "Database connection failed"
**Solution:** Check file `.env` di backend dan pastikan kredensial MySQL benar

### Error: "No such file or directory"
**Solution:** Pastikan semua file sudah dibuat sesuai struktur

---

## QUICK START (ALL IN ONE)

```bash
# Install semua dependencies
cd /opt/lampp/htdocs/tarombo/backend && composer install
cd ../frontend && npm install
cd ../tests && npm install && npx playwright install

# Setup database
mysql -u root -p < ../database/schema.sql
mysql -u root -p tarombo < ../database/seeds.sql

# Start servers (di terminal terpisah)
# Terminal 1:
cd /opt/lampp/htdocs/tarombo/backend && php -S localhost:8000 -t public/

# Terminal 2:
cd /opt/lampp/htdocs/tarombo/frontend && npm run dev

# Terminal 3 (tests):
cd /opt/lampp/htdocs/tarombo/tests
npm run test:headed
```

---

## TEST COVERAGE

Saat ini tests mencakup:
- ✅ Homepage navigation
- ✅ Homepage welcome message
- ✅ Persons list display
- ✅ Search functionality
- ✅ Pagination
- ✅ Person detail navigation

Future tests akan ditambahkan untuk:
- Family tree visualization
- Partuturan calculator
- Authentication
- CRUD operations

---

## NOTES

- Tests menggunakan Playwright dengan browser Chromium dan Firefox
- Tests dijalankan secara parallel untuk speed
- Screenshots diambil otomatis jika test gagal
- HTML report di-generate setelah test selesai

---

**Status:** Ready untuk menjalankan tests dengan Playwright-Headed! 🎉
