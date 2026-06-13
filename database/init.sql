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
    parent_id INT NULL COMMENT 'Induk marga (hierarki)',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES marga(id) ON DELETE SET NULL,
    INDEX idx_sub_suku (sub_suku),
    INDEX idx_status (status),
    INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Marga Hierarchy table (Closure Table Pattern)
-- This table stores all ancestor-descendant relationships for efficient hierarchy queries
CREATE TABLE marga_hierarchy (
    ancestor_id INT NOT NULL COMMENT 'ID marga induk (ancestor)',
    descendant_id INT NOT NULL COMMENT 'ID marga turunan (descendant)',
    depth INT NOT NULL DEFAULT 0 COMMENT 'Jarak hierarki (0 = self)',
    PRIMARY KEY (ancestor_id, descendant_id),
    FOREIGN KEY (ancestor_id) REFERENCES marga(id) ON DELETE CASCADE,
    FOREIGN KEY (descendant_id) REFERENCES marga(id) ON DELETE CASCADE,
    INDEX idx_ancestor (ancestor_id),
    INDEX idx_descendant (descendant_id),
    INDEX idx_depth (depth)
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

-- Insert Marga (Clans) - Updated with hierarchical structure
-- Root marga (no parent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Si Raja Batak', 'Toba', 'Induk utama semua marga Batak', 'Sianjur Mulamula', NULL),
('Guru Tatea Bulan', 'Toba', 'Anak Si Raja Batak', 'Toba', 1),
('Raja Isumbaon', 'Toba', 'Anak Guru Tatea Bulan', 'Toba', 2),
('Tuan Sariburaja', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Limbong Mulana', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Sagala Raja', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Silau Raja', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Raja Lontung', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Raja Borbor', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Raja Galeman', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3),
('Raja Oloan', 'Toba', 'Anak Raja Isumbaon', 'Toba', 3);

-- Tuan Sariburaja descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Pasaribu', 'Toba', 'Turunan Tuan Sariburaja', 'Toba', 4),
('Batubara', 'Toba', 'Turunan Tuan Sariburaja', 'Toba', 4),
('Parapat', 'Toba', 'Turunan Tuan Sariburaja', 'Toba', 4),
('Matondang', 'Toba', 'Turunan Tuan Sariburaja', 'Toba', 4);

-- Sagala Raja descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Harahap', 'Toba', 'Turunan Sagala Raja', 'Toba', 6),
('Tanjung', 'Toba', 'Turunan Sagala Raja', 'Toba', 6);

-- Silau Raja descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Pulungan', 'Toba', 'Turunan Silau Raja', 'Toba', 7),
('Lubis', 'Toba', 'Turunan Silau Raja', 'Toba', 7);

-- Raja Lontung descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Situmorang', 'Toba', 'Turunan Raja Lontung', 'Toba', 8),
('Sinaga', 'Toba', 'Turunan Raja Lontung', 'Toba', 8),
('Pandiangan', 'Toba', 'Turunan Raja Lontung', 'Toba', 8),
('Nainggolan', 'Toba', 'Turunan Raja Lontung', 'Toba', 8),
('Aritonang', 'Toba', 'Turunan Raja Lontung', 'Toba', 8);

-- Situmorang descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Lumban Pande', 'Toba', 'Turunan Situmorang', 'Toba', 21),
('Lumban Nahor', 'Toba', 'Turunan Situmorang', 'Toba', 21),
('Siringoringo', 'Toba', 'Turunan Situmorang', 'Toba', 21),
('Lumban Toruan', 'Toba', 'Turunan Situmorang', 'Toba', 21);

-- Sinaga descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Bonor', 'Toba', 'Turunan Sinaga', 'Toba', 22);

-- Pandiangan descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Toga Pande', 'Toba', 'Turunan Pandiangan', 'Toba', 23),
('Lumban Uruk', 'Toba', 'Turunan Pandiangan', 'Toba', 23);

-- Nainggolan descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Lumban Tungkup', 'Toba', 'Turunan Nainggolan', 'Toba', 24),
('Lumban Raja', 'Toba', 'Turunan Nainggolan', 'Toba', 24),
('Huta Balian', 'Toba', 'Turunan Nainggolan', 'Toba', 24),
('Lumban Siantar', 'Toba', 'Turunan Nainggolan', 'Toba', 24);

-- Aritonang descendants
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Ompu Sunggu', 'Toba', 'Turunan Aritonang', 'Toba', 25),
('Rajagukguk', 'Toba', 'Turunan Aritonang', 'Toba', 25),
('Simaremare', 'Toba', 'Turunan Aritonang', 'Toba', 25);

-- Raja Oloan descendants (Huta group)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Hutagalung', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutapea', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutajulu', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutabarat', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutabalian', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutagaol', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutahaean', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutatoruan', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutauruk', 'Toba', 'Turunan Raja Oloan', 'Toba', 11),
('Hutasuhut', 'Toba', 'Turunan Raja Oloan', 'Toba', 11);

-- Other Toba marga (independent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Simanjuntak', 'Toba', 'Salah satu marga besar di Toba', 'Toba Samosir', NULL),
('Marbun', 'Toba', 'Marga dengan cabang-cabang yang banyak', 'Toba', NULL),
('Sihotang', 'Toba', 'Marga yang tersebar di berbagai daerah', 'Toba', NULL),
('Siregar', 'Toba', 'Marga besar di Toba', 'Toba', NULL),
('Pardede', 'Toba', 'Marga dari daerah Toba', 'Toba', NULL),
('Gultom', 'Toba', 'Marga di Toba', 'Toba', NULL),
('Lumbantobing', 'Toba', 'Marga Toba', 'Toba', NULL),
('Panjaitan', 'Toba', 'Marga Toba yang besar', 'Toba', NULL),
('Panggabean', 'Toba', 'Marga Toba', 'Toba', NULL),
('Pangaribuan', 'Toba', 'Marga Toba', 'Toba', NULL),
('Pardosi', 'Toba', 'Marga Toba', 'Toba', NULL),
('Parhusip', 'Toba', 'Marga Toba', 'Toba', NULL),
('Nababan', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sihombing', 'Toba', 'Marga Toba', 'Toba', NULL),
('Tambunan', 'Toba', 'Marga Toba', 'Toba', NULL),
('Lumbangaol', 'Toba', 'Marga Toba', 'Toba', NULL),
('Lumbantoruan', 'Toba', 'Marga Toba', 'Toba', NULL),
('Lumbanraja', 'Toba', 'Marga Toba', 'Toba', NULL),
('Lumbanbatu', 'Toba', 'Marga Toba', 'Toba', NULL),
('Manalu', 'Toba', 'Marga Toba', 'Toba', NULL),
('Munte', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sagala', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sibuea', 'Toba', 'Marga Toba', 'Toba', NULL),
('Silitonga', 'Toba', 'Marga Toba', 'Toba', NULL),
('Simanullang', 'Toba', 'Marga Toba', 'Toba', NULL),
('Simarmata', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sinurat', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sirait', 'Toba', 'Marga Toba', 'Toba', NULL),
('Sormin', 'Toba', 'Marga Toba', 'Toba', NULL),
('Tampubolon', 'Toba', 'Marga Toba', 'Toba', NULL),
('Togatorop', 'Toba', 'Marga Toba', 'Toba', NULL),
('Tumanggor', 'Toba', 'Marga Toba', 'Toba', NULL);

-- Karo marga (independent - different lineage)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Sinuraya', 'Karo', 'Marga dari Karo', 'Karo', NULL),
('Barus', 'Karo', 'Marga Karo', 'Karo', NULL),
('Ginting', 'Karo', 'Marga Karo', 'Karo', NULL),
('Tarigan', 'Karo', 'Marga Karo', 'Karo', NULL),
('Sitepu', 'Karo', 'Marga Karo', 'Karo', NULL),
('Karo-karo', 'Karo', 'Marga Karo', 'Karo', NULL),
('Girsang', 'Karo', 'Marga Karo', 'Karo', NULL),
('Surbakti', 'Karo', 'Marga Karo', 'Karo', NULL),
('Kembaren', 'Karo', 'Marga Karo', 'Karo', NULL),
('Peranginangin', 'Karo', 'Marga Karo', 'Karo', NULL),
('Sebastian', 'Karo', 'Marga Karo', 'Karo', NULL),
('Bangun', 'Karo', 'Marga Karo', 'Karo', NULL),
('Sembiring', 'Karo', 'Marga Karo', 'Karo', NULL),
('Tekan', 'Karo', 'Marga Karo', 'Karo', NULL);

-- Simalungun marga (independent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Purba', 'Simalungun', 'Marga Simalungun', 'Simalungun', NULL),
('Damanik', 'Simalungun', 'Marga Simalungun', 'Simalungun', NULL),
('Saragih', 'Simalungun', 'Marga Simalungun', 'Simalungun', NULL),
('Tamba', 'Simalungun', 'Marga Simalungun', 'Simalungun', NULL),
('Manurung', 'Simalungun', 'Marga Simalungun', 'Simalungun', NULL);

-- Mandailing marga (independent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Hutasoit', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL),
('Nasution', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL),
('Hasibuan', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL),
('Rangkuti', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL),
('Parinduri', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL),
('Erdin', 'Mandailing', 'Marga Mandailing', 'Mandailing', NULL);

-- Angkola marga (independent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Daulay', 'Angkola', 'Marga Angkola', 'Angkola', NULL);

-- Pakpak marga (independent)
INSERT INTO marga (nama, sub_suku, deskripsi, asal_usul, parent_id) VALUES
('Beringin', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Capah', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Kabeaken', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Mungkur', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Tinambunan', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Berutu', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Solin', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL),
('Maibang', 'Pakpak', 'Marga Pakpak', 'Pakpak', NULL);

-- Populate marga_hierarchy table (Closure Table Pattern)
-- Insert self-references (depth = 0)
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT id, id, 0 FROM marga;

-- Insert direct parent-child relationships (depth = 1)
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT parent_id, id, 1 FROM marga WHERE parent_id IS NOT NULL;

-- Insert deeper relationships recursively
-- This will populate all ancestor-descendant relationships
INSERT INTO marga_hierarchy (ancestor_id, descendant_id, depth)
SELECT 
    p.ancestor_id,
    c.descendant_id,
    p.depth + c.depth AS depth
FROM marga_hierarchy AS p
JOIN marga_hierarchy AS c ON p.descendant_id = c.ancestor_id
WHERE c.depth > 0
AND NOT EXISTS (
    SELECT 1 FROM marga_hierarchy AS h 
    WHERE h.ancestor_id = p.ancestor_id AND h.descendant_id = c.descendant_id
);

-- Insert sample Persons (family tree)
INSERT INTO persons (nama, marga_id, jenis_kelamin, tanggal_lahir, tempat_lahir) VALUES
('John Simanjuntak', 32, 'L', '1950-01-15', 'Medan'),
('Mary Simanjuntak', 32, 'P', '1952-03-20', 'Medan'),
('Robert Simanjuntak', 32, 'L', '1975-05-10', 'Jakarta'),
('Sarah Simanjuntak', 32, 'P', '1978-07-25', 'Jakarta'),
('Michael Simanjuntak', 32, 'L', '1980-09-30', 'Bandung'),
('Emily Marbun', 33, 'P', '1977-11-15', 'Surabaya'),
('David Marbun', 33, 'L', '1979-02-28', 'Surabaya'),
('Alice Marbun', 33, 'P', '2005-04-10', 'Jakarta'),
('Charlie Marbun', 33, 'L', '2008-06-20', 'Jakarta'),
('Emma Simanjuntak', 32, 'P', '2006-08-15', 'Bandung');

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
