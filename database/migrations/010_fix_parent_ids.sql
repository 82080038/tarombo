-- Migration 010: Fix parent-child IDs to match actual auto-increment values

USE tarombo;

-- Fix Gen 4: Raja Ihat Manisia & Boru Ihat Manisia → parent = Si Boru Deak Parujar (id=5)
UPDATE silsilah_mitolologis SET orang_tuan_id = 5 WHERE nama = 'Raja Ihat Manisia';
UPDATE silsilah_mitolologis SET orang_tuan_id = 5 WHERE nama = 'Boru Ihat Manisia';

-- Fix Gen 5: Si Raja Batak → parent = Boru Ihat Manisia (id=7)
UPDATE silsilah_mitolologis SET orang_tuan_id = 7 WHERE nama = 'Si Raja Batak';

-- Fix Gen 6: Guru Tatea Bulan & Raja Isumbaon → parent = Si Raja Batak (id=8)
UPDATE silsilah_mitolologis SET orang_tuan_id = 8 WHERE nama = 'Guru Tatea Bulan';
UPDATE silsilah_mitolologis SET orang_tuan_id = 8 WHERE nama = 'Raja Isumbaon';

-- Fix Gen 7: 5 putra Guru Tatea Bulan → parent = Guru Tatea Bulan (id=9)
UPDATE silsilah_mitolologis SET orang_tuan_id = 9 WHERE nama IN ('Raja Uti (Raja Biak-biak)', 'Tuan Sariburaja', 'Limbong Mulana', 'Sagala Raja', 'Silau Raja (Malau Raja)');

-- Fix Gen 7: 3 putra Raja Isumbaon → parent = Raja Isumbaon (id=10)
UPDATE silsilah_mitolologis SET orang_tuan_id = 10 WHERE nama IN ('Tuan Sorimangaraja', 'Si Raja Asiasi', 'Sangkar Somalidang');

-- Fix Gen 8: Si Raja Lontung & Si Raja Borbor → parent = Tuan Sariburaja (id=12)
UPDATE silsilah_mitolologis SET orang_tuan_id = 12 WHERE nama IN ('Si Raja Lontung', 'Si Raja Borbor');

-- Fix Gen 8: Nai Ambaton, Nai Rasaon, Nai Suanon → parent = Tuan Sorimangaraja (id=16)
UPDATE silsilah_mitolologis SET orang_tuan_id = 16 WHERE nama LIKE '%Nai Ambaton%' OR nama LIKE '%Nai Rasaon%' OR nama LIKE '%Nai Suanon%';

-- Fix Gen 9: 7 putra Si Raja Lontung → parent = Si Raja Lontung (id=19)
UPDATE silsilah_mitolologis SET orang_tuan_id = 19 WHERE nama IN ('Tuan Situmorang', 'Sinaga Raja', 'Pandiangan', 'Toga Nainggolan', 'Simatupang', 'Aritonang', 'Siregar');

-- Fix Gen 9: 4 putra Nai Ambaton → parent = Nai Ambaton (id=21)
UPDATE silsilah_mitolologis SET orang_tuan_id = 21 WHERE nama IN ('Simbolon Tua', 'Tamba Tua', 'Saragi Tua', 'Munte Tua');

-- Fix Gen 9: 2 putra Nai Rasaon → parent = Nai Rasaon (id=22)
UPDATE silsilah_mitolologis SET orang_tuan_id = 22 WHERE nama IN ('Raja Mardopang', 'Raja Mangatur');

-- Fix Gen 9: 8 putra Nai Suanon → parent = Nai Suanon (id=23)
UPDATE silsilah_mitolologis SET orang_tuan_id = 23 WHERE nama IN ('Si Bagot Ni Pohan', 'Si Paet Tua', 'Si Lahi Sabungan', 'Si Raja Oloan', 'Si Raja Huta Lima', 'Si Raja Sumba', 'Si Raja Sobu', 'Toga Naipospos');
