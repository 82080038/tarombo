# Database Files

This directory contains database schema, migrations, and exports for the Tarombo Digital application.

## Files

### Schema Files
- `schema.sql` - Basic database schema
- `schema_updated.sql` - Updated schema with comprehensive tables
- `init.sql` - Initial database setup with seed data

### Migrations
- `migrations/` - Database migration files for version control

### Seeds
- `seeds.sql` - Seed data for testing and development

### Exports
- `tarombo_export_YYYYMMDD_HHMMSS.sql` - Latest database export (timestamped)

## Importing Database

```bash
# Using MySQL command line
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/schema.sql
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/seeds.sql

# Or import the latest export
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo < database/tarombo_export_*.sql
```

## Exporting Database

```bash
# Export current database
mysqldump -u root -p --socket=/opt/lampp/var/mysql/mysql.sock tarombo > database/tarombo_export_$(date +%Y%m%d_%H%M%S).sql
```

## Database Configuration

Database connection is configured in `backend/config/database.php`:
- Host: localhost
- Database: tarombo
- User: root
- Socket: /opt/lampp/var/mysql/mysql.sock (XAMPP)
