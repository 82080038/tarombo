-- Migration 007: Fix all parent-child relationships

USE tarombo;

-- Fix: Raja Isumbaon parent should be Guru Tatea Bulan (id=7), not Boru Ihat Manisia (id=6)
UPDATE silsilah_mitolologis SET orang_tuan_id = 7 WHERE nama = 'Raja Isumbaon';

-- Fix: Tuan Sariburaja parent should be Raja Isumbaon (id=8), not Guru Tatea Bulan (id=7)
UPDATE silsilah_mitolologis SET orang_tuan_id = 8 WHERE nama = 'Tuan Sariburaja';

-- Fix: Gen 8 (Si Raja Lontung, Limbong, Sagala, Silau, Borbor, Sorimangaraja) 
-- parent should be Tuan Sariburaja (id=9), not Raja Isumbaon (id=8)
UPDATE silsilah_mitolologis SET orang_tuan_id = 9 WHERE nama IN ('Si Raja Lontung', 'Limbong Mulana', 'Sagala Raja', 'Silau Raja', 'Si Raja Borbor', 'Tuan Sorimangaraja');

-- Fix: Nai Ambaton, Nai Rasaon, Nai Suanon 
-- parent should be Tuan Sorimangaraja (id=15), not Si Raja Borbor (id=14)
UPDATE silsilah_mitolologis SET orang_tuan_id = 15 WHERE nama LIKE '%Nai Ambaton%' OR nama LIKE '%Nai Rasaon%' OR nama LIKE '%Nai Suanon%';

-- Fix: Raja Sibagotni Pohan, Raja Sipaettua, etc (Gen 9)
-- parent should be Si Raja Lontung (id=10), not Tuan Sariburaja (id=9)
UPDATE silsilah_mitolologis SET orang_tuan_id = 10 WHERE nama IN ('Raja Sibagotni Pohan', 'Raja Sipaettua', 'Raja Silahisabungan', 'Raja Oloan', 'Raja Hutalima', 'Raja Sumba', 'Raja Sobu', 'Raja Naipospos');
