# ENTITY RELATIONSHIP DIAGRAM
## Diagram Hubungan Entitas Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Overview Diagram](#1-overview-diagram)
2. [Entity Relationship Detail](#2-entity-relationship-detail)
3. [Diagram Sub-Sistem](#3-diagram-sub-sistem)
4. [Relationship Matrix](#4-relationship-matrix)

---

## 1. OVERVIEW DIAGRAM

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ENTITY RELATIONSHIP OVERVIEW                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌───────────────┐         ┌───────────────┐         ┌───────────────┐     │
│  │     USER      │◄───────►│    PERSON     │◄───────►│     MARGA     │     │
│  │   ├─ user_id  │    1:1 │   ├─ person_id │    N:1  │   ├─ marga_id │     │
│  │   ├─ email    │         │   ├─ full_name│         │   ├─ name     │     │
│  │   ├─ password │         │   ├─ gender   │         │   └─ sub_suku │     │
│  │   └─ role     │         │   └─ birth_date│        └───────────────┘     │
│  └───────────────┘         └───────┬───────┘                │               │
│                                    │                        │               │
│                                    │ 1:N                    │               │
│                                    ▼                        ▼               │
│                           ┌───────────────┐         ┌───────────────┐       │
│                           │  MARRIAGE     │         │  SUB_MARGA    │       │
│                           │  ├─ marriage_id│         │  ├─ sub_id    │       │
│                           │  ├─ husband_id│         │  ├─ name      │       │
│                           │  ├─ wife_id   │         │  └─ parent_id │       │
│                           │  └─ date      │         └───────────────┘       │
│                           └───────┬───────┘                                 │
│                                   │                                         │
│                                   │ 1:N                                     │
│                                   ▼                                         │
│                           ┌───────────────┐                                 │
│                           │MARRIAGE_STAGE  │                                 │
│                           │  ├─ stage_id   │                                 │
│                           │  ├─ stage_name │                                 │
│                           │  └─ status     │                                 │
│                           └───────────────┘                                 │
│                                                                             │
│  ┌───────────────┐         ┌───────────────┐         ┌───────────────┐     │
│  │  CEREMONY     │◄───────►│   PERSON      │◄───────►│  VALIDATION   │     │
│  │  ├─ ceremony_id│    N:M  │               │   1:N   │  ├─ val_id    │     │
│  │  ├─ type      │         │               │         │  ├─ level     │     │
│  │  └─ date      │         │               │         │  └─ status    │     │
│  └───────────────┘         └───────────────┘         └───────────────┘     │
│                                                                             │
│  ┌───────────────┐         ┌───────────────┐                               │
│  │  AUDIT_LOG    │────────►│    PERSON     │                               │
│  │  ├─ log_id    │    N:1  │               │                               │
│  │  ├─ action    │         │               │                               │
│  │  └─ timestamp │         │               │                               │
│  └───────────────┘         └───────────────┘                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. ENTITY RELATIONSHIP DETAIL

### 2.1 Core Entities

#### ENTITY: person

```
┌─────────────────────────────────────────────────────────────┐
│                         PERSON                              │
├─────────────────────────────────────────────────────────────┤
│  PK  person_id          UUID                                │
│      full_name          VARCHAR(100) NOT NULL               │
│      gender             ENUM('MALE','FEMALE') NOT NULL      │
│      birth_date         DATE                                │
│      birth_place        VARCHAR(100)                        │
│      death_date         DATE                                │
│      death_place        VARCHAR(100)                        │
│  FK  marga_id           UUID → marga                        │
│      sub_suku           ENUM('TOBA','KARO',...)             │
│  FK  father_id          UUID → person (recursive)         │
│  FK  mother_id          UUID → person (recursive)         │
│      generation_number  INTEGER (calculated)                │
│      created_at         TIMESTAMP                           │
│      updated_at         TIMESTAMP                           │
│      status             ENUM('ACTIVE','DECEASED','DELETED')│
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • person.marga_id ──N:1──► marga                          │
│  • person.father_id ──N:1──► person (recursive)            │
│  • person.mother_id ──N:1──► person (recursive)            │
│  • person.person_id ◄──1:N── person (as father/mother)    │
│  • person.person_id ◄──1:N── marriage (as husband)         │
│  • person.person_id ◄──1:N── marriage (as wife)            │
│  • person.person_id ◄──1:N── ceremony_attendee             │
│  • person.person_id ◄──1:N── validation                    │
│  • person.person_id ◄──1:N── audit_log                     │
└─────────────────────────────────────────────────────────────┘
```

#### ENTITY: marga

```
┌─────────────────────────────────────────────────────────────┐
│                          MARGA                              │
├─────────────────────────────────────────────────────────────┤
│  PK  marga_id           UUID                                  │
│      marga_name         VARCHAR(50) UNIQUE NOT NULL          │
│      sub_suku           ENUM('TOBA','KARO','SIM','MAN',      │
│                              'ANG','PAK') NOT NULL           │
│      ancestor_name      VARCHAR(50)                          │
│      ancestor_story     TEXT                                 │
│      is_active          BOOLEAN DEFAULT TRUE                 │
│      verified_by        UUID → user                        │
│      verification_date  TIMESTAMP                           │
│      created_at         TIMESTAMP                            │
│      updated_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • marga.marga_id ◄──N:1── person                           │
│  • marga.marga_id ◄──1:N── sub_marga (as parent)           │
│  • marga.marga_id ──N:M── marga_prohibition                │
│  • marga.marga_id ──N:M── marga_prohibition (as prohibited) │
└─────────────────────────────────────────────────────────────┘
```

#### ENTITY: sub_marga

```
┌─────────────────────────────────────────────────────────────┐
│                       SUB_MARGA                             │
├─────────────────────────────────────────────────────────────┤
│  PK  sub_marga_id       UUID                                  │
│  FK  parent_marga_id    UUID → marga                        │
│      sub_marga_name     VARCHAR(50) NOT NULL                │
│      ancestor_name      VARCHAR(50)                          │
│      description        TEXT                                  │
│      created_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • sub_marga.parent_marga_id ──N:1──► marga                 │
│  • sub_marga.sub_marga_id ◄──1:N── person (optional)        │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Marriage Entities

#### ENTITY: marriage

```
┌─────────────────────────────────────────────────────────────┐
│                        MARRIAGE                             │
├─────────────────────────────────────────────────────────────┤
│  PK  marriage_id        UUID                                  │
│  FK  husband_id         UUID → person NOT NULL              │
│  FK  wife_id            UUID → person NOT NULL               │
│      marriage_date      DATE NOT NULL                       │
│      marriage_place     VARCHAR(100)                        │
│      marriage_type      ENUM('TRADITIONAL','CIVIL','RELIGIOUS',
│                              'COMBINED') DEFAULT 'COMBINED' │
│      sinamot_amount     DECIMAL(15,2)                       │
│      sinamot_details    TEXT                                 │
│      status             ENUM('ACTIVE','DIVORCED','ANNULLED',
│                              'WIDOWED') DEFAULT 'ACTIVE'    │
│      notes              TEXT                                  │
│      created_by         UUID → user                         │
│      created_at         TIMESTAMP                            │
│      updated_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • marriage.husband_id ──N:1──► person                      │
│  • marriage.wife_id ──N:1──► person                        │
│  • marriage.marriage_id ◄──1:N── marriage_stage            │
│  • marriage.marriage_id ◄──1:N── ulos_distribution           │
│  • marriage.marriage_id ◄──1:N── ceremony (if adat)          │
└─────────────────────────────────────────────────────────────┘
```

#### ENTITY: marriage_stage

```
┌─────────────────────────────────────────────────────────────┐
│                     MARRIAGE_STAGE                          │
├─────────────────────────────────────────────────────────────┤
│  PK  stage_id           UUID                                  │
│  FK  marriage_id        UUID → marriage NOT NULL            │
│      stage_name         ENUM('MANGARISIKA','MARTUMPOL',      │
│                              'MARTONGGO_RAJA','MARSIBUHA_BUHAI',
│                              'PEMBERKATAN','MANGULOSI',     │
│                              'PAULAK_UNE') NOT NULL         │
│      stage_date         DATE                                  │
│      stage_location     VARCHAR(100)                        │
│      status             ENUM('PENDING','COMPLETED',          │
│                              'SKIPPED','CANCELLED')         │
│      details            JSON                                 │
│      documented_by      UUID → user                          │
│      created_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • marriage_stage.marriage_id ──N:1──► marriage            │
└─────────────────────────────────────────────────────────────┘
```

#### ENTITY: ulos_distribution

```
┌─────────────────────────────────────────────────────────────┐
│                    ULOS_DISTRIBUTION                        │
├─────────────────────────────────────────────────────────────┤
│  PK  distribution_id    UUID                                  │
│  FK  marriage_id        UUID → marriage NOT NULL             │
│      ulos_type          ENUM('PASAMOT','HELA','PAMARAI',    │
│                              'SIMANDOKKON','NAMBORUNYA',    │
│                              'PARIBAN','HULA_HULA','TULANG',
│                              'BONA_TULANG','TULANG_ROROBOT',
│                              'OTHER') NOT NULL              │
│  FK  from_person_id     UUID → person                       │
│  FK  to_person_id       UUID → person                       │
│      from_side          ENUM('PARBORU','PARANAK')          │
│      is_mandatory       BOOLEAN DEFAULT FALSE              │
│      description        TEXT                                  │
│      created_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • ulos_distribution.marriage_id ──N:1──► marriage         │
│  • ulos_distribution.from_person_id ──N:1──► person        │
│  • ulos_distribution.to_person_id ──N:1──► person            │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 User & Authentication Entities

#### ENTITY: user

```
┌─────────────────────────────────────────────────────────────┐
│                          USER                               │
├─────────────────────────────────────────────────────────────┤
│  PK  user_id            UUID                                  │
│  FK  person_id          UUID → person (optional link)      │
│      email              VARCHAR(100) UNIQUE NOT NULL         │
│      password_hash      VARCHAR(255) NOT NULL              │
│      full_name          VARCHAR(100)                        │
│      role               ENUM('USER','VERIFIED_USER',       │
│                              'TETUA_ADAT','RAJA_PARHATA',     │
│                              'ADMIN_BUDAYA','ADMIN_SISTEM') │
│                              DEFAULT 'USER'                  │
│      sub_suku           ENUM('TOBA','KARO',...)              │
│      status             ENUM('DRAFT','SELF_VERIFIED',        │
│                              'IDENTITY_PENDING','VERIFIED', │
│                              'SUSPENDED','DELETED')         │
│                              DEFAULT 'DRAFT'                │
│      email_verified     BOOLEAN DEFAULT FALSE              │
│      last_login         TIMESTAMP                            │
│      created_at         TIMESTAMP                            │
│      updated_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • user.person_id ──1:1──► person (optional)               │
│  • user.user_id ◄──1:N── validation (as verifier)           │
│  • user.user_id ◄──1:N── audit_log (as actor)              │
│  • user.user_id ◄──1:N── ceremony (as raja_parhata)        │
└─────────────────────────────────────────────────────────────┘
```

### 2.4 Validation & Audit Entities

#### ENTITY: validation

```
┌─────────────────────────────────────────────────────────────┐
│                       VALIDATION                            │
├─────────────────────────────────────────────────────────────┤
│  PK  validation_id      UUID                                  │
│  FK  person_id          UUID → person NOT NULL              │
│      level              ENUM('L1','L2','L3','L4','L5')       │
│      status             ENUM('PENDING','APPROVED','REJECTED') │
│  FK  validator_id       UUID → user                         │
│      validated_at       TIMESTAMP                            │
│      notes              TEXT                                  │
│      created_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • validation.person_id ──N:1──► person                     │
│  • validation.validator_id ──N:1──► user                      │
└─────────────────────────────────────────────────────────────┘
```

#### ENTITY: audit_log

```
┌─────────────────────────────────────────────────────────────┐
│                        AUDIT_LOG                          │
├─────────────────────────────────────────────────────────────┤
│  PK  log_id             UUID                                  │
│  FK  person_id          UUID → person (affected person)     │
│  FK  actor_id           UUID → user (who made change)       │
│      action             ENUM('CREATE','UPDATE','DELETE',     │
│                              'VALIDATE','MERGE','RESTORE')   │
│      entity_type        ENUM('PERSON','MARRIAGE','USER',...) │
│      entity_id          UUID                                │
│      field_name         VARCHAR(50)                         │
│      old_value          TEXT                                 │
│      new_value          TEXT                                 │
│      ip_address         VARCHAR(45)                         │
│      user_agent         TEXT                                 │
│      timestamp          TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • audit_log.person_id ──N:1──► person                       │
│  • audit_log.actor_id ──N:1──► user                         │
└─────────────────────────────────────────────────────────────┘
```

### 2.5 Reference Entities

#### ENTITY: marga_prohibition

```
┌─────────────────────────────────────────────────────────────┐
│                    MARGA_PROHIBITION                        │
├─────────────────────────────────────────────────────────────┤
│  PK  prohibition_id     UUID                                  │
│  FK  marga_1_id         UUID → marga NOT NULL               │
│  FK  marga_2_id         UUID → marga NOT NULL               │
│      prohibition_type   ENUM('ABSOLUTE','CONDITIONAL')      │
│      reason             TEXT NOT NULL                        │
│      effective_date     DATE                                 │
│  FK  verified_by        UUID → user                         │
│      created_at         TIMESTAMP                            │
├─────────────────────────────────────────────────────────────┤
│  RELATIONSHIPS:                                             │
│  • marga_prohibition.marga_1_id ──N:1──► marga             │
│  • marga_prohibition.marga_2_id ──N:1──► marga             │
│  • marga_prohibition.verified_by ──N:1──► user             │
│  CONSTRAINT: marga_1_id != marga_2_id                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. DIAGRAM SUB-SISTEM

### 3.1 Sistem Kekerabatan (Relationship System)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SISTEM KEKERABATAN                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│     ┌───────────┐                                                           │
│     │  PERSON   │                                                           │
│     │           │                                                           │
│     │ ├─ person_id                                                          │
│     │ ├─ full_name                                                           │
│     │ ├─ father_id ─────────┐                                              │
│     │ └─ mother_id ──────┐  │                                              │
│     └───────────┘        │  │                                              │
│            │             │  │                                              │
│            │ 1:N         │  │                                              │
│            ▼             │  │                                              │
│     ┌───────────┐        │  │                                              │
│     │  PERSON   │        │  │                                              │
│     │  (anak)   │◄───────┘  │                                              │
│     │           │◄──────────┘                                              │
│     │ ├─ person_id                                                          │
│     └───────────┘                                                           │
│                                                                             │
│     ┌───────────┐         ┌───────────┐         ┌───────────┐              │
│     │  PERSON   │◄───────►│  MARRIAGE │◄───────►│  PERSON   │              │
│     │  (suami)  │   1:N   │           │   N:1   │  (istri)  │              │
│     └───────────┘         └───────────┘         └───────────┘              │
│                                                                             │
│     RELASI YANG DIHITUNG:                                                   │
│     • Tulang (saudara laki ibu)                                             │
│     • Namboru (saudari ayah)                                                │
│     • Lae/Eda (anak tulang)                                                 │
│     • Pariban                                                               │
│     • Hula-hula                                                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Sistem Perkawinan (Marriage System)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SISTEM PERKAWINAN                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌───────────┐                                                             │
│   │  MARRIAGE │◄─────────────────────────────────────────────────────────┐  │
│   │           │                                                           │  │
│   │ ├─ marriage_id                                                        │  │
│   │ ├─ husband_id ──► PERSON                                             │  │
│   │ ├─ wife_id ─────► PERSON                                             │  │
│   │ ├─ marriage_date                                                      │  │
│   │ ├─ sinamot_amount                                                     │  │
│   │ └─ status                                                             │  │
│   └─────┬───┘                                                           │  │
│         │ 1:N                                                           │  │
│         ▼                                                               │  │
│   ┌───────────────┐                                                     │  │
│   │ MARRIAGE_STAGE│                                                     │  │
│   │               │                                                     │  │
│   │ ├─ stage_id                                                         │  │
│   │ ├─ stage_name [MANGARISIKA, MARTUMPOL, ..., PAULAK_UNE]           │  │
│   │ ├─ stage_date                                                       │  │
│   │ └─ status                                                           │  │
│   └───────────────┘                                                     │  │
│         │                                                               │  │
│         │ 1:N                                                           │  │
│         ▼                                                               │  │
│   ┌───────────────┐                                                     │  │
│   │ULOS_DISTRIBUTION                                                     │  │
│   │               │                                                     │  │
│   │ ├─ ulos_type [PASAMOT, HELA, PAMARAI, HULA_HULA, TULANG, ...]      │  │
│   │ ├─ from_person_id                                                   │  │
│   │ └─ to_person_id                                                     │  │
│   └───────────────┘                                                     │  │
│                                                                         │  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Sistem Validasi (Validation System)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SISTEM VALIDASI                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌───────────┐         ┌───────────┐         ┌───────────┐              │
│   │  PERSON   │◄───────│ VALIDATION│◄───────│   USER    │              │
│   │           │   1:N   │           │   N:1   │(validator)│              │
│   │ ├─ status │         │ ├─ level  │         │           │              │
│   │    [DRAFT,│         │   [L1-L5] │         │ ├─ role    │              │
│   │     SELF_V│         │ ├─ status │         │   [VERIFIED│              │
│   │     FAMILY│         │   [PENDING│         │    _USER,  │              │
│   │     COMMU │         │    APPROVE│         │    TETUA_  │              │
│   │     NITY_V│         │    D,     │         │    ADAT,   │              │
│   │     ELDER_│         │    REJECTE│         │    ...]    │              │
│   │     VERIFI│         │    D]     │         │           │              │
│   │     ED,   │         │           │         │           │              │
│   │     OFFICI│         │           │         │           │              │
│   │     AL]   │         │           │         │           │              │
│   └───────────┘         └───────────┘         └───────────┘              │
│                                                                             │
│   WORKFLOW VALIDASI:                                                        │
│   DRAFT ──► SELF_VERIFIED ──► FAMILY_VERIFIED ──► COMMUNITY_VERIFIED       │
│     │           │                   │                     │                │
│     │           │                   │                     ▼                │
│     │           │                   │             ┌───────────────┐       │
│     │           │                   │             │ ELDER_VERIFIED│       │
│     │           │                   │             └───────┬───────┘       │
│     │           │                   │                     │                │
│     │           │                   │                     ▼                │
│     │           │                   │             ┌───────────────┐       │
│     │           │                   │             │   OFFICIAL    │       │
│     │           │                   │             └───────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. RELATIONSHIP MATRIX

### 4.1 Cardinality Summary

| Entity 1 | Relationship | Entity 2 | Cardinality | Description |
|------------|--------------|----------|-------------|-------------|
| person | has father | person | N:1 | Recursive parent-child |
| person | has mother | person | N:1 | Recursive parent-child |
| person | belongs to | marga | N:1 | Patrilineal inheritance |
| person | marries as husband | marriage | 1:N | Male in marriage |
| person | marries as wife | marriage | 1:N | Female in marriage |
| marriage | consists of | marriage_stage | 1:N | 7 stages per marriage |
| marriage | involves | ulos_distribution | 1:N | Ulos given |
| user | manages | person | 1:1 | User linked to person |
| user | validates | validation | 1:N | Validator actions |
| person | subject of | validation | 1:N | Validation levels |
| person | generates | audit_log | 1:N | Change tracking |
| marga | has | sub_marga | 1:N | Sub-divisions |
| marga | prohibits | marga | N:M | Marriage prohibitions |

### 4.2 Constraint Summary

| Constraint | Type | Entities | Rule |
|------------|------|----------|------|
| PATRILINEAL_MARGA | Business | person, marga | Child inherits father's marga |
| NO_SELF_MARRIAGE | Business | marriage | Husband != Wife |
| UNIQUE_EMAIL | Database | user | Email must be unique |
| UNIQUE_MARGA_NAME | Database | marga | Marga name must be unique |
| NO_CIRCULAR_PARENT | Referential | person | Cannot be own ancestor |

---

## LAMPIRAN: Notasi ERD

```
╔════════════════════════════════════════════════════════════╗
│                    LEGENDA NOTASI                          ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  ┌─────────────┐                                           ║
║  │   ENTITY    │  = Entitas/Tabel                          ║
║  │  ├─ PK      │     PK = Primary Key                      ║
║  │  ├─ FK      │     FK = Foreign Key                      ║
║  │  └─ field   │                                           ║
║  └─────────────┘                                           ║
║                                                            ║
║  ────►  = Relasi (dari sumber ke target)                 ║
║  1:N    = Satu ke Banyak                                  ║
║  N:1    = Banyak ke Satu                                  ║
║  N:M    = Banyak ke Banyak                                ║
║  1:1    = Satu ke Satu                                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

**Referensi:** DATABASE_DESIGN.md, SQL_SCHEMA.md, BUSINESS_RULE.md

© 2026 Tarombo Digital Project
