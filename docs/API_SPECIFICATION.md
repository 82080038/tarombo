# API SPECIFICATION
## Spesifikasi API Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final
**Base URL:** `https://api.tarombo.digital/v1`
**Protocol:** HTTPS/REST + WebSocket untuk real-time

---

## DAFTAR ISI

1. [Authentication](#1-authentication)
2. [Person API](#2-person-api)
3. [Marga API](#3-marga-api)
4. [Marriage API](#4-marriage-api)
5. [Partuturan API](#5-partuturan-api)
6. [Ceremony API](#6-ceremony-api)
7. [Admin API](#7-admin-api)

---

## 1. AUTHENTICATION

### 1.1 POST /auth/login

Login user dan mendapatkan JWT token.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "totp_code": "123456"  // Optional, jika 2FA enabled
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4...",
    "expires_in": 3600,
    "token_type": "Bearer",
    "user": {
      "user_id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "full_name": "John Doe Simanjuntak",
      "role": "VERIFIED_USER",
      "marga": "Simanjuntak"
    }
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email atau password tidak valid"
  }
}
```

### 1.2 POST /auth/register

Registrasi user baru.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "full_name": "John Doe Simanjuntak",
  "marga_id": "550e8400-e29b-41d4-a716-446655440001",
  "sub_suku": "TOBA"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "status": "DRAFT",
    "verification_email_sent": true
  }
}
```

### 1.3 POST /auth/refresh

Refresh access token menggunakan refresh token.

**Request:**
```json
{
  "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4..."
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600
  }
}
```

---

## 2. PERSON API

### 2.1 GET /persons

List person dengan filter dan pagination.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | string | Filter nama (fuzzy search) |
| `marga_id` | UUID | Filter marga |
| `sub_suku` | string | Filter sub-suku |
| `gender` | string | Filter gender (MALE/FEMALE) |
| `generation` | integer | Filter generasi |
| `page` | integer | Halaman (default: 1) |
| `limit` | integer | Jumlah per halaman (default: 20) |
| `sort_by` | string | Field sorting (default: full_name) |
| `sort_order` | string | asc/desc (default: asc) |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "person_id": "550e8400-e29b-41d4-a716-446655440002",
        "full_name": "John Simanjuntak",
        "gender": "MALE",
        "birth_date": "1990-01-15",
        "marga": {
          "marga_id": "550e8400-e29b-41d4-a716-446655440001",
          "marga_name": "Simanjuntak"
        },
        "sub_suku": "TOBA",
        "generation_number": 5,
        "photo_url": "https://cdn.tarombo.digital/photos/xxx.jpg",
        "status": "ACTIVE"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "total_pages": 8
    }
  }
}
```

### 2.2 GET /persons/{person_id}

Detail person dengan relasi keluarga.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "person_id": "550e8400-e29b-41d4-a716-446655440002",
    "full_name": "John Simanjuntak",
    "gender": "MALE",
    "birth_date": "1990-01-15",
    "birth_place": "Medan",
    "death_date": null,
    "marga": {
      "marga_id": "550e8400-e29b-41d4-a716-446655440001",
      "marga_name": "Simanjuntak",
      "sub_suku": "TOBA"
    },
    "generation_number": 5,
    "photo_url": "https://cdn.tarombo.digital/photos/xxx.jpg",
    "family": {
      "father": {
        "person_id": "550e8400-e29b-41d4-a716-446655440003",
        "full_name": "Peter Simanjuntak",
        "partuturan": "Amang"
      },
      "mother": {
        "person_id": "550e8400-e29b-41d4-a716-446655440004",
        "full_name": "Maria Panjaitan",
        "partuturan": "Inang"
      },
      "spouse": {
        "person_id": "550e8400-e29b-41d4-a716-446655440005",
        "full_name": "Jane Sinaga",
        "partuturan": "Boru"
      },
      "children": [
        {
          "person_id": "550e8400-e29b-41d4-a716-446655440006",
          "full_name": "Child Simanjuntak",
          "partuturan": "Anak"
        }
      ]
    },
    "created_at": "2026-01-15T10:30:00Z",
    "updated_at": "2026-01-15T10:30:00Z",
    "validation_level": "L3"
  }
}
```

### 2.3 POST /persons

Create person baru.

**Request:**
```json
{
  "full_name": "New Person Simanjuntak",
  "gender": "MALE",
  "birth_date": "2000-05-20",
  "birth_place": "Jakarta",
  "marga_id": "550e8400-e29b-41d4-a716-446655440001",
  "sub_suku": "TOBA",
  "father_id": "550e8400-e29b-41d4-a716-446655440002",
  "mother_id": "550e8400-e29b-41d4-a716-446655440007"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "person_id": "550e8400-e29b-41d4-a716-446655440008",
    "full_name": "New Person Simanjuntak",
    "generation_number": 6,
    "marga": {
      "marga_id": "550e8400-e29b-41d4-a716-446655440001",
      "marga_name": "Simanjuntak"
    },
    "created_at": "2026-01-15T10:30:00Z"
  }
}
```

### 2.4 GET /persons/{person_id}/tree

Get family tree untuk person.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `generations_up` | integer | Jumlah generasi ke atas (default: 3) |
| `generations_down` | integer | Jumlah generasi ke bawah (default: 3) |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "person_id": "550e8400-e29b-41d4-a716-446655440002",
    "tree": {
      "ancestors": [
        {
          "level": 1,
          "persons": [
            {
              "person_id": "xxx",
              "full_name": "Father",
              "relation": "Amang"
            }
          ]
        }
      ],
      "descendants": [
        {
          "level": 1,
          "persons": [
            {
              "person_id": "yyy",
              "full_name": "Child",
              "relation": "Anak"
            }
          ]
        }
      ]
    }
  }
}
```

---

## 3. MARGA API

### 3.1 GET /margas

List semua marga.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `sub_suku` | string | Filter sub-suku |
| `search` | string | Search nama marga |
| `is_active` | boolean | Filter active only |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "marga_id": "550e8400-e29b-41d4-a716-446655440001",
        "marga_name": "Simanjuntak",
        "sub_suku": "TOBA",
        "ancestor_name": "Ompu Simanjuntak",
        "person_count": 1250,
        "is_active": true
      }
    ],
    "total": 100
  }
}
```

### 3.2 GET /margas/{marga_id}

Detail marga dengan statistik.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "marga_id": "550e8400-e29b-41d4-a716-446655440001",
    "marga_name": "Simanjuntak",
    "sub_suku": "TOBA",
    "ancestor_name": "Ompu Simanjuntak",
    "ancestor_story": "Asal-usul marga Simanjuntak...",
    "statistics": {
      "total_persons": 1250,
      "male_count": 650,
      "female_count": 600,
      "generations": 8,
      "marriages": 320
    },
    "sub_margas": [
      {
        "sub_marga_id": "xxx",
        "sub_marga_name": "Simanjuntak Parsuratan"
      }
    ],
    "prohibited_margas": [
      {
        "marga_id": "yyy",
        "marga_name": "Sihotang",
        "reason": "Larangan adat"
      }
    ]
  }
}
```

### 3.3 GET /margas/{marga_id}/can-marry/{target_marga_id}

Cek apakah dua marga boleh menikah.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "can_marry": false,
    "reason": "Perkawinan sesama marga tidak diperbolehkan",
    "prohibition_details": {
      "type": "SAME_MARGA",
      "code": "BR-MRG-005"
    }
  }
}
```

---

## 4. MARRIAGE API

### 4.1 GET /marriages

List perkawinan.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `person_id` | UUID | Filter perkawinan yang melibatkan person |
| `marga_id` | UUID | Filter berdasarkan marga |
| `status` | string | ACTIVE/DIVORCED/ANNULLED/WIDOWED |
| `from_date` | date | Filter dari tanggal |
| `to_date` | date | Filter sampai tanggal |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "marriage_id": "550e8400-e29b-41d4-a716-446655440010",
        "husband": {
          "person_id": "550e8400-e29b-41d4-a716-446655440002",
          "full_name": "John Simanjuntak",
          "marga": "Simanjuntak"
        },
        "wife": {
          "person_id": "550e8400-e29b-41d4-a716-446655440005",
          "full_name": "Jane Sinaga",
          "marga": "Sinaga"
        },
        "marriage_date": "2025-06-15",
        "marriage_place": "Jakarta",
        "status": "ACTIVE",
        "completed_stages": 7
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50
    }
  }
}
```

### 4.2 POST /marriages

Create perkawinan baru.

**Request:**
```json
{
  "husband_id": "550e8400-e29b-41d4-a716-446655440002",
  "wife_id": "550e8400-e29b-41d4-a716-446655440005",
  "marriage_date": "2025-06-15",
  "marriage_place": "Jakarta",
  "marriage_type": "COMBINED",
  "sinamot_amount": 50000000,
  "sinamot_details": "Uang tunai, perhiasan, dll"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "marriage_id": "550e8400-e29b-41d4-a716-446655440010",
    "husband_id": "550e8400-e29b-41d4-a716-446655440002",
    "wife_id": "550e8400-e29b-41d4-a716-446655440005",
    "marriage_date": "2025-06-15",
    "status": "ACTIVE",
    "created_at": "2026-01-15T10:30:00Z"
  }
}
```

**Error Response (400 Bad Request - Same Marga):**
```json
{
  "success": false,
  "error": {
    "code": "SAME_MARGA_MARRIAGE",
    "message": "Perkawinan sesama marga tidak diperbolehkan",
    "details": {
      "husband_marga": "Simanjuntak",
      "wife_marga": "Simanjuntak"
    }
  }
}
```

### 4.3 GET /marriages/{marriage_id}

Detail perkawinan dengan tahapan.

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "marriage_id": "550e8400-e29b-41d4-a716-446655440010",
    "husband": {
      "person_id": "550e8400-e29b-41d4-a716-446655440002",
      "full_name": "John Simanjuntak"
    },
    "wife": {
      "person_id": "550e8400-e29b-41d4-a716-446655440005",
      "full_name": "Jane Sinaga"
    },
    "marriage_date": "2025-06-15",
    "marriage_place": "Jakarta",
    "sinamot_amount": 50000000,
    "status": "ACTIVE",
    "stages": [
      {
        "stage_id": "xxx",
        "stage_name": "MANGARISIKA",
        "stage_order": 1,
        "stage_date": "2025-05-01",
        "status": "COMPLETED",
        "details": {}
      },
      {
        "stage_id": "yyy",
        "stage_name": "MARTUMPOL",
        "stage_order": 2,
        "stage_date": "2025-05-15",
        "status": "COMPLETED",
        "details": {}
      }
      // ... 5 more stages
    ],
    "ulos_distributions": [
      {
        "distribution_id": "zzz",
        "ulos_type": "HELA",
        "from_person": {"name": "Ayah pengantin pria"},
        "to_person": {"name": "Pengantin pria"},
        "was_given": true
      }
    ]
  }
}
```

### 4.4 PUT /marriages/{marriage_id}/stages/{stage_id}

Update status tahapan perkawinan.

**Request:**
```json
{
  "status": "COMPLETED",
  "stage_date": "2025-05-01",
  "stage_location": "Rumah keluarga",
  "details": {
    "witnesses": ["Nama saksi 1", "Nama saksi 2"],
    "notes": "Berjalan lancar"
  }
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "stage_id": "xxx",
    "stage_name": "MANGARISIKA",
    "status": "COMPLETED",
    "completed_at": "2026-01-15T10:30:00Z"
  }
}
```

---

## 5. PARTUTURAN API

### 5.1 GET /partuturan

Calculate partuturan antara dua person.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `viewer_id` | UUID | Yes | Person yang melihat |
| `target_id` | UUID | Yes | Person yang dilihat |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "viewer": {
      "person_id": "550e8400-e29b-41d4-a716-446655440002",
      "full_name": "John Simanjuntak",
      "marga": "Simanjuntak"
    },
    "target": {
      "person_id": "550e8400-e29b-41d4-a716-446655440004",
      "full_name": "Maria Panjaitan",
      "marga": "Panjaitan"
    },
    "partuturan": {
      "term": "Inang",
      "alternatives": ["Inong", "Omak"],
      "hierarchy_level": 1,
      "relationship_path": [
        {"step": 1, "relation": "MOTHER", "direction": "UP"}
      ],
      "requires_respect": true,
      "special_status": null,
      "explanation": "Inang adalah panggilan kepada ibu kandung"
    },
    "dalihan_na_tolu": {
      "category": "BORU",  // atau HULA_HULA, DONGAN_TUBU
      "position": "Pihak yang memberi istri"
    }
  }
}
```

### 5.2 GET /partuturan/pariban

Find pariban matches untuk person.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `person_id` | UUID | Yes | Person yang mencari pariban |
| `gender` | string | No | Filter gender pariban |
| `max_age_diff` | integer | No | Maksimal selisih umur |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "person_id": "550e8400-e29b-41d4-a716-446655440002",
    "pariban_candidates": [
      {
        "person_id": "550e8400-e29b-41d4-a716-446655440020",
        "full_name": "Potential Match",
        "gender": "FEMALE",
        "birth_date": "1992-03-10",
        "marga": "Sinaga",
        "pariban_relation": "Anak perempuan dari tulang (saudara laki ibu)",
        "match_score": 85
      }
    ],
    "total_candidates": 5
  }
}
```

---

## 6. CEREMONY API

### 6.1 GET /ceremonies

List upacara adat.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `ceremony_type` | string | MARRIAGE/DEATH_SAUR_MATUA/DEATH_REGULAR/BIRTH |
| `status` | string | PLANNED/ONGOING/COMPLETED/CANCELLED |
| `from_date` | date | Filter dari tanggal |
| `to_date` | date | Filter sampai tanggal |

### 6.2 POST /ceremonies

Create upacara baru.

**Request:**
```json
{
  "ceremony_type": "MARRIAGE",
  "ceremony_name": "Pernikahan John & Jane",
  "marriage_id": "550e8400-e29b-41d4-a716-446655440010",
  "ceremony_date": "2025-06-15",
  "ceremony_location": "Gedung Serbaguna",
  "raja_parhata_id": "550e8400-e29b-41d4-a716-446655440030",
  "suhut_bolahan": "Keluarga Simanjuntak"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "ceremony_id": "550e8400-e29b-41d4-a716-446655440040",
    "ceremony_type": "MARRIAGE",
    "ceremony_name": "Pernikahan John & Jane",
    "tata_tertib": "Generated...",
    "status": "PLANNED"
  }
}
```

---

## 7. ADMIN API

### 7.1 GET /admin/statistics

Get statistik sistem.

**Headers:**
```
Authorization: Bearer {admin_token}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_persons": 10000,
      "total_users": 2500,
      "total_marriages": 3200,
      "total_margas": 100
    },
    "by_sub_suku": [
      {"sub_suku": "TOBA", "count": 5000},
      {"sub_suku": "KARO", "count": 2000},
      {"sub_suku": "SIM", "count": 1500}
    ],
    "recent_activity": {
      "new_persons_this_month": 50,
      "new_marriages_this_month": 20,
      "new_users_this_month": 100
    }
  }
}
```

### 7.2 GET /admin/audit-logs

Get audit logs.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `entity_type` | string | Filter entity |
| `action` | string | CREATE/UPDATE/DELETE |
| `actor_id` | UUID | Filter actor |
| `from_date` | date | Filter dari tanggal |
| `to_date` | date | Filter sampai tanggal |

### 7.3 POST /admin/margas

Create marga baru (Admin Budaya only).

**Request:**
```json
{
  "marga_name": "Marga Baru",
  "sub_suku": "TOBA",
  "ancestor_name": "Leluhur Marga",
  "ancestor_story": "Sejarah marga..."
}
```

---

## ERROR HANDLING

### Standard Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {},
    "timestamp": "2026-01-15T10:30:00Z",
    "request_id": "req-xxx-yyy-zzz"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Token tidak valid atau expired |
| `FORBIDDEN` | 403 | Tidak memiliki permission |
| `NOT_FOUND` | 404 | Resource tidak ditemukan |
| `VALIDATION_ERROR` | 422 | Input tidak valid |
| `SAME_MARGA_MARRIAGE` | 400 | Perkawinan sesama marga |
| `PROHIBITED_MARRIAGE` | 400 | Perkawinan dilarang |
| `CONFLICT` | 409 | Data conflict |
| `RATE_LIMITED` | 429 | Terlalu banyak request |
| `INTERNAL_ERROR` | 500 | Error server |

---

## PAGINATION

Semua endpoint list menggunakan pagination standar:

```json
{
  "data": {
    "items": [],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "total_pages": 5,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

---

**Referensi:** SYSTEM_REQUIREMENT.md, BUSINESS_RULE.md

© 2026 Tarombo Digital Project
