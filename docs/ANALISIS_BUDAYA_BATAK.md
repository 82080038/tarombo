# ANALISIS BUDAYA BATAK
## Dokumen Fondasi untuk Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Pendahuluan](#1-pendahuluan)
2. [Enam Sub-Suku Batak](#2-enam-sub-suku-batak)
3. [Sistem Marga dan Tarombo](#3-sistem-marga-dan-tarombo)
4. [Filosofi Dalihan Na Tolu](#4-filosofi-dalihan-na-tolu)
5. [Sistem Partuturan](#5-sistem-partuturan)
6. [Ritual dan Upacara Adat](#6-ritual-dan-upacara-adat)
7. [Prinsip Sistem Tarombo Digital](#7-prinsip-sistem-tarombo-digital)
8. [Implementasi Digital](#8-implementasi-digital)

---

## 1. PENDAHULUAN

### 1.1 Latar Belakang

Suku Batak adalah kelompok etnis Austronesia dengan populasi ~8,5 juta di Sumatera Utara. Sistem **Tarombo** (silsilah patrilineal) menjadi tulang punggung identitas sosial - berbeda dari sistem barat karena bersifat **patrilineal kaku** dengan struktur hierarkis yang menentukan posisi sosial setiap individu.

### 1.2 Tujuan Dokumen

- Dokumentasi komprehensif sistem kekerabatan Batak
- Fondasi teknis pengembangan Tarombo Digital
- Referensi tim pengembang non-Batak
- Menjaga integritas adat dalam transformasi digital

### 1.3 Ruang Lingkup

| Aspek | Cakupan |
|-------|---------|
| Sub-suku | Toba (referensi utama), Karo, Simalungun, Mandailing, Angkola, Pakpak |
| Sistem | Patrilineal dengan matrilateral links |
| Agama | Kristen, Islam, Parmalim/Animisme |

---

## 2. ENAM SUB-SUKU BATAK

### 2.1 Peta Etnografis

```
┌────────────────────────────────────────────────────┐
│               SEBARAN SUB-SUKU BATAK               │
├────────────────────────────────────────────────────┤
│                                                    │
│  ┌──────────┐                                     │
│  │ PAKPAK   │ ◄── Kab. Dairi (~200rb)             │
│  │ /DAIRI   │                                     │
│  └────┬─────┘                                     │
│       │                                           │
│  ┌────▼─────┐                                     │
│  │   KARO   │ ◄── Kab. Karo (~600rb)              │
│  └────┬─────┘                                     │
│       │                                           │
│  ┌────▼─────┐    ┌──────────┐    ┌──────────┐     │
│  │SIMALUNGUN│◄──►│   TOBA   │    │ ANGKOLA  │◄──┐ │
│  │(~300rb)  │    │(~3jt)    │    │(~500rb)  │   │ │
│  └──────────┘    └────┬─────┘    └────┬─────┘   │ │
│                       │               │         │ │
│                  ┌────▼───────────────▼─────────┘ │
│                  │     MANDAILING (~1jt)          │
│                  └───────────────────────────────┘
│
└────────────────────────────────────────────────────┘
```

### 2.2 Karakteristik Per Sub-Suku

| Sub-Suku | Sistem Marga | Karakteristik Distinktif | Agama Dominan |
|----------|--------------|-------------------------|---------------|
| **TOBA** | 100+ marga hierarkis, patrilineal | Partuturan paling elaborat dengan 40+ istilah panggilan; marga diturunkan dari ayah | Kristen |
| **KARO** | 5 kelompok utama (Karo-karo) | Sistem **Rakut Sitelu**: Kalimbubu (hula-hula), Sembuyak (dongan tubu), Anak Beru (boru) | Kristen/Katolik |
| **SIMALUNGUN** | **Sisadapur**: 4 marga asli sederajat | Sinaga, Saragih, Damanik, Purba dari Harungguan Bolon; sistem konfederasi | Kristen |
| **MANDAILING** | Patrilineal adaptasi Islam | "Santun Dongan" menggantikan "Horas"; Islamisasi mendalam | Islam |
| **ANGKOLA** | Mirip Mandailing | Wilayah selatan Tapanuli, identitas marga dipertahankan meski Islam | Islam |
| **PAKPAK** | Marga terbatas ketat | Motto "Ulang Telpus Bulung" (saling mengisi); sistem patrilineal kaku | Kristen |

### 2.2a Perbandingan Sistem Kekerabatan Detail

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              PERBANDINGAN SISTEM KEKERABATAN BATAK                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  BATAK TOBA                          BATAK KARO                            │
│  ─────────────                       ────────────                           │
│  Dalihan Na Tolu                     Rakut Sitelu                         │
│  • Hula-hula (pemberi perempuan)     • Kalimbubu (hula-hula equivalent)   │
│  • Dongan Tubu (sesama marga)        • Sembuyak (sesama marga)            │
│  • Boru (penerima perempuan)         • Anak Beru (boru equivalent)         │
│                                                                             │
│  BATAK SIMALUNGUN                                                        │
│  ────────────────                                                         │
│  Harungguan Manriah (Sisadapur)                                         │
│  • 4 Marga Raja sederajat: Sinaga, Saragih, Damanik, Purba               │
│  • Sistem kepemimpinan bersama (empat raja)                               │
│  • Hak Ulayat dimiliki bersama                                           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Perbandingan Sistem

**Batak Toba:** Marga utama 100+, leluhur mitos Si Raja Batak → Guru Tatea Bulan / Raja Isumbaon. Larangan perkawinan sesama marga + marga spesifik (Marbun-Sihotang, Nainggolan-Siregar).

**Batak Karo:** Sistem "Karo-Karo" (Perangin-angin, Karo-karo, Ginting, Tarigan, Sembiring). Konsep kalimbubu (hula-hula) dan sembuyak (boru).

**Batak Simalungun:** "Harungguan Manriah" - Sinaga, Saragih, Damanik, Purba. Sistem sederajat, perkawinan lebih fleksibel.

**Mandailing & Angkola:** Adaptasi Islam, "Santun Dongan" menggantikan "Horas".

---

## 3. SISTEM MARGA DAN TAROMBO

### 3.1 Definisi

| Istilah | Definisi |
|---------|----------|
| **Marga** | Unit klan patrilineal, menentukan identitas, hak, kewajiban, larangan perkawinan |
| **Tarombo** | Sistem silsilah yang menelusuri keturunan dari leluhur bersama |
| **Partuturan** | Sistem panggilan berbasis hubungan kekerabatan |

### 3.2 Marga Batak Toba (Daftar Utama)

#### Keturunan Raja Lontung (anak Saribu Raja):
- Sinaga, Situmorang, Pandiangan, Nainggolan, Simatupang, Aritonang, Siregar

#### Keturunan Si Bagot ni Pohan:
- Tampubolon, Siahaan, Simanjuntak, Hutagaol, Panjaitan, Silitonga, Siagian, Sianipar, Simangunsong, Marpaung, Napitupulu, Pardede

#### Marga Besar Lainnya:
- Sitorus, Samosir, Pasaribu, Hutabarat, Hutapea, Lubis, Tambunan, Tanjung, Limbong, Gultom, Harahap, Hasibuan, Sihombing, Nainggolan, Naibaho, Siallagan, Sianturi, Sibarani, Sibuea, Sigalingging, Silaen, Silaban, Silalahi, Simamora, Simanullang, Simaremare, Simarmata, Simbolon, Sinambela, Sinurat, Sipahutar, Sirait, Sitanggang, Sitepu, Sitindaon, Sitinjak, Sitohang, Sitompul, Situmeang

**Total: 100+ marga** (perlu kurasi untuk sistem digital)

### 3.3 Aturan Perkawinan

```
┌──────────────────────────────────────────────────────┐
│         LARANGAN PERKAWINAN MARGA                    │
├──────────────────────────────────────────────────────┤
│                                                      │
│  PRINSIP: Tidak boleh menikah sesama marga          │
│                                                      │
│  LARANGAN SPESIFIK:                                 │
│  • Marbun ◄──┐                                       │
│              ├──► Tidak boleh menikah               │
│  • Sihotang ◄┘                                       │
│                                                      │
│  • Nainggolan ◄──┐                                   │
│                  ├──► Tidak boleh menikah         │
│  • Siregar ◄─────┘                                   │
│                                                      │
│  SANKSI: Tidak diakui, dikucilkan                   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### 3.4 Sistem Pariban

**Pariban** = Anak laki-laki saudara perempuan ayah ↔ Anak perempuan saudara laki-laki ibu

- Calon pasangan ideal dalam adat
- Hak istimewa dalam peminangan
- Status sosial dihormati

---

## 4. FILOSOFI DALIHAN NA TOLU

### 4.1 Konsep Dasar

**Dalihan Na Tolu** (Tungku Nan Tiga) = Sistem sosial berbasis tiga unsur yang saling melengkapi:

```
                    DALIHAN NA TOLU
                         /|\
                        / | \
                       /  |  \
                      /   |   \
                     /    |    \
            ┌───────┐     │     ┌───────┐
            │ HULA  │◄────┼────►│ BORU  │
            │ -HULA │     │     │       │
            └───────┘     │     └───────┘
                   \\\\    │    //
                    \\\\   │   //
                     \\\\  │  //
                      \\\\ │ //
                       \\\\│//
                    ┌───────────┐
                    │  DONGAN   │
                    │   TUBU    │
                    └───────────┘
```

### 4.2 Komponen

| Komponen | Definisi | Status | Peran |
|----------|----------|--------|-------|
| **Hula-hula** | Saudara laki-laki ibu; keluarga yang memberi istri | Paling dihormati | Pemberi restu, penjaga kehormatan |
| **Dongan Tubu** | Sesama marga; saudara sebapak | Setara | Pendukung, penolong |
| **Boru** | Keluarga yang menerima istri | Dengan kewajiban | Menerima, melindungi |

### 4.3 Tiga Hukum Dalihan Na Tolu

1. **Somba Marhula-hula** (Menghormati hula-hula)
   - Keputusan penting perlu persetujuan hula-hula
   - Tempat terhormat dalam acara adat
   - Ulos pertama untuk hula-hula

2. **Manat Mardongan Tubu** (Bersikap adil kepada dongan tubu)
   - Penengah dalam konflik
   - Hak dan kewajiban seimbang
   - Solidaritas komunitas

3. **Manat Marboru** (Bersikap adil kepada boru)
   - Perlakuan adil, tidak merendahkan
   - Hak perlindungan
   - Hak mengajukan gugatan

---

## 5. SISTEM PARTUTURAN

### 5.1 Definisi

**Partuturan** = Sistem panggilan wajib berbasis hubungan kekerabatan. Setiap interaksi harus menggunakan panggilan tepat.

### 5.2 Panggilan Keluarga Inti

| Panggilan | Definisi |
|-----------|----------|
| Amang/Among/Bapa | Ayah kandung |
| Inang/Inong/Omak | Ibu kandung |
| Haha/Angkang | Kakak laki-laki/perempuan |
| Agi/Anggi | Adik laki-laki/perempuan |
| Iboto/Ito | Saudara kandung beda jenis kelamin |
| Boru | Anak perempuan |

### 5.3 Panggilan Marga Ayah

| Panggilan | Definisi |
|-----------|----------|
| Amang Tua | Abang ayah |
| Amang Uda | Adik laki-laki ayah |
| Namboru | Saudari ayah (bibi) |
| Amang Boru | Suami saudari ayah |

### 5.4 Panggilan Marga Ibu

| Panggilan | Definisi |
|-----------|----------|
| Tulang | Saudara laki-laki ibu (paman) |
| Nantulang | Istri tulang |
| Lae | Anak laki-laki tulang |
| Eda | Anak perempuan tulang |

### 5.5 Panggilan Pernikahan

| Panggilan | Definisi |
|-----------|----------|
| Simatua | Mertua |
| Hela | Menantu laki-laki |
| Parumaen | Menantu perempuan |
| Tunggane | Saudara laki-laki istri |
| Bere | Calon menantu (pacaran) |
| Pariban | Anak dari saudara laki-laki ibu dengan anak dari saudara perempuan ayah |

---

## 6. RITUAL DAN UPACARA ADAT

### 6.1 Tahapan Pernikahan Adat

| Tahap | Nama | Deskripsi |
|-------|------|-----------|
| 1 | Mangarisika | Kunjungan non-resmi untuk penjajakan |
| 2 | Martumpol | Pertunangan resmi, pemberian tanda |
| 3 | Martonggo Raja | Pemberitahuan resmi ke masyarakat |
| 4 | Marsibuha Buhai | Penjemputan mempelai wanita |
| 5 | Pemberkatan | Pelaksanaan pernikahan resmi |
| 6 | Mangulosi | Pemberian ulos sebagai restu |
| 7 | Paulak Une | Penutupan acara adat |

### 6.2 Elemen Penting

| Elemen | Fungsi |
|--------|--------|
| **Sinamot** | Pemberian dari pihak pria ke wanita - bukan "pembelian" melainkan penghormatan |
| **Ulos** | Kain tenun sakral - lambang doa dan restu |
| **Dengke** | Ikan masak khas - simbol seia sekata |
| **Jambar** | Pembagian makanan adat |
| **Raja Parhata** | Protokol/juru bicara adat |

### 6.3 Pihak dalam Acara Adat

| Pihak | Definisi |
|-------|----------|
| Parboru | Orang tua pengantin perempuan |
| Paranak | Orang tua pengantin pria |
| Suhut | Tuan rumah penyelenggara acara |
| Hula-hula | Saudara laki-laki ibu masing-masing suhut |
| Tulang | Saudara laki-laki ibu (sisi lain) |
| Dongan Tubu | Sesama marga |
| Boru | Keluarga yang menikahi sesama marga dengan suhut |

### 6.4 Upacara Kematian

| Jenis | Kriteria | Upacara |
|-------|----------|---------|
| Saur Matua | Orang tua yang meninggal dengan anak sudah menikah & punya cucu | Upacara besar, pesta adat |
| Mate Bortian | Bayi dalam kandungan/meninggal sebelum lahir | Dikubur langsung tanpa peti |
| Mate Saur Matua | Orang tua yang belum punya cucu | Upacara sederhana |
| Mate Na Soada | Meninggal karena kecelakaan/bunuh diri | Ritual khusus |

---

## 7. PRINSIP SISTEM TAROMBO DIGITAL

### 7.1 Verifikasi dan Keabsahan Data

```
PRINSIP VERIFIKASI TAROMBO
═══════════════════════════════════════════════════════════════

Setiap perubahan data dalam sistem harus melalui proses verifikasi:

┌─────────────────────────────────────────────────────────────┐
│                    VERIFICATION CHAIN                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   INPUT ──► VALIDATION ──► VERIFICATION ──► APPROVAL ──►   │
│   DATA        OTOMATIS       MANUAL         FINAL           │
│                                                             │
│   • Format    • Aturan    • Tetua/Keluarga • Status       │
│     check       adat        confirmation     update         │
│   • Relasi                                              │
│     logis                                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Komponen Verifikasi:
────────────────────
1. PENGUSUL (Proposer)
   - User yang mengajukan perubahan data
   - Harus memiliki relasi atau hak akses
   
2. VERIFIKATOR (Verifier)
   - Minimal 2 anggota keluarga (L2)
   - Atau 1 Tetua Adat (L3)
   - Atau Admin Budaya (L5)
   
3. RIWAYAT (Audit Trail)
   - Timestamp lengkap
   - Perubahan nilai (old → new)
   - Alasan perubahan
   - Bukti pendukung
```

### 7.2 Resolusi Konflik Data

```
KONFLIK DATA SCENARIO
═══════════════════════════════════════════════════════════════

Kasus: Perbedaan data untuk orang yang sama

Contoh Konflik:
┌─────────────────────────────────────────────────────────────┐
│ Versi A: Ayah = X (dari keluarga pihak ayah)              │
│ Versi B: Ayah = Y (dari keluarga pihak ibu)               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Sistem menyimpan:                                          │
│ • Kedua versi sebagai "CLAIMED"                            │
│ • Sumber masing-masing versi                                │
│ • Timestamp input                                           │
│ • Status: PENDING_RESOLUTION                               │
│                                                             │
│ Resolusi:                                                  │
│ • Review oleh Tetua Adat                                   │
│ • Verifikasi dokumen (akta, KTP, testimony)              │
│ • Keputusan: CONFIRMED / REJECTED                          │
│ • Riwayat resolusi disimpan permanen                       │
└─────────────────────────────────────────────────────────────┘

Alur Resolusi Konflik:
1. DETEKSI → Sistem otomatis mendeteksi konflik
2. FLAGGING → Data ditandai "CONFLICTED"
3. NOTIFIKASI → Pihak terkait diberitahu
4. REVIEW → Tetua/Admin review bukti
5. RESOLUSI → Keputusan final dicatat
6. ARSIP → Konflik dan resolusi diarsipkan
```

### 7.3 Prinsip Privasi Data

Sistem mengimplementasikan tingkat privasi hierarkis:

| Tingkat | Definisi | Akses | Contoh Data |
|---------|----------|-------|-------------|
| **PUBLIK** | Data terbuka | Semua user | Nama lengkap, marga, generasi |
| **TERBATAS** | Data keluarga | Keluarga + Dongan tubu | Tanggal lahir, tempat lahir, status pernikahan |
| **RAHASIA** | Data sensitif | Keluarga inti + approval | Alamat lengkap, kontak pribadi, dokumen identitas |
| **SENSITIF** | Data kritis | Admin + verifikasi khusus | Informasi keuangan, data medis, histori sensitif |

```
PRIVACY MATRIX
═══════════════════════════════════════════════════════════════

                      PUBLIK   TERBATAS   RAHASIA   SENSITIF
                      ───────  ─────────  ────────  ────────
User Biasa             ✓        -          -         -
Verified User          ✓        ✓ (family) -         -
Dongan Tubu            ✓        ✓          -         -
Tetua Adat             ✓        ✓          L3        -
Admin Budaya           ✓        ✓          ✓         L5
Admin Sistem           ✓        ✓          ✓         ✓

Catatan: 
• Data pribadi dapat di-set lebih restrictive oleh owner
• Opt-in required untuk data sharing antar komunitas
• Right to be forgotten: user dapat request deletion
```

### 7.4 Jenis Acara Adat Tambahan

Selain pernikahan dan kematian, sistem mendukung:

#### Mangokal Holi
- Penghubung antara leluhur, keturunan, dan lokasi makam
- Dokumentasi: Tempat asal, makam leluhur, migrasi keluarga
- Relasi: Vertical lineage + Geografis

#### Baptisan/Penyerahan Anak
- Pencatatan spiritual dalam komunitas gereja/adat
- Hubungan: Anak, Orang tua, Keluarga besar, Pihak gereja
- Sponsors: Ditandai sebagai hubungan adat khusus

### 7.5 Pemisahan Hubungan

Sistem membedakan dengan jelas:

```
┌─────────────────────────────────────────────────────────────┐
│              HUBUNGAN DARAH vs HUBUNGAN ADAT                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  HUBUNGAN DARAH (Blood Relations)                           │
│  ─────────────────────────────────                          │
│  • Fixed, tidak berubah                                     │
│  • Prioritas verifikasi: TINGGI                             │
│  • Contoh: Ayah, Ibu, Anak, Saudara kandung                │
│                                                             │
│  HUBUNGAN ADAT (Adat Relations)                             │
│  ─────────────────────────────────                          │
│  • Context-dependent, dapat berubah                         │
│  • Dihitung dinamis berdasarkan situasi                     │
│  • Contoh: Hula-hula, Boru, Dongan Tubu (bisa berbeda      │
│    tergantung acara)                                       │
│                                                             │
│  IMPLEMENTASI:                                             │
│  • Hubungan darah: Stored dalam database                    │
│  • Hubungan adat: Calculated on-demand                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. IMPLEMENTASI DIGITAL

### 8.1 Entitas Utama Sistem

```
┌─────────────────────────────────────────────────────────┐
│              ENTITAS SISTEM TAROMBO                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │   PERSON    │◄──►│   MARGA     │◄──►│ SUB-MARGA   │ │
│  │  (Individu) │    │   (Klan)    │    │  (Cabang)   │ │
│  └──────┬──────┘    └─────────────┘    └─────────────┘ │
│         │                                               │
│         ▼                                               │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │  MARRIAGE   │    │ RELATIONSHIP│    │  CEREMONY   │ │
│  │  (Perkaw.)  │    │  (Hubungan) │    │  (Upacara)  │ │
│  └─────────────┘    └─────────────┘    └─────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 7.2 Aturan Validasi Data

| Aturan | Deskripsi |
|--------|-----------|
| R001 | Marga wajib diisi dan valid terhadap daftar resmi |
| R002 | Tidak boleh ada perkawinan sesama marga |
| R003 | Orang tua wajib memiliki marga yang sama dengan anak laki-laki |
| R004 | Isteri masuk ke marga suami dalam sistem pencatatan |
| R005 | Generasi dihitung berdasarkan patrilineal lineage |

### 7.3 Partuturan Algorithm

```
FUNCTION getPartuturan(fromPerson, toPerson):
    IF sameMarga(fromPerson, toPerson):
        IF sameFather(fromPerson, toPerson):
            RETURN siblingTerm(fromPerson, toPerson)
        ELSE:
            RETURN "Dongan" + generationGap(fromPerson, toPerson)
    
    IF isMothersBrother(toPerson, fromPerson):
        RETURN "Tulang"
    
    IF isFathersSister(toPerson, fromPerson):
        RETURN "Namboru"
    
    IF isSpouse(toPerson, fromPerson):
        RETURN "Boru" (for wife) / "Doli" (for husband)
    
    RETURN calculateExtendedKinship(fromPerson, toPerson)
END FUNCTION
```

### 7.4 Pertimbangan Multi-Sub-Suku

| Sub-Suku | Modifikasi Sistem |
|----------|-------------------|
| Toba | Sistem referensi penuh |
| Karo | Menambah field "Merga", mengubah partuturan |
| Simalungun | Simplified marga validation (4 marga utama) |
| Mandailing | Menambah field agama, modifikasi ritual |
| Pakpak | Strict marga validation |

---

## LAMPIRAN A: Daftar Marga Batak Toba Lengkap

### A.1 Marga Berdasarkan Urutan Alfabet

| No | Marga | No | Marga | No | Marga |
|----|-------|----|-------|----|-------|
| 1 | Aritonang | 2 | Ambarita | 3 | Banjarnahor |
| 4 | Batubara | 5 | Butarbutar | 6 | Doloksaribu |
| 7 | Gultom | 8 | Harahap | 9 | Hasibuan |
| 10 | Hutabarat | 11 | Hutagalung | 12 | Hutagaol |
| 13 | Hutahaean | 14 | Hutajulu | 15 | Hutapea |
| 16 | Hutasoit | 17 | Limbong | 18 | Lubis |
| 19 | Lumbanbatu | 20 | Lumbangaol | 21 | Lumbantobing |
| 22 | Malau | 23 | Manalu | 24 | Manik |
| 25 | Manurung | 26 | Marbun | 27 | Marpaung |
| 28 | Naibaho | 29 | Nainggolan | 30 | Naipospos |
| 31 | Napitupulu | 32 | Pakpahan | 33 | Pandiangan |
| 34 | Pane | 35 | Pangaribuan | 36 | Panggabean |
| 37 | Panjaitan | 38 | Pardede | 39 | Pardosi |
| 40 | Pasaribu | 41 | Pohan | 42 | Purba |
| 43 | Rajagukguk | 44 | Sagala | 45 | Samosir |
| 46 | Sarumpaet | 47 | Siagian | 48 | Siahaan |
| 49 | Siallagan | 50 | Sianipar | 51 | Sianturi |
| 52 | Sibarani | 53 | Sibuea | 54 | Sigalingging |
| 55 | Sihombing | 56 | Sihotang | 57 | Silaen |
| 58 | Silaban | 59 | Silalahi | 60 | Silitonga |
| 61 | Simamora | 62 | Simangunsong | 63 | Simanjuntak |
| 64 | Simanullang | 65 | Simanungkalit | 66 | Simaremare |
| 67 | Simarmata | 68 | Simatupang | 69 | Simbolon |
| 70 | Sinaga | 71 | Sinambela | 72 | Sinurat |
| 73 | Sipahutar | 74 | Sirait | 75 | Siregar |
| 76 | Sitanggang | 77 | Sitepu | 78 | Sitindaon |
| 79 | Sitinjak | 80 | Sitohang | 81 | Sitompul |
| 82 | Sitorus | 83 | Situmeang | 84 | Situmorang |
| 85 | Tamba | 86 | Tambunan | 87 | Tampubolon |
| 88 | Tanjung | 89 | Togatorop | 90 | Sianturi |
| 91 | Siburian | 92 | - | 93 | - |

**Total: 90+ marga tercatat** (dokumen ini akan terus diperbarui)

---

## REFERENSI

1. Simatupang, D. (2014). *Hukum Adat Batak Dalihan Na Tolu*. Jakarta: Pustaka Sinar Harapan.
2. Parlindungan, T. (2002). *Adat Batak: Dalihan Na Tolu*. Tugu Harapan.
3. Wikipedia Indonesia - Partuturan (Batak Toba)
4. Batakkeren.com - Sistem Marga dan Tarombo
5. Gramedia Literasi - Sistem Kekerabatan Batak
6. Budaya-Indonesia.org - Tarombo dan Adat Batak
7. Komunitas-batak.com - Urutan Acara Adat
8. Batarasimanjuntak.wordpress.com - Ulaon Adat Pengolihon Anak

---

**Dokumen ini adalah referensi teknis dan budaya untuk pengembangan Tarombo Digital. Segala implementasi harus tetap menghormati dan mengonsultasikan dengan para tetua adat Batak.**

© 2026 Tarombo Digital Project
