# BUSINESS RULE
## Aturan Bisnis dan Validasi Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Aturan Dasar](#1-aturan-dasar)
2. [Aturan Marga](#2-aturan-marga)
   - 2.3 Konfigurasi Sub-Suku ← BARU
3. [Aturan Kekerabatan](#3-aturan-kekerabatan)
4. [Aturan Perkawinan](#4-aturan-perkawinan)
5. [Aturan Validasi Data](#5-aturan-validasi-data)
6. [Aturan Akses](#6-aturan-akses)
7. [Aturan Generasi](#7-aturan-generasi)
8. [Aturan Tulang](#8-aturan-tulang)
9. [Aturan Namboru](#9-aturan-namboru)
10. [Aturan Bere](#10-aturan-bere)
11. [Aturan Pariban](#11-aturan-pariban)
12. [Aturan Dongan Tubu](#12-aturan-dongan-tubu)
13. [Aturan Hula-hula](#13-aturan-hula-hula)
14. [Aturan Boru](#14-aturan-boru)
15. [Aturan Dalihan Na Tolu](#15-aturan-dalihan-na-tolu)
16. [Aturan Acara Adat](#16-aturan-acara-adat)
17. [Aturan Punguan](#17-aturan-punguan)
18. [Aturan Bantuan Duka](#18-aturan-bantuan-duka)
19. [Aturan Dokumen](#19-aturan-dokumen)
20. [Aturan AI Tarombo](#20-aturan-ai-tarombo)
21. [Aturan Riwayat Perubahan](#21-aturan-riwayat-perubahan)

---

## 1. ATURAN DASAR

### 1.1 Prinsip Utama

| ID | Prinsip | Implementasi |
|----|---------|--------------|
| P01 | **Patrilinealitas** | Marga diturunkan dari ayah ke anak |
| P02 | **Exogami** | Tidak boleh nikah sesama marga |
| P03 | **Hierarki Generasi** | Generasi menentukan partuturan |
| P04 | **Hula-hula Primacy** | Hula-hula posisi tertinggi |

### 1.2 Aturan Person

```
BR-SYS-001: Person WAJIB memiliki:
  - person_id (UUID)
  - full_name (min 2 karakter)
  - marga_id (valid dari registry)
  - gender (MALE/FEMALE)
  - sub_suku (TOBA/KARO/SIMALUNGUN/MANDAILING/ANGKOLA/PAKPAK)

BR-SYS-002: Uniqueness: full_name + marga + birth_date + father's_name

BR-SYS-003: Marga TIDAK DAPAT diubah setelah dibuat
  KECUALI: Proses adat resmi atau approval admin budaya

BR-SYS-004: Gender WAJIB ditentukan dan tidak dapat diubah
  jika sudah memiliki relasi kekerabatan
```

### 1.3 Aturan Relasi

| ID | Aturan | Constraint |
|----|--------|------------|
| BR-SYS-005 | Maksimal 1 ayah biologis | Strict |
| BR-SYS-006 | Maksimal 1 ibu biologis | Strict |
| BR-SYS-007 | Laki-laki: 0..N istri (histori/poligami) | Flexible |
| BR-SYS-008 | Perempuan: maksimal 1 suami pada satu waktu | Strict |
| BR-SYS-009 | Anak: 0..N | No limit |
| BR-SYS-010 | Jenis relasi: BIOLOGIS/ADOPSI/STEPPARENT | Enum |

---

## 2. ATURAN MARGA

### 2.1 Validasi Marga

```sql
BR-MRG-001: Marga harus ada di official_marga_registry
BR-MRG-002: Person mewarisi marga dari ayah (patrilineal inheritance)

CREATE TRIGGER inherit_marga
BEFORE INSERT ON person
FOR EACH ROW
BEGIN
  IF NEW.father_id IS NOT NULL THEN
    NEW.marga_id = (SELECT marga_id FROM person WHERE person_id = NEW.father_id);
  END IF;
END;
```

### 2.2 Larangan Perkawinan Marga

| ID | Marga 1 | Marga 2 | Status |
|----|---------|---------|--------|
| BR-MRG-003 | Marbun | Sihotang | TERLARANG |
| BR-MRG-004 | Nainggolan | Siregar | TERLARANG |
| BR-MRG-005 | [Any] | [Same] | TERLARANG |

```python
def validate_marriage_marga(male_marga, female_marga):
    # Check same marga
    if male_marga == female_marga:
        return {"valid": False, "code": "SAME_MARGA"}
    
    # Check prohibited pairs
    prohibited = [
        ("Marbun", "Sihotang"),
        ("Nainggolan", "Siregar"),
        ("Sihotang", "Marbun"),
        ("Siregar", "Nainggolan")
    ]
    
    if (male_marga, female_marga) in prohibited:
        return {"valid": False, "code": "PROHIBITED_PAIR"}
    
    return {"valid": True}
```

### 2.3 Struktur Database Marga

```sql
-- Tabel Marga
CREATE TABLE marga (
    marga_id UUID PRIMARY KEY,
    marga_name VARCHAR(50) UNIQUE NOT NULL,
    sub_suku ENUM('TOBA','KARO','SIM','MAN','ANG','PAK'),
    ancestor_name VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    verified_by UUID,
    verification_date TIMESTAMP
);

-- Tabel Larangan
CREATE TABLE marga_prohibition (
    prohibition_id UUID PRIMARY KEY,
    marga_1_id UUID REFERENCES marga(marga_id),
    marga_2_id UUID REFERENCES marga(marga_id),
    prohibition_type ENUM('ABSOLUTE','CONDITIONAL'),
    reason TEXT
);
```

### 2.3 Konfigurasi Sub-Suku

Sistem harus mendukung variasi aturan adat per sub-suku:

```sql
-- Sub-suku configuration table
CREATE TABLE sub_suku_config (
    sub_suku_code VARCHAR(20) PRIMARY KEY, -- TOBA, KARO, SIMALUNGUN, dll
    system_name VARCHAR(50),                -- Dalihan Na Tolu / Rakut Sitelu / Sisadapur
    hula_hula_term VARCHAR(50),           -- Hula-hula / Kalimbubu
    dongan_tubu_term VARCHAR(50),         -- Dongan Tubu / Sembuyak
    boru_term VARCHAR(50),                -- Boru / Anak Beru
    hierarchy_type VARCHAR(20),           -- HIERARCHICAL / EQUAL / ISLAM_ADAPT
    allowed_marriage_rules JSON           -- Variasi aturan perkawinan
);

-- Data konfigurasi
INSERT INTO sub_suku_config VALUES
('TOBA', 'Dalihan Na Tolu', 'Hula-hula', 'Dongan Tubu', 'Boru', 'HIERARCHICAL', 
 '{"same_marga": "FORBIDDEN", "specific_pairs": ["Marbun-Sihotang", "Nainggolan-Siregar"]}'),

('KARO', 'Rakut Sitelu', 'Kalimbubu', 'Sembuyak', 'Anak Beru', 'HIERARCHICAL',
 '{"same_marga": "FORBIDDEN", "kutain_system": true}'),

('SIMALUNGUN', 'Harungguan Manriah', 'Hula-hula', 'Dongan Tubu', 'Boru', 'EQUAL',
 '{"same_marga": "FORBIDDEN", "four_royal_marga": ["Sinaga", "Saragih", "Damanik", "Purba"]}'),

('MANDAILING', 'Dalihan Na Tolu (Islam Adaptation)', 'Hula-hula', 'Dongan Tubu', 'Boru', 'ISLAM_ADAPT',
 '{"same_marga": "FORBIDDEN", "greeting": "Santun Dongan", "poligamy_rules": "ISLAMIC"}'),

('ANGKOLA', 'Dalihan Na Tolu (Islam Adaptation)', 'Hula-hula', 'Dongan Tubu', 'Boru', 'ISLAM_ADAPT',
 '{"same_marga": "FORBIDDEN", "greeting": "Santun Dongan"}'),

('PAKPAK', 'Dalihan Na Tolu', 'Hula-hula', 'Dongan Tubu', 'Boru', 'HIERARCHICAL',
 '{"same_marga": "FORBIDDEN", "motto": "Ulang Telpus Bulung"}');
```

| Aturan | TOBA | KARO | SIMALUNGUN | MANDAILING | PAKPAK |
|--------|------|------|------------|------------|--------|
| **Sistem Kekerabatan** | Dalihan Na Tolu | Rakut Sitelu | Harungguan Manriah | Dalihan Na Tolu (adaptasi) | Dalihan Na Tolu |
| **Terminologi Hula-hula** | Hula-hula | Kalimbubu | Hula-hula | Hula-hula | Hula-hula |
| **Terminologi Dongan Tubu** | Dongan Tubu | Sembuyak | Dongan Tubu | Dongan Tubu | Dongan Tubu |
| **Terminologi Boru** | Boru | Anak Beru | Boru | Boru | Boru |
| **Struktur Marga** | Hierarkis 100+ | 5 Karo-karo | 4 Raja sederajat | Hierarkis | Terbatas ketat |
| **Salam Adat** | Horas | Horas | Horas | Santun Dongan | Horas |

---

## 3. ATURAN KEKERABATAN

### 3.1 Algoritma Partuturan

```python
def calculate_partuturan(viewer, target):
    # BR-KKB-001: Same marga
    if viewer.marga == target.marga:
        if viewer.father == target.father:
            return sibling_partuturan(viewer, target)
        else:
            return "Dongan" + generation_gap(viewer, target)
    
    # BR-KKB-002: Mother's brother
    if is_mothers_brother(target, viewer):
        return {"term": "Tulang", "priority": "HIGH", "respect": True}
    
    # BR-KKB-003: Father's sister
    if is_fathers_sister(target, viewer):
        return {"term": "Namboru", "priority": "HIGH", "pariban": True}
    
    # BR-KKB-004: Spouse
    if is_spouse(target, viewer):
        return "Boru" if target.gender == "FEMALE" else "Doli"
    
    return calculate_extended_kinship(viewer, target)
```

### 3.2 Mapping Partuturan

| ID | Kondisi | Partuturan | Level |
|----|---------|------------|-------|
| BR-KKB-005 | Ayah kandung | Amang/Among/Bapa | Primary |
| BR-KKB-006 | Ibu kandung | Inang/Inong/Omak | Primary |
| BR-KKB-007 | Kakak laki-laki | Haha/Angkang | Primary |
| BR-KKB-008 | Kakak perempuan | Haha/Angkang | Primary |
| BR-KKB-009 | Adik laki-laki | Agi/Anggi | Primary |
| BR-KKB-010 | Adik perempuan | Agi/Anggi | Primary |
| BR-KKB-011 | Saudara beda gender | Iboto/Ito | Primary |
| BR-KKB-012 | Abang ayah | Amang Tua | Secondary |
| BR-KKB-013 | Adik ayah | Amang Uda | Secondary |
| BR-KKB-014 | Saudari ayah | Namboru | Secondary |
| BR-KKB-015 | Suami namboru | Amang Boru | Secondary |
| BR-KKB-016 | Saudara laki ibu | Tulang | High |
| BR-KKB-017 | Istri tulang | Nantulang | High |
| BR-KKB-018 | Anak laki tulang | Lae | Normal |
| BR-KKB-019 | Anak perempuan tulang | Eda | Normal |
| BR-KKB-020 | Mertua laki | Simatua doli | High |
| BR-KKB-021 | Mertua perempuan | Simatua boru | High |
| BR-KKB-022 | Menantu laki | Hela | High |
| BR-KKB-023 | Menantu perempuan | Parumaen | Normal |
| BR-KKB-024 | Calon menantu | Bere | Normal |
| BR-KKB-025 | Saudara laki istri | Tunggane | Normal |
| BR-KKB-026 | Kakek/Nenek | Ompu/Ompung | High |
| BR-KKB-027 | Cucu | Pahompu/Hompu | Normal |

### 3.3 Aturan Pariban

```
BR-KKB-028: PARIBAN DETECTION

Pariban terjadi antara:
- Anak laki-laki saudari ayah (Namboru)
- Anak perempuan saudara laki ibu (Tulang)

Kalkulasi:
  IF (viewer.gender == MALE AND
      viewer.father.female_sibling.has_daughter(target)) OR
     (viewer.gender == FEMALE AND
      viewer.mother.male_sibling.has_daughter(target)):
    
    status = "PARIBAN"
    ideal_spouse = True
    priority_in_courtship = True
```

---

## 4. ATURAN PERKAWINAN

### 4.1 Status Perkawinan

| ID | Status | Transisi |
|----|--------|----------|
| BR-PRK-001 | SINGLE | → ENGAGED, MARRIED |
| BR-PRK-002 | ENGAGED | → MARRIED, SINGLE |
| BR-PRK-003 | MARRIED | → DIVORCED, WIDOWED |
| BR-PRK-004 | DIVORCED | → MARRIED, SINGLE |
| BR-PRK-005 | WIDOWED | → MARRIED |

### 4.2 Validasi Perkawinan

```python
class MarriageValidator:
    def validate(self, marriage_data):
        checks = [
            self._check_marga_compatibility,
            self._check_existing_marriage,
            self._check_consanguinity,
            self._check_generational_gap
        ]
        
        for check in checks:
            result = check(marriage_data)
            if not result["valid"]:
                return result
        
        return {"valid": True}
    
    def _check_marga_compatibility(self, data):
        """BR-PRK-006"""
        return validate_marriage_marga(
            data.husband.marga,
            data.wife.marga
        )
    
    def _check_existing_marriage(self, data):
        """BR-PRK-007"""
        if data.wife.current_spouse:
            return {"valid": False, "code": "WIFE_ALREADY_MARRIED"}
        return {"valid": True}
    
    def _check_consanguinity(self, data):
        """BR-PRK-008: Cek hubungan darah"""
        relatedness = calculate_relatedness(
            data.husband.person_id,
            data.wife.person_id
        )
        
        if relatedness.degree <= 1:  # Parent/sibling
            return {"valid": False, "code": "CONSANGUINITY_VIOLATION"}
        
        return {"valid": True}
```

### 4.3 Tahapan Perkawinan Adat

```
BR-PRK-009: SEQUENCE WAJIB (dalam urutan)

1. Mangarisika    ──► Penjajakan
     │
2. Martumpol      ──► Pertunangan (min 1 minggu dari #1)
     │
3. Martonggo Raja ──► Pemberitahuan resmi (min 1 minggu dari #2)
     │
4. Marsibuha Buhai──► Penjemputan pengantin (Hari H)
     │
5. Pemberkatan    ──► Akad/perkawinan resmi
     │
6. Mangulosi      ──► Pemberian ulos
     │
7. Paulak Une     ──► Penutupan

VALIDASI SETIAP TAHAP:
- Minimal 2 witness
- Raja Parhata tercatat
- Timestamp tercatat
```

### 4.4 Pihak dalam Perkawinan

| Peran | Definisi | Kewajiban Sistem |
|-------|----------|------------------|
| **Parboru** | Orang tua pengantin wanita | Mencatat sinamot diterima |
| **Paranak** | Orang tua pengantin pria | Mencatat sinamot diberikan |
| **Hula-hula Parboru** | Tulang pihak wanita | Validator pertama |
| **Hula-hula Paranak** | Tulang pihak pria | Validator kedua |
| **Dongan Tubu** | Sesama marga | Pendukung acara |
| **Raja Parhata** | Protokol | Validator setiap tahap |

---

## 5. ATURAN VALIDASI DATA

### 5.1 Tingkat Validasi

| Level | Nama | Deskripsi |
|-------|------|-----------|
| L0 | DRAFT | Data entry awal |
| L1 | SELF_VERIFIED | Diverifikasi sendiri |
| L2 | FAMILY_VERIFIED | Approval 2 anggota keluarga |
| L3 | COMMUNITY_VERIFIED | Approval 2 dongan tubu |
| L4 | ELDER_VERIFIED | Approval 1 tetua adat |
| L5 | OFFICIAL | Approval admin budaya |

### 5.2 Aturan Perubahan

```python
def validate_modification(field, old_value, new_value, current_level, user_role):
    CRITICAL_FIELDS = ['marga_id', 'father_id', 'mother_id', 'gender']
    
    if field in CRITICAL_FIELDS:
        if current_level >= 3:
            return {
                "allowed": False,
                "reason": "Field kritis - memerlukan proses adat formal"
            }
        
        if user_role not in ['ADMIN_BUDAYA', 'TETUA_ADAT']:
            return {
                "allowed": False,
                "reason": "Memerlukan hak akses khusus"
            }
    
    # Log semua perubahan
    log_modification(field, old_value, new_value, user_role)
    
    return {"allowed": True}
```

---

## 6. ATURAN AKSES

### 6.1 Matriks Akses (CRUD)

| Peran | Data Sendiri | Keluarga | Marga | Publik |
|-------|:------------:|:--------:|:-----:|:------:|
| User Biasa | CRUD | R | - | R-Limited |
| Verified User | CRUD | CRUD | R | R |
| Tetua Adat | CRUD | CRUD | CRUD | R |
| Admin Budaya | CRUD | CRUD | CRUD | CRUD |
| Admin Sistem | CRUD | CRUD | CRUD | CRUD |

### 6.2 Tingkat Privasi

```
BR-ACC-001: KATEGORI DATA

PUBLIK (Semua user):
  - Nama lengkap
  - Marga
  - Generasi

KELUARGA (Keluarga + Dongan Tubu):
  - Tanggal lahir
  - Tempat lahir
  - Status pernikahan
  - Nama orang tua

PRIVAT (Keluarga inti):
  - Alamat lengkap
  - Nomor telepon
  - Email
  - Pekerjaan detail

SENSITIF (Approval):
  - Dokumen identitas
  - Informasi keuangan
  - Data medis
```

---

## 7. ATURAN GENERASI

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-GEN-001 | Generasi dihitung relatif terhadap leluhur | Leluhur = Gen 0, Anak = Gen 1, Cucu = Gen 2 |
| BR-GEN-002 | Sistem menghitung generasi otomatis | Auto-calculate saat insert/update father |

---

## 8. ATURAN TULANG (HUBUNGAN GARIS IBU)

| ID | Aturan | Formula |
|----|--------|---------|
| BR-TUL-001 | Tulang adalah saudara laki-laki ibu | IBU → SAUDARA LAKI-LAKI |
| BR-TUL-002 | Semua saudara laki-laki ibu termasuk Tulang | Semua saudara kandung dan sebapak dari ibu |
| BR-TUL-003 | Anak Tulang bukan Tulang | Hubungan berubah menjadi Lae (laki) atau Eda (perempuan) |

---

## 9. ATURAN NAMBORU (HUBUNGAN GARIS AYAH)

| ID | Aturan | Formula |
|----|--------|---------|
| BR-NBR-001 | Namboru adalah saudara perempuan ayah | AYAH → SAUDARA PEREMPUAN |
| BR-NBR-002 | Suami Namboru disebut Amangboru | Amangboru = Suami(Namboru) |

---

## 10. ATURAN BERE

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-BER-001 | Bere adalah anak dari saudara perempuan | Anak dari saudari kandung atau seibu |
| BR-BER-002 | Hubungan Tulang ↔ Bere dihitung dua arah | Tulang dapat melihat Bere, dan sebaliknya |

---

## 11. ATURAN PARIBAN

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-PAR-001 | Pariban ditentukan berdasarkan aturan adat | Support multi-sub-suku dengan konfigurasi |
| BR-PAR-002 | Aturan Pariban dapat bervariasi antar daerah | Tidak boleh hardcoded, configurable |
| BR-PAR-003 | Pariban harus dihitung menggunakan konfigurasi adat | Database-driven configuration |

```
KONFIGURASI PARIBAN PER SUB-SUKU:

TOBA: Anak laki-laki Namboru ↔ Anak perempuan Tulang
KARO: Variasi konsep "kalimbubu" 
SIMALUNGUN: Konsep "pariban" mungkin berbeda
```

---

## 12. ATURAN DONGAN TUBU

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-DTG-001 | Dongan Tubu adalah sesama marga | Sesama marga = Dongan Tubu |
| BR-DTG-002 | Dongan Tubu dapat dibatasi berdasarkan | Marga, Cabang, atau Leluhur |

---

## 13. ATURAN HULA-HULA

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-HUL-001 | Hula-hula adalah pihak pemberi perempuan | Keluarga yang memberikan istri |
| BR-HUL-002 | Hula-hula dihitung berdasarkan konteks acara | Dynamic calculation per event |
| BR-HUL-003 | Seseorang dapat berbeda peran per acara | Hula-hula di Acara A, Boru di Acara B |

---

## 14. ATURAN BORU

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-BOR-001 | Boru adalah pihak penerima perempuan | Keluarga yang menerima istri |
| BR-BOR-002 | Hubungan Boru bersifat kontekstual | Dihitung per acara, tidak fixed |

---

## 15. ATURAN DALIHAN NA TOLU

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-DNT-001 | Setiap acara adat harus menghasilkan 3 komponen | Hula-hula, Dongan Tubu, Boru |
| BR-DNT-002 | Jika komponen tidak ditemukan, beri peringatan | Warning untuk incomplete Dalihan Na Tolu |

---

## 16. ATURAN ACARA ADAT

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-ACR-001 | Setiap acara harus memiliki Tanggal, Lokasi, Penanggung Jawab | Required fields |
| BR-ACR-002 | Acara dapat memiliki lebih dari satu Suhut | Multiple suhut support |
| BR-ACR-003 | Acara harus memiliki struktur adat | Template berdasarkan jenis acara |

---

## 17. ATURAN PUNGUAN

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-PUN-001 | Satu orang dapat menjadi anggota lebih dari satu punguan | Many-to-many relationship |
| BR-PUN-002 | Setiap punguan memiliki Pengurus, Anggota, Periode Kepengurusan | Organizational structure |

---

## 18. ATURAN BANTUAN DUKA

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-BND-001 | Penerima santunan harus anggota aktif | Membership validation |
| BR-BND-002 | Nominal santunan harus mengikuti aturan punguan | Configurable per punguan |
| BR-BND-003 | Riwayat santunan tidak boleh dihapus | Audit trail permanen |

---

## 19. ATURAN DOKUMEN

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-DOK-001 | Dokumen harus memiliki pemilik | Owner field mandatory |
| BR-DOK-002 | Dokumen dapat diberi tingkat akses | PUBLIC, RESTRICTED, CONFIDENTIAL |

---

## 20. ATURAN AI TAROMBO

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-AIT-001 | AI tidak boleh membuat hubungan yang tidak dapat dibuktikan | Evidence-based only |
| BR-AIT-002 | AI harus menunjukkan jalur hubungan | Full path visualization |
| BR-AIT-003 | Setiap hasil AI harus dapat ditelusuri ke data sumber | Source traceability |

```
CONTOH OUTPUT AI TAROMBO:

Budi
→ Anak dari: Maman (Ayah)
→ Cucu dari: Togatorop (Kakek)
→ Ponakan dari: Simanjuntak (Tulang)

Berdasarkan data terverifikasi:
✓ Budi.person_id = xxx
✓ Maman.person_id = yyy (VERIFIED)
✓ Togatorop.person_id = zzz (VERIFIED)
```

---

## 21. ATURAN RIWAYAT PERUBAHAN (HISTORY)

| ID | Aturan | Implementasi |
|----|--------|--------------|
| BR-HIS-001 | Perubahan hubungan keluarga (ayah, ibu, pasangan) harus diverifikasi | Status: PENDING |
| BR-HIS-002 | Riwayat perubahan ayah atau ibu tidak boleh dihapus | Soft delete + audit trail |
| BR-HIS-003 | Semua perubahan dicatat dengan: Siapa, Kapan, Apa yang diubah | Audit log lengkap |
| BR-HIS-004 | Audit tidak boleh dihapus | Immutable log |

---

## MATRIKS KEPUTUSAN

### Keputusan Otomatis

| Situasi | Aturan | Keputusan |
|---------|--------|-----------|
| Pendaftaran baru | BR-SYS-001 | Auto-approve jika lengkap |
| Perubahan non-kritis | BR-VAL | Auto-approve, logged |
| Perkawinan valid | BR-PRK | Auto-update status |
| Query partuturan | BR-KKB | Auto-calculate |

### Keputusan Manual

| Situasi | Aturan | Proses |
|---------|--------|--------|
| Perubahan marga | BR-SYS-003 | Review 2 tetua adat |
| Perkawinan terlarang | BR-MRG | Auto-reject + notifikasi |
| Data konflik | BR-VAL | Escalate admin budaya |

---

## RINGKASAN ATURAN

Dokumen ini mencakup **21 Bagian** dengan **100+ Business Rules** yang menjadi dasar:

| Engine | Rules yang Digunakan |
|--------|------------------------|
| **Relationship Engine** | BR-SYS, BR-GEN, BR-TUL, BR-NBR, BR-BER |
| **Dalihan Na Tolu Engine** | BR-HUL, BR-BOR, BR-DTG, BR-DNT |
| **Pariban Engine** | BR-PAR |
| **Event Engine** | BR-ACR, BR-PUN, BR-BND |
| **AI Tarombo Engine** | BR-AIT |
| **Validation Engine** | BR-SYS, BR-HIS, BR-VAL |
| **Security Engine** | BR-DOK, BR-ACC |

---

**Referensi:** ANALISIS_BUDAYA_BATAK.md, KAMUS_ISTILAH_ADAT_BATAK.md

© 2026 Tarombo Digital Project
