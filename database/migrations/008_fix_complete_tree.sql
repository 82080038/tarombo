-- Migration 008: Fix complete tree structure based on verified sources
-- Sources:
-- 1. W.M. Hutagalung, "PUSTAHA BATAK: Tarombo dohot Turiturian ni Bangso Batak" (1926)
-- 2. BPODT - https://bpodt.kemenpar.go.id/jejak-batak-siraja-batak/
-- 3. Budaya-Indonesia.org - https://budaya-indonesia.org/TAROMBO-Silsilah-Keluarga-dalam-adat-Batak
-- 4. BatakPedia - https://batakpedia.org/mengenal-asal-usul-raja-batak/
-- 5. TobaTobo - https://www.tobatabo.com/news/batak/118
-- 6. Wikipedia - https://id.wikipedia.org/wiki/Siraja_Batak

USE tarombo;

-- Step 1: Clear and re-insert correct data
DELETE FROM silsilah_mitolologis;

-- Reset auto increment
ALTER TABLE silsilah_mitolologis AUTO_INCREMENT = 1;

-- Gen 1: Dewa Tertinggi
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Mulajadi Na Bolon', 1, NULL, 'L', 'Debata Maha Kuasa', 'Dewa tertinggi pencipta alam semesta dalam kosmologi Batak. Tinggal di Banua Ginjang (dunia atas).', 'ya', '—', 'Dewa tertinggi, tidak ada pasangan');

-- Gen 2: Anak-anak Mulajadi Na Bolon (Debata Natolu)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Batara Guru', 2, 1, 'L', 'Dewa Guru (Sang Mula Tua)', 'Dewa pertama ciptaan Mulajadi Na Bolon. Ayah Si Boru Deak Parujar.', 'ya', 'Saniang Naga', 'Menikah dengan Saniang Naga'),
('Soripada', 2, 1, 'L', 'Dewa Kedua', 'Dewa kedua ciptaan Mulajadi Na Bolon (Debata Natolu).', 'ya', '—', ''),
('Mangala Bulan', 2, 1, 'L', 'Dewa Ketiga / Raja Odap-odap', 'Dewa ketiga ciptaan Mulajadi Na Bolon. Juga disebut Raja Odap-odap. Menikahi Si Boru Deak Parujar.', 'ya', 'Si Boru Deak Parujar', 'Menikahi Si Boru Deak Parujar (putri Batara Guru) setelah ia turun ke Banua Tonga');

-- Gen 3: Si Boru Deak Parujar (putri Batara Guru)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Si Boru Deak Parujar', 3, 2, 'P', 'Putri Dewi pencipta bumi', 'Putri Batara Guru yang turun ke Banua Tonga (bumi). Menikah dengan Raja Odap-odap (Mangala Bulan). Mereka menjadi cikal bakal manusia Batak.', 'ya', 'Mangala Bulan (Raja Odap-odap)', 'Awalnya menolak, tapi akhirnya menikah di bumi. Melahirkan Raja Ihat Manisia & Boru Ihat Manisia');

-- Gen 4: Anak-anak Si Boru Deak Parujar & Raja Odap-odap
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Raja Ihat Manisia', 4, 4, 'L', 'Cikal bakal manusia Batak', 'Anak pertama Si Boru Deak Parujar & Raja Odap-odap. Beberapa generasi kemudian lahirlah Si Raja Batak.', 'ya', '', ''),
('Boru Ihat Manisia', 4, 4, 'P', 'Anak kedua', 'Anak kedua Si Boru Deak Parujar & Raja Odap-odap.', 'ya', '', '');

-- Gen 5-6: Si Raja Batak (beberapa generasi setelah Raja Ihat Manisia)
-- Berdasarkan W.M. Hutagalung (1926), Si Raja Batak adalah keturunan Raja Ihat Manisia
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Si Raja Batak', 5, 5, 'L', 'Leluhur Bangso Batak', 'Leluhur pertama orang Batak. Berasal dari Sianjur Mula-mula, Pusuk Buhit, Samosir. Semua marga Batak berasal dari beliau.', 'ya', 'Si Boru Nai Mula Uji', 'Si Raja Batak menikah dan memiliki 2 putra: Guru Tatea Bulan & Raja Isumbaon');

-- Gen 6: Dua putra Si Raja Batak
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Guru Tatea Bulan', 6, 7, 'L', 'Putra sulung Si Raja Batak', 'Guru Tatea Bulan = "Tertayang Bulan". Golongan Bulan = golongan perempuan (hula-hula). Induk kelompok Lontung.', 'ya', 'Si Boru Soping Sopang', 'Memiliki 5 putra: Raja Uti, Sariburaja, Limbong Mulana, Sagala Raja, Silau Raja'),
('Raja Isumbaon', 6, 7, 'L', 'Putra kedua Si Raja Batak', 'Raja Isumbaon = "Raja yang disembah". Golongan Matahari = golongan laki-laki. Induk kelompok Sumba.', 'ya', 'Si Boru Anting Sabungan', 'Memiliki 3 putra: Tuan Sorimangaraja, Si Raja Asiasi, Sangkar Somalidang');

-- Gen 7: 5 putra Guru Tatea Bulan
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Raja Uti (Raja Biak-biak)', 7, 8, 'L', 'Putra sulung Guru Tatea Bulan', 'Raja Uti terkenal sakti. Pemimpin spiritual Tanah Batak. Tidak memiliki keturunan langsung.', 'ya', '', 'Tidak berketurunan langsung'),
('Tuan Sariburaja', 7, 8, 'L', 'Putra kedua Guru Tatea Bulan', 'Sariburaja lahir kembar dengan saudari perempuannya Si Boru Pareme. Menikah dengan Si Boru Pareme (incest) dan Nai Margiring Laut.', 'ya', 'Si Boru Pareme (istri 1) & Nai Margiring Laut (istri 2)', 'Dari Si Boru Pareme lahir Si Raja Lontung. Dari Nai Margiring Laut lahir Si Raja Borbor'),
('Limbong Mulana', 7, 8, 'L', 'Putra ketiga Guru Tatea Bulan', 'Keturunannya bermarga Limbong dan cabangnya.', 'ya', 'Si Boru Pinta Omas', 'Keturunannya: marga Limbong, Sihole, Habeahan'),
('Sagala Raja', 7, 8, 'L', 'Putra keempat Guru Tatea Bulan', 'Keturunannya bermarga Sagala.', 'ya', 'Si Boru Anting Sabungan', 'Keturunannya bermarga Sagala'),
('Silau Raja (Malau Raja)', 7, 8, 'L', 'Putra kelima Guru Tatea Bulan', 'Memiliki 4 putra: Malau, Manik, Ambarita, Gurning.', 'ya', 'Si Boru Anting Menalam', 'Keturunannya: Malau, Manik, Ambarita, Gurning');

-- Gen 7: 3 putra Raja Isumbaon
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Tuan Sorimangaraja', 7, 9, 'L', 'Putra sulung Raja Isumbaon', 'Satu-satunya putra Raja Isumbaon yang tinggal di Pusuk Buhit. Menikah dengan 3 istri (putri Guru Tatea Bulan).', 'ya', 'Si Boru Anting Malela (istri 1), Si Boru Biding Laut (istri 2), Si Boru Sanggul Baomasan (istri 3)', '3 istri: Nai Ambaton, Nai Rasaon, Nai Suanon adalah nama gelar putra-putranya dari masing-masing istri'),
('Si Raja Asiasi', 7, 9, 'L', 'Putra kedua Raja Isumbaon', 'Putra kedua Raja Isumbaon.', 'ya', '', ''),
('Sangkar Somalidang', 7, 9, 'L', 'Putra ketiga Raja Isumbaon', 'Putra ketiga Raja Isumbaon.', 'ya', '', '');

-- Gen 8: Anak Tuan Sariburaja
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Si Raja Lontung', 8, 11, 'L', 'Putra Tuan Sariburaja dari Si Boru Pareme', 'Induk kelompok Lontung. Memiliki 7 putra + 2 putri. Keturunannya adalah marga-marga utama Batak Toba.', 'ya', 'Si Boru Anak Pardomuan', '7 putra: Situmorang, Sinaga, Pandiangan, Nainggolan, Simatupang, Aritonang, Siregar. 2 putri: Si Boru Anakpandan (kawin Sihombing), Si Boru Panggabean (kawin Simamora)'),
('Si Raja Borbor', 8, 11, 'L', 'Putra Tuan Sariburaja dari Nai Margiring Laut', 'Induk kelompok Borbor. Keturunannya bermarga Borbor dan cabangnya.', 'ya', 'Si Boru Anting Mela', 'Keturunannya: Sipahutar, Harahap, Tanjung, Pulungan, Lubis, Hutasuhut, Pasaribu, Batubara, dll');

-- Gen 8: 3 putra Tuan Sorimangaraja (Nai Ambaton, Nai Rasaon, Nai Suanon)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Tuan Sorbadijulu (Nai Ambaton)', 8, 14, 'L', 'Putra sulung Tuan Sorimangaraja', 'Nama asli: Ompu Raja Nabolon. Nai Ambaton = nama ibu. Keturunannya bermarga Simbolon, Tamba, Saragi, Munte.', 'ya', 'Si Boru Biding Laut', '4 putra: Simbolon Tua, Tamba Tua, Saragi Tua, Munte Tua'),
('Tuan Sorbadijae (Nai Rasaon)', 8, 14, 'L', 'Putra kedua Tuan Sorimangaraja', 'Nama asli: Raja Mangarerak. Nai Rasaon = nama ibu. Keturunannya bermarga Sitorus, Sirait, Butar-butar, Manurung.', 'ya', 'Si Boru Anting Malela', '2 putra: Raja Mardopang, Raja Mangatur'),
('Tuan Sorbadibanua (Nai Suanon)', 8, 14, 'L', 'Putra ketiga Tuan Sorimangaraja', 'Nai Suanon = nama ibu. 8 putra dari 2 istri. Keturunannya lebih dari 100 marga.', 'ya', 'Putri Sariburaja (istri 1) & Boru Sibasopaet (istri 2)', '8 putra: Si Bagot Ni Pohan, Si Paet Tua, Si Lahi Sabungan, Si Raja Oloan, Si Raja Huta Lima (dari istri 1); Si Raja Sumba, Si Raja Sobu, Toga Naipospos (dari istri 2)');

-- Gen 9: 7 putra Si Raja Lontung (marga-marga utama)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Tuan Situmorang', 9, 16, 'L', 'Putra sulung Si Raja Lontung', 'Keturunannya bermarga Situmorang dan cabang: Siringoringo, Rumapea, Padang, Solin, Lumban Pande, dll.', 'ya', '', ''),
('Sinaga Raja', 9, 16, 'L', 'Putra kedua Si Raja Lontung', 'Keturunannya bermarga Sinaga dan cabang: Simanjorang, Simandalahi, Barutu.', 'ya', '', ''),
('Pandiangan', 9, 16, 'L', 'Putra ketiga Si Raja Lontung', 'Keturunannya bermarga Pandiangan dan cabang: Samosir, Pakpahan, Gultom, Sidari, Sitinjak, Harianja.', 'ya', '', ''),
('Toga Nainggolan', 9, 16, 'L', 'Putra keempat Si Raja Lontung', 'Keturunannya bermarga Nainggolan dan cabang: Parhusip, Lumban Tungkup, Lumban Siantar, Hutabalian, dll.', 'ya', '', ''),
('Simatupang', 9, 16, 'L', 'Putra kelima Si Raja Lontung', 'Keturunannya bermarga Simatupang dan cabang: Togatorop, Sianturi, Siburian.', 'ya', '', ''),
('Aritonang', 9, 16, 'L', 'Putra keenam Si Raja Lontung', 'Keturunannya bermarga Aritonang dan cabang: Rajagukguk, Simaremare.', 'ya', '', ''),
('Siregar', 9, 16, 'L', 'Putra ketujuh Si Raja Lontung', 'Keturunannya bermarga Siregar dan cabang: Silo, Dongaran, Siagian, Ritonga, Sormin.', 'ya', '', '');

-- Gen 9: 4 putra Nai Ambaton
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Simbolon Tua', 9, 17, 'L', 'Putra sulung Nai Ambaton', 'Keturunannya bermarga Simbolon, Tinambunan, Tumanggor, Maharaja, Turutan, Nahampun, Pinayungan.', 'ya', '', ''),
('Tamba Tua', 9, 17, 'L', 'Putra kedua Nai Ambaton', 'Keturunannya bermarga Tamba, Siallagan, Sidabutar, Sijabat, Gusar, Siadari, dll.', 'ya', '', ''),
('Saragi Tua', 9, 17, 'L', 'Putra ketiga Nai Ambaton', 'Keturunannya bermarga Saragi, Simalango, Saing, Simarmata, Nadeak, Sidabungke.', 'ya', '', ''),
('Munte Tua', 9, 17, 'L', 'Putra keempat Nai Ambaton', 'Keturunannya bermarga Munte, Sitanggang, Manihuruk, Sidauruk, Turnip, Sitio, Sigalingging.', 'ya', '', '');

-- Gen 9: 2 putra Nai Rasaon
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Raja Mardopang', 9, 18, 'L', 'Putra sulung Nai Rasaon', 'Keturunannya bermarga Sitorus, Sirait, Butar-butar, Pane.', 'ya', '', ''),
('Raja Mangatur', 9, 18, 'L', 'Putra kedua Nai Rasaon', 'Keturunannya bermarga Manurung.', 'ya', '', '');

-- Gen 9: 8 putra Nai Suanon (Tuan Sorbadibanua)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Si Bagot Ni Pohan', 9, 19, 'L', 'Putra sulung Nai Suanon (istri 1)', 'Keturunannya bermarga Pohan, Tampubolon, Siahaan, Simanjuntak, Panjaitan, Simangunsong, dll.', 'ya', '', ''),
('Si Paet Tua', 9, 19, 'L', 'Putra kedua Nai Suanon (istri 1)', 'Keturunannya bermarga Hutahaean, Hutajulu, Aruan, Sibarani, Sibuea, Pangaribuan, Hutapea.', 'ya', '', ''),
('Si Lahi Sabungan', 9, 19, 'L', 'Putra ketiga Nai Suanon (istri 1)', 'Keturunannya bermarga Silalahi, Situngkir, Sipangkar, Sipayung, Sirumasondi, Tambun/Tambunan, Sinurat, dll.', 'ya', '', ''),
('Si Raja Oloan', 9, 19, 'L', 'Putra keempat Nai Suanon (istri 1)', 'Keturunannya bermarga Naibaho, Sihotang, Sinambela, Sihite, Simanullang, Angkat, dll.', 'ya', '', ''),
('Si Raja Huta Lima', 9, 19, 'L', 'Putra kelima Nai Suanon (istri 1)', 'Keturunannya bermarga Maha, Sambo, Pardosi, Sembiring Meliala.', 'ya', '', ''),
('Si Raja Sumba', 9, 19, 'L', 'Putra keenam Nai Suanon (istri 2)', 'Keturunannya bermarga Simamora, Purba, Manalu, Sihombing, Silaban, Nababan, Hutasoit, dll.', 'ya', '', ''),
('Si Raja Sobu', 9, 19, 'L', 'Putra ketujuh Nai Suanon (istri 2)', 'Keturunannya bermarga Sitompul, Hasibuan, Hutabarat, Panggabean, Hutagalung, Hutatoruan, Simorangkir, dll.', 'ya', '', ''),
('Toga Naipospos', 9, 19, 'L', 'Putra kedelapan Nai Suanon (istri 2)', 'Keturunannya bermarga Marbun, Sibagariang, Hutauruk, Simanungkalit, Situmeang.', 'ya', '', '');
