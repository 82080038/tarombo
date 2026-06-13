-- Initialize Tarombo Database
-- Drop and recreate everything

DROP DATABASE IF EXISTS tarombo;
CREATE DATABASE tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tarombo;

-- Marga table (Clans)
CREATE TABLE marga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL UNIQUE,
    sub_suku ENUM('Toba', 'Karo', 'Simalungun', 'Mandailing', 'Angkola', 'Pakpak') NOT NULL,
    deskripsi TEXT,
    asal_usul TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_sub_suku (sub_suku),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Persons table
CREATE TABLE persons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    marga_id INT NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    father_id INT NULL,
    mother_id INT NULL,
    tanggal_lahir DATE NULL,
    tempat_lahir VARCHAR(255) NULL,
    tanggal_meninggal DATE NULL,
    status ENUM('active', 'deleted') DEFAULT 'active',
    created_by INT NULL,
    verified_by INT NULL,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE RESTRICT,
    FOREIGN KEY (father_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (mother_id) REFERENCES persons(id) ON DELETE SET NULL,
    INDEX idx_marga (marga_id),
    INDEX idx_father (father_id),
    INDEX idx_mother (mother_id),
    INDEX idx_status (status),
    INDEX idx_nama (nama),
    INDEX idx_jenis_kelamin (jenis_kelamin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Marriages table
CREATE TABLE marriages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    husband_id INT NOT NULL,
    wife_id INT NOT NULL,
    tanggal_perkawinan DATE NULL,
    tempat_perkawinan VARCHAR(255) NULL,
    status ENUM('active', 'divorced', 'widowed') DEFAULT 'active',
    hula_hula_marga_id INT NULL COMMENT 'Pihak pemberi perempuan',
    boru_marga_id INT NULL COMMENT 'Pihak menerima perempuan',
    created_by INT NULL,
    verified_by INT NULL,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (husband_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (wife_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (hula_hula_marga_id) REFERENCES marga(id) ON DELETE SET NULL,
    FOREIGN KEY (boru_marga_id) REFERENCES marga(id) ON DELETE SET NULL,
    UNIQUE KEY unique_marriage (husband_id, wife_id),
    INDEX idx_husband (husband_id),
    INDEX idx_wife (wife_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Audit logs table
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action ENUM('CREATE', 'UPDATE', 'DELETE') NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id INT NOT NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    performed_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_action (action),
    INDEX idx_performed_by (performed_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Users table (for authentication)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nama VARCHAR(255) NOT NULL,
    role ENUM('guest', 'user', 'verified', 'tetua', 'admin') DEFAULT 'user',
    person_id INT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert Marga (Clans) - Updated with comprehensive list
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul) VALUES
-- Toba
('Simanjuntak', 'Toba', 'Salah satu marga besar di Toba', 'Toba Samosir'),
('Marbun', 'Toba', 'Marga dengan cabang-cabang yang banyak', 'Toba'),
('Sihotang', 'Toba', 'Marga yang tersebar di berbagai daerah', 'Toba'),
('Nainggolan', 'Toba', 'Marga asal dari Toba', 'Toba'),
('Siregar', 'Toba', 'Marga besar di Toba', 'Toba'),
('Sinaga', 'Toba', 'Marga dengan sejarah panjang', 'Toba'),
('Pardede', 'Toba', 'Marga dari daerah Toba', 'Toba'),
('Gultom', 'Toba', 'Marga di Toba', 'Toba'),
('Lumbantobing', 'Toba', 'Marga Toba', 'Toba'),
('Situmorang', 'Toba', 'Marga Toba', 'Toba'),
('Hutagalung', 'Toba', 'Marga Toba yang terkenal', 'Toba'),
('Hutapea', 'Toba', 'Marga Toba', 'Toba'),
('Hutajulu', 'Toba', 'Marga Toba', 'Toba'),
('Hutabarat', 'Toba', 'Marga Toba', 'Toba'),
('Hutabalian', 'Toba', 'Marga Toba', 'Toba'),
('Hutagaol', 'Toba', 'Marga Toba', 'Toba'),
('Hutahaean', 'Toba', 'Marga Toba', 'Toba'),
('Hutatoruan', 'Toba', 'Marga Toba', 'Toba'),
('Hutauruk', 'Toba', 'Marga Toba', 'Toba'),
('Hutasuhut', 'Toba', 'Marga Toba', 'Toba'),
('Panjaitan', 'Toba', 'Marga Toba yang besar', 'Toba'),
('Panggabean', 'Toba', 'Marga Toba', 'Toba'),
('Pangaribuan', 'Toba', 'Marga Toba', 'Toba'),
('Pandiangan', 'Toba', 'Marga Toba', 'Toba'),
('Pasaribu', 'Toba', 'Marga Toba', 'Toba'),
('Pardosi', 'Toba', 'Marga Toba', 'Toba'),
('Parhusip', 'Toba', 'Marga Toba', 'Toba'),
('Nababan', 'Toba', 'Marga Toba', 'Toba'),
('Sihombing', 'Toba', 'Marga Toba', 'Toba'),
('Siringoringo', 'Toba', 'Marga Toba', 'Toba'),
('Tambunan', 'Toba', 'Marga Toba', 'Toba'),
('Lumbangaol', 'Toba', 'Marga Toba', 'Toba'),
('Lumbantoruan', 'Toba', 'Marga Toba', 'Toba'),
('Lumbanraja', 'Toba', 'Marga Toba', 'Toba'),
('Lumbanbatu', 'Toba', 'Marga Toba', 'Toba'),
('Aritonang', 'Toba', 'Marga Toba', 'Toba'),
('Manalu', 'Toba', 'Marga Toba', 'Toba'),
('Matondang', 'Toba', 'Marga Toba', 'Toba'),
('Munte', 'Toba', 'Marga Toba', 'Toba'),
('Sagala', 'Toba', 'Marga Toba', 'Toba'),
('Sibuea', 'Toba', 'Marga Toba', 'Toba'),
('Silitonga', 'Toba', 'Marga Toba', 'Toba'),
('Simanullang', 'Toba', 'Marga Toba', 'Toba'),
('Simarmata', 'Toba', 'Marga Toba', 'Toba'),
('Sinurat', 'Toba', 'Marga Toba', 'Toba'),
('Sirait', 'Toba', 'Marga Toba', 'Toba'),
('Sormin', 'Toba', 'Marga Toba', 'Toba'),
('Tampubolon', 'Toba', 'Marga Toba', 'Toba'),
('Tanjung', 'Toba', 'Marga Toba', 'Toba'),
('Togatorop', 'Toba', 'Marga Toba', 'Toba'),
('Tumanggor', 'Toba', 'Marga Toba', 'Toba'),
-- Karo
('Sinuraya', 'Karo', 'Marga dari Karo', 'Karo'),
('Barus', 'Karo', 'Marga Karo', 'Karo'),
('Ginting', 'Karo', 'Marga Karo', 'Karo'),
('Tarigan', 'Karo', 'Marga Karo', 'Karo'),
('Sitepu', 'Karo', 'Marga Karo', 'Karo'),
('Karo-karo', 'Karo', 'Marga Karo', 'Karo'),
('Girsang', 'Karo', 'Marga Karo', 'Karo'),
('Surbakti', 'Karo', 'Marga Karo', 'Karo'),
('Kembaren', 'Karo', 'Marga Karo', 'Karo'),
('Peranginangin', 'Karo', 'Marga Karo', 'Karo'),
('Sebastian', 'Karo', 'Marga Karo', 'Karo'),
('Bangun', 'Karo', 'Marga Karo', 'Karo'),
('Sembiring', 'Karo', 'Marga Karo', 'Karo'),
('Tekan', 'Karo', 'Marga Karo', 'Karo'),
-- Simalungun
('Purba', 'Simalungun', 'Marga Simalungun', 'Simalungun'),
('Damanik', 'Simalungun', 'Marga Simalungun', 'Simalungun'),
('Saragih', 'Simalungun', 'Marga Simalungun', 'Simalungun'),
('Tamba', 'Simalungun', 'Marga Simalungun', 'Simalungun'),
('Manurung', 'Simalungun', 'Marga Simalungun', 'Simalungun'),
-- Mandailing
('Hutasoit', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Nasution', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Lubis', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Harahap', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Pulungan', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Batubara', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Hasibuan', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Rangkuti', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Parinduri', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
('Erdin', 'Mandailing', 'Marga Mandailing', 'Mandailing'),
-- Angkola
('Daulay', 'Angkola', 'Marga Angkola', 'Angkola'),
-- Pakpak
('Beringin', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Capah', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Kabeaken', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Mungkur', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Tinambunan', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Berutu', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Solin', 'Pakpak', 'Marga Pakpak', 'Pakpak'),
('Maibang', 'Pakpak', 'Marga Pakpak', 'Pakpak');

-- Insert sample Persons (family tree)
INSERT INTO persons (nama, marga_id, jenis_kelamin, tanggal_lahir, tempat_lahir) VALUES
('John Simanjuntak', 1, 'L', '1950-01-15', 'Medan'),
('Mary Simanjuntak', 1, 'P', '1952-03-20', 'Medan'),
('Robert Simanjuntak', 1, 'L', '1975-05-10', 'Jakarta'),
('Sarah Simanjuntak', 1, 'P', '1978-07-25', 'Jakarta'),
('Michael Simanjuntak', 1, 'L', '1980-09-30', 'Bandung'),
('Emily Marbun', 2, 'P', '1977-11-15', 'Surabaya'),
('David Marbun', 2, 'L', '1979-02-28', 'Surabaya'),
('Alice Marbun', 2, 'P', '2005-04-10', 'Jakarta'),
('Charlie Marbun', 2, 'L', '2008-06-20', 'Jakarta'),
('Emma Simanjuntak', 1, 'P', '2006-08-15', 'Bandung');

-- Set relationships (father/mother)
UPDATE persons SET father_id = 1, mother_id = 2 WHERE id IN (3, 4, 5);
UPDATE persons SET father_id = 1, mother_id = 2 WHERE id = 10;
UPDATE persons SET father_id = 3, mother_id = 6 WHERE id IN (8, 9);

-- Insert sample Marriage
INSERT INTO marriages (husband_id, wife_id, tanggal_perkawinan, hula_hula_marga_id, boru_marga_id) VALUES
(3, 6, '2000-12-15', 2, 1);

-- Insert sample User
INSERT INTO users (email, password, nama, role, person_id) VALUES
('admin@tarombo.digital', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin', NULL),
('john@tarombo.digital', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Simanjuntak', 'verified', 1);
