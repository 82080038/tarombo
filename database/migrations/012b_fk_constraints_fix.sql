-- Migration 012b: Continue FK constraints (fix for NOT NULL columns)
-- Run after 012 partially failed on inheritance_records

-- messages -> persons (pengirim, penerima), self-reference parent
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='messages' AND CONSTRAINT_NAME='fk_messages_pengirim');
SET @sql = IF(@fk=0, 'ALTER TABLE messages ADD CONSTRAINT fk_messages_pengirim FOREIGN KEY (pengirim_id) REFERENCES users(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='messages' AND CONSTRAINT_NAME='fk_messages_penerima');
SET @sql = IF(@fk=0, 'ALTER TABLE messages ADD CONSTRAINT fk_messages_penerima FOREIGN KEY (penerima_id) REFERENCES users(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- rumah_keluarga -> persons
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='rumah_keluarga' AND CONSTRAINT_NAME='fk_rumah_keluarga_person');
SET @sql = IF(@fk=0, 'ALTER TABLE rumah_keluarga ADD CONSTRAINT fk_rumah_keluarga_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE RESTRICT', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- transactions -> documents (bukti_dokumen_id)
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='transactions' AND CONSTRAINT_NAME='fk_transactions_bukti_dokumen');
SET @sql = IF(@fk=0, 'ALTER TABLE transactions ADD CONSTRAINT fk_transactions_bukti_dokumen FOREIGN KEY (bukti_dokumen_id) REFERENCES documents(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- Add updated_at columns
ALTER TABLE `iuran` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `transactions` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `budgets` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `assets` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `inheritance_records` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
