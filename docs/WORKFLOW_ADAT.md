# WORKFLOW ADAT
## Alur Kerja Prosesi Adat dalam Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Workflow Overview](#1-workflow-overview)
2. [Workflow Pendaftaran dan Verifikasi](#2-workflow-pendaftaran-dan-verifikasi)
3. [Workflow Perkawinan Adat](#3-workflow-perkawinan-adat)
4. [Workflow Pencatatan Kelahiran](#4-workflow-pencatatan-kelahiran)
5. [Workflow Kematian dan Warisan](#5-workflow-kematian-dan-warisan)
6. [Workflow Perbaikan Data](#6-workflow-perbaikan-data)
7. [Workflow Validasi dan Approvals](#7-workflow-validasi-dan-approvals)
8. [Workflow Kekerabatan Engine](#8-workflow-kekerabatan-engine) ← BARU
9. [Workflow Dalihan Na Tolu Engine](#9-workflow-dalihan-na-tolu-engine) ← BARU
10. [Workflow Punguan & Organisasi](#10-workflow-punguan--organisasi) ← BARU
11. [Workflow Dokumen & Arsip](#11-workflow-dokumen--arsip) ← BARU
12. [Workflow Geografis & Makam](#12-workflow-geografis--makam) ← BARU
13. [Workflow AI Tarombo](#13-workflow-ai-tarombo) ← BARU
14. [Workflow Audit & Keamanan](#14-workflow-audit--keamanan) ← BARU
15. [Workflow Integrasi & Koneksi](#15-workflow-integrasi--koneksi) ← BARU

---

## 1. WORKFLOW OVERVIEW

### 1.1 Diagram Alur Utama

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      WORKFLOW UTAMA SISTEM                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐     ┌───────────┐         │
│  │ REGISTRASI│────►│ VERIFIKASI│────►│  INPUT    │────►│ VALIDASI  │         │
│  │  USER     │     │  IDENTITAS│     │  DATA     │     │  DATA     │         │
│  └───────────┘     └───────────┘     └───────────┘     └───────────┘         │
│                                                              │              │
│                              ┌───────────────────────────────┘              │
│                              ▼                                              │
│                       ┌───────────┐                                         │
│                       │  PENGGUNA │                                         │
│                       │  AKTIF    │                                         │
│                       └─────┬─────┘                                         │
│                             │                                               │
│          ┌──────────────────┼──────────────────┐                           │
│          │                  │                  │                            │
│          ▼                  ▼                  ▼                            │
│   ┌──────────┐      ┌──────────┐      ┌──────────┐                         │
│   │ PERKAWINAN│      │ KELAHIRAN │      │ KEMATIAN │                         │
│   │  ADAT    │      │          │      │          │                         │
│   └──────────┘      └──────────┘      └──────────┘                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Kategori Workflow

| Kode | Kategori | Deskripsi | Aktor Utama |
|------|----------|-----------|-------------|
| WF-REG | Registrasi | Alur pendaftaran dan verifikasi user | User, System |
| WF-PRK | Perkawinan | Alur pencatatan dan validasi perkawinan | Keluarga, Tetua |
| WF-LHR | Kelahiran | Alur pencatatan kelahiran | Orang Tua, System |
| WF-MAT | Kematian | Alur pencatatan kematian dan warisan | Keluarga, Tetua |
| WF-VAL | Validasi | Alur validasi data | Semua Level |
| WF-CRK | Koreksi | Alur perbaikan data | User, Admin |
| WF-REL | Kekerabatan | Alur perhitungan hubungan (Tulang, Namboru, Bere) | System, AI |
| WF-DNT | Dalihan Na Tolu | Alur perhitungan struktur adat | System, Tetua |
| WF-PUN | Punguan | Alur organisasi marga dan keuangan | Admin Punguan |
| WF-DOC | Dokumen | Alur upload dan management arsip | User, Admin |
| WF-GEO | Geografis | Alur pendataan makam dan peta | User, Admin |
| WF-AI | AI Tarombo | Alur query AI dan NLP | User, AI System |
| WF-AUD | Audit | Alur logging dan backup | Admin Sistem |
| WF-SYNC | Integrasi | Alur sinkronisasi tarombo | Verifikator, Admin |

---

## 2. WORKFLOW PENDAFTARAN DAN VERIFIKASI

### 2.1 Workflow Registrasi User (WF-REG-01)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  START  │────►│  INPUT  │────►│ VALIDASI│────►│  EMAIL  │────►│ KONFIRMA│
│         │     │  DATA   │     │  FORMAT │     │  KIRIM  │     │  SI     │
└─────────┘     └─────────┘     └────┬────┘     └─────────┘     └────┬────┘
                                     │                              │
                              ┌──────┴──────┐                       │
                              │             │                       │
                              ▼             ▼                       ▼
                        ┌─────────┐   ┌─────────┐              ┌─────────┐
                        │  ERROR  │   │  VALID  │              │  CEK    │
                        │  INPUT  │   │  LANJUT │              │  EMAIL  │
                        │         │   │         │              │         │
                        └────┬────┘   └─────────┘              └────┬────┘
                             │                                       │
                             │    ┌──────────────────────────────────┘
                             │    │
                             ▼    ▼
                        ┌─────────────────────────────────────────────┐
                        │         EMAIL TERKONFIRMASI                 │
                        │              (Status: DRAFT)                │
                        └─────────────────────┬───────────────────────┘
                                                │
                                                ▼
                        ┌─────────────────────────────────────────────┐
                        │        VERIFIKASI IDENTITAS (Opsional)      │
                        │              (Menuju: VERIFIED USER)        │
                        └─────────────────────────────────────────────┘
```

**Langkah Detail:**

| Step | Aksi | Aktor | Output | Durasi Estimasi |
|------|------|-------|--------|-----------------|
| 1 | Akses form registrasi | User | Form tersedia | - |
| 2 | Isi data: nama, email, password, marga | User | Data entry | 5 menit |
| 3 | Validasi format | Sistem | Valid/Invalid | Real-time |
| 4 | Cek duplikasi email | Sistem | Unique/Duplicate | <1 detik |
| 5 | Kirim email verifikasi | Sistem | Email sent | <1 menit |
| 6 | User klik link verifikasi | User | Email confirmed | - |
| 7 | Aktivasi akun (Status: DRAFT) | Sistem | Account active | Real-time |
| 8 | (Opsional) Upload identitas | User | Dokumen uploaded | 5 menit |
| 9 | (Opsional) Review identitas | Admin | Identity verified | 1-2 hari |
| 10 | Upgrade status ke VERIFIED | Sistem | Status updated | Real-time |

**Status Akun:**
```
DRAFT ──► SELF_VERIFIED ──► IDENTITY_PENDING ──► VERIFIED
  │            │                  │
  │            ▼                  ▼
  │        REJECTED          REJECTED
  │            │                  │
  └────────────┴──────────────────┘
              │
              ▼
        SUSPENDED (pelanggaran)
```

---

## 3. WORKFLOW PERKAWINAN ADAT

### 3.1 Overview Workflow Perkawinan (WF-PRK-01)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    WORKFLOW PERKAWINAN ADAT                             │
│                         (7 Tahapan Utama)                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐     │
│  │ MANGARI │──►│ MARTUM  │──►│ MARTONG │──►│ MARSIBU │──►│ PEMBER  │     │
│  │  SIKA   │   │  POL    │   │ GO RAJA │   │HA BUHAI │   │ KATAN   │     │
│  └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘     │
│       │             │             │             │             │         │
│       ▼             ▼             ▼             ▼             ▼         │
│   ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐    ┌───────┐         │
│   │Input  │    │Validasi│    │Notifikasi│    │Protokol │    │Akad    │         │
│   │Data   │    │Tetua  │    │Masyarakat│    │Acara    │    │Resmi   │         │
│   └───────┘    └───────┘    └───────┘    └───────┘    └───────┘         │
│                                                                         │
│  ┌─────────┐   ┌─────────┐                                             │
│  │ MANGULO │──►│ PAULAK  │                                             │
│  │   SI    │   │  UNE    │                                             │
│  └────┬────┘   └────┬────┘                                             │
│       │             │                                                   │
│       ▼             ▼                                                   │
│   ┌───────┐    ┌───────┐                                               │
│   │Pemberian│    │Closing │                                               │
│   │Ulos    │    │Archive │                                               │
│   └───────┘    └───────┘                                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Detail Tahapan

#### Tahap 1: Mangarisika (WF-PRK-01-A)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Mangarisika |
| **Status** | Optional |
| **Durasi** | 1-4 minggu sebelum tahap 2 |

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  CALON  │────►│ UTUSAN  │────►│  PANTAU │────►│  HASIL  │
│  MEMPIN │     │  DATANG │     │  SIAP?  │     │         │
└─────────┘     └─────────┘     └────┬────┘     └─────────┘
                                     │
                          ┌──────────┴──────────┐
                          │                     │
                          ▼                     ▼
                   ┌─────────┐           ┌─────────┐
                   │ LANJUT  │           │ TUNDA/  │
                   │ TAHAP 2 │           │ BATAL   │
                   │         │           │         │
                   └────┬────┘           └─────────┘
                        │
                        ▼
                 ┌─────────────┐
                 │ CATAT SISTEM│
                 │ (Optional)  │
                 └─────────────┘
```

**Input Sistem:**
- Data pihak pria (calon pengantin)
- Data pihak wanita (calon pengantin)
- Tanggal mangarisika
- Hasil (lanjut/tunda/batal)

#### Tahap 2: Martumpol (WF-PRK-01-B)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Martumpol (Pertunangan) |
| **Status** | Wajib untuk adat besar |
| **Prerequisite** | Hasil mangarisika positif |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PARANAK    │────►│  PERSIAPAN  │────►│  PELAKSANAAN│
│  (Pihak     │     │  Acara      │     │  Martumpol  │
│   Pria)     │     │             │     │             │
└─────────────┘     └──────┬──────┘     └──────┬──────┘
                           │                     │
           ┌───────────────┴───────────────┐     │
           │                               │     │
           ▼                               ▼     │
    ┌─────────────┐                 ┌─────────────┐
    │  Input Data │                 │  TANDA      │
    │  ke Sistem  │                 │  HOLONG     │
    │             │                 │  (diterima) │
    └─────────────┘                 └──────┬──────┘
                                           │
                              ┌────────────┴────────────┐
                              │                         │
                              ▼                         ▼
                       ┌─────────────┐           ┌─────────────┐
                       │  LANJUT     │           │  TOLAK      │
                       │  TAHAP 3    │           │  (batal)    │
                       └─────────────┘           └─────────────┘
```

**Input Sistem:**
- Tanggal martumpol
- Lokasi
- Tanda holong (detail pemberian)
- Tanda mata (detail balasan)
- Saksi (minimal 2 orang per pihak)
- Bohi sinamot (jika ada)

#### Tahap 3: Martonggo Raja (WF-PRK-01-C)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Martonggo Raja |
| **Status** | Wajib |
| **Fungsi** | Pemberitahuan resmi ke masyarakat |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   SUHUT     │────►│  PEMBUATAN  │────►│  PENYEBARAN │
│  (Tuan      │     │  PENGUMUMAN │     │  INFORMASI  │
│   Rumah)    │     │             │     │             │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  CATAT      │
                    │  SISTEM     │
                    │  (notifikasi│
                    │  masyarakat)│
                    └─────────────┘
```

#### Tahap 4: Marsibuha Buhai (WF-PRK-01-D)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Marsibuha Buhai |
| **Status** | Wajib |
| **Waktu** | Hari H, pagi hari |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PARANAK    │────►│  TUDU-TUDU  │────►│  PENYERAHAN │────►│   MAKAN     │
│  DATANG     │     │  SIPANGANON │     │  DENGKE     │     │   BERSAMA   │
│             │     │  (makanan)  │     │  (ikan)     │     │             │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                                                     │
                                                                     ▼
                                                              ┌─────────────┐
                                                              │  KE GEREJA/ │
                                                              │  KUA        │
                                                              │  (tempat    │
                                                              │  pemberkatan)│
                                                              └─────────────┘
```

**Input Sistem:**
- Jam kedatangan paranak
- Daftar tudu-tudu (jenis dan jumlah)
- Dengke (jumlah, jenis ikan)
- Rombongan yang hadir (list person)
- Foto dokumentasi

#### Tahap 5: Pemberkatan (WF-PRK-01-E)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Pemberkatan Perkawinan |
| **Status** | Wajib |
| **Pelaksana** | Pejabat agama/civil registry |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  KEDATANGAN │────►│  AKAD/      │────►│  TANDA      │
│  DI TEMPAT  │     │  PEPERCAYAAN│     │  TANGAN     │
│  PEMBERKATAN│     │             │     │  (saksi)    │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  SUDAH      │
                    │  MENIKAH    │
                    │  (status    │
                    │  update)    │
                    └─────────────┘
```

**Update Sistem:**
- Status person: MARRIED
- Relasi: SPOUSE created
- Tanggal pernikahan: recorded
- Nomor akta: recorded (jika civil)

#### Tahap 6: Mangulosi (WF-PRK-01-F)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Mangulosi |
| **Status** | Wajib |
| **Fungsi** | Pemberian ulos sebagai restu |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  HULA-HULA  │────►│  PEMBERIAN  │────►│  DOA RESTU  │
│  & PARBORU  │     │  ULOS       │     │  (pasu-pasu)│
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │  ULOS KE    │ │  ULOS KE    │ │  ULOS KE    │
    │  PENGANTIN  │ │  ORANG TUA  │ │  HULA-HULA  │
    │             │ │  PENGANTIN  │ │  PARANAK    │
    └─────────────┘ └─────────────┘ └─────────────┘
```

**Jenis Ulos yang Dicatat:**

| Penerima | Pemberi | Jenis Ulos | Wajib |
|----------|---------|------------|-------|
| Paranak | Parboru | Pasamot/Pansamot | Ya |
| Hela | Parboru | Hela | Ya |
| Pamarai | Parboru | Pamarai | Ya |
| Simandokkon | Parboru | Simandokkon | - |
| Namborunya | Parboru | Namborunya | - |
| Hula-hula Parboru | Parboru | Hula-hula | Ya |
| Tulang Parboru | Parboru | Tulang | Ya |
| Hula-hula Paranak | Paranak | Hula-hula | Ya |
| Tulang Paranak | Paranak | Tulang | Ya |

**Input Sistem:**
- List pemberian ulos (dari, kepada, jenis)
- Foto setiap pemberian
- Umpasa/pasu-pasu (text)

#### Tahap 7: Paulak Une (WF-PRK-01-G)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Paulak Une (Penutupan) |
| **Status** | Wajib |
| **Fungsi** | Penutupan acara dengan kesimpulan |

**Workflow:**
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PERCAKAPAN │────►│  KESIMPULAN │────►│  PENUTUPAN  │
│  PENUTUP    │     │  ADAT       │     │  FORMAL     │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │  ARSIP      │
                                        │  DIGITAL    │
                                        │  (complete) │
                                        └─────────────┘
```

**Status Akhir:**
```
┌─────────────────────────────────────────────────────────┐
│              RIWAYAT PERKAWINAN TERSIMPAN                │
├─────────────────────────────────────────────────────────┤
│ • Data pengantin (lengkap)                              │
│ • Data orang tua kedua belah pihak                      │
│ • Riwayat 7 tahapan                                   │
│ • Dokumentasi foto/video                                │
│ • List pemberian ulos                                 │
│ • Detail sinamot (jumlah, bentuk)                      │
│ • Daftar hadir (rombongan)                              │
│ • Sertifikat adat digital (jika ada)                    │
└─────────────────────────────────────────────────────────┘
```

---

## 4. WORKFLOW PENCATATAN KELAHIRAN

### 4.1 Overview (WF-LHR-01)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ KELAHIRAN    │────►│ INPUT   │────►│ AUTO    │────►│ NOTIFIKASI│
│  ANAK   │     │  DATA   │     │  MARGA  │     │  KELUARGA │
└─────────┘     └────┬────┘     │  DARI   │     └─────────┘
                     │         │  AYAH   │
                     │         └─────────┘
                     │
                     ▼
              ┌─────────────┐
              │  UPDATE     │
              │  TAROMBO    │
              │  (generasi  │
              │  number)    │
              └─────────────┘
```

### 4.2 Detail Langkah

| Step | Aksi | Aktor | Output |
|------|------|-------|--------|
| 1 | Anak lahir | Alam | - |
| 2 | Orang tua/catat data | Orang Tua/Verified User | Data entry |
| 3 | Sistem auto-set marga | Sistem | Marga dari ayah |
| 4 | Sistem hitung generasi | Sistem | Generation number |
| 5 | Hubungkan dengan orang tua | Sistem | Relasi PARENT-CHILD |
| 6 | Notifikasi keluarga | Sistem | Notif ke: hula-hula, dongan tubu |
| 7 | (Opsional) Validasi | Keluarga | Status: FAMILY_VERIFIED |
| 8 | Entry complete | Sistem | Person active in system |

**Data yang Dicatat:**
- Nama lengkap anak
- Tanggal dan waktu lahir
- Tempat lahir
- Gender
- Marga (otomatis dari ayah)
- Orang tua (ayah dan ibu)
- Keterangan tambahan (jika ada)

---

## 5. WORKFLOW KEMATIAN DAN WARISAN

### 5.1 Overview (WF-MAT-01)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  KEMATIAN   │────►│ KATEGORI│────►│ UPACARA │────►│  UPDATE   │
│  ORANG  │     │  STATUS │     │  ADAT   │     │  STATUS     │
└─────────┘     └────┬────┘     └────┬────┘     │  & WARISAN │
                     │               │          └─────────┘
                     │               │
            ┌────────┴────────┐      │
            │                 │      │
            ▼                 ▼      │
     ┌──────────┐       ┌──────────┐│
     │SAUR MATUA│       │ BIASA    ││
     │ (Besar)  │       │(Sederhana││
     └────┬─────┘       └────┬─────┘│
          │                  │      │
          ▼                  ▼      │
     ┌──────────┐       ┌──────────┐│
     │PESTA ADAT│       │UPACARA   ││
     │(7 hari+) │       │SINGKAT   ││
     └──────────┘       └──────────┘
```

### 5.2 Kategori Kematian

| Kategori | Kriteria | Upacara | Input Sistem |
|----------|----------|---------|--------------|
| **Saur Matua** | Orang tua, anak sudah menikah, punya cucu | Besar, pesta adat | Lengkap dengan hula-hula |
| **Mate Saur Matua** | Orang tua, belum punya cucu | Sederhana | Standar |
| **Mate Bortian** | Bayi dalam kandungan | Dikubur langsung | Minimal |
| **Mate Na Soada** | Kecelakaan/bunuh diri | Ritual khusus | Keterangan khusus |

### 5.3 Workflow Warisan (WF-MAT-02)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ KEMATIAN    │────►│ IDENTIFIKASI│────►│ KALKULASI │────►│ PEMBAGIAN │
│  TERCATAT   │     │  AHLI WARIS │     │  HAK      │     │  (digital)│
└─────────┘     └─────────┘     └────┬────┘     └─────────┘
                                     │
                                     ▼
                              ┌─────────────┐
                              │  HIERARKI   │
                              │  DALIHAN    │
                              │  NA TOLU    │
                              │  APPLIED    │
                              └─────────────┘
```

**Hierarki Ahli Waris (Auto-calculate):**

```
Priority 1: Anak laki-laki (paranak)
    └── Jika ada: equal share
    └── Jika tidak ada → Priority 2

Priority 2: Anak perempuan (boru)
    └── Equal share (jika tidak ada anak laki)
    └── Jika tidak ada → Priority 3

Priority 3: Saudara laki-laki kandung (dongan tubu)
    └── Equal share
    └── Jika tidak ada → Priority 4

Priority 4: Saudara laki-laki sebapak
    └── Equal share
    └── Jika tidak ada → Priority 5

Priority 5: Hula-hula (tulang)
    └── Keturunan laki-laki hula-hula
```

---

## 6. WORKFLOW PERBAIKAN DATA

### 6.1 Overview (WF-CRK-01)

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ IDENTIFIKASI│────►│ SUBMIT  │────►│ REVIEW  │────►│ IMPLEMEN  │
│  KESALAHAN  │     │ REQUEST │     │  &      │     │  TASI     │
└─────────┘     └────┬────┘     │  DECISION│     └─────────┘
                     │          └────┬────┘
                     │               │
                     │    ┌──────────┴──────────┐
                     │    │                     │
                     │    ▼                     ▼
                     │ ┌─────────┐          ┌─────────┐
                     │ │APPROVED │          │ REJECTED│
                     │ │         │          │         │
                     │ └────┬────┘          └─────────┘
                     │      │
                     │      └──────────────────────┐
                     │                             │
                     ▼                             ▼
               ┌─────────────┐               ┌─────────────┐
               │  DATA       │               │  NOTIFIKASI │
               │  DIUPDATE   │               │  ALASAN     │
               │  + AUDIT    │               │             │
               └─────────────┘               └─────────────┘
```

### 6.2 Detail Workflow

| Step | Aksi | Aktor | Durasi |
|------|------|-------|--------|
| 1 | User identifikasi kesalahan | User | - |
| 2 | User submit request perbaikan | User | 10 menit |
| 3 | Sistem cek duplikasi request | Sistem | <1 menit |
| 4 | Assign reviewer | Sistem | Real-time |
| 5 | Reviewer evaluasi request | Reviewer | 1-3 hari |
| 6 | Decision: approve/reject | Reviewer | - |
| 7 | Jika approve: implementasi perubahan | Admin/System | 1 hari |
| 8 | Notifikasi hasil ke user | Sistem | Real-time |

**Reviewer Assignment berdasarkan Level:**

| Level Perubahan | Reviewer |
|-----------------|----------|
| Non-kritis | Keluarga (L2) atau Tetua (L3) |
| Semi-kritis | Tetua (L3) atau Admin Budaya (L4) |
| Kritis (marga, orang tua) | Admin Budaya (L5) |

---

## 7. WORKFLOW VALIDASI DAN APPROVALS

### 7.1 Overview Tingkat Validasi (WF-VAL-01)

```
DRAFT ─────► SELF_VERIFIED ─────► FAMILY_VERIFIED ─────► COMMUNITY_VERIFIED
  │                │                       │                       │
  │                │                       │                       │
  ▼                ▼                       ▼                       ▼
Input data    Konfirmasi diri    Approval 2 keluarga    Approval 2 dongan tubu
                                                                   │
                                                                   ▼
                                                         ┌───────────────────┐
                                                         │ ELDER_VERIFIED  │
                                                         │ (1 Tetua Adat)  │
                                                         └─────────┬─────────┘
                                                                   │
                                                                   ▼
                                                         ┌───────────────────┐
                                                         │    OFFICIAL       │
                                                         │ (Admin Budaya)    │
                                                         └───────────────────┘
```

### 7.2 Approval Matrix

| Level | Approver | Jumlah | Method | Status Result |
|-------|----------|--------|--------|---------------|
| L1 | Self | 1 | Email/SMS confirmation | SELF_VERIFIED |
| L2 | Family | 2 | In-app approval | FAMILY_VERIFIED |
| L3 | Dongan Tubu | 2 | In-app + tetua ack | COMMUNITY_VERIFIED |
| L4 | Tetua Adat | 1 | Digital signature | ELDER_VERIFIED |
| L5 | Admin Budaya | 1 | Admin panel approval | OFFICIAL |

---

## 8. WORKFLOW KEKERABATAN ENGINE

### 8.1 Workflow Pencarian Hubungan (WF-REL-01)

**Tujuan:** Menentukan hubungan dua orang

```
Alur:
┌─────────┐     ┌─────────┐     ┌─────────────┐     ┌─────────┐
│ Pilih   │────►│ Pilih   │────►│ Relationship│────►│ Cari    │
│ Orang A │     │ Orang B │     │ Engine      │     │ Jalur   │
└─────────┘     └─────────┘     └──────┬──────┘     └────┬────┘
                                       │                    │
                                       ▼                    ▼
                                ┌─────────────┐      ┌─────────┐
                                │ Hitung      │      │ Tampil  │
                                │ Hubungan    │      │ Hasil   │
                                └─────────────┘      └─────────┘

Output: Jenis Hubungan (Sepupu Tingkat 3, Tulang, dll)
```

### 8.2 Workflow Perhitungan Tulang (WF-REL-02)

**Tujuan:** Menentukan Tulang seseorang

```
Formula: IBU → SAUDARA LAKI-LAKI

Alur:
┌─────────┐     ┌─────────┐     ┌─────────────────────┐
│  Orang  │────►│ Cari    │────►│ Cari Saudara      │
│         │     │ Ibu     │     │ Laki-Laki Ibu     │
└─────────┘     └────┬────┘     └─────────┬───────────┘
                     │                    │
                     ▼                    ▼
              ┌─────────────┐      ┌─────────────┐
              │  Data Ibu   │      │ Daftar      │
              │  Ditemukan  │      │ Tulang      │
              └─────────────┘      └─────────────┘

Output: Daftar Tulang (dengan prioritas berdasarkan kedekatan)
```

### 8.3 Workflow Perhitungan Namboru (WF-REL-03)

**Tujuan:** Menentukan Namboru

```
Formula: AYAH → SAUDARA PEREMPUAN

Alur:
┌─────────┐     ┌─────────┐     ┌─────────────────────┐
│  Orang  │────►│ Cari    │────►│ Cari Saudara      │
│         │     │ Ayah    │     │ Perempuan Ayah    │
└─────────┘     └────┬────┘     └─────────┬───────────┘
                     │                    │
                     ▼                    ▼
              ┌─────────────┐      ┌─────────────┐
              │  Data Ayah  │      │ Daftar      │
              │  Ditemukan  │      │ Namboru     │
              └─────────────┘      └─────────────┘
```

### 8.4 Workflow Perhitungan Bere (WF-REL-04)

**Tujuan:** Menentukan Bere

```
Alur:
┌─────────┐     ┌─────────────────┐     ┌─────────────┐
│  Orang  │────►│ Cari Saudara    │────►│ Cari Anak   │
│         │     │ Perempuan       │     │ Mereka      │
└─────────┘     └────────┬────────┘     └──────┬──────┘
                         │                      │
                         ▼                      ▼
                  ┌─────────────┐        ┌─────────────┐
                  │ List Saudari│        │ Daftar      │
                  │             │        │ Bere        │
                  └─────────────┘        └─────────────┘
```

---

## 9. WORKFLOW DALIHAN NA TOLU ENGINE

### 9.1 Workflow Perhitungan Dalihan Na Tolu (WF-DNT-01)

**Tujuan:** Menentukan struktur adat tungku nan tolu

```
Alur:
┌─────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Pilih   │────►│ Identifikasi    │────►│ Identifikasi    │
│ Orang   │     │ Marga           │     │ Hula-Hula       │
└─────────┘     └────────┬────────┘     └────────┬────────┘
                         │                       │
                         ▼                       ▼
              ┌─────────────────┐     ┌─────────────────┐
              │ Identifikasi    │     │ Identifikasi    │
              │ Dongan Tubu     │     │ Boru            │
              └────────┬────────┘     └────────┬────────┘
                       │                       │
                       └───────────┬───────────┘
                                   │
                                   ▼
                         ┌─────────────────┐
                         │ Susun Struktur  │
                         │ Dalihan Na Tolu │
                         └─────────────────┘

Output: Struktur Adat Lengkap (Hula-hula, Dongan Tubu, Boru)
```

---

## 10. WORKFLOW PUNGUAN & ORGANISASI

### 10.1 Workflow Pembentukan Punguan (WF-PUN-01)

**Tujuan:** Membentuk organisasi marga

```
Alur:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Buat       │────►│  Input      │────►│  Tambah     │
│  Punguan    │     │  Data       │     │  Pengurus   │
└─────────────┘     └──────┬──────┘     └──────┬──────┘
                           │                     │
                           ▼                     ▼
                    ┌─────────────┐       ┌─────────────┐
                    │  Tambah     │       │  Status     │
                    │  Anggota    │       │  Aktif      │
                    └─────────────┘       └─────────────┘

Output: Punguan Baru Aktif
```

### 10.2 Workflow Pembayaran Iuran (WF-PUN-02)

**Tujuan:** Mencatat pembayaran anggota

```
Alur:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Input      │────►│  Validasi   │────►│  Verifikasi │
│  Pembayaran │     │  Data       │     │  Admin      │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │  Masuk Kas  │
                                        │  Terkonfirmasi│
                                        └─────────────┘

Output: Transaksi Iuran Terverifikasi
```

### 10.3 Workflow Bantuan Duka (WF-PUN-03)

**Tujuan:** Mengelola santunan kematian

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Input Anggota   │────►│ Verifikasi      │────►│ Hitung Hak      │
│ Meninggal       │     │ Keanggotaan     │     │ Santunan        │
└─────────────────┘     └────────┬────────┘     └────────┬────────┘
                                 │                        │
                                 ▼                        ▼
                          ┌─────────────────┐     ┌─────────────────┐
                          │ Anggota Aktif?  │────►│ Nominal Sesuai  │
                          │ (Ya/Tidak)      │     │ Aturan Punguan  │
                          └─────────────────┘     └────────┬────────┘
                                                           │
                                                           ▼
                                                    ┌─────────────────┐
                                                    │ Persetujuan →   │
                                                    │ Pembayaran →    │
                                                    │ Arsip Permanen  │
                                                    └─────────────────┘

Output: Transaksi Santunan Tercatat
```

---

## 11. WORKFLOW DOKUMEN & ARSIP

### 11.1 Workflow Upload Arsip Keluarga (WF-DOC-01)

**Tujuan:** Menyimpan dokumen sejarah keluarga

```
Alur:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Upload     │────►│  Isi        │────►│  Atur       │
│  File       │     │  Metadata   │     │  Hak Akses  │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │  Arsip      │
                                        │  Digital    │
                                        │  Tersimpan  │
                                        └─────────────┘

Jenis File: Foto, Video, Audio, PDF
Hak Akses: PUBLIC, RESTRICTED, CONFIDENTIAL
```

---

## 12. WORKFLOW GEOGRAFIS & MAKAM

### 12.1 Workflow Pendataan Makam Leluhur (WF-GEO-01)

**Tujuan:** Mendokumentasikan makam leluhur

```
Alur:
┌─────────────┐     ┌─────────────────┐     ┌─────────────┐
│  Tambah     │────►│  Input Lokasi   │────►│  Upload     │
│  Makam      │     │  GPS            │     │  Foto       │
└─────────────┘     └─────────────────┘     └──────┬──────┘
                                                 │
                                                 ▼
                                          ┌─────────────┐
                                          │  Verifikasi │
                                          │  → Publikasi│
                                          └─────────────┘

Output: Data Makam dengan Koordinat GPS dan Foto
```

---

## 13. WORKFLOW AI TAROMBO

### 13.1 Workflow AI Assistant (WF-AI-01)

**Tujuan:** Menjawab pertanyaan adat dan hubungan keluarga

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Input           │────►│ Analisis        │────►│ Cari Data       │
│ Pertanyaan      │     │ Pertanyaan      │     │ Tarombo         │
│ (Natural Lang)  │     │ (NLP Engine)    │     │                 │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
                                                  ┌─────────────────┐
                                                  │ Hitung Jalur    │
                                                  │ Tentukan        │
                                                  │ Hubungan        │
                                                  └────────┬────────┘
                                                           │
                                                           ▼
                                                    ┌─────────────────┐
                                                    │ Jawaban         │
                                                    │ Terstruktur     │
                                                    │ (dengan sumber) │
                                                    └─────────────────┘

Contoh Query:
- "Apa hubungan saya dengan Budi Simbolon?"
- "Siapa Tulang saya?"
- "Siapa Hula-hula dalam acara ini?"

Requirements: Evidence-based, Traceable, Explainable
```

---

## 14. WORKFLOW AUDIT & KEAMANAN

### 14.1 Workflow Audit Sistem (WF-AUD-01)

**Tujuan:** Mencatat seluruh aktivitas sistem

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Aktivitas       │────►│ Buat Audit Log  │────►│ Simpan          │
│ Terjadi         │     │ (Siapa, Kapan,  │     │ Permanen        │
│ (CRUD Operation)│     │ Apa, Hasil)     │     │ (Immutable)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘

Data Tercatat:
- Timestamp
- User/Aktor
- Tipe operasi (CREATE/UPDATE/DELETE)
- Entity yang diubah
- Nilai lama vs baru
- IP Address
- User Agent
```

### 14.2 Workflow Backup Data (WF-AUD-02)

**Tujuan:** Menjamin keamanan data

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Jadwal Backup   │────►│ Generate        │────►│ Enkripsi        │
│ (Otomatis)      │     │ Backup          │     │ (AES-256)       │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                         │
                              ┌──────────────────────────┴──────────┐
                              │                                     │
                              ▼                                     ▼
                       ┌─────────────────┐              ┌─────────────────┐
                       │ Simpan Lokal    │              │ Simpan Cloud    │
                       │ (Retention: 30  │              │ (Retention: 7   │
                       │  hari)          │              │  tahun)         │
                       └─────────────────┘              └─────────────────┘
```

---

## 15. WORKFLOW INTEGRASI & KONEKSI

### 15.1 Workflow Sinkronisasi Antar Tarombo (WF-SYNC-01)

**Tujuan:** Menggabungkan dua pohon keluarga

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Permintaan      │────►│ Pemeriksaan     │────►│ Review          │
│ Penggabungan    │     │ Konflik         │     │ Verifikator     │
└─────────────────┘     └────────┬────────┘     └────────┬────────┘
                                 │                       │
                     ┌───────────┴───────────┐          │
                     │                       │          │
                     ▼                       ▼          ▼
            ┌─────────────────┐    ┌─────────────────┐  │
            │ Ada Konflik?    │───►│ Resolve         │  │
            │ (Ya/Tidak)      │    │ Konflik       │  │
            └─────────────────┘    └─────────────────┘  │
                                                       │
                                                       ▼
                                                ┌─────────────────┐
                                                │ Merge → Aktif   │
                                                │ Tarombo         │
                                                │ Terhubung       │
                                                └─────────────────┘

Output: Tarombo Terhubung (dua pohon menjadi satu)
```

### 15.2 Workflow Integrasi Pernikahan Antar Marga (WF-SYNC-02)

**Tujuan:** Menghubungkan dua keluarga besar melalui pernikahan

```
Alur:
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ Pernikahan      │────►│ Hubungan        │────►│ Marga           │
│ Dicatat         │     │ Suami-Istri     │     │ Terhubung       │
└─────────────────┘     └─────────────────┘     └────────┬────────┘
                                                       │
                                                       ▼
                                                ┌─────────────────┐
                                                │ Dalihan Na Tolu │
                                                │ Diperbarui      │
                                                │ (Hula-hula,     │
                                                │  Boru, Dongan   │
                                                │  Tubu baru)     │
                                                └─────────────────┘

Output: Koneksi Antar Tarombo (network effect)
```

---

## LAMPIRAN: Quick Workflow Reference

```
╔════════════════════════════════════════════════════════════╗
║              QUICK WORKFLOW REFERENCE                      ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  PERKAWINAN (7 Tahapan):                                  ║
║  ─────────────────────────                                ║
║  1. Mangarisika ──► 2. Martumpol ──► 3. Martonggo Raja  ║
║  4. Marsibuha Buhai ──► 5. Pemberkatan ──► 6. Mangulosi  ║
║  7. Paulak Une                                           ║
║                                                            ║
║  KELAHIRAN:                                               ║
║  ───────────                                              ║
║  Input ──► Auto marga dari ayah ──► Update tarombo      ║
║                                                            ║
║  KEMATIAN:                                                ║
║  ─────────                                                ║
║  Input ──► Kategori (Saur Matua/Biasa) ──► Upacara      ║
║  ──► Warisan (auto-calculate)                           ║
║                                                            ║
║  VALIDASI LEVEL:                                          ║
║  ───────────────                                          ║
║  DRAFT ──► L1 ──► L2 ──► L3 ──► L4 ──► L5 (OFFICIAL)   ║
║                                                            ║
║  KEKERABATAN ENGINE:                                      ║
║  ───────────────────                                      ║
║  Orang ──► Cari Ibu/Ayah ──► Cari Saudara ──► Hasil    ║
║  (Tulang, Namboru, Bere)                                 ║
║                                                            ║
║  DALIHAN NA TOLU ENGINE:                                  ║
║  ────────────────────────                                 ║
║  Orang ──► Identifikasi Marga ──► Hula-hula/Dongan/Boru ║
║                                                            ║
║  PUNGUAN:                                                 ║
║  ───────                                                  ║
║  Buat ──► Input Data ──► Pengurus ──► Anggota ──► Aktif ║
║                                                            ║
║  AI TAROMBO:                                              ║
║  ──────────                                               ║
║  Query ──► NLP ──► Cari Data ──► Hitung ──► Jawaban     ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

**Referensi:** USE_CASE.md, BUSINESS_RULE.md

© 2026 Tarombo Digital Project
