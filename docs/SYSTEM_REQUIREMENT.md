# SYSTEM REQUIREMENT
## Spesifikasi Kebutuhan Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Functional Requirements](#1-functional-requirements)
2. [Non-Functional Requirements](#2-non-functional-requirements)
3. [Integration Requirements](#3-integration-requirements)
4. [Security Requirements](#4-security-requirements)
5. [Data Requirements](#5-data-requirements)

---

## 1. FUNCTIONAL REQUIREMENTS

### 1.1 Modul Manajemen Person (FR-PERSON)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-PERSON-001 | Sistem harus dapat mencatat data person dengan field: nama lengkap, marga, gender, tanggal lahir, tempat lahir | High | Semua field tersimpan dengan validasi tipe data |
| FR-PERSON-002 | Sistem harus mendukung patrilineal inheritance untuk marga | High | Marga anak otomatis sama dengan ayah |
| FR-PERSON-003 | Sistem harus mendukung pencarian person dengan fuzzy search | High | Pencarian nama dengan toleransi typo 80% match |
| FR-PERSON-004 | Sistem harus menampilkan silsilah keluarga dalam format tree | High | Tree view menampilkan minimal 5 generasi |
| FR-PERSON-005 | Sistem harus menghitung partuturan otomatis antara dua person | High | Output partuturan sesuai BR-KKB-001 |
| FR-PERSON-006 | Sistem harus mendeteksi pariban relationship | High | Deteksi pariban dengan akurasi 100% |
| FR-PERSON-007 | Sistem harus mendukung multi-bahasa (Indonesia, Batak Toba, Inggris) | Medium | UI dapat switch bahasa |
| FR-PERSON-008 | Sistem harus mendukung foto profil dan galeri dokumentasi | Medium | Upload dan display foto berfungsi |

### 1.2 Modul Manajemen Marga (FR-MARGA)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-MARGA-001 | Sistem harus menyimpan master data marga minimal 100 marga Toba | High | Database berisi 100+ marga valid |
| FR-MARGA-002 | Sistem harus mendukung sub-marga/cabang | High | Struktur parent-child berfungsi |
| FR-MARGA-003 | Sistem harus validasi larangan perkawinan marga | High | Validasi sesuai BR-MRG-003 s/d 006 |
| FR-MARGA-004 | Sistem harus menampilkan sejarah/asal-usul marga | Medium | Deskripsi dan leluhur tersedia |
| FR-MARGA-005 | Sistem harus mendukung multi-sub-suku (Toba, Karo, Simalungun, dll) | Medium | Konfigurasi per sub-suku berfungsi |

### 1.3 Modul Perkawinan (FR-MARRIAGE)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-MARRIAGE-001 | Sistem harus mencatat 7 tahapan perkawinan adat | High | Semua tahapan dapat diinput dengan detail |
| FR-MARRIAGE-002 | Sistem harus validasi marga sebelum pencatatan perkawinan | High | Warning/error jika sesama marga |
| FR-MARRIAGE-003 | Sistem harus menghitung dan mencatat sinamot | High | Field sinamot dengan jumlah dan bentuk |
| FR-MARRIAGE-004 | Sistem harus mencatat pemberian ulos (mangulosi) | High | Detail ulos: jenis, pemberi, penerima |
| FR-MARRIAGE-005 | Sistem harus generate tata tertib acara otomatis | Medium | Tata tertib dapat dicetak/diekspor |
| FR-MARRIAGE-006 | Sistem harus mengelola role dalam acara (Raja Parhata, Hula-hula, dll) | Medium | Assignment role berfungsi |

### 1.4 Modul Validasi Data (FR-VALIDATION)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-VALIDATION-001 | Sistem harus mendukung 5 level validasi data | High | L1-L5 berfungsi dengan approval workflow |
| FR-VALIDATION-002 | Sistem harus mencatat audit trail perubahan data | High | Log perubahan: field, nilai lama/baru, user, timestamp |
| FR-VALIDATION-003 | Sistem harus deteksi data konflik otomatis | High | Alert untuk data duplikat/inkonsisten |
| FR-VALIDATION-004 | Sistem harus support request perbaikan data | High | Workflow request berfungsi |
| FR-VALIDATION-005 | Sistem harus mengirim notifikasi untuk approval | High | Email dan in-app notifikasi berfungsi |

### 1.5 Modul Pencarian dan Relasi (FR-SEARCH)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-SEARCH-001 | Sistem harus menyediakan pencarian berdasarkan nama, marga, wilayah | High | Multi-criteria search berfungsi |
| FR-SEARCH-002 | Sistem harus menampilkan peta kekerabatan visual | Medium | Network graph interaktif |
| FR-SEARCH-003 | Sistem harus mendukung pariban matching | Medium | List pariban candidates berfungsi |
| FR-SEARCH-004 | Sistem harus menampilkan hubungan path antara dua person | Medium | Path visualization berfungsi |

### 1.6 Modul Laporan dan Statistik (FR-REPORT)

| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|-------------------|
| FR-REPORT-001 | Sistem harus generate statistik demografi marga | Medium | Chart dan tabel statistik berfungsi |
| FR-REPORT-002 | Sistem harus export data dalam format PDF, Excel | Medium | Export berfungsi dengan format standar |
| FR-REPORT-003 | Sistem harus menyediakan dashboard admin | Medium | Dashboard dengan key metrics |

---

## 2. NON-FUNCTIONAL REQUIREMENTS

### 2.1 Performance Requirements (NFR-PERF)

| ID | Requirement | Target | Measurement |
|----|-------------|--------|-------------|
| NFR-PERF-001 | Response time untuk pencarian person | < 2 detik | 95th percentile |
| NFR-PERF-002 | Response time untuk kalkulasi partuturan | < 1 detik | 95th percentile |
| NFR-PERF-003 | Response time untuk generate silsilah (5 generasi) | < 3 detik | 95th percentile |
| NFR-PERF-004 | Sistem harus support 1000+ concurrent users | 1000 users | Load testing |
| NFR-PERF-005 | Database query untuk tree traversal | < 500ms | Average |
| NFR-PERF-006 | Image loading dan resize | < 2 detik | 95th percentile |

### 2.2 Availability dan Reliability (NFR-AVAIL)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-AVAIL-001 | System uptime | 99.9% |
| NFR-AVAIL-002 | Scheduled maintenance window | < 4 jam/bulan |
| NFR-AVAIL-003 | Recovery Time Objective (RTO) | < 4 jam |
| NFR-AVAIL-004 | Recovery Point Objective (RPO) | < 1 jam |
| NFR-AVAIL-005 | Backup otomatis | Daily incremental, weekly full |

### 2.3 Scalability (NFR-SCALE)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-SCALE-001 | Support data person | 1 juta person |
| NFR-SCALE-002 | Support marga | 200+ marga |
| NFR-SCALE-003 | Growth capacity | 20% YoY tanpa degradasi performance |
| NFR-SCALE-004 | Horizontal scaling | Support load balancer |

### 2.4 Usability (NFR-USE)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-USE-001 | First-time user dapat input data tanpa training | 80% completion rate |
| NFR-USE-002 | Mobile responsiveness | iOS, Android native-like |
| NFR-USE-003 | Accessibility compliance | WCAG 2.1 Level AA |
| NFR-USE-004 | Multi-language support | Indonesia, Batak Toba, English |

### 2.5 Maintainability (NFR-MAINT)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-MAINT-001 | Code coverage untuk unit test | > 80% |
| NFR-MAINT-002 | Dokumentasi API | OpenAPI/Swagger |
| NFR-MAINT-003 | Deployment frequency | On-demand, zero-downtime |
| NFR-MAINT-004 | Mean Time To Repair (MTTR) | < 2 jam |

---

## 3. INTEGRATION REQUIREMENTS

### 3.1 External System Integration (INT-EXT)

| ID | System | Protocol | Data | Frequency |
|----|--------|----------|------|-----------|
| INT-EXT-001 | Email Service (SMTP/SendGrid) | REST API | Email notifikasi | Real-time |
| INT-EXT-002 | SMS Gateway | REST API | SMS verifikasi | On-demand |
| INT-EXT-003 | Cloud Storage (S3/MinIO) | SDK/REST | File storage | On-demand |
| INT-EXT-004 | Payment Gateway | REST API | Transaction data | On-demand |
| INT-EXT-005 | Maps API (Google/Mapbox) | REST API | Geolocation | On-demand |

### 3.2 Internal Integration (INT-INT)

| ID | Komponen | Protocol | Purpose |
|----|----------|----------|---------|
| INT-INT-001 | Frontend ↔ Backend API | HTTPS/REST | Data exchange |
| INT-INT-002 | Backend ↔ Database | SQL/TCP | Data persistence |
| INT-INT-003 | Backend ↔ Cache (Redis) | TCP | Session & performance |
| INT-INT-004 | Backend ↔ Message Queue | AMQP | Async processing |
| INT-INT-005 | Backend ↔ Search Engine | HTTP | Full-text search |

---

## 4. SECURITY REQUIREMENTS

### 4.1 Authentication dan Authorization (SEC-AUTH)

| ID | Requirement | Implementation |
|----|-------------|----------------|
| SEC-AUTH-001 | User authentication dengan password + 2FA opsional | bcrypt + JWT + TOTP |
| SEC-AUTH-002 | Role-based access control (RBAC) | 6 roles: User, Verified, Tetua, Raja Parhata, Admin Budaya, Admin Sistem |
| SEC-AUTH-003 | Session timeout | 30 menit idle, 8 jam max |
| SEC-AUTH-004 | Password policy | Min 8 chars, complexity, 90 days expiry |
| SEC-AUTH-005 | Digital signature untuk Tetua | PKI certificate |

### 4.2 Data Protection (SEC-DATA)

| ID | Requirement | Implementation |
|----|-------------|----------------|
| SEC-DATA-001 | Encryption at rest untuk PII | AES-256 |
| SEC-DATA-002 | Encryption in transit | TLS 1.3 |
| SEC-DATA-003 | Field-level encryption untuk data sensitif | AES-256 |
| SEC-DATA-004 | Data masking untuk data privat di level publik | Masking rules |
| SEC-DATA-005 | Secure backup encryption | AES-256 dengan key management |

### 4.3 Compliance (SEC-COMP)

| ID | Requirement | Standard |
|----|-------------|----------|
| SEC-COMP-001 | Data privacy compliance | UU PDP (Indonesia), GDPR (jika EU users) |
| SEC-COMP-002 | Audit logging untuk semua transaksi sensitif | ISO 27001 |
| SEC-COMP-003 | Right to be forgotten | Implementasi deletion workflow |
| SEC-COMP-004 | Data portability | Export dalam format standar |

### 4.4 Infrastructure Security (SEC-INFRA)

| ID | Requirement | Implementation |
|----|-------------|----------------|
| SEC-INFRA-001 | Web Application Firewall (WAF) | ModSecurity/CloudFlare |
| SEC-INFRA-002 | DDoS protection | Cloud provider/CloudFlare |
| SEC-INFRA-003 | Network segmentation | VPC, security groups |
| SEC-INFRA-004 | Intrusion Detection System | IDS monitoring |
| SEC-INFRA-005 | Security scanning | SAST/DAST dalam CI/CD |

---

## 5. DATA REQUIREMENTS

### 5.1 Data Volume Estimation (DATA-VOL)

| Entitas | Estimasi Awal | Pertumbuhan/Tahun | 5 Tahun |
|---------|---------------|-------------------|---------|
| Person | 10,000 | 50% | 75,000 |
| Marga | 100 | 5% | 125 |
| Perkawinan | 2,000 | 100% | 64,000 |
| Upacara Adat | 500 | 100% | 16,000 |
| User Accounts | 5,000 | 75% | 50,000 |
| Foto/Dokumen | 20,000 | 150% | 300,000 |

### 5.2 Data Retention (DATA-RET)

| Tipe Data | Retention Period | Action After |
|-----------|------------------|--------------|
| Active person data | 7 tahun setelah last update | Archive |
| Deleted person data (soft delete) | 7 tahun | Permanent delete |
| Audit logs | 7 tahun | Archive ke cold storage |
| Session logs | 1 tahun | Delete |
| Backup files | 12 minggu | Delete |

### 5.3 Data Quality (DATA-QUAL)

| ID | Requirement | Metric |
|----|-------------|--------|
| DATA-QUAL-001 | Data completeness untuk field wajib | > 95% |
| DATA-QUAL-002 | Data accuracy (verified data) | > 90% |
| DATA-QUAL-003 | Duplicate rate | < 1% |
| DATA-QUAL-004 | Consistency rate (marga inheritance) | > 99% |

---

## MATRIKS TRACEBILITY

### Traceability ke Dokumen Lain

| Requirement ID | Referensi Dokumen | Section |
|----------------|-------------------|---------|
| FR-PERSON-005 | ANALISIS_BUDAYA_BATAK.md | Sistem Partuturan |
| FR-PERSON-006 | BUSINESS_RULE.md | BR-KKB-028 |
| FR-MARGA-003 | BUSINESS_RULE.md | BR-MRG-003 s/d 006 |
| FR-MARRIAGE-001 | WORKFLOW_ADAT.md | WF-PRK-01 |
| FR-VALIDATION-001 | BUSINESS_RULE.md | BR-VAL |
| NFR-PERF-002 | BUSINESS_RULE.md | BR-KKB-001 |
| SEC-AUTH-002 | USE_CASE.md | Aktor Sistem |

---

## GLOSSARY

| Term | Definisi |
|------|----------|
| PII | Personally Identifiable Information |
| RBAC | Role-Based Access Control |
| JWT | JSON Web Token |
| TOTP | Time-based One-Time Password |
| PKI | Public Key Infrastructure |
| RTO | Recovery Time Objective |
| RPO | Recovery Point Objective |
| MTTR | Mean Time To Repair |
| SAST | Static Application Security Testing |
| DAST | Dynamic Application Security Testing |

---

**Referensi:** USE_CASE.md, WORKFLOW_ADAT.md, BUSINESS_RULE.md

© 2026 Tarombo Digital Project
