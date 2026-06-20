-- Migration 006: Fix tree structure - pasangan dan keturunan
-- Perbaiki hubungan perkawinan dan orang_tuan_id

USE tarombo;

-- 1. Lepaskan Mangala Bulan dari Mulajadi Na Bolon (dia dari realm dewa berbeda)
-- Mangala Bulan akan muncul sebagai pasangan Si Boru Deak Parujar, bukan anak Mulajadi
UPDATE silsilah_mitolologis SET orang_tuan_id = NULL WHERE nama = 'Mangala Bulan';

-- 2. Set pasangan_id: Si Boru Deak Parujar × Mangala Bulan
UPDATE silsilah_mitolologis SET pasangan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Mangala Bulan') t) WHERE nama = 'Si Boru Deak Parujar';
UPDATE silsilah_mitolologis SET pasangan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Si Boru Deak Parujar') t) WHERE nama = 'Mangala Bulan';

-- 3. Anak-anak (Raja Ihat Manisia & Boru Ihat Manisia) orang_tuan_id sudah = Si Boru Deak Parujar (id=4)
-- Ini sudah benar, anak mengikuti garis ibu yang turun ke bumi

-- 4. Hubungkan Guru Tatea Bulan ke Boru Ihat Manisia (beberapa generasi kemudian)
-- Dalam mitologi, Guru Tatea Bulan adalah keturunan beberapa generasi setelah Raja Ihat Manisia
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Boru Ihat Manisia') t) WHERE nama = 'Guru Tatea Bulan';

-- 5. Update info perkawinan yang lebih akurat
UPDATE silsilah_mitolologis SET 
    pasangan_nama = 'Saniang Naga (permaisuri)',
    info_perkawinan = 'Batara Guru menikah dengan Saniang Naga, putri dari kerajaan dewa lain'
WHERE nama = 'Batara Guru';

UPDATE silsilah_mitolologis SET 
    pasangan_nama = 'Si Boru Deak Parujar (putri Batara Guru)',
    info_perkawinan = 'Raja Odap-odap menikahi Si Boru Deak Parujar setelah ia turun ke Banua Tonga (bumi)'
WHERE nama = 'Mangala Bulan';

UPDATE silsilah_mitolologis SET 
    pasangan_nama = 'Mangala Bulan / Raja Odap-odap',
    info_perkawinan = 'Si Boru Deak Parujar awalnya menolak, tapi akhirnya menikah dengan Raja Odap-odap di bumi. Mereka berdua menjadi cikal bakal manusia Batak.'
WHERE nama = 'Si Boru Deak Parujar';

-- 6. Tambah info perkawinan untuk Guru Tatea Bulan
UPDATE silsilah_mitolologis SET 
    pasangan_nama = 'Si Boru Baso Burning',
    info_perkawinan = 'Guru Tatea Bulan menikah dengan Si Boru Baso Burning, melahirkan Raja Isumbaon'
WHERE nama = 'Guru Tatea Bulan';

-- 7. Update deskripsi untuk klarifikasi
UPDATE silsilah_mitolologis SET 
    deskripsi = 'Raja Odap-odap dari kerajaan dewa. Menikahi Si Boru Deak Parujar setelah ia turun ke bumi. Mereka berdua menjadi leluhur manusia Batak.'
WHERE nama = 'Mangala Bulan';

UPDATE silsilah_mitolologis SET 
    deskripsi = 'Putri Batara Guru yang turun ke bumi (Banua Tonga). Menikah dengan Raja Odap-odap dan melahirkan Raja Ihat Manisia & Boru Ihat Manisia — cikal bakal orang Batak.'
WHERE nama = 'Si Boru Deak Parujar';

UPDATE silsilah_mitolologis SET 
    deskripsi = 'Anak pertama Si Boru Deak Parujar & Raja Odap-odap. Leluhur langsung orang Batak.'
WHERE nama = 'Raja Ihat Manisia';

UPDATE silsilah_mitolologis SET 
    deskripsi = 'Anak kedua Si Boru Deak Parujar & Raja Odap-odap. Keturunannya melahirkan Guru Tatea Bulan.'
WHERE nama = 'Boru Ihat Manisia';

UPDATE silsilah_mitolologis SET 
    deskripsi = 'Keturunan Boru Ihat Manisia, beberapa generasi setelah Si Boru Deak Parujar. Penghubung antara dunia dewa dan manusia Batak.'
WHERE nama = 'Guru Tatea Bulan';
