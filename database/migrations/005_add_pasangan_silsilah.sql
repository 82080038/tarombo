-- Migration 005: Add pasangan (spouse) data to silsilah
-- Tambahkan info perkawinan dan pasangan

USE tarombo;

-- Tambah kolom pasangan_id ke silsilah_mitolologis
ALTER TABLE silsilah_mitolologis 
ADD COLUMN IF NOT EXISTS pasangan_id INT NULL COMMENT 'ID pasangan (suami/istri)',
ADD COLUMN IF NOT EXISTS pasangan_nama VARCHAR(255) NULL COMMENT 'Nama pasangan',
ADD COLUMN IF NOT EXISTS info_perkawinan TEXT NULL COMMENT 'Info perkawinan',
ADD FOREIGN KEY IF NOT EXISTS (pasangan_id) REFERENCES silsilah_mitolologis(id) ON DELETE SET NULL;

-- Update data dengan info pasangan dan perkawinan
-- Gen 1-2: Dewa
UPDATE silsilah_mitolologis SET pasangan_nama = '—', info_perkawinan = 'Dewa tertinggi, tidak ada pasangan' WHERE nama = 'Mulajadi Na Bolon';

-- Batara Guru
UPDATE silsilah_mitolologis SET pasangan_nama = 'Saniang Naga', info_perkawinan = 'Batara Guru menikah dengan Saniang Naga' WHERE nama = 'Batara Guru';

-- Mangala Bulan / Raja Odap-odap
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Deak Parujar', info_perkawinan = 'Raja Odap-odap menikah dengan Si Boru Deak Parujar (putri Batara Guru)' WHERE nama = 'Mangala Bulan';

-- Si Boru Deak Parujar
UPDATE silsilah_mitolologis SET pasangan_nama = 'Raja Odap-odap (Mangala Bulan)', info_perkawinan = 'Si Boru Deak Parujar menikah dengan Raja Odap-odap setelah turun ke bumi' WHERE nama = 'Si Boru Deak Parujar';

-- Gen 5: Guru Tatea Bulan
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Baso Burning', info_perkawinan = 'Guru Tatea Bulan menikah dengan Si Boru Baso Burning' WHERE nama = 'Guru Tatea Bulan';

-- Gen 6: Raja Isumbaon
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Serimbang', info_perkawinan = 'Raja Isumbaon menikah dengan Si Boru Serimbang' WHERE nama = 'Raja Isumbaon';

-- Gen 7: Tuan Sariburaja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Pareme (istri 1) & Nai Mangiring Laut (istri 2)', info_perkawinan = 'Tuan Sariburaja menikah dengan 2 istri: Si Boru Pareme (ibu Si Raja Lontung & kelompok Borbor) dan Nai Mangiring Laut (ibu Tuan Sorimangaraja)' WHERE nama = 'Tuan Sariburaja';

-- Gen 8: Si Raja Lontung
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Sitomayan', info_perkawinan = 'Si Raja Lontung menikah dengan Si Boru Sitomayan, memiliki 8 anak' WHERE nama = 'Si Raja Lontung';

-- Limbong Mulana
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Pinta Omas', info_perkawinan = 'Limbong Mulana menikah dengan Si Boru Pinta Omas' WHERE nama = 'Limbong Mulana';

-- Sagala Raja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Sabungan', info_perkawinan = 'Sagala Raja menikah dengan Si Boru Anting Sabungan' WHERE nama = 'Sagala Raja';

-- Silau Raja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Menalam', info_perkawinan = 'Silau Raja menikah dengan Si Boru Anting Menalam' WHERE nama = 'Silau Raja';

-- Si Raja Borbor
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Mela', info_perkawinan = 'Si Raja Borbor menikah dengan Si Boru Anting Mela' WHERE nama = 'Si Raja Borbor';

-- Tuan Sorimangaraja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Malela (istri 1), Si Boru Anting Haomasan (istri 2), Siboru Sinta (istri 3)', info_perkawinan = 'Tuan Sorimangaraja menikah dengan 3 istri: Si Boru Paromas (ibu Nai Ambaton), Si Boru Anting Haomasan (ibu Nai Rasaon), Siboru Sinta (ibu Nai Suanon)' WHERE nama = 'Tuan Sorimangaraja';

-- Gen 9: Anak-anak Si Raja Lontung
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Manga Ranggas', info_perkawinan = 'Raja Sibagotni Pohan menikah dengan Si Boru Manga Ranggas' WHERE nama = 'Raja Sibagotni Pohan';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Bunga', info_perkawinan = 'Raja Sipaettua menikah dengan Si Boru Anting Bunga' WHERE nama = 'Raja Sipaettua';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Rungga', info_perkawinan = 'Raja Silahisabungan menikah dengan Si Boru Anting Rungga' WHERE nama = 'Raja Silahisabungan';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Nangkir', info_perkawinan = 'Raja Oloan menikah dengan Si Boru Anting Nangkir' WHERE nama = 'Raja Oloan';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Godang', info_perkawinan = 'Raja Hutalima menikah dengan Si Boru Anting Godang' WHERE nama = 'Raja Hutalima';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Pane', info_perkawinan = 'Raja Sumba menikah dengan Si Boru Anting Pane' WHERE nama = 'Raja Sumba';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Bolon', info_perkawinan = 'Raja Sobu menikah dengan Si Boru Anting Bolon' WHERE nama = 'Raja Sobu';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Jou', info_perkawinan = 'Raja Naipospos menikah dengan Si Boru Anting Jou' WHERE nama = 'Raja Naipospos';

-- Gen 9: Anak-anak Tuan Sorimangaraja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Tua', info_perkawinan = 'Nai Ambaton menikah dengan Si Boru Anting Tua' WHERE nama LIKE '%Nai Ambaton%';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Muda', info_perkawinan = 'Nai Rasaon menikah dengan Si Boru Anting Muda' WHERE nama LIKE '%Nai Rasaon%';

UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Bunga', info_perkawinan = 'Nai Suanon menikah dengan Si Boru Anting Bunga' WHERE nama LIKE '%Nai Suanon%';
