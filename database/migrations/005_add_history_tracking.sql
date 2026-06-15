-- Migration 005: History Tracking System for All Entities
-- This migration adds comprehensive history tracking for all entities

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Create entity_history table for tracking all changes
CREATE TABLE IF NOT EXISTS entity_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type VARCHAR(50) NOT NULL COMMENT 'Type of entity (person, asset, tanah, event, etc.)',
    entity_id INT NOT NULL COMMENT 'ID of the entity being tracked',
    action ENUM('created', 'updated', 'deleted', 'transferred', 'published', 'archived') NOT NULL,
    old_data JSON COMMENT 'Previous state of the entity',
    new_data JSON COMMENT 'New state of the entity',
    changed_fields JSON COMMENT 'List of fields that changed',
    changed_by INT COMMENT 'User who made the change',
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT COMMENT 'Reason for the change',
    ip_address VARCHAR(45) COMMENT 'IP address of the user',
    user_agent TEXT COMMENT 'User agent string',
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_changed_by (changed_by),
    INDEX idx_changed_at (changed_at),
    INDEX idx_action (action)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create entity_timeline table for chronological events
CREATE TABLE IF NOT EXISTS entity_timeline (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    event_type VARCHAR(50) NOT NULL COMMENT 'Type of event (birth, death, marriage, transfer, etc.)',
    event_date DATE NOT NULL,
    event_description TEXT,
    event_data JSON COMMENT 'Additional event data',
    related_entity_type VARCHAR(50) COMMENT 'Type of related entity',
    related_entity_id INT COMMENT 'ID of related entity',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_event_date (event_date),
    INDEX idx_event_type (event_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create entity_version table for version control
CREATE TABLE IF NOT EXISTS entity_version (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    version_number INT NOT NULL,
    version_data JSON NOT NULL COMMENT 'Complete entity state at this version',
    version_description TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_version (entity_type, entity_id, version_number),
    INDEX idx_entity (entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create entity_relationship_history table for tracking relationship changes
CREATE TABLE IF NOT EXISTS entity_relationship_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    relationship_type VARCHAR(50) NOT NULL COMMENT 'Type of relationship (parent-child, owner-asset, etc.)',
    from_entity_type VARCHAR(50) NOT NULL,
    from_entity_id INT NOT NULL,
    to_entity_type VARCHAR(50) NOT NULL,
    to_entity_id INT NOT NULL,
    action ENUM('created', 'updated', 'deleted') NOT NULL,
    old_data JSON,
    new_data JSON,
    changed_by INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    INDEX idx_from_entity (from_entity_type, from_entity_id),
    INDEX idx_to_entity (to_entity_type, to_entity_id),
    INDEX idx_relationship (relationship_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create oral_traditions table for preserving Batak oral traditions
CREATE TABLE IF NOT EXISTS oral_traditions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kategori VARCHAR(50) NOT NULL COMMENT 'Type: umpasa, cerita_rakyat, lagu_adat, mantra, etc.',
    judul VARCHAR(255) NOT NULL,
    konten TEXT NOT NULL,
    bahasa_asli TEXT COMMENT 'Original Batak language text',
    terjemahan TEXT COMMENT 'Indonesian translation',
    transliterasi TEXT COMMENT 'Latin script transliteration',
    audio_path VARCHAR(255) COMMENT 'Path to audio recording',
    video_path VARCHAR(255) COMMENT 'Path to video recording',
    marga_id INT,
    daerah VARCHAR(100) COMMENT 'Region where tradition is practiced',
    narator VARCHAR(255) COMMENT 'Name of the narrator/tradition keeper',
    tanggal_rekam DATE COMMENT 'Date when tradition was recorded',
    status ENUM('aktif', 'terancam', 'punah') DEFAULT 'aktif',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_id) REFERENCES marga(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_kategori (kategori),
    INDEX idx_marga (marga_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create traditional_knowledge table for indigenous wisdom
CREATE TABLE IF NOT EXISTS traditional_knowledge (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kategori VARCHAR(50) NOT NULL COMMENT 'Type: pertanian, obat_tradisional, konservasi, kerajinan, etc.',
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT NOT NULL,
    metode TEXT COMMENT 'Detailed method/procedure',
    bahan TEXT COMMENT 'Materials needed',
    alat TEXT COMMENT 'Tools needed',
    manfaat TEXT COMMENT 'Benefits and uses',
    larangan TEXT COMMENT 'Taboos and restrictions',
    marga_id INT,
    daerah VARCHAR(100),
    pengetahuan_dari VARCHAR(255) COMMENT 'Source of knowledge (elder, etc.)',
    tanggal_dokumentasi DATE,
    foto_path VARCHAR(255),
    video_path VARCHAR(255),
    status ENUM('aktif', 'terancam', 'punah') DEFAULT 'aktif',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_id) REFERENCES marga(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_kategori (kategori),
    INDEX idx_marga (marga_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create cultural_sites table for important cultural locations
CREATE TABLE IF NOT EXISTS cultural_sites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    tipe VARCHAR(50) NOT NULL COMMENT 'Type: makam_leluhur, situs_adat, tempat_suci, dll',
    deskripsi TEXT,
    alamat TEXT,
    kota VARCHAR(100),
    provinsi VARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    marga_id INT,
    person_id INT COMMENT 'Person associated with this site',
    sejarah TEXT COMMENT 'Historical significance',
    status_konservasi ENUM('terjaga', 'terancam', 'rusak', 'hilang') DEFAULT 'terjaga',
    foto_path VARCHAR(255),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_id) REFERENCES marga(id),
    FOREIGN KEY (person_id) REFERENCES persons(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_tipe (tipe),
    INDEX idx_marga (marga_id),
    INDEX idx_status (status_konservasi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Insert sample data
INSERT INTO oral_traditions (kategori, judul, konten, bahasa_asli, terjemahan, marga_id, narator, status) VALUES
('umpasa', 'Mangulosi', 'Ulos sebagai simbol berkat dan perlindungan', 'Ulos manungkos, manungkoban, manungkalhati', 'Ulos memberikan kehangatan, perlindungan, dan ketenangan hati', 1, 'Nenek Boru', 'aktif'),
('cerita_rakyat', 'Asal Usul Danau Toba', 'Legenda pembentukan Danau Toba', 'Si Ombu nan dohot Si Ombu...', 'Kisah tentang pembentukan Danau Toba dari legenda lokal', 1, 'Amang Tua', 'aktif');

INSERT INTO traditional_knowledge (kategori, judul, deskripsi, metode, marga_id, pengetahuan_dari, status) VALUES
('pertanian', 'Maragat Getah', 'Teknik tradisional mengambil getah karet tanpa merusak pohon', 'Mengambil getah dengan tangan kosong secara hati-hati', 1, 'Amang Tani', 'aktif'),
('obat_tradisional', 'Obat Daun Sirih', 'Penggunaan daun sirih untuk kesehatan', 'Rebus daun sirih dan minum airnya', 1, 'Nenek Boru', 'aktif');

INSERT INTO cultural_sites (nama, tipe, deskripsi, alamat, kota, provinsi, marga_id, sejarah, status_konservasi) VALUES
('Makam Si Singamangaraja', 'makam_leluhur', 'Makam pahlawan Batak terakhir', 'Desa Bakara', 'Bakara', 'Sumatera Utara', 1, 'Makam Si Singamangaraja XII yang gugur melawan Belanda', 'terjaga'),
('Sianjur Mulamula', 'situs_adat', 'Tempat asal usul marga Batak', 'Desa Sianjur', 'Samosir', 'Sumatera Utara', 1, 'Tempat dianggap sebagai asal usul semua marga Batak', 'terjaga');
