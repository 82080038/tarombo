-- Migration 011: Insert missing Nai Ambaton/Rasaon/Suanon and fix children parents

USE tarombo;

-- Insert Nai Ambaton, Nai Rasaon, Nai Suanon (parent = Tuan Sorimangaraja, id=16)
INSERT INTO silsilah_mitolologis (nama, generasi_ke, orang_tuan_id, jenis_kelamin, peran, deskripsi, mitologi, pasangan_nama, info_perkawinan) VALUES
('Tuan Sorbadijulu (Nai Ambaton)', 8, 16, 'L', 'Putra sulung Tuan Sorimangaraja', 'Nama asli: Ompu Raja Nabolon. Nai Ambaton = nama ibu. Keturunannya bermarga Simbolon, Tamba, Saragi, Munte.', 'ya', 'Si Boru Biding Laut', '4 putra: Simbolon Tua, Tamba Tua, Saragi Tua, Munte Tua'),
('Tuan Sorbadijae (Nai Rasaon)', 8, 16, 'L', 'Putra kedua Tuan Sorimangaraja', 'Nama asli: Raja Mangarerak. Nai Rasaon = nama ibu. Keturunannya bermarga Sitorus, Sirait, Butar-butar, Manurung.', 'ya', 'Si Boru Anting Malela', '2 putra: Raja Mardopang, Raja Mangatur'),
('Tuan Sorbadibanua (Nai Suanon)', 8, 16, 'L', 'Putra ketiga Tuan Sorimangaraja', 'Nai Suanon = nama ibu. 8 putra dari 2 istri. Keturunannya lebih dari 100 marga.', 'ya', 'Putri Sariburaja (istri 1) dan Boru Sibasopaet (istri 2)', '8 putra dari 2 istri');

-- Now fix children parents:
-- Get the new IDs using subqueries
-- 4 putra Nai Ambaton
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama LIKE '%Nai Ambaton%') t) WHERE nama IN ('Simbolon Tua', 'Tamba Tua', 'Saragi Tua', 'Munte Tua');

-- 2 putra Nai Rasaon
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama LIKE '%Nai Rasaon%') t) WHERE nama IN ('Raja Mardopang', 'Raja Mangatur');

-- 8 putra Nai Suanon
UPDATE silsilah_mitolologis SET orang_tuan_id = (SELECT id FROM (SELECT id FROM silsilah_mitolologis WHERE nama LIKE '%Nai Suanon%') t) WHERE nama IN ('Si Bagot Ni Pohan', 'Si Paet Tua', 'Si Lahi Sabungan', 'Si Raja Oloan', 'Si Raja Huta Lima', 'Si Raja Sumba', 'Si Raja Sobu', 'Toga Naipospos');
