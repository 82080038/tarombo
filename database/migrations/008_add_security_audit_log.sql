-- Migration: Add security_audit_log table
-- Description: Comprehensive security audit logging for sensitive operations

CREATE TABLE IF NOT EXISTS security_audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL COMMENT 'Type of security event (API_ACCESS, SENSITIVE_OPERATION, LOGIN_ATTEMPT, etc.)',
    user_id INT NULL COMMENT 'User ID if authenticated',
    uri VARCHAR(500) NOT NULL COMMENT 'Request URI',
    method VARCHAR(10) NOT NULL COMMENT 'HTTP method (GET, POST, PUT, DELETE)',
    ip_address VARCHAR(45) NOT NULL COMMENT 'Client IP address',
    user_agent TEXT NULL COMMENT 'User agent string',
    metadata JSON NULL COMMENT 'Additional event metadata',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Event timestamp',
    
    INDEX idx_event_type (event_type),
    INDEX idx_user_id (user_id),
    INDEX idx_ip_address (ip_address),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Security audit log for monitoring sensitive operations';

-- Add created_by column to transactions table if not exists
ALTER TABLE transactions 
ADD COLUMN IF NOT EXISTS created_by INT NULL COMMENT 'User who created the transaction' AFTER bukti_dokumen_id,
ADD INDEX IF NOT EXISTS idx_created_by (created_by);

-- Add foreign key constraint for created_by (check if exists first)
SET @fk_exists = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'transactions' AND CONSTRAINT_NAME = 'fk_transactions_created_by');
SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE transactions ADD CONSTRAINT fk_transactions_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
