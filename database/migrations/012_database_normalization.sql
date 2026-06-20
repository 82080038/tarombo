-- Migration 012: Database normalization - add missing indexes and FK constraints
-- Addresses normalization issues found in audit

-- =============================================
-- Part 1: Add missing indexes on FK columns
-- =============================================

-- announcements
CREATE INDEX IF NOT EXISTS `idx_announcements_marga` ON `announcements` (`marga_id`);
CREATE INDEX IF NOT EXISTS `idx_announcements_pengirim` ON `announcements` (`pengirim_id`);
CREATE INDEX IF NOT EXISTS `idx_announcements_punguan` ON `announcements` (`punguan_id`);

-- entity_timeline
CREATE INDEX IF NOT EXISTS `idx_entity_timeline_related` ON `entity_timeline` (`related_entity_id`);

-- events
CREATE INDEX IF NOT EXISTS `idx_events_person` ON `events` (`person_id`);
CREATE INDEX IF NOT EXISTS `idx_events_punguan` ON `events` (`punguan_id`);

-- inheritance_records
CREATE INDEX IF NOT EXISTS `idx_inheritance_dokumen` ON `inheritance_records` (`dokumen_id`);
CREATE INDEX IF NOT EXISTS `idx_inheritance_pemilik_lama` ON `inheritance_records` (`pemilik_lama_id`);
CREATE INDEX IF NOT EXISTS `idx_inheritance_saksi` ON `inheritance_records` (`saksi_id`);

-- messages
CREATE INDEX IF NOT EXISTS `idx_messages_parent` ON `messages` (`parent_id`);

-- stories
CREATE INDEX IF NOT EXISTS `idx_stories_penulis` ON `stories` (`penulis_id`);
CREATE INDEX IF NOT EXISTS `idx_stories_person` ON `stories` (`person_id`);

-- tanah_ulayat
CREATE INDEX IF NOT EXISTS `idx_tanah_ulayat_pengelola` ON `tanah_ulayat` (`pengelola_id`);

-- transactions
CREATE INDEX IF NOT EXISTS `idx_transactions_bukti_dokumen` ON `transactions` (`bukti_dokumen_id`);

-- =============================================
-- Part 2: Add missing FK constraints
-- =============================================

-- We use conditional approach since MariaDB doesn't fully support ADD CONSTRAINT IF NOT EXISTS

-- announcements -> marga, users, punguan
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='announcements' AND CONSTRAINT_NAME='fk_announcements_marga');
SET @sql = IF(@fk=0, 'ALTER TABLE announcements ADD CONSTRAINT fk_announcements_marga FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='announcements' AND CONSTRAINT_NAME='fk_announcements_pengirim');
SET @sql = IF(@fk=0, 'ALTER TABLE announcements ADD CONSTRAINT fk_announcements_pengirim FOREIGN KEY (pengirim_id) REFERENCES users(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='announcements' AND CONSTRAINT_NAME='fk_announcements_punguan');
SET @sql = IF(@fk=0, 'ALTER TABLE announcements ADD CONSTRAINT fk_announcements_punguan FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- assets -> marga, persons
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='assets' AND CONSTRAINT_NAME='fk_assets_marga');
SET @sql = IF(@fk=0, 'ALTER TABLE assets ADD CONSTRAINT fk_assets_marga FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='assets' AND CONSTRAINT_NAME='fk_assets_pemilik');
SET @sql = IF(@fk=0, 'ALTER TABLE assets ADD CONSTRAINT fk_assets_pemilik FOREIGN KEY (pemilik_saat_ini_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- budgets -> punguan
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='budgets' AND CONSTRAINT_NAME='fk_budgets_punguan');
SET @sql = IF(@fk=0, 'ALTER TABLE budgets ADD CONSTRAINT fk_budgets_punguan FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- events -> persons, punguan
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='events' AND CONSTRAINT_NAME='fk_events_person');
SET @sql = IF(@fk=0, 'ALTER TABLE events ADD CONSTRAINT fk_events_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='events' AND CONSTRAINT_NAME='fk_events_punguan');
SET @sql = IF(@fk=0, 'ALTER TABLE events ADD CONSTRAINT fk_events_punguan FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- event_attendees -> events, persons
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='event_attendees' AND CONSTRAINT_NAME='fk_event_attendees_event');
SET @sql = IF(@fk=0, 'ALTER TABLE event_attendees ADD CONSTRAINT fk_event_attendees_event FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='event_attendees' AND CONSTRAINT_NAME='fk_event_attendees_person');
SET @sql = IF(@fk=0, 'ALTER TABLE event_attendees ADD CONSTRAINT fk_event_attendees_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- iuran -> punguan, persons
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='iuran' AND CONSTRAINT_NAME='fk_iuran_punguan');
SET @sql = IF(@fk=0, 'ALTER TABLE iuran ADD CONSTRAINT fk_iuran_punguan FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='iuran' AND CONSTRAINT_NAME='fk_iuran_person');
SET @sql = IF(@fk=0, 'ALTER TABLE iuran ADD CONSTRAINT fk_iuran_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- inheritance_records -> assets, persons (pemilik_lama, pemilik_baru, saksi)
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='inheritance_records' AND CONSTRAINT_NAME='fk_inheritance_asset');
SET @sql = IF(@fk=0, 'ALTER TABLE inheritance_records ADD CONSTRAINT fk_inheritance_asset FOREIGN KEY (asset_id) REFERENCES assets(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='inheritance_records' AND CONSTRAINT_NAME='fk_inheritance_pemilik_baru');
SET @sql = IF(@fk=0, 'ALTER TABLE inheritance_records ADD CONSTRAINT fk_inheritance_pemilik_baru FOREIGN KEY (pemilik_baru_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='inheritance_records' AND CONSTRAINT_NAME='fk_inheritance_pemilik_lama');
SET @sql = IF(@fk=0, 'ALTER TABLE inheritance_records ADD CONSTRAINT fk_inheritance_pemilik_lama FOREIGN KEY (pemilik_lama_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='inheritance_records' AND CONSTRAINT_NAME='fk_inheritance_saksi');
SET @sql = IF(@fk=0, 'ALTER TABLE inheritance_records ADD CONSTRAINT fk_inheritance_saksi FOREIGN KEY (saksi_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- notifications -> users
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='notifications' AND CONSTRAINT_NAME='fk_notifications_user');
SET @sql = IF(@fk=0, 'ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- stories -> marga, persons, users
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='stories' AND CONSTRAINT_NAME='fk_stories_marga');
SET @sql = IF(@fk=0, 'ALTER TABLE stories ADD CONSTRAINT fk_stories_marga FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='stories' AND CONSTRAINT_NAME='fk_stories_person');
SET @sql = IF(@fk=0, 'ALTER TABLE stories ADD CONSTRAINT fk_stories_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='stories' AND CONSTRAINT_NAME='fk_stories_penulis');
SET @sql = IF(@fk=0, 'ALTER TABLE stories ADD CONSTRAINT fk_stories_penulis FOREIGN KEY (penulis_id) REFERENCES users(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- transactions -> punguan, persons, documents
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='transactions' AND CONSTRAINT_NAME='fk_transactions_punguan');
SET @sql = IF(@fk=0, 'ALTER TABLE transactions ADD CONSTRAINT fk_transactions_punguan FOREIGN KEY (punguan_id) REFERENCES punguan(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='transactions' AND CONSTRAINT_NAME='fk_transactions_person');
SET @sql = IF(@fk=0, 'ALTER TABLE transactions ADD CONSTRAINT fk_transactions_person FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- tanah_ulayat -> marga, persons
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tanah_ulayat' AND CONSTRAINT_NAME='fk_tanah_ulayat_marga');
SET @sql = IF(@fk=0, 'ALTER TABLE tanah_ulayat ADD CONSTRAINT fk_tanah_ulayat_marga FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tanah_ulayat' AND CONSTRAINT_NAME='fk_tanah_ulayat_pengelola');
SET @sql = IF(@fk=0, 'ALTER TABLE tanah_ulayat ADD CONSTRAINT fk_tanah_ulayat_pengelola FOREIGN KEY (pengelola_id) REFERENCES persons(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- tanah_boundaries -> tanah_ulayat
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tanah_boundaries' AND CONSTRAINT_NAME='fk_tanah_boundaries_ulayat');
SET @sql = IF(@fk=0, 'ALTER TABLE tanah_boundaries ADD CONSTRAINT fk_tanah_boundaries_ulayat FOREIGN KEY (tanah_ulayat_id) REFERENCES tanah_ulayat(id) ON DELETE CASCADE', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- traditions -> marga
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='traditions' AND CONSTRAINT_NAME='fk_traditions_marga');
SET @sql = IF(@fk=0, 'ALTER TABLE traditions ADD CONSTRAINT fk_traditions_marga FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- security_audit_log -> users
SET @fk = (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='security_audit_log' AND CONSTRAINT_NAME='fk_security_audit_log_user');
SET @sql = IF(@fk=0, 'ALTER TABLE security_audit_log ADD CONSTRAINT fk_security_audit_log_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL', 'SELECT 1');
PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;

-- =============================================
-- Part 3: Add missing columns for consistency
-- =============================================

-- Add updated_at to tables that only have created_at
ALTER TABLE `iuran` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `transactions` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `budgets` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `assets` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
ALTER TABLE `inheritance_records` ADD COLUMN IF NOT EXISTS `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;
