# Analisis Mendalam Aplikasi Tarombo Digital

> Tanggal analisis: 20 Juni 2026  
> Cakupan: Arsitektur, backend, frontend, database, keamanan, testing, performa

---

## 1. Gambaran Umum Arsitektur

```
Browser → Apache (.htaccess) → index.php (router) → frontend/*.php atau proxy API ke localhost:8000
                                                          ↓
                                               backend/public/index.php (Slim 4 + Eloquent ORM)
                                                          ↓
                                               MySQL/MariaDB (tarombo)
```

**Stack:**
- **Backend:** PHP 8.1+, Slim 4, Eloquent ORM (Illuminate Database 10), JWT (firebase/php-jwt), PhpSpreadsheet, mPDF
- **Frontend:** PHP templates + Bootstrap 5, jQuery, vanilla JS modules
- **Database:** MariaDB 10.4 (XAMPP)
- **Testing:** PHPUnit 10 (backend), Playwright (E2E)

**Modul fungsional:** Person/Marga, Partuturan, Perkawinan (7 tahapan), Acara Adat, Punguan, Harta Warisan, Keuangan, Tanah Ulayat, Geografis/Peta, Tradisi Lisan, Pengetahuan Tradisional, Situs Budaya, Notifikasi, Backup/Restore, Laporan (PDF/Excel/CSV), AI Assistant, History Tracking.

---

## 2. Bug Kritis (Harus Diperbaiki Sekarang)

### 2.1 Double `$app->run()` — Response Ganda
**File:** `backend/public/index.php:242-243`
```php
$app->run();
$app->run();  // ← BUG: dipanggil dua kali
```
**Dampak:** Slim 4 akan mencoba mengirim response HTTP dua kali. Pada beberapa konfigurasi server ini menyebabkan output ganda atau error "headers already sent".

### 2.2 Konflik `const API` di Frontend
**File:** `frontend/js/api.js:29` dan `frontend/js/finance.js:1`

`api.js` mendefinisikan `const API = { ... }` dan `finance.js` juga mendefinisikan `const API = { ... }`. Jika kedua file dimuat di halaman yang sama (seperti `finance.php`), terjadi `SyntaxError: Identifier 'API' has already been declared`.

### 2.3 Mismatch URL API Frontend
**File:** `frontend/js/api.js:2`
```javascript
const API_BASE_URL = 'http://localhost:9000/api/v1';
```
Tapi `index.php` (router) mem-proxy ke `http://localhost:8000/`, dan `config.php` mendefinisikan `API_BASE_URL = '/tarombo/api/v1'`. **Tiga URL berbeda** untuk API yang sama. Frontend JS tidak akan berfungsi kecuali server berjalan di port 9000.

### 2.4 Mismatch Function Name Token
**File:** `frontend/js/finance.js:6`
```javascript
'Authorization': `Bearer ${getToken()}`
```
`api.js` mendefinisikan `getAuthToken()`, bukan `getToken()`. `finance.js` akan error `ReferenceError: getToken is not defined`.

### 2.5 `footer.php` Dimulai dengan `?>`
**File:** `frontend/includes/footer.php:1`
```php
?>
<footer class="mt-5 py-3 bg-light text-center">
```
File dimulai dengan closing PHP tag tanpa opening tag. Saat di-`require_once` dari file PHP yang sudah berakhir dengan `?>`, ini menghasilkan output `?>` literal di HTML.

### 2.6 Enum Mismatch pada Iuran
**File:** `database/schema_updated.sql:150` vs `backend/src/Controllers/FinanceController.php:188,213`

Schema: `enum('pending','verified','rejected')`  
Controller: set `status = 'belum'` dan `status = 'lunas'`

Nilai `'belum'` dan `'lunas'` tidak ada dalam enum. Insert akan gagal atau di-silent-ignore tergantung mode SQL.

### 2.7 `NotificationService::notifyEntityChange` Signature Mismatch
**File:** `backend/src/Services/AuditService.php:48` vs `backend/src/Services/NotificationService.php:93`

AuditService memanggil:
```php
$this->notificationService->notifyEntityChange($performedBy, $entityType, $entityId, $action);
```
Tapi signature NotificationService:
```php
public function notifyEntityChange(string $entityType, int $entityId, string $action, string $entityName, ?int $changedBy = null): void
```
Parameter tidak cocok — akan fatal error jika notificationService di-set.

---

## 3. Masalah Keamanan

### 3.1 Kritis: SQL Injection via Backup Export
**File:** `backend/src/Controllers/BackupController.php:86`
```php
$entityType = $args['type'];
$data = DB::table($entityType)->get()->toArray();
```
Nama tabel diambil langsung dari URL tanpa validasi. Attacker bisa mengakses tabel manapun: `users`, `security_audit_log`, dll.

### 3.2 Kritis: Backup Import — Truncate Arbitrary Tables
**File:** `backend/src/Controllers/BackupController.php:147-152`
```php
DB::table($table)->truncate();
foreach ($rows as $row) {
    unset($row['id']);
    DB::table($table)->insert($row);
}
```
Nama tabel dan data diambil dari JSON upload. File backup malicious bisa menghapus dan mengisi tabel manapun (termasuk `users` untuk privilege escalation).

### 3.3 Tinggi: Quick Login Backdoor
**File:** `backend/src/Controllers/AuthController.php:246-314`

Endpoint `POST /api/v1/auth/quick-login` mem-bypass autentikasi dan mengembalikan JWT valid untuk user manapun. Hanya dicek `APP_ENV === 'development'`, dan `.env` saat ini berisi `APP_ENV=development`. Jika deploy tanpa mengubah env, backdoor aktif di production.

### 3.4 Tinggi: JWT Secret Default Yang Lemah
**File:** `backend/.env:10`, `AuthController.php:22`, `AuthMiddleware.php:21`

Secret: `tarombo-secret-key-2024-change-in-production` — hardcoded di `.env` yang ter-commit. Fallback di code juga sama-sama lemah. Attacker yang tahu secret bisa forge JWT untuk user manapun.

### 3.5 Tinggi: CORS Wide Open + Credentials
**File:** `backend/src/Middleware/CorsMiddleware.php:20-23`
```php
->withHeader('Access-Control-Allow-Origin', '*')
->withHeader('Access-Control-Allow-Credentials', 'true')
```
Kombinasi `*` + `credentials: true` dilarang spec. Browser akan block, tapi ini menunjukkan tidak ada CORS policy yang proper.

### 3.6 Sedang: SQL Injection via Search
**File:** `backend/src/Controllers/PersonController.php:44`
```php
$q->where('nama', 'like', "%$search%")
```
`$search` tidak di-escape. Wildcard `%` dan `_` bisa digunakan untuk pattern injection. Tidak juga di-parameterize dengan binding.

### 3.7 Sedang: Frontend JWT Decode Tanpa Verifikasi
**File:** `frontend/includes/config.php:31-34`
```php
$payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')), true);
```
JWT di-decode tanpa verifikasi signature. Attacker bisa craft JWT cookie untuk bypass RBAC di frontend (menu admin muncul). Server-side masih aman karena AuthMiddleware verify, tapi ini misleading.

### 3.8 Sedang: Rate Limit Tidak Efektif
**File:** `backend/src/Middleware/RateLimitMiddleware.php:71-73`

Rate limit menggunakan PHP session (`$_SESSION`). API consumer biasanya tidak mengirim cookie session, sehingga rate limit tidak berfungsi. Brute force tetap possible.

### 3.9 Sedang: AuditMiddleware Dimatikan
**File:** `backend/public/index.php:44`
```php
// $app->add(new AuditMiddleware());
```
Audit logging global dimatikan. Hanya audit per-controller via AuditService yang aktif.

### 3.10 Rendah: Tidak Ada CSRF Protection
Tidak ada CSRF token di form manapun. Meskipun API menggunakan JWT (bukan cookie), form-form PHP tradisional rentan jika token disimpan di cookie.

---

## 4. Masalah Database

### 4.1 Schema Tidak Lengkap
`schema_updated.sql` hanya berisi ~15 tabel, tapi kode mengakses 30+ tabel. Tabel yang missing: `assets`, `inheritance_records`, `transactions`, `budgets`, `tanah_ulayat`, `rumah_keluarga`, `events`, `event_attendees`, `stories`, `traditions`, `oral_traditions`, `traditional_knowledge`, `cultural_sites`, `announcements`, `messages`, `notifications`, `security_audit_log`, `entity_history`, `entity_timeline`, `entity_version`, `notification_preferences`, `audit_logs` (model `AuditLog` dipakai di `AdminController` tapi tabel `audit_logs` ada di schema, bukan `entity_history`).

### 4.2 Conflict Migration Number
Dua file migration dengan nomor yang sama:
- `004_add_comprehensive_management.sql`
- `004_add_security_audit_log.sql`

### 4.3 Column Mismatch
- `persons` table: tidak ada `nama_depan` di `schema_updated.sql`, tapi `Person` model mengaksesnya. Migration `006_split_person_name.sql` mungkin menambahkannya tapi schema utama tidak sinkron.
- `iuran` table: tidak ada `jenis_iuran`, `tanggal_bayar` di schema, tapi controller menggunakannya.
- `iuran` table: `status` enum tidak cocok dengan nilai yang di-set controller.

### 4.4 Tidak Ada Soft Delete Konsisten
`Person` menggunakan `status = 'deleted'` untuk soft delete, tapi tidak ada scope global untuk memfilter. `Person::all()` akan return record terhapus. Hanya `scopeActive` yang memfilter, dan tidak semua query menggunakannya.

### 4.5 Tidak Ada Index pada Foreign Keys yang Sering Dijoin
Banyak FK tidak memiliki index eksplisit (misal: `transactions.punguan_id`, `transactions.person_id`). Untuk dataset besar ini lambat.

---

## 5. Masalah Arsitektur & Code Quality

### 5.1 Tidak Ada Service Container / DI Yang Proper
Controller di-instantiate langsung di route definitions. Setiap controller membuat instance service-nya sendiri di constructor (`new PartuturanService()`, `new AuditService()`). Tidak ada dependency injection yang proper meskipun PHP-DI ter-install.

### 5.2 Response Format Tidak Konsisten
- `PersonController`: `{data: [...], meta: {...}}` — tidak ada `success` field
- `MarriageController`: `{success: true, data: {...}}`
- `FinanceController`: `{success: true, data: ...}`
- `AuthController`: `{success: true, data: {...}}` atau `{success: false, error: {...}}`

Frontend harus handle multiple format. Seharusnya ada satu response wrapper.

### 5.3 N+1 Query Problem
- `PartuturanService::findShortestPath` — BFS dengan lazy loading relationships. Setiap node memicu query terpisah untuk father, mother, children, marriages.
- `Person::getParibanCandidates()` — multiple nested loops dengan lazy load.
- `Person::siblings()` — query terpisah setiap kali dipanggil.

### 5.4 Hardcoded Forbidden Marga Pairs
**File:** `backend/src/Models/Marriage.php:77-80`
```php
$forbiddenPairs = [
    ['Marbun', 'Sihotang'],
    ['Nainggolan', 'Siregar']
];
```
Hardcoded di model, padahal ada tabel `forbidden_marga_pairs` di database. `MarriageController::store` sudah menggunakan tabel, tapi `Marriage::validateForbiddenPairs` masih hardcoded — duplikasi logika.

### 5.5 `Person::spouses()` Union Query Buggy
**File:** `backend/src/Models/Person.php:126-138`

Menggunakan `union()` pada BelongsToMany — ini tidak akan berfungsi dengan baik di Eloquent. Union pada relationship builder menghasilkan query yang salah.

### 5.6 `Person::allChildren()` Mengembalikan Collection, Bukan Query Builder
```php
return $this->childrenAsFather->merge($this->childrenAsMother);
```
Ini memuat semua children ke memory lalu merge. Tidak bisa di-chain dengan query builder methods. `PersonController::destroy` memanggil `->count()` pada hasil ini, yang bekerja tapi tidak efisien.

### 5.7 Menu Navigation Menggunakan `.html` Extension
**File:** `frontend/includes/menu.php:19-48`

Semua link menggunakan `href="persons.html"`, `href="family-tree.html"`, dll. Router akan melayani `.php` version, tapi URL bar menampilkan `.html`. Tidak konsisten dan membingungkan untuk SEO.

### 5.8 Inline JavaScript di `login.php` Setelah Footer
**File:** `frontend/login.php:36-53`

Script tag berada setelah `</body></html>` (di luar document). Browser akan tetap mengeksekusi, tapi ini invalid HTML.

### 5.9 `auth-nav.js` Hardcoded URL
**File:** `frontend/js/auth-nav.js:27`
```javascript
const response = await fetch('/tarombo/api/v1/auth/me', {
```
Hardcoded path, tidak menggunakan `API_BASE_URL` dari `api.js`.

### 5.10 Tidak Ada Error Handling Global
Tidak ada custom error handler. `addErrorMiddleware(true, true, true)` menampilkan detail error ke client — berbahaya di production (membocorkan struktur code, query, dll).

---

## 6. Masalah Testing

### 6.1 Test Environment Tidak Mewakili Production
`phpunit.xml` menggunakan SQLite in-memory, tapi app menggunakan MySQL dengan enum, JSON columns, dan foreign key constraints. Test mungkin pass tapi production fail.

### 6.2 Test Coverage Minimal
Hanya 3 unit test dan 4 integration test. Banyak controller tidak ada test: AssetController, BackupController, ReportController, CommunicationController, LocationController, dll.

### 6.3 E2E Test Tidak Berjalan
`test-results/` kosong. Tidak ada konfigurasi CI/CD untuk menjalankan test otomatis.

### 6.4 Tidak Ada Test untuk Security Cases
Tidak ada test untuk: SQL injection, XSS, CSRF, JWT forgery, rate limit bypass, unauthorized access.

---

## 7. Masalah Performa

### 7.1 Tidak Ada Caching
Tidak ada cache layer untuk: marga list (static data), partuturan calculation (expensive BFS), statistics query, genealogy tree.

### 7.2 Tidak Ada Pagination di Beberapa Endpoint
- `AssetController::index` — load semua asset tanpa pagination
- `FinanceController::getTransactions` — load semua transaksi
- `FinanceController::getBudgets` — load semua budget
- `BackupController::export` — load semua tabel ke memory sekaligus

### 7.3 BFS Partuturan Tanpa Batas
`PartuturanService::findShortestPath` tidak memiliki depth limit. Pada family tree yang besar, BFS bisa explode secara eksponensial.

### 7.4 Eager Loading Tidak Optimal
`PersonController::show` eager-loads 8 relationship sekaligus. Untuk person dengan banyak children dan marriages, ini menghasilkan query yang sangat besar.

---

## 8. Saran Perbaikan (Prioritized)

### Prioritas 1: Bug Kritis & Keamanan

| # | Item | Estimasi |
|---|------|----------|
| 1 | Hapus double `$app->run()` di `backend/public/index.php` | 5 menit |
| 2 | Fix `const API` conflict di `finance.js` — rename menjadi `FinanceAPI` | 15 menit |
| 3 | Fix `getToken()` → `getAuthToken()` di `finance.js` | 5 menit |
| 4 | Fix `API_BASE_URL` di `api.js` — gunakan `/tarombo/api/v1` (relative) | 10 menit |
| 5 | Fix `footer.php` — hapus `?>` di awal file | 2 menit |
| 6 | Fix enum mismatch iuran — update controller atau schema | 30 menit |
| 7 | Fix `NotificationService::notifyEntityChange` signature | 15 menit |
| 8 | **Validasi whitelist tabel** di `BackupController::exportEntity` dan `import` | 30 menit |
| 9 | **Hapus atau guard `quickLogin`** dengan environment check yang stricter | 15 menit |
| 10 | **Ganti JWT secret** dengan random 256-bit key, jangan commit `.env` | 15 menit |
| 11 | **Fix CORS** — restrict origin ke domain yang diketahui | 10 menit |
| 12 | **Escape search input** di `PersonController::index` | 10 menit |
| 13 | Disable error detail di production: `addErrorMiddleware(false, false, false)` | 5 menit |

### Prioritas 2: Konsistensi & Code Quality

| # | Item | Estimasi |
|---|------|----------|
| 14 | Buat response wrapper trait/class untuk format konsisten | 1 jam |
| 15 | Sinkronkan `schema_updated.sql` dengan semua tabel dari migrations | 2 jam |
| 16 | Fix conflict migration number `004_` → rename salah satu | 5 menit |
| 17 | Implement DI container yang proper untuk controller | 2 jam |
| 18 | Hapus hardcoded forbidden pairs di `Marriage` model | 15 menit |
| 19 | Fix `Person::spouses()` — gunakan union di query level, bukan relationship | 1 jam |
| 20 | Fix `Person::allChildren()` — return query builder, bukan collection | 30 menit |
| 21 | Fix menu links — hapus `.html` extension, gunakan clean URL | 30 menit |
| 22 | Fix `auth-nav.js` — gunakan `API_BASE_URL` dari `api.js` | 15 menit |
| 23 | Pindahkan inline JS di `login.php` ke sebelum `</body>` | 10 menit |

### Prioritas 3: Performa & Scalability

| # | Item | Estimasi |
|---|------|----------|
| 24 | Tambah depth limit (max 10) di `PartuturanService::findShortestPath` | 15 menit |
| 25 | Eager load relationships di BFS partuturan | 1 jam |
| 26 | Tambah pagination di `AssetController`, `FinanceController` | 1 jam |
| 27 | Implement caching untuk marga list dan statistics | 2 jam |
| 28 | Tambah database index untuk FK columns yang sering di-query | 30 menit |
| 29 | Optimize `PersonController::show` — lazy load children/marriages hanya jika diminta | 1 jam |

### Prioritas 4: Testing & CI/CD

| # | Item | Estimasi |
|---|------|----------|
| 30 | Tambah unit test untuk semua controller | 1 hari |
| 31 | Tambah security test: SQL injection, XSS, JWT forgery | 4 jam |
| 32 | Setup GitHub Actions / CI untuk auto-run test | 2 jam |
| 33 | Fix test environment — gunakan MySQL test database, bukan SQLite | 2 jam |
| 34 | Tambah integration test untuk RBAC dan business rules | 4 jam |

### Prioritas 5: Pengembangan Fitur

| # | Item | Estimasi |
|---|------|----------|
| 35 | Password reset / forgot password via email | 1 hari |
| 36 | Email verification flow | 4 jam |
| 37 | File upload untuk documents (dengan validation & virus scan) | 1 hari |
| 38 | Real-time notifications via WebSocket/SSE | 2 hari |
| 39 | Implement GEDCOM import/export yang functional | 2 hari |
| 40 | Mobile-responsive UI audit & fix | 1 hari |
| 41 | Multi-language support (Batak/Indonesia/English) | 3 hari |
| 42 | PWA — offline support untuk data genealogy | 3 hari |
| 43 | API rate limiting yang proper (Redis-based) | 1 hari |
| 44 | API documentation dengan OpenAPI/Swagger | 1 hari |
| 45 | Implement actual AI assistant (bukan placeholder) | 1 minggu |

---

## 9. Rekomendasi Arsitektur Jangka Panjang

### 9.1 Migration ke Frontend SPA
Pertimbangkan migrasi frontend ke React/Vue SPA dengan:
- State management yang proper (Redux/Pinia)
- Component-based UI (shadcn/ui atau Material UI)
- TypeScript untuk type safety
- Vite sebagai build tool

Backend menjadi pure API, frontend di-serve terpisah. Ini menghilangkan need untuk PHP router di `index.php`.

### 9.2 API Versioning & Documentation
- Implement OpenAPI 3.0 spec
- Generate dokumentasi interaktif dengan Swagger UI
- Versioning yang proper: `/api/v1/`, `/api/v2/`
- Deprecation policy untuk endpoint lama

### 9.3 Database Migration Strategy
- Gunakan migration tool proper (Phinx atau Laravel migrations)
- Seed data terpisah dari schema
- Versioning yang konsisten (tidak ada duplikasi nomor)
- Rollback support

### 9.4 Microservices untuk Fitur Berat
Pisahkan service berat ke proses terpisah:
- **Partuturan calculation service** — BFS graph traversal bisa di-offload
- **Report generation service** — PDF/Excel generation memakan CPU
- **Notification service** — WebSocket/SSE real-time
- **AI assistant service** — NLP/ML processing

### 9.5 Infrastructure
- Docker container untuk development & production
- Nginx sebagai reverse proxy (bukan Apache .htaccess)
- Redis untuk caching & rate limiting
- Elasticsearch untuk search genealogy yang kompleks
- S3-compatible storage untuk documents & photos
- CI/CD pipeline (GitHub Actions → staging → production)

---

## 10. Ringkasan Eksekutif

| Kategori | Status | Jumlah Issue |
|----------|--------|-------------|
| Bug Kritis | 🔴 Urgent | 7 |
| Keamanan | 🔴 Kritis | 10 |
| Database | 🟡 Perlu Perbaikan | 5 |
| Code Quality | 🟡 Perlu Perbaikan | 10 |
| Testing | 🟠 Kurang | 4 |
| Performa | 🟠 Perlu Optimasi | 5 |

**Total: 41 issue teridentifikasi**

Aplikasi memiliki fondasi fungsional yang baik dengan implementasi business rules adat Batak yang komprehensif. Namun, ada beberapa bug kritis dan vulnerability keamanan yang harus segera diperbaiki sebelum aplikasi digunakan di production. Konsistensi response format, proper DI, dan test coverage adalah investasi penting untuk maintainability jangka panjang.

---

## 11. Stack Teknologi untuk Perbaikan & Pengembangan

### 11.1 Stack Saat Ini (Dipertahankan untuk Perbaikan Prioritas 1-3)

Perbaikan bug kritis, keamanan, konsistensi, dan performa akan menggunakan stack yang sudah ada — tidak perlu migrasi:

| Layer | Teknologi | Versi | File Terkait |
|-------|-----------|-------|-------------|
| **Backend Language** | PHP | 8.1+ | `backend/src/**/*.php` |
| **Backend Framework** | Slim 4 | ^4.0 | `backend/public/index.php`, `composer.json` |
| **ORM** | Eloquent (Illuminate Database) | ^10.0 | `backend/src/Models/*.php`, `backend/config/database.php` |
| **Auth** | firebase/php-jwt | ^6.0 | `backend/src/Controllers/AuthController.php`, `backend/src/Middleware/AuthMiddleware.php` |
| **Env Management** | vlucas/phpdotenv | ^5.0 | `backend/.env` |
| **DI Container** | php-di/php-di | ^7.0 | `backend/public/index.php` (terpasang tapi belum optimal) |
| **Export** | phpoffice/phpspreadsheet | ^5.8 | `backend/src/Controllers/ReportController.php` |
| **PDF** | mpdf/mpdf | ^8.3 | `backend/src/Controllers/ReportController.php` |
| **Logging** | monolog/monolog | ^3.0 | `composer.json` (terpasang, belum digunakan) |
| **Frontend Language** | PHP + JavaScript (vanilla) | - | `frontend/*.php`, `frontend/js/*.js` |
| **Frontend CSS** | Bootstrap 5 | 5.3.0 (CDN) | `frontend/includes/header.php` |
| **Frontend JS Lib** | jQuery | 3.7.0 (CDN) | `frontend/includes/footer.php` |
| **Database** | MariaDB | 10.4 (XAMPP) | `database/schema_updated.sql` |
| **Web Server** | Apache | XAMPP | `.htaccess` |
| **Unit Test** | PHPUnit | ^10.0 | `backend/phpunit.xml`, `backend/tests/` |
| **E2E Test** | Playwright | - | `tests/playwright.config.ts`, `tests/e2e/` |
| **Code Quality** | PHP_CodeSniffer + PHPStan | ^3.7 / ^1.10 | `composer.json` |

### 11.2 Stack untuk Pengembangan Lanjutan (Prioritas 4-5)

Untuk fitur baru dan peningkatan arsitektur, akan ditambahkan:

| Kategori | Teknologi | Tujuan | Prioritas |
|----------|-----------|--------|-----------|
| **Caching** | Redis 7 + predis/predis | Cache marga list, partuturan result, statistics | P3 |
| **Rate Limiting** | Redis-based counter | Ganti session-based rate limit yang tidak efektif | P3 |
| **API Documentation** | OpenAPI 3.0 + swagger-php | Generate dokumentasi API otomatis dari annotation | P4 |
| **File Upload** | PHP native + intervention/image | Upload, resize, validate documents & photos | P5 |
| **Email** | PHPMailer / symfony/mailer | Password reset, email verification, notifikasi | P5 |
| **Real-time** | Ratchet / Workerman (PHP WebSocket) | Notifikasi real-time tanpa polling | P5 |
| **Search** | Elasticsearch (opsional) | Search genealogy kompleks (full-text, fuzzy) | P5 |

### 11.3 Stack Migrasi Jangka Panjang (Opsional)

Jika memutuskan migrasi ke SPA (Section 9.1):

| Layer | Teknologi | Alasan |
|-------|-----------|--------|
| **Frontend Framework** | React 18 + TypeScript | Component-based, ecosystem matang |
| **Build Tool** | Vite 5 | Fast HMR, ES modules native |
| **UI Components** | shadcn/ui + TailwindCSS | Modern, customizable, aksesibel |
| **State Management** | Zustand / TanStack Query | Lightweight, server-state management |
| **Routing** | React Router 6 | Client-side routing |
| **Charts** | Recharts / D3.js | Visualisasi pohon tarombo & statistik |
| **Map** | Leaflet + react-leaflet | Peta persebaran keluarga |
| **Containerization** | Docker + docker-compose | Reproducible environment |
| **Reverse Proxy** | Nginx | Lebih efisien dari Apache untuk API |
| **CI/CD** | GitHub Actions | Auto test, lint, build, deploy |

### 11.4 Bahasa Pemrograman per Area Perbaikan

Berikut rincian bahasa/teknologi yang akan dipakai untuk setiap kategori perbaikan:

#### A. Bug Kritis (Prioritas 1) — PHP + JavaScript
```
Perbaikan                              Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
Double $app->run()                     PHP             backend/public/index.php
const API conflict                     JavaScript      frontend/js/finance.js
API_BASE_URL mismatch                  JavaScript      frontend/js/api.js
getToken() → getAuthToken()            JavaScript      frontend/js/finance.js
footer.php ?> bug                      PHP             frontend/includes/footer.php
Enum iuran mismatch                    SQL + PHP       database/migrations/, FinanceController.php
NotificationService signature          PHP             backend/src/Services/*.php
BackupController SQL injection         PHP             backend/src/Controllers/BackupController.php
Quick login backdoor                   PHP             backend/src/Controllers/AuthController.php
JWT secret                             PHP + Shell     backend/.env
CORS fix                               PHP             backend/src/Middleware/CorsMiddleware.php
Search input escape                    PHP             backend/src/Controllers/PersonController.php
Error middleware                       PHP             backend/public/index.php
```

#### B. Database (Prioritas 2) — SQL + PHP
```
Perbaikan                              Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
Sinkronisasi schema                    SQL             database/schema_updated.sql
Fix migration conflict                 Shell           database/migrations/004_*
Column mismatch                        SQL + PHP       database/migrations/, Models/*.php
Soft delete scope                      PHP             backend/src/Models/Person.php
Tambah index                           SQL             database/migrations/008_*
```

#### C. Code Quality (Prioritas 2) — PHP + JavaScript
```
Perbaikan                              Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
Response wrapper trait                 PHP             backend/src/Traits/ApiResponse.php
DI container                           PHP             backend/public/index.php, config/
Hapus hardcoded forbidden pairs        PHP             backend/src/Models/Marriage.php
Fix Person::spouses()                  PHP             backend/src/Models/Person.php
Fix Person::allChildren()              PHP             backend/src/Models/Person.php
Menu links                             PHP             frontend/includes/menu.php
auth-nav.js URL                        JavaScript      frontend/js/auth-nav.js
Login.php inline JS                    PHP + JS        frontend/login.php
```

#### D. Performa (Prioritas 3) — PHP + SQL + Redis
```
Perbaikan                              Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
BFS depth limit                        PHP             backend/src/Services/PartuturanService.php
Eager load BFS                         PHP             backend/src/Services/PartuturanService.php
Pagination                             PHP             backend/src/Controllers/*.php
Caching                                PHP + Redis     backend/src/Services/CacheService.php (baru)
DB index                               SQL             database/migrations/008_*
```

#### E. Testing (Prioritas 4) — PHP + TypeScript
```
Perbaikan                              Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
Unit test controller                   PHP             backend/tests/Unit/*.php
Security test                          PHP             backend/tests/Integration/*.php
E2E test                               TypeScript      tests/e2e/*.spec.ts
CI/CD config                           YAML            .github/workflows/ci.yml (baru)
```

#### F. Fitur Baru (Prioritas 5) — PHP + JavaScript + SQL
```
Fitur                                  Bahasa          File
─────────────────────────────────────  ──────────────  ──────────────────────
Password reset                         PHP + SQL       backend/src/Controllers/AuthController.php
Email verification                     PHP             backend/src/Services/EmailService.php (baru)
File upload                            PHP + JS        backend/src/Controllers/DocumentController.php
Real-time notif                        PHP + JS        backend/src/Services/WebSocketService.php (baru)
GEDCOM import/export                   PHP             backend/src/Services/GenealogyService.php
Multi-language                         PHP + JS        frontend/includes/lang/*.php (baru)
PWA                                    JavaScript      frontend/sw.js (baru)
AI Assistant                           PHP + Python    backend/src/Services/AIAssistantService.php (baru)
```
