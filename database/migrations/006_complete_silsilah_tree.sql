-- Migration 006: Lengkapi pohon silsilah dari Mulajadi Na Bolon sampai asal mula semua marga
-- Sumber: budaya-indonesia.org, Wikipedia, buku W. Hutagalung (1926), detik.com
-- Pendekatan: tree dulu (pernikahan + anak), marga muncul dari keturunan, lalu klasifikasi by wilayah

-- ============================================
-- STRUKTUR: Tambah kolom wilayah & marga_dari_node
-- ============================================
ALTER TABLE silsilah_mitolologis ADD COLUMN wilayah VARCHAR(100) NULL COMMENT 'Wilayah/geografi keturunan';
ALTER TABLE silsilah_mitolologis ADD COLUMN marga_turunan VARCHAR(100) NULL COMMENT 'Marga yang berasal dari tokoh ini';
ALTER TABLE silsilah_mitolologis ADD COLUMN info_perkawinan TEXT NULL COMMENT 'Detail perkawinan';

-- ============================================
-- 1. UPDATE NODE YANG SUDAH ADA: tambah pasangan & info
-- ============================================

-- Gen 5: Si Raja Batak
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Nai Mula Uji (putri Mulajadi Na Bolon)', info_perkawinan = 'Pernikahan suci pertama' WHERE id = 8;

-- Gen 6: Guru Tatea Bulan
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Soping Sopang', info_perkawinan = 'Golongan Tatea Bulan (Bulan/Perempuan/Hula-hula)' WHERE id = 9;

-- Gen 6: Raja Isumbaon
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Sabungan (putri Guru Tatea Bulan)', info_perkawinan = 'Golongan Isombaon (Matahari/Laki-laki)' WHERE id = 10;

-- Gen 7: Tuan Sariburaja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Pareme (istri 1, adik kandung) & Nai Margiring Laut (istri 2)', info_perkawinan = 'Istri 1: Si Boru Pareme (kembar marporhas) → Si Raja Lontung. Istri 2: Nai Margiring Laut → Si Raja Borbor. Juga dari harimau betina → Si Raja Babiat' WHERE id = 12;

-- Gen 7: Tuan Sorimangaraja
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Malela / Nai Rasaon (istri 1), Si Boru Biding Laut / Nai Ambaton (istri 2), Si Boru Sanggul Baomasan / Nai Suanon (istri 3)', info_perkawinan = '3 istri, masing-masing melahirkan kelompok marga besar' WHERE id = 16;

-- Gen 8: Si Raja Lontung
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anak Pardomuan', info_perkawinan = '7 putra + 2 putri = Lontung Si Sia Marina (9 satu ibu)', marga_turunan = 'Lontung', wilayah = 'Toba' WHERE id = 19;

-- Gen 8: Si Raja Borbor
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Mela', info_perkawinan = 'Keturunannya bermarga Borbor', marga_turunan = 'Borbor', wilayah = 'Toba/Angkola/Mandailing' WHERE id = 20;

-- Gen 8: Nai Ambaton
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Biding Laut / Nai Ambaton (putri Guru Tatea Bulan)', info_perkawinan = 'Istri berasal dari golongan Tatea Bulan', marga_turunan = 'Parna (Nai Ambaton)', wilayah = 'Toba' WHERE id = 42;

-- Gen 8: Nai Rasaon
UPDATE silsilah_mitolologis SET pasangan_nama = 'Si Boru Anting Malela / Nai Rasaon (putri Guru Tatea Bulan)', info_perkawinan = 'Istri berasal dari golongan Tatea Bulan', marga_turunan = 'Nai Rasaon', wilayah = 'Toba' WHERE id = 43;

-- Gen 8: Nai Suanon
UPDATE silsilah_mitolologis SET pasangan_nama = 'Putri Sariburaja (istri 1, dari Si Boru Pareme) & Boru Sibasopaet (istri 2, putri Mojopahit)', info_perkawinan = 'Istri 1: 5 putra. Istri 2: 3 putra. Konflik istri → istri 2 pindah ke Lobu Gala-gala', marga_turunan = 'Nai Suanon', wilayah = 'Toba' WHERE id = 44;

-- Gen 7: Silau Raja
UPDATE silsilah_mitolologis SET marga_turunan = 'Silau Raja', wilayah = 'Toba/Karo' WHERE id = 15;

-- Gen 7: Limbong Mulana
UPDATE silsilah_mitolologis SET marga_turunan = 'Limbong', wilayah = 'Toba' WHERE id = 13;

-- Gen 7: Sagala Raja
UPDATE silsilah_mitolologis SET marga_turunan = 'Sagala', wilayah = 'Toba/Pakpak' WHERE id = 14;

-- ============================================
-- 2. TAMBAH ANAK SILAU RAJA (Gen 8) - 4 putra
-- ============================================
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, marga_turunan, wilayah) VALUES
('Malau', 'L', 15, 8, 'Putra sulung Silau Raja', NULL, 'Malau', 'Toba'),
('Manik', 'L', 15, 8, 'Putra kedua Silau Raja', NULL, 'Manik/Ginting Manik/Damanik', 'Toba/Karo/Simalungun'),
('Ambarita', 'L', 15, 8, 'Putra ketiga Silau Raja', NULL, 'Ambarita', 'Toba/Simalungun'),
('Gurning', 'L', 15, 8, 'Putra keempat Silau Raja', NULL, 'Gurning', 'Toba');

-- ============================================
-- 3. TAMBAH ANAK LIMBONG MULANA (Gen 8-9)
-- ============================================
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, marga_turunan, wilayah) VALUES
('Palu Onggang', 'L', 13, 8, 'Putra sulung Limbong Mulana', NULL, 'Limbong', 'Toba'),
('Langgat Limbong', 'L', 13, 8, 'Putra kedua Limbong Mulana', NULL, 'Limbong', 'Toba');

-- Langgat Limbong → 3 putra (Gen 9)
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, marga_turunan, wilayah) VALUES
('Limbong (Tua)', 'L', NULL, 9, 'Putra sulung Langgat Limbong — tetap memakai marga induk', NULL, 'Limbong', 'Toba'),
('Sihole', 'L', NULL, 9, 'Putra kedua Langgat Limbong', NULL, 'Sihole', 'Toba'),
('Habeahan', 'L', NULL, 9, 'Putra ketiga Langgat Limbong', NULL, 'Habeahan', 'Toba');

-- Set orang_tuan_id untuk anak Langgat Limbong
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Langgat Limbong' AND orang_tuan_id = 13) x) WHERE nama IN ('Limbong (Tua)', 'Sihole', 'Habeahan') AND generasi_ke = 9;

-- ============================================
-- 4. TAMBAH PUTRI SI RAJA LONTUNG (Gen 9) - 2 putri
-- ============================================
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, info_perkawinan, marga_turunan, wilayah) VALUES
('Si Boru Anakpandan', 'P', 19, 9, 'Putri pertama Si Raja Lontung', 'Toga Sihombing', 'Menikah dengan Toga Sihombing (keturunan Si Raja Sumba). Anak: Silaban, Lumbantoruan, Nababan, Hutasoit', 'Sihombing (melalui anak)', 'Toba'),
('Si Boru Panggabean', 'P', 19, 9, 'Putri kedua Si Raja Lontung', 'Toga Simamora', 'Menikah dengan Toga Simamora (keturunan Si Raja Sumba)', 'Simamora (melalui anak)', 'Toba');

-- ============================================
-- 5. TAMBAH SI RAJA BABIAT (Gen 8) - dari Sariburaja & harimau betina
-- ============================================
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, info_perkawinan, marga_turunan, wilayah) VALUES
('Si Raja Babiat', 'L', 12, 8, 'Putra Tuan Sariburaja dari harimau betina', NULL, 'Lahir dari harimau betina di hutan Sabulan. Keturunannya di Mandailing', 'Bayoangin', 'Mandailing');

-- ============================================
-- 6. SI RAJA BORBOR → DATU TALADIBABANA → 6 PUTRA (Gen 10-11)
-- Borbor → [beberapa generasi] → Datu Taladibabana → 6 putra
-- ============================================
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Datu Taladibabana', 'L', 20, 10, 'Cucu beberapa generasi dari Si Raja Borbor', 'Borbor', 'Toba/Angkola/Mandailing');

-- 6 putra Datu Taladibabana (Gen 11)
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Datu Dalu (Sahangmaima)', 'L', NULL, 11, 'Putra sulung Datu Taladibabana', 'Borbor (induk)', 'Toba/Angkola'),
('Sipahutar', 'L', NULL, 11, 'Putra kedua Datu Taladibabana', 'Sipahutar', 'Toba'),
('Harahap', 'L', NULL, 11, 'Putra ketiga Datu Taladibabana', 'Harahap', 'Toba/Mandailing/Angkola'),
('Tanjung', 'L', NULL, 11, 'Putra keempat Datu Taladibabana', 'Tanjung', 'Toba/Mandailing/Angkola'),
('Datu Pulungan', 'L', NULL, 11, 'Putra kelima Datu Taladibabana', 'Borbor (induk)', 'Toba'),
('Simargolang', 'L', NULL, 11, 'Putra keenam Datu Taladibabana', 'Imargolang', 'Toba');

-- Set orang_tuan_id
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Datu Taladibabana') x) WHERE nama IN ('Datu Dalu (Sahangmaima)', 'Sipahutar', 'Harahap', 'Tanjung', 'Datu Pulungan', 'Simargolang') AND generasi_ke = 11;

-- Anak Datu Dalu (Gen 12) — marga cabang Borbor
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Pasaribu', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Pasaribu', 'Toba/Angkola'),
('Batubara', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Batubara', 'Toba/Angkola/Mandailing'),
('Habeahan (Borbor)', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Habeahan', 'Toba'),
('Bondar', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Bondar', 'Toba'),
('Gorat', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Gorat', 'Toba'),
('Tinendang', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Tinendang', 'Toba'),
('Tangkar', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Tangkar', 'Toba'),
('Matondang', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Matondang', 'Toba/Angkola'),
('Saruksuk', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Saruksuk', 'Toba'),
('Tarihoran', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Tarihoran', 'Toba/Angkola'),
('Parapat', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Parapat', 'Toba'),
('Rangkuti', 'L', NULL, 12, 'Keturunan Datu Dalu', 'Rangkuti', 'Mandailing');

-- Set orang_tuan_id untuk anak Datu Dalu
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Datu Dalu (Sahangmaima)') x) WHERE nama IN ('Pasaribu', 'Batubara', 'Habeahan (Borbor)', 'Bondar', 'Gorat', 'Tinendang', 'Tangkar', 'Matondang', 'Saruksuk', 'Tarihoran', 'Parapat', 'Rangkuti') AND generasi_ke = 12;

-- Anak Datu Pulungan (Gen 12)
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Lubis', 'L', NULL, 12, 'Keturunan Datu Pulungan', 'Lubis', 'Mandailing/Toba'),
('Hutasuhut', 'L', NULL, 12, 'Keturunan Datu Pulungan', 'Hutasuhut', 'Mandailing/Toba/Angkola');

UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Datu Pulungan') x) WHERE nama IN ('Lubis', 'Hutasuhut') AND generasi_ke = 12;

-- ============================================
-- 7. ANAK SI RAJA LONTUNG (Gen 9) → CUCU (Gen 10)
-- ============================================

-- 7a. Tuan Situmorang → 7 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sihotang Toruan', 'L', 21, 10, 'Putra sulung Tuan Situmorang', 'Sihotang Toruan', 'Toba'),
('Sihorang Tonga-tonga', 'L', 21, 10, 'Putra kedua Tuan Situmorang', 'Sihorang', 'Toba'),
('Sihotang Uruk', 'L', 21, 10, 'Putra ketiga Tuan Situmorang', 'Sihotang Uruk', 'Toba'),
('Raja Ringo (Siringoringo)', 'L', 21, 10, 'Putra keempat Tuan Situmorang', 'Siringoringo', 'Toba'),
('Tuan Suhut ni Huta', 'L', 21, 10, 'Putra kelima Tuan Situmorang', 'Suhutnihuta', 'Toba'),
('Raja Nahor (Lumban Nahor)', 'L', 21, 10, 'Putra keenam Tuan Situmorang', 'Lumban Nahor', 'Toba'),
('Raja Pande (Lumban Pande)', 'L', 21, 10, 'Putra ketujuh Tuan Situmorang', 'Lumban Pande', 'Toba');

-- 7b. Sinaga Raja → 3 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sagiulubalang (Uruk)', 'L', 22, 10, 'Putra sulung Sinaga Raja', 'Simandalahi/Simanjorang', 'Toba'),
('Raja Ratus', 'L', 22, 10, 'Putra kedua Sinaga Raja', 'Simaibang', 'Toba'),
('Raja Bonor', 'L', 22, 10, 'Putra ketiga Sinaga Raja', 'Sidahapintu', 'Toba');

-- 7c. Pandiangan → 6 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Samosir', 'L', 23, 10, 'Putra sulung Pandiangan', 'Samosir', 'Toba'),
('Pakpahan', 'L', 23, 10, 'Putra kedua Pandiangan', 'Pakpahan', 'Toba'),
('Gultom', 'L', 23, 10, 'Putra ketiga Pandiangan', 'Gultom', 'Toba'),
('Sidari', 'L', 23, 10, 'Putra keempat Pandiangan', 'Sidari', 'Toba'),
('Sitinjak', 'L', 23, 10, 'Putra kelima Pandiangan', 'Sitinjak', 'Toba'),
('Harianja', 'L', 23, 10, 'Putra keenam Pandiangan', 'Harianja', 'Toba');

-- 7d. Toga Nainggolan → 8 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Rumahombar (Parhusip)', 'L', 24, 10, 'Putra sulung Toga Nainggolan', 'Parhusip', 'Toba'),
('Lumban Tungkup', 'L', 24, 10, 'Putra kedua Toga Nainggolan', 'Lumban Tungkup', 'Toba'),
('Lumban Siantar', 'L', 24, 10, 'Putra ketiga Toga Nainggolan', 'Lumban Siantar', 'Toba'),
('Hutabalian', 'L', 24, 10, 'Putra keempat Toga Nainggolan', 'Hutabalian', 'Toba'),
('Lumban Raja', 'L', 24, 10, 'Putra kelima Toga Nainggolan', 'Lumban Raja', 'Toba'),
('Pusuk', 'L', 24, 10, 'Putra keenam Toga Nainggolan', 'Pusuk', 'Toba'),
('Buaton', 'L', 24, 10, 'Putra ketujuh Toga Nainggolan', 'Buaton', 'Toba'),
('Mahulae (Batuara)', 'L', 24, 10, 'Putra kedelapan Toga Nainggolan', 'Batuara/Mahulae', 'Toba');

-- 7e. Simatupang → 3 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Togatorop', 'L', 25, 10, 'Putra sulung Simatupang', 'Togatorop/Sitogatorop', 'Toba'),
('Sianturi', 'L', 25, 10, 'Putra kedua Simatupang', 'Sianturi', 'Toba'),
('Siburian', 'L', 25, 10, 'Putra ketiga Simatupang', 'Siburian', 'Toba');

-- 7f. Aritonang → 3 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Ompu Sunggu', 'L', 26, 10, 'Putra sulung Aritonang', 'Ompusunggu', 'Toba'),
('Rajagukguk', 'L', 26, 10, 'Putra kedua Aritonang', 'Rajagukguk', 'Toba'),
('Simaremare', 'L', 26, 10, 'Putra ketiga Aritonang', 'Simaremare', 'Toba');

-- 7g. Siregar → 5 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Silo (Dongoran)', 'L', 27, 10, 'Putra sulung Siregar', 'Silo/Dongoran', 'Toba/Angkola'),
('Silali', 'L', 27, 10, 'Putra kedua Siregar', 'Silali', 'Toba'),
('Siagian', 'L', 27, 10, 'Putra ketiga Siregar', 'Siagian', 'Toba'),
('Ritonga', 'L', 27, 10, 'Putra keempat Siregar', 'Ritonga', 'Toba/Angkola'),
('Sormin', 'L', 27, 10, 'Putra kelima Siregar', 'Sormin', 'Toba/Angkola');

-- ============================================
-- 8. NAI AMBATON (Gen 8) → 4 PUTRA (Gen 9) → CUCU (Gen 10)
-- ============================================

-- 8a. Simbolon Tua → 6 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Tinambunan', 'L', 28, 10, 'Putra sulung Simbolon Tua', 'Tinambunan', 'Toba/Pakpak'),
('Tumanggor', 'L', 28, 10, 'Putra kedua Simbolon Tua', 'Tumanggor', 'Toba/Pakpak/Karo'),
('Maharaja', 'L', 28, 10, 'Putra ketiga Simbolon Tua', 'Maharaja', 'Toba/Pakpak'),
('Turutan', 'L', 28, 10, 'Putra keempat Simbolon Tua', 'Turutan', 'Toba/Pakpak'),
('Nahampun', 'L', 28, 10, 'Putra kelima Simbolon Tua', 'Nahampun', 'Toba/Pakpak'),
('Pinayungan', 'L', 28, 10, 'Putra keenam Simbolon Tua', 'Pinayungan', 'Toba/Pakpak');

-- 8b. Tamba Tua → 9 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Siallagan', 'L', 29, 10, 'Putra sulung Tamba Tua', 'Siallagan', 'Toba'),
('Tomok', 'L', 29, 10, 'Putra kedua Tamba Tua', 'Tomok', 'Toba'),
('Sidabutar', 'L', 29, 10, 'Putra ketiga Tamba Tua', 'Sidabutar', 'Toba'),
('Sijabat', 'L', 29, 10, 'Putra keempat Tamba Tua', 'Sijabat', 'Toba'),
('Gusar', 'L', 29, 10, 'Putra kelima Tamba Tua', 'Gusar', 'Toba'),
('Siadari', 'L', 29, 10, 'Putra keenam Tamba Tua', 'Siadari', 'Toba'),
('Sidabolak', 'L', 29, 10, 'Putra ketujuh Tamba Tua', 'Sidabolak', 'Toba'),
('Rumahorbo', 'L', 29, 10, 'Putra kedelapan Tamba Tua', 'Rumahorbo', 'Toba'),
('Napitu', 'L', 29, 10, 'Putra kesembilan Tamba Tua', 'Napitu', 'Toba');

-- 8c. Saragi Tua → 5 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Simalango', 'L', 30, 10, 'Putra sulung Saragi Tua', 'Simalango', 'Toba/Simalungun'),
('Saing', 'L', 30, 10, 'Putra kedua Saragi Tua', 'Saing', 'Toba/Pakpak'),
('Simarmata', 'L', 30, 10, 'Putra ketiga Saragi Tua', 'Simarmata', 'Toba/Simalungun'),
('Nadeak', 'L', 30, 10, 'Putra keempat Saragi Tua', 'Nadeak', 'Toba'),
('Sidabungke', 'L', 30, 10, 'Putra kelima Saragi Tua', 'Sidabungke', 'Toba');

-- 8d. Munte Tua → 6 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sitanggang', 'L', 31, 10, 'Putra sulung Munte Tua', 'Sitanggang', 'Toba'),
('Manihuruk', 'L', 31, 10, 'Putra kedua Munte Tua', 'Manihuruk', 'Toba'),
('Sidauruk', 'L', 31, 10, 'Putra ketiga Munte Tua', 'Sidauruk', 'Toba/Simalungun'),
('Turnip', 'L', 31, 10, 'Putra keempat Munte Tua', 'Turnip', 'Toba/Simalungun'),
('Sitio', 'L', 31, 10, 'Putra kelima Munte Tua', 'Sitio', 'Toba/Simalungun'),
('Sigalingging', 'L', 31, 10, 'Putra keenam Munte Tua', 'Sigalingging', 'Toba/Pakpak');

-- ============================================
-- 9. NAI RASAON (Gen 8) → 2 PUTRA (Gen 9) → CUCU (Gen 10)
-- ============================================

-- 9a. Raja Mardopang → 3 putra
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sitorus', 'L', 32, 10, 'Putra sulung Raja Mardopang', 'Sitorus', 'Toba/Angkola'),
('Sirait', 'L', 32, 10, 'Putra kedua Raja Mardopang', 'Sirait', 'Toba'),
('Butarbutar', 'L', 32, 10, 'Putra ketiga Raja Mardopang', 'Butarbutar', 'Toba');

-- 9b. Raja Mangatur → Toga Manurung
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Toga Manurung', 'L', 33, 10, 'Putra Raja Mangatur', 'Manurung', 'Toba');

-- ============================================
-- 10. NAI SUANON (Gen 8) → 8 PUTRA (Gen 9) → CUCU (Gen 10-11)
-- ============================================

-- 10a. Si Bagot Ni Pohan → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Tampubolon', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Tampubolon', 'Toba'),
('Barimbing', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Barimbing', 'Toba'),
('Silaen', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Silaen', 'Toba'),
('Siahaan', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Siahaan', 'Toba'),
('Simanjuntak', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Simanjuntak', 'Toba'),
('Hutagaol', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Hutagaol', 'Toba'),
('Nasution', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Nasution', 'Toba/Mandailing'),
('Panjaitan', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Panjaitan', 'Toba'),
('Siagian (Naisuanon)', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Siagian', 'Toba'),
('Silitonga', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Silitonga', 'Toba'),
('Sianipar', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Sianipar', 'Toba'),
('Pardosi (Hutalima)', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Pardosi', 'Toba'),
('Simangunsong', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Simangunsong', 'Toba'),
('Marpaung', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Marpaung', 'Toba/Angkola'),
('Napitupulu', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Napitupulu', 'Toba'),
('Pardede', 'L', 34, 10, 'Keturunan Si Bagot Ni Pohan', 'Pardede', 'Toba');

-- 10b. Si Paet Tua → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Hutahaean', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Hutahaean', 'Toba'),
('Hutajulu', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Hutajulu', 'Toba'),
('Aruan', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Aruan', 'Toba'),
('Sibarani', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Sibarani', 'Toba/Angkola'),
('Sibuea', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Sibuea', 'Toba'),
('Sarumpaet', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Sarumpaet', 'Toba/Angkola/Mandailing'),
('Pangaribuan', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Pangaribuan', 'Toba'),
('Hutapea (Paet Tua)', 'L', 35, 10, 'Keturunan Si Paet Tua', 'Hutapea', 'Toba');

-- 10c. Si Lahi Sabungan → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sihaloho', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sihaloho', 'Toba/Pakpak'),
('Situngkir', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Situngkir', 'Toba'),
('Sipangkar', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sipangkar', 'Toba'),
('Sipayung', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sipayung', 'Toba'),
('Sirumasondi', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sirumasondi', 'Toba'),
('Sidabutar (Lahi Sabungan)', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sidabutar', 'Toba'),
('Sidabariba', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sidabariba', 'Toba'),
('Pintubatu', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Pintubatu', 'Toba'),
('Sigiro', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sigiro', 'Toba'),
('Tambun (Tambunan)', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Tambunan', 'Toba/Angkola'),
('Doloksaribu', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Doloksaribu', 'Toba'),
('Sinurat', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Sinurat', 'Toba'),
('Naiborhu', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Naiborhu', 'Toba'),
('Pagaraji', 'L', 36, 10, 'Keturunan Si Lahi Sabungan', 'Pagaraji', 'Toba');

-- 10d. Si Raja Oloan → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Naibaho', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Naibaho', 'Toba/Pakpak/Karo'),
('Sihotang', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Sihotang', 'Toba/Pakpak'),
('Hasugian', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Hasugian', 'Toba'),
('Lingga', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Lingga', 'Toba/Karo'),
('Sinambela', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Sinambela', 'Toba/Karo'),
('Sihite', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Sihite', 'Toba'),
('Simanullang', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Simanullang', 'Toba'),
('Bangkara', 'L', 37, 10, 'Keturunan Si Raja Oloan', 'Bangkara', 'Toba');

-- 10e. Si Raja Huta Lima → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Maha', 'L', 38, 10, 'Keturunan Si Raja Huta Lima', 'Maha', 'Toba/Pakpak'),
('Sambo', 'L', 38, 10, 'Keturunan Si Raja Huta Lima', 'Sambo', 'Toba/Pakpak'),
('Pardosi (Hutalima)', 'L', 38, 10, 'Keturunan Si Raja Huta Lima', 'Pardosi', 'Toba/Pakpak'),
('Sembiring Meliala', 'L', 38, 10, 'Keturunan Si Raja Huta Lima — pindah ke Karo', 'Sembiring Meliala', 'Karo');

-- 10f. Si Raja Sumba → marga cabang (BESAR)
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, info_perkawinan, marga_turunan, wilayah) VALUES
('Toga Simamora', 'L', 39, 10, 'Putra sulung Si Raja Sumba', 'Si Boru Panggabean (putri Si Raja Lontung)', 'Menikah dengan putri Si Raja Lontung', 'Simamora', 'Toba'),
('Toga Sihombing', 'L', 39, 10, 'Putra kedua Si Raja Sumba', 'Si Boru Anakpandan (putri Si Raja Lontung)', 'Menikah dengan putri Si Raja Lontung. 4 putra: Silaban, Lumbantoruan, Nababan, Hutasoit', 'Sihombing', 'Toba');

INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Rambe', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Rambe', 'Toba/Mandailing'),
('Purba (Sumba)', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Purba', 'Toba/Karo/Simalungun'),
('Manalu', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Manalu', 'Toba/Pakpak'),
('Debataraja', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Debataraja', 'Toba'),
('Girsang', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Girsang', 'Toba/Karo'),
('Tambak', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Tambak', 'Toba'),
('Siboro', 'L', 39, 10, 'Keturunan Si Raja Sumba', 'Siboro', 'Toba');

-- Anak Toga Sihombing (Gen 11) — 4 putra (Sihombing si Opat Ama)
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Borsak Jungjungan (Silaban)', 'L', NULL, 11, 'Putra sulung Toga Sihombing', 'Silaban', 'Toba'),
('Borsak Sirumonggur (Lumbantoruan)', 'L', NULL, 11, 'Putra kedua Toga Sihombing — yang paling banyak memakai marga Sihombing', 'Lumbantoruan/Sihombing', 'Toba'),
('Borsak Mangatasi (Nababan)', 'L', NULL, 11, 'Putra ketiga Toga Sihombing', 'Nababan/Sihombing', 'Toba'),
('Borsak Bimbinan (Hutasoit)', 'L', NULL, 11, 'Putra keempat Toga Sihombing', 'Hutasoit/Sihombing', 'Toba');

UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama = 'Toga Sihombing' AND orang_tuan_id = 39) x) WHERE nama IN ('Borsak Jungjungan (Silaban)', 'Borsak Sirumonggur (Lumbantoruan)', 'Borsak Mangatasi (Nababan)', 'Borsak Bimbinan (Hutasoit)') AND generasi_ke = 11;

-- 10g. Si Raja Sobu → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Sitompul', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Sitompul', 'Toba'),
('Hasibuan', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Hasibuan', 'Toba/Mandailing/Angkola'),
('Hutabarat', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Hutabarat', 'Toba'),
('Panggabean', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Panggabean', 'Toba/Mandailing/Angkola'),
('Hutagalung', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Hutagalung', 'Toba'),
('Hutatoruan', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Hutatoruan', 'Toba'),
('Simorangkir', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Simorangkir', 'Toba'),
('Hutapea (Sobu)', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Hutapea', 'Toba'),
('Lumban Tobing', 'L', 40, 10, 'Keturunan Si Raja Sobu', 'Lumbantobing', 'Toba');

-- 10h. Toga Naipospos → marga cabang
INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, marga_turunan, wilayah) VALUES
('Marbun', 'L', 41, 10, 'Putra sulung Toga Naipospos', 'Marbun', 'Toba'),
('Lumban Batu (Naipospos)', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Lumbanbatu', 'Toba'),
('Banjarnahor', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Banjarnahor', 'Toba'),
('Lumban Gaol', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Lumbangaol', 'Toba'),
('Sibagariang', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Sibagariang', 'Toba'),
('Hutauruk', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Hutauruk', 'Toba'),
('Simanungkalit', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Simanungkalit', 'Toba'),
('Situmeang', 'L', 41, 10, 'Keturunan Toga Naipospos', 'Situmeang', 'Toba');

-- ============================================
-- 11. UPDATE MARGA TABLE: link marga ke node silsilah
-- ============================================
-- Tambah kolom silsilah_node_id di tabel marga
ALTER TABLE marga ADD COLUMN silsilah_node_id INT NULL COMMENT 'Link ke node silsilah_mitolologis yang menjadi asal marga ini';
ALTER TABLE marga ADD FOREIGN KEY (silsilah_node_id) REFERENCES silsilah_mitolologis(id) ON DELETE SET NULL;

-- Update marga yang punya node silsilah
UPDATE marga m JOIN silsilah_mitolologis s ON m.nama = s.marga_turunan SET m.silsilah_node_id = s.id WHERE s.marga_turunan IS NOT NULL;

-- Update marga berdasarkan nama yang cocok
UPDATE marga m JOIN silsilah_mitolologis s ON m.nama = s.nama SET m.silsilah_node_id = s.id WHERE s.generasi_ke >= 9;

-- ============================================
-- 12. UPDATE WILAYAH MARGA BERDASARKAN NODE SILSILAH
-- ============================================
UPDATE marga m JOIN silsilah_mitolologis s ON m.silsilah_node_id = s.id SET m.sub_suku = s.wilayah WHERE s.wilayah IS NOT NULL AND m.sub_suku IS NULL;
