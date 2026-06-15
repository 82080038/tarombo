-- Migration 006: Split Person Name Structure
-- Memisahkan nama orang menjadi komponen terpisah untuk tracking marga

USE tarombo;

-- Add new columns to persons table
ALTER TABLE persons 
ADD COLUMN nama_depan VARCHAR(100) NULL COMMENT 'Nama depan/personal name' AFTER nama,
ADD COLUMN id_turunan_marga INT NULL COMMENT 'ID marga turunan (untuk tracking hierarki)' AFTER marga_id,
ADD COLUMN id_asal_usul INT NULL COMMENT 'ID asal usul marga (referensi ke marga asal)' AFTER id_turunan_marga,
ADD INDEX idx_turunan_marga (id_turunan_marga),
ADD INDEX idx_asal_usul (id_asal_usul);

-- Add foreign key constraints
ALTER TABLE persons 
ADD FOREIGN KEY (id_turunan_marga) REFERENCES marga(id) ON DELETE SET NULL,
ADD FOREIGN KEY (id_asal_usul) REFERENCES marga(id) ON DELETE SET NULL;

-- Migrate existing data: extract nama_depan from nama (assuming format "Nama Marga")
-- For existing records, we'll try to extract the first name part
UPDATE persons 
SET nama_depan = SUBSTRING_INDEX(nama, ' ', 1)
WHERE nama_depan IS NULL;

-- For records that don't have space in name, use the full name as nama_depan
UPDATE persons 
SET nama_depan = nama
WHERE nama_depan IS NULL OR nama_depan = '';

-- Update id_asal_usul to reference the marga's origin (parent_id from marga table)
UPDATE persons p
JOIN marga m ON p.marga_id = m.id
SET p.id_asal_usul = m.parent_id
WHERE p.id_asal_usul IS NULL AND m.parent_id IS NOT NULL;

-- Add a computed column or view for full name (optional, can be done in application layer)
-- For now, we'll handle full name in the application layer
