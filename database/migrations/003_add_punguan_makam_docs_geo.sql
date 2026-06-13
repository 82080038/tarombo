-- Migration: Add Punguan, Documents, Makam, and Geographic tables
USE tarombo;

-- Punguan (Marga Organization)
CREATE TABLE punguan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    marga_id INT NOT NULL,
    deskripsi TEXT NULL,
    alamat VARCHAR(255) NULL,
    kota VARCHAR(100) NULL,
    provinsi VARCHAR(100) NULL,
    ketua_id INT NULL COMMENT 'ID person ketua punguan',
    wakil_ketua_id INT NULL,
    sekretaris_id INT NULL,
    bendahara_id INT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE CASCADE,
    FOREIGN KEY (ketua_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (wakil_ketua_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (sekretaris_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (bendahara_id) REFERENCES persons(id) ON DELETE SET NULL,
    INDEX idx_marga (marga_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Punguan Members
CREATE TABLE punguan_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    punguan_id INT NOT NULL,
    person_id INT NOT NULL,
    role ENUM('member', 'pengurus', 'ketua_cabang') DEFAULT 'member',
    join_date DATE NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    UNIQUE KEY unique_member (punguan_id, person_id),
    INDEX idx_punguan (punguan_id),
    INDEX idx_person (person_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Iuran (Contributions)
CREATE TABLE iuran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    punguan_id INT NOT NULL,
    person_id INT NOT NULL,
    jenis_iuran VARCHAR(100) NOT NULL COMMENT 'bulanan, saur matua, acara, dll',
    jumlah DECIMAL(15,2) NOT NULL,
    periode VARCHAR(50) NULL COMMENT '2026-06',
    status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    verified_by INT NULL,
    verified_at TIMESTAMP NULL,
    keterangan TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_punguan (punguan_id),
    INDEX idx_person (person_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Documents (Files & Media)
CREATE TABLE documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    document_type ENUM('photo', 'video', 'audio', 'pdf', 'other') NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INT NULL COMMENT 'bytes',
    mime_type VARCHAR(100) NULL,
    access_level ENUM('public', 'restricted', 'confidential') DEFAULT 'public',
    person_id INT NULL COMMENT 'If related to a person',
    ceremony_id INT NULL COMMENT 'If related to a ceremony',
    punguan_id INT NULL,
    uploaded_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (ceremony_id) REFERENCES ceremonies(id) ON DELETE SET NULL,
    FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE SET NULL,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_type (document_type),
    INDEX idx_access (access_level),
    INDEX idx_person (person_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Makam (Grave/Tomb data)
CREATE TABLE makam (
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NULL COMMENT 'Person buried here',
    nama_makam VARCHAR(255) NOT NULL COMMENT 'Nama yang dimakamkan',
    lokasi VARCHAR(255) NULL,
    latitude DECIMAL(10,8) NULL,
    longitude DECIMAL(11,8) NULL,
    foto_path VARCHAR(500) NULL,
    deskripsi TEXT NULL,
    riwayat_perawatan JSON NULL COMMENT 'Array of maintenance records',
    jalur_ziarah TEXT NULL COMMENT 'Directions for pilgrimage',
    verified_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_person (person_id),
    INDEX idx_lokasi (lokasi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Geographic / Person Locations (for map visualization)
CREATE TABLE person_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT NOT NULL,
    lokasi VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,8) NULL,
    longitude DECIMAL(11,8) NULL,
    address_detail TEXT NULL,
    location_type ENUM('birth', 'current', 'hometown', 'work') DEFAULT 'current',
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    INDEX idx_person (person_id),
    INDEX idx_lokasi (lokasi)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample Punguan
INSERT INTO punguan (nama, marga_id, deskripsi, alamat, kota, provinsi, status) VALUES
('Punguan Simanjuntak Jakarta', 32, 'Organisasi marga Simanjuntak di Jakarta', 'Jl. Batak No.1', 'Jakarta', 'DKI Jakarta', 'active'),
('Punguan Marbun Medan', 33, 'Organisasi marga Marbun di Medan', 'Jl. Sisingamangaraja', 'Medan', 'Sumatera Utara', 'active');

-- Insert sample Makam
INSERT INTO makam (person_id, nama_makam, lokasi, latitude, longitude, deskripsi, jalur_ziarah) VALUES
(1, 'John Simanjuntak', 'Taman Makam Pahlawan Medan', 3.5952, 98.6721, 'Makam leluhur marga Simanjuntak', 'Dari bandara menuju jalan Sisingamangaraja, belok kanan ke TMP'),
(6, 'Emily Marbun', 'Taman Makam Keluarga Marbun, Medan', 3.6000, 98.6800, 'Makam keluarga besar Marbun', 'Dari pusat kota Medan, 15 menit ke arah barat');

-- Insert sample Person Locations
INSERT INTO person_locations (person_id, lokasi, latitude, longitude, location_type, is_primary) VALUES
(1, 'Medan', 3.5952, 98.6721, 'hometown', true),
(3, 'Jakarta', -6.2088, 106.8456, 'current', true),
(6, 'Surabaya', -7.2575, 112.7521, 'current', true),
(8, 'Jakarta', -6.2100, 106.8500, 'current', true);
