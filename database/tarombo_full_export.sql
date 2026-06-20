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
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `judul` varchar(255) NOT NULL,
  `konten` text NOT NULL,
  `tipe` enum('umum','punguan','marga','acara','lainnya') NOT NULL,
  `punguan_id` int(11) DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `pengirim_id` int(11) NOT NULL,
  `prioritas` enum('normal','penting','urgent') DEFAULT 'normal',
  `status` enum('draft','published','archived') DEFAULT 'draft',
  `tanggal_publish` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_status` (`status`),
  KEY `idx_tanggal` (`tanggal_publish`),
  KEY `idx_announcements_marga` (`marga_id`),
  KEY `idx_announcements_pengirim` (`pengirim_id`),
  KEY `idx_announcements_punguan` (`punguan_id`),
  CONSTRAINT `fk_announcements_marga` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_announcements_pengirim` FOREIGN KEY (`pengirim_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_announcements_punguan` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,'Undangan Rapat Tahunan','Diharapkan kehadiran seluruh anggota punguan Simanjuntak Jakarta pada tanggal 15 Desember 2026','punguan',1,NULL,1,'penting','published','2026-06-15 13:13:21','2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Undangan Rapat Tahunan','Diharapkan kehadiran seluruh anggota punguan Simanjuntak Jakarta pada tanggal 15 Desember 2026','punguan',1,NULL,1,'penting','published','2026-06-20 09:11:24','2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `tipe` enum('tanah','rumah','kendaraan','pusaka_adat','emas_perhiasan','tanaman','ternak','lainnya') NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `nilai_estimasi` decimal(15,2) DEFAULT NULL,
  `tanggal_perolehan` date DEFAULT NULL,
  `cara_perolehan` enum('warisan','beli','hadiah','hadiah_adat','lainnya') DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `foto_path` varchar(500) DEFAULT NULL,
  `status` enum('aktif','terjual','hilang','rusak','disewakan') DEFAULT 'aktif',
  `pemilik_saat_ini_id` int(11) DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_pemilik` (`pemilik_saat_ini_id`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_assets_marga` (`marga_id`),
  KEY `idx_assets_pemilik` (`pemilik_saat_ini_id`),
  KEY `idx_assets_status` (`status`),
  CONSTRAINT `fk_assets_marga` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_assets_pemilik` FOREIGN KEY (`pemilik_saat_ini_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'Tanah Pusaka Simanjuntak','tanah','Tanah warisan leluhur di Medan',500000000.00,'1950-01-01','warisan','Medan',NULL,NULL,NULL,'aktif',NULL,32,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Rumah Adat Batak','rumah','Rumah bolon tradisional',200000000.00,'1960-06-15','warisan','Tobasa',NULL,NULL,NULL,'aktif',NULL,1,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(3,'Ulos Batak','pusaka_adat','Koleksi ulos warisan keluarga',5000000.00,'1970-01-01','warisan',NULL,NULL,NULL,NULL,'aktif',NULL,32,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(4,'Tanah Pusaka Simanjuntak','tanah','Tanah warisan leluhur di Medan',500000000.00,'1950-01-01','warisan','Medan',NULL,NULL,NULL,'aktif',NULL,32,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(5,'Rumah Adat Batak','rumah','Rumah bolon tradisional',200000000.00,'1960-06-15','warisan','Tobasa',NULL,NULL,NULL,'aktif',NULL,1,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(6,'Ulos Batak','pusaka_adat','Koleksi ulos warisan keluarga',5000000.00,'1970-01-01','warisan',NULL,NULL,NULL,NULL,'aktif',NULL,32,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `budgets`
--

DROP TABLE IF EXISTS `budgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `budgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `punguan_id` int(11) NOT NULL,
  `tahun` int(11) NOT NULL,
  `kategori` varchar(100) NOT NULL,
  `anggaran` decimal(15,2) NOT NULL,
  `terpakai` decimal(15,2) DEFAULT 0.00,
  `deskripsi` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_budget` (`punguan_id`,`tahun`,`kategori`),
  KEY `idx_tahun` (`tahun`),
  KEY `idx_budgets_punguan` (`punguan_id`),
  KEY `idx_budgets_tahun` (`tahun`),
  CONSTRAINT `fk_budgets_punguan` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `budgets`
--

LOCK TABLES `budgets` WRITE;
/*!40000 ALTER TABLE `budgets` DISABLE KEYS */;
/*!40000 ALTER TABLE `budgets` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `ceremonies`
--

LOCK TABLES `ceremonies` WRITE;
/*!40000 ALTER TABLE `ceremonies` DISABLE KEYS */;
/*!40000 ALTER TABLE `ceremonies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cultural_sites`
--

DROP TABLE IF EXISTS `cultural_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cultural_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `tipe` varchar(50) NOT NULL COMMENT 'Type: makam_leluhur, situs_adat, tempat_suci, dll',
  `deskripsi` text DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `kota` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL COMMENT 'Person associated with this site',
  `sejarah` text DEFAULT NULL COMMENT 'Historical significance',
  `status_konservasi` enum('terjaga','terancam','rusak','hilang') DEFAULT 'terjaga',
  `foto_path` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `person_id` (`person_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_status` (`status_konservasi`),
  CONSTRAINT `cultural_sites_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`),
  CONSTRAINT `cultural_sites_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `cultural_sites_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultural_sites`
--

LOCK TABLES `cultural_sites` WRITE;
/*!40000 ALTER TABLE `cultural_sites` DISABLE KEYS */;
INSERT INTO `cultural_sites` VALUES (1,'Makam Si Singamangaraja','makam_leluhur','Makam pahlawan Batak terakhir','Desa Bakara','Bakara','Sumatera Utara',NULL,NULL,1,NULL,'Makam Si Singamangaraja XII yang gugur melawan Belanda','terjaga',NULL,NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(2,'Sianjur Mulamula','situs_adat','Tempat asal usul marga Batak','Desa Sianjur','Samosir','Sumatera Utara',NULL,NULL,1,NULL,'Tempat dianggap sebagai asal usul semua marga Batak','terjaga',NULL,NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(3,'Makam Si Singamangaraja','makam_leluhur','Makam pahlawan Batak terakhir','Desa Bakara','Bakara','Sumatera Utara',NULL,NULL,1,NULL,'Makam Si Singamangaraja XII yang gugur melawan Belanda','terjaga',NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'Sianjur Mulamula','situs_adat','Tempat asal usul marga Batak','Desa Sianjur','Samosir','Sumatera Utara',NULL,NULL,1,NULL,'Tempat dianggap sebagai asal usul semua marga Batak','terjaga',NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `cultural_sites` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_history`
--

DROP TABLE IF EXISTS `entity_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) NOT NULL COMMENT 'Type of entity (person, asset, tanah, event, etc.)',
  `entity_id` int(11) NOT NULL COMMENT 'ID of the entity being tracked',
  `action` enum('created','updated','deleted','transferred','published','archived') NOT NULL,
  `old_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Previous state of the entity' CHECK (json_valid(`old_data`)),
  `new_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'New state of the entity' CHECK (json_valid(`new_data`)),
  `changed_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'List of fields that changed' CHECK (json_valid(`changed_fields`)),
  `changed_by` int(11) DEFAULT NULL COMMENT 'User who made the change',
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reason` text DEFAULT NULL COMMENT 'Reason for the change',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP address of the user',
  `user_agent` text DEFAULT NULL COMMENT 'User agent string',
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_changed_by` (`changed_by`),
  KEY `idx_changed_at` (`changed_at`),
  KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entity_history`
--

LOCK TABLES `entity_history` WRITE;
/*!40000 ALTER TABLE `entity_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `entity_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_relationship_history`
--

DROP TABLE IF EXISTS `entity_relationship_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_relationship_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relationship_type` varchar(50) NOT NULL COMMENT 'Type of relationship (parent-child, owner-asset, etc.)',
  `from_entity_type` varchar(50) NOT NULL,
  `from_entity_id` int(11) NOT NULL,
  `to_entity_type` varchar(50) NOT NULL,
  `to_entity_id` int(11) NOT NULL,
  `action` enum('created','updated','deleted') NOT NULL,
  `old_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_data`)),
  `new_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_data`)),
  `changed_by` int(11) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reason` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_from_entity` (`from_entity_type`,`from_entity_id`),
  KEY `idx_to_entity` (`to_entity_type`,`to_entity_id`),
  KEY `idx_relationship` (`relationship_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entity_relationship_history`
--

LOCK TABLES `entity_relationship_history` WRITE;
/*!40000 ALTER TABLE `entity_relationship_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `entity_relationship_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_timeline`
--

DROP TABLE IF EXISTS `entity_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `event_type` varchar(50) NOT NULL COMMENT 'Type of event (birth, death, marriage, transfer, etc.)',
  `event_date` date NOT NULL,
  `event_description` text DEFAULT NULL,
  `event_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Additional event data' CHECK (json_valid(`event_data`)),
  `related_entity_type` varchar(50) DEFAULT NULL COMMENT 'Type of related entity',
  `related_entity_id` int(11) DEFAULT NULL COMMENT 'ID of related entity',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_event_date` (`event_date`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_entity_timeline_related` (`related_entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entity_timeline`
--

LOCK TABLES `entity_timeline` WRITE;
/*!40000 ALTER TABLE `entity_timeline` DISABLE KEYS */;
/*!40000 ALTER TABLE `entity_timeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entity_version`
--

DROP TABLE IF EXISTS `entity_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entity_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` int(11) NOT NULL,
  `version_number` int(11) NOT NULL,
  `version_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Complete entity state at this version' CHECK (json_valid(`version_data`)),
  `version_description` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_version` (`entity_type`,`entity_id`,`version_number`),
  KEY `idx_entity` (`entity_type`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entity_version`
--

LOCK TABLES `entity_version` WRITE;
/*!40000 ALTER TABLE `entity_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `entity_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_attendees`
--

DROP TABLE IF EXISTS `event_attendees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_attendees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `status` enum('hadir','tidak_hadir','ragu_ragu','menunggu') DEFAULT 'menunggu',
  `catatan` text DEFAULT NULL,
  `tanggal_respon` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_attendee` (`event_id`,`person_id`),
  KEY `idx_event` (`event_id`),
  KEY `idx_person` (`person_id`),
  CONSTRAINT `fk_event_attendees_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_event_attendees_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_attendees`
--

LOCK TABLES `event_attendees` WRITE;
/*!40000 ALTER TABLE `event_attendees` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_attendees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `tipe` enum('rapat_punguan','acara_adat','reuni_keluarga','pernikahan','kematian','ulang_tahun','lainnya') NOT NULL,
  `tanggal_mulai` datetime NOT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `punguan_id` int(11) DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `max_peserta` int(11) DEFAULT NULL,
  `status` enum('terjadwal','berlangsung','selesai','dibatalkan') DEFAULT 'terjadwal',
  `reminder_sent` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tanggal` (`tanggal_mulai`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_status` (`status`),
  KEY `idx_events_person` (`person_id`),
  KEY `idx_events_punguan` (`punguan_id`),
  CONSTRAINT `fk_events_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_events_punguan` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Rapat Tahunan Punguan Simanjuntak','Rapat evaluasi dan perencanaan tahunan punguan','rapat_punguan','2026-12-15 09:00:00','2026-12-15 15:00:00','Jakarta',NULL,NULL,1,NULL,NULL,'terjadwal',0,1,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Rapat Tahunan Punguan Simanjuntak','Rapat evaluasi dan perencanaan tahunan punguan','rapat_punguan','2026-12-15 09:00:00','2026-12-15 15:00:00','Jakarta',NULL,NULL,1,NULL,NULL,'terjadwal',0,1,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `forbidden_marga_pairs`
--

LOCK TABLES `forbidden_marga_pairs` WRITE;
/*!40000 ALTER TABLE `forbidden_marga_pairs` DISABLE KEYS */;
INSERT INTO `forbidden_marga_pairs` VALUES (1,33,34,'Perkawinan Marbun - Sihotang dilarang menurut adat','BR-PRK-007','2026-06-13 19:52:04'),(2,35,36,'Perkawinan Nainggolan - Siregar dilarang menurut adat','BR-PRK-007','2026-06-13 19:52:04');
/*!40000 ALTER TABLE `forbidden_marga_pairs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inheritance_records`
--

DROP TABLE IF EXISTS `inheritance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inheritance_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `pemilik_lama_id` int(11) DEFAULT NULL,
  `pemilik_baru_id` int(11) NOT NULL,
  `tanggal_transfer` date NOT NULL,
  `cara_transfer` enum('warisan_adat','hibah','jual_beli','tukar_menukar','lainnya') DEFAULT NULL,
  `alasan_transfer` text DEFAULT NULL,
  `saksi_id` int(11) DEFAULT NULL,
  `dokumen_id` int(11) DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_asset` (`asset_id`),
  KEY `idx_pemilik_baru` (`pemilik_baru_id`),
  KEY `idx_inheritance_dokumen` (`dokumen_id`),
  KEY `idx_inheritance_pemilik_lama` (`pemilik_lama_id`),
  KEY `idx_inheritance_saksi` (`saksi_id`),
  CONSTRAINT `fk_inheritance_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inheritance_pemilik_baru` FOREIGN KEY (`pemilik_baru_id`) REFERENCES `persons` (`id`),
  CONSTRAINT `fk_inheritance_pemilik_lama` FOREIGN KEY (`pemilik_lama_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_inheritance_saksi` FOREIGN KEY (`saksi_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inheritance_records`
--

LOCK TABLES `inheritance_records` WRITE;
/*!40000 ALTER TABLE `inheritance_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `inheritance_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `iuran`
--

DROP TABLE IF EXISTS `iuran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `iuran` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `punguan_id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `jenis_iuran` varchar(100) NOT NULL DEFAULT 'bulanan' COMMENT 'bulanan, saur matua, acara, dll',
  `jumlah` decimal(15,2) NOT NULL DEFAULT 0.00,
  `periode` enum('bulanan','tahunan','sekali') DEFAULT 'bulanan',
  `status` enum('pending','verified','rejected') DEFAULT 'pending',
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_bayar` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_punguan` (`punguan_id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_iuran_jenis` (`jenis_iuran`),
  KEY `fk_iuran_verified_by` (`verified_by`),
  CONSTRAINT `fk_iuran_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_iuran_punguan` FOREIGN KEY (`punguan_id`) REFERENCES `punguan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_iuran_verified_by` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `iuran`
--

LOCK TABLES `iuran` WRITE;
/*!40000 ALTER TABLE `iuran` DISABLE KEYS */;
/*!40000 ALTER TABLE `iuran` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `makam`
--

LOCK TABLES `makam` WRITE;
/*!40000 ALTER TABLE `makam` DISABLE KEYS */;
INSERT INTO `makam` VALUES (1,1,'John Simanjuntak','Taman Makam Pahlawan Medan',3.59520000,98.67210000,NULL,'Makam leluhur marga Simanjuntak',NULL,'Dari bandara menuju jalan Sisingamangaraja, belok kanan ke TMP',NULL,'2026-06-13 20:26:41','2026-06-13 20:26:41'),(2,6,'Emily Marbun','Taman Makam Keluarga Marbun, Medan',3.60000000,98.68000000,NULL,'Makam keluarga besar Marbun',NULL,'Dari pusat kota Medan, 15 menit ke arah barat',NULL,'2026-06-13 20:26:41','2026-06-13 20:26:41');
/*!40000 ALTER TABLE `makam` ENABLE KEYS */;
UNLOCK TABLES;

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
  FULLTEXT KEY `ft_marga_nama` (`nama`,`asal_usul`,`deskripsi`),
  CONSTRAINT `marga_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marga`
--

LOCK TABLES `marga` WRITE;
/*!40000 ALTER TABLE `marga` DISABLE KEYS */;
INSERT INTO `marga` VALUES (1,'Si Raja Batak','Toba','Induk utama semua marga Batak','Sianjur Mulamula',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(2,'Guru Tatea Bulan','Toba','Anak Si Raja Batak','Toba',1,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(3,'Raja Isumbaon','Toba','Anak Guru Tatea Bulan','Toba',2,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(4,'Tuan Sariburaja','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(5,'Limbong Mulana','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(6,'Sagala Raja','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(7,'Silau Raja','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(8,'Raja Lontung','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(9,'Raja Borbor','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(10,'Raja Galeman','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(11,'Raja Oloan','Toba','Anak Raja Isumbaon','Toba',3,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(12,'Pasaribu','Toba','Turunan Tuan Sariburaja','Toba',4,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(13,'Batubara','Toba','Turunan Tuan Sariburaja','Toba',4,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(14,'Parapat','Toba','Turunan Tuan Sariburaja','Toba',4,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(15,'Matondang','Toba','Turunan Tuan Sariburaja','Toba',4,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(16,'Harahap','Toba','Turunan Sagala Raja','Toba',6,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(17,'Tanjung','Toba','Turunan Sagala Raja','Toba',6,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(18,'Pulungan','Toba','Turunan Silau Raja','Toba',7,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(19,'Lubis','Toba','Turunan Silau Raja','Toba',7,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(20,'Situmorang','Toba','Turunan Raja Lontung','Toba',8,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(21,'Sinaga','Toba','Turunan Raja Lontung','Toba',8,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(22,'Pandiangan','Toba','Turunan Raja Lontung','Toba',8,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(23,'Nainggolan','Toba','Turunan Raja Lontung','Toba',8,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(24,'Aritonang','Toba','Turunan Raja Lontung','Toba',8,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(25,'Lumban Pande','Toba','Turunan Situmorang','Toba',21,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(26,'Lumban Nahor','Toba','Turunan Situmorang','Toba',21,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(27,'Siringoringo','Toba','Turunan Situmorang','Toba',21,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(28,'Lumban Toruan','Toba','Turunan Situmorang','Toba',21,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(29,'Bonor','Toba','Turunan Sinaga','Toba',22,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(30,'Toga Pande','Toba','Turunan Pandiangan','Toba',23,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(31,'Lumban Uruk','Toba','Turunan Pandiangan','Toba',23,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(32,'Lumban Tungkup','Toba','Turunan Nainggolan','Toba',24,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(33,'Lumban Raja','Toba','Turunan Nainggolan','Toba',24,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(34,'Huta Balian','Toba','Turunan Nainggolan','Toba',24,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(35,'Lumban Siantar','Toba','Turunan Nainggolan','Toba',24,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(36,'Ompu Sunggu','Toba','Turunan Aritonang','Toba',25,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(37,'Rajagukguk','Toba','Turunan Aritonang','Toba',25,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(38,'Simaremare','Toba','Turunan Aritonang','Toba',25,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(39,'Hutagalung','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(40,'Hutapea','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(41,'Hutajulu','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(42,'Hutabarat','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(43,'Hutabalian','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(44,'Hutagaol','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(45,'Hutahaean','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(46,'Hutatoruan','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(47,'Hutauruk','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(48,'Hutasuhut','Toba','Turunan Raja Oloan','Toba',11,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(49,'Simanjuntak','Toba','Salah satu marga besar di Toba','Toba Samosir',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(50,'Marbun','Toba','Marga dengan cabang-cabang yang banyak','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(51,'Sihotang','Toba','Marga yang tersebar di berbagai daerah','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(52,'Siregar','Toba','Marga besar di Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(53,'Pardede','Toba','Marga dari daerah Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(54,'Gultom','Toba','Marga di Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(55,'Lumbantobing','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(56,'Panjaitan','Toba','Marga Toba yang besar','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(57,'Panggabean','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(58,'Pangaribuan','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(59,'Pardosi','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(60,'Parhusip','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(61,'Nababan','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(62,'Sihombing','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(63,'Tambunan','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(64,'Lumbangaol','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(65,'Lumbantoruan','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(66,'Lumbanraja','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(67,'Lumbanbatu','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(68,'Manalu','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(69,'Munte','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(70,'Sagala','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(71,'Sibuea','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(72,'Silitonga','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(73,'Simanullang','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(74,'Simarmata','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(75,'Sinurat','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(76,'Sirait','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(77,'Sormin','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(78,'Tampubolon','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(79,'Togatorop','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(80,'Tumanggor','Toba','Marga Toba','Toba',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(81,'Sinuraya','Karo','Marga dari Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(82,'Barus','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(83,'Ginting','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(84,'Tarigan','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(85,'Sitepu','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(86,'Karo-karo','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(87,'Girsang','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(88,'Surbakti','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(89,'Kembaren','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(90,'Peranginangin','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(91,'Sebastian','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(92,'Bangun','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(93,'Sembiring','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(94,'Tekan','Karo','Marga Karo','Karo',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(95,'Purba','Simalungun','Marga Simalungun','Simalungun',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(96,'Damanik','Simalungun','Marga Simalungun','Simalungun',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(97,'Saragih','Simalungun','Marga Simalungun','Simalungun',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(98,'Tamba','Simalungun','Marga Simalungun','Simalungun',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(99,'Manurung','Simalungun','Marga Simalungun','Simalungun',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(100,'Hutasoit','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(101,'Nasution','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(102,'Hasibuan','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(103,'Rangkuti','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(104,'Parinduri','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(105,'Erdin','Mandailing','Marga Mandailing','Mandailing',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(106,'Daulay','Angkola','Marga Angkola','Angkola',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(107,'Beringin','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(108,'Capah','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(109,'Kabeaken','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(110,'Mungkur','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(111,'Tinambunan','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(112,'Berutu','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(113,'Solin','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49'),(114,'Maibang','Pakpak','Marga Pakpak','Pakpak',NULL,'active','2026-06-13 17:28:49','2026-06-13 17:28:49');
/*!40000 ALTER TABLE `marga` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `marga_hierarchy`
--

LOCK TABLES `marga_hierarchy` WRITE;
/*!40000 ALTER TABLE `marga_hierarchy` DISABLE KEYS */;
INSERT INTO `marga_hierarchy` VALUES (1,1,0),(2,2,0),(3,3,0),(4,4,0),(5,5,0),(6,6,0),(7,7,0),(8,8,0),(9,9,0),(10,10,0),(11,11,0),(12,12,0),(13,13,0),(14,14,0),(15,15,0),(16,16,0),(17,17,0),(18,18,0),(19,19,0),(20,20,0),(21,21,0),(22,22,0),(23,23,0),(24,24,0),(25,25,0),(26,26,0),(27,27,0),(28,28,0),(29,29,0),(30,30,0),(31,31,0),(32,32,0),(33,33,0),(34,34,0),(35,35,0),(36,36,0),(37,37,0),(38,38,0),(39,39,0),(40,40,0),(41,41,0),(42,42,0),(43,43,0),(44,44,0),(45,45,0),(46,46,0),(47,47,0),(48,48,0),(49,49,0),(50,50,0),(51,51,0),(52,52,0),(53,53,0),(54,54,0),(55,55,0),(56,56,0),(57,57,0),(58,58,0),(59,59,0),(60,60,0),(61,61,0),(62,62,0),(63,63,0),(64,64,0),(65,65,0),(66,66,0),(67,67,0),(68,68,0),(69,69,0),(70,70,0),(71,71,0),(72,72,0),(73,73,0),(74,74,0),(75,75,0),(76,76,0),(77,77,0),(78,78,0),(79,79,0),(80,80,0),(81,81,0),(82,82,0),(83,83,0),(84,84,0),(85,85,0),(86,86,0),(87,87,0),(88,88,0),(89,89,0),(90,90,0),(91,91,0),(92,92,0),(93,93,0),(94,94,0),(95,95,0),(96,96,0),(97,97,0),(98,98,0),(99,99,0),(100,100,0),(101,101,0),(102,102,0),(103,103,0),(104,104,0),(105,105,0),(106,106,0),(107,107,0),(108,108,0),(109,109,0),(110,110,0),(111,111,0),(112,112,0),(113,113,0),(114,114,0),(1,2,1),(2,3,1),(3,4,1),(3,5,1),(3,6,1),(3,7,1),(3,8,1),(3,9,1),(3,10,1),(3,11,1),(4,12,1),(4,13,1),(4,14,1),(4,15,1),(6,16,1),(6,17,1),(7,18,1),(7,19,1),(8,20,1),(8,21,1),(8,22,1),(8,23,1),(8,24,1),(11,39,1),(11,40,1),(11,41,1),(11,42,1),(11,43,1),(11,44,1),(11,45,1),(11,46,1),(11,47,1),(11,48,1),(21,25,1),(21,26,1),(21,27,1),(21,28,1),(22,29,1),(23,30,1),(23,31,1),(24,32,1),(24,33,1),(24,34,1),(24,35,1),(25,36,1),(25,37,1),(25,38,1),(1,3,2),(2,4,2),(2,5,2),(2,6,2),(2,7,2),(2,8,2),(2,9,2),(2,10,2),(2,11,2),(3,12,2),(3,13,2),(3,14,2),(3,15,2),(3,16,2),(3,17,2),(3,18,2),(3,19,2),(3,20,2),(3,21,2),(3,22,2),(3,23,2),(3,24,2),(3,39,2),(3,40,2),(3,41,2),(3,42,2),(3,43,2),(3,44,2),(3,45,2),(3,46,2),(3,47,2),(3,48,2),(8,25,2),(8,26,2),(8,27,2),(8,28,2),(8,29,2),(8,30,2),(8,31,2),(8,32,2),(8,33,2),(8,34,2),(8,35,2),(21,36,2),(21,37,2),(21,38,2);
/*!40000 ALTER TABLE `marga_hierarchy` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `marriage_stages`
--

LOCK TABLES `marriage_stages` WRITE;
/*!40000 ALTER TABLE `marriage_stages` DISABLE KEYS */;
/*!40000 ALTER TABLE `marriage_stages` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `marriages`
--

LOCK TABLES `marriages` WRITE;
/*!40000 ALTER TABLE `marriages` DISABLE KEYS */;
INSERT INTO `marriages` VALUES (1,3,6,'2000-12-15',NULL,'active',2,1,NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49');
/*!40000 ALTER TABLE `marriages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pengirim_id` int(11) NOT NULL,
  `penerima_id` int(11) DEFAULT NULL,
  `subjek` varchar(255) DEFAULT NULL,
  `konten` text NOT NULL,
  `status` enum('terkirim','dibaca','dihapus') DEFAULT 'terkirim',
  `parent_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pengirim` (`pengirim_id`),
  KEY `idx_penerima` (`penerima_id`),
  KEY `idx_status` (`status`),
  KEY `idx_messages_parent` (`parent_id`),
  CONSTRAINT `fk_messages_penerima` FOREIGN KEY (`penerima_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_messages_pengirim` FOREIGN KEY (`pengirim_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_preferences`
--

DROP TABLE IF EXISTS `notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification_preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notify_on_person_changes` tinyint(1) DEFAULT 1,
  `notify_on_asset_changes` tinyint(1) DEFAULT 1,
  `notify_on_financial_changes` tinyint(1) DEFAULT 1,
  `notify_on_cultural_changes` tinyint(1) DEFAULT 1,
  `notify_on_system_updates` tinyint(1) DEFAULT 1,
  `email_notifications` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user` (`user_id`),
  CONSTRAINT `notification_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_preferences`
--

LOCK TABLES `notification_preferences` WRITE;
/*!40000 ALTER TABLE `notification_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tipe` enum('acara','pesan','pengumuman','iuran','lainnya') NOT NULL,
  `judul` varchar(255) NOT NULL,
  `konten` text DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  `status` enum('unread','read','archived') DEFAULT 'unread',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_tipe` (`tipe`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,2,'acara','Rapat Tahunan','Undangan rapat tahunan punguan','/events/1','unread','2026-06-15 13:13:21'),(2,3,'pengumuman','Undangan Rapat','Undangan rapat tahunan punguan','/announcements/1','unread','2026-06-15 13:13:21'),(3,2,'acara','Rapat Tahunan','Undangan rapat tahunan punguan','/events/1','unread','2026-06-20 09:11:24'),(4,3,'pengumuman','Undangan Rapat','Undangan rapat tahunan punguan','/announcements/1','unread','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oral_traditions`
--

DROP TABLE IF EXISTS `oral_traditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oral_traditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kategori` varchar(50) NOT NULL COMMENT 'Type: umpasa, cerita_rakyat, lagu_adat, mantra, etc.',
  `judul` varchar(255) NOT NULL,
  `konten` text NOT NULL,
  `bahasa_asli` text DEFAULT NULL COMMENT 'Original Batak language text',
  `terjemahan` text DEFAULT NULL COMMENT 'Indonesian translation',
  `transliterasi` text DEFAULT NULL COMMENT 'Latin script transliteration',
  `audio_path` varchar(255) DEFAULT NULL COMMENT 'Path to audio recording',
  `video_path` varchar(255) DEFAULT NULL COMMENT 'Path to video recording',
  `marga_id` int(11) DEFAULT NULL,
  `daerah` varchar(100) DEFAULT NULL COMMENT 'Region where tradition is practiced',
  `narator` varchar(255) DEFAULT NULL COMMENT 'Name of the narrator/tradition keeper',
  `tanggal_rekam` date DEFAULT NULL COMMENT 'Date when tradition was recorded',
  `status` enum('aktif','terancam','punah') DEFAULT 'aktif',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_kategori` (`kategori`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `oral_traditions_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`),
  CONSTRAINT `oral_traditions_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oral_traditions`
--

LOCK TABLES `oral_traditions` WRITE;
/*!40000 ALTER TABLE `oral_traditions` DISABLE KEYS */;
INSERT INTO `oral_traditions` VALUES (1,'umpasa','Mangulosi','Ulos sebagai simbol berkat dan perlindungan','Ulos manungkos, manungkoban, manungkalhati','Ulos memberikan kehangatan, perlindungan, dan ketenangan hati',NULL,NULL,NULL,1,NULL,'Nenek Boru',NULL,'aktif',NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(2,'cerita_rakyat','Asal Usul Danau Toba','Legenda pembentukan Danau Toba','Si Ombu nan dohot Si Ombu...','Kisah tentang pembentukan Danau Toba dari legenda lokal',NULL,NULL,NULL,1,NULL,'Amang Tua',NULL,'aktif',NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(3,'umpasa','Mangulosi','Ulos sebagai simbol berkat dan perlindungan','Ulos manungkos, manungkoban, manungkalhati','Ulos memberikan kehangatan, perlindungan, dan ketenangan hati',NULL,NULL,NULL,1,NULL,'Nenek Boru',NULL,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'cerita_rakyat','Asal Usul Danau Toba','Legenda pembentukan Danau Toba','Si Ombu nan dohot Si Ombu...','Kisah tentang pembentukan Danau Toba dari legenda lokal',NULL,NULL,NULL,1,NULL,'Amang Tua',NULL,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `oral_traditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_password_resets_email` (`email`),
  KEY `idx_password_resets_token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `person_locations`
--

LOCK TABLES `person_locations` WRITE;
/*!40000 ALTER TABLE `person_locations` DISABLE KEYS */;
INSERT INTO `person_locations` VALUES (1,1,'Medan',3.59520000,98.67210000,NULL,'hometown',1,'2026-06-13 20:26:41'),(2,3,'Jakarta',-6.20880000,106.84560000,NULL,'current',1,'2026-06-13 20:26:41'),(3,6,'Surabaya',-7.25750000,112.75210000,NULL,'current',1,'2026-06-13 20:26:41'),(4,8,'Jakarta',-6.21000000,106.85000000,NULL,'current',1,'2026-06-13 20:26:41');
/*!40000 ALTER TABLE `person_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `persons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `nama_depan` varchar(100) DEFAULT NULL COMMENT 'Nama depan/personal name',
  `marga_id` int(11) NOT NULL,
  `id_turunan_marga` int(11) DEFAULT NULL COMMENT 'ID marga turunan (untuk tracking hierarki)',
  `id_asal_usul` int(11) DEFAULT NULL COMMENT 'ID asal usul marga (referensi ke marga asal)',
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
  KEY `idx_turunan_marga` (`id_turunan_marga`),
  KEY `idx_asal_usul` (`id_asal_usul`),
  FULLTEXT KEY `ft_persons_nama` (`nama`,`tempat_lahir`),
  CONSTRAINT `persons_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`),
  CONSTRAINT `persons_ibfk_2` FOREIGN KEY (`father_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `persons_ibfk_3` FOREIGN KEY (`mother_id`) REFERENCES `persons` (`id`) ON DELETE SET NULL,
  CONSTRAINT `persons_ibfk_4` FOREIGN KEY (`id_turunan_marga`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `persons_ibfk_5` FOREIGN KEY (`id_asal_usul`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (1,'John Simanjuntak','John',32,NULL,24,'L',NULL,NULL,'1950-01-15','Medan',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(2,'Mary Simanjuntak','Mary',32,NULL,24,'P',NULL,NULL,'1952-03-20','Medan',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(3,'Robert Simanjuntak','Robert',32,NULL,24,'L',1,2,'1975-05-10','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(4,'Sarah Simanjuntak','Sarah',32,NULL,24,'P',1,2,'1978-07-25','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(5,'Michael Simanjuntak','Michael',32,NULL,24,'L',1,2,'1980-09-30','Bandung',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(6,'Emily Marbun','Emily',33,NULL,24,'P',NULL,NULL,'1977-11-15','Surabaya',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(7,'David Marbun','David',33,NULL,24,'L',NULL,NULL,'1979-02-28','Surabaya',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(8,'Alice Marbun','Alice',33,NULL,24,'P',3,6,'2005-04-10','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(9,'Charlie Marbun','Charlie',33,NULL,24,'L',3,6,'2008-06-20','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51'),(10,'Emma Simanjuntak','Emma',32,NULL,24,'P',1,2,'2006-08-15','Bandung',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-15 14:43:51');
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `punguan`
--

LOCK TABLES `punguan` WRITE;
/*!40000 ALTER TABLE `punguan` DISABLE KEYS */;
INSERT INTO `punguan` VALUES (1,'Punguan Simanjuntak Jakarta',32,'Organisasi marga Simanjuntak di Jakarta','Jl. Batak No.1','Jakarta','DKI Jakarta',NULL,NULL,NULL,NULL,'active','2026-06-13 20:26:41','2026-06-13 20:26:41'),(2,'Punguan Marbun Medan',33,'Organisasi marga Marbun di Medan','Jl. Sisingamangaraja','Medan','Sumatera Utara',NULL,NULL,NULL,NULL,'active','2026-06-13 20:26:41','2026-06-13 20:26:41');
/*!40000 ALTER TABLE `punguan` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `punguan_members`
--

LOCK TABLES `punguan_members` WRITE;
/*!40000 ALTER TABLE `punguan_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `punguan_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rumah_keluarga`
--

DROP TABLE IF EXISTS `rumah_keluarga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rumah_keluarga` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `person_id` int(11) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `kota` varchar(100) DEFAULT NULL,
  `provinsi` varchar(100) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `tipe` enum('rumah_utama','rumah_kediaman','rumah_adat','rumah_villa','lainnya') DEFAULT 'rumah_kediaman',
  `status` enum('dihuni','kosong','disewakan','dijual') DEFAULT 'dihuni',
  `foto_path` varchar(500) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_person` (`person_id`),
  KEY `idx_kota` (`kota`),
  CONSTRAINT `fk_rumah_keluarga_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rumah_keluarga`
--

LOCK TABLES `rumah_keluarga` WRITE;
/*!40000 ALTER TABLE `rumah_keluarga` DISABLE KEYS */;
INSERT INTO `rumah_keluarga` VALUES (1,'Rumah Keluarga Simanjuntak',1,'Jl. Batak No. 1','Medan','Sumatera Utara',NULL,NULL,'rumah_kediaman','dihuni',NULL,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Rumah Adat',3,'Desa Tomok','Toba Samosir','Sumatera Utara',NULL,NULL,'rumah_adat','dihuni',NULL,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(3,'Rumah Keluarga Simanjuntak',1,'Jl. Batak No. 1','Medan','Sumatera Utara',NULL,NULL,'rumah_kediaman','dihuni',NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'Rumah Adat',3,'Desa Tomok','Toba Samosir','Sumatera Utara',NULL,NULL,'rumah_adat','dihuni',NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `rumah_keluarga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_audit_log`
--

DROP TABLE IF EXISTS `security_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `security_audit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(100) NOT NULL COMMENT 'Type of security event (API_ACCESS, SENSITIVE_OPERATION, LOGIN_ATTEMPT, etc.)',
  `user_id` int(11) DEFAULT NULL COMMENT 'User ID if authenticated',
  `uri` varchar(500) NOT NULL COMMENT 'Request URI',
  `method` varchar(10) NOT NULL COMMENT 'HTTP method (GET, POST, PUT, DELETE)',
  `ip_address` varchar(45) NOT NULL COMMENT 'Client IP address',
  `user_agent` text DEFAULT NULL COMMENT 'User agent string',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Additional event metadata' CHECK (json_valid(`metadata`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Event timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_event_type` (`event_type`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ip_address` (`ip_address`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Security audit log for monitoring sensitive operations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_audit_log`
--

LOCK TABLES `security_audit_log` WRITE;
/*!40000 ALTER TABLE `security_audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `security_audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `judul` varchar(255) NOT NULL,
  `tipe` enum('sejarah_keluarga','cerita_leluhur','dongeng_adat','pengalaman_pribadi','lainnya') NOT NULL,
  `konten` text NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `penulis_id` int(11) DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `tanggal_kejadian` date DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `status` enum('draft','published','archived') DEFAULT 'draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_status` (`status`),
  KEY `idx_stories_penulis` (`penulis_id`),
  KEY `idx_stories_person` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` VALUES (1,'Asal Usul Marga Simanjuntak','sejarah_keluarga','Marga Simanjuntak berasal dari daerah Toba dan merupakan keturunan dari...',NULL,1,32,NULL,NULL,'published','2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Asal Usul Marga Simanjuntak','sejarah_keluarga','Marga Simanjuntak berasal dari daerah Toba dan merupakan keturunan dari...',NULL,1,32,NULL,NULL,'published','2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tanah_boundaries`
--

DROP TABLE IF EXISTS `tanah_boundaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tanah_boundaries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tanah_ulayat_id` int(11) NOT NULL,
  `titik_urutan` int(11) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `deskripsi_titik` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_tanah` (`tanah_ulayat_id`),
  KEY `idx_urutan` (`titik_urutan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanah_boundaries`
--

LOCK TABLES `tanah_boundaries` WRITE;
/*!40000 ALTER TABLE `tanah_boundaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `tanah_boundaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tanah_ulayat`
--

DROP TABLE IF EXISTS `tanah_ulayat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tanah_ulayat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `marga_id` int(11) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `luas_hektar` decimal(10,2) DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `batas_wilayah` text DEFAULT NULL,
  `status` enum('aktif','sengketa','dijual','disewakan') DEFAULT 'aktif',
  `pengelola_id` int(11) DEFAULT NULL,
  `foto_path` varchar(500) DEFAULT NULL,
  `peta_path` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_marga` (`marga_id`),
  KEY `idx_status` (`status`),
  KEY `idx_tanah_ulayat_pengelola` (`pengelola_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tanah_ulayat`
--

LOCK TABLES `tanah_ulayat` WRITE;
/*!40000 ALTER TABLE `tanah_ulayat` DISABLE KEYS */;
INSERT INTO `tanah_ulayat` VALUES (1,'Tanah Ulayat Simanjuntak',32,'Tanah ulayat marga Simanjuntak di daerah Toba',50.00,'Toba Samosir',2.50000000,99.00000000,NULL,'aktif',NULL,NULL,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Tanah Ulayat Marbun',33,'Tanah ulayat marga Marbun di Humbang Hasundutan',30.00,'Humbang Hasundutan',2.30000000,99.10000000,NULL,'aktif',NULL,NULL,NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(3,'Tanah Ulayat Simanjuntak',32,'Tanah ulayat marga Simanjuntak di daerah Toba',50.00,'Toba Samosir',2.50000000,99.00000000,NULL,'aktif',NULL,NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'Tanah Ulayat Marbun',33,'Tanah ulayat marga Marbun di Humbang Hasundutan',30.00,'Humbang Hasundutan',2.30000000,99.10000000,NULL,'aktif',NULL,NULL,NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `tanah_ulayat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `traditional_knowledge`
--

DROP TABLE IF EXISTS `traditional_knowledge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `traditional_knowledge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kategori` varchar(50) NOT NULL COMMENT 'Type: pertanian, obat_tradisional, konservasi, kerajinan, etc.',
  `judul` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `metode` text DEFAULT NULL COMMENT 'Detailed method/procedure',
  `bahan` text DEFAULT NULL COMMENT 'Materials needed',
  `alat` text DEFAULT NULL COMMENT 'Tools needed',
  `manfaat` text DEFAULT NULL COMMENT 'Benefits and uses',
  `larangan` text DEFAULT NULL COMMENT 'Taboos and restrictions',
  `marga_id` int(11) DEFAULT NULL,
  `daerah` varchar(100) DEFAULT NULL,
  `pengetahuan_dari` varchar(255) DEFAULT NULL COMMENT 'Source of knowledge (elder, etc.)',
  `tanggal_dokumentasi` date DEFAULT NULL,
  `foto_path` varchar(255) DEFAULT NULL,
  `video_path` varchar(255) DEFAULT NULL,
  `status` enum('aktif','terancam','punah') DEFAULT 'aktif',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_kategori` (`kategori`),
  KEY `idx_marga` (`marga_id`),
  CONSTRAINT `traditional_knowledge_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`),
  CONSTRAINT `traditional_knowledge_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `traditional_knowledge`
--

LOCK TABLES `traditional_knowledge` WRITE;
/*!40000 ALTER TABLE `traditional_knowledge` DISABLE KEYS */;
INSERT INTO `traditional_knowledge` VALUES (1,'pertanian','Maragat Getah','Teknik tradisional mengambil getah karet tanpa merusak pohon','Mengambil getah dengan tangan kosong secara hati-hati',NULL,NULL,NULL,NULL,1,NULL,'Amang Tani',NULL,NULL,NULL,'aktif',NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(2,'obat_tradisional','Obat Daun Sirih','Penggunaan daun sirih untuk kesehatan','Rebus daun sirih dan minum airnya',NULL,NULL,NULL,NULL,1,NULL,'Nenek Boru',NULL,NULL,NULL,'aktif',NULL,'2026-06-15 13:29:29','2026-06-15 13:29:29'),(3,'pertanian','Maragat Getah','Teknik tradisional mengambil getah karet tanpa merusak pohon','Mengambil getah dengan tangan kosong secara hati-hati',NULL,NULL,NULL,NULL,1,NULL,'Amang Tani',NULL,NULL,NULL,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'obat_tradisional','Obat Daun Sirih','Penggunaan daun sirih untuk kesehatan','Rebus daun sirih dan minum airnya',NULL,NULL,NULL,NULL,1,NULL,'Nenek Boru',NULL,NULL,NULL,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `traditional_knowledge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `traditions`
--

DROP TABLE IF EXISTS `traditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `traditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `kategori` enum('adat_perkawinan','adat_kematian','adat_lahir','adat_punguan','tradisi_lainnya') NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `asal_usul` text DEFAULT NULL,
  `prosedur` text DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `status` enum('aktif','tidak_aktif') DEFAULT 'aktif',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_kategori` (`kategori`),
  KEY `idx_marga` (`marga_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `traditions`
--

LOCK TABLES `traditions` WRITE;
/*!40000 ALTER TABLE `traditions` DISABLE KEYS */;
INSERT INTO `traditions` VALUES (1,'Mangulosi','adat_perkawinan','Tradisi memberkati pengantin dengan ulos','Tradisi Batak kuno',NULL,1,'aktif',NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(2,'Martumpol','adat_perkawinan','Lamaran resmi dengan pemberian pasu','Tradisi Batak kuno',NULL,1,'aktif',NULL,'2026-06-15 13:13:21','2026-06-15 13:13:21'),(3,'Mangulosi','adat_perkawinan','Tradisi memberkati pengantin dengan ulos','Tradisi Batak kuno',NULL,1,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24'),(4,'Martumpol','adat_perkawinan','Lamaran resmi dengan pemberian pasu','Tradisi Batak kuno',NULL,1,'aktif',NULL,'2026-06-20 09:11:24','2026-06-20 09:11:24');
/*!40000 ALTER TABLE `traditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `punguan_id` int(11) NOT NULL,
  `tipe` enum('masuk','keluar') NOT NULL,
  `kategori` enum('iuran','sumbangan','acara_adat','sosial','operasional','pembangunan','lainnya') NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `tanggal` date NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `person_id` int(11) DEFAULT NULL,
  `bukti_dokumen_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'User who created the transaction',
  `status` enum('pending','verified','rejected') DEFAULT 'pending',
  `verified_by` int(11) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_punguan` (`punguan_id`),
  KEY `idx_tipe` (`tipe`),
  KEY `idx_tanggal` (`tanggal`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_transactions_punguan` (`punguan_id`),
  KEY `idx_transactions_person` (`person_id`),
  KEY `idx_transactions_status` (`status`),
  KEY `idx_transactions_bukti_dokumen` (`bukti_dokumen_id`),
  CONSTRAINT `fk_transactions_bukti_dokumen` FOREIGN KEY (`bukti_dokumen_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_transactions_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

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
  `role` enum('guest','user','verified','tetua','punguan_admin','admin') DEFAULT 'user',
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@tarombo.digital','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','Administrator','admin',NULL,'active',NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(2,'john@tarombo.digital','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','John Simanjuntak','verified',1,'active',NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(3,'testnew@tarombo.digital','$2y$10$UUMwj.z6G/kRW0eRjGYpIep79tkSsvBgjHuog.4C4urvlaz5l5bVy','Test User','user',NULL,'active',NULL,'2026-06-13 14:31:20','2026-06-13 14:31:20'),(4,'punguan@tarombo.digital','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','Punguan Admin','punguan_admin',NULL,'active',NULL,'2026-06-15 13:01:10','2026-06-15 13:01:10');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'tarombo'
--
