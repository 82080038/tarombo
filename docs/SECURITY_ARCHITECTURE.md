# SECURITY ARCHITECTURE
## Arsitektur Keamanan Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Security Overview](#1-security-overview)
2. [Authentication Architecture](#2-authentication-architecture)
3. [Authorization & RBAC](#3-authorization--rbac)
4. [Data Protection](#4-data-protection)
5. [API Security](#5-api-security)
6. [Infrastructure Security](#6-infrastructure-security)
7. [Incident Response](#7-incident-response)

---

## 1. SECURITY OVERVIEW

### 1.1 Security Model

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DEFENSE IN DEPTH LAYERS                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   LAYER 1: PERIMETER                                                        │
│   ├── WAF (Web Application Firewall)                                      │
│   ├── DDoS Protection                                                     │
│   └── Rate Limiting                                                       │
│                                                                             │
│   LAYER 2: APPLICATION                                                      │
│   ├── Authentication (JWT + 2FA)                                          │
│   ├── Authorization (RBAC)                                                │
│   ├── Input Validation                                                    │
│   └── Output Encoding                                                     │
│                                                                             │
│   LAYER 3: DATA                                                             │
│   ├── Encryption at Rest (AES-256)                                        │
│   ├── Encryption in Transit (TLS 1.3)                                      │
│   └── Field-level Encryption (PII)                                        │
│                                                                             │
│   LAYER 4: NETWORK                                                          │
│   ├── VPC Segmentation                                                    │
│   ├── Security Groups                                                     │
│   └── Private Subnets                                                     │
│                                                                             │
│   LAYER 5: MONITORING                                                       │
│   ├── Audit Logging                                                       │
│   ├── Intrusion Detection                                                 │
│   └── Security Alerts                                                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Threat Model

| Threat | Likelihood | Impact | Mitigation |
|--------|------------|--------|------------|
| Data Breach | Medium | High | Encryption, Access Control |
| Account Takeover | Medium | High | 2FA, Rate Limiting |
| DDoS Attack | Low | Medium | CDN, Rate Limiting |
| SQL Injection | Low | High | Parameterized Queries |
| XSS Attack | Low | Medium | Output Encoding, CSP |
| Insider Threat | Low | High | RBAC, Audit Logs |

---

## 2. AUTHENTICATION ARCHITECTURE

### 2.1 Authentication Flow

```
┌─────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  USER   │────►│   LOGIN     │────►│   VERIFY    │────►│   CHECK     │
│         │     │  CREDENTIALS│     │   PASSWORD  │     │    2FA      │
└─────────┘     └─────────────┘     └──────┬──────┘     └──────┬──────┘
                                           │                     │
                                           │                     │
                                    ┌──────┴──────┐      ┌──────┴──────┐
                                    │  INVALID    │      │  ENABLED    │
                                    │  Reject     │      │  Verify TOTP │
                                    └─────────────┘      └──────┬──────┘
                                                                │
                                                                ▼
                                                         ┌─────────────┐
                                                         │  SUCCESS    │
                                                         │  Generate   │
                                                         │  Tokens     │
                                                         └──────┬──────┘
                                                                │
                                                                ▼
                                                         ┌─────────────┐
                                                         │  RETURN     │
                                                         │  Access +   │
                                                         │  Refresh    │
                                                         │  Token      │
                                                         └─────────────┘
```

### 2.2 JWT Token Structure

**Access Token:**
```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "key-id-2026-01"
  },
  "payload": {
    "sub": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "role": "VERIFIED_USER",
    "marga": "Simanjuntak",
    "iat": 1705312800,
    "exp": 1705316400,
    "jti": "unique-token-id",
    "permissions": ["person:read", "person:create", "marriage:read"]
  }
}
```

**Token Configuration:**
| Token Type | Expiration | Storage |
|------------|------------|---------|
| Access Token | 1 hour | Memory only |
| Refresh Token | 7 days | HttpOnly Cookie |
| ID Token | 1 hour | Memory only |

### 2.3 Two-Factor Authentication (2FA)

**TOTP Configuration:**
- Algorithm: SHA1
- Digits: 6
- Period: 30 seconds
- Recovery codes: 10 codes

**2FA Flow:**
```
1. User enables 2FA in settings
2. System generates TOTP secret
3. User scans QR code dengan authenticator app
4. User verifies dengan entering TOTP code
5. System generates backup recovery codes
6. 2FA activated untuk account
```

### 2.4 Password Policy

| Requirement | Value |
|-------------|-------|
| Minimum Length | 8 characters |
| Complexity | Upper, lower, number, special |
| History | Last 5 passwords cannot be reused |
| Expiration | 90 days (optional enforcement) |
| Lockout | 5 failed attempts = 15 min lockout |
| Hash Algorithm | bcrypt dengan cost factor 12 |

---

## 3. AUTHORIZATION & RBAC

### 3.1 Role Hierarchy

```
ADMIN_SISTEM
└── ADMIN_BUDAYA
    ├── TETUA_ADAT
    │   └── RAJA_PARHATA
    └── VERIFIED_USER
        └── USER
```

### 3.2 Permission Matrix

| Resource | USER | VERIFIED_USER | TETUA_ADAT | RAJA_PARHATA | ADMIN_BUDAYA | ADMIN_SISTEM |
|----------|:----:|:-------------:|:----------:|:------------:|:------------:|:------------:|
| **Person** ||||||||
| Read (Public) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Read (Full) | - | ✓ (keluarga) | ✓ (komunitas) | ✓ | ✓ | ✓ |
| Create | - | ✓ (keluarga) | ✓ | - | ✓ | ✓ |
| Update | - | ✓ (own) | ✓ | - | ✓ | ✓ |
| Delete | - | - | - | - | ✓ | ✓ |
| **Marriage** ||||||||
| Read | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | - | ✓ | ✓ | ✓ | ✓ | ✓ |
| Validate | - | - | ✓ | ✓ | ✓ | ✓ |
| **Marga** ||||||||
| Read | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Create | - | - | - | - | ✓ | ✓ |
| Update | - | - | - | - | ✓ | ✓ |
| **Ceremony** ||||||||
| Create | - | - | ✓ | ✓ | ✓ | ✓ |
| Protocol | - | - | - | ✓ | ✓ | ✓ |
| **Admin** ||||||||
| View Stats | - | - | - | - | ✓ | ✓ |
| Manage Users | - | - | - | - | - | ✓ |
| Audit Logs | - | - | - | - | ✓ | ✓ |

### 3.3 Permission Implementation

```javascript
// Permission middleware example
const checkPermission = (resource, action) => {
  return async (req, res, next) => {
    const userRole = req.user.role;
    const userPermissions = getPermissionsForRole(userRole);
    
    const requiredPermission = `${resource}:${action}`;
    
    if (!userPermissions.includes(requiredPermission)) {
      // Check ownership untuk resource-specific permissions
      if (action === 'update' || action === 'delete') {
        const resource = await getResource(req.params.id);
        if (resource.created_by !== req.user.user_id) {
          return res.status(403).json({
            error: 'Forbidden: You do not have permission for this action'
          });
        }
      } else {
        return res.status(403).json({
          error: 'Forbidden: Insufficient permissions'
        });
      }
    }
    
    next();
  };
};

// Usage
router.post('/persons', 
  authenticate, 
  checkPermission('person', 'create'), 
  createPerson
);
```

---

## 4. DATA PROTECTION

### 4.1 Data Classification

| Classification | Examples | Protection Level |
|----------------|----------|------------------|
| **Public** | Nama, marga, generasi | None |
| **Internal** | Tanggal lahir, tempat lahir | Standard |
| **Confidential** | Alamat, kontak | High |
| **Restricted** | Dokumen identitas, data medis | Highest |

### 4.2 Encryption Strategy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ENCRYPTION LAYERS                                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   TRANSIT (TLS 1.3)                                                         │
│   ├── Certificate: Let's Encrypt / CloudFlare                              │
│   ├── Cipher Suites: TLS_AES_256_GCM_SHA384                               │
│   └── HSTS: Enabled                                                         │
│                                                                             │
│   REST (Database)                                                           │
│   ├── Algorithm: AES-256                                                  │
│   ├── Key Management: Cloud KMS / HashiCorp Vault                         │
│   └── Field Encryption untuk PII:                                           │
│       ├── email                                                           │
│       ├── phone_number                                                    │
│       └── address                                                         │
│                                                                             │
│   BACKUP                                                                    │
│   ├── Encryption: AES-256                                                 │
│   ├── Key Rotation: 90 days                                               │
│   └── Secure Storage: S3 dengan SSE                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 Field-Level Encryption

```python
from cryptography.fernet import Fernet
import hashlib

class FieldEncryption:
    def __init__(self, key):
        self.cipher = Fernet(key)
    
    def encrypt(self, plaintext: str) -> str:
        """Encrypt field value"""
        return self.cipher.encrypt(plaintext.encode()).decode()
    
    def decrypt(self, ciphertext: str) -> str:
        """Decrypt field value"""
        return self.cipher.decrypt(ciphertext.encode()).decode()
    
    def hash_for_search(self, plaintext: str) -> str:
        """Create searchable hash (HMAC)"""
        return hashlib.sha256(plaintext.encode()).hexdigest()[:16]

# Usage
encryption = FieldEncryption(get_kms_key())

# Encrypt before saving
user.email_encrypted = encryption.encrypt(user.email)
user.email_hash = encryption.hash_for_search(user.email)

# Decrypt when reading
email = encryption.decrypt(user.email_encrypted)
```

### 4.4 Data Masking

| Field | Public View | Family View | Full View |
|-------|-------------|-------------|-----------|
| Nama | Full | Full | Full |
| Email | - | masked***@domain | Full |
| Phone | - | +62****1234 | Full |
| Address | - | Kota only | Full |
| Birth Date | Year only | Full | Full |
| ID Document | - | - | Full |

---

## 5. API SECURITY

### 5.1 Security Headers

```nginx
# nginx.conf
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self' https://api.tarombo.digital;" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
```

### 5.2 Rate Limiting

| Endpoint Type | Limit | Window |
|---------------|-------|--------|
| Authentication | 5 requests | 1 minute |
| General API | 100 requests | 1 minute |
| Search | 30 requests | 1 minute |
| Data Export | 10 requests | 1 minute |
| Admin Operations | 50 requests | 1 minute |

```javascript
// Rate limiting middleware
const rateLimit = require('express-rate-limit');

const authLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 5,
  message: 'Too many authentication attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: false
});

const apiLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 100,
  keyGenerator: (req) => req.user?.user_id || req.ip
});
```

### 5.3 Input Validation

```javascript
// Validation schema example
const { body, validationResult } = require('express-validator');

const createPersonValidation = [
  body('full_name')
    .trim()
    .isLength({ min: 2, max: 100 })
    .matches(/^[a-zA-Z\s'-]+$/)
    .escape(),
  body('gender')
    .isIn(['MALE', 'FEMALE']),
  body('birth_date')
    .optional()
    .isISO8601()
    .toDate(),
  body('marga_id')
    .isUUID(),
  body('father_id')
    .optional()
    .isUUID(),
  body('mother_id')
    .optional()
    .isUUID()
    .custom((value, { req }) => {
      if (value === req.body.father_id) {
        throw new Error('Father and mother cannot be the same person');
      }
      return true;
    })
];
```

### 5.4 CORS Policy

```javascript
const cors = require('cors');

const corsOptions = {
  origin: [
    'https://tarombo.digital',
    'https://www.tarombo.digital',
    'https://app.tarombo.digital'
  ],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  credentials: true,
  maxAge: 86400 // 24 hours
};

app.use(cors(corsOptions));
```

---

## 6. INFRASTRUCTURE SECURITY

### 6.1 Network Architecture

```
                    INTERNET
                       │
                       ▼
              ┌─────────────────┐
              │   CLOUDFLARE    │
              │  (CDN + WAF)    │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   LOAD BALANCER │
              │   (HTTPS/TLS)   │
              └────────┬────────┘
                       │
       ┌───────────────┼───────────────┐
       │               │               │
       ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  APP SERVER │ │  APP SERVER │ │  APP SERVER │
│   (Node.js) │ │   (Node.js) │ │   (Node.js) │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │               │               │
       └───────────────┼───────────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   POSTGRESQL    │
              │   (Primary)     │
              └────────┬────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   POSTGRESQL    │
              │   (Replica)     │
              └─────────────────┘
```

### 6.2 Security Groups / Firewall Rules

| Source | Destination | Port | Protocol | Action |
|--------|-------------|------|----------|--------|
| 0.0.0.0/0 | Load Balancer | 443 | TCP | Allow |
| Load Balancer | App Servers | 3000 | TCP | Allow |
| App Servers | PostgreSQL | 5432 | TCP | Allow |
| App Servers | Redis | 6379 | TCP | Allow |
| Admin IPs | PostgreSQL | 5432 | TCP | Allow |
| Any | Any | 22 | TCP | Deny |
| Any | Any | 3389 | TCP | Deny |

### 6.3 Backup Security

```bash
#!/bin/bash
# Backup encryption script

BACKUP_FILE="tarombo_backup_$(date +%Y%m%d_%H%M%S).sql"
ENCRYPTED_FILE="${BACKUP_FILE}.gpg"

# Create backup
pg_dump tarombo_digital > $BACKUP_FILE

# Encrypt dengan GPG
gpg --symmetric --cipher-algo AES256 \
    --compress-algo 1 --compress-level 9 \
    --output $ENCRYPTED_FILE \
    --passphrase-file /secure/backup_key.txt \
    $BACKUP_FILE

# Upload ke S3 dengan server-side encryption
aws s3 cp $ENCRYPTED_FILE s3://tarombo-backups/ \
    --sse AES256 \
    --storage-class STANDARD_IA

# Cleanup
shred -u $BACKUP_FILE
rm $ENCRYPTED_FILE

# Verify backup integrity
echo "Backup completed: $ENCRYPTED_FILE"
```

---

## 7. INCIDENT RESPONSE

### 7.1 Security Incident Levels

| Level | Description | Response Time | Examples |
|-------|-------------|---------------|----------|
| **Critical** | System compromise | 15 minutes | Data breach, Ransomware |
| **High** | Service impact | 1 hour | DDoS, Major vulnerability |
| **Medium** | Limited impact | 4 hours | Minor vulnerability, Suspicious activity |
| **Low** | No immediate impact | 24 hours | Policy violation, Failed login attempts |

### 7.2 Incident Response Procedure

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    INCIDENT RESPONSE FLOW                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   DETECTION              CONTAINMENT              ERADICATION               │
│   ─────────              ──────────              ───────────               │
│       │                      │                        │                     │
│       ▼                      ▼                        ▼                     │
│   ┌─────────┐          ┌─────────┐              ┌─────────┐               │
│   │ Alert   │          │ Isolate │              │ Remove  │               │
│   │ Trigger │          │ System  │              │ Threat  │               │
│   └────┬────┘          └────┬────┘              └────┬────┘               │
│        │                     │                        │                      │
│        │                     ▼                        ▼                      │
│        │                ┌─────────┐              ┌─────────┐               │
│        │                │ Preserve│              │ Patch   │               │
│        │                │ Evidence│              │ System  │               │
│        │                └────┬────┘              └────┬────┘               │
│        │                     │                        │                      │
│        └─────────────────────┴────────────────────────┘                      │
│                              │                                               │
│                              ▼                                               │
│                        ┌─────────────┐                                       │
│                        │  RECOVERY   │                                       │
│                        │  & POST-    │                                       │
│                        │  INCIDENT   │                                       │
│                        │  ACTIVITIES │                                       │
│                        └─────────────┘                                       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.3 Security Contacts

| Role | Contact | Responsibility |
|------|---------|----------------|
| Security Lead | security@tarombo.digital | Overall security |
| Incident Commander | oncall@tarombo.digital | Incident response |
| Database Admin | dba@tarombo.digital | Database security |
| Cloud Admin | cloud@tarombo.digital | Infrastructure security |

---

## LAMPIRAN: Security Checklist

### Pre-Deployment Checklist

- [ ] All dependencies scanned untuk vulnerabilities
- [ ] Security headers configured
- [ ] Rate limiting enabled
- [ ] Input validation implemented
- [ ] Output encoding implemented
- [ ] Authentication tested
- [ ] Authorization tested
- [ ] Encryption at rest enabled
- [ ] TLS 1.3 configured
- [ ] Audit logging enabled
- [ ] Backup encryption enabled
- [ ] WAF rules configured
- [ ] DDoS protection enabled
- [ ] Incident response plan documented
- [ ] Security contacts updated

---

**Referensi:** SYSTEM_REQUIREMENT.md, API_SPECIFICATION.md

© 2026 Tarombo Digital Project
