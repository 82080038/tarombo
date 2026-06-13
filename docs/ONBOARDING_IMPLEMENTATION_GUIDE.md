# 📖 Review Implementation Guide

**Versi:** 1.0.0  
**Durasi:** 1-2 jam  
**Target:** Developer baru Tarombo Digital

---

## 📋 Tujuan Review

Setelah review ini, developer diharapkan:
1. Memahami arsitektur aplikasi
2. Mengerti struktur database dan closure table
3. Paham flow kerja development
4. Dapat mulai development dengan benar

---

## 🏗️ Arsitektur Aplikasi

### High-Level Architecture

```
┌─────────────────┐
│   Frontend      │
│  (HTML/jQuery)  │
└────────┬────────┘
         │ HTTP/REST
         ▼
┌─────────────────┐
│   Backend API   │
│  (PHP Slim)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Database      │
│  (MySQL 8.0)    │
└─────────────────┘
```

### Frontend Architecture

**Tech Stack:**
- HTML 5 untuk struktur
- Bootstrap 5.3 untuk styling
- jQuery 3.7.0 untuk DOM manipulation dan AJAX
- D3.js untuk family tree visualization (optional)

**Structure:**
```
frontend/
├── css/
│   ├── style.css          # Global styles
│   ├── persons.css        # Persons page styles
│   └── family-tree.css    # Family tree styles
├── js/
│   ├── api.js             # API integration
│   ├── persons.js         # Persons logic
│   └── family-tree.js     # Family tree logic
├── index.html            # Homepage
├── persons.html          # Persons list
├── person-detail.html    # Person detail
├── family-tree.html      # Family tree visualization
└── partuturan.html       # Partuturan calculation
```

### Backend Architecture

**Tech Stack:**
- PHP 8.1+ dengan Slim Framework
- Eloquent ORM untuk database
- JWT untuk authentication
- php-di untuk dependency injection

**Structure:**
```
backend/
├── src/
│   ├── Controllers/       # API endpoints
│   │   ├── PersonController.php
│   │   ├── MargaController.php
│   │   └── PartuturanController.php
│   ├── Models/           # Eloquent models
│   │   ├── Person.php
│   │   ├── Marga.php
│   │   └── Marriage.php
│   ├── Services/         # Business logic
│   │   ├── PersonService.php
│   │   ├── MargaService.php
│   │   └── PartuturanService.php
│   └── Middleware/       # Auth & validation
│       ├── AuthMiddleware.php
│       └── ValidationMiddleware.php
├── config/
│   ├── database.php      # Database config
│   └── routes.php        # API routes
└── public/
    └── index.php         # Entry point
```

---

## 🗄️ Database Design

### Schema Overview

**Tabel Utama:**
1. `marga` - Marga Batak dengan hierarki
2. `marga_hierarchy` - Closure table untuk hierarki
3. `persons` - Data person/family
4. `marriages` - Data pernikahan
5. `audit_logs` - Log aktivitas
6. `users` - User authentication

### Closure Table Pattern

**Konsep:**
- Menyimpan semua hubungan ancestor-descendant
- Memungkinkan query hierarki cepat tanpa recursion
- Field: `ancestor_id`, `descendant_id`, `depth`

**Contoh Data:**
```
ancestor_id | descendant_id | depth
-----------|---------------|-------
    1      |       1       |   0   (Si Raja Batak self)
    1      |       2       |   1   (Si Raja Batak → Guru Tatea Bulan)
    1      |       3       |   2   (Si Raja Batak → Raja Isumbaon)
    2      |       2       |   0   (Guru Tatea Bulan self)
    2      |       3       |   1   (Guru Tatea Bulan → Raja Isumbaon)
```

**Query Examples:**

Get all ancestors of a marga:
```sql
SELECT m.nama, h.depth
FROM marga_hierarchy h
JOIN marga m ON m.id = h.ancestor_id
WHERE h.descendant_id = [marga_id]
ORDER BY h.depth;
```

Get all descendants of a marga:
```sql
SELECT m.nama, h.depth
FROM marga_hierarchy h
JOIN marga m ON m.id = h.descendant_id
WHERE h.ancestor_id = [marga_id]
ORDER BY h.depth;
```

---

## 🔧 Development Workflow

### 1. Setup Environment

**Clone Repository:**
```bash
git clone https://github.com/82080038/tarombo.git
cd tarombo
```

**Backend Setup:**
```bash
cd backend
composer install
cp .env.example .env
# Edit .env with your database credentials
php -S localhost:8000 -t public/
```

**Frontend Setup:**
```bash
cd frontend
python3 -m http.server 8080
```

**Database Setup:**
```bash
mysql -u root -p < database/init.sql
```

### 2. Development Flow

**Create Feature Branch:**
```bash
git checkout -b feature/nama-fitur
```

**Develop with Tests:**
```bash
# Backend tests
cd backend
./vendor/bin/phpunit

# E2E tests
cd tests
npx playwright test --headed
```

**Commit Changes:**
```bash
git add .
git commit -m "feat: deskripsi fitur"
```

**Push & PR:**
```bash
git push origin feature/nama-fitur
```

### 3. Code Quality Standards

**Backend (PHP):**
- Follow PSR-12 coding standard
- Use type hints
- Add docblocks
- Maximum complexity: 10

**Frontend (JavaScript):**
- Use ES6+ syntax
- Add JSDoc comments
- Follow jQuery best practices
- Maximum function length: 50 lines

---

## 🧪 Testing Strategy

### Unit Tests (Backend)

**Location:** `backend/tests/`

**Example:**
```php
class PersonServiceTest extends TestCase {
    public function testCreatePerson() {
        $service = new PersonService();
        $person = $service->create([
            'nama' => 'Test Person',
            'marga_id' => 1,
            'jenis_kelamin' => 'L'
        ]);
        
        $this->assertNotNull($person->id);
        $this->assertEquals('Test Person', $person->nama);
    }
}
```

### E2E Tests (Playwright)

**Location:** `tests/e2e/`

**Example:**
```typescript
test('should create person', async ({ page }) => {
    await page.goto('http://localhost:8080/persons.html');
    await page.click('#btn-add-person');
    await page.fill('#input-nama', 'Test Person');
    await page.selectOption('#select-marga', '1');
    await page.click('#btn-save');
    
    await expect(page.locator('.alert-success')).toBeVisible();
});
```

### Run Tests

```bash
# Backend unit tests
cd backend
./vendor/bin/phpunit

# E2E tests
cd tests
npx playwright test

# E2E with UI
npx playwright test --ui
```

---

## 📝 API Integration

### Authentication

**JWT Token Flow:**
```javascript
// Login
const response = await fetch('/api/v1/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        email: 'user@example.com',
        password: 'password'
    })
});

const { token } = await response.json();
localStorage.setItem('token', token);

// Use token in requests
const data = await fetch('/api/v1/persons', {
    headers: {
        'Authorization': `Bearer ${token}`
    }
});
```

### API Endpoints

**Persons:**
```javascript
// List all persons
GET /api/v1/persons

// Get person detail
GET /api/v1/persons/{id}

// Create person (auth required)
POST /api/v1/persons
{
    "nama": "John Doe",
    "marga_id": 1,
    "jenis_kelamin": "L",
    "tanggal_lahir": "1990-01-01",
    "tempat_lahir": "Medan"
}

// Update person (auth required)
PUT /api/v1/persons/{id}

// Delete person (auth required)
DELETE /api/v1/persons/{id}
```

**Marga:**
```javascript
// List all marga
GET /api/v1/marga

// Get marga detail with hierarchy
GET /api/v1/marga/{id}

// Get marga ancestors
GET /api/v1/marga/{id}/ancestors

// Get marga descendants
GET /api/v1/marga/{id}/descendants
```

**Partuturan:**
```javascript
// Calculate partuturan
GET /api/v1/partuturan/calculate?from={person_id}&to={person_id}

// Calculate tulang
GET /api/v1/partuturan/tulang?person_id={person_id}

// Calculate namboru
GET /api/v1/partuturan/namboru?person_id={person_id}
```

---

## 🚨 Common Issues & Solutions

### Issue 1: Database Connection Error

**Error:** `Can't connect to local MySQL server through socket`

**Solution:**
```bash
# Check MySQL socket path
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock

# Update .env with correct socket
DB_SOCKET=/opt/lampp/var/mysql/mysql.sock
```

### Issue 2: CORS Error

**Error:** `Access-Control-Allow-Origin`

**Solution:**
```php
// Add CORS middleware in backend/src/Middleware/CorsMiddleware.php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
```

### Issue 3: Closure Table Not Populated

**Error:** Empty marga_hierarchy table

**Solution:**
```sql
-- Re-populate closure table
DELETE FROM marga_hierarchy;

-- Insert self-references
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT id, id, 0 FROM marga;

-- Insert direct relationships
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT parent_id, id, 1 FROM marga WHERE parent_id IS NOT NULL;

-- Insert deeper relationships
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT p.ancestor_id, c.descendant_id, p.depth + c.depth
FROM marga_hierarchy p
JOIN marga_hierarchy c ON p.descendant_id = c.ancestor_id
WHERE c.depth > 0
AND NOT EXISTS (
    SELECT 1 FROM marga_hierarchy h 
    WHERE h.ancestor_id = p.ancestor_id AND h.descendant_id = c.descendant_id
);
```

---

## 📚 Key Documentation

**Wajib Baca:**
1. `docs/IMPLEMENTATION_GUIDE.md` - Guide lengkap
2. `docs/API_SPECIFICATION.md` - API documentation
3. `docs/DATABASE_DESIGN.md` - Database design
4. `docs/BUSINESS_RULE.md` - Business rules

**Referensi:**
1. `docs/LEARNING_GUIDE.md` - Learning path
2. `docs/SECURITY_ARCHITECTURE.md` - Security best practices
3. `docs/ROADMAP.md` - Development roadmap

---

## ✅ Checklist Review

Setelah review, developer harus:
- [ ] Memahami arsitektur frontend/backend
- [ ] Paham closure table pattern
- [ ] Bisa setup environment sendiri
- [ ] Mengerti workflow development
- [ ] Dapat menjalankan tests
- [ ] Paham API integration
- [ ] Bisa troubleshooting common issues
- [ ] Siap untuk development

---

## 🎯 Next Steps

Setelah review selesai:
1. Setup environment lokal
2. Jalankan tests untuk verifikasi
3. Mulai dengan task kecil (bug fix, small feature)
4. Review code dengan senior developer
5. Lanjut ke fitur yang lebih kompleks

---

**Motto:** *"Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."*
