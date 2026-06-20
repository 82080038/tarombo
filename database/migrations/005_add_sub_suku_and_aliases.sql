-- Migration: Sub-suku, marga induk, alias lintas sub-suku
-- Sumber: Wikipedia (Daftar marga Batak), budaya-indonesia.org, naming.id
-- Tanggal: 2026-06-21

-- ============================================
-- 1. SKEMA: Tambah kolom marga_induk_id & buat tabel baru
-- ============================================

-- Tambah kolom marga_induk_id (untuk sub-marga yang merujuk ke marga induk)
ALTER TABLE marga ADD COLUMN marga_induk_id INT NULL DEFAULT NULL;
ALTER TABLE marga ADD FOREIGN KEY (marga_induk_id) REFERENCES marga(id) ON DELETE SET NULL;

-- Tabel alias: marga yang sama dengan nama berbeda di sub-suku lain
CREATE TABLE IF NOT EXISTS marga_alias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marga_id INT NOT NULL,
    alias_nama VARCHAR(100) NOT NULL,
    sub_suku VARCHAR(50) NOT NULL,
    keterangan TEXT NULL,
    FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_alias (marga_id, alias_nama, sub_suku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabel junction marga_sub_suku: satu marga bisa ada di multiple sub-suku
CREATE TABLE IF NOT EXISTS marga_sub_suku (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marga_id INT NOT NULL,
    sub_suku VARCHAR(50) NOT NULL,
    is_native TINYINT(1) DEFAULT 0 COMMENT '1 = marga asli sub-suku ini, 0 = ada karena migrasi/persebaran',
    FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE CASCADE,
    UNIQUE KEY uniq_marga_suku (marga_id, sub_suku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 2. FIX SUB_SUKU MARGA YANG SUDAH ADA
-- ============================================

-- Marga yang sebenarnya Mandailing/Angkola tapi di-tag Toba
UPDATE marga SET sub_suku = 'Mandailing' WHERE nama IN ('Lubis', 'Nasution', 'Harahap', 'Rangkuti', 'Parinduri', 'Daulay') AND sub_suku = 'Toba';
UPDATE marga SET sub_suku = 'Angkola' WHERE nama IN ('Dasopang', 'Dalimunthe') AND sub_suku = 'Toba';

-- Marga yang tersebar di Toba & Angkola/Mandailing — set ke yang dominan
UPDATE marga SET sub_suku = 'Toba' WHERE nama IN ('Batubara', 'Pasaribu', 'Pulungan', 'Tanjung', 'Matondang', 'Parapat', 'Hutasuhut', 'Sipahutar', 'Tarihoran') AND sub_suku = 'Mandailing';

-- Marga Karo yang di-tag Toba
UPDATE marga SET sub_suku = 'Karo' WHERE nama IN ('Ginting', 'Karo-karo', 'Peranginangin', 'Tarigan', 'Sembiring', 'Surbakti', 'Sitepu', 'Sinuraya', 'Kembaren', 'Bangun', 'Barus', 'Sebastian', 'Tekan') AND sub_suku = 'Toba';

-- Marga Pakpak yang di-tag Toba
UPDATE marga SET sub_suku = 'Pakpak' WHERE nama IN ('Berutu', 'Capah', 'Kabeaken', 'Maibang', 'Mungkur', 'Solin') AND sub_suku = 'Toba';

-- Marga Simalungun yang di-tag Toba
UPDATE marga SET sub_suku = 'Simalungun' WHERE nama IN ('Damanik', 'Saragih') AND sub_suku = 'Toba';

-- ============================================
-- 3. ISI MARGA_SUB_SUKU UNTUK MARGA YANG SUDAH ADA
-- ============================================

-- Insert marga_sub_suku untuk semua marga yang sudah ada (is_native=1 untuk sub_suku asalnya)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native)
SELECT id, sub_suku, 1 FROM marga WHERE sub_suku IS NOT NULL
ON DUPLICATE KEY UPDATE is_native = VALUES(is_native);

-- Marga yang tersebar di multiple sub-suku (dari Wikipedia)
-- Batubara: Toba + Angkola + Mandailing
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Batubara'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Batubara'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Harahap: Mandailing + Angkola + Toba (Borbor)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Harahap'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Toba', 0 FROM marga WHERE nama = 'Harahap'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Nasution: Mandailing + Angkola + Toba (Naisuanon)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Nasution'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Toba', 0 FROM marga WHERE nama = 'Nasution'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Lubis: Mandailing + Toba (Borbor)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Toba', 0 FROM marga WHERE nama = 'Lubis'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Pulungan: Toba (Borbor) + Angkola + Mandailing
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Pulungan'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Pulungan'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Tanjung: Toba (Borbor) + Angkola + Mandailing
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Tanjung'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Tanjung'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Pasaribu: Toba (Borbor) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Pasaribu'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Matondang: Toba (Borbor) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Matondang'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Siregar: Toba (Lontung) + Angkola (sebagai Dongoran, Ritonga, Siagian, Sormin)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Siregar'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Siregar'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Hasibuan: Toba (Naisuanon) + Mandailing + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Hasibuan'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Hasibuan'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Hutasuhut: Toba (Borbor) + Mandailing + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Hutasuhut'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Hutasuhut'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Marpaung: Toba (Naisuanon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Marpaung'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Simatupang: Toba (Lontung) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Simatupang'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Tampubolon: Toba (Naisuanon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Tampubolon'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Tambunan: Toba (Naisuanon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Tambunan'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Nainggolan: Toba (Lontung) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Nainggolan'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sitorus: Toba (Nairasaon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Sitorus'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Panggabean: Toba (Naisuanon) + Mandailing + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Panggabean'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Panggabean'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Pohan: Toba (Naisuanon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Pohan'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sibarani: Toba (Naisuanon) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Sibarani'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sarumpaet: Toba + Angkola + Mandailing
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Sarumpaet'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Mandailing', 0 FROM marga WHERE nama = 'Sarumpaet'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sipahutar: Toba (Borbor) + Angkola
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Angkola', 0 FROM marga WHERE nama = 'Sipahutar'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Marga yang ada di Toba & Karo
-- Manik: Toba (Silau Raja) + Karo (Ginting Manik, Karo-Karo Manik) + Simalungun (Damanik)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Karo', 0 FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Pakpak', 0 FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sagala: Toba (Sagala Raja) + Pakpak
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Pakpak', 0 FROM marga WHERE nama = 'Sagala'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Purba: Toba (Naisuanon) + Karo (Karo-Karo Purba) + Simalungun (marga induk)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Karo', 0 FROM marga WHERE nama = 'Purba'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Purba'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Sinaga: Toba (Lontung) + Simalungun (marga induk)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Sinaga'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Saragih: Toba (Naiambaton) + Simalungun (marga induk)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Saragih'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Munte: Toba (Naiambaton) + Karo (Ginting Munte) + Pakpak (Munthe) + Simalungun (Dalimunthe)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Karo', 0 FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Pakpak', 0 FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE is_native = is_native;
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Limbong: Toba (Limbong Mulana) + Pakpak (Lembeng)
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Pakpak', 0 FROM marga WHERE nama = 'Limbong'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- Ambarita: Toba (Silau Raja) + Simalungun
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native) 
SELECT id, 'Simalungun', 0 FROM marga WHERE nama = 'Ambarita'
ON DUPLICATE KEY UPDATE is_native = is_native;

-- ============================================
-- 4. TAMBAH MARGA KARO YANG KURANG
-- ============================================

-- 5 marga induk Karo sudah ada (Ginting, Karo-karo, Peranginangin, Sembiring, Tarigan)
-- Tambah sub-marga Karo yang penting

INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Gurusinga', 'Karo', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Gurusinga');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Kaban', 'Karo', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Kaban');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Ketaren', 'Karo', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Ketaren');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sinulingga', 'Karo', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sinulingga');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Bukit', 'Karo', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Bukit');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Guru Tatea Bulan', 'Toba', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Guru Tatea Bulan');

-- Set marga_induk_id untuk sub-marga Karo
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Ginting') x) WHERE nama IN ('Capah', 'Munte') AND sub_suku = 'Karo';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Karo-karo') x) WHERE nama IN ('Barus', 'Bukit', 'Gurusinga', 'Sinuraya', 'Sitepu', 'Surbakti', 'Tarigan') AND sub_suku = 'Karo';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Peranginangin') x) WHERE nama = 'Bangun' AND sub_suku = 'Karo';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Sembiring') x) WHERE nama = 'Sebastian' AND sub_suku = 'Karo';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Tarigan') x) WHERE nama IN ('Kembaren', 'Tekan') AND sub_suku = 'Karo';

-- Insert marga_sub_suku untuk marga Karo baru
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native)
SELECT id, 'Karo', 1 FROM marga WHERE sub_suku = 'Karo' AND id NOT IN (SELECT marga_id FROM marga_sub_suku WHERE sub_suku = 'Karo')
ON DUPLICATE KEY UPDATE is_native = 1;

-- ============================================
-- 5. TAMBAH MARGA SIMALUNGUN YANG KURANG
-- ============================================

INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Damanik', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Damanik');

-- Sub-marga Damanik
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sarasan', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sarasan');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Simaringga', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simaringga');

-- Sub-marga Saragih
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sumbayak', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sumbayak');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sidauruk', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sidauruk');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sitio', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sitio');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Turnip', 'Simalungun', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Turnip');

-- Set marga_induk_id untuk sub-marga Simalungun
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Damanik') x) WHERE nama IN ('Sarasan', 'Simaringga') AND sub_suku = 'Simalungun';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Saragih') x) WHERE nama IN ('Sumbayak', 'Sidauruk', 'Sitio', 'Turnip', 'Simarmata') AND sub_suku = 'Simalungun';
UPDATE marga SET marga_induk_id = (SELECT id FROM (SELECT id FROM marga WHERE nama = 'Purba') x) WHERE sub_suku = 'Simalungun' AND nama NOT IN ('Damanik', 'Saragih', 'Purba', 'Sinaga');

-- Insert marga_sub_suku untuk marga Simalungun baru
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native)
SELECT id, 'Simalungun', 1 FROM marga WHERE sub_suku = 'Simalungun' AND id NOT IN (SELECT marga_id FROM marga_sub_suku WHERE sub_suku = 'Simalungun')
ON DUPLICATE KEY UPDATE is_native = 1;

-- ============================================
-- 6. TAMBAH MARGA PAKPAK/DAIRI YANG KURANG
-- ============================================

INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Banurea', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Banurea');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Berasa', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Berasa');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Bintang', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Bintang');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Boangmanalu', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Boangmanalu');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Gajah', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Gajah');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Kombih', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Kombih');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Maharaja', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Maharaja');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Pinayungan', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Pinayungan');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Saing', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Saing');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Saraan', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Saraan');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Sigalingging', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sigalingging');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Tendang', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Tendang');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Tinambunen', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Tinambunen');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Turuten', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Turuten');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Ujung', 'Pakpak', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Ujung');

-- Insert marga_sub_suku untuk marga Pakpak baru
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native)
SELECT id, 'Pakpak', 1 FROM marga WHERE sub_suku = 'Pakpak' AND id NOT IN (SELECT marga_id FROM marga_sub_suku WHERE sub_suku = 'Pakpak')
ON DUPLICATE KEY UPDATE is_native = 1;

-- ============================================
-- 7. TAMBAH MARGA MANDAILING & ANGKOLA YANG KURANG
-- ============================================

INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Dasopang', 'Angkola', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Dasopang');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Dalimunthe', 'Angkola', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Dalimunthe');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Pane', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Pane');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Ritonga', 'Angkola', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Ritonga');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Rambe', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Rambe');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Pospos', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Pospos');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Dolok', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Dolok');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Lintang', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Lintang');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Lancat', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Lancat');
INSERT INTO marga (nama, sub_suku, kelompok_marga) 
SELECT 'Pisang', 'Mandailing', NULL WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Pisang');

-- Insert marga_sub_suku untuk marga Mandailing/Angkola baru
INSERT INTO marga_sub_suku (marga_id, sub_suku, is_native)
SELECT id, sub_suku, 1 FROM marga WHERE sub_suku IN ('Mandailing', 'Angkola') AND id NOT IN (SELECT marga_id FROM marga_sub_suku WHERE sub_suku = marga.sub_suku)
ON DUPLICATE KEY UPDATE is_native = 1;

-- ============================================
-- 8. ISI TABEL MARGA_ALIAS
-- ============================================

-- Naibaho = Bako (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Bako', 'Pakpak', 'Naibaho di Pakpak disebut Bako' FROM marga WHERE nama = 'Naibaho'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sihotang = Siketang (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Siketang', 'Pakpak', 'Sihotang di Pakpak disebut Siketang' FROM marga WHERE nama = 'Sihotang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sihaloho = Kaloko (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Kaloko', 'Pakpak', 'Sihaloho di Pakpak disebut Kaloko' FROM marga WHERE nama = 'Sihaloho'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Limbong = Lembeng (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Lembeng', 'Pakpak', 'Limbong di Pakpak disebut Lembeng' FROM marga WHERE nama = 'Limbong'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Naibaho = Baho (Karo)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Baho', 'Karo', 'Naibaho di Karo disebut Baho' FROM marga WHERE nama = 'Naibaho'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Munte = Munthe (Pakpak) = Dalimunthe (Simalungun/Angkola/Mandailing) = Ginting Munte (Karo)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Munthe', 'Pakpak', 'Munte di Pakpak disebut Munthe' FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Dalimunthe', 'Simalungun', 'Munte di Simalungun disebut Dalimunthe/Dalimunta' FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Dalimunthe', 'Angkola', 'Munte di Angkola disebut Dalimunthe' FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Dalimunthe', 'Mandailing', 'Munte di Mandailing disebut Dalimunthe' FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Ginting Munte', 'Karo', 'Munte di Karo menjadi sub-marga Ginting Munte' FROM marga WHERE nama = 'Munte'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Manik = Damanik (Simalungun) = Ginting Manik (Karo) = Manik Kecupak (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Damanik', 'Simalungun', 'Manik di Simalungun menjadi marga induk Damanik' FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Ginting Manik', 'Karo', 'Manik di Karo menjadi sub-marga Ginting Manik' FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Manik Kecupak', 'Pakpak', 'Manik di Pakpak disebut Manik Kecupak' FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Manik Pegagan', 'Pakpak', 'Manik di Pakpak (Pegagan) disebut Manik Pegagan' FROM marga WHERE nama = 'Manik'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Siregar = Dongoran (Angkola) = Ritonga (Angkola) = Siagian (Angkola, sub Siregar) = Sormin (Angkola, sub Siregar)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Dongoran', 'Angkola', 'Siregar di Angkola disebut Dongoran' FROM marga WHERE nama = 'Siregar'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Ritonga', 'Angkola', 'Sub-marga Siregar di Angkola' FROM marga WHERE nama = 'Siregar'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Sormin', 'Angkola', 'Sub-marga Siregar di Angkola' FROM marga WHERE nama = 'Siregar'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Simamora = Debataraja (Angkola/Mandailing) = Rambe (Mandailing)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Debataraja', 'Mandailing', 'Simamora di Mandailing disebut Debataraja' FROM marga WHERE nama = 'Simamora'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Rambe', 'Mandailing', 'Simamora di Mandailing disebut Rambe' FROM marga WHERE nama = 'Simamora'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Tinambunan = Tinambunen (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Tinambunen', 'Pakpak', 'Tinambunan di Pakpak disebut Tinambunen' FROM marga WHERE nama = 'Tinambunan'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Tumanggor = Tumangger (Pakpak) = Ginting Tumangger (Karo)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Tumangger', 'Pakpak', 'Tumanggor di Pakpak disebut Tumangger' FROM marga WHERE nama = 'Tumanggor'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Ginting Tumangger', 'Karo', 'Tumanggor di Karo menjadi sub-marga Ginting Tumangger' FROM marga WHERE nama = 'Tumanggor'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Siboro = Cibro (Pakpak)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Cibro', 'Pakpak', 'Siboro di Pakpak disebut Cibro' FROM marga WHERE nama = 'Siboro'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Naipospos = Pospos (Mandailing)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Pospos', 'Mandailing', 'Naipospos di Mandailing disebut Pospos' FROM marga WHERE nama = 'Naipospos'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sihotang = Simarsoit (sub-marga di Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Simarsoit', 'Toba', 'Sub-marga Sihotang' FROM marga WHERE nama = 'Sihotang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Tambunan = Baruara (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Baruara', 'Toba', 'Sub-marga Tambunan' FROM marga WHERE nama = 'Tambunan'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Nainggolan = Batuara (Toba) = Buaton (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Batuara', 'Toba', 'Sub-marga Nainggolan' FROM marga WHERE nama = 'Nainggolan'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Buaton', 'Toba', 'Sub-marga Nainggolan' FROM marga WHERE nama = 'Nainggolan'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Simatupang = Togatorop (Toba) = Sianturi (Toba) = Siburian (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Togatorop', 'Toba', 'Sub-marga Simatupang' FROM marga WHERE nama = 'Simatupang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Sianturi', 'Toba', 'Sub-marga Simatupang' FROM marga WHERE nama = 'Simatupang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sitorus = Pane (Toba/Mandailing)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Pane', 'Mandailing', 'Sitorus di Mandailing disebut Pane' FROM marga WHERE nama = 'Sitorus'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Tampubolon = Baringbing (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Baringbing', 'Toba', 'Sub-marga Tampubolon' FROM marga WHERE nama = 'Tampubolon'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Simanjuntak = Napitupulu (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Napitupulu', 'Toba', 'Sub-marga Simanjuntak' FROM marga WHERE nama = 'Simanjuntak'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Aritonang = Ompusunggu (Toba) = Rajagukguk (Toba) = Simaremare (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Ompusunggu', 'Toba', 'Sub-marga Aritonang' FROM marga WHERE nama = 'Aritonang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Samosir = Gultom (Toba) = Pakpahan (Toba) = Sidari (Toba) = Harianja (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Gultom', 'Toba', 'Sub-marga Samosir (Situmorang)' FROM marga WHERE nama = 'Gultom'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Situmorang = Siringoringo (Toba) = Lumban Pande (Toba) = Lumban Nahor (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Siringoringo', 'Toba', 'Sub-marga Situmorang' FROM marga WHERE nama = 'Situmorang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Lumban Pande', 'Toba', 'Sub-marga Situmorang' FROM marga WHERE nama = 'Situmorang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Lumban Nahor', 'Toba', 'Sub-marga Situmorang' FROM marga WHERE nama = 'Situmorang'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sinaga = Simandalahi (Toba) = Simanjorang (Toba) = Barutu (Toba)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Simandalahi', 'Toba', 'Sub-marga Sinaga' FROM marga WHERE nama = 'Sinaga'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Simanjorang', 'Toba', 'Sub-marga Sinaga' FROM marga WHERE nama = 'Sinaga'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Pandiangan = Pakpahan (Toba) = Samosir (Toba, sub Situmorang)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Pakpahan', 'Toba', 'Sub-marga Pandiangan' FROM marga WHERE nama = 'Pandiangan'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);

-- Sembiring = Sembiring Meliala (Karo, terkait Naisuanon)
INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan)
SELECT id, 'Sembiring Meliala', 'Karo', 'Sembiring Meliala adalah sub-marga yang terkait dengan Naisuanon (Si Raja Huta Lima)' FROM marga WHERE nama = 'Sembiring'
ON DUPLICATE KEY UPDATE keterangan = VALUES(keterangan);
