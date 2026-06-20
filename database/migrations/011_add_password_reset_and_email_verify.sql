-- Migration 011: Add password_resets table and email_verified_at column
-- Required for password reset and email verification features

-- Password resets table
CREATE TABLE IF NOT EXISTS `password_resets` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `token` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_password_resets_email` (`email`),
    INDEX `idx_password_resets_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add email_verified_at to users if not exists
ALTER TABLE `users` 
  ADD COLUMN IF NOT EXISTS `email_verified_at` TIMESTAMP NULL DEFAULT NULL AFTER `role`;

-- Add email_verified_at to fillable in User model via migration comment
-- Model update is done in code, not SQL
