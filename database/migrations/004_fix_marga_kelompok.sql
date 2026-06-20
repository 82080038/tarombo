-- Migration: Fix kelompok_marga berdasarkan sumber terpercaya
-- Sumber: budaya-indonesia.org, Wikipedia, detik.com, buku W. Hutagalung
-- Tanggal: 2026-06-21

-- ============================================
-- 1. LONTUNG: Hapus Sihombing (seharusnya Naisuanon via Raja Sumba)
-- ============================================
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Si Raja Sumba (Toga Sihombing)' WHERE nama = 'Sihombing';

-- ============================================
-- 2. NAIAMBATON: Fix root marga (4 putra Nai Ambaton)
-- Root: Simbolon, Tamba, Saragih, Munte
-- Sub-marga pindah ke keturunan_siraja yang spesifik
-- ============================================
-- Tambah Simbolon sebagai root marga
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Simbolon', 'Naiambaton', 'Nai Ambaton (Tuan Sorbadijulu)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simbolon');

-- Tambah Saragih sebagai root marga (jika belum ada dengan kelompok)
UPDATE marga SET kelompok_marga = 'Naiambaton', keturunan_siraja = 'Nai Ambaton (Tuan Sorbadijulu)' WHERE nama = 'Saragih' AND kelompok_marga IS NULL;

-- Hapus sub-marga dari Naiambaton (mereka cabang, bukan root)
-- Simarmata = sub-marga Saragih
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Saragih (Nai Ambaton)' WHERE nama = 'Simarmata';
-- Tinambunan = sub-marga Simbolon
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Simbolon (Nai Ambaton)' WHERE nama = 'Tinambunan';
-- Tumanggor = sub-marga Simbolon
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Simbolon (Nai Ambaton)' WHERE nama = 'Tumanggor';

-- ============================================
-- 3. NAIRASAON: Tambah Butarbutar
-- ============================================
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku)
SELECT 'Butarbutar', 'Nairasaon', 'Nai Rasaon (Tuan Sorbadijae)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Butarbutar');

-- ============================================
-- 4. NAISUANON: Hapus Beringin (bukan keturunan Si Raja Batak)
-- ============================================
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Ompu Bada (Dairi/Pakpak) - BUKAN keturunan Si Raja Batak' WHERE nama = 'Beringin';

-- Tambah marga Naisuanon yang kurang berdasarkan sumber
-- Keturunan Si Bagot Ni Pohan: Tampubolon(sudah), Siahaan, Simanjuntak(sudah), Panjaitan(sudah), Siagian, Simangunsong, Marpaung(sudah), Napitupulu, Pardede(sudah)
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Siahaan', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Bagot Ni Pohan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Siahaan' AND kelompok_marga = 'Naisuanon');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Siagian', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Bagot Ni Pohan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Siagian' AND kelompok_marga = 'Naisuanon');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Simangunsong', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Bagot Ni Pohan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simangunsong');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Napitupulu', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Bagot Ni Pohan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Napitupulu');

-- Keturunan Si Paet Tua: Hutahaean(sudah), Hutajulu(sudah), Sibarani, Sibuea(sudah), Pangaribuan(sudah), Hutapea(sudah)
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sibarani', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Paet Tua', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sibarani');

-- Keturunan Si Lahi Sabungan: Silalahi(sudah), Sihaloho, Situngkir, Sipayung(sudah)
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sihaloho', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Lahi Sabungan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sihaloho');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Situngkir', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Lahi Sabungan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Situngkir');

-- Keturunan Si Raja Oloan: Naibaho, Sihotang(sudah)
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Naibaho', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Oloan', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Naibaho');

-- Keturunan Si Raja Sumba: Simamora, Silaban, Lumban Toruan, Nababan(sudah), Hutasoit(sudah)
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Simamora', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sumba', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simamora' AND kelompok_marga IS NULL);

UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sumba' WHERE nama = 'Silaban' AND kelompok_marga IS NULL;

UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sumba' WHERE nama = 'Lumban Toruan' AND kelompok_marga IS NULL;

-- Keturunan Si Raja Sobu: Sitompul, Simorangkir, Lumbantobing
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sitompul', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sobu', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sitompul');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Simorangkir', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sobu', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simorangkir');

UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Si Raja Sobu' WHERE nama = 'Lumbantobing' AND kelompok_marga IS NULL;

-- Keturunan Toga Naipospos: Marbun(sudah), Lumbanbatu, Lumbangaol, Banjarnahor, Sibagariang, Hutauruk(sudah), Simanungkalit
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos' WHERE nama = 'Lumbanbatu' AND kelompok_marga IS NULL;

UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos' WHERE nama = 'Lumbangaol' AND kelompok_marga IS NULL;

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Banjarnahor', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Banjarnahor');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sibagariang', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sibagariang');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Simanungkalit', 'Naisuanon', 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Simanungkalit');

-- Naipospos sendiri
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua) - Toga Naipospos' WHERE nama = 'Naipospos' AND kelompok_marga IS NULL;

-- ============================================
-- 5. BORBOR: Tambah marga kurang
-- ============================================
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sipahutar', 'Borbor', 'Si Raja Borbor', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sipahutar');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Tarihoran', 'Borbor', 'Si Raja Borbor', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Tarihoran');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Habeahan', 'Borbor', 'Si Raja Borbor', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Habeahan');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Tinendang', 'Borbor', 'Si Raja Borbor', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Tinendang');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Tangkar', 'Borbor', 'Si Raja Borbor', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Tangkar');

-- ============================================
-- 6. KELOMPOK BARU: Silau Raja (4 putra: Malau, Manik, Ambarita, Gurning)
-- ============================================
INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Malau', 'Silau Raja', 'Silau Raja (Guru Tatea Bulan)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Malau');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Manik', 'Silau Raja', 'Silau Raja (Guru Tatea Bulan)', 'Karo'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Manik' AND kelompok_marga IS NULL);

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Ambarita', 'Silau Raja', 'Silau Raja (Guru Tatea Bulan)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Ambarita');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Gurning', 'Silau Raja', 'Silau Raja (Guru Tatea Bulan)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Gurning');

-- ============================================
-- 7. KELOMPOK BARU: Limbong (Limbong Mulana)
-- ============================================
UPDATE marga SET kelompok_marga = 'Limbong', keturunan_siraja = 'Limbong Mulana (Guru Tatea Bulan)' WHERE nama = 'Limbong Mulana';

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Limbong', 'Limbong', 'Limbong Mulana (Guru Tatea Bulan)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Limbong');

INSERT INTO marga (nama, kelompok_marga, keturunan_siraja, sub_suku) 
SELECT 'Sihole', 'Limbong', 'Limbong Mulana (Guru Tatea Bulan)', 'Toba'
WHERE NOT EXISTS (SELECT 1 FROM marga WHERE nama = 'Sihole');

-- Habeahan juga ada di Limbong (dari sumber), tapi sudah di Borbor - biarkan di Borbor sesuai sumber utama

-- ============================================
-- 8. FIX MARGA TANPA KELOMPOK yang jelas asalnya
-- ============================================
-- Lontung sub-marga:
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Situmorang' WHERE nama = 'Siringoringo' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Situmorang' WHERE nama = 'Lumban Pande' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Situmorang' WHERE nama = 'Lumban Nahor' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Pandiangan' WHERE nama = 'Gultom' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Aritonang' WHERE nama = 'Ompu Sunggu' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Aritonang' WHERE nama = 'Rajagukguk' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Aritonang' WHERE nama = 'Simaremare' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Siregar' WHERE nama = 'Sormin' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Simatupang' WHERE nama = 'Togatorop' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Nainggolan' WHERE nama = 'Parhusip' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Nainggolan' WHERE nama = 'Lumban Tungkup' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Nainggolan' WHERE nama = 'Lumban Siantar' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Nainggolan' WHERE nama = 'Lumban Raja' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung - Nainggolan' WHERE nama = 'Hutabalian' AND kelompok_marga IS NULL;

-- Naisuanon sub-marga yang masih tanpa kelompok:
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon - Si Raja Sumba' WHERE nama = 'Lumbantoruan' AND kelompok_marga IS NULL;
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon - Si Raja Sobu' WHERE nama = 'Lumbantobing' AND kelompok_marga IS NULL;

-- Borbor sub-marga:
UPDATE marga SET kelompok_marga = 'Borbor', keturunan_siraja = 'Si Raja Borbor' WHERE nama = 'Borbor' AND kelompok_marga IS NULL;

-- Sagala Raja -> sudah ada Sagala, ini adalah node silsilah
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Node Silsilah (Guru Tatea Bulan)' WHERE nama = 'Sagala Raja' AND kelompok_marga IS NULL;

-- Node silsilah yang bukan marga modern - set NULL eksplisit
-- (Si Raja Batak, Guru Tatea Bulan, Tuan Sariburaja, Raja Isumbaon, Raja Lontung, Raja Borbor, Raja Oloan, Raja Galeman, Silau Raja)
-- Biarkan NULL - ini tokoh silsilah, bukan marga

-- ============================================
-- 9. Hapus Sembiring dari Naisuanon (debatable - hanya Sembiring Meliala yang dari Naisuanon)
-- Sembiring secara umum adalah marga Karo, bukan langsung Naisuanon
-- ============================================
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = 'Karo - Sembiring Meliala ada hubungan dengan Naisuanon (Si Raja Huta Lima)' WHERE nama = 'Sembiring' AND kelompok_marga = 'Naisuanon';
