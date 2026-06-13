-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: tarombo
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action` enum('CREATE','UPDATE','DELETE') NOT NULL,
  `entity_type` varchar(100) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `performed_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_action` (`action`),
  KEY `idx_performed_by` (`performed_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ceremonies`
--

DROP TABLE IF EXISTS `ceremonies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ceremonies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ceremony_type` enum('MARRIAGE','DEATH_SAUR_MATUA','BIRTH','OTHER') NOT NULL,
  `ceremony_name` varchar(255) NOT NULL,
  `marriage_id` int(11) DEFAULT NULL,
  `ceremony_date` date DEFAULT NULL,
  `ceremony_location` varchar(255) DEFAULT NULL,
  `raja_parhata_id` int(11) DEFAULT NULL COMMENT 'ID person yang menjadi Raja Parhata',
  `hula_hula_marga_id` int(11) DEFAULT NULL,
  `boru_marga_id` int(11) DEFAULT NULL,
  `status` enum('PLANNED','ONGOING','COMPLETED','CANCELLED') DEFAULT 'PLANNED',
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `marriage_id` (`marriage_id`),
  KEY `raja_parhata_id` (`raja_parhata_id`),
  KEY `hula_hula_marga_id` (`hula_hula_marga_id`),
  KEY `boru_marga_id` (`boru_marga_id`),
  KEY `idx_type` (`ceremony_type`),
  KEY `idx_status` (`status`),
  KEY `idx_date` (`ceremony_date`),
  CONSTRAINT `ceremonies_ibfk_1` FOREIGN KEY (`marriage_id`) REFERENCES `marriages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ceremonies_ibfk_2` FOREIGN KEY (`raja_parhata_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ceremonies_ibfk_3` FOREIGN KEY (`hula_hula_marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ceremonies_ibfk_4` FOREIGN KEY (`boru_marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_type` enum('photo','video','audio','pdf','other') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_size` int(11) DEFAULT NULL COMMENT 'bytes',
  `mime_type` varchar(100) DEFAULT NULL,
  `access_level` enum('public','restricted','confidential') DEFAULT 'public',
  `person_id` int(11) DEFAULT NULL COMMENT 'If related to a person',
  `ceremony_id` int(11) DEFAULT NULL COMMENT 'If related to a ceremony',
  `punguan_id` int(11) DEFAULT NULL,
  `uploaded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ceremony_id` (`ceremony_id`),
  KEY `punguan_id` (`punguan_id`),
  KEY `uploaded_by` (`uploaded_by`),
  KEY `idx_type` (`document_type`),
  KEY `idx_access` (`access_level`),
  KEY `idx_person` (`person_id`),
  CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`ceremony_id`) REFERENCES `ceremonies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `documents_ibfk_3` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE SET NULL,
  CONSTRAINT `documents_ibfk_4` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forbidden_marga_pairs`
--

DROP TABLE IF EXISTS `forbidden_marga_pairs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forbidden_marga_pairs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marga_a_id` int(11) NOT NULL,
  `marga_b_id` int(11) NOT NULL,
  `reason` text NOT NULL,
  `rule_reference` varchar(50) NOT NULL DEFAULT 'BR-PRK-007',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_pair` (`marga_a_id`,`marga_b_id`),
  KEY `idx_marga_a` (`marga_a_id`),
  KEY `idx_marga_b` (`marga_b_id`),
  CONSTRAINT `forbidden_marga_pairs_ibfk_1` FOREIGN KEY (`marga_a_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE,
  CONSTRAINT `forbidden_marga_pairs_ibfk_2` FOREIGN KEY (`marga_b_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `iuran`
--

DROP TABLE IF EXISTS `iuran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iuran` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `punguan_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `jenis_iuran` varchar(100) NOT NULL COMMENT 'bulanan, saur matua, acara, dll',
  `jumlah` decimal(15,2) NOT NULL,
  `periode` varchar(50) DEFAULT NULL COMMENT '2026-06',
  `status` enum('pending','verified','rejected') DEFAULT 'pending',
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `verified_by` (`verified_by`),
  KEY `idx_punguan` (`punguan_id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `iuran_ibfk_1` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `iuran_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `iuran_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `makam`
--

DROP TABLE IF EXISTS `makam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `makam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) DEFAULT NULL COMMENT 'Person buried here',
  `nama_makam` varchar(255) NOT NULL COMMENT 'Nama yang dimakamkan',
  `lokasi` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `foto_path` varchar(500) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `riwayat_perawatan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Array of maintenance records' CHECK (json_valid(`riwayat_perawatan`)),
  `jalur_ziarah` text DEFAULT NULL COMMENT 'Directions for pilgrimage',
  `verified_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `verified_by` (`verified_by`),
  KEY `idx_person` (`person_id`),
  KEY `idx_lokasi` (`lokasi`),
  CONSTRAINT `makam_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `makam_ibfk_2` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marga`
--

DROP TABLE IF EXISTS `marga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marga` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `sub_suku` enum('Toba','Karo','Simalungun','Mandailing','Angkola','Pakpak') NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `asal_usul` text DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL COMMENT 'Induk marga (hierarki)',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`),
  KEY `idx_sub_suku` (`sub_suku`),
  KEY `idx_status` (`status`),
  KEY `idx_parent` (`parent_id`),
  CONSTRAINT `marga_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marga_hierarchy`
--

DROP TABLE IF EXISTS `marga_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marga_hierarchy` (
  `ancestor_id` int(11) NOT NULL COMMENT 'ID marga induk (ancestor)',
  `descendant_id` int(11) NOT NULL COMMENT 'ID marga turunan (descendant)',
  `depth` int(11) NOT NULL DEFAULT 0 COMMENT 'Jarak hierarki (0 = self)',
  PRIMARY KEY (`ancestor_id`,`descendant_id`),
  KEY `idx_ancestor` (`ancestor_id`),
  KEY `idx_descendant` (`descendant_id`),
  KEY `idx_depth` (`depth`),
  CONSTRAINT `marga_hierarchy_ibfk_1` FOREIGN KEY (`ancestor_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE,
  CONSTRAINT `marga_hierarchy_ibfk_2` FOREIGN KEY (`descendant_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marriage_stages`
--

DROP TABLE IF EXISTS `marriage_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marriage_stages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marriage_id` int(11) NOT NULL,
  `stage_name` enum('Mangarisika','Martumpol','Martonggo Raja','Marsibuha Buhai','Pemberkatan','Mangulosi','Paulak Une') NOT NULL,
  `stage_order` int(11) NOT NULL COMMENT '1=Mangarisika ... 7=Paulak Une',
  `status` enum('pending','completed','skipped') DEFAULT 'pending',
  `stage_date` date DEFAULT NULL,
  `stage_location` varchar(255) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'witnesses, notes, etc' CHECK (json_valid(`details`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_marriage_stage` (`marriage_id`,`stage_name`),
  KEY `idx_marriage` (`marriage_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `marriage_stages_ibfk_1` FOREIGN KEY (`marriage_id`) REFERENCES `marriages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `marriages`
--

DROP TABLE IF EXISTS `marriages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marriages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `husband_id` int(11) NOT NULL,
  `wife_id` int(11) NOT NULL,
  `tanggal_perkawinan` date DEFAULT NULL,
  `tempat_perkawinan` varchar(255) DEFAULT NULL,
  `status` enum('active','divorced','widowed') DEFAULT 'active',
  `hula_hula_marga_id` int(11) DEFAULT NULL COMMENT 'Pihak pemberi perempuan',
  `boru_marga_id` int(11) DEFAULT NULL COMMENT 'Pihak menerima perempuan',
  `created_by` int(11) DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_marriage` (`husband_id`,`wife_id`),
  KEY `hula_hula_marga_id` (`hula_hula_marga_id`),
  KEY `boru_marga_id` (`boru_marga_id`),
  KEY `idx_husband` (`husband_id`),
  KEY `idx_wife` (`wife_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `marriages_ibfk_1` FOREIGN KEY (`husband_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `marriages_ibfk_2` FOREIGN KEY (`wife_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE,
  CONSTRAINT `marriages_ibfk_3` FOREIGN KEY (`hula_hula_marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marriages_ibfk_4` FOREIGN KEY (`boru_marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_locations`
--

DROP TABLE IF EXISTS `person_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `person_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `person_id` int(11) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `address_detail` text DEFAULT NULL,
  `location_type` enum('birth','current','hometown','work') DEFAULT 'current',
  `is_primary` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_lokasi` (`lokasi`),
  CONSTRAINT `person_locations_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `marga_id` int(11) NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `father_id` int(11) DEFAULT NULL,
  `mother_id` int(11) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `tempat_lahir` varchar(255) DEFAULT NULL,
  `tanggal_meninggal` date DEFAULT NULL,
  `status` enum('active','deleted') DEFAULT 'active',
  `created_by` int(11) DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_father` (`father_id`),
  KEY `idx_mother` (`mother_id`),
  KEY `idx_status` (`status`),
  KEY `idx_nama` (`nama`),
  KEY `idx_jenis_kelamin` (`jenis_kelamin`),
  CONSTRAINT `persons_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`),
  CONSTRAINT `persons_ibfk_2` FOREIGN KEY (`father_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `persons_ibfk_3` FOREIGN KEY (`mother_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `punguan`
--

DROP TABLE IF EXISTS `punguan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `punguan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `marga_id` int(11) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `kota` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `ketua_id` int(11) DEFAULT NULL COMMENT 'ID person ketua punguan',
  `wakil_ketua_id` int(11) DEFAULT NULL,
  `sekretaris_id` int(11) DEFAULT NULL,
  `bendahara_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ketua_id` (`ketua_id`),
  KEY `wakil_ketua_id` (`wakil_ketua_id`),
  KEY `sekretaris_id` (`sekretaris_id`),
  KEY `bendahara_id` (`bendahara_id`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `punguan_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE,
  CONSTRAINT `punguan_ibfk_2` FOREIGN KEY (`ketua_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `punguan_ibfk_3` FOREIGN KEY (`wakil_ketua_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `punguan_ibfk_4` FOREIGN KEY (`sekretaris_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `punguan_ibfk_5` FOREIGN KEY (`bendahara_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `punguan_members`
--

DROP TABLE IF EXISTS `punguan_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `punguan_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `punguan_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `role` enum('member','pengurus','ketua_cabang') DEFAULT 'member',
  `join_date` date DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member` (`punguan_id`,`person_id`),
  KEY `idx_punguan` (`punguan_id`),
  KEY `idx_person` (`person_id`),
  CONSTRAINT `punguan_members_ibfk_1` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `punguan_members_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `role` enum('guest','user','verified','tetua','admin') DEFAULT 'user',
  `person_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `person_id` (`person_id`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-14  3:59:31
