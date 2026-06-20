-- Migration 009: Fix marga groupings based on verified sources
-- Sources: W.M. Hutagalung (1926), Budaya-Indonesia.org, BatakPedia

USE tarombo;

-- Clear old kelompok_marga
UPDATE marga SET kelompok_marga = NULL, keturunan_siraja = NULL;

-- KELOMPOK LONTUNG (keturunan Si Raja Lontung, anak Tuan Sariburaja, anak Guru Tatea Bulan)
UPDATE marga SET kelompok_marga = 'Lontung', keturunan_siraja = 'Si Raja Lontung' WHERE nama IN (
    'Situmorang', 'Sinaga', 'Pandiangan', 'Nainggolan', 'Simatupang', 'Aritonang', 'Siregar',
    'Sihombing', 'Simamora', 'Manurung'
);

-- KELOMPOK BORBOR (keturunan Si Raja Borbor, anak Tuan Sariburaja dari Nai Margiring Laut)
UPDATE marga SET kelompok_marga = 'Borbor', keturunan_siraja = 'Si Raja Borbor' WHERE nama IN (
    'Sipahutar', 'Harahap', 'Tanjung', 'Pulungan', 'Lubis', 'Hutasuhut',
    'Pasaribu', 'Batubara', 'Habeahan', 'Bondar', 'Gorat', 'Tinendang',
    'Tangkar', 'Matondang', 'Saruksuk', 'Tarihoran', 'Parapat', 'Rangkuti',
    'Limbong', 'Sihole', 'Bayoangin'
);

-- KELOMPOK NAI AMATON (keturunan Tuan Sorbadijulu, anak Tuan Sorimangaraja, anak Raja Isumbaon)
UPDATE marga SET kelompok_marga = 'Naiambaton', keturunan_siraja = 'Nai Ambaton (Tuan Sorbadijulu)' WHERE nama IN (
    'Simbolon', 'Tinambunan', 'Tumanggor', 'Maharaja', 'Turutan', 'Nahampun', 'Pinayungan',
    'Tamba', 'Siallagan', 'Sidabutar', 'Sijabat', 'Gusar', 'Siadari',
    'Saragi', 'Simalango', 'Saing', 'Simarmata', 'Nadeak', 'Sidabungke',
    'Munte', 'Sitanggang', 'Manihuruk', 'Sidauruk', 'Turnip', 'Sitio', 'Sigalingging'
);

-- KELOMPOK NAI RASAON (keturunan Tuan Sorbadijae, anak Tuan Sorimangaraja, anak Raja Isumbaon)
UPDATE marga SET kelompok_marga = 'Nairasaon', keturunan_siraja = 'Nai Rasaon (Tuan Sorbadijae)' WHERE nama IN (
    'Sitorus', 'Sirait', 'Butar-butar', 'Pane', 'Manurung'
);

-- KELOMPOK NAI SUANON (keturunan Tuan Sorbadibanua, anak Tuan Sorimangaraja, anak Raja Isumbaon)
UPDATE marga SET kelompok_marga = 'Naisuanon', keturunan_siraja = 'Nai Suanon (Tuan Sorbadibanua)' WHERE nama IN (
    'Pohan', 'Tampubolon', 'Siahaan', 'Simanjuntak', 'Panjaitan', 'Simangunsong',
    'Hutahaean', 'Hutajulu', 'Aruan', 'Sibarani', 'Sibuea', 'Pangaribuan', 'Hutapea',
    'Silalahi', 'Situngkir', 'Sipangkar', 'Sipayung', 'Sirumasondi', 'Tambunan', 'Sinurat', 'Naiborhu',
    'Naibaho', 'Sihotang', 'Sinambela', 'Sihite', 'Simanullang', 'Angkat',
    'Maha', 'Sambo', 'Pardosi', 'Sembiring', 'Meliala',
    'Purba', 'Manalu', 'Silaban', 'Nababan', 'Hutasoit', 'Sitindaon', 'Binjori',
    'Sitompul', 'Hasibuan', 'Hutabarat', 'Panggabean', 'Hutagalung', 'Hutatoruan', 'Simorangkir',
    'Marbun', 'Sibagariang', 'Hutauruk', 'Simanungkalit', 'Situmeang',
    'Silaen', 'Barimbing', 'Nasution', 'Hutagaol', 'Siagian', 'Silitonga', 'Sianipar',
    'Marpaung', 'Napitupulu', 'Pardede', 'Beringin', 'Gajah', 'Manik', 'Tendang', 'Bunurea', 'Barasa'
);

-- KELOMPOK SILAU RAJA (keturunan Silau Raja, anak Guru Tatea Bulan)
UPDATE marga SET kelompok_marga = 'Silau Raja', keturunan_siraja = 'Silau Raja' WHERE nama IN (
    'Ambarita', 'Gurning'
);

-- KELOMPOK SAGALA (keturunan Sagala Raja, anak Guru Tatea Bulan)
UPDATE marga SET kelompok_marga = 'Sagala', keturunan_siraja = 'Sagala Raja' WHERE nama IN (
    'Sagala'
);

-- KELOMPOK LIMBONG (keturunan Limbong Mulana, anak Guru Tatea Bulan)
UPDATE marga SET kelompok_marga = 'Limbong', keturunan_siraja = 'Limbong Mulana' WHERE nama IN (
    'Limbong'
);
