-- Tarombo Digital Database Schema
-- MySQL 8.0+

-- Create database
CREATE DATABASE IF NOT EXISTS tarombo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
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
