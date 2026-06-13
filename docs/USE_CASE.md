# USE CASE SPECIFICATION
## Dokumen Kasus Penggunaan Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Diagram Use Case Overview](#1-diagram-use-case-overview)
2. [Aktor Sistem](#2-aktor-sistem)
3. [Use Case Detail](#3-use-case-detail)
   - UC-01 s/d UC-30: Core System
   - UC-31 s/d UC-40: Hubungan Kekerabatan & Dalihan Na Tolu ← BARU
   - UC-41 s/d UC-50: Punguan, Dokumen, AI, Laporan ← BARU
4. [Matriks Traceability](#4-matriks-traceability)

---

## 1. DIAGRAM USE CASE OVERVIEW

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SISTEM TAROMBO DIGITAL                               │
│                                                                             │
│  ┌─────────────┐                                                            │
│  │ USER BIASA  │                                                            │
│  │  (Pengguna) │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-01 ──► Registrasi Akun                                         │
│         │ UC-02 ──► Kelola Profil Pribadi                                  │
│         │ UC-03 ──► Lihat Silsilah (Terbatas)                              │
│         │ UC-04 ──► Cari Person                                           │
│         │ UC-05 ──► Lihat Partuturan                                       │
│         │ UC-06 ──► Ajukan Perbaikan Data                                  │
│         │                                                                   │
│  ┌──────┴──────┐                                                            │
│  │ VERIFIED    │                                                            │
│  │ USER        │                                                            │
│  │ (Terferifikasi)│                                                         │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-07 ──► Input Data Keluarga                                    │
│         │ UC-08 ──► Lihat Silsilah Lengkap                                 │
│         │ UC-09 ──► Validasi Data Keluarga                                 │
│         │ UC-10 ──► Catat Perkawinan                                       │
│         │ UC-11 ──► Catat Kelahiran                                        │
│         │ UC-12 ──► Request Pariban Match                                  │
│         │ UC-13 ──► Lihat Peta Kekerabatan                                 │
│         │                                                                   │
│  ┌──────┴──────┐                                                            │
│  │ TETUA ADAT  │                                                            │
│  │ (Elder)     │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-14 ──► Verifikasi Data Komunitas                              │
│         │ UC-15 ──► Validasi Perkawinan Adat                               │
│         │ UC-16 ──► Kelola Acara Adat                                    │
│         │ UC-17 ──► Berikan Restu Digital                                  │
│         │ UC-18 ──► Konfirmasi Partuturan                                  │
│         │                                                                   │
│  ┌──────┴──────┐                                                            │
│  │ RAJA PARHATA│                                                            │
│  │ (Protocol)  │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-19 ──► Protokol Acara Adat                                    │
│         │ UC-20 ──► Generate Tata Tertib                                   │
│         │ UC-21 ──► Kelola Urutan Upacara                                  │
│         │                                                                   │
│  ┌──────┴──────┐                                                            │
│  │ ADMIN       │                                                            │
│  │ BUDAYA      │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-22 ──► Kelola Master Marga                                    │
│         │ UC-23 ──► Verifikasi Data Kritis                                 │
│         │ UC-24 ──► Resolve Data Conflict                                  │
│         │ UC-25 ──► Generate Report Statistik                              │
│         │ UC-26 ──► Audit Trail Review                                    │
│         │                                                                   │
│  ┌──────┴──────┐                                                            │
│  │ ADMIN       │                                                            │
│  │ SISTEM      │                                                            │
│  └──────┬──────┘                                                            │
│         │                                                                   │
│         │ UC-27 ──► Kelola User dan Hak Akses                              │
│         │ UC-28 ──► Backup dan Restore                                     │
│         │ UC-29 ──► System Configuration                                   │
│         │ UC-30 ──► Monitoring dan Logging                                 │
│         │                                                                   │
└─────────────────────────────────────────────────────────────────────────────┘

SUPPORTING SYSTEMS:
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ NOTIFICATION    │  │ PAYMENT GATEWAY │  │ GEOLOCATION     │
│ SERVICE         │  │ (untuk monetisasi)│  │ SERVICE         │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

---

## 2. AKTOR SISTEM

| Aktor | Deskripsi | Hak Akses |
|-------|-----------|-----------|
| **User Biasa** | Pengguna umum yang baru mendaftar | Lihat data publik, kelola profil sendiri, ajukan perbaikan |
| **Verified User** | Pengguna terverifikasi identitasnya | Semua hak User Biasa + input data keluarga, lihat silsilah lengkap, validasi data |
| **Verifikator Tarombo** | Verifikator data kekerabatan | Meninjau, menyetujui, menolak perubahan data |
| **Tetua Adat** | Penjaga adat yang diverifikasi komunitas | Verifikasi data komunitas, validasi perkawinan, kelola acara adat |
| **Raja Parhata** | Protokol adat resmi | Protokol acara, generate tata tertib, kelola urutan upacara |
| **Admin Punguan** | Pengurus organisasi marga | Kelola anggota punguan, kelola acara, kelola iuran, bantuan duka |
| **Admin Budaya** | Administrator konten budaya | Kelola master marga, verifikasi data kritis, resolve konflik, laporan |
| **Admin Sistem** | Administrator teknis | Kelola user, backup, konfigurasi sistem, monitoring |

---

## 3. USE CASE DETAIL

### 3.1 UC-01: Registrasi Akun

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Registrasi Akun |
| **Aktor** | User Biasa |
| **Tujuan** | Membuat akun dalam sistem Tarombo Digital |
| **Kondisi Awal** | User belum memiliki akun |
| **Kondisi Akhir** | Akun berhasil dibuat, status: DRAFT |

**Alur Normal:**
1. User mengakses halaman registrasi
2. Sistem menampilkan form registrasi
3. User mengisi: nama lengkap, email, password, marga, sub-suku
4. Sistem validasi format email dan kekuatan password
5. Sistem cek keunikan email
6. User mengisi data profil tambahan (opsional)
7. Sistem kirim email verifikasi
8. User konfirmasi email
9. Sistem aktifkan akun dengan status DRAFT

**Alur Alternatif:**
- 4a. Format email invalid → Sistem tampilkan error, kembali ke langkah 3
- 4b. Password lemah → Sistem tampilkan requirements, kembali ke langkah 3
- 5a. Email sudah terdaftar → Sistem tawarkan login atau reset password

**Aturan Bisnis:**
- BR-SYS-001: Data wajib minimal harus diisi
- BR-SYS-002: Email harus unik
- Marga harus dipilih dari daftar yang tersedia

---

### 3.2 UC-02: Kelola Profil Pribadi

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Profil Pribadi |
| **Aktor** | User Biasa, Verified User |
| **Tujuan** | Mengelola data pribadi dalam sistem |

**Alur Normal:**
1. User login dan akses menu profil
2. Sistem tampilkan data profil existing
3. User pilih edit profil
4. Sistem tampilkan form editable sesuai hak akses
5. User ubah data yang diizinkan
6. Sistem validasi perubahan
7. Sistem simpan perubahan dengan status DRAFT/SELF_VERIFIED
8. Sistem catat audit trail

**Batasan Perubahan:**
| Field | User Biasa | Verified User | Keterangan |
|-------|:----------:|:-------------:|------------|
| Nama | ✓ | ✓ | Dengan alasan |
| Marga | ✗ | ✗ | Tidak dapat diubah |
| Gender | ✗ | ✗ | Tidak dapat diubah |
| Tanggal Lahir | ✓ | ✓ | Dengan bukti |
| Orang Tua | ✓ | ✓ | Dengan validasi |
| Kontak | ✓ | ✓ | Bebas |

---

### 3.3 UC-03: Lihat Silsilah (Terbatas)

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Lihat Silsilah Terbatas |
| **Aktor** | User Biasa (Publik) |
| **Tujuan** | Melihat struktur silsilah dengan batasan privasi |

**Data yang Ditampilkan (Publik):**
- Nama lengkap
- Marga
- Generasi dalam tarombo
- Hubungan kekerabatan umum (tanpa detail)

**Data yang Disembunyikan:**
- Tanggal lahir lengkap (hanya tahun jika relevan)
- Tempat tinggal
- Kontak pribadi
- Status ekonomi
- Dokumen identitas

---

### 3.4 UC-04: Cari Person

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Person |
| **Aktor** | Semua aktor |
| **Tujuan** | Menemukan person dalam database |

**Kriteria Pencarian:**
- Nama (fuzzy search)
- Marga
- Sub-suku
- Generasi
- Wilayah/geografis

**Hasil Pencarian:**
| Level Akses | Detail Hasil |
|-------------|--------------|
| Publik | Nama, Marga, Generasi |
| Keluarga | + Tanggal lahir, Orang tua |
| Verified | + Kontak (jika diizinkan) |
| Tetua/Admin | Full data |

---

### 3.5 UC-05: Lihat Partuturan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Lihat Partuturan |
| **Aktor** | Semua aktor |
| **Tujuan** | Mengetahui panggilan adat antara dua person |

**Alur:**
1. User pilih dua person (viewer dan target)
2. Sistem kalkulasi:
   - Marga masing-masing
   - Relasi kekerabatan
   - Generasi gap
   - Hubungan spesial (tulang, namboru, dll)
3. Sistem return partuturan dengan:
   - Term panggilan
   - Level hierarki
   - Ketentuan hormat/sikap
   - Rights/obligations (jika ada)

**Business Rule:**
- BR-KKB-001: Algoritma partuturan mengikuti struktur adat
- BR-KKB-028: Pariban detection otomatis

---

### 3.6 UC-06: Ajukan Perbaikan Data

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Ajukan Perbaikan Data |
| **Aktor** | User Biasa, Verified User |
| **Tujuan** | Mengajukan koreksi data yang salah |

**Alur:**
1. User temukan data yang salah
2. User klik "Ajukan Perbaikan"
3. Sistem tampilkan form perbaikan dengan:
   - Data saat ini (read-only)
   - Field koreksi
   - Alasan perbaikan (mandatory)
   - Bukti pendukung (upload)
4. User submit perbaikan
5. Sistem cek duplikasi dengan request existing
6. Sistem kirim ke reviewer (keluarga/tetua/admin)
7. Sistem notifikasi user hasil review

**Status Request:**
- PENDING → IN_REVIEW → APPROVED/REJECTED → IMPLEMENTED

---

### 3.7 UC-07: Input Data Keluarga

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Input Data Keluarga |
| **Aktor** | Verified User |
| **Tujuan** | Menambah atau memperbarui data keluarga |

**Fitur Input:**
- Tambah person baru (anak, cucu, saudara)
- Edit person existing
- Hubungkan person yang sudah ada dalam sistem
- Import dari file (CSV/Excel/GEDCOM)

**Validasi Input:**
- Cek keunikan person (anti-duplikasi)
- Validasi marga (inheritance dari ayah)
- Validasi tanggal (logis: anak < orang tua)
- Cek perkawinan sesama marga (warning)

---

### 3.8 UC-08: Lihat Silsilah Lengkap

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Lihat Silsilah Lengkap |
| **Aktor** | Verified User |
| **Tujuan** | Melihat struktur lengkap dengan data pribadi |

**View Options:**
- Tree view (pohon keluarga)
- Timeline view (berdasarkan generasi)
- Map view (geografis penyebaran)
- Table view (list dengan filter)

**Detail yang Ditampilkan:**
- Data pribadi (lahir, kontak)
- Relasi lengkap
- Status pernikahan
- Riwayat perkawinan
- Anak-anak

---

### 3.9 UC-09: Validasi Data Keluarga

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Validasi Data Keluarga |
| **Aktor** | Verified User, Keluarga yang bersangkutan |
| **Tujuan** | Memverifikasi keakuratan data |

**Tingkat Validasi:**

| Level | Dari | Jumlah Approver | Status Akhir |
|-------|------|-----------------|--------------|
| L1 | Diri sendiri | 1 | SELF_VERIFIED |
| L2 | Keluarga | 2 | FAMILY_VERIFIED |
| L3 | Dongan Tubu | 2 | COMMUNITY_VERIFIED |
| L4 | Tetua | 1 | ELDER_VERIFIED |
| L5 | Admin Budaya | 1 | OFFICIAL |

---

### 3.10 UC-10: Catat Perkawinan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Catat Perkawinan |
| **Aktor** | Verified User (keluarga mempelai) |
| **Tujuan** | Mencatat pernikahan dalam sistem |

**Data yang Dicatat:**
- Data pengantin (pria & wanita)
- Data orang tua (parboru & paranak)
- Tanggal & lokasi pernikahan
- Hula-hula dari masing-masing pihak
- Sinamot (jumlah, bentuk)
- Tahapan upacara yang dilaksanakan
- Dokumentasi (foto, scan dokumen)

**Validasi Otomatis:**
- Check marga compatibility (BR-MRG-003 s/d 005)
- Check existing marriage status
- Check pariban status (if applicable)
- Generate warnings untuk review

**Sequence Tahapan:**
Sesuai BR-PRK-009: Mangarisika → Martumpol → Martonggo Raja → Marsibuha Buhai → Pemberkatan → Mangulosi → Paulak Une

---

### 3.11 UC-11: Catat Kelahiran

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Catat Kelahiran |
| **Aktor** | Verified User (orang tua/kerabat) |
| **Tujuan** | Mencatat kelahiran anak |

**Proses:**
1. Input data bayi (nama, gender, tanggal lahir)
2. Sistem auto-set marga dari ayah
3. Hubungkan dengan orang tua
4. Update tarombo keluarga
5. Generate generasi number
6. Notifikasi ke keluarga terdekat

---

### 3.12 UC-12: Request Pariban Match

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Request Pariban Match |
| **Aktor** | Verified User |
| **Tujuan** | Mencari calon pasangan yang merupakan pariban ideal |

**Alur:**
1. User request pariban search
2. Sistem identifikasi:
   - Anak laki-laki dari namboru (untuk laki-laki user)
   - Anak perempuan dari tulang (untuk perempuan user)
3. Sistem cari dalam database
4. Sistem return list pariban kandidat dengan:
   - Data person (terbatas sesuai privasi)
   - Hubungan pariban (bagaimana terjadi)
   - Match score (umur, lokasi, status)
5. User dapat request introduction (jika kandidat setuju)

---

### 3.13 UC-13: Lihat Peta Kekerabatan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Lihat Peta Kekerabatan |
| **Aktor** | Verified User |
| **Tujuan** | Visualisasi jaringan kekerabatan |

**Visualisasi:**
- Network graph dengan person sebagai node
- Edge menunjukkan relasi (ayah-ibu-anak, perkawinan)
- Warna node menunjukkan marga
- Size node menunjukkan generasi/tingkat
- Interaksi: zoom, pan, click untuk detail

**Filter:**
- Berdasarkan marga
- Berdasarkan generasi
- Berdasarkan geografis
- Berdasarkan hubungan spesifik (hula-hula, dll)

---

### 3.14 UC-14: Verifikasi Data Komunitas

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Verifikasi Data Komunitas |
| **Aktor** | Tetua Adat |
| **Tujuan** | Memverifikasi data anggota komunitasnya |

**Wewenang Tetua:**
- Melihat data L3 (community level) untuk marga/wilayahnya
- Memberikan approval untuk validasi L3
- Mengajukan koreksi data ke admin
- Menandatangani digital untuk keabsahan

---

### 3.15 UC-15: Validasi Perkawinan Adat

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Validasi Perkawinan Adat |
| **Aktor** | Tetua Adat |
| **Tujuan** | Memastikan perkawinan sesuai adat |

**Validasi:**
- Check marga (larangan sesama)
- Check hula-hula (posisi dan peran)
- Check sinamot (sesuai ketentuan)
- Check prosesi (urutan tahapan)
- Check partuturan (panggilan benar)

**Output:**
- Sertifikat validasi adat digital
- QR code untuk verifikasi
- Tanda tangan digital tetua

---

### 3.16 UC-16: Kelola Acara Adat

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Acara Adat |
| **Aktor** | Tetua Adat, Raja Parhata |
| **Tujuan** | Mengorganisir acara adat (perkawinan, kematian) |

**Fitur:**
- Buat acara baru dengan template adat
- Assign roles (Raja Parhata, Hula-hula, dll)
- Manage guest list dengan partuturan auto-tag
- Generate tata tertib dan urutan acara
- Dokumentasi real-time
- Laporan pasca-acara

---

### 3.17 UC-17: Berikan Restu Digital

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Berikan Restu Digital |
| **Aktor** | Tetua Adat, Hula-hula |
| **Tujuan** | Memberikan restu/approval untuk peristiwa adat |

**Use Cases:**
- Restu perkawinan dari hula-hula
- Restu perubahan data kritis
- Restu pelaksanaan upacara
- Restu pengolihon anak angkat

**Mekanisme:**
- Digital signature dengan private key
- Timestamp dan IP address tercatat
- Notifikasi ke pihak terkait
- Reversible dengan alasan

---

### 3.18 UC-18: Konfirmasi Partuturan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Konfirmasi Partuturan |
| **Aktor** | Tetua Adat |
| **Tujuan** | Mengkonfirmasi partuturan yang kompleks/tidak jelas |

**Kapan Diperlukan:**
- Hubungan kekerabatan jauh/generasi banyak
- Kasus adopsi/perubahan status
- Perkawinan beda marga dengan kompleksitas
- Situasi khusus lainnya

---

### 3.19 UC-19: Protokol Acara Adat

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Protokol Acara Adat |
| **Aktor** | Raja Parhata |
| **Tujuan** | Menjalankan protokol sebagai juru bicara |

**Fitur:**
- Script/bahan bicara adat (bahasa Batak + terjemahan)
- Urutan acara dengan timer
- Checklist pihak-pihak yang hadir
- Notifikasi ke tahap selanjutnya
- Recording dokumentasi

---

### 3.20 UC-20: Generate Tata Tertib

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Generate Tata Tertib |
| **Aktor** | Raja Parhata |
| **Tujuan** | Membuat tata tertib acara otomatis |

**Input:**
- Jenis acara (perkawinan/kematian/saur matua)
- Pihak yang terlibat
- Skala acara (kecil/sedang/besar)
- Lokasi dan waktu

**Output:**
- Tata tertib lengkap dengan nama-nama pihak
- Urutan masuk gedung
- Posisi duduk
- Alur percakapan adat
- Daftar jambar/ulos yang dibutuhkan

---

### 3.21 UC-21: Kelola Urutan Upacara

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Urutan Upacara |
| **Aktor** | Raja Parhata |
| **Tujuan** | Mengatur dan memantau urutan upacara |

**Fitur:**
- Step-by-step guide untuk setiap tahap
- Checklist completion setiap tahap
- Timer untuk mengatur waktu
- Escalation jika ada masalah
- Real-time update ke semua pihak

---

### 3.22 UC-22: Kelola Master Marga

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Master Marga |
| **Aktor** | Admin Budaya |
| **Tujuan** | Mengelola data marga dalam sistem |

**Operasi:**
- Tambah marga baru
- Edit informasi marga
- Tambah sub-marga
- Kelola larangan perkawinan
- Verifikasi marga dari request user

---

### 3.23 UC-23: Verifikasi Data Kritis

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Verifikasi Data Kritis |
| **Aktor** | Admin Budaya |
| **Tujuan** | Memberikan approval level tertinggi untuk data sensitif |

**Data Kritis:**
- Perubahan marga
- Perubahan orang tua
- Penghapusan data
- Merge data duplikat
- Perubahan gender

---

### 3.24 UC-24: Resolve Data Conflict

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Resolve Data Conflict |
| **Aktor** | Admin Budaya |
| **Tujuan** | Menyelesaikan konflik data dari berbagai sumber |

**Jenis Konflik:**
- Duplikasi person (sama orang, entry berbeda)
- Konflik relasi (orang tua berbeda versi)
- Konflik tanggal (tidak logis)
- Konflik marga (inkonsistensi inheritance)

**Proses Resolution:**
1. Sistem deteksi konflik
2. Admin review data dan sumber
3. Kontak pihak terkait untuk klarifikasi
4. Putusan dengan alasan
5. Merge atau pilih versi yang benar
6. Dokumentasi resolution

---

### 3.25 UC-25: Generate Report Statistik

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Generate Report Statistik |
| **Aktor** | Admin Budaya |
| **Tujuan** | Membuat laporan statistik sistem |

**Jenis Report:**
- Demografi marga (jumlah per marga)
- Statistik geografis (penyebaran)
- Statistik perkawinan (per tahun, per marga)
- Statistik validasi data
- Statistik penggunaan sistem

---

### 3.26 UC-26: Audit Trail Review

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Audit Trail Review |
| **Aktor** | Admin Budaya |
| **Tujuan** | Memonitor aktivitas dan perubahan dalam sistem |

**Fitur:**
- Search dan filter audit log
- View perubahan dengan before/after
- Identifikasi anomali (unusual pattern)
- Export audit report

---

### 3.27 UC-27: Kelola User dan Hak Akses

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola User dan Hak Akses |
| **Aktor** | Admin Sistem |
| **Tujuan** | Mengelola pengguna dan role mereka |

**Operasi:**
- Lihat semua user
- Edit role dan permissions
- Suspend/activate user
- Reset password
- View login history

---

### 3.28 UC-28: Backup dan Restore

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Backup dan Restore |
| **Aktor** | Admin Sistem |
| **Tujuan** | Menjaga ketersediaan dan recovery data |

**Jadwal Backup:**
- Full backup: mingguan
- Incremental: harian
- Transaction log: real-time

**Retention:**
- 30 hari untuk daily
- 12 minggu untuk weekly
- 7 tahun untuk yearly

---

### 3.29 UC-29: System Configuration

| Atribut | Nilai |
|-----------|-------|
| **Nama** | System Configuration |
| **Aktor** | Admin Sistem |
| **Tujuan** | Mengkonfigurasi parameter sistem |

**Parameter:**
- Email server settings
- Notification settings
- Security policies
- Rate limiting
- Feature flags

---

### 3.30 UC-30: Monitoring dan Logging

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Monitoring dan Logging |
| **Aktor** | Admin Sistem |
| **Tujuan** | Memantau kesehatan sistem |

**Dashboard:**
- System health metrics
- Error rate
- Performance metrics
- User activity
- Security incidents

---

### 3.31 UC-31: Cari Hubungan Dua Orang

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Hubungan Dua Orang |
| **Aktor** | Semua pengguna |
| **Tujuan** | Mengetahui hubungan antara dua person |

**Input:**
- Person A (viewer)
- Person B (target)

**Output:**
- Jenis hubungan (Tulang, Namboru, Bere, dll)
- Jalur kekerabatan (path)
- Tingkat kedekatan

---

### 3.32 UC-32: Tampilkan Jalur Hubungan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Tampilkan Jalur Hubungan |
| **Aktor** | Semua pengguna |
| **Tujuan** | Visualisasi graph hubungan |

**Output:**
```
Petrick Simanjuntak
→ Ayah: Maman Simanjuntak
→ Kakek: Togatorop Simanjuntak
→ Saudara Kakek: Budi Simanjuntak (Tulang)
```

---

### 3.33 UC-33: Tampilkan Tingkat Generasi

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Tampilkan Tingkat Generasi |
| **Aktor** | Semua pengguna |
| **Tujuan** | Mengetahui generasi relatif |

---

### 3.34 UC-34: Cari Tulang

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Tulang |
| **Aktor** | Semua pengguna |
| **Tujuan** | Menemukan saudara laki-laki ibu |

**Formula:** IBU → Saudara Laki-laki

---

### 3.35 UC-35: Cari Namboru

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Namboru |
| **Aktor** | Semua pengguna |
| **Tujuan** | Menemukan saudara perempuan ayah |

**Formula:** AYAH → Saudara Perempuan

---

### 3.36 UC-36: Cari Bere

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Bere |
| **Aktor** | Semua pengguna |
| **Tujuan** | Menemukan anak dari saudara perempuan |

---

### 3.37 UC-37: Cari Pariban

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Pariban |
| **Aktor** | Verified User |
| **Tujuan** | Menemukan pasangan ideal menurut adat |

---

### 3.38 UC-38: Cari Hula-Hula

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Hula-Hula |
| **Aktor** | Tetua Adat, Raja Parhata |
| **Tujuan** | Identifikasi pihak pemberi perempuan per acara |

**Note:** Kontekstual per acara

---

### 3.39 UC-39: Cari Boru

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Boru |
| **Aktor** | Tetua Adat, Raja Parhata |
| **Tujuan** | Identifikasi pihak penerima perempuan per acara |

---

### 3.40 UC-40: Cari Dongan Tubu

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Cari Dongan Tubu |
| **Aktor** | Semua pengguna |
| **Tujuan** | Menemukan sesama marga |

**Filter:** Marga, Cabang, Leluhur

---

### 3.41 UC-41: Kelola Punguan

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Punguan |
| **Aktor** | Admin Punguan |
| **Tujuan** | Mengelola organisasi marga |

**Fitur:**
- Buat punguan baru
- Tambah/keluarkan anggota
- Kelola pengurus
- Kelola cabang
- Atur periode kepengurusan

---

### 3.42 UC-42: Kelola Iuran

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Iuran |
| **Aktor** | Admin Punguan |
| **Tujuan** | Mengelola keuangan punguan |

**Fitur:**
- Buat jenis iuran
- Input pembayaran
- Verifikasi pembayaran
- Cetak laporan
- Kirim pengingat otomatis

---

### 3.43 UC-43: Bantuan Duka

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Bantuan Duka |
| **Aktor** | Admin Punguan, Tetua Adat |
| **Tujuan** | Mengelola santunan kematian |

**Alur:**
1. Input data meninggal
2. Validasi keanggotaan aktif
3. Hitung nominal santunan (sesuai aturan punguan)
4. Verifikasi
5. Cetak surat santunan
6. Arsip permanen

---

### 3.44 UC-44: Kelola Dokumen

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Dokumen |
| **Aktor** | Anggota, Admin |
| **Tujuan** | Mengelola file media |

**Jenis:**
- Foto (profil, acara, makam)
- Video (upacara adat)
- Audio (doa, umpasa)
- PDF (dokumen resmi)

**Akses:** PUBLIC, RESTRICTED, CONFIDENTIAL

---

### 3.45 UC-45: Kelola Data Makam

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Kelola Data Makam |
| **Aktor** | Anggota, Admin Punguan |
| **Tujuan** | Dokumentasi makam leluhur |

**Data:**
- Lokasi GPS
- Foto makam
- Riwayat perawatan
- Jalur ziarah

---

### 3.46 UC-46: Peta Keluarga

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Peta Keluarga |
| **Aktor** | Semua pengguna |
| **Tujuan** | Visualisasi persebaran geografis |

**Filter:**
- Berdasarkan marga
- Berdasarkan generasi
- Berdasarkan wilayah

---

### 3.47 UC-47: AI Tarombo Assistant

| Atribut | Nilai |
|-----------|-------|
| **Nama** | AI Tarombo Assistant |
| **Aktor** | Semua pengguna |
| **Tujuan** | Asisten virtual untuk query kekerabatan |

**Contoh Query:**
- "Apa hubungan saya dengan Budi Simbolon?"
- "Siapa Tulang saya?"
- "Siapa Hula-hula dalam acara ini?"
- "Siapa Pariban ideal untuk saya?"

**Requirements:**
- Evidence-based (dengan sumber data)
- Traceable (bisa ditelusuri)
- Explainable (menunjukkan jalur)

---

### 3.48 UC-48: Workflow Verifikasi

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Workflow Verifikasi |
| **Aktor** | Verifikator, Admin |
| **Tujuan** | Mengelola antrian perubahan data |

**Status:**
- PENDING → IN_REVIEW → APPROVED/REJECTED → IMPLEMENTED

---

### 3.49 UC-49: Audit Trail

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Audit Trail |
| **Aktor** | Admin Budaya, Admin Sistem |
| **Tujuan** | Monitoring perubahan data |

**Fitur:**
- Lihat log aktivitas
- Cari perubahan data
- Lihat riwayat perubahan per person
- Export audit report

---

### 3.50 UC-50: Laporan dan Statistik

| Atribut | Nilai |
|-----------|-------|
| **Nama** | Laporan dan Statistik |
| **Aktor** | Admin Budaya, Admin Punguan |
| **Tujuan** | Generate laporan komprehensif |

**Jenis Laporan:**
- Statistik anggota per marga
- Statistik generasi
- Statistik wilayah
- Statistik perkawinan
- Statistik keuangan punguan

---

## 4. MATRIKS TRACEABILITY

### 4.1 Use Case ke Business Rule

| Use Case | Business Rules |
|----------|----------------|
| UC-01 | BR-SYS-001, BR-SYS-002 |
| UC-02 | BR-SYS-003, BR-VAL-001 |
| UC-03 | BR-ACC-001 |
| UC-04 | - |
| UC-05 | BR-KKB-001 s/d BR-KKB-028 |
| UC-06 | BR-VAL-001 |
| UC-07 | BR-SYS-001, BR-MRG-002 |
| UC-08 | BR-ACC-001 |
| UC-09 | BR-VAL-001 |
| UC-10 | BR-PRK-006 s/d BR-PRK-011, BR-MRG-003 s/d 006 |
| UC-11 | BR-SYS-001, BR-MRG-002 |
| UC-12 | BR-KKB-028 |
| UC-13 | BR-KKB-001 |
| UC-14 | BR-ACC-001 |
| UC-15 | BR-PRK-011, BR-MRG-003 |
| UC-16 | BR-PRK-011 |
| UC-17 | BR-SYS-012 |
| UC-22 | BR-MRG-001 |
| UC-23 | BR-VAL-001 |
| UC-24 | BR-SYS-012 |
| UC-31 | BR-KKB-001, BR-AIT-001 |
| UC-32 | BR-KKB-001, BR-AIT-002 |
| UC-33 | BR-GEN-001 |
| UC-34 | BR-TUL-001, BR-TUL-002 |
| UC-35 | BR-NBR-001 |
| UC-36 | BR-BER-001 |
| UC-37 | BR-PAR-001, BR-PAR-002 |
| UC-38 | BR-HUL-001, BR-HUL-002 |
| UC-39 | BR-BOR-001, BR-BOR-002 |
| UC-40 | BR-DTG-001 |
| UC-41 | BR-PUN-001, BR-PUN-002 |
| UC-42 | BR-PUN-002 |
| UC-43 | BR-BND-001, BR-BND-002, BR-BND-003 |
| UC-44 | BR-DOK-001, BR-DOK-002 |
| UC-45 | BR-HIS-003 |
| UC-46 | BR-KKB-001 |
| UC-47 | BR-AIT-001, BR-AIT-002, BR-AIT-003 |
| UC-48 | BR-HIS-001, BR-VAL-001 |
| UC-49 | BR-HIS-003, BR-HIS-004 |
| UC-50 | BR-MRG-001, BR-GEN-001 |

---

## RINGKASAN USE CASE

Dokumen ini mendefinisikan **50 Use Cases** yang mencakup:

| Kategori | Jumlah | Use Case |
|----------|--------|----------|
| **Core System** | 30 | UC-01 s/d UC-30 |
| **Hubungan Kekerabatan** | 10 | UC-31 s/d UC-40 |
| **Punguan & Organisasi** | 3 | UC-41, UC-42, UC-43 |
| **Dokumen & Media** | 1 | UC-44 |
| **Makam & Geografis** | 2 | UC-45, UC-46 |
| **AI & Intelligence** | 1 | UC-47 |
| **Audit & Verifikasi** | 2 | UC-48, UC-49 |
| **Laporan** | 1 | UC-50 |
| **TOTAL** | **50** | |

---

**Referensi:** BUSINESS_RULE.md, ANALISIS_BUDAYA_BATAK.md

© 2026 Tarombo Digital Project
