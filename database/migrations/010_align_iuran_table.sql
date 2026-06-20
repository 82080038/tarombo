-- Migration 010: Align iuran table to schema_updated.sql
-- The actual DB has different columns than schema_updated.sql
-- This migration adds missing columns and fixes the status enum

-- Add missing columns
ALTER TABLE `iuran` 
  ADD COLUMN IF NOT EXISTS `jenis_iuran` VARCHAR(100) NOT NULL DEFAULT 'bulanan' COMMENT 'bulanan, saur matua, acara, dll' AFTER `person_id`,
  ADD COLUMN IF NOT EXISTS `verified_by` INT NULL AFTER `status`,
  ADD COLUMN IF NOT EXISTS `verified_at` TIMESTAMP NULL DEFAULT NULL AFTER `verified_by`,
  ADD COLUMN IF NOT EXISTS `keterangan` TEXT NULL AFTER `verified_at`;

-- Change status enum from ('lunas','belum','terlambat') to ('pending','verified','rejected')
ALTER TABLE `iuran` 
  MODIFY COLUMN `status` ENUM('pending','verified','rejected') DEFAULT 'pending';

-- Migrate old status values to new ones
UPDATE `iuran` SET `status` = 'pending' WHERE `status` = 'belum';
UPDATE `iuran` SET `status` = 'verified' WHERE `status` = 'lunas';
UPDATE `iuran` SET `status` = 'rejected' WHERE `status` = 'terlambat';

-- Add index on jenis_iuran
CREATE INDEX IF NOT EXISTS `idx_iuran_jenis` ON `iuran` (`jenis_iuran`);

-- Add foreign key for verified_by
SET @fk_exists = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'iuran' AND CONSTRAINT_NAME = 'fk_iuran_verified_by');
SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE iuran ADD CONSTRAINT fk_iuran_verified_by FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
