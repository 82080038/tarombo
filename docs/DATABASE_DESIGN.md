# DATABASE DESIGN
## Desain Database Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Database Architecture](#1-database-architecture)
2. [Physical Data Model](#2-physical-data-model)
3. [Table Specifications](#3-table-specifications)
4. [Index Strategy](#4-index-strategy)
5. [Partitioning Strategy](#5-partitioning-strategy)

---

## 1. DATABASE ARCHITECTURE

### 1.1 Arsitektur Database

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        DATABASE ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    PRIMARY DATABASE (PostgreSQL)                     │   │
│  │                                                                     │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │   │
│  │  │   SCHEMA     │  │   SCHEMA     │  │   SCHEMA     │             │   │
│  │  │  tarombo_core│  │  tarombo_auth│  │  tarombo_adat│             │   │
│  │  │              │  │              │  │              │             │   │
│  │  │ • person     │  │ • user       │  │ • ceremony   │             │   │
│  │  │ • marga      │  │ • role       │  │ • ulos       │             │   │
│  │  │ • marriage   │  │ • permission │  │ • stage      │             │   │
│  │  │ • family_rel │  │ • audit_log  │  │ • tradition  │             │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘             │   │
│  │                                                                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│         ┌──────────────────────────┼──────────────────────────┐              │
│         │                          │                          │              │
│         ▼                          ▼                          ▼              │
│  ┌──────────────┐          ┌──────────────┐          ┌──────────────┐      │
│  │    CACHE     │          │    SEARCH    │          │    FILE      │      │
│  │    REDIS     │          │   ELASTIC    │          │   STORAGE    │      │
│  │              │          │   SEARCH     │          │   (MinIO/S3) │      │
│  │ • Session    │          │              │          │              │      │
│  │ • Query cache│          │ • Full-text  │          │ • Photos     │      │
│  │ • Rate limit │          │ • Facets     │          │ • Documents  │      │
│  └──────────────┘          └──────────────┘          └──────────────┘      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Database Selection

| Komponen | Teknologi | Alasan Pemilihan |
|----------|-----------|------------------|
| **Primary Database** | PostgreSQL 15+ | ACID compliance, JSON support, CTE untuk recursive queries |
| **Cache Layer** | Redis 7+ | Session management, query result caching |
| **Search Engine** | Elasticsearch 8+ | Full-text search, faceted search, fuzzy matching |
| **File Storage** | MinIO / AWS S3 | Object storage untuk foto dan dokumen |
| **Message Queue** | RabbitMQ / Redis Streams | Async processing, event-driven architecture |

### 1.3 Schema Design

| Schema | Purpose | Tables |
|--------|---------|--------|
| `tarombo_core` | Data inti kekerabatan | person, marga, sub_marga, marriage, family_rel |
| `tarombo_auth` | Autentikasi dan otorisasi | user, role, permission, user_role, audit_log |
| `tarombo_adat` | Data adat dan upacara | ceremony, ulos_distribution, marriage_stage, tradition_config |
| `tarombo_reference` | Data referensi | marga_prohibition, sub_suku_config, partuturan_rules |

---

## 2. PHYSICAL DATA MODEL

### 2.1 Table Structure Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TABLE RELATIONSHIP MAP                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  tarombo_core.person                                                        │
│  ├── person_id (PK, UUID)                                                   │
│  ├── full_name (VARCHAR 100)                                                │
│  ├── gender (ENUM)                                                          │
│  ├── birth_date (DATE)                                                      │
│  ├── marga_id (FK → marga)                                                  │
│  ├── father_id (FK → person, self-ref)                                      │
│  ├── mother_id (FK → person, self-ref)                                      │
│  └── generation_number (INTEGER, computed)                                  │
│                                                                             │
│  tarombo_core.marga                                                         │
│  ├── marga_id (PK, UUID)                                                    │
│  ├── marga_name (VARCHAR 50, UNIQUE)                                        │
│  ├── sub_suku (ENUM)                                                          │
│  ├── ancestor_name (VARCHAR 50)                                               │
│  └── is_active (BOOLEAN)                                                      │
│                                                                             │
│  tarombo_core.marriage                                                      │
│  ├── marriage_id (PK, UUID)                                                 │
│  ├── husband_id (FK → person)                                               │
│  ├── wife_id (FK → person)                                                  │
│  ├── marriage_date (DATE)                                                   │
│  ├── sinamot_amount (DECIMAL)                                                 │
│  └── status (ENUM)                                                          │
│                                                                             │
│  tarombo_auth.user                                                          │
│  ├── user_id (PK, UUID)                                                     │
│  ├── person_id (FK → person, nullable)                                      │
│  ├── email (VARCHAR 100, UNIQUE)                                              │
│  ├── password_hash (VARCHAR 255)                                              │
│  └── role (ENUM)                                                              │
│                                                                             │
│  tarombo_adat.marriage_stage                                                │
│  ├── stage_id (PK, UUID)                                                    │
│  ├── marriage_id (FK → marriage)                                            │
│  ├── stage_name (ENUM)                                                        │
│  ├── stage_date (DATE)                                                        │
│  └── status (ENUM)                                                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. TABLE SPECIFICATIONS

### 3.1 Core Tables

#### Table: `tarombo_core.person`

```sql
CREATE TABLE tarombo_core.person (
    -- Primary Key
    person_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Basic Information
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    birth_date DATE,
    birth_place VARCHAR(100),
    death_date DATE,
    death_place VARCHAR(100),
    
    -- Cultural Identity
    marga_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    sub_suku VARCHAR(20) CHECK (sub_suku IN ('TOBA', 'KARO', 'SIM', 'MAN', 'ANG', 'PAK')),
    
    -- Family Relationships (Recursive)
    father_id UUID REFERENCES tarombo_core.person(person_id),
    mother_id UUID REFERENCES tarombo_core.person(person_id),
    
    -- Computed/Cache Fields
    generation_number INTEGER GENERATED ALWAYS AS (
        CASE 
            WHEN father_id IS NULL THEN 1
            ELSE (SELECT generation_number + 1 
                  FROM tarombo_core.person p 
                  WHERE p.person_id = tarombo_core.person.father_id)
        END
    ) STORED,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES tarombo_auth.user(user_id),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'DECEASED', 'DELETED')),
    
    -- Constraints
    CONSTRAINT no_self_parent CHECK (
        person_id != father_id AND person_id != mother_id
    ),
    CONSTRAINT valid_death CHECK (
        death_date IS NULL OR death_date > birth_date
    )
);

-- Indexes
CREATE INDEX idx_person_marga ON tarombo_core.person(marga_id);
CREATE INDEX idx_person_father ON tarombo_core.person(father_id);
CREATE INDEX idx_person_mother ON tarombo_core.person(mother_id);
CREATE INDEX idx_person_name ON tarombo_core.person USING gin(to_tsvector('indonesian', full_name));
CREATE INDEX idx_person_birth_date ON tarombo_core.person(birth_date);
CREATE INDEX idx_person_status ON tarombo_core.person(status) WHERE status = 'ACTIVE';
```

#### Table: `tarombo_core.marga`

```sql
CREATE TABLE tarombo_core.marga (
    marga_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marga_name VARCHAR(50) NOT NULL UNIQUE,
    sub_suku VARCHAR(20) NOT NULL CHECK (sub_suku IN ('TOBA', 'KARO', 'SIM', 'MAN', 'ANG', 'PAK')),
    
    -- Cultural Information
    ancestor_name VARCHAR(50),
    ancestor_story TEXT,
    
    -- Status
    is_active BOOLEAN DEFAULT TRUE,
    verified_by UUID REFERENCES tarombo_auth.user(user_id),
    verification_date TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_marga_name ON tarombo_core.marga(marga_name);
CREATE INDEX idx_marga_sub_suku ON tarombo_core.marga(sub_suku);
CREATE INDEX idx_marga_active ON tarombo_core.marga(is_active) WHERE is_active = TRUE;
```

#### Table: `tarombo_core.sub_marga`

```sql
CREATE TABLE tarombo_core.sub_marga (
    sub_marga_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_marga_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    sub_marga_name VARCHAR(50) NOT NULL,
    ancestor_name VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_sub_per_parent UNIQUE(parent_marga_id, sub_marga_name)
);

CREATE INDEX idx_sub_marga_parent ON tarombo_core.sub_marga(parent_marga_id);
```

#### Table: `tarombo_core.marriage`

```sql
CREATE TABLE tarombo_core.marriage (
    marriage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Spouses
    husband_id UUID NOT NULL REFERENCES tarombo_core.person(person_id),
    wife_id UUID NOT NULL REFERENCES tarombo_core.person(person_id),
    
    -- Marriage Details
    marriage_date DATE NOT NULL,
    marriage_place VARCHAR(100),
    marriage_type VARCHAR(20) DEFAULT 'COMBINED' 
        CHECK (marriage_type IN ('TRADITIONAL', 'CIVIL', 'RELIGIOUS', 'COMBINED')),
    
    -- Sinamot (traditional dowry)
    sinamot_amount DECIMAL(15, 2),
    sinamot_details TEXT,
    
    -- Status
    status VARCHAR(20) DEFAULT 'ACTIVE' 
        CHECK (status IN ('ACTIVE', 'DIVORCED', 'ANNULLED', 'WIDOWED')),
    notes TEXT,
    
    -- Metadata
    created_by UUID REFERENCES tarombo_auth.user(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT no_self_marriage CHECK (husband_id != wife_id),
    CONSTRAINT unique_active_marriage_per_wife 
        UNIQUE (wife_id, status) 
        DEFERRABLE INITIALLY DEFERRED
);

-- Indexes
CREATE INDEX idx_marriage_husband ON tarombo_core.marriage(husband_id);
CREATE INDEX idx_marriage_wife ON tarombo_core.marriage(wife_id);
CREATE INDEX idx_marriage_date ON tarombo_core.marriage(marriage_date);
CREATE INDEX idx_marriage_status ON tarombo_core.marriage(status);
```

### 3.2 Authentication Tables

#### Table: `tarombo_auth.user`

```sql
CREATE TABLE tarombo_auth.user (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Link to person (optional)
    person_id UUID UNIQUE REFERENCES tarombo_core.person(person_id),
    
    -- Credentials
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    
    -- Profile
    full_name VARCHAR(100),
    sub_suku VARCHAR(20) CHECK (sub_suku IN ('TOBA', 'KARO', 'SIM', 'MAN', 'ANG', 'PAK')),
    
    -- Role & Status
    role VARCHAR(30) DEFAULT 'USER' 
        CHECK (role IN ('USER', 'VERIFIED_USER', 'TETUA_ADAT', 'RAJA_PARHATA', 
                       'ADMIN_BUDAYA', 'ADMIN_SISTEM')),
    status VARCHAR(20) DEFAULT 'DRAFT' 
        CHECK (status IN ('DRAFT', 'SELF_VERIFIED', 'IDENTITY_PENDING', 
                         'VERIFIED', 'SUSPENDED', 'DELETED')),
    
    -- Security
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    last_login TIMESTAMP WITH TIME ZONE,
    last_ip_address INET,
    
    -- 2FA
    totp_secret VARCHAR(255),
    totp_enabled BOOLEAN DEFAULT FALSE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_user_email ON tarombo_auth.user(email);
CREATE INDEX idx_user_role ON tarombo_auth.user(role);
CREATE INDEX idx_user_status ON tarombo_auth.user(status);
CREATE INDEX idx_user_person ON tarombo_auth.user(person_id) WHERE person_id IS NOT NULL;
```

#### Table: `tarombo_auth.audit_log`

```sql
CREATE TABLE tarombo_auth.audit_log (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Target Entity
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    person_id UUID REFERENCES tarombo_core.person(person_id),
    
    -- Action Details
    action VARCHAR(20) NOT NULL CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'VALIDATE', 'MERGE', 'RESTORE')),
    field_name VARCHAR(50),
    old_value TEXT,
    new_value TEXT,
    
    -- Actor
    actor_id UUID REFERENCES tarombo_auth.user(user_id),
    actor_role VARCHAR(30),
    
    -- Context
    ip_address INET,
    user_agent TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Partitioning key
    log_date DATE DEFAULT CURRENT_DATE
) PARTITION BY RANGE (log_date);

-- Create partitions (monthly)
CREATE TABLE tarombo_auth.audit_log_2026_01 PARTITION OF tarombo_auth.audit_log
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE tarombo_auth.audit_log_2026_02 PARTITION OF tarombo_auth.audit_log
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
-- ... continue for all months

-- Indexes
CREATE INDEX idx_audit_entity ON tarombo_auth.audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_person ON tarombo_auth.audit_log(person_id);
CREATE INDEX idx_audit_actor ON tarombo_auth.audit_log(actor_id);
CREATE INDEX idx_audit_timestamp ON tarombo_auth.audit_log(timestamp);
CREATE INDEX idx_audit_action ON tarombo_auth.audit_log(action, entity_type);
```

### 3.3 Adat/Ceremony Tables

#### Table: `tarombo_adat.marriage_stage`

```sql
CREATE TABLE tarombo_adat.marriage_stage (
    stage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marriage_id UUID NOT NULL REFERENCES tarombo_core.marriage(marriage_id) ON DELETE CASCADE,
    
    stage_name VARCHAR(30) NOT NULL 
        CHECK (stage_name IN ('MANGARISIKA', 'MARTUMPOL', 'MARTONGGO_RAJA', 
                             'MARSIBUHA_BUHAI', 'PEMBERKATAN', 'MANGULOSI', 'PAULAK_UNE')),
    stage_date DATE,
    stage_location VARCHAR(100),
    
    status VARCHAR(20) DEFAULT 'PENDING' 
        CHECK (status IN ('PENDING', 'COMPLETED', 'SKIPPED', 'CANCELLED')),
    
    details JSONB, -- Flexible storage for stage-specific data
    
    documented_by UUID REFERENCES tarombo_auth.user(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_stage_per_marriage UNIQUE(marriage_id, stage_name)
);

CREATE INDEX idx_marriage_stage_marriage ON tarombo_adat.marriage_stage(marriage_id);
CREATE INDEX idx_marriage_stage_name ON tarombo_adat.marriage_stage(stage_name);
CREATE INDEX idx_marriage_stage_date ON tarombo_adat.marriage_stage(stage_date);
```

#### Table: `tarombo_adat.ulos_distribution`

```sql
CREATE TABLE tarombo_adat.ulos_distribution (
    distribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marriage_id UUID NOT NULL REFERENCES tarombo_core.marriage(marriage_id) ON DELETE CASCADE,
    
    ulos_type VARCHAR(30) NOT NULL 
        CHECK (ulos_type IN ('PASAMOT', 'HELA', 'PAMARAI', 'SIMANDOKKON', 'NAMBORUNYA',
                            'PARIBAN', 'HULA_HULA', 'TULANG', 'BONA_TULANG', 'TULANG_ROROBOT',
                            'BONA_TULANG_PARANAK', 'TULANG_ROROBOT_PARANAK', 'OTHER')),
    
    from_person_id UUID REFERENCES tarombo_core.person(person_id),
    to_person_id UUID REFERENCES tarombo_core.person(person_id),
    from_side VARCHAR(20) CHECK (from_side IN ('PARBORU', 'PARANAK')),
    
    is_mandatory BOOLEAN DEFAULT FALSE,
    description TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ulos_marriage ON tarombo_adat.ulos_distribution(marriage_id);
CREATE INDEX idx_ulos_from ON tarombo_adat.ulos_distribution(from_person_id);
CREATE INDEX idx_ulos_to ON tarombo_adat.ulos_distribution(to_person_id);
CREATE INDEX idx_ulos_type ON tarombo_adat.ulos_distribution(ulos_type);
```

### 3.4 Reference Tables

#### Table: `tarombo_reference.marga_prohibition`

```sql
CREATE TABLE tarombo_reference.marga_prohibition (
    prohibition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marga_1_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    marga_2_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    
    prohibition_type VARCHAR(20) DEFAULT 'ABSOLUTE' 
        CHECK (prohibition_type IN ('ABSOLUTE', 'CONDITIONAL')),
    reason TEXT NOT NULL,
    effective_date DATE DEFAULT CURRENT_DATE,
    
    verified_by UUID REFERENCES tarombo_auth.user(user_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT different_margas CHECK (marga_1_id != marga_2_id),
    CONSTRAINT unique_prohibition UNIQUE(marga_1_id, marga_2_id)
);

CREATE INDEX idx_prohibition_m1 ON tarombo_reference.marga_prohibition(marga_1_id);
CREATE INDEX idx_prohibition_m2 ON tarombo_reference.marga_prohibition(marga_2_id);
```

---

## 4. INDEX STRATEGY

### 4.1 Index Summary

| Table | Index Name | Columns | Type | Purpose |
|-------|------------|---------|------|---------|
| person | idx_person_marga | marga_id | B-tree | Foreign key lookups |
| person | idx_person_father | father_id | B-tree | Tree traversal |
| person | idx_person_mother | mother_id | B-tree | Tree traversal |
| person | idx_person_name | full_name (GIN tsvector) | GIN | Full-text search |
| person | idx_person_birth_date | birth_date | B-tree | Range queries |
| person | idx_person_status | status (partial) | B-tree | Filter active |
| marga | idx_marga_name | marga_name | B-tree | Lookup by name |
| marga | idx_marga_sub_suku | sub_suku | B-tree | Filter by sub-suku |
| marriage | idx_marriage_husband | husband_id | B-tree | Spouse lookups |
| marriage | idx_marriage_wife | wife_id | B-tree | Spouse lookups |
| user | idx_user_email | email | B-tree | Login lookup |
| user | idx_user_role | role | B-tree | Role-based queries |
| audit_log | idx_audit_timestamp | timestamp | B-tree | Time-based queries |
| audit_log | idx_audit_entity | entity_type, entity_id | B-tree | Entity history |

### 4.2 Full-Text Search Configuration

```sql
-- Create Indonesian text search configuration
CREATE TEXT SEARCH CONFIGURATION indonesian (COPY = simple);

-- Add custom dictionary if needed
ALTER TEXT SEARCH CONFIGURATION indonesian
    ALTER MAPPING FOR asciiword, asciihword, hword_asciipart,
                      word, hword, hword_part
    WITH simple;

-- Create index for person name search
CREATE INDEX idx_person_name_search ON tarombo_core.person
    USING gin(to_tsvector('indonesian', full_name));
```

---

## 5. PARTITIONING STRATEGY

### 5.1 Partitioned Tables

| Table | Partition Key | Strategy | Partition Size |
|-------|---------------|----------|----------------|
| audit_log | log_date (DATE) | Range (monthly) | ~1M records/partition |
| person | created_at (YEAR) | Range (yearly) | Growth-based |

### 5.2 Partition Management

```sql
-- Automated partition creation function
CREATE OR REPLACE FUNCTION create_audit_partition()
RETURNS void AS $$
DECLARE
    partition_date DATE;
    partition_name TEXT;
    start_date DATE;
    end_date DATE;
BEGIN
    partition_date := DATE_TRUNC('month', CURRENT_DATE + INTERVAL '1 month');
    partition_name := 'audit_log_' || TO_CHAR(partition_date, 'YYYY_MM');
    start_date := partition_date;
    end_date := partition_date + INTERVAL '1 month';
    
    EXECUTE format('CREATE TABLE IF NOT EXISTS tarombo_auth.%I 
                  PARTITION OF tarombo_auth.audit_log
                  FOR VALUES FROM (%L) TO (%L)',
                  partition_name, start_date, end_date);
END;
$$ LANGUAGE plpgsql;

-- Schedule monthly partition creation
-- (Implementasi dengan pg_cron atau cron job eksternal)
```

---

## LAMPIRAN: Connection String & Configuration

### PostgreSQL Configuration (Recommended)

```
# Connection Pool Settings
max_connections = 200
shared_buffers = 2GB
effective_cache_size = 6GB
work_mem = 32MB
maintenance_work_mem = 512MB

# WAL Settings
wal_buffers = 16MB
max_wal_size = 2GB
min_wal_size = 512MB

# Query Planning
effective_io_concurrency = 200
random_page_cost = 1.1

# Logging
log_statement = 'ddl'
log_min_duration_statement = 1000
```

---

**Referensi:** ERD.md, SQL_SCHEMA.md (DDL lengkap)

© 2026 Tarombo Digital Project
