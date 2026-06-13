# 🎓 Training Budaya Batak untuk Developer

**Versi:** 1.0.0  
**Durasi:** 2-3 jam  
**Target:** Developer baru Tarombo Digital

---

## 📋 Tujuan Training

Setelah training ini, developer diharapkan:
1. Memahami konsep dasar budaya Batak
2. Mengerti sistem marga dan silsilah
3. Paham aturan partuturan (hubungan kekerabatan)
4. Dapat mengimplementasikan business rules Batak dengan benar

---

## 🌳 Konsep Dasar: Marga

### Apa itu Marga?

**Marga** adalah nama keluarga patrilineal di masyarakat Batak. Marga diturunkan dari ayah ke anak laki-laki secara turun-temurun.

**Contoh:**
- Si Raja Batak → Guru Tatea Bulan → Raja Isumbaon → Tuan Sariburaja → Pasaribu
- Jika ayah marga Pasaribu, anak laki-laki juga Pasaribu
- Anak perempuan tetap Pasaribu, tapi anak-anaknya mengikuti marga suaminya

### Struktur Hierarki Marga

```
Si Raja Batak (Induk Utama)
├── Guru Tatea Bulan
│   └── Raja Isumbaon
│       ├── Tuan Sariburaja → Pasaribu, Batubara, dll
│       ├── Sagala Raja → Harahap, Tanjung
│       ├── Silau Raja → Pulungan, Lubis
│       ├── Raja Lontung → Situmorang, Sinaga, dll
│       └── Raja Oloan → Hutagalung, Hutapea, dll
```

### Sub-Suku Batak

| Sub-Suku | Wilayah Utama | Marga Contoh |
|----------|---------------|--------------|
| Toba | Toba Samosir | Simanjuntak, Situmorang, Hutagalung |
| Karo | Tanah Karo | Ginting, Tarigan, Girsang |
| Simalungun | Simalungun | Purba, Damanik, Saragih |
| Mandailing | Mandailing Natal | Nasution, Lubis, Harahap |
| Angkola | Angkola | Daulay, Pulungan |
| Pakpak | Pakpak | Manik, Beringin, Capah |

---

## 👨‍👩‍👧‍👦 Sistem Keluarga

### Dalihan Na Tolu (Tiga Tungku)

Fondasi sosial Batak terdiri dari 3 elemen:

1. **Siholi (Anak Kandung)**
   - Hubungan orang tua-anak
   - Tanggung jawab orang tua mendidik anak
   - Anak wajib menghormati orang tua

2. **Sahat (Saudara Kandung)**
   - Hubungan antar saudara satu ayah-ibu
   - Solidaritas dan saling membantu
   - Sama marga (satu garis keturunan)

3. **Dongan Tubu (Kerabat Ibu)**
   - Hubungan melalui garis ibu
   - Penting dalam sistem pernikahan
   - Menghindari inces (kawin sedarah)

---

## 🔄 Partuturan (Hubungan Kekerabatan)

### Konsep Partuturan

**Partuturan** adalah sistem pengaturan hubungan kekerabatan berdasarkan:
- Marga (garis keturunan)
- Generasi (sejarah turun)
- Wilayah (asal-usul)

### Jenis Hubungan Partuturan

#### 1. Hula-Hula (Mertua Ibu)

**Definisi:** Keluarga ibu, pihak yang memberikan anak perempuan untuk dinikahkan.

**Peran:**
- Di hormati sebagai pemberi kehidupan
- Menjadi penasihat adat
- Disebut "Amang" (laki-laki) atau "Inang" (perempuan)

**Contoh:**
- Jika A menikah dengan B, maka keluarga B adalah hula-hula bagi A

#### 2. Dongan Tubu (Kerabat Ibu)

**Definisi:** Saudara-saudara dari pihak ibu.

**Peran:**
- Penjaga adat
- Mediator dalam konflik
- Tidak boleh kawin (inces)

#### 3. Boru (Anak Perempuan)

**Definisi:** Anak perempuan yang dinikahkan ke keluarga lain.

**Peran:**
- Membawa nama marga ke keluarga suami
- Menjaga hubungan antar marga
- Disebut "Boru" oleh keluarga suami

#### 4. Tulang (Kerabat Suami)

**Definisi:** Saudara-saudara dari pihak suami.

**Peran:**
- Pelindung keluarga
- Pembantu dalam kebutuhan
- Disebut "Tulang" oleh keluarga istri

---

## 🚫 Aturan Pernikahan

### Pernikahan Dilarang (Inces)

**Pernikahan dilarang jika:**
1. Sama marga (satu garis keturunan)
2. Kerabat dekat (dongan tubu)
3. Hubungan hula-hula (mertua ibu)

### Pasangan yang Dilarang

Contoh pasangan yang dilarang (BR-PRK-007):
- Situmorang dengan Situmorang (sama marga)
- Harahap dengan Harahap (sama marga)
- Lubis dengan Lubis (sama marga)
- Hutagalung dengan Hutagalung (sama marga)

### Pernikahan yang Diizinkan

**Syarat:**
- Berbeda marga
- Tidak ada hubungan kerabat dekat
- Memenuhi aturan partuturan

**Contoh pasangan yang diizinkan:**
- Simanjuntak (Toba) dengan Hutagalung (Toba) - berbeda marga
- Situmorang (Toba) dengan Ginting (Karo) - berbeda sub-suku
- Nasution (Mandailing) dengan Purba (Simalungun) - berbeda sub-suku

---

## 📊 Implementasi dalam Aplikasi

### Business Rules yang Perlu Diimplementasikan

#### BR-MRG-001: Marga Patrilineal
```php
// Marga diturunkan dari ayah
function determineMarga($father_id, $mother_id) {
    if ($father_id) {
        return getPersonMarga($father_id);
    }
    return null; // Anak tanpa ayah, marga belum ditentukan
}
```

#### BR-PRK-006: Sama Marga Dilarang
```php
function validateMarriage($husband_id, $wife_id) {
    $husband_marga = getPersonMarga($husband_id);
    $wife_marga = getPersonMarga($wife_id);
    
    if ($husband_marga === $wife_marga) {
        throw new Exception("Pernikahan sama marga dilarang");
    }
    
    return true;
}
```

#### BR-TUL-001: Kalkulasi Tulang
```php
function calculateTulang($person_id, $spouse_id) {
    // Tulang = kerabat suami
    // Ambil semua saudara laki-laki dari suami
    $spouse_father_id = getPersonFather($spouse_id);
    $spouse_siblings = getSiblings($spouse_father_id);
    
    return array_filter($spouse_siblings, function($sibling) {
        return $sibling->gender === 'L';
    });
}
```

#### BR-NBR-001: Kalkulasi Namboru
```php
function calculateNamboru($person_id) {
    // Namboru = anak perempuan dari saudara laki-laki
    $siblings = getSiblings($person_id);
    $male_siblings = array_filter($siblings, function($s) {
        return $s->gender === 'L';
    });
    
    $namboru = [];
    foreach ($male_siblings as $uncle) {
        $children = getChildren($uncle->id);
        $namboru = array_merge($namboru, 
            array_filter($children, function($c) {
                return $c->gender === 'P';
            })
        );
    }
    
    return $namboru;
}
```

---

## 🧪 Quiz Singkat

### Pertanyaan 1
Jika ayah marga Simanjuntak, apa marga anak laki-lakinya?

**Jawaban:** Simanjuntak (patrilineal)

### Pertanyaan 2
Apakah Situmorang boleh menikah dengan Situmorang?

**Jawaban:** Tidak (sama marga dilarang)

### Pertanyaan 3
Apa peran hula-hula dalam pernikahan?

**Jawaban:** Keluarga ibu, pemberi anak perempuan, dihormati

### Pertanyaan 4
Apa perbedaan antara dongan tubu dan tulang?

**Jawaban:** 
- Dongan tubu = kerabat ibu
- Tulang = kerabat suami

### Pertanyaan 5
Berapa sub-suku Batak yang ada?

**Jawaban:** 6 (Toba, Karo, Simalungun, Mandailing, Angkola, Pakpak)

---

## 📚 Referensi Lanjutan

Untuk pemahaman lebih mendalam, baca:
1. `docs/ANALISIS_BUDAYA_BATAK.md` - Analisis budaya lengkap
2. `docs/KAMUS_ISTILAH_ADAT_BATAK.md` - Kamus istilah
3. `docs/WORKFLOW_ADAT.md` - Workflow adat lengkap
4. `docs/BUSINESS_RULE.md` - 100+ business rules

---

## ✅ Checklist Training

Setelah training, developer harus:
- [ ] Memahami konsep marga patrilineal
- [ ] Mengetahui 6 sub-suku Batak
- [ ] Paham Dalihan Na Tolu
- [ ] Mengerti 4 jenis partuturan
- [ ] Bisa menjelaskan aturan pernikahan
- [ ] Dapat mengimplementasikan BR-MRG-001
- [ ] Dapat mengimplementasikan BR-PRK-006
- [ ] Dapat mengimplementasikan BR-TUL-001
- [ ] Dapat mengimplementasikan BR-NBR-001

---

**Motto:** *"Marsipature Hutanabe, Mardongan Tubu, Marhula-hula, Marboru, dalam Era Digital."*
