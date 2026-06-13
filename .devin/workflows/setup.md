---
description: Setup dan menjalankan aplikasi Tarombo Digital
---

## Stack
- **Backend**: PHP 8.2 + Slim 4 + Eloquent ORM (port 8000)
- **Frontend**: HTML/jQuery/Bootstrap 5 (port 8080)
- **Database**: MariaDB 10.4 via XAMPP
- **Test**: Playwright (Node.js, di /tests/)

## Setup Environment

1. Pastikan XAMPP berjalan
```
sudo /opt/lampp/lampp start
```

2. Buat database
```
/opt/lampp/bin/mysql -u root -proot < /opt/lampp/htdocs/tarombo/database/init.sql
```

3. Buat .env backend
```
cp /opt/lampp/htdocs/tarombo/backend/.env.example /opt/lampp/htdocs/tarombo/backend/.env
```
Edit `.env`: DB_PASS=root, JWT_SECRET=tarombo-secret-key-2024

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

## Menjalankan Frontend (port 8080)

```
cd /opt/lampp/htdocs/tarombo/frontend && python3 -m http.server 8080
```

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

## API Endpoints
- GET /api/v1/persons - list persons (paginasi)
- GET /api/v1/persons/{id} - detail person
- POST /api/v1/persons - buat person (butuh JWT)
- PUT /api/v1/persons/{id} - update person (butuh JWT)
- DELETE /api/v1/persons/{id} - hapus person (butuh JWT)
- GET /api/v1/marga - list marga
- GET /api/v1/marga/{id} - detail marga
- GET /api/v1/partuturan/calculate?from={id}&to={id} - hitung partuturan
