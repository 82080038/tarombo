# Developer Guide - Tarombo Digital

**Version:** 1.0.0  
**Last Updated:** June 15, 2026  
**Target Audience:** Developers joining the Tarombo Digital project

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Development Environment Setup](#development-environment-setup)
4. [Database Management](#database-management)
5. [Code Structure](#code-structure)
6. [API Development](#api-development)
7. [Frontend Development](#frontend-development)
8. [Testing](#testing)
9. [Deployment](#deployment)
10. [Common Tasks](#common-tasks)
11. [Troubleshooting](#troubleshooting)

---

## Project Overview

**Tarombo Digital** is a web-based family tree system for Batak families, implementing traditional kinship rules (partuturan) in a modern digital application.

### Key Features
- **Family Tree Management:** Track lineage from generation to generation
- **Partuturan Calculator:** Calculate family relationships using Batak kinship rules
- **Marriage Validation:** Enforce traditional marriage restrictions
- **Asset & Inheritance Tracking:** Manage family assets and inheritance
- **Punguan Finance:** Track clan organization finances
- **Cultural Heritage:** Document traditions, stories, and cultural sites

### Tech Stack
- **Backend:** PHP 8.1+ with Slim Framework, Eloquent ORM
- **Frontend:** HTML5, Bootstrap 5.3, jQuery 3.7
- **Database:** MySQL 8.0+ (XAMPP)
- **Testing:** Playwright (E2E)
- **Authentication:** JWT

---

## System Architecture

```
┌─────────────────┐
│   Browser       │
│  (Frontend)     │
└────────┬────────┘
         │ HTTP/HTTPS
         ▼
┌─────────────────┐
│  Apache/XAMPP   │
│  (index.php)    │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌────────────┐
│Static  │ │  Backend   │
│Files   │ │  (Port 8000)│
└────────┘ └─────┬──────┘
                 │
                 ▼
          ┌────────────┐
          │  MySQL     │
          │  (tarombo) │
          └────────────┘
```

### Key Components

1. **Frontend Router** (`index.php`): Routes requests to static files or proxies API calls
2. **Backend API** (`backend/public/index.php`): REST API on port 8000
3. **Database** (`database/`): MySQL schema, migrations, and exports
4. **Tests** (`tests/`): Playwright E2E tests

---

## Development Environment Setup

### Prerequisites
- PHP 8.1+ with Composer
- MySQL 8.0+ (XAMPP recommended)
- Node.js 18+ with npm
- Git

### Step 1: Clone Repository

```bash
git clone https://github.com/82080038/tarombo.git
cd /opt/lampp/htdocs/tarombo
```

### Step 2: Install Backend Dependencies

```bash
cd backend
composer install
cp .env.example .env
# Edit .env if needed (defaults work for XAMPP)
```

### Step 3: Setup Database

```bash
# Import schema
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/schema.sql

# Import seed data
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/seeds.sql

# Or import latest export
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/tarombo_export_*.sql
```

### Step 4: Install Test Dependencies

```bash
cd tests
npm install
npx playwright install
```

### Step 5: Start Development Servers

**Terminal 1 - Backend API:**
```bash
cd /opt/lampp/htdocs/tarombo/backend
php -S localhost:8000 -t public/
```

**Terminal 2 - Frontend (if not using Apache):**
```bash
cd /opt/lampp/htdocs/tarombo
php -S localhost:8080
```

**Access the application:**
- With Apache: `http://localhost/tarombo/`
- With PHP server: `http://localhost:8080/`

---

## Database Management

### Database Configuration

Location: `backend/config/database.php`

```php
$capsule->addConnection([
    'driver'    => 'mysql',
    'host'      => 'localhost',
    'database'  => 'tarombo',
    'username'  => 'root',
    'password'  => '',
    'unix_socket' => '/opt/lampp/var/mysql/mysql.sock', // XAMPP socket
]);
```

### Export Database

```bash
mysqldump -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo > database/tarombo_export_$(date +%Y%m%d_%H%M%S).sql
```

### Import Database

```bash
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/tarombo_export_YYYYMMDD_HHMMSS.sql
```

### Database Schema

Key tables:
- `persons` - Family members
- `marga` - Clan names
- `marriages` - Marriage records
- `users` - System users
- `assets` - Family assets
- `transactions` - Financial transactions
- `tanah_ulayat` - Customary land
- `traditions` - Cultural traditions
- `stories` - Family stories

See `database/schema.sql` for complete schema.

---

## Code Structure

### Backend Structure

```
backend/
├── config/
│   └── database.php          # Database configuration
├── public/
│   └── index.php              # API entry point
├── src/
│   ├── Controllers/           # API endpoint handlers
│   │   ├── PersonController.php
│   │   ├── AuthController.php
│   │   └── ...
│   ├── Models/                # Eloquent models
│   │   ├── Person.php
│   │   ├── Marga.php
│   │   └── ...
│   ├── Services/              # Business logic
│   │   ├── PartuturanService.php
│   │   └── AuditService.php
│   └── Middleware/            # Request processing
│       ├── AuthMiddleware.php
│       └── CorsMiddleware.php
├── composer.json
└── .env.example
```

### Frontend Structure

```
frontend/
├── css/
│   └── style.css              # Custom styles
├── js/
│   ├── api.js                 # API client
│   ├── auth-nav.js            # Authentication navigation
│   ├── persons.js             # Persons page logic
│   ├── family-tree.js         # Family tree visualization
│   └── partuturan.js          # Partuturan calculator
├── includes/
│   ├── header.php             # Common header
│   ├── footer.php             # Common footer
│   └── menu.php               # Navigation menu
├── index.html                 # Homepage
├── persons.html              # Persons list
├── family-tree.html           # Family tree page
├── partuturan.html            # Partuturan calculator
└── login.html                 # Login page
```

---

## API Development

### Adding a New Endpoint

1. **Create Controller Method** in `backend/src/Controllers/`

```php
public function getSomething(Request $request, Response $response, array $args) {
    $id = $args['id'];
    $data = Model::find($id);
    
    if (!$data) {
        $response->getBody()->write(json_encode([
            'success' => false,
            'error' => ['code' => 'NOT_FOUND', 'message' => 'Resource not found']
        ]));
        return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
    }
    
    $response->getBody()->write(json_encode(['success' => true, 'data' => $data]));
    return $response->withHeader('Content-Type', 'application/json');
}
```

2. **Register Route** in `backend/public/index.php`

```php
$app->get('/api/v1/something/{id}', [SomethingController::class, 'getSomething']);
```

3. **Add Authentication** (if needed)

```php
$app->group('/api/v1/protected', function (RouteCollectorProxy $group) {
    $group->get('/something', [SomethingController::class, 'getSomething']);
})->add(new AuthMiddleware());
```

### API Response Format

**Success:**
```json
{
  "success": true,
  "data": { ... }
}
```

**Error:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description"
  }
}
```

---

## Frontend Development

### Adding a New Page

1. **Create HTML/PHP file** in `frontend/`

```php
<?php
$extraJs = 'newpage';
include 'includes/header.php';
?>
<!-- Page content -->
<?php include 'includes/footer.php'; ?>
```

2. **Create JavaScript file** in `frontend/js/`

```javascript
$(document).ready(function() {
    // Page logic
});
```

3. **Add navigation link** in `frontend/includes/menu.php`

### API Calls

Use the `API` object from `js/api.js`:

```javascript
// GET request
API.getPersons().then(function(data) {
    console.log(data);
});

// POST request
API.createPerson(personData).then(function(data) {
    console.log(data);
});
```

---

## Testing

### Running Tests

```bash
cd tests

# Headed mode (browser visible)
npm run test:headed

# Headless mode
npm run test

# UI mode (interactive)
npm run test:ui

# Specific test file
npx playwright test e2e/persons.spec.ts --headed
```

### Writing Tests

Create test file in `tests/e2e/`:

```typescript
import { test, expect } from '@playwright/test'

test.describe('New Feature', () => {
  test('should do something', async ({ page }) => {
    await page.goto('newpage.html')
    await expect(page.locator('h1')).toContainText('Title')
  })
})
```

---

## Deployment

### Production Deployment

1. **Environment Variables:**
   - Set `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS` in `.env`
   - Disable quick login in production
   - Set `APP_ENV=production`

2. **Database:**
   - Import production database schema
   - Run migrations if needed

3. **Web Server:**
   - Configure Apache virtual host
   - Point DocumentRoot to project directory
   - Enable mod_rewrite

4. **Backend:**
   - Configure production PHP server
   - Set up process manager (systemd/supervisor)

---

## Common Tasks

### Add New Database Table

1. Create migration in `database/migrations/`
2. Update `database/schema.sql`
3. Create Eloquent model in `backend/src/Models/`
4. Create controller in `backend/src/Controllers/`
5. Add API routes
6. Create frontend page
7. Write tests

### Fix Authentication Issues

1. Check JWT token in localStorage
2. Verify token format: `header.payload.signature`
3. Check `backend/src/Middleware/AuthMiddleware.php`
4. Ensure API calls include `Authorization: Bearer {token}` header

### Debug API Issues

1. Check backend server is running on port 8000
2. Check database connection in `backend/config/database.php`
3. Enable error logging in PHP
4. Check browser console for network errors

---

## Troubleshooting

### Backend Not Starting

**Problem:** `php -S localhost:8000` fails

**Solutions:**
- Check port 8000 is not in use: `lsof -i :8000`
- Verify PHP is installed: `php --version`
- Check file permissions

### Database Connection Failed

**Problem:** "Can't connect to local MySQL server"

**Solutions:**
- Verify MySQL is running: `sudo /opt/lampp/lampp start`
- Check socket path: `/opt/lampp/var/mysql/mysql.sock`
- Verify credentials in `backend/config/database.php`

### Frontend Not Loading

**Problem:** 404 errors or blank pages

**Solutions:**
- Check Apache/XAMPP is running
- Verify `.htaccess` is present
- Check file permissions
- Ensure backend API is running on port 8000

### Tests Failing

**Problem:** Playwright tests timeout or fail

**Solutions:**
- Ensure backend is running on port 8000
- Check baseURL in `tests/playwright.config.ts`
- Increase timeout in test if needed
- Run tests in headed mode to see what's happening

---

## Resources

### Documentation
- [README.md](README.md) - Project overview
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Detailed project summary
- [docs/](docs/) - Comprehensive documentation
- [RUN_TESTS.md](RUN_TESTS.md) - Testing guide

### Business Rules
- [BUSINESS_RULE.md](docs/BUSINESS_RULE.md) - All business rules
- [USE_CASE.md](docs/USE_CASE.md) - Use cases

### API Documentation
- [API_SPECIFICATION.md](docs/API_SPECIFICATION.md) - API endpoints

### Learning
- [LEARNING_GUIDE.md](docs/LEARNING_GUIDE.md) - Learning curriculum
- [IMPLEMENTATION_GUIDE.md](docs/IMPLEMENTATION_GUIDE.md) - Implementation guide

---

## Contact & Support

For questions or issues:
1. Check this guide first
2. Review documentation in `docs/`
3. Check existing GitHub issues
4. Create new issue with detailed description

---

**Motto:** *"Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."*

© 2026 Tarombo Digital Project
