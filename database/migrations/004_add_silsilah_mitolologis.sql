-- Migration 004: Add Silsilah Mitologis dan Historis Batak
-- Tambahkan data silsilah lengkap dari penciptaan sampai marga modern

USE tarombo;

-- Tabel untuk silsilah mitologis/legendaris
CREATE TABLE IF NOT EXISTS silsilah_mitolologis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    generasi_ke INT NOT NULL,
    orang_tuan_id INT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    peran VARCHAR(100) NULL, -- Dewa, Leluhur, Raja, dll
    deskripsi TEXT NULL,
    mitologi ENUM('ya', 'tidak') DEFAULT 'ya',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orang_tuan_id) REFERENCES silsilah_mitolologis(id) ON DELETE SET NULL,
    INDEX idx_generasi (generasi_ke),
    INDEX idx_mitologi (mitologi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabel untuk raja-raja Batak historis
CREATE TABLE IF NOT EXISTS raja_batak (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    gelar VARCHAR(255) NULL,
    kerajaan VARCHAR(100) NULL,
    masa_jabatan VARCHAR(100) NULL, -- contoh: "Abad ke-13-15"
    silsilah_mitolologis_id INT NULL,
    deskripsi TEXT NULL,
    sumber_sejarah TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (silsilah_mitolologis_id) REFERENCES silsilah_mitolologis(id) ON DELETE SET NULL,
    INDEX idx_kerajaan (kerajaan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Update tabel marga untuk menambahkan data kelompok dan hubungan
ALTER TABLE marga 
ADD COLUMN IF NOT EXISTS kelompok_marga VARCHAR(50) NULL COMMENT 'Lontung, Borbor, Naiambaton, Nairasaon, Naisuanon',
ADD COLUMN IF NOT EXISTS induk_marga_id INT NULL COMMENT 'Hubungan ke marga induk',
ADD COLUMN IF NOT EXISTS asal_usul_legenda TEXT NULL COMMENT 'Legenda asal-usul marga',
ADD COLUMN IF NOT EXISTS keturunan_siraja VARCHAR(100) NULL COMMENT 'Nama leluhur dari Si Raja Batak',
ADD FOREIGN KEY IF NOT EXISTS (induk_marga_id) REFERENCES marga(id) ON DELETE SET NULL,
ADD INDEX idx_kelompok_marga (kelompok_marga);

-- Tabel hubungan kekerabatan antar marga
CREATE TABLE IF NOT EXISTS hubungan_marga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marga1_id INT NOT NULL,
    marga2_id INT NOT NULL,
    jenis_hubungan VARCHAR(50) NOT NULL COMMENT 'pariban, tulang, bere, hula-hula, dll',
    deskripsi TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (marga1_id) REFERENCES marga(id) ON DELETE CASCADE,
    FOREIGN KEY (marga2_id) REFERENCES marga(id) ON DELETE CASCADE,
    UNIQUE KEY unique_hubungan (marga1_id, marga2_id, jenis_hubungan),
    INDEX idx_jenis_hubungan (jenis_hubungan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
