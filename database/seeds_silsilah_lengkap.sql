-- Seed Data Silsilah Batak Lengkap
-- Dari penciptaan mitologis sampai marga modern

USE tarombo;

-- ================================
-- SILSILAH MITOLOGIS (Generasi Dewa)
-- ================================

-- Generasi 1: Dewa Utama
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Mulajadi Na Bolon', 1, NULL, 'L', 'Debata Maha Kuasa', 'Dewa tertinggi dalam kepercayaan Batak, pencipta segala sesuatu', 'ya'),
('Batara Guru', 2, 1, 'L', 'Dewa Guru', 'Dewa pengajar dan pemimpin di langit', 'ya'),
('Mangala Bulan', 2, 1, 'L', 'Raja Odap-odap', 'Raja dari kerajaan Odap-odap', 'ya');

-- Generasi 2: Si Boru Deak Parujar
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Si Boru Deak Parujar', 3, 2, 'P', 'Putri Dewi', 'Anak perempuan Batara Guru yang ditolak menikah dengan Raja Odap-odap', 'ya');

-- Generasi 3: Anak Si Boru Deak Parujar & Raja Odap-odap
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Raja Ihat Manisia', 4, 4, 'L', 'Anak Pertama', 'Anak pertama Si Boru Deak Parujar dan Raja Odap-odap', 'ya'),
('Boru Ihat Manisia', 4, 4, 'P', 'Anak Kedua', 'Anak kedua Si Boru Deak Parujar dan Raja Odap-odap', 'ya');

-- ================================
-- SILSILAH DARI GURU TATEA BULAN
-- ================================

-- Guru Tatea Bulan (Generasi penting dalam silsilah)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Guru Tatea Bulan', 5, NULL, 'L', 'Leluhur Utama', 'Tokoh penting dalam silsilah Batak, penghubung antara dunia dewa dan manusia', 'ya');

-- Raja Isumbaon (Anak Guru Tatea Bulan)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Raja Isumbaon', 6, 6, 'L', 'Raja Batak Pertama', 'Raja pertama yang dianggap sebagai leluhur langsung orang Batak', 'ya');

-- Tuan Sariburaja (Anak Raja Isumbaon)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Tuan Sariburaja', 7, 7, 'L', 'Raja Kedua', 'Anak Raja Isumbaon, memiliki banyak keturunan', 'ya');

-- ================================
-- ANAK-ANAK TUAN SARIBURAJA
-- ================================

-- Dari istri pertama: Si Boru Pareme
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Si Raja Lontung', 8, 8, 'L', 'Induk Kelompok Lontung', 'Anak pertama Tuan Sariburaja dari Si Boru Pareme, induk kelompok Lontung', 'ya'),
('Limbong Mulana', 8, 8, 'L', 'Induk Kelompok Borbor', 'Anak kedua Tuan Sariburaja dari Si Boru Pareme', 'ya'),
('Sagala Raja', 8, 8, 'L', 'Induk Kelompok Borbor', 'Anak ketiga Tuan Sariburaja dari Si Boru Pareme', 'ya'),
('Silau Raja', 8, 8, 'L', 'Induk Kelompok Borbor', 'Anak keempat Tuan Sariburaja dari Si Boru Pareme', 'ya'),
('Si Raja Borbor', 8, 8, 'L', 'Induk Kelompok Borbor', 'Anak kelima Tuan Sariburaja dari Si Boru Pareme', 'ya');

-- Dari istri kedua: Nai Mangiring Laut
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Tuan Sorimangaraja', 8, 8, 'L', 'Induk 3 Kelompok', 'Anak Tuan Sariburaja dari Nai Mangiring Laut', 'ya');

-- ================================
-- KETURUNAN TUAN SORIMANGARAJA
-- ================================

-- Dari istri pertama: Si Boru Anting Malela (Si Boru Paromas)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Tuan Sorbadijulu (Nai Ambaton)', 9, 14, 'L', 'Induk Kelompok Naiambaton', 'Anak pertama Tuan Sorimangaraja dari Si Boru Paromas', 'ya');

-- Dari istri kedua: Si Boru Anting Haomasan
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Tuan Sorbadijae (Nai Rasaon)', 9, 14, 'L', 'Induk Kelompok Nairasaon', 'Anak kedua Tuan Sorimangaraja dari Si Boru Anting Haomasan', 'ya');

-- Dari istri ketiga: Siboru Sinta/Sanggul Haomasan
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Tuan Sorbadibanua (Nai Suanon)', 9, 14, 'L', 'Induk Kelompok Naisuanon', 'Anak ketiga Tuan Sorimangaraja dari Siboru Sinta', 'ya');

-- ================================
-- KETURUNAN SI RAJA LONTUNG (Kelompok Lontung)
-- ================================

INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi) VALUES
('Raja Sibagotni Pohan', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak pertama Si Raja Lontung', 'ya'),
('Raja Sipaettua', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak kedua Si Raja Lontung', 'ya'),
('Raja Silahisabungan', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak ketiga Si Raja Lontung', 'ya'),
('Raja Oloan', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak keempat Si Raja Lontung', 'ya'),
('Raja Hutalima', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak kelima Si Raja Lontung', 'ya'),
('Raja Sumba', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak keenam Si Raja Lontung', 'ya'),
('Raja Sobu', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak ketujuh Si Raja Lontung', 'ya'),
('Raja Naipospos', 9, 9, 'L', 'Anak Si Raja Lontung', 'Anak kedelapan Si Raja Lontung', 'ya');

-- ================================
-- UPDATE MARGA DENGAN KELOMPOK DAN ASAL-USUL
-- ================================

-- Update marga Toba (Kelompok Lontung)
UPDATE marga SET 
    kelompok_marga = 'Lontung',
    asal_usul_legenda = 'Keturunan Si Raja Lontung, anak Tuan Sariburaja dari Si Boru Pareme',
    keturunan_siraja = 'Si Raja Lontung'
WHERE nama IN ('Simanjuntak', 'Marbun', 'Sihotang', 'Nainggolan', 'Siregar', 'Sinaga', 'Pardede', 'Gultom', 'Lumbantobing', 'Situmorang');

-- Update marga Karo (Campuran dari berbagai kelompok)
UPDATE marga SET 
    kelompok_marga = 'Campuran',
    asal_usul_legenda = 'Keturunan dari berbagai kelompok Si Raja Batak yang tersebar di Tanah Karo',
    keturunan_siraja = 'Berbagai keturunan Si Raja Batak'
WHERE sub_suku = 'Karo';

-- Update marga Simalungun (Kelompok Borbor)
UPDATE marga SET 
    kelompok_marga = 'Borbor',
    asal_usul_legenda = 'Keturunan Limbong Mulana, Sagala Raja, Silau Raja, dan Si Raja Borbor',
    keturunan_siraja = 'Limbong Mulana/Sagala Raja/Silau Raja/Si Raja Borbor'
WHERE sub_suku = 'Simalungun';

-- Update marga Mandailing (Campuran Naiambaton/Nairasaon)
UPDATE marga SET 
    kelompok_marga = 'Campuran',
    asal_usul_legenda = 'Keturunan Tuan Sorbadijulu (Nai Ambaton) dan Tuan Sorbadijae (Nai Rasaon)',
    keturunan_siraja = 'Tuan Sorbadijulu/Tuan Sorbadijae'
WHERE sub_suku = 'Mandailing';

-- Update marga Angkola (Kelompok Naisuanon)
UPDATE marga SET 
    kelompok_marga = 'Naisuanon',
    asal_usul_legenda = 'Keturunan Tuan Sorbadibanua (Nai Suanon)',
    keturunan_siraja = 'Tuan Sorbadibanua'
WHERE sub_suku = 'Angkola';

-- Update marga Pakpak (Kelompok Naiambaton)
UPDATE marga SET 
    kelompok_marga = 'Naiambaton',
    asal_usul_legenda = 'Keturunan Tuan Sorbadijulu (Nai Ambaton)',
    keturunan_siraja = 'Tuan Sorbadijulu'
WHERE sub_suku = 'Pakpak';

-- ================================
-- TAMBAH MARGA YANG LENGKAP
-- ================================

-- Marga-marga dari kelompok Lontung yang belum ada
INSERT IGNORE INTO marga (nama, sub_suku, deskripsi, kelompok_marga, asal_usul_legenda, keturunan_siraja) VALUES
-- Dari Raja Sibagotni Pohan
('Pohan', 'Toba', 'Keturunan Raja Sibagotni Pohan', 'Lontung', 'Keturunan Raja Sibagotni Pohan, anak Si Raja Lontung', 'Raja Sibagotni Pohan'),
('Simatupang', 'Toba', 'Keturunan Raja Sibagotni Pohan', 'Lontung', 'Keturunan Raja Sibagotni Pohan, anak Si Raja Lontung', 'Raja Sibagotni Pohan'),
('Sitorus', 'Toba', 'Keturunan Raja Sibagotni Pohan', 'Lontung', 'Keturunan Raja Sibagotni Pohan, anak Si Raja Lontung', 'Raja Sibagotni Pohan'),
('Panggabean', 'Toba', 'Keturunan Raja Sibagotni Pohan', 'Lontung', 'Keturunan Raja Sibagotni Pohan, anak Si Raja Lontung', 'Raja Sibagotni Pohan'),

-- Dari Raja Sipaettua
('Sipayung', 'Toba', 'Keturunan Raja Sipaettua', 'Lontung', 'Keturunan Raja Sipaettua, anak Si Raja Lontung', 'Raja Sipaettua'),
('Rajagukguk', 'Toba', 'Keturunan Raja Sipaettua', 'Lontung', 'Keturunan Raja Sipaettua, anak Si Raja Lontung', 'Raja Sipaettua'),

-- Dari Raja Silahisabungan
('Silalahi', 'Toba', 'Keturunan Raja Silahisabungan', 'Lontung', 'Keturunan Raja Silahisabungan, anak Si Raja Lontung', 'Raja Silahisabungan'),
('Rajagukguk', 'Toba', 'Keturunan Raja Silahisabungan', 'Lontung', 'Keturunan Raja Silahisabungan, anak Si Raja Lontung', 'Raja Silahisabungan'),

-- Dari Raja Oloan
('Hutagalung', 'Toba', 'Keturunan Raja Oloan', 'Lontung', 'Keturunan Raja Oloan, anak Si Raja Lontung', 'Raja Oloan'),
('Hutapea', 'Toba', 'Keturunan Raja Oloan', 'Lontung', 'Keturunan Raja Oloan, anak Si Raja Lontung', 'Raja Oloan'),
('Hutauruk', 'Toba', 'Keturunan Raja Oloan', 'Lontung', 'Keturunan Raja Oloan, anak Si Raja Lontung', 'Raja Oloan'),

-- Dari Raja Hutalima
('Lumbangaol', 'Toba', 'Keturunan Raja Hutalima', 'Lontung', 'Keturunan Raja Hutalima, anak Si Raja Lontung', 'Raja Hutalima'),
('Nababan', 'Toba', 'Keturunan Raja Hutalima', 'Lontung', 'Keturunan Raja Hutalima, anak Si Raja Lontung', 'Raja Hutalima'),
('Harefa', 'Toba', 'Keturunan Raja Hutalima', 'Lontung', 'Keturunan Raja Hutalima, anak Si Raja Lontung', 'Raja Hutalima'),
('Sihombing', 'Toba', 'Keturunan Raja Hutalima', 'Lontung', 'Keturunan Raja Hutalima, anak Si Raja Lontung', 'Raja Hutalima'),
('Lubis', 'Toba', 'Keturunan Raja Hutalima', 'Lontung', 'Keturunan Raja Hutalima, anak Si Raja Lontung', 'Raja Hutalima'),

-- Dari Raja Sumba
('Pandiangan', 'Toba', 'Keturunan Raja Sumba', 'Lontung', 'Keturunan Raja Sumba, anak Si Raja Lontung', 'Raja Sumba'),
('Manurung', 'Toba', 'Keturunan Raja Sumba', 'Lontung', 'Keturunan Raja Sumba, anak Si Raja Lontung', 'Raja Sumba'),
('Marpaung', 'Toba', 'Keturunan Raja Sumba', 'Lontung', 'Keturunan Raja Sumba, anak Si Raja Lontung', 'Raja Sumba'),

-- Dari Raja Naipospos
('Naipospos', 'Toba', 'Keturunan Raja Naipospos', 'Lontung', 'Keturunan Raja Naipospos, anak Si Raja Lontung', 'Raja Naipospos'),

-- Marga dari kelompok Borbor
('Borbor', 'Toba', 'Keturunan Si Raja Borbor', 'Borbor', 'Keturunan Si Raja Borbor, anak Tuan Sariburaja', 'Si Raja Borbor'),

-- Marga dari kelompok Naiambaton (PARNA)
('Ginting', 'Karo', 'Keturunan Tuan Sorbadijulu (Nai Ambaton)', 'Naiambaton', 'Keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja', 'Tuan Sorbadijulu'),
('Tarigan', 'Karo', 'Keturunan Tuan Sorbadijulu (Nai Ambaton)', 'Naiambaton', 'Keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja', 'Tuan Sorbadijulu'),
('Karo-karo', 'Karo', 'Keturunan Tuan Sorbadijulu (Nai Ambaton)', 'Naiambaton', 'Keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja', 'Tuan Sorbadijulu'),
('Sitepu', 'Karo', 'Keturunan Tuan Sorbadijulu (Nai Ambaton)', 'Naiambaton', 'Keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja', 'Tuan Sorbadijulu'),
('Sembiring', 'Karo', 'Keturunan Tuan Sorbadijulu (Nai Ambaton)', 'Naiambaton', 'Keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja', 'Tuan Sorbadijulu'),

-- Marga dari kelompok Nairasaon
('Munte', 'Karo', 'Keturunan Tuan Sorbadijae (Nai Rasaon)', 'Nairasaon', 'Keturunan Tuan Sorbadijae, anak Tuan Sorimangaraja', 'Tuan Sorbadijae'),
('Kembaren', 'Karo', 'Keturunan Tuan Sorbadijae (Nai Rasaon)', 'Nairasaon', 'Keturunan Tuan Sorbadijae, anak Tuan Sorimangaraja', 'Tuan Sorbadijae'),

-- Marga dari kelompok Naisuanon
('Pulungan', 'Angkola', 'Keturunan Tuan Sorbadibanua (Nai Suanon)', 'Naisuanon', 'Keturunan Tuan Sorbadibanua, anak Tuan Sorimangaraja', 'Tuan Sorbadibanua'),
('Rangkuti', 'Angkola', 'Keturunan Tuan Sorbadibanua (Nai Suanon)', 'Naisuanon', 'Keturunan Tuan Sorbadibanua, anak Tuan Sorimangaraja', 'Tuan Sorbadibanua');

-- ================================
-- HUBUNGAN KEKERABATAN MARGA
-- ================================

-- Contoh hubungan pariban (sepupu)
INSERT IGNORE INTO hubungan_marga (marga1_id, marga2_id, jenis_hubungan, deskripsi) VALUES
((SELECT id FROM marga WHERE nama = 'Simanjuntak'), (SELECT id FROM marga WHERE nama = 'Marbun'), 'pariban', 'Simanjuntak dan Marbun adalah pariban'),
((SELECT id FROM marga WHERE nama = 'Siregar'), (SELECT id FROM marga WHERE nama = 'Sinaga'), 'pariban', 'Siregar dan Sinaga adalah pariban');

-- Contoh hubungan tulang (paman dari pihak ibu)
INSERT IGNORE INTO hubungan_marga (marga1_id, marga2_id, jenis_hubungan, deskripsi) VALUES
((SELECT id FROM marga WHERE nama = 'Hutagalung'), (SELECT id FROM marga WHERE nama = 'Lumbantobing'), 'tulang', 'Hutagalung adalah tulang bagi Lumbantobing');

-- Contoh hubungan bere (keponakan laki-laki)
INSERT IGNORE INTO hubungan_marga (marga1_id, marga2_id, jenis_hubungan, deskripsi) VALUES
((SELECT id FROM marga WHERE nama = 'Lumbantobing'), (SELECT id FROM marga WHERE nama = 'Hutagalung'), 'bere', 'Lumbantobing adalah bere bagi Hutagalung');
