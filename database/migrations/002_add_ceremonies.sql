-- Migration: Add ceremonies table for Batak traditional events
USE tarombo;

CREATE TABLE ceremonies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ceremony_type ENUM('MARRIAGE', 'DEATH_SAUR_MATUA', 'BIRTH', 'OTHER') NOT NULL,
    ceremony_name VARCHAR(255) NOT NULL,
    marriage_id INT NULL,
    ceremony_date DATE NULL,
    ceremony_location VARCHAR(255) NULL,
    raja_parhata_id INT NULL COMMENT 'ID person yang menjadi Raja Parhata',
    hula_hula_marga_id INT NULL,
    boru_marga_id INT NULL,
    status ENUM('PLANNED', 'ONGOING', 'COMPLETED', 'CANCELLED') DEFAULT 'PLANNED',
    notes TEXT NULL,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marriage_id) REFERENCES marriages(id) ON DELETE SET NULL,
    FOREIGN KEY (raja_parhata_id) REFERENCES persons(id) ON DELETE SET NULL,
    FOREIGN KEY (hula_hula_marga_id) REFERENCES marga(id) ON DELETE SET NULL,
    FOREIGN KEY (boru_marga_id) REFERENCES marga(id) ON DELETE SET NULL,
    INDEX idx_type (ceremony_type),
    INDEX idx_status (status),
    INDEX idx_date (ceremony_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
