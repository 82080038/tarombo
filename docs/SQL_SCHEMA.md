# SQL SCHEMA
## Skema SQL Sistem Tarombo Digital (Core Tables)

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## 1. SETUP DATABASE

```sql
-- Create database
CREATE DATABASE tarombo_digital WITH ENCODING = 'UTF8';

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Create schemas
CREATE SCHEMA IF NOT EXISTS tarombo_core;
CREATE SCHEMA IF NOT EXISTS tarombo_auth;
CREATE SCHEMA IF NOT EXISTS tarombo_adat;
CREATE SCHEMA IF NOT EXISTS tarombo_reference;
```

---

## 2. CORE TABLES

### 2.1 Table: marga

```sql
CREATE TABLE tarombo_core.marga (
    marga_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marga_name VARCHAR(50) NOT NULL UNIQUE,
    sub_suku VARCHAR(20) NOT NULL CHECK (sub_suku IN ('TOBA', 'KARO', 'SIM', 'MAN', 'ANG', 'PAK')),
    ancestor_name VARCHAR(50),
    ancestor_story TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_marga_name ON tarombo_core.marga(marga_name);
CREATE INDEX idx_marga_sub_suku ON tarombo_core.marga(sub_suku);
```

### 2.2 Table: person

```sql
CREATE TABLE tarombo_core.person (
    person_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    birth_date DATE,
    birth_place VARCHAR(100),
    death_date DATE,
    death_place VARCHAR(100),
    marga_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    sub_suku VARCHAR(20) CHECK (sub_suku IN ('TOBA', 'KARO', 'SIM', 'MAN', 'ANG', 'PAK')),
    father_id UUID REFERENCES tarombo_core.person(person_id),
    mother_id UUID REFERENCES tarombo_core.person(person_id),
    generation_number INTEGER,
    photo_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'DECEASED', 'DELETED')),
    
    CONSTRAINT no_self_parent CHECK (person_id != father_id AND person_id != mother_id),
    CONSTRAINT valid_death CHECK (death_date IS NULL OR death_date >= birth_date)
);

CREATE INDEX idx_person_marga ON tarombo_core.person(marga_id);
CREATE INDEX idx_person_father ON tarombo_core.person(father_id);
CREATE INDEX idx_person_mother ON tarombo_core.person(mother_id);
CREATE INDEX idx_person_name ON tarombo_core.person USING gin(to_tsvector('simple', full_name));
CREATE INDEX idx_person_status ON tarombo_core.person(status) WHERE status = 'ACTIVE';
```

### 2.3 Table: marriage

```sql
CREATE TABLE tarombo_core.marriage (
    marriage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    husband_id UUID NOT NULL REFERENCES tarombo_core.person(person_id),
    wife_id UUID NOT NULL REFERENCES tarombo_core.person(person_id),
    marriage_date DATE NOT NULL,
    marriage_place VARCHAR(100),
    marriage_type VARCHAR(20) DEFAULT 'COMBINED' 
        CHECK (marriage_type IN ('TRADITIONAL', 'CIVIL', 'RELIGIOUS', 'COMBINED')),
    sinamot_amount DECIMAL(15, 2),
    sinamot_details TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE' 
        CHECK (status IN ('ACTIVE', 'DIVORCED', 'ANNULLED', 'WIDOWED')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT no_self_marriage CHECK (husband_id != wife_id),
    CONSTRAINT valid_divorce_date CHECK (divorce_date IS NULL OR divorce_date >= marriage_date)
);

CREATE INDEX idx_marriage_husband ON tarombo_core.marriage(husband_id);
CREATE INDEX idx_marriage_wife ON tarombo_core.marriage(wife_id);
CREATE INDEX idx_marriage_date ON tarombo_core.marriage(marriage_date);
CREATE UNIQUE INDEX idx_marriage_active_wife ON tarombo_core.marriage(wife_id) WHERE status = 'ACTIVE';
```

---

## 3. AUTH TABLES

### 3.1 Table: user

```sql
CREATE TABLE tarombo_auth.user (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID UNIQUE REFERENCES tarombo_core.person(person_id),
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    full_name VARCHAR(100),
    role VARCHAR(30) DEFAULT 'USER' 
        CHECK (role IN ('USER', 'VERIFIED_USER', 'TETUA_ADAT', 'RAJA_PARHATA', 'ADMIN_BUDAYA', 'ADMIN_SISTEM')),
    status VARCHAR(20) DEFAULT 'DRAFT' 
        CHECK (status IN ('DRAFT', 'SELF_VERIFIED', 'IDENTITY_PENDING', 'VERIFIED', 'SUSPENDED', 'DELETED')),
    failed_login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP WITH TIME ZONE,
    last_login TIMESTAMP WITH TIME ZONE,
    totp_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON tarombo_auth.user(email);
CREATE INDEX idx_user_role ON tarombo_auth.user(role);
CREATE INDEX idx_user_status ON tarombo_auth.user(status);
```

### 3.2 Table: audit_log

```sql
CREATE TABLE tarombo_auth.audit_log (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    person_id UUID REFERENCES tarombo_core.person(person_id),
    action VARCHAR(20) NOT NULL CHECK (action IN ('CREATE', 'UPDATE', 'DELETE', 'VALIDATE', 'MERGE', 'RESTORE')),
    field_name VARCHAR(50),
    old_value TEXT,
    new_value TEXT,
    actor_id UUID REFERENCES tarombo_auth.user(user_id),
    ip_address INET,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    log_date DATE DEFAULT CURRENT_DATE
);

CREATE INDEX idx_audit_entity ON tarombo_auth.audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_person ON tarombo_auth.audit_log(person_id);
CREATE INDEX idx_audit_actor ON tarombo_auth.audit_log(actor_id);
CREATE INDEX idx_audit_timestamp ON tarombo_auth.audit_log(timestamp);
```

---

## 4. ADAT TABLES

### 4.1 Table: marriage_stage

```sql
CREATE TABLE tarombo_adat.marriage_stage (
    stage_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marriage_id UUID NOT NULL REFERENCES tarombo_core.marriage(marriage_id) ON DELETE CASCADE,
    stage_name VARCHAR(30) NOT NULL 
        CHECK (stage_name IN ('MANGARISIKA', 'MARTUMPOL', 'MARTONGGO_RAJA', 
                             'MARSIBUHA_BUHAI', 'PEMBERKATAN', 'MANGULOSI', 'PAULAK_UNE')),
    stage_order INTEGER GENERATED ALWAYS AS (
        CASE stage_name
            WHEN 'MANGARISIKA' THEN 1 WHEN 'MARTUMPOL' THEN 2 WHEN 'MARTONGGO_RAJA' THEN 3
            WHEN 'MARSIBUHA_BUHAI' THEN 4 WHEN 'PEMBERKATAN' THEN 5 WHEN 'MANGULOSI' THEN 6
            WHEN 'PAULAK_UNE' THEN 7
        END
    ) STORED,
    stage_date DATE,
    stage_location VARCHAR(100),
    stage_details JSONB,
    status VARCHAR(20) DEFAULT 'PENDING' 
        CHECK (status IN ('PENDING', 'COMPLETED', 'SKIPPED', 'CANCELLED')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT unique_stage_per_marriage UNIQUE(marriage_id, stage_name)
);

CREATE INDEX idx_marriage_stage_marriage ON tarombo_adat.marriage_stage(marriage_id);
CREATE INDEX idx_marriage_stage_name ON tarombo_adat.marriage_stage(stage_name);
```

### 4.2 Table: ulos_distribution

```sql
CREATE TABLE tarombo_adat.ulos_distribution (
    distribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marriage_id UUID NOT NULL REFERENCES tarombo_core.marriage(marriage_id) ON DELETE CASCADE,
    ulos_type VARCHAR(30) NOT NULL 
        CHECK (ulos_type IN ('PASAMOT', 'HELA', 'PAMARAI', 'SIMANDOKKON', 'NAMBORUNYA',
                            'PARIBAN', 'HULA_HULA', 'TULANG', 'BONA_TULANG', 'TULANG_ROROBOT', 'OTHER')),
    from_person_id UUID REFERENCES tarombo_core.person(person_id),
    to_person_id UUID REFERENCES tarombo_core.person(person_id),
    from_side VARCHAR(20) CHECK (from_side IN ('PARBORU', 'PARANAK')),
    is_mandatory BOOLEAN DEFAULT FALSE,
    was_given BOOLEAN DEFAULT FALSE,
    pasu_pasu TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ulos_marriage ON tarombo_adat.ulos_distribution(marriage_id);
CREATE INDEX idx_ulos_type ON tarombo_adat.ulos_distribution(ulos_type);
```

---

## 5. REFERENCE TABLES

### 5.1 Table: marga_prohibition

```sql
CREATE TABLE tarombo_reference.marga_prohibition (
    prohibition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    marga_1_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    marga_2_id UUID NOT NULL REFERENCES tarombo_core.marga(marga_id),
    prohibition_type VARCHAR(20) DEFAULT 'ABSOLUTE' CHECK (prohibition_type IN ('ABSOLUTE', 'CONDITIONAL')),
    reason TEXT NOT NULL,
    effective_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT different_margas CHECK (marga_1_id != marga_2_id),
    CONSTRAINT unique_prohibition UNIQUE(marga_1_id, marga_2_id)
);

CREATE INDEX idx_prohibition_m1 ON tarombo_reference.marga_prohibition(marga_1_id);
CREATE INDEX idx_prohibition_m2 ON tarombo_reference.marga_prohibition(marga_2_id);
```

---

## 6. FUNCTIONS & TRIGGERS

### 6.1 Calculate Generation

```sql
CREATE OR REPLACE FUNCTION tarombo_core.calculate_generation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.father_id IS NULL THEN
        NEW.generation_number := 1;
    ELSE
        SELECT generation_number + 1 INTO NEW.generation_number
        FROM tarombo_core.person WHERE person_id = NEW.father_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calculate_generation
    BEFORE INSERT OR UPDATE OF father_id ON tarombo_core.person
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.calculate_generation();
```

### 6.2 Inherit Marga

```sql
CREATE OR REPLACE FUNCTION tarombo_core.inherit_marga()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.father_id IS NOT NULL AND NEW.marga_id IS NULL THEN
        SELECT marga_id INTO NEW.marga_id
        FROM tarombo_core.person WHERE person_id = NEW.father_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inherit_marga
    BEFORE INSERT ON tarombo_core.person
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.inherit_marga();
```

### 6.3 Check Marriage Prohibition

```sql
CREATE OR REPLACE FUNCTION tarombo_core.check_marriage_prohibition()
RETURNS TRIGGER AS $$
DECLARE
    v_husband_marga UUID;
    v_wife_marga UUID;
    v_prohibition_exists BOOLEAN;
BEGIN
    SELECT marga_id INTO v_husband_marga FROM tarombo_core.person WHERE person_id = NEW.husband_id;
    SELECT marga_id INTO v_wife_marga FROM tarombo_core.person WHERE person_id = NEW.wife_id;
    
    IF v_husband_marga = v_wife_marga THEN
        RAISE EXCEPTION 'Perkawinan sesama marga tidak diperbolehkan';
    END IF;
    
    SELECT EXISTS(
        SELECT 1 FROM tarombo_reference.marga_prohibition
        WHERE (marga_1_id = v_husband_marga AND marga_2_id = v_wife_marga)
           OR (marga_1_id = v_wife_marga AND marga_2_id = v_husband_marga)
    ) INTO v_prohibition_exists;
    
    IF v_prohibition_exists THEN
        RAISE EXCEPTION 'Perkawinan antara marga ini dilarang menurut adat';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_marriage_prohibition
    BEFORE INSERT OR UPDATE OF husband_id, wife_id ON tarombo_core.marriage
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.check_marriage_prohibition();
```

### 6.4 Update Timestamp

```sql
CREATE OR REPLACE FUNCTION tarombo_core.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_timestamp BEFORE UPDATE ON tarombo_core.person
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.update_timestamp();
CREATE TRIGGER trg_marga_timestamp BEFORE UPDATE ON tarombo_core.marga
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.update_timestamp();
CREATE TRIGGER trg_marriage_timestamp BEFORE UPDATE ON tarombo_core.marriage
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.update_timestamp();
CREATE TRIGGER trg_user_timestamp BEFORE UPDATE ON tarombo_auth.user
    FOR EACH ROW EXECUTE FUNCTION tarombo_core.update_timestamp();
```

---

## 7. SEED DATA (Sample)

```sql
-- Sample marga Batak Toba
INSERT INTO tarombo_core.marga (marga_name, sub_suku, is_active) VALUES
('Simanjuntak', 'TOBA', TRUE),
('Sinaga', 'TOBA', TRUE),
('Siregar', 'TOBA', TRUE),
('Nainggolan', 'TOBA', TRUE),
('Panjaitan', 'TOBA', TRUE),
('Tampubolon', 'TOBA', TRUE),
('Lubis', 'TOBA', TRUE),
('Sitorus', 'TOBA', TRUE),
('Marbun', 'TOBA', TRUE),
('Sihotang', 'TOBA', TRUE);

-- Sample larangan
INSERT INTO tarombo_reference.marga_prohibition (marga_1_id, marga_2_id, prohibition_type, reason)
SELECT m1.marga_id, m2.marga_id, 'ABSOLUTE', 'Larangan adat turun-temurun'
FROM tarombo_core.marga m1, tarombo_core.marga m2
WHERE m1.marga_name = 'Marbun' AND m2.marga_name = 'Sihotang';

INSERT INTO tarombo_reference.marga_prohibition (marga_1_id, marga_2_id, prohibition_type, reason)
SELECT m1.marga_id, m2.marga_id, 'ABSOLUTE', 'Larangan adat turun-temurun'
FROM tarombo_core.marga m1, tarombo_core.marga m2
WHERE m1.marga_name = 'Nainggolan' AND m2.marga_name = 'Siregar';
```

---

**Referensi:** DATABASE_DESIGN.md, ERD.md

© 2026 Tarombo Digital Project
