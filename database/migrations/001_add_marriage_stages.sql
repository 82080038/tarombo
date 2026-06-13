-- Migration: Add marriage stages and forbidden marga pairs
-- For Batak marriage ceremony tracking

USE tarombo;

-- Marriage stages table (7 Batak marriage stages)
CREATE TABLE marriage_stages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marriage_id INT NOT NULL,
    stage_name ENUM('Mangarisika', 'Martumpol', 'Martonggo Raja', 'Marsibuha Buhai', 'Pemberkatan', 'Mangulosi', 'Paulak Une') NOT NULL,
    stage_order INT NOT NULL COMMENT '1=Mangarisika ... 7=Paulak Une',
    status ENUM('pending', 'completed', 'skipped') DEFAULT 'pending',
    stage_date DATE NULL,
    stage_location VARCHAR(255) NULL,
    details JSON NULL COMMENT 'witnesses, notes, etc',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marriage_id) REFERENCES marriages(id) ON DELETE CASCADE,
    UNIQUE KEY unique_marriage_stage (marriage_id, stage_name),
    INDEX idx_marriage (marriage_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Forbidden marga pairs (marriage prohibition rules)
CREATE TABLE forbidden_marga_pairs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    marga_a_id INT NOT NULL,
    marga_b_id INT NOT NULL,
    reason TEXT NOT NULL,
    rule_reference VARCHAR(50) NOT NULL DEFAULT 'BR-PRK-007',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (marga_a_id) REFERENCES marga(id) ON DELETE CASCADE,
    FOREIGN KEY (marga_b_id) REFERENCES marga(id) ON DELETE CASCADE,
    UNIQUE KEY unique_pair (marga_a_id, marga_b_id),
    INDEX idx_marga_a (marga_a_id),
    INDEX idx_marga_b (marga_b_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample forbidden pairs (BR-PRK-007)
INSERT INTO forbidden_marga_pairs (marga_a_id, marga_b_id, reason, rule_reference) VALUES
(33, 34, 'Perkawinan Marbun - Sihotang dilarang menurut adat', 'BR-PRK-007'),
(35, 36, 'Perkawinan Nainggolan - Siregar dilarang menurut adat', 'BR-PRK-007');
