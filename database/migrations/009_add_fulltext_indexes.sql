-- Migration 009: Add FULLTEXT search indexes
-- Improves search performance for persons and marga tables

-- Fulltext index on persons table
ALTER TABLE `persons` 
  ADD FULLTEXT INDEX IF NOT EXISTS `ft_persons_nama` (`nama`, `tempat_lahir`);

-- Fulltext index on marga table
ALTER TABLE `marga` 
  ADD FULLTEXT INDEX IF NOT EXISTS `ft_marga_nama` (`nama`, `asal_usul`, `deskripsi`);

-- Additional indexes for frequently queried FK columns
CREATE INDEX IF NOT EXISTS `idx_transactions_punguan` ON `transactions` (`punguan_id`);
CREATE INDEX IF NOT EXISTS `idx_transactions_person` ON `transactions` (`person_id`);
CREATE INDEX IF NOT EXISTS `idx_transactions_status` ON `transactions` (`status`);
CREATE INDEX IF NOT EXISTS `idx_budgets_punguan` ON `budgets` (`punguan_id`);
CREATE INDEX IF NOT EXISTS `idx_budgets_tahun` ON `budgets` (`tahun`);
CREATE INDEX IF NOT EXISTS `idx_assets_marga` ON `assets` (`marga_id`);
CREATE INDEX IF NOT EXISTS `idx_assets_pemilik` ON `assets` (`pemilik_saat_ini_id`);
CREATE INDEX IF NOT EXISTS `idx_assets_status` ON `assets` (`status`);
