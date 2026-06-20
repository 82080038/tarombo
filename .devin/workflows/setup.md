---
description: Setup dan menjalankan aplikasi Tarombo Digital
---

## Stack
- **Backend**: PHP 8.2 + Slim 4 + Eloquent ORM (port 8000)
- **Frontend**: PHP + HTML/jQuery/Bootstrap 5 + PHP Includes (header/menu/footer)
- **Database**: MariaDB 10.4 via XAMPP
- **Test**: Playwright (Node.js, di /tests/)
- **Map**: Leaflet.js + OpenStreetMap

## Arsitektur Frontend (PHP Includes)

Frontend sekarang menggunakan reusable PHP includes:
- `frontend/includes/config.php` — konfigurasi & helper RBAC
- `frontend/includes/header.php` — HTML head + Bootstrap CSS
- `frontend/includes/menu.php` — Navbar dengan RBAC-aware dropdown
- `frontend/includes/footer.php` — Footer + scripts
- `frontend/includes/content.php` — Layout helper functions

Setiap halaman menggunakan:
```php
<?php
$pageTitle = 'Judul Halaman';
$activePage = 'persons'; // untuk highlight menu
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
// ... konten halaman ...
$extraJs = '/js/file.js'; // opsional
require_once __DIR__ . '/includes/footer.php';
?>
```

Router root (`index.php`) akan mencoba `.php` terlebih dahulu sebelum fallback ke `.html`.

## Setup Environment

1. Pastikan XAMPP berjalan
```
sudo /opt/lampp/lampp start
```

2. Buat database dan jalankan semua migrations
```
/opt/lampp/bin/mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
# Jalankan schema utama
/opt/lampp/bin/mysql -u root -proot tarombo < /opt/lampp/htdocs/tarombo/database/schema_updated.sql
# Jalankan semua migrations berurutan
for f in /opt/lampp/htdocs/tarombo/database/migrations/*.sql; do
  /opt/lampp/bin/mysql -u root -proot tarombo < "$f"
done
```

3. Buat .env backend
```
cp /opt/lampp/htdocs/tarombo/backend/.env.example /opt/lampp/htdocs/tarombo/backend/.env
```
Edit `.env`: DB_PASS=root, JWT_SECRET=<generate dengan `openssl rand -base64 32`>

4. Install backend dependencies
```
cd /opt/lampp/htdocs/tarombo/backend && composer install
```

5. Install test dependencies
```
cd /opt/lampp/htdocs/tarombo/tests && npm install
```

## Menjalankan Backend API (port 8000)

```
/opt/lampp/bin/php -c /opt/lampp/etc/php.ini -S 0.0.0.0:8000 -t /opt/lampp/htdocs/tarombo/backend/public /opt/lampp/htdocs/tarombo/backend/public/index.php
```

## Menjalankan Frontend (port 8080) — Static Fallback

```
cd /opt/lampp/htdocs/tarombo/frontend && python3 -m http.server 8080
```

## Akses via Apache/XAMPP (PHP Includes Aktif)

Buka browser ke: `http://localhost/tarombo/` — Apache akan mengeksekusi PHP includes.

## Menjalankan Tests Playwright (headed)

```
cd /opt/lampp/htdocs/tarombo/tests && npx playwright test --headed
```

## Konfigurasi Database
- Host: localhost
- Database: tarombo
- User: root
- Password: root
- Socket: /opt/lampp/var/mysql/mysql.sock

## Fitur Aplikasi
1. **Dongan Tubu** — CRUD anggota, filter marga/sub-suku/gender, search
2. **Pohon Tarombo** — Visualisasi silsilah keluarga
3. **Partuturan** — Kalkulator hubungan, Tulang, Namboru, Bere, Pariban
4. **Perkawinan** — 7 tahapan adat, validasi marga
5. **Acara Adat** — Saur Matua, Kelahiran, Perkawinan
6. **Punguan** — Organisasi marga, pengurus, anggota
7. **Dokumen** — Arsip foto, video, audio, PDF
8. **Makam** — Dokumentasi makam dengan peta Leaflet
9. **Peta Keluarga** — Persebaran geografis anggota
10. **AI Assistant** — Chatbot pengetahuan adat Batak
11. **Admin Dashboard** — Statistik, aktivitas, user management
12. **Autentikasi** — JWT login/register/quick-login

## API Endpoints

### Auth
- POST /api/v1/auth/login
- POST /api/v1/auth/register
- POST /api/v1/auth/quick-login (localhost only)
- GET /api/v1/auth/me (JWT)
- POST /api/v1/auth/logout (JWT)
- POST /api/v1/auth/forgot-password
- POST /api/v1/auth/reset-password
- POST /api/v1/auth/verify-email

### Persons
- GET /api/v1/persons — list persons (dengan filter)
- GET /api/v1/persons/{id} — detail person (dengan relationships)
- POST /api/v1/persons — buat person (JWT)
- PUT /api/v1/persons/{id} — update person (JWT)
- DELETE /api/v1/persons/{id} — hapus person (JWT)
- GET /api/v1/partuturan/calculate?from={id}&to={id}

### Marga
- GET /api/v1/marga — list marga
- GET /api/v1/marga/{id} — detail marga
- GET /api/v1/marga/{id}/can-marry/{target_id}

### Marriage
- GET /api/v1/marriages — list perkawinan
- POST /api/v1/marriages — buat perkawinan (JWT)
- GET /api/v1/marriages/{id} — detail
- PUT /api/v1/marriages/{id}/stages/{stage_id} — update tahapan (JWT)
- DELETE /api/v1/marriages/{id} — hapus (JWT)

### Ceremony
- GET /api/v1/ceremonies — list acara
- POST /api/v1/ceremonies — buat acara (JWT)
- GET /api/v1/ceremonies/{id} — detail
- PUT /api/v1/ceremonies/{id} — update (JWT)

### Punguan
- GET /api/v1/punguan — list organisasi
- GET /api/v1/punguan/{id} — detail
- GET /api/v1/punguan/{id}/members — anggota
- POST /api/v1/punguan — buat (JWT)

### Documents
- GET /api/v1/documents — list dokumen (filter type)
- POST /api/v1/documents — upload (JWT)
- GET /api/v1/documents/{id} — detail

### Makam
- GET /api/v1/makam — list makam
- POST /api/v1/makam — buat (JWT)
- GET /api/v1/makam/{id} — detail

### Geo / Map
- GET /api/v1/geo/persons — lokasi anggota (filter marga/sub-suku)
- GET /api/v1/geo/makam — lokasi makam
- GET /api/v1/geo/statistics — statistik persebaran

### Admin
- GET /api/v1/admin/statistics — dashboard stats (JWT + admin)
- GET /api/v1/admin/users — list users (JWT + admin)
- PUT /api/v1/admin/users/{id}/role — update role (JWT + admin)

### GEDCOM
- GET /api/v1/gedcom/export — export GEDCOM 5.5.1 (JWT)
- POST /api/v1/gedcom/import — import GEDCOM (JWT)

### Backup/Restore
- GET /api/v1/backup/export — full backup (JWT + admin)
- GET /api/v1/backup/export/{type} — entity backup (JWT + admin)
- POST /api/v1/backup/import — restore backup (JWT + admin)

### Response Format (Konsisten)
```json
// Success
{"success": true, "data": {...}, "meta": {...}}
// Error
{"success": false, "error": {"code": "ERROR_CODE", "message": "..."}}
```

### Testing
```
cd /opt/lampp/htdocs/tarombo/backend && vendor/bin/phpunit --testsuite Unit
cd /opt/lampp/htdocs/tarombo/backend && vendor/bin/phpunit --filter SecurityFixesTest
cd /opt/lampp/htdocs/tarombo/tests && npx playwright test --headed
```

### Database Info
- 38 tabel, 25+ FK constraints, 14+ indexes
- FULLTEXT indexes pada persons.nama, marga.nama, stories.judil
- Migration files: 001-012 di database/migrations/
- Lihat ANALISIS_MENDALAM_APLIKASI.md untuk status perbaikan
- Lihat DEVELOPER_GUIDE.md untuk panduan lengkap
