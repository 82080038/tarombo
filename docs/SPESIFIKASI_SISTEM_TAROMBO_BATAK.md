# SPESIFIKASI SISTEM TAROMBO DIGITAL BATAK

## Versi

1.0

## Status

Draft Awal

## Tujuan

Membangun platform Tarombo Digital Batak yang mampu:

* Menyimpan silsilah keluarga.
* Menghubungkan berbagai marga.
* Menghitung hubungan kekerabatan.
* Menghitung hubungan adat Batak.
* Mendukung kegiatan punguan.
* Mendukung pelaksanaan acara adat.
* Menjadi arsip sejarah keluarga lintas generasi.

---

# 1. LATAR BELAKANG

Saat ini sebagian besar data tarombo masih tersimpan dalam:

* Buku cetak
* Excel
* Dokumen Word
* Grup WhatsApp
* Ingatan para tetua

Permasalahan:

* Data mudah hilang.
* Sulit diperbarui.
* Sulit diverifikasi.
* Sulit mencari hubungan keluarga.
* Generasi muda semakin kurang memahami tarombo.

Sistem ini dibuat untuk menjaga warisan budaya Batak secara digital.

---

# 2. VISI SISTEM

Membangun platform digital yang mampu menjadi:

* Tarombo Digital
* Arsip Keluarga
* Sistem Organisasi Punguan
* Asisten Adat Batak
* Database Kekerabatan Batak

---

# 3. TUJUAN UTAMA

## Tujuan Jangka Pendek

* Digitalisasi tarombo keluarga.
* Pendataan anggota keluarga.

## Tujuan Jangka Menengah

* Hubungan kekerabatan otomatis.
* Integrasi antar marga.

## Tujuan Jangka Panjang

* Tarombo Batak Nasional.
* Mesin Adat Batak Digital.
* AI Kekerabatan Batak.

---

# 4. MODUL SISTEM

## Modul 1 - Tarombo

### Fitur

* Data anggota keluarga.
* Pohon keluarga.
* Ayah.
* Ibu.
* Pasangan.
* Anak.
* Saudara.

---

## Modul 2 - Kekerabatan

Menghitung:

* Saudara kandung.
* Sepupu.
* Kakek.
* Nenek.
* Buyut.
* Cicit.

---

## Modul 3 - Dalihan Na Tolu

Menghitung:

* Hula-hula.
* Boru.
* Dongan Tubu.
* Tulang.
* Bere.
* Namboru.
* Pariban.
* Amangboru.

---

## Modul 4 - Organisasi Punguan

### Fitur

* Pendataan anggota.
* Pengurus.
* Cabang punguan.
* Pengumuman.
* Kalender kegiatan.

---

## Modul 5 - Keuangan Punguan

### Fitur

* Iuran anggota.
* Donasi.
* Kas organisasi.
* Laporan keuangan.

---

## Modul 6 - Bantuan Duka

### Fitur

* Data anggota meninggal.
* Riwayat santunan.
* Perhitungan bantuan.
* Laporan santunan.

---

## Modul 7 - Acara Adat

### Jenis Acara

* Pernikahan
* Saur Matua
* Mangokal Holi
* Baptisan
* Syukuran

### Fitur

* Daftar peserta.
* Hubungan adat.
* Pembagian tugas.
* Dokumentasi acara.

---

## Modul 8 - Arsip Digital

### Dokumen

* Foto
* Video
* Audio
* Surat
* Akta
* Ijazah

---

## Modul 9 - Peta Keturunan

### Fitur

* Persebaran keluarga.
* Lokasi anggota.
* Statistik wilayah.

---

## Modul 10 - AI Tarombo

### Pertanyaan

Contoh:

"Apa hubungan saya dengan Budi Simbolon?"

"Siapa tulang saya?"

"Siapa hula-hula saya?"

---

# 5. MODEL DATA

## Entitas Orang

### Data Dasar

* ID
* Nama Lengkap
* Nama Panggilan
* Jenis Kelamin
* Tanggal Lahir
* Tempat Lahir
* Tanggal Meninggal
* Status Hidup

---

## Entitas Marga

### Data

* ID
* Nama Marga
* Deskripsi
* Asal Daerah

---

## Entitas Hubungan

### Jenis

* AYAH
* IBU
* SUAMI
* ISTRI
* ANAK
* SAUDARA
* ADOPSI

---

# 6. MODEL GRAPH

Sistem menggunakan konsep Graph.

## Node

* Orang
* Marga
* Punguan

## Edge

* Ayah
* Ibu
* Pasangan
* Anak

Keuntungan:

* Mudah menghitung hubungan.
* Mudah menggabungkan marga.
* Mudah mencari jalur kekerabatan.

---

# 7. ROLE DAN HAK AKSES

## Super Admin

Hak:

* Mengelola seluruh sistem.

---

## Admin Marga

Hak:

* Mengelola data marga.

---

## Admin Cabang

Hak:

* Mengelola cabang punguan.

---

## Verifikator

Hak:

* Menyetujui perubahan tarombo.

---

## Anggota

Hak:

* Mengelola data pribadi.

---

## Pengunjung

Hak:

* Melihat data yang diizinkan.

---

# 8. KEAMANAN

## Prinsip Dasar

Data pribadi harus dilindungi.

---

## Kategori Data

### Publik

* Nama
* Marga
* Hubungan

### Terbatas

* Foto
* Tahun lahir

### Rahasia

* NIK
* KK
* KTP
* Alamat
* Nomor HP

---

## Pengamanan

* HTTPS
* MFA
* Hash Password Argon2id
* Audit Log
* Backup Harian
* Backup Terenkripsi

---

# 9. AUDIT LOG

Catat:

* Login
* Perubahan data
* Penghapusan data
* Persetujuan data

---

# 10. WORKFLOW VERIFIKASI

## Pengajuan

Anggota mengubah data.

↓

## Review

Verifikator memeriksa.

↓

## Persetujuan

Data diterima.

atau

↓

## Penolakan

Data dikembalikan.

---

# 11. TEKNOLOGI

## Backend

* PHP 8.4
* REST API

## Database

* MySQL 8

## Frontend

* Bootstrap 5
* jQuery

## Mobile

* Flutter (Tahap Lanjut)

---

# 12. STRUKTUR FOLDER

/backend

/api

/auth

/orang

/marga

/punguan

/acara

/laporan

/frontend

/assets

/css

/js

/images

/uploads

/database

/sql

/docs

---

# 13. ROADMAP

## Versi 1

* Login
* Data Orang
* Pohon Keluarga

## Versi 2

* Hubungan Otomatis

## Versi 3

* Dalihan Na Tolu Engine

## Versi 4

* Acara Adat

## Versi 5

* Punguan

## Versi 6

* Bantuan Duka

## Versi 7

* AI Tarombo

## Versi 8

* Tarombo Batak Nasional

---

# 14. TARGET JANGKA PANJANG

Membangun platform yang mampu menjadi pusat data kekerabatan Batak digital dan membantu pelestarian budaya Batak lintas generasi.

