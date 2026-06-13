# 🖥️ Environment Setup Onboarding Guide

**Versi:** 1.0.0  
**Durasi:** 1-2 jam  
**Target:** Developer baru Tarombo Digital

---

## 📋 Tujuan Setup

Setelah setup ini, developer akan memiliki:
1. Environment development yang siap
2. Database MySQL dengan data lengkap
3. Backend API yang berjalan
4. Frontend yang dapat diakses
5. Tools testing yang terinstall

---

## 🔧 Prerequisites

### Software yang Diperlukan

**Wajib:**
- PHP 8.1+ atau 8.2+
- Composer (PHP package manager)
- MySQL 8.0+ atau MariaDB 10.6+
- Python 3.8+ (untuk static file server)
- Git
- VS Code atau IDE lain

**Optional:**
- XAMPP (untuk MySQL pada Windows/Mac)
- Docker (alternative environment)
- Node.js 18+ (untuk Playwright)

---

## 📥 Step 1: Clone Repository

```bash
# Clone repository
git clone https://github.com/82080038/tarombo.git
cd tarombo

# Check branch
git branch
# Should show: * main
```

---

## 🗄️ Step 2: Setup Database

### Option A: Menggunakan XAMPP (Windows/Mac)

```bash
# 1. Install XAMPP
# Download dari: https://www.apachefriends.org/

# 2. Start MySQL
# Buka XAMPP Control Panel → Start MySQL

# 3. Import database
# Buka terminal/command prompt
cd /opt/lampp/htdocs/tarombo  # Linux/Mac
# atau
cd C:\xampp\htdocs\tarombo  # Windows

# Import database
mysql -u root -p < database/init.sql

# Masukkan password root (default: kosong atau sesuai konfigurasi)
```

### Option B: Menggunakan MySQL Standalone

```bash
# 1. Install MySQL
# Linux: sudo apt install mysql-server
# Mac: brew install mysql
# Windows: Download dari mysql.com

# 2. Start MySQL service
sudo systemctl start mysql  # Linux
brew services start mysql    # Mac
# Windows: Start MySQL service dari Services

# 3. Create database dan user
mysql -u root -p

# Di MySQL prompt:
CREATE DATABASE tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'tarombo_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON tarombo.* TO 'tarombo_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 4. Import database
mysql -u tarombo_user -p tarombo < database/init.sql
```

### Option C: Menggunakan Docker (Alternative)

```bash
# 1. Install Docker
# Download dari: https://www.docker.com/

# 2. Create docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: tarombo
    ports:
      - "3306:3306"
    volumes:
      - ./database:/docker-entrypoint-initdb.d
EOF

# 3. Start MySQL container
docker-compose up -d

# 4. Import database (otomatis dari folder database)
```

### Verifikasi Database

```bash
# Connect ke database
mysql -u root -p tarombo

# Check tables
SHOW TABLES;
# Should show: marga, marga_hierarchy, persons, marriages, audit_logs, users

# Check marga count
SELECT COUNT(*) FROM marga;
# Should show: 114

# Check hierarchy count
SELECT COUNT(*) FROM marga_hierarchy;
# Should show: 207

EXIT;
```

---

## 🔨 Step 3: Setup Backend

### Install PHP Dependencies

```bash
cd backend

# Install Composer jika belum ada
# Linux/Mac:
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Windows: Download dari https://getcomposer.org/

# Install dependencies
composer install

# Verifikasi
ls vendor/
# Should show folder vendor dengan banyak package
```

### Configure Environment

```bash
# Copy .env.example ke .env
cp .env.example .env

# Edit .env
nano .env  # Linux/Mac
# atau
notepad .env  # Windows
```

**Isi .env sesuai environment:**
```env
# Database Configuration
DB_DRIVER=mysql
DB_HOST=localhost
DB_NAME=tarombo
DB_USER=root
DB_PASS=root  # Sesuai password MySQL Anda
DB_SOCKET=/opt/lampp/var/mysql/mysql.sock  # Hanya untuk XAMPP Linux

# JWT Secret
JWT_SECRET=your-secret-key-change-in-production

# App Configuration
APP_ENV=development
APP_DEBUG=true
```

### Verifikasi Backend

```bash
# Start PHP development server
php -S localhost:8000 -t public/

# Buka browser: http://localhost:8000
# Should show: 404 Not Found (normal, karena belum ada route root)

# Test API endpoint
curl http://localhost:8000/api/v1/marga
# Should return JSON dengan list marga
```

---

## 🎨 Step 4: Setup Frontend

### Install Python (jika belum ada)

```bash
# Linux:
sudo apt install python3 python3-pip

# Mac:
brew install python3

# Windows:
# Download dari: https://www.python.org/
```

### Start Frontend Server

```bash
cd frontend

# Start Python static file server
python3 -m http.server 8080

# Alternative: Gunakan PHP
php -S localhost:8080

# Alternative: Gunakan Node.js http-server
npx http-server -p 8080
```

### Verifikasi Frontend

```bash
# Buka browser: http://localhost:8080
# Should show: Homepage Tarombo Digital

# Test halaman lain
http://localhost:8080/persons.html
http://localhost:8080/family-tree.html
http://localhost:8080/partuturan.html
```

---

## 🧪 Step 5: Setup Testing

### Install Playwright

```bash
cd tests

# Install Node.js jika belum ada
# Download dari: https://nodejs.org/

# Install Playwright
npm install -D @playwright/test

# Install Playwright browsers
npx playwright install

# Verifikasi
npx playwright --version
# Should show version number
```

### Run Tests

```bash
# Run semua tests (headless)
npx playwright test

# Run tests dengan browser visible (headed)
npx playwright test --headed

# Run specific test
npx playwright test person.spec.ts --headed

# Run dengan UI mode
npx playwright test --ui
```

---

## 🔧 Step 6: Configure IDE

### VS Code Extensions (Recommended)

Install extensions berikut:
1. **PHP Intelephense** - PHP intelligence
2. **PHP Debug** - PHP debugging
3. **MySQL** - Database management
4. **Playwright Test for VSCode** - Test runner
5. **GitLens** - Git supercharged
6. **Prettier** - Code formatter
7. **ESLint** - JavaScript linter

### VS Code Settings

```json
{
  "php.validate.executablePath": "/usr/bin/php",
  "files.associations": {
    "*.php": "php"
  },
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

---

## 🚨 Common Setup Issues

### Issue 1: PHP Version Tidak Support

**Error:** `PHP version 8.1+ required`

**Solution:**
```bash
# Linux: Install PHP 8.1+
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-mysql php8.1-xml

# Mac: Brew install PHP
brew install php@8.1

# Windows: Download PHP 8.1+ dari php.net
```

### Issue 2: MySQL Connection Error

**Error:** `Can't connect to local MySQL server through socket`

**Solution:**
```bash
# Check MySQL status
sudo systemctl status mysql  # Linux
brew services list | grep mysql  # Mac

# Start MySQL
sudo systemctl start mysql  # Linux
brew services start mysql    # Mac

# Check socket path
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock

# Update .env dengan socket yang benar
DB_SOCKET=/path/to/mysql.sock
```

### Issue 3: Composer Install Failed

**Error:** `composer install failed`

**Solution:**
```bash
# Update composer
composer self-update

# Clear composer cache
composer clear-cache

# Install dengan verbose
composer install -vvv
```

### Issue 4: Port Already in Use

**Error:** `Address already in use`

**Solution:**
```bash
# Check port yang digunakan
lsof -i :8000  # Linux/Mac
netstat -ano | findstr :8000  # Windows

# Kill process
kill -9 [PID]  # Linux/Mac
taskkill /PID [PID] /F  # Windows

# Atau gunakan port lain
php -S localhost:8001 -t public/
python3 -m http.server 8081
```

---

## ✅ Verification Checklist

Setelah setup selesai, verifikasi:

**Database:**
- [ ] MySQL service berjalan
- [ ] Database `tarombo` ada
- [ ] 6 tabel tercreate
- [ ] 114 marga records
- [ ] 207 marga_hierarchy records

**Backend:**
- [ ] PHP 8.1+ terinstall
- [ ] Composer dependencies terinstall
- [ ] .env file dikonfigurasi
- [ ] Backend server berjalan di port 8000
- [ ] API endpoint `/api/v1/marga` accessible

**Frontend:**
- [ ] Python 3+ terinstall
- [ ] Frontend server berjalan di port 8080
- [ ] Homepage accessible di browser
- [ ] Semua halaman dapat diakses

**Testing:**
- [ ] Node.js terinstall
- [ ] Playwright terinstall
- [ ] Playwright browsers terinstall
- [ ] Tests dapat dijalankan

---

## 📚 Quick Reference

### Start Development

```bash
# Terminal 1: Backend
cd backend
php -S localhost:8000 -t public/

# Terminal 2: Frontend
cd frontend
python3 -m http.server 8080

# Terminal 3: Tests (opsional)
cd tests
npx playwright test --headed
```

### Database Reset

```bash
# Drop dan recreate database
mysql -u root -p -e "DROP DATABASE IF EXISTS tarombo; CREATE DATABASE tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import ulang
mysql -u root -p tarombo < database/init.sql
```

### Git Workflow

```bash
# Check status
git status

# Create branch
git checkout -b feature/nama-fitur

# Commit
git add .
git commit -m "feat: deskripsi"

# Push
git push origin feature/nama-fitur
```

---

## 🎯 Next Steps

Setelah setup selesai:
1. Baca `docs/ONBOARDING_BATAK_CULTURE.md` (2-3 jam)
2. Baca `docs/ONBOARDING_IMPLEMENTATION_GUIDE.md` (1-2 jam)
3. Jalankan tests untuk verifikasi
4. Mulai dengan task kecil
5. Review code dengan senior developer

---

## 🆘 Support

Jika mengalami masalah:
1. Check troubleshooting section di atas
2. Baca dokumentasi di folder `docs/`
3. Tanya di channel development
4. Request help session dengan senior developer

---

**Motto:** *"Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."*
