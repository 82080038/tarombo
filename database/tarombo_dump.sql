-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: tarombo
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `hubungan_marga`
--

DROP TABLE IF EXISTS `hubungan_marga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hubungan_marga` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marga1_id` int(11) NOT NULL,
  `marga2_id` int(11) NOT NULL,
  `jenis_hubungan` varchar(50) NOT NULL COMMENT 'pariban, tulang, bere, hula-hula, dll',
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_hubungan` (`marga1_id`,`marga2_id`,`jenis_hubungan`),
  KEY `marga2_id` (`marga2_id`),
  KEY `idx_jenis_hubungan` (`jenis_hubungan`),
  CONSTRAINT `hubungan_marga_ibfk_1` FOREIGN KEY (`marga1_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hubungan_marga_ibfk_2` FOREIGN KEY (`marga2_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hubungan_marga`
--

LOCK TABLES `hubungan_marga` WRITE;
/*!40000 ALTER TABLE `hubungan_marga` DISABLE KEYS */;
INSERT INTO `hubungan_marga` VALUES (1,49,50,'pariban','Simanjuntak dan Marbun adalah pariban','2026-06-20 19:03:10'),(2,52,21,'pariban','Siregar dan Sinaga adalah pariban','2026-06-20 19:03:10'),(3,39,55,'tulang','Hutagalung adalah tulang bagi Lumbantobing','2026-06-20 19:03:10'),(4,55,39,'bere','Lumbantobing adalah bere bagi Hutagalung','2026-06-20 19:03:10');
/*!40000 ALTER TABLE `hubungan_marga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inheritance_records`
--

DROP TABLE IF EXISTS `inheritance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `kontribusi`
--

DROP TABLE IF EXISTS `kontribusi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kontribusi` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jenis` enum('tambah_node','edit_node','tambah_marga','koreksi_silsilah','laporan_error') NOT NULL,
  `node_id` int(11) DEFAULT NULL,
  `marga_id` int(11) DEFAULT NULL,
  `data_usulan` text NOT NULL,
  `catatan` text DEFAULT NULL,
  `nama_kontributor` varchar(200) DEFAULT NULL,
  `email_kontributor` varchar(200) DEFAULT NULL,
  `status` enum('pending','disetujui','ditolak','selesai') DEFAULT 'pending',
  `catatan_admin` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diproses_pada` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `node_id` (`node_id`),
  KEY `marga_id` (`marga_id`),
  CONSTRAINT `kontribusi_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE SET NULL,
  CONSTRAINT `kontribusi_ibfk_2` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kontribusi`
--

LOCK TABLES `kontribusi` WRITE;
/*!40000 ALTER TABLE `kontribusi` DISABLE KEYS */;
/*!40000 ALTER TABLE `kontribusi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `makam`
--

DROP TABLE IF EXISTS `makam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marga` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(200) NOT NULL,
  `sub_suku` varchar(100) DEFAULT NULL,
  `bona_pasogit` varchar(200) DEFAULT NULL,
  `kelompok_marga` varchar(100) DEFAULT NULL,
  `marga_induk_id` int(11) DEFAULT NULL,
  `silsilah_node_id` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `sumber` varchar(200) DEFAULT 'Wikipedia - Daftar marga Batak',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nama` (`nama`),
  KEY `marga_induk_id` (`marga_induk_id`),
  KEY `silsilah_node_id` (`silsilah_node_id`),
  CONSTRAINT `marga_ibfk_1` FOREIGN KEY (`marga_induk_id`) REFERENCES `marga` (`id`) ON DELETE SET NULL,
  CONSTRAINT `marga_ibfk_2` FOREIGN KEY (`silsilah_node_id`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marga`
--

LOCK TABLES `marga` WRITE;
/*!40000 ALTER TABLE `marga` DISABLE KEYS */;
INSERT INTO `marga` VALUES (1,'Ajartambun','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(2,'Ambarita','Toba','Sihaporas, Simalungun','Silau Raja',NULL,28,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(3,'Angkat','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(4,'Angkat Singkapal','Pakpak',NULL,NULL,3,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(5,'Aritonang','Toba','Pangururan','Lontung',NULL,40,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(6,'Aruan','Toba',NULL,'Naisuanon',NULL,180,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(7,'Babiat','Mandailing',NULL,NULL,NULL,25,'Keturunan Si Raja Babiat. Marga Bayoangin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(8,'Babo','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(9,'Bako','Pakpak',NULL,NULL,141,NULL,'Alias Naibaho di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(10,'Bancin','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(11,'Banjarnahor','Toba',NULL,'Naisuanon',NULL,257,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(12,'Banuarea','Pakpak',NULL,NULL,NULL,3,'Alias Bunurea','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(13,'Bakkara','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(14,'Bariba','Simalungun',NULL,NULL,46,192,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(15,'Baringbing','Toba',NULL,'Naisuanon',NULL,163,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(16,'Barotbot','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(17,'Baruara','Toba',NULL,'Naisuanon',322,NULL,'Submarga Si Lahi Sabungan / Tambunan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(18,'Barus','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(19,'Batuara','Toba',NULL,'Naiambaton',143,120,'Submarga Nainggolan / Mahulae','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(20,'Batubara','Toba','Batubara','Borbor',NULL,69,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(21,'Baumi','Toba',NULL,'Lontung',296,NULL,'Submarga Siregar','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(22,'Bayu','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(23,'Benjerang','Karo',NULL,NULL,171,NULL,'Submarga Perangin-angin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(24,'Berampu','Pakpak',NULL,NULL,269,NULL,'Submarga Simbolon (Si Onom Hudon)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(25,'Beras','Karo',NULL,NULL,59,7,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(26,'Berasa','Pakpak',NULL,NULL,NULL,7,'Submarga Ompu Bada / Si Onom Kodin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(27,'Beringin','Pakpak',NULL,NULL,NULL,5,'Submarga Ompu Bada / Si Onom Kodin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(28,'Berutu','Pakpak',NULL,NULL,269,NULL,'Submarga Simbolon (Si Onom Hudon)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(29,'Barutu','Pakpak',NULL,NULL,NULL,NULL,'Alias Berutu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(30,'Bintang','Toba',NULL,'Naisuanon',NULL,217,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(31,'Boangmanalu','Toba',NULL,'Naisuanon',119,244,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(32,'Bondar','Toba',NULL,'Borbor',NULL,71,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(33,'Bondong','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(34,'Boliala','Toba',NULL,'Naisuanon',NULL,204,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(35,'Brahmana','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(36,'Buaton','Toba',NULL,'Naiambaton',143,119,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(37,'Bukit','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(38,'Buniaji','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(39,'Busuk','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(40,'Butarbutar','Toba',NULL,'Nairasaon',NULL,160,'Submarga Raja Mardopang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(41,'Capah','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(42,'Cibro','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(43,'Colia','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(44,'Dajawak','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(45,'Dalimunthe','Angkola',NULL,NULL,134,NULL,'Alias Munte di Angkola/Mandailing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(46,'Damanik','Simalungun','Simalungun',NULL,NULL,27,'Marga induk Simalungun. Asal: Manik (Silau Raja)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(47,'Damunthei','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(48,'Dasalak','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(49,'Dasopang','Angkola',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(50,'Daulay','Mandailing',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(51,'Debataraja','Toba',NULL,'Naisuanon',NULL,232,'Submarga Si Raja Sumba / Simamora','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(52,'Depari','Toba',NULL,'Naisuanon',NULL,206,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(53,'Doloksaribu','Toba',NULL,'Naisuanon',NULL,196,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(54,'Dongoran','Toba',NULL,'Lontung',296,127,'Submarga Siregar. Juga di Angkola','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(55,'Gajah','Pakpak',NULL,NULL,NULL,6,'Submarga Ompu Bada / Si Onom Kodin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(56,'Gajamanik','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(57,'Ganagana','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(58,'Garamata','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(59,'Ginting','Karo','Karo',NULL,NULL,NULL,'Marga induk Karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(60,'Giringging','Toba',NULL,'Naiambaton',NULL,NULL,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(61,'Gerneng','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(62,'Girsang','Toba',NULL,'Naisuanon',NULL,233,'Submarga Si Raja Sumba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(63,'Gorat','Toba',NULL,'Borbor',NULL,72,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(64,'Gultom','Toba',NULL,'Lontung',NULL,109,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(65,'Gurning','Toba',NULL,'Silau Raja',NULL,29,'Putra Silau Raja','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(66,'Gurukinayan','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(67,'Gurusinga','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(68,'Gurupatih','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(69,'Habeahan','Toba',NULL,'Limbong',NULL,70,'Submarga Limbong. Juga di Borbor','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(70,'Harahap','Mandailing','Mandailing','Borbor',NULL,64,'Submarga Datu Taladibabana (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(71,'Harianja','Toba',NULL,'Lontung',NULL,112,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(72,'Haromunthe','Simalungun',NULL,NULL,134,NULL,'Alias Munte di Simalungun','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(73,'Hasibuan','Toba','Sipirok','Naisuanon',NULL,246,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(74,'Hasugian','Toba',NULL,'Naisuanon',NULL,211,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(75,'Hutabalian','Toba',NULL,'Naiambaton',143,116,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(76,'Hutabarat','Toba',NULL,'Naisuanon',NULL,247,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(77,'Hutagaol','Toba',NULL,'Naisuanon',NULL,167,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(78,'Hutagalung','Toba','Sipirok','Naisuanon',NULL,249,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(79,'Hutahaean','Toba',NULL,'Naisuanon',NULL,178,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(80,'Hutajulu','Toba',NULL,'Naisuanon',NULL,179,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(81,'Hutanamora','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(82,'Hutapea','Toba',NULL,'Naisuanon',NULL,185,'Submarga Si Paet Tua & Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(83,'Hutasoit','Toba',NULL,'Naisuanon',243,85,'Submarga Si Raja Sumba / Sihombing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(84,'Hutasuhut','Mandailing',NULL,'Borbor',NULL,81,'Submarga Datu Pulungan (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(85,'Hutatoruan','Toba',NULL,'Naisuanon',NULL,250,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(86,'Hutauruk','Toba',NULL,'Naisuanon',NULL,260,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(87,'Jadibata','Karo',NULL,NULL,NULL,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(88,'Jampang','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(89,'Jawak','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(90,'Kaban','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(91,'Kabeaken','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(92,'Kacaribu','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(93,'Kaloko','Pakpak',NULL,NULL,NULL,NULL,'Alias Sihaloho di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(94,'Keling','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(95,'Keloko','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(96,'Kembaren','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(97,'Kemit','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(98,'Ketaren','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(99,'Kombih','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(100,'Kudadiri','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(101,'Lembeng','Pakpak',NULL,NULL,NULL,NULL,'Alias Limbong di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(102,'Limbong','Toba','Pangururan','Limbong',NULL,44,'Marga induk Limbong Mulana','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(103,'Lingga','Toba',NULL,'Naisuanon',NULL,212,'Submarga Si Raja Oloan. Juga di Karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(104,'Lintang','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(105,'Lubis','Mandailing','Mandailing','Borbor',NULL,80,'Submarga Datu Pulungan (Borbor). Marga besar Mandailing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(106,'Lumbanbatu','Toba',NULL,'Naisuanon',NULL,256,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(107,'Lumbangaol','Toba',NULL,'Naisuanon',NULL,258,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(108,'Lumbannahor','Toba',NULL,'Lontung',309,NULL,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(109,'Lumbanpea','Toba',NULL,'Naisuanon',322,NULL,'Submarga Si Lahi Sabungan / Tambunan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(110,'Lumbanraja','Toba',NULL,'Naiambaton',143,NULL,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(111,'Lumbansiantar','Toba',NULL,'Naiambaton',143,NULL,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(112,'Lumbantobing','Toba',NULL,'Naisuanon',NULL,253,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(113,'Lumbantoruan','Toba',NULL,'Naisuanon',243,83,'Submarga Si Raja Sumba / Sihombing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(114,'Lumbantungkup','Toba',NULL,'Naiambaton',143,NULL,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(115,'Maha','Toba',NULL,'Naisuanon',NULL,134,'Submarga Si Raja Huta Lima','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(116,'Maharaja','Toba',NULL,'Naiambaton',269,134,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(117,'Mahulae','Toba',NULL,'Naiambaton',143,120,'Submarga Nainggolan / Batuara','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(118,'Malau','Toba',NULL,'Silau Raja',NULL,26,'Putra sulung Silau Raja','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(119,'Manalu','Toba',NULL,'Naisuanon',NULL,231,'Submarga Si Raja Sumba / Simamora','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(120,'Manihuruk','Toba',NULL,'Naiambaton',59,153,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(121,'Manik','Toba',NULL,'Silau Raja',NULL,4,'Putra Silau Raja','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(122,'Manik Kecupak','Pakpak',NULL,NULL,NULL,4,'Submarga Ompu Bada di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(123,'Manurung','Toba',NULL,'Nairasaon',NULL,161,'Submarga Raja Mangatur','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(124,'Marbun','Toba',NULL,'Naisuanon',NULL,255,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(125,'Mardia','Mandailing',NULL,NULL,181,NULL,'Submarga Rangkuti','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(126,'Marpaung','Toba',NULL,'Naisuanon',NULL,175,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(127,'Matanari','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(128,'Matondang','Angkola',NULL,'Borbor',NULL,75,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(129,'Meka','Pakpak',NULL,NULL,124,NULL,'Submarga Marbun di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(130,'Milala','Karo',NULL,NULL,205,NULL,'Submarga Sembiring / Meliala','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(131,'Meliala','Karo',NULL,NULL,205,NULL,'Submarga Sembiring. Juga di Toba (Si Raja Huta Lima)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(132,'Muham','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(133,'Mungkur','Toba',NULL,'Naisuanon',NULL,263,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(134,'Munte','Toba','Sianjur Mula-mula','Naiambaton',NULL,50,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(135,'Munthe','Simalungun',NULL,NULL,134,NULL,'Alias Munte di Simalungun','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(136,'Nababan','Toba',NULL,'Naisuanon',243,84,'Submarga Si Raja Sumba / Sihombing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(137,'Nadapdap','Toba',NULL,'Naisuanon',NULL,199,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(138,'Nadeak','Toba',NULL,'Naiambaton',198,150,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(139,'Nagur','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(140,'Nahampun','Toba',NULL,'Naiambaton',269,136,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(141,'Naibaho','Toba','Balige','Naisuanon',NULL,209,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(142,'Naiborhu','Toba',NULL,'Naisuanon',NULL,198,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(143,'Nainggolan','Toba','Nainggolan, Samosir','Naiambaton',NULL,38,'Marga induk dari Toga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(144,'Naipospos','Toba','Sipirok','Naisuanon',NULL,60,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(145,'Napitu','Toba',NULL,'Naiambaton',319,146,'Submarga Tamba Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(146,'Napitupulu','Toba',NULL,'Naisuanon',NULL,176,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(147,'Nasution','Mandailing','Mandailing',NULL,NULL,168,'Marga besar Mandailing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(148,'Ompusunggu','Toba',NULL,'Lontung',5,124,'Submarga Aritonang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(149,'Padang','Toba',NULL,'Lontung',309,92,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(150,'Padang Batanghari','Toba',NULL,'Lontung',309,NULL,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(151,'Pakpahan','Toba',NULL,'Lontung',NULL,108,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(152,'Pandebayang','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(153,'Pane','Toba',NULL,'Nairasaon',NULL,NULL,'Submarga Sitorus','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(154,'Pangaribuan','Toba',NULL,'Naisuanon',NULL,184,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(155,'Panggabean','Toba',NULL,'Naisuanon',NULL,248,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(156,'Panjaitan','Toba',NULL,'Naisuanon',NULL,169,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(157,'Parapat','Toba',NULL,'Borbor',NULL,78,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(158,'Pardede','Toba',NULL,'Naisuanon',NULL,177,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(159,'Pardosi','Toba',NULL,'Naisuanon',NULL,173,'Submarga Si Bagot Ni Pohan & Si Raja Huta Lima','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(160,'Parhusip','Toba',NULL,'Naiambaton',143,113,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(161,'Parmata','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(162,'Paroka','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(163,'Parinduri','Mandailing',NULL,NULL,181,NULL,'Submarga Rangkuti','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(164,'Pasaribu','Toba',NULL,'Borbor',NULL,68,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(165,'Pase','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(166,'Pasei','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(167,'Pasi','Pakpak',NULL,NULL,269,NULL,'Submarga Simbolon (Si Onom Hudon)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(168,'Pekan','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(169,'Pelawi','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(170,'Penarik','Pakpak',NULL,NULL,171,NULL,'Submarga Perangin-angin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(171,'Perangin-angin','Karo','Karo',NULL,NULL,NULL,'Marga induk Karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(172,'Pinayungan','Toba',NULL,'Naiambaton',269,137,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(173,'Pintubatu','Toba',NULL,'Naisuanon',NULL,193,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(174,'Pohan','Toba',NULL,'Naisuanon',NULL,53,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(175,'Porti','Toba',NULL,'Lontung',275,106,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(176,'Pulungan','Mandailing',NULL,'Borbor',NULL,66,'Submarga Datu Pulungan (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(177,'Purba','Simalungun','Simalungun',NULL,NULL,230,'Marga induk Simalungun. Juga di Toba/Karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(178,'Rambe','Toba',NULL,'Naisuanon',NULL,229,'Submarga Si Raja Sumba / Simamora','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(179,'Rajagukguk','Toba',NULL,'Lontung',5,125,'Submarga Aritonang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(180,'Rampogos','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(181,'Rangkuti','Mandailing',NULL,'Borbor',NULL,79,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(182,'Rih','Simalungun',NULL,NULL,46,77,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(183,'Ritonga','Toba',NULL,'Lontung',296,130,'Submarga Siregar','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(184,'Rumabutar','Toba',NULL,'Naisuanon',119,238,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(185,'Rumagorga','Toba',NULL,'Naisuanon',119,239,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(186,'Rumahole','Toba',NULL,'Naisuanon',119,240,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(187,'Rumahorbo','Toba',NULL,'Naiambaton',319,145,'Submarga Tamba Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(188,'Rumaijuk','Toba',NULL,'Naisuanon',119,241,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(189,'Rumapea','Toba',NULL,'Lontung',309,91,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(190,'Rumasingap','Toba',NULL,'Naisuanon',NULL,207,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(191,'Rumasondi','Toba',NULL,'Naisuanon',NULL,190,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(192,'Sagala','Toba','Pangururan','Sagala',NULL,14,'Marga induk Sagala Raja','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(193,'Saing','Toba',NULL,'Naiambaton',198,148,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(194,'Sambo','Toba',NULL,'Naisuanon',NULL,226,'Submarga Si Raja Huta Lima','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(195,'Samosir','Toba',NULL,'Lontung',NULL,107,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(196,'Samura','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(197,'Saraan','Toba',NULL,'Naisuanon',NULL,264,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(198,'Saragi','Toba','Sianjur Mula-mula','Naiambaton',NULL,49,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(199,'Saragih','Simalungun','Simalungun',NULL,NULL,49,'Marga induk Simalungun. Asal: Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(200,'Sarasan','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(201,'Saruksuk','Toba',NULL,'Borbor',NULL,76,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(202,'Sarumpaet','Toba',NULL,'Naisuanon',NULL,183,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(203,'Sehun','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(204,'Sekali','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(205,'Sembiring','Karo','Karo',NULL,NULL,NULL,'Marga induk Karo. Asal: Si Raja Huta Lima (Toba)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(206,'Seragih','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(207,'Siadari','Toba',NULL,'Naiambaton',319,143,'Submarga Tamba Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(208,'Siagian','Toba',NULL,'Lontung',296,129,'Submarga Siregar / Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(209,'Siahaan','Toba','Sianjur Mula-mula','Naisuanon',NULL,165,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(210,'Siallagan','Toba',NULL,'Naiambaton',319,138,'Submarga Tamba Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(211,'Sianipar','Toba',NULL,'Naisuanon',NULL,172,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(212,'Sianturi','Toba',NULL,'Lontung',268,122,'Submarga Simatupang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(213,'Sibagariang','Toba',NULL,'Naisuanon',NULL,259,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(214,'Sibarani','Toba',NULL,'Naisuanon',NULL,181,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(215,'Sibero','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(216,'Siboro','Toba',NULL,'Naisuanon',NULL,235,'Submarga Si Raja Sumba / Simamora','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(217,'Sibuea','Toba',NULL,'Naisuanon',NULL,182,'Submarga Si Paet Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(218,'Siburian','Toba',NULL,'Lontung',268,123,'Submarga Simatupang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(219,'Sidauruk','Toba',NULL,'Naiambaton',NULL,154,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(220,'Sidabalok','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(221,'Sidabutar','Toba',NULL,'Naiambaton',319,140,'Submarga Tamba Tua & Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(222,'Sidabungke','Toba',NULL,'Naiambaton',198,151,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(223,'Sidadolog','Simalungun',NULL,NULL,177,NULL,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(224,'Sidagambir','Simalungun',NULL,NULL,177,NULL,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(225,'Sidagurgur','Toba',NULL,'Lontung',275,97,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(226,'Sidahambang','Toba',NULL,'Lontung',275,98,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(227,'Sidahapitu','Toba',NULL,'Lontung',275,99,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(228,'Sidahoro','Toba',NULL,'Lontung',275,100,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(229,'Sidalogan','Toba',NULL,'Lontung',275,101,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(230,'Sidapulou','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(231,'Sidari','Toba',NULL,'Lontung',NULL,110,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(232,'Sidasuha','Simalungun',NULL,NULL,177,NULL,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(233,'Sidasuhut','Toba',NULL,'Lontung',275,102,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(234,'Sidebang','Toba',NULL,'Naisuanon',NULL,202,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(235,'Sigalingging','Toba',NULL,'Naiambaton',NULL,157,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(236,'Sigiro','Toba',NULL,'Naisuanon',NULL,194,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(237,'Sigukguhi','Toba',NULL,'Naisuanon',119,242,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(238,'Sigumonrong','Simalungun',NULL,NULL,177,NULL,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(239,'Sihala','Simalungun',NULL,NULL,177,NULL,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(240,'Sihaloho','Toba',NULL,'Naisuanon',NULL,186,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(241,'Sihite','Toba',NULL,'Naisuanon',NULL,214,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(242,'Sihole','Toba',NULL,'Limbong',NULL,45,'Submarga Limbong (Langgat Limbong)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(243,'Sihombing','Toba','Balige','Naisuanon',NULL,42,'Submarga Si Raja Sumba. Sihombing si Opat Ama','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(244,'Sihotang','Toba','Balige','Naisuanon',NULL,94,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(245,'Sijabat','Toba',NULL,'Naiambaton',319,141,'Submarga Tamba Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(246,'Siketang','Pakpak',NULL,NULL,244,NULL,'Alias Sihotang di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(247,'Silaen','Toba',NULL,'Naisuanon',NULL,164,'Submarga Si Bagot Ni Pohan / Tampubolon','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(248,'Silaban','Toba',NULL,'Naisuanon',243,82,'Submarga Si Raja Sumba / Sihombing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(249,'Silalahi','Toba',NULL,'Naisuanon',NULL,55,'Submarga Si Lahi Sabungan. Marga induk','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(250,'Silampuyang','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(251,'Silangit','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(252,'Sileang','Toba',NULL,'Naisuanon',241,221,'Submarga Si Raja Oloan / Sihite','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(253,'Silitonga','Toba',NULL,'Naisuanon',NULL,171,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(254,'Simaibang','Toba',NULL,'Lontung',275,103,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(255,'Simalango','Toba',NULL,'Naiambaton',198,147,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(256,'Simamora','Toba','Balige','Naisuanon',NULL,43,'Submarga Si Raja Sumba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(257,'Simandalahi','Toba',NULL,'Lontung',275,104,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(258,'Simangunsong','Toba',NULL,'Naisuanon',NULL,174,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(259,'Simanjorang','Toba',NULL,'Lontung',275,105,'Submarga Sinaga','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(260,'Simanjuntak','Toba','Balige','Naisuanon',NULL,166,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(261,'Simanullang','Toba',NULL,'Naisuanon',NULL,215,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(262,'Simanungkalit','Toba',NULL,'Naisuanon',NULL,261,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(263,'Simaremare','Toba',NULL,'Lontung',5,126,'Submarga Aritonang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(264,'Simargolang','Toba',NULL,'Borbor',NULL,NULL,'Submarga Datu Taladibabana (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(265,'Simaringga','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(266,'Simarmata','Toba',NULL,'Naiambaton',198,149,'Submarga Saragi Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(267,'Simarsoit','Toba',NULL,'Naisuanon',244,224,'Submarga Si Raja Oloan / Sihotang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(268,'Simatupang','Toba','Pangururan','Lontung',NULL,39,'Putra kelima Si Raja Lontung','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(269,'Simbolon','Toba','Sianjur Mula-mula','Naiambaton',NULL,47,'Putra sulung Nai Ambaton','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(270,'Simbulan','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(271,'Simorangkir','Toba',NULL,'Naisuanon',NULL,251,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(272,'Sinabariba','Toba',NULL,'Naisuanon',NULL,203,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(273,'Sinabang','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(274,'Sinabutar','Pakpak',NULL,NULL,NULL,NULL,'Alias Sidabutar di Pakpak','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(275,'Sinaga','Toba','Pangururan','Lontung',NULL,36,'Putra kedua Si Raja Lontung','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(276,'Sinambela','Toba',NULL,'Naisuanon',NULL,213,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(277,'Sinamo','Toba',NULL,'Naisuanon',NULL,219,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(278,'Sinisuka','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(279,'Sinubulan','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(280,'Sinuhaji','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(281,'Sinukaban','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(282,'Sinukapar','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(283,'Sinulaki','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(284,'Sinulingga','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(285,'Sinupayung','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(286,'Sinuraya','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(287,'Sinusinga','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(288,'Sinurat','Toba',NULL,'Naisuanon',NULL,197,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(289,'Sipahutar','Toba','Tapanuli Utara','Borbor',NULL,63,'Submarga Datu Taladibabana (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(290,'Sipangkar','Toba',NULL,'Naisuanon',NULL,188,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(291,'Siampapaga','Toba',NULL,'Naiambaton',NULL,NULL,'Submarga Nainggolan / Nahampun','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(292,'Sipardabuan','Toba',NULL,'Naisuanon',244,222,'Submarga Si Raja Oloan / Sihotang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(293,'Sipayung','Toba',NULL,'Naisuanon',NULL,189,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(294,'Sipoldas','Simalungun',NULL,NULL,199,NULL,'Submarga Saragih','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(295,'Sirait','Toba',NULL,'Nairasaon',NULL,159,'Submarga Raja Mardopang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(296,'Siregar','Toba','Sipirok','Lontung',NULL,41,'Putra ketujuh Si Raja Lontung','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(297,'Siringoringo','Toba',NULL,'Lontung',309,86,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(298,'Sitanggang','Toba',NULL,'Naiambaton',NULL,152,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(299,'Sitakar','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(300,'Sitepu','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(301,'Sitindaon','Toba',NULL,'Naisuanon',243,236,'Submarga Si Raja Sumba / Sihombing','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(302,'Sitinjak','Toba',NULL,'Lontung',NULL,111,'Submarga Pandiangan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(303,'Sitio','Toba',NULL,'Naiambaton',NULL,156,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(304,'Sitohang','Toba',NULL,'Lontung',309,90,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(305,'Sitompul','Toba',NULL,'Naisuanon',NULL,245,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(306,'Sitopu','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(307,'Sitorus','Toba',NULL,'Nairasaon',NULL,158,'Submarga Raja Mardopang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(308,'Situmeang','Toba',NULL,'Naisuanon',NULL,262,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(309,'Situmorang','Toba','Pangururan','Lontung',NULL,35,'Putra sulung Si Raja Lontung','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(310,'Situngkir','Toba',NULL,'Naisuanon',NULL,187,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(311,'Sola','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(312,'Solin','Toba',NULL,'Lontung',309,93,'Submarga Situmorang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(313,'Sorganimusu','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(314,'Sorimunggu','Toba',NULL,'Naisuanon',119,243,'Submarga Si Raja Sumba / Manalu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(315,'Sormin','Toba',NULL,'Lontung',296,131,'Submarga Siregar','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(316,'Sugihen','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(317,'Suka','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(318,'Surbakti','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(319,'Tamba','Toba','Sianjur Mula-mula','Naiambaton',NULL,48,'Putra kedua Nai Ambaton','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(320,'Tambak','Toba',NULL,'Naisuanon',NULL,234,'Submarga Si Raja Sumba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(321,'Tambun','Toba',NULL,'Naisuanon',NULL,195,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(322,'Tambunan','Toba',NULL,'Naisuanon',NULL,195,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(323,'Tampubolon','Toba','Balige','Naisuanon',NULL,53,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(324,'Tampune','Karo',NULL,NULL,59,NULL,'Submarga Ginting','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(325,'Tanjung','Toba','Tapanuli Utara','Borbor',NULL,65,'Submarga Datu Taladibabana (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(326,'Tarihoran','Toba',NULL,'Borbor',NULL,77,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(327,'Tegur','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(328,'Tekang','Karo',NULL,NULL,205,NULL,'Submarga Sembiring','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(329,'Tendang','Pakpak',NULL,NULL,NULL,2,'Submarga Ompu Bada / Si Onom Kodin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(330,'Tinambunan','Toba',NULL,'Naiambaton',269,132,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(331,'Tinendung','Pakpak',NULL,NULL,269,NULL,'Submarga Simbolon (Si Onom Hudon)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(332,'Togatorop','Toba',NULL,'Lontung',268,121,'Submarga Simatupang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(333,'Tomog','Simalungun',NULL,NULL,46,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(334,'Tondang','Simalungun',NULL,NULL,177,75,'Submarga Purba','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(335,'Torbandolok','Toba',NULL,'Naisuanon',244,223,'Submarga Si Raja Oloan / Sihotang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(336,'Torong','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(337,'Tua','Karo',NULL,NULL,NULL,54,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(338,'Tumanggor','Toba',NULL,'Naiambaton',269,133,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(339,'Turnip','Toba',NULL,'Naiambaton',NULL,155,'Submarga Munte Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(340,'Turutan','Toba',NULL,'Naiambaton',269,135,'Submarga Simbolon Tua','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(341,'Ujung','Toba',NULL,'Naisuanon',NULL,205,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(342,'Ujungsaribu','Toba',NULL,'Naisuanon',NULL,205,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(343,'Usang','Simalungun',NULL,NULL,NULL,NULL,'Submarga Damanik','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(344,'Ace','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(345,'Badan','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(346,'Chaniago','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir). Asal Minang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(347,'Malabu','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(348,'Priaman','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir). Asal Minang','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(349,'Rao','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(350,'Saribu','Pasisi',NULL,NULL,NULL,68,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(351,'Sibuaya','Pasisi',NULL,NULL,NULL,NULL,'Batak Pasisi (Pesisir)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(352,'Nasution Bototan','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(353,'Nasution Loncat','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(354,'Nasution Tangga Ambeng','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(355,'Nasution Simanggintir','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(356,'Nasution Manggis','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(357,'Nasution Jor','Mandailing',NULL,NULL,147,NULL,'Submarga Nasution','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(358,'Lubis Hatonopan','Mandailing',NULL,NULL,105,NULL,'Submarga Lubis','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(359,'Lubis Singasoro','Mandailing',NULL,NULL,105,NULL,'Submarga Lubis','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(360,'Bangun','Karo',NULL,NULL,NULL,NULL,'Submarga Tarigan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(361,'Barusa','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(362,'Dapari','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(363,'Daulae','Mandailing',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(364,'Gajadiri','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(365,'Hotmatua','Toba',NULL,'Naisuanon',NULL,NULL,'Submarga Si Bagot Ni Pohan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(366,'Karosekali','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(367,'Kombara','Karo',NULL,NULL,NULL,NULL,'Submarga Karo-karo','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(368,'Lumbandolok','Toba',NULL,'Naiambaton',143,NULL,'Submarga Nainggolan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(369,'Mahabunga','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(370,'Maliam','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(371,'Martumpu','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(372,'Mataniari','Toba',NULL,'Naisuanon',NULL,220,'Submarga Si Raja Oloan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(373,'Mismis','Toba',NULL,'Naisuanon',NULL,254,'Submarga Si Raja Sobu','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(374,'Mukur','Toba',NULL,'Naisuanon',NULL,265,'Submarga Toga Naipospos','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(375,'Pinem','Karo',NULL,NULL,171,NULL,'Submarga Perangin-angin','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(376,'Pospos','Angkola',NULL,NULL,NULL,60,'Alias Naipospos di Angkola','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(377,'Ramin','Pakpak',NULL,NULL,NULL,NULL,NULL,'Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(378,'Sibabiat','Toba',NULL,NULL,NULL,NULL,'Alias Bayoangin/Babiat','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(379,'Sunge','Toba',NULL,'Naisuanon',322,201,'Submarga Si Lahi Sabungan / Tambunan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(380,'Tambun Saribu','Toba',NULL,'Naisuanon',322,NULL,'Submarga Si Lahi Sabungan','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(381,'Tangkar','Toba',NULL,'Borbor',NULL,74,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)'),(382,'Tinendang','Toba',NULL,'Borbor',NULL,73,'Submarga Datu Dalu (Borbor)','Wikipedia - Daftar marga Batak; H.B. Situmorang (1983)');
/*!40000 ALTER TABLE `marga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marga_alias`
--

DROP TABLE IF EXISTS `marga_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marga_alias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marga_id` int(11) NOT NULL,
  `alias_nama` varchar(200) NOT NULL,
  `sub_suku` varchar(100) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `sumber` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marga_id` (`marga_id`),
  CONSTRAINT `marga_alias_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marga_alias`
--

LOCK TABLES `marga_alias` WRITE;
/*!40000 ALTER TABLE `marga_alias` DISABLE KEYS */;
INSERT INTO `marga_alias` VALUES (1,134,'Dalimunthe','Angkola/Mandailing','Munte di Angkola/Mandailing disebut Dalimunthe','Wikipedia; budaya-indonesia.org'),(2,134,'Munthe','Simalungun','Munte di Simalungun disebut Munthe','Wikipedia; budaya-indonesia.org'),(3,134,'Dalimunte','Angkola','Variasi Dalimunthe','Wikipedia; budaya-indonesia.org'),(4,141,'Bako','Pakpak','Naibaho di Pakpak disebut Bako','Wikipedia; budaya-indonesia.org'),(5,141,'Baho','Pakpak','Variasi Bako','Wikipedia; budaya-indonesia.org'),(6,240,'Kaloko','Pakpak','Sihaloho di Pakpak disebut Kaloko','Wikipedia; budaya-indonesia.org'),(7,244,'Siketang','Pakpak','Sihotang di Pakpak disebut Siketang','Wikipedia; budaya-indonesia.org'),(8,102,'Lembeng','Pakpak','Limbong di Pakpak disebut Lembeng','Wikipedia; budaya-indonesia.org'),(9,221,'Sinabutar','Pakpak','Sidabutar di Pakpak disebut Sinabutar','Wikipedia; budaya-indonesia.org'),(10,28,'Barutu','Pakpak','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(11,144,'Pospos','Angkola','Naipospos di Angkola disebut Pospos','Wikipedia; budaya-indonesia.org'),(12,269,'Siambaton','Pakpak','Simbolon di Pakpak','Wikipedia; budaya-indonesia.org'),(13,199,'Saragi','Toba','Saragih di Toba disebut Saragi','Wikipedia; budaya-indonesia.org'),(14,46,'Manik','Toba','Damanik berasal dari Manik (Silau Raja)','Wikipedia; budaya-indonesia.org'),(15,205,'Meliala','Karo','Sembiring/Meliala dari Si Raja Huta Lima (Toba)','Wikipedia; budaya-indonesia.org'),(16,59,'Manik','Karo','Ginting Manik berasal dari Manik (Silau Raja)','Wikipedia; budaya-indonesia.org'),(17,378,'Babiat','Mandailing','Variasi Bayoangin/Babiat','Wikipedia; budaya-indonesia.org'),(18,378,'Bayoangin','Mandailing','Marga asli Si Raja Babiat','Wikipedia; budaya-indonesia.org'),(19,322,'Tambun','Toba','Tambunan = Tambun (Si Lahi Sabungan)','Wikipedia; budaya-indonesia.org'),(20,296,'Dongoran','Angkola','Siregar Dongoran di Angkola','Wikipedia; budaya-indonesia.org'),(21,296,'Ritonga','Angkola','Siregar Ritonga di Angkola','Wikipedia; budaya-indonesia.org'),(22,296,'Sormin','Angkola','Siregar Sormin di Angkola','Wikipedia; budaya-indonesia.org'),(23,296,'Siagian','Angkola','Siregar Siagian di Angkola','Wikipedia; budaya-indonesia.org'),(24,82,'Hutapea','Angkola','Hutapea juga di Angkola','Wikipedia; budaya-indonesia.org'),(25,177,'Purba Pakpak','Pakpak','Purba di Pakpak = Sidapakpak','Wikipedia; budaya-indonesia.org'),(26,329,'Tendang','Pakpak','Submarga Ompu Bada','Wikipedia; budaya-indonesia.org'),(27,113,'Tobing','Toba','Lumbantoruan = Lumban Tobing','Wikipedia; budaya-indonesia.org'),(28,112,'Tobing','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(29,297,'Ringo','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(30,148,'Ompu Sunggu','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(31,332,'Sitogatorop','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(32,264,'Imargolang','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(33,159,'Dosi','Toba','Variasi penulisan','Wikipedia; budaya-indonesia.org'),(34,242,'Limbong Sihole','Toba','Sihole = submarga Limbong','Wikipedia; budaya-indonesia.org');
/*!40000 ALTER TABLE `marga_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marga_hierarchy`
--

DROP TABLE IF EXISTS `marga_hierarchy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `marga_sub_suku`
--

DROP TABLE IF EXISTS `marga_sub_suku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marga_sub_suku` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marga_id` int(11) NOT NULL,
  `sub_suku` varchar(100) NOT NULL,
  `is_native` tinyint(1) DEFAULT 0,
  `keterangan` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_marga_suku` (`marga_id`,`sub_suku`),
  CONSTRAINT `marga_sub_suku_ibfk_1` FOREIGN KEY (`marga_id`) REFERENCES `marga` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=534 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marga_sub_suku`
--

LOCK TABLES `marga_sub_suku` WRITE;
/*!40000 ALTER TABLE `marga_sub_suku` DISABLE KEYS */;
INSERT INTO `marga_sub_suku` VALUES (1,1,'Karo',1,NULL),(2,2,'Toba',1,NULL),(3,3,'Pakpak',1,NULL),(4,4,'Pakpak',1,NULL),(5,5,'Toba',1,NULL),(6,6,'Toba',1,NULL),(7,7,'Mandailing',1,NULL),(8,8,'Karo',1,NULL),(9,9,'Pakpak',1,NULL),(10,10,'Pakpak',1,NULL),(11,11,'Toba',1,NULL),(12,12,'Pakpak',1,NULL),(13,13,'Pakpak',1,NULL),(14,14,'Simalungun',1,NULL),(15,15,'Toba',1,NULL),(16,16,'Simalungun',1,NULL),(17,17,'Toba',1,NULL),(18,18,'Karo',1,NULL),(19,19,'Toba',1,NULL),(20,20,'Toba',1,NULL),(21,21,'Toba',1,NULL),(22,22,'Simalungun',1,NULL),(23,23,'Karo',1,NULL),(24,24,'Pakpak',1,NULL),(25,25,'Karo',1,NULL),(26,26,'Pakpak',1,NULL),(27,27,'Pakpak',1,NULL),(28,28,'Pakpak',1,NULL),(29,29,'Pakpak',1,NULL),(30,30,'Toba',1,NULL),(31,31,'Toba',1,NULL),(32,32,'Toba',1,NULL),(33,33,'Karo',1,NULL),(34,34,'Toba',1,NULL),(35,35,'Karo',1,NULL),(36,36,'Toba',1,NULL),(37,37,'Karo',1,NULL),(38,38,'Karo',1,NULL),(39,39,'Karo',1,NULL),(40,40,'Toba',1,NULL),(41,41,'Karo',1,NULL),(42,42,'Pakpak',1,NULL),(43,43,'Karo',1,NULL),(44,44,'Simalungun',1,NULL),(45,45,'Angkola',1,NULL),(46,46,'Simalungun',1,NULL),(47,47,'Simalungun',1,NULL),(48,48,'Simalungun',1,NULL),(49,49,'Angkola',1,NULL),(50,50,'Mandailing',1,NULL),(51,51,'Toba',1,NULL),(52,52,'Toba',1,NULL),(53,53,'Toba',1,NULL),(54,54,'Toba',1,NULL),(55,55,'Pakpak',1,NULL),(56,56,'Karo',1,NULL),(57,57,'Karo',1,NULL),(58,58,'Karo',1,NULL),(59,59,'Karo',1,NULL),(60,60,'Toba',1,NULL),(61,61,'Karo',1,NULL),(62,62,'Toba',1,NULL),(63,63,'Toba',1,NULL),(64,64,'Toba',1,NULL),(65,65,'Toba',1,NULL),(66,66,'Karo',1,NULL),(67,67,'Karo',1,NULL),(68,68,'Karo',1,NULL),(69,69,'Toba',1,NULL),(70,70,'Mandailing',1,NULL),(71,71,'Toba',1,NULL),(72,72,'Simalungun',1,NULL),(73,73,'Toba',1,NULL),(74,74,'Toba',1,NULL),(75,75,'Toba',1,NULL),(76,76,'Toba',1,NULL),(77,77,'Toba',1,NULL),(78,78,'Toba',1,NULL),(79,79,'Toba',1,NULL),(80,80,'Toba',1,NULL),(81,81,'Karo',1,NULL),(82,82,'Toba',1,NULL),(83,83,'Toba',1,NULL),(84,84,'Mandailing',1,NULL),(85,85,'Toba',1,NULL),(86,86,'Toba',1,NULL),(87,87,'Karo',1,NULL),(88,88,'Karo',1,NULL),(89,89,'Karo',1,NULL),(90,90,'Karo',1,NULL),(91,91,'Karo',1,NULL),(92,92,'Karo',1,NULL),(93,93,'Pakpak',1,NULL),(94,94,'Karo',1,NULL),(95,95,'Karo',1,NULL),(96,96,'Karo',1,NULL),(97,97,'Karo',1,NULL),(98,98,'Karo',1,NULL),(99,99,'Pakpak',1,NULL),(100,100,'Pakpak',1,NULL),(101,101,'Pakpak',1,NULL),(102,102,'Toba',1,NULL),(103,103,'Toba',1,NULL),(104,104,'Karo',1,NULL),(105,105,'Mandailing',1,NULL),(106,106,'Toba',1,NULL),(107,107,'Toba',1,NULL),(108,108,'Toba',1,NULL),(109,109,'Toba',1,NULL),(110,110,'Toba',1,NULL),(111,111,'Toba',1,NULL),(112,112,'Toba',1,NULL),(113,113,'Toba',1,NULL),(114,114,'Toba',1,NULL),(115,115,'Toba',1,NULL),(116,116,'Toba',1,NULL),(117,117,'Toba',1,NULL),(118,118,'Toba',1,NULL),(119,119,'Toba',1,NULL),(120,120,'Toba',1,NULL),(121,121,'Toba',1,NULL),(122,122,'Pakpak',1,NULL),(123,123,'Toba',1,NULL),(124,124,'Toba',1,NULL),(125,125,'Mandailing',1,NULL),(126,126,'Toba',1,NULL),(127,127,'Karo',1,NULL),(128,128,'Angkola',1,NULL),(129,129,'Pakpak',1,NULL),(130,130,'Karo',1,NULL),(131,131,'Karo',1,NULL),(132,132,'Karo',1,NULL),(133,133,'Toba',1,NULL),(134,134,'Toba',1,NULL),(135,135,'Simalungun',1,NULL),(136,136,'Toba',1,NULL),(137,137,'Toba',1,NULL),(138,138,'Toba',1,NULL),(139,139,'Simalungun',1,NULL),(140,140,'Toba',1,NULL),(141,141,'Toba',1,NULL),(142,142,'Toba',1,NULL),(143,143,'Toba',1,NULL),(144,144,'Toba',1,NULL),(145,145,'Toba',1,NULL),(146,146,'Toba',1,NULL),(147,147,'Mandailing',1,NULL),(148,148,'Toba',1,NULL),(149,149,'Toba',1,NULL),(150,150,'Toba',1,NULL),(151,151,'Toba',1,NULL),(152,152,'Karo',1,NULL),(153,153,'Toba',1,NULL),(154,154,'Toba',1,NULL),(155,155,'Toba',1,NULL),(156,156,'Toba',1,NULL),(157,157,'Toba',1,NULL),(158,158,'Toba',1,NULL),(159,159,'Toba',1,NULL),(160,160,'Toba',1,NULL),(161,161,'Simalungun',1,NULL),(162,162,'Karo',1,NULL),(163,163,'Mandailing',1,NULL),(164,164,'Toba',1,NULL),(165,165,'Karo',1,NULL),(166,166,'Simalungun',1,NULL),(167,167,'Pakpak',1,NULL),(168,168,'Karo',1,NULL),(169,169,'Karo',1,NULL),(170,170,'Pakpak',1,NULL),(171,171,'Karo',1,NULL),(172,172,'Toba',1,NULL),(173,173,'Toba',1,NULL),(174,174,'Toba',1,NULL),(175,175,'Toba',1,NULL),(176,176,'Mandailing',1,NULL),(177,177,'Simalungun',1,NULL),(178,178,'Toba',1,NULL),(179,179,'Toba',1,NULL),(180,180,'Simalungun',1,NULL),(181,181,'Mandailing',1,NULL),(182,182,'Simalungun',1,NULL),(183,183,'Toba',1,NULL),(184,184,'Toba',1,NULL),(185,185,'Toba',1,NULL),(186,186,'Toba',1,NULL),(187,187,'Toba',1,NULL),(188,188,'Toba',1,NULL),(189,189,'Toba',1,NULL),(190,190,'Toba',1,NULL),(191,191,'Toba',1,NULL),(192,192,'Toba',1,NULL),(193,193,'Toba',1,NULL),(194,194,'Toba',1,NULL),(195,195,'Toba',1,NULL),(196,196,'Karo',1,NULL),(197,197,'Toba',1,NULL),(198,198,'Toba',1,NULL),(199,199,'Simalungun',1,NULL),(200,200,'Simalungun',1,NULL),(201,201,'Toba',1,NULL),(202,202,'Toba',1,NULL),(203,203,'Pakpak',1,NULL),(204,204,'Karo',1,NULL),(205,205,'Karo',1,NULL),(206,206,'Karo',1,NULL),(207,207,'Toba',1,NULL),(208,208,'Toba',1,NULL),(209,209,'Toba',1,NULL),(210,210,'Toba',1,NULL),(211,211,'Toba',1,NULL),(212,212,'Toba',1,NULL),(213,213,'Toba',1,NULL),(214,214,'Toba',1,NULL),(215,215,'Karo',1,NULL),(216,216,'Toba',1,NULL),(217,217,'Toba',1,NULL),(218,218,'Toba',1,NULL),(219,219,'Toba',1,NULL),(220,220,'Simalungun',1,NULL),(221,221,'Toba',1,NULL),(222,222,'Toba',1,NULL),(223,223,'Simalungun',1,NULL),(224,224,'Simalungun',1,NULL),(225,225,'Toba',1,NULL),(226,226,'Toba',1,NULL),(227,227,'Toba',1,NULL),(228,228,'Toba',1,NULL),(229,229,'Toba',1,NULL),(230,230,'Simalungun',1,NULL),(231,231,'Toba',1,NULL),(232,232,'Simalungun',1,NULL),(233,233,'Toba',1,NULL),(234,234,'Toba',1,NULL),(235,235,'Toba',1,NULL),(236,236,'Toba',1,NULL),(237,237,'Toba',1,NULL),(238,238,'Simalungun',1,NULL),(239,239,'Simalungun',1,NULL),(240,240,'Toba',1,NULL),(241,241,'Toba',1,NULL),(242,242,'Toba',1,NULL),(243,243,'Toba',1,NULL),(244,244,'Toba',1,NULL),(245,245,'Toba',1,NULL),(246,246,'Pakpak',1,NULL),(247,247,'Toba',1,NULL),(248,248,'Toba',1,NULL),(249,249,'Toba',1,NULL),(250,250,'Simalungun',1,NULL),(251,251,'Karo',1,NULL),(252,252,'Toba',1,NULL),(253,253,'Toba',1,NULL),(254,254,'Toba',1,NULL),(255,255,'Toba',1,NULL),(256,256,'Toba',1,NULL),(257,257,'Toba',1,NULL),(258,258,'Toba',1,NULL),(259,259,'Toba',1,NULL),(260,260,'Toba',1,NULL),(261,261,'Toba',1,NULL),(262,262,'Toba',1,NULL),(263,263,'Toba',1,NULL),(264,264,'Toba',1,NULL),(265,265,'Karo',1,NULL),(266,266,'Toba',1,NULL),(267,267,'Toba',1,NULL),(268,268,'Toba',1,NULL),(269,269,'Toba',1,NULL),(270,270,'Karo',1,NULL),(271,271,'Toba',1,NULL),(272,272,'Toba',1,NULL),(273,273,'Pakpak',1,NULL),(274,274,'Pakpak',1,NULL),(275,275,'Toba',1,NULL),(276,276,'Toba',1,NULL),(277,277,'Toba',1,NULL),(278,278,'Karo',1,NULL),(279,279,'Karo',1,NULL),(280,280,'Karo',1,NULL),(281,281,'Karo',1,NULL),(282,282,'Karo',1,NULL),(283,283,'Karo',1,NULL),(284,284,'Karo',1,NULL),(285,285,'Karo',1,NULL),(286,286,'Karo',1,NULL),(287,287,'Karo',1,NULL),(288,288,'Toba',1,NULL),(289,289,'Toba',1,NULL),(290,290,'Toba',1,NULL),(291,291,'Toba',1,NULL),(292,292,'Toba',1,NULL),(293,293,'Toba',1,NULL),(294,294,'Simalungun',1,NULL),(295,295,'Toba',1,NULL),(296,296,'Toba',1,NULL),(297,297,'Toba',1,NULL),(298,298,'Toba',1,NULL),(299,299,'Pakpak',1,NULL),(300,300,'Karo',1,NULL),(301,301,'Toba',1,NULL),(302,302,'Toba',1,NULL),(303,303,'Toba',1,NULL),(304,304,'Toba',1,NULL),(305,305,'Toba',1,NULL),(306,306,'Pakpak',1,NULL),(307,307,'Toba',1,NULL),(308,308,'Toba',1,NULL),(309,309,'Toba',1,NULL),(310,310,'Toba',1,NULL),(311,311,'Simalungun',1,NULL),(312,312,'Toba',1,NULL),(313,313,'Pakpak',1,NULL),(314,314,'Toba',1,NULL),(315,315,'Toba',1,NULL),(316,316,'Karo',1,NULL),(317,317,'Karo',1,NULL),(318,318,'Karo',1,NULL),(319,319,'Toba',1,NULL),(320,320,'Toba',1,NULL),(321,321,'Toba',1,NULL),(322,322,'Toba',1,NULL),(323,323,'Toba',1,NULL),(324,324,'Karo',1,NULL),(325,325,'Toba',1,NULL),(326,326,'Toba',1,NULL),(327,327,'Karo',1,NULL),(328,328,'Karo',1,NULL),(329,329,'Pakpak',1,NULL),(330,330,'Toba',1,NULL),(331,331,'Pakpak',1,NULL),(332,332,'Toba',1,NULL),(333,333,'Simalungun',1,NULL),(334,334,'Simalungun',1,NULL),(335,335,'Toba',1,NULL),(336,336,'Karo',1,NULL),(337,337,'Karo',1,NULL),(338,338,'Toba',1,NULL),(339,339,'Toba',1,NULL),(340,340,'Toba',1,NULL),(341,341,'Toba',1,NULL),(342,342,'Toba',1,NULL),(343,343,'Simalungun',1,NULL),(344,344,'Pasisi',1,NULL),(345,345,'Pasisi',1,NULL),(346,346,'Pasisi',1,NULL),(347,347,'Pasisi',1,NULL),(348,348,'Pasisi',1,NULL),(349,349,'Pasisi',1,NULL),(350,350,'Pasisi',1,NULL),(351,351,'Pasisi',1,NULL),(352,352,'Mandailing',1,NULL),(353,353,'Mandailing',1,NULL),(354,354,'Mandailing',1,NULL),(355,355,'Mandailing',1,NULL),(356,356,'Mandailing',1,NULL),(357,357,'Mandailing',1,NULL),(358,358,'Mandailing',1,NULL),(359,359,'Mandailing',1,NULL),(360,360,'Karo',1,NULL),(361,361,'Pakpak',1,NULL),(362,362,'Pakpak',1,NULL),(363,363,'Mandailing',1,NULL),(364,364,'Pakpak',1,NULL),(365,365,'Toba',1,NULL),(366,366,'Karo',1,NULL),(367,367,'Karo',1,NULL),(368,368,'Toba',1,NULL),(369,369,'Pakpak',1,NULL),(370,370,'Pakpak',1,NULL),(371,371,'Pakpak',1,NULL),(372,372,'Toba',1,NULL),(373,373,'Toba',1,NULL),(374,374,'Toba',1,NULL),(375,375,'Karo',1,NULL),(376,376,'Angkola',1,NULL),(377,377,'Pakpak',1,NULL),(378,378,'Toba',1,NULL),(379,379,'Toba',1,NULL),(380,380,'Toba',1,NULL),(381,381,'Toba',1,NULL),(382,382,'Toba',1,NULL),(384,2,'Simalungun',0,'Cross-suku'),(386,5,'Simalungun',0,'Cross-suku'),(388,20,'Angkola',0,'Cross-suku'),(389,20,'Mandailing',0,'Cross-suku'),(390,24,'Toba',0,'Cross-suku'),(392,27,'Toba',0,'Cross-suku'),(395,30,'Karo',0,'Cross-suku'),(397,36,'Pakpak',0,'Cross-suku'),(399,46,'Karo',0,'Cross-suku'),(401,45,'Mandailing',0,'Cross-suku'),(402,45,'Simalungun',0,'Cross-suku'),(404,54,'Angkola',0,'Cross-suku'),(406,59,'Pakpak',0,'Cross-suku'),(408,62,'Simalungun',0,'Cross-suku'),(409,70,'Toba',0,'Cross-suku'),(411,70,'Angkola',0,'Cross-suku'),(413,73,'Angkola',0,'Cross-suku'),(414,73,'Mandailing',0,'Cross-suku'),(416,82,'Angkola',0,'Cross-suku'),(418,83,'Karo',0,'Cross-suku'),(419,84,'Toba',0,'Cross-suku'),(421,84,'Angkola',0,'Cross-suku'),(423,103,'Karo',0,'Cross-suku'),(424,105,'Toba',0,'Cross-suku'),(427,119,'Simalungun',0,'Cross-suku'),(428,119,'Karo',0,'Cross-suku'),(430,121,'Karo',0,'Cross-suku'),(431,121,'Simalungun',0,'Cross-suku'),(432,121,'Pakpak',0,'Cross-suku'),(434,126,'Angkola',0,'Cross-suku'),(436,134,'Pakpak',0,'Cross-suku'),(437,134,'Simalungun',0,'Cross-suku'),(438,134,'Angkola',0,'Cross-suku'),(439,134,'Mandailing',0,'Cross-suku'),(441,147,'Angkola',0,'Cross-suku'),(442,147,'Toba',0,'Cross-suku'),(444,143,'Angkola',0,'Cross-suku'),(446,155,'Mandailing',0,'Cross-suku'),(447,155,'Angkola',0,'Cross-suku'),(449,151,'Angkola',0,'Cross-suku'),(451,159,'Karo',0,'Cross-suku'),(453,164,'Angkola',0,'Cross-suku'),(455,174,'Pasisi',0,'Cross-suku'),(456,176,'Toba',0,'Cross-suku'),(458,176,'Angkola',0,'Cross-suku'),(460,177,'Toba',0,'Cross-suku'),(461,177,'Karo',0,'Cross-suku'),(462,177,'Pakpak',0,'Cross-suku'),(464,178,'Mandailing',0,'Cross-suku'),(465,178,'Simalungun',0,'Cross-suku'),(467,183,'Angkola',0,'Cross-suku'),(469,199,'Toba',0,'Cross-suku'),(470,199,'Pakpak',0,'Cross-suku'),(472,202,'Angkola',0,'Cross-suku'),(473,202,'Mandailing',0,'Cross-suku'),(475,214,'Angkola',0,'Cross-suku'),(477,219,'Simalungun',0,'Cross-suku'),(479,240,'Pakpak',0,'Cross-suku'),(481,243,'Karo',0,'Cross-suku'),(483,244,'Pakpak',0,'Cross-suku'),(485,235,'Pakpak',0,'Cross-suku'),(487,248,'Karo',0,'Cross-suku'),(489,255,'Simalungun',0,'Cross-suku'),(491,266,'Simalungun',0,'Cross-suku'),(493,268,'Angkola',0,'Cross-suku'),(495,269,'Pakpak',0,'Cross-suku'),(496,269,'Karo',0,'Cross-suku'),(498,276,'Karo',0,'Cross-suku'),(499,276,'Pakpak',0,'Cross-suku'),(501,289,'Mandailing',0,'Cross-suku'),(502,289,'Angkola',0,'Cross-suku'),(504,307,'Angkola',0,'Cross-suku'),(506,298,'Pakpak',0,'Cross-suku'),(508,303,'Simalungun',0,'Cross-suku'),(510,305,'Karo',0,'Cross-suku'),(512,315,'Angkola',0,'Cross-suku'),(514,322,'Angkola',0,'Cross-suku'),(516,323,'Angkola',0,'Cross-suku'),(518,325,'Mandailing',0,'Cross-suku'),(519,325,'Angkola',0,'Cross-suku'),(521,326,'Angkola',0,'Cross-suku'),(523,330,'Pakpak',0,'Cross-suku'),(525,338,'Pakpak',0,'Cross-suku'),(526,338,'Karo',0,'Cross-suku'),(528,339,'Simalungun',0,'Cross-suku'),(530,340,'Pakpak',0,'Cross-suku'),(532,341,'Karo',0,'Cross-suku'),(533,341,'Pakpak',0,'Cross-suku');
/*!40000 ALTER TABLE `marga_sub_suku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marriage_stages`
--

DROP TABLE IF EXISTS `marriage_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `tipe` enum('acara','pesan','pengumuman','iuran','lainnya') NOT NULL,
  `type` varchar(50) DEFAULT 'info',
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `judul` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `konten` text DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  `status` enum('unread','read','archived') DEFAULT 'unread',
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
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
INSERT INTO `notifications` VALUES (1,2,'acara','info',NULL,NULL,NULL,'Rapat Tahunan',NULL,NULL,'Undangan rapat tahunan punguan','/events/1','unread',0,NULL,'2026-06-15 13:13:21',NULL),(2,3,'pengumuman','info',NULL,NULL,NULL,'Undangan Rapat',NULL,NULL,'Undangan rapat tahunan punguan','/announcements/1','unread',0,NULL,'2026-06-15 13:13:21',NULL),(3,2,'acara','info',NULL,NULL,NULL,'Rapat Tahunan',NULL,NULL,'Undangan rapat tahunan punguan','/events/1','unread',0,NULL,'2026-06-20 09:11:24',NULL),(4,3,'pengumuman','info',NULL,NULL,NULL,'Undangan Rapat',NULL,NULL,'Undangan rapat tahunan punguan','/announcements/1','unread',0,NULL,'2026-06-20 09:11:24',NULL);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oral_traditions`
--

DROP TABLE IF EXISTS `oral_traditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `partuturan_log`
--

DROP TABLE IF EXISTS `partuturan_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partuturan_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `node_id_1` int(11) NOT NULL,
  `node_id_2` int(11) NOT NULL,
  `sebutan_batak` varchar(100) DEFAULT NULL,
  `sebutan_indonesia` varchar(100) DEFAULT NULL,
  `tingkat_kekerabatan` int(11) DEFAULT NULL,
  `jalur` text DEFAULT NULL,
  `dihitung_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_partuturan` (`node_id_1`,`node_id_2`),
  KEY `node_id_2` (`node_id_2`),
  CONSTRAINT `partuturan_log_ibfk_1` FOREIGN KEY (`node_id_1`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE CASCADE,
  CONSTRAINT `partuturan_log_ibfk_2` FOREIGN KEY (`node_id_2`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partuturan_log`
--

LOCK TABLES `partuturan_log` WRITE;
/*!40000 ALTER TABLE `partuturan_log` DISABLE KEYS */;
INSERT INTO `partuturan_log` VALUES (1,1,2,'Anak','Anak laki-laki',1,'Ompu Bada â† [LCA: Ompu Bada] â†’ Ompu Bada â†’ Tendang','2026-06-20 20:36:57');
/*!40000 ALTER TABLE `partuturan_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pasangan`
--

DROP TABLE IF EXISTS `pasangan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pasangan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `silsilah_node_id` int(11) NOT NULL COMMENT 'ID suami di silsilah_mitolologis',
  `nama` varchar(200) NOT NULL COMMENT 'Nama istri',
  `boru_marga` varchar(200) DEFAULT NULL COMMENT 'Marga asal istri (marga ayah)',
  `urutan_istri` int(11) DEFAULT 1 COMMENT 'Istri ke berapa (1, 2, 3)',
  `info_perkawinan` text DEFAULT NULL,
  `wilayah` varchar(100) DEFAULT NULL,
  `sumber` varchar(200) DEFAULT 'W.M. Hutagalung (1926)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_silsilah_node` (`silsilah_node_id`),
  CONSTRAINT `pasangan_ibfk_1` FOREIGN KEY (`silsilah_node_id`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pasangan`
--

LOCK TABLES `pasangan` WRITE;
/*!40000 ALTER TABLE `pasangan` DISABLE KEYS */;
INSERT INTO `pasangan` VALUES (1,12,'Si Boru Pareme (kembar)','Tampubolon',1,'Kembar dgn Pareme. Kawin incest â†’ diusir. Keturunan: Si Raja Lontung, Si Raja Borbor, Si Raja Babiat',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(2,12,'Nai Margiring Laut','Tampubolon',2,'Istri kedua. Keturunan: Tuan Sorimangaraja',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(3,12,'Harimau Betina',NULL,3,'Istri ketua (mitos). Keturunan: Si Raja Babiat (versi lain)',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(4,20,'Si Boru Anting Malela (Nai Rasaon)','Tampubolon',1,'Istri 1 â†’ Nai Rasaon. Keturunan: Tuan Sorbadijae (Nai Rasaon), Raja Mardopang, Raja Mangatur',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(5,20,'Si Boru Biding Laut (Nai Ambaton)','Tampubolon',2,'Istri 2 â†’ Nai Ambaton. Keturunan: Tuan Sorbadijulu (Nai Ambaton), Simbolon, Tamba, Saragi, Munte',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(6,20,'Si Boru Sanggul Baomasan (Nai Suanon)','Tampubolon',3,'Istri 3 â†’ Nai Suanon. Keturunan: Tuan Sorbadibanua (Nai Suanon)',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(7,34,'Putri Sariburaja','Tampubolon',1,'Istri 1 (putri Sariburaja). 5 putra: Si Bagot Ni Pohan, Si Paet Tua, Si Lahi Sabungan, Si Raja Oloan, Si Raja Huta Lima',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(8,34,'Boru Sibasopaet','Tampubolon',2,'Istri 2. 3 putra: Si Raja Sumba, Si Raja Sobu, Toga Naipospos',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(9,58,'Si Boru Anakpandan','Tampubolon',1,'Istri 1 (putri Lontung). Keturunan: Simamora, Rambe, Purba, Manalu, Debataraja, Girsang, Tambak, Siboro, Sitindaon, Binjori',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(10,58,'Si Boru Panggabean','Tampubolon',2,'Istri 2 (putri Lontung). Keturunan: Sihombing si Opat Ama â†’ Silaban, Lumbantoruan, Nababan, Hutasoit',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(11,8,'Si Boru Nai Mula Uji','Si Boru Nai Mula Uji',1,'Bermukim di Pusuk Buhit, Sianjur Mula-mula',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(12,9,'Si Boru Soping Sopang','Si Boru Soping Sopang',1,'Golongan Tatea Bulan = Pemberi Perempuan (Hula-hula)',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(13,10,'Si Boru Anting Sabungan','Si Boru Anting Sabungan',1,'Golongan Isombaon = Laki-laki (Boru)',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(14,11,'Si Boru Anting Nai Bolon','Tampubolon',1,'Raja Uti wafat muda, keturunannya tidak dikenal. Ada versi yang menyebut keturunan Raja Uti menjadi marga Tampubolon.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(15,13,'Si Boru Pinta Omas','Si Boru Pinta Omas',1,'Bermarga Limbong',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(16,14,'Si Boru Anting Sabungan','Si Boru Anting Sabungan',1,'Bermarga Sagala',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(17,15,'Si Boru Anting Menalam','Si Boru Anting Menalam',1,'4 putra: Malau, Manik, Ambarita, Gurning',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(18,19,'Tuan Sariburaja','Tuan Sariburaja',1,'Kawin incest â†’ Si Raja Lontung',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(19,21,'Si Boru Anting Manis','Tampubolon',1,'Putra Raja Isumbaon dari istri kedua. Keturunannya tidak banyak dikenal.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(20,22,'Si Boru Biding','Tampubolon',1,'Putra Raja Isumbaon. Keturunannya tersebar di Silindung.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(21,23,'Si Boru Anak Pardomuan','Si Boru Anak Pardomuan',1,'7 putra + 2 putri = Si Sia Marina',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(22,24,'Si Boru Anting Mela','Si Boru Anting Mela',1,'Bermarga Borbor',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(23,25,'Si Boru Anting Mela','Borbor',1,'Putra Sariburaja dari istri kedua. Bermarga Bayoangin/Babiat.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(24,26,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra sulung Silau Raja. Bermarga Malau.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(25,27,'Si Boru Anting Mela','Borbor',1,'Putra Silau Raja. Bermarga Manik/Damanik (Simalungun).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(26,28,'Si Boru Anting Malela','Tampubolon',1,'Putra Silau Raja. Bermarga Ambarita (Simalungun).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(27,29,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra Silau Raja. Bermarga Gurning.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(28,30,'Si Boru Anting Mela','Borbor',1,'Putra Limbong Mulana. Bermarga Limbong (Palu Onggang).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(29,31,'Si Boru Anting Malela','Tampubolon',1,'Putra Limbong Mulana. Bermarga Limbong (Langgat).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(30,32,'Si Boru Biding Laut','Tampubolon',1,'Putra sulung Sorimangaraja â†’ Nai Ambaton. Istri: Si Boru Biding Laut (kembar dgn Nai Ambaton).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(31,33,'Si Boru Sanggul Baomasan','Tampubolon',1,'Putra kedua Sorimangaraja â†’ Nai Rasaon. Istri: Si Boru Sanggul Baomasan.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(32,35,'Si Boru Anting Mela','Borbor',1,'Putra sulung Si Raja Lontung. Bermarga Situmorang. Istri dari marga Borbor.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(33,36,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra kedua Si Raja Lontung. Bermarga Sinaga.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(34,37,'Si Boru Anting Malela','Tampubolon',1,'Putra ketiga Si Raja Lontung. Bermarga Pandiangan.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(35,38,'Si Boru Anting Mela','Borbor',1,'Putra keempat Si Raja Lontung. Bermarga Nainggolan. Istri dari marga Borbor.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(36,39,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra kelima Si Raja Lontung. Bermarga Simatupang.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(37,40,'Si Boru Anting Malela','Tampubolon',1,'Putra keenam Si Raja Lontung. Bermarga Aritonang.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(38,41,'Si Boru Anting Mela','Borbor',1,'Putra ketujuh Si Raja Lontung. Bermarga Siregar. Istri dari marga Borbor.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(39,42,'Toga Sihombing','Toga Sihombing',1,'â†’ Sihombing si Opat Ama',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(40,43,'Toga Simamora','Toga Simamora',1,'â†’ Simamora',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(41,44,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra Langgat Limbong. Tetap marga Limbong.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(42,45,'Si Boru Anting Malela','Tampubolon',1,'Putra Langgat Limbong. Bermarga Sihole.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(43,46,'Si Boru Anting Mela','Borbor',1,'Putra Langgat Limbong. Bermarga Habeahan.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(44,47,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra Nai Ambaton. Bermarga Simbolon. Si Onom Hudon: Tinambunan, Tumanggor, Maharaja, Turutan, Nahampun, Pinayungan.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(45,48,'Si Boru Anting Malela','Tampubolon',1,'Putra Nai Ambaton. Bermarga Tamba. 9 putra: Siallagan, Tomok, Sidabutar, Sijabat, Gusar, Siadari, Sidabolak, Rumahorbo, Napitu.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(46,49,'Si Boru Anting Mela','Borbor',1,'Putra Nai Ambaton. Bermarga Saragi/Saragih. 5 putra: Simalango, Saing, Simarmata, Nadeak, Sidabungke. Simalungunâ†’Saragih.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(47,50,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra Nai Ambaton. Bermarga Munte. 6 putra: Sitanggang, Manihuruk, Sidauruk, Turnip, Sitio, Sigalingging.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(48,51,'Si Boru Anting Malela','Tampubolon',1,'Putra Nai Rasaon. 3 putra: Sitorus, Sirait, Butarbutar.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(49,52,'Si Boru Anting Mela','Borbor',1,'Putra Nai Rasaon. Putra: Toga Manurung.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(50,53,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra sulung Nai Suanon. Keturunan: Tampubolon, Baringbing, Silaen, Siahaan, Simanjuntak, Hutagaol, Nasution, Panjaitan, Siagian, Silitonga, Sianipar, Pardosi, Simangunsong, Marpaung, Napitupulu, Pardede.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(51,54,'Si Boru Anting Malela','Tampubolon',1,'Putra kedua Nai Suanon. Keturunan: Hutahaean, Hutajulu, Aruan, Sibarani, Sibuea, Sarumpaet, Pangaribuan, Hutapea.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(52,55,'Si Boru Pareme','Tampubolon',1,'Putra ketiga Nai Suanon. Istri: Si Boru Pareme (putri Tuan Sariburaja, kembar dgn Pareme). Kawin incest â†’ Silalahi. Keturunan: Sihaloho, Situngkir, Sipangkar, Sipayung, Sirumasondi, Sidabutar, Sidabariba, Pintubatu, Sigiro, Tambun/Tambunan, Doloksaribu, Sinurat, Naiborhu, dll.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(53,56,'Si Boru Anting Mela','Borbor',1,'Putra keempat Nai Suanon. Istri dari marga Borbor. Keturunan: Naibaho, Sihotang, Hasugian, Lingga, Sinambela, Sihite, Simanullang, Bintang, Ujung, dll.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(54,57,'Si Boru Anting Nai Bolon','Tampubolon',1,'Putra kelima Nai Suanon. Keturunan: Maha, Sambo, Pardosi, Sembiring Meliala (pindah ke Karo).',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(55,59,'Si Boru Anting Malela','Tampubolon',1,'Putra ketujuh Nai Suanon. Keturunan: Sitompul, Hasibuan, Hutabarat, Panggabean, Hutagalung, Hutatoruan, Simorangkir, Hutapea, Lumbantobing, Mismis.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(56,60,'Si Boru Anting Mela','Borbor',1,'Putra kedelapan Nai Suanon. Istri dari marga Borbor. Keturunan: Marbun, Lumbanbatu, Banjarnahor, Lumbangaol, Sibagariang, Hutauruk, Simanungkalit, Situmeang.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:45:45'),(57,1,'Si Boru Nai Bolon','Tampubolon',1,'Istri Ompu Bada. Nama tidak terdokumentasi dalam sumber.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:55:28'),(58,61,'Si Boru Anting Nai Bolon','Tampubolon',1,'Istri Datu Taladibabana. Leluhur marga Angkola/Mandailing.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:55:28'),(59,231,'Si Boru Anting Mela','Borbor',1,'Istri Manalu. Keturunan: Rumabutar, Rumagorga, Rumahole, Rumaijuk, Sigukguhi, Sorimunggu, Boangmanalu.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:55:28'),(60,62,'Si Boru Anting Malela','Tampubolon',1,'Istri Datu Dalu. Keturunan: Pasaribu, Batubara, Habeahan, Bondar, Gorat, Tinendang, Tangkar, Matondang, Saruksuk, Tarihoran, Parapat, Rangkuti.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:55:28'),(61,66,'Si Boru Anting Nai Bolon','Tampubolon',1,'Istri Datu Pulungan. Keturunan: Lubis, Hutasuhut.',NULL,'W.M. Hutagalung (1926)','2026-06-20 20:55:28');
/*!40000 ALTER TABLE `pasangan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `raja_batak`
--

DROP TABLE IF EXISTS `raja_batak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `raja_batak` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `gelar` varchar(255) DEFAULT NULL,
  `kerajaan` varchar(100) DEFAULT NULL,
  `masa_jabatan` varchar(100) DEFAULT NULL,
  `silsilah_mitolologis_id` int(11) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `sumber_sejarah` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `silsilah_mitolologis_id` (`silsilah_mitolologis_id`),
  KEY `idx_kerajaan` (`kerajaan`),
  CONSTRAINT `raja_batak_ibfk_1` FOREIGN KEY (`silsilah_mitolologis_id`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `raja_batak`
--

LOCK TABLES `raja_batak` WRITE;
/*!40000 ALTER TABLE `raja_batak` DISABLE KEYS */;
/*!40000 ALTER TABLE `raja_batak` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rumah_keluarga`
--

DROP TABLE IF EXISTS `rumah_keluarga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
-- Table structure for table `silsilah_mitolologis`
--

DROP TABLE IF EXISTS `silsilah_mitolologis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `silsilah_mitolologis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(200) NOT NULL,
  `jenis_kelamin` enum('L','P') DEFAULT 'L',
  `status_hidup` enum('hidup','wafat','mitologis') DEFAULT 'mitologis',
  `is_private` tinyint(1) DEFAULT 0,
  `tanggal_lahir` varchar(50) DEFAULT NULL,
  `tanggal_wafat` varchar(50) DEFAULT NULL,
  `orang_tuan_id` int(11) DEFAULT NULL,
  `ibu_id` int(11) DEFAULT NULL,
  `generasi_ke` int(11) NOT NULL,
  `peran` text DEFAULT NULL,
  `pasangan_nama` text DEFAULT NULL,
  `boru_marga` varchar(200) DEFAULT NULL,
  `info_perkawinan` text DEFAULT NULL,
  `marga_turunan` varchar(200) DEFAULT NULL,
  `wilayah` varchar(100) DEFAULT NULL,
  `bona_pasogit` varchar(200) DEFAULT NULL,
  `sumber` varchar(200) DEFAULT 'W.M. Hutagalung (1926)',
  `tingkat_kepastian` enum('tinggi','sedang','rendah') DEFAULT 'tinggi',
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orang_tuan_id` (`orang_tuan_id`),
  KEY `ibu_id` (`ibu_id`),
  CONSTRAINT `silsilah_mitolologis_ibfk_1` FOREIGN KEY (`orang_tuan_id`) REFERENCES `silsilah_mitolologis` (`id`) ON DELETE CASCADE,
  CONSTRAINT `silsilah_mitolologis_ibfk_2` FOREIGN KEY (`ibu_id`) REFERENCES `pasangan` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `silsilah_mitolologis`
--

LOCK TABLES `silsilah_mitolologis` WRITE;
/*!40000 ALTER TABLE `silsilah_mitolologis` DISABLE KEYS */;
INSERT INTO `silsilah_mitolologis` VALUES (1,'Ompu Bada','L','mitologis',0,NULL,NULL,NULL,NULL,1,'Leluhur Pakpak/Dairi (BUKAN keturunan Si Raja Batak)',NULL,NULL,'Sudah ada di Tanah Dairi sebelum Si Raja Batak. Ahli kapur barus. Si Onom Kodin = 6 periuk',NULL,'Tanah Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(2,'Tendang','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Tendang','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(3,'Bunurea','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Bunurea/Banuarea','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(4,'Manik (Ompu Bada)','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Manik Kecupak','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(5,'Beringin','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Beringin','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(6,'Gajah','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Gajah','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(7,'Barasa','L','mitologis',0,NULL,NULL,1,57,2,'Putra Ompu Bada - Si Onom Kodin',NULL,NULL,'Tidak terhubung ke Si Raja Batak','Barasa/Berasa','Pakpak/Dairi',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(8,'Si Raja Batak','L','mitologis',0,NULL,NULL,NULL,NULL,1,'Leluhur bangso Batak','Si Boru Nai Mula Uji','Si Boru Nai Mula Uji','Bermukim di Pusuk Buhit, Sianjur Mula-mula',NULL,'Pusuk Buhit',NULL,'BPODT; W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(9,'Guru Tatea Bulan (Tuan Doli)','L','mitologis',0,NULL,NULL,8,11,2,'Putra sulung Si Raja Batak','Si Boru Soping Sopang','Si Boru Soping Sopang','Golongan Tatea Bulan = Pemberi Perempuan (Hula-hula)',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(10,'Raja Isumbaon','L','mitologis',0,NULL,NULL,8,11,2,'Putra kedua Si Raja Batak','Si Boru Anting Sabungan','Si Boru Anting Sabungan','Golongan Isombaon = Laki-laki (Boru)',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(11,'Raja Uti (Raja Biak-biak)','L','mitologis',0,NULL,NULL,9,12,3,'Putra sulung Guru Tatea Bulan','Si Boru Anting Nai Bolon','Tampubolon','Raja Uti wafat muda, keturunannya tidak dikenal. Ada versi yang menyebut keturunan Raja Uti menjadi marga Tampubolon.',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(12,'Tuan Sariburaja','L','mitologis',0,NULL,NULL,9,12,3,'Putra kedua Guru Tatea Bulan','Si Boru Pareme (kembar) & Nai Margiring Laut & harimau betina','Si Boru Pareme (kembar) & Nai Margiring Laut & harimau betina','Kembar dgn Pareme. Kawin incestâ†’diusir. Harimauâ†’Si Raja Babiat',NULL,'Hutan Sabulan',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(13,'Limbong Mulana','L','mitologis',0,NULL,NULL,9,12,3,'Putra ketiga Guru Tatea Bulan','Si Boru Pinta Omas','Si Boru Pinta Omas','Bermarga Limbong','Limbong','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(14,'Sagala Raja','L','mitologis',0,NULL,NULL,9,12,3,'Putra keempat Guru Tatea Bulan','Si Boru Anting Sabungan','Si Boru Anting Sabungan','Bermarga Sagala','Sagala','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(15,'Silau Raja','L','mitologis',0,NULL,NULL,9,12,3,'Putra kelima Guru Tatea Bulan','Si Boru Anting Menalam','Si Boru Anting Menalam','4 putra: Malau, Manik, Ambarita, Gurning',NULL,'Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(16,'Si Boru Anting Malela (Nai Rasaon)','P','mitologis',0,NULL,NULL,9,12,3,'Putri GTB â†’ istri Sorimangaraja','Tuan Sorimangaraja','Tuan Sorimangaraja','Istri 1 â†’ Nai Rasaon',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(17,'Si Boru Biding Laut (Nai Ambaton)','P','mitologis',0,NULL,NULL,9,12,3,'Putri GTB â†’ istri Sorimangaraja','Tuan Sorimangaraja','Tuan Sorimangaraja','Istri 2 â†’ Nai Ambaton',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(18,'Si Boru Sanggul Baomasan (Nai Suanon)','P','mitologis',0,NULL,NULL,9,12,3,'Putri GTB â†’ istri Sorimangaraja','Tuan Sorimangaraja','Tuan Sorimangaraja','Istri 3 â†’ Nai Suanon',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(19,'Si Boru Pareme','P','mitologis',0,NULL,NULL,9,12,3,'Putri GTB (kembar Sariburaja)','Tuan Sariburaja','Tuan Sariburaja','Kawin incest â†’ Si Raja Lontung',NULL,'Hutan Sabulan',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(20,'Tuan Sorimangaraja','L','mitologis',0,NULL,NULL,10,2,3,'Putra sulung Raja Isumbaon','Nai Rasaon, Nai Ambaton, Nai Suanon','Nai Rasaon, Nai Ambaton, Nai Suanon','3 istri â†’ 3 kelompok besar',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(21,'Si Raja Asiasi','L','mitologis',0,NULL,NULL,10,13,3,'Putra kedua Raja Isumbaon','Si Boru Anting Manis','Tampubolon','Putra Raja Isumbaon dari istri kedua. Keturunannya tidak banyak dikenal.',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(22,'Sangkar Somalidang','L','mitologis',0,NULL,NULL,10,13,3,'Putra ketiga Raja Isumbaon','Si Boru Biding','Tampubolon','Putra Raja Isumbaon. Keturunannya tersebar di Silindung.',NULL,'Pusuk Buhit',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(23,'Si Raja Lontung','L','mitologis',0,NULL,NULL,12,1,4,'Putra Sariburaja dari Si Boru Pareme','Si Boru Anak Pardomuan','Si Boru Anak Pardomuan','7 putra + 2 putri = Si Sia Marina','Lontung','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(24,'Si Raja Borbor','L','mitologis',0,NULL,NULL,12,1,4,'Putra Sariburaja dari Nai Margiring Laut','Si Boru Anting Mela','Si Boru Anting Mela','Bermarga Borbor','Borbor','Toba/Angkola/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(25,'Si Raja Babiat','L','mitologis',0,NULL,NULL,12,1,4,'Putra Sariburaja dari harimau betina','Si Boru Anting Mela','Borbor','Putra Sariburaja dari istri kedua. Bermarga Bayoangin/Babiat.','Bayoangin/Babiat','Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(26,'Malau','L','mitologis',0,NULL,NULL,15,17,4,'Putra sulung Silau Raja','Si Boru Anting Nai Bolon','Tampubolon','Putra sulung Silau Raja. Bermarga Malau.','Malau','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(27,'Manik','L','mitologis',0,NULL,NULL,15,17,4,'Putra kedua Silau Raja','Si Boru Anting Mela','Borbor','Putra Silau Raja. Bermarga Manik/Damanik (Simalungun).','Manik/Damanik','Toba/Karo/Simalungun/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(28,'Ambarita','L','mitologis',0,NULL,NULL,15,17,4,'Putra ketiga Silau Raja','Si Boru Anting Malela','Tampubolon','Putra Silau Raja. Bermarga Ambarita (Simalungun).','Ambarita','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(29,'Gurning','L','mitologis',0,NULL,NULL,15,17,4,'Putra keempat Silau Raja','Si Boru Anting Nai Bolon','Tampubolon','Putra Silau Raja. Bermarga Gurning.','Gurning','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(30,'Palu Onggang','L','mitologis',0,NULL,NULL,13,15,4,'Putra sulung Limbong Mulana','Si Boru Anting Mela','Borbor','Putra Limbong Mulana. Bermarga Limbong (Palu Onggang).','Limbong','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(31,'Langgat Limbong','L','mitologis',0,NULL,NULL,13,15,4,'Putra kedua Limbong Mulana','Si Boru Anting Malela','Tampubolon','Putra Limbong Mulana. Bermarga Limbong (Langgat).',NULL,'Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(32,'Tuan Sorbadijulu (Nai Ambaton)','L','mitologis',0,NULL,NULL,20,5,4,'Putra Sorimangaraja dari Nai Ambaton','Si Boru Biding Laut','Tampubolon','Putra sulung Sorimangaraja â†’ Nai Ambaton. Istri: Si Boru Biding Laut (kembar dgn Nai Ambaton).','Nai Ambaton','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(33,'Tuan Sorbadijae (Nai Rasaon)','L','mitologis',0,NULL,NULL,20,4,4,'Putra Sorimangaraja dari Nai Rasaon','Si Boru Sanggul Baomasan','Tampubolon','Putra kedua Sorimangaraja â†’ Nai Rasaon. Istri: Si Boru Sanggul Baomasan.','Nai Rasaon','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(34,'Tuan Sorbadibanua (Nai Suanon)','L','mitologis',0,NULL,NULL,20,6,4,'Putra Sorimangaraja dari Nai Suanon','Putri Sariburaja (istri 1) & Boru Sibasopaet (istri 2)','Putri Sariburaja (istri 1) & Boru Sibasopaet (istri 2)','Istri 1: 5 putra. Istri 2: 3 putra','Nai Suanon','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(35,'Tuan Situmorang','L','mitologis',0,NULL,NULL,23,21,5,'Putra sulung Si Raja Lontung','Si Boru Anting Mela','Borbor','Putra sulung Si Raja Lontung. Bermarga Situmorang. Istri dari marga Borbor.','Situmorang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(36,'Sinaga Raja','L','mitologis',0,NULL,NULL,23,21,5,'Putra kedua Si Raja Lontung','Si Boru Anting Nai Bolon','Tampubolon','Putra kedua Si Raja Lontung. Bermarga Sinaga.','Sinaga','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(37,'Pandiangan','L','mitologis',0,NULL,NULL,23,21,5,'Putra ketiga Si Raja Lontung','Si Boru Anting Malela','Tampubolon','Putra ketiga Si Raja Lontung. Bermarga Pandiangan.','Pandiangan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(38,'Toga Nainggolan','L','mitologis',0,NULL,NULL,23,21,5,'Putra keempat Si Raja Lontung','Si Boru Anting Mela','Borbor','Putra keempat Si Raja Lontung. Bermarga Nainggolan. Istri dari marga Borbor.','Nainggolan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(39,'Simatupang','L','mitologis',0,NULL,NULL,23,21,5,'Putra kelima Si Raja Lontung','Si Boru Anting Nai Bolon','Tampubolon','Putra kelima Si Raja Lontung. Bermarga Simatupang.','Simatupang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(40,'Aritonang','L','mitologis',0,NULL,NULL,23,21,5,'Putra keenam Si Raja Lontung','Si Boru Anting Malela','Tampubolon','Putra keenam Si Raja Lontung. Bermarga Aritonang.','Aritonang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(41,'Siregar','L','mitologis',0,NULL,NULL,23,21,5,'Putra ketujuh Si Raja Lontung','Si Boru Anting Mela','Borbor','Putra ketujuh Si Raja Lontung. Bermarga Siregar. Istri dari marga Borbor.','Siregar','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(42,'Si Boru Anakpandan','P','mitologis',0,NULL,NULL,23,21,5,'Putri Si Raja Lontung','Toga Sihombing','Toga Sihombing','â†’ Sihombing si Opat Ama','Sihombing (via anak)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(43,'Si Boru Panggabean','P','mitologis',0,NULL,NULL,23,21,5,'Putri Si Raja Lontung','Toga Simamora','Toga Simamora','â†’ Simamora','Simamora (via anak)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(44,'Limbong (Tua)','L','mitologis',0,NULL,NULL,31,29,5,'Putra sulung Langgat Limbong','Si Boru Anting Nai Bolon','Tampubolon','Putra Langgat Limbong. Tetap marga Limbong.','Limbong','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(45,'Sihole','L','mitologis',0,NULL,NULL,31,29,5,'Putra kedua Langgat Limbong','Si Boru Anting Malela','Tampubolon','Putra Langgat Limbong. Bermarga Sihole.','Sihole','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(46,'Habeahan','L','mitologis',0,NULL,NULL,31,29,5,'Putra ketiga Langgat Limbong','Si Boru Anting Mela','Borbor','Putra Langgat Limbong. Bermarga Habeahan.','Habeahan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(47,'Simbolon Tua','L','mitologis',0,NULL,NULL,32,30,5,'Putra sulung Nai Ambaton','Si Boru Anting Nai Bolon','Tampubolon','Putra Nai Ambaton. Bermarga Simbolon. Si Onom Hudon: Tinambunan, Tumanggor, Maharaja, Turutan, Nahampun, Pinayungan.','Simbolon','Toba/Pakpak/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(48,'Tamba Tua','L','mitologis',0,NULL,NULL,32,30,5,'Putra kedua Nai Ambaton','Si Boru Anting Malela','Tampubolon','Putra Nai Ambaton. Bermarga Tamba. 9 putra: Siallagan, Tomok, Sidabutar, Sijabat, Gusar, Siadari, Sidabolak, Rumahorbo, Napitu.','Tamba','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(49,'Saragi Tua','L','mitologis',0,NULL,NULL,32,30,5,'Putra ketiga Nai Ambaton','Si Boru Anting Mela','Borbor','Putra Nai Ambaton. Bermarga Saragi/Saragih. 5 putra: Simalango, Saing, Simarmata, Nadeak, Sidabungke. Simalungunâ†’Saragih.','Saragi/Saragih','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(50,'Munte Tua','L','mitologis',0,NULL,NULL,32,30,5,'Putra keempat Nai Ambaton','Si Boru Anting Nai Bolon','Tampubolon','Putra Nai Ambaton. Bermarga Munte. 6 putra: Sitanggang, Manihuruk, Sidauruk, Turnip, Sitio, Sigalingging.','Munte','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(51,'Raja Mardopang','L','mitologis',0,NULL,NULL,33,4,5,'Putra sulung Nai Rasaon','Si Boru Anting Malela','Tampubolon','Putra Nai Rasaon. 3 putra: Sitorus, Sirait, Butarbutar.','Nai Rasaon','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(52,'Raja Mangatur','L','mitologis',0,NULL,NULL,33,4,5,'Putra kedua Nai Rasaon','Si Boru Anting Mela','Borbor','Putra Nai Rasaon. Putra: Toga Manurung.','Nai Rasaon','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(53,'Si Bagot Ni Pohan','L','mitologis',0,NULL,NULL,34,7,5,'Putra sulung Nai Suanon (istri 1)','Si Boru Anting Nai Bolon','Tampubolon','Putra sulung Nai Suanon. Keturunan: Tampubolon, Baringbing, Silaen, Siahaan, Simanjuntak, Hutagaol, Nasution, Panjaitan, Siagian, Silitonga, Sianipar, Pardosi, Simangunsong, Marpaung, Napitupulu, Pardede.','Pohan/Tampubolon','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(54,'Si Paet Tua','L','mitologis',0,NULL,NULL,34,7,5,'Putra kedua Nai Suanon (istri 1)','Si Boru Anting Malela','Tampubolon','Putra kedua Nai Suanon. Keturunan: Hutahaean, Hutajulu, Aruan, Sibarani, Sibuea, Sarumpaet, Pangaribuan, Hutapea.','Naisuanon (Paet Tua)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(55,'Si Lahi Sabungan (Silalahi)','L','mitologis',0,NULL,NULL,34,7,5,'Putra ketiga Nai Suanon (istri 1)','Si Boru Pareme','Tampubolon','Putra ketiga Nai Suanon. Istri: Si Boru Pareme (putri Tuan Sariburaja, kembar dgn Pareme). Kawin incest â†’ Silalahi. Keturunan: Sihaloho, Situngkir, Sipangkar, Sipayung, Sirumasondi, Sidabutar, Sidabariba, Pintubatu, Sigiro, Tambun/Tambunan, Doloksaribu, Sinurat, Naiborhu, dll.','Silalahi','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(56,'Si Raja Oloan','L','mitologis',0,NULL,NULL,34,7,5,'Putra keempat Nai Suanon (istri 1)','Si Boru Anting Mela','Borbor','Putra keempat Nai Suanon. Istri dari marga Borbor. Keturunan: Naibaho, Sihotang, Hasugian, Lingga, Sinambela, Sihite, Simanullang, Bintang, Ujung, dll.','Naisuanon (Oloan)','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(57,'Si Raja Huta Lima','L','mitologis',0,NULL,NULL,34,7,5,'Putra kelima Nai Suanon (istri 1)','Si Boru Anting Nai Bolon','Tampubolon','Putra kelima Nai Suanon. Keturunan: Maha, Sambo, Pardosi, Sembiring Meliala (pindah ke Karo).','Naisuanon (Huta Lima)','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(58,'Si Raja Sumba','L','mitologis',0,NULL,NULL,34,8,5,'Putra keenam Nai Suanon (istri 2)','Si Boru Anakpandan & Si Boru Panggabean (putri Lontung)','Si Boru Anakpandan & Si Boru Panggabean (putri Lontung)','Keturunan: Simamora, Rambe, Purba, Manalu, Debataraja, Girsang, Tambak, Siboro, Sihombing. Sihombing si Opat Ama: Silaban, Lumbantoruan, Nababan, Hutasoit','Naisuanon (Sumba)','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(59,'Si Raja Sobu','L','mitologis',0,NULL,NULL,34,8,5,'Putra ketujuh Nai Suanon (istri 2)','Si Boru Anting Malela','Tampubolon','Putra ketujuh Nai Suanon. Keturunan: Sitompul, Hasibuan, Hutabarat, Panggabean, Hutagalung, Hutatoruan, Simorangkir, Hutapea, Lumbantobing, Mismis.','Naisuanon (Sobu)','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(60,'Toga Naipospos','L','mitologis',0,NULL,NULL,34,8,5,'Putra kedelapan Nai Suanon (istri 2)','Si Boru Anting Mela','Borbor','Putra kedelapan Nai Suanon. Istri dari marga Borbor. Keturunan: Marbun, Lumbanbatu, Banjarnahor, Lumbangaol, Sibagariang, Hutauruk, Simanungkalit, Situmeang.','Naipospos','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(61,'Datu Taladibabana','L','mitologis',0,NULL,NULL,24,22,6,'Cucu beberapa generasi dari Si Raja Borbor',NULL,NULL,'6 putra = asal marga Borbor cabang. Sumber: W.M. Hutagalung (1926)','Borbor','Toba/Angkola/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','sedang',NULL),(62,'Datu Dalu (Sahangmaima)','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Borbor (induk)','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(63,'Sipahutar','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Sipahutar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(64,'Harahap','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Harahap','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(65,'Tanjung','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Tanjung','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(66,'Datu Pulungan','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Pulungan','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(67,'Simargolang','L','mitologis',0,NULL,NULL,61,58,7,'Putra Datu Taladibabana',NULL,NULL,NULL,'Imargolang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(68,'Pasaribu','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Pasaribu','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(69,'Batubara','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Batubara','Toba/Angkola/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(70,'Habeahan (Borbor)','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Habeahan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(71,'Bondar','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Bondar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(72,'Gorat','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Gorat','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(73,'Tinendang','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Tinendang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(74,'Tangkar','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Tangkar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(75,'Matondang','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Matondang','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(76,'Saruksuk','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Saruksuk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(77,'Tarihoran','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Tarihoran','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(78,'Parapat','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Parapat','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(79,'Rangkuti','L','mitologis',0,NULL,NULL,62,60,8,'Keturunan Datu Dalu',NULL,NULL,NULL,'Rangkuti','Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(80,'Lubis','L','mitologis',0,NULL,NULL,66,61,8,'Keturunan Datu Pulungan',NULL,NULL,'Marga besar Mandailing','Lubis','Mandailing/Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(81,'Hutasuhut','L','mitologis',0,NULL,NULL,66,61,8,'Keturunan Datu Pulungan',NULL,NULL,NULL,'Hutasuhut','Mandailing/Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(82,'Borsak Jungjungan (Silaban)','L','mitologis',0,NULL,NULL,58,10,6,'Sihombing si Opat Ama (putra Si Raja Sumba dari Si Boru Anakpandan)',NULL,NULL,NULL,'Silaban','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(83,'Borsak Sirumonggur (Lumbantoruan)','L','mitologis',0,NULL,NULL,58,10,6,'Sihombing si Opat Ama (putra Si Raja Sumba dari Si Boru Anakpandan)',NULL,NULL,NULL,'Lumbantoruan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(84,'Borsak Mangatasi (Nababan)','L','mitologis',0,NULL,NULL,58,10,6,'Sihombing si Opat Ama (putra Si Raja Sumba dari Si Boru Anakpandan)',NULL,NULL,NULL,'Nababan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(85,'Borsak Bimbinan (Hutasoit)','L','mitologis',0,NULL,NULL,58,10,6,'Sihombing si Opat Ama (putra Si Raja Sumba dari Si Boru Anakpandan)',NULL,NULL,NULL,'Hutasoit','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(86,'Siringoringo','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Siringoringo','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(87,'Lumban Nahor','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Lumban Nahor','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(88,'Lumban Pande','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Lumban Pande','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(89,'Suhutnihuta','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Suhutnihuta','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(90,'Sitohang','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Sitohang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(91,'Rumapea','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Rumapea','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(92,'Padang','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Padang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(93,'Solin','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Solin','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(94,'Sihotang Toruan','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Sihotang Toruan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(95,'Sihorang Tonga-tonga','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Sihorang Tonga-tonga','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(96,'Sihotang Uruk','L','mitologis',0,NULL,NULL,35,32,6,'Submarga Situmorang',NULL,NULL,NULL,'Sihotang Uruk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(97,'Sinaga Sidagurgur','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidagurgur','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(98,'Sinaga Sidahambang','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidahambang','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(99,'Sinaga Sidahapitu','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidahapitu','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(100,'Sinaga Sidahoro','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidahoro','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(101,'Sinaga Sidalogan','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidalogan','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(102,'Sinaga Sidasuhut','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Sidasuhut','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(103,'Sinaga Simaibang','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Simaibang','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(104,'Sinaga Simandalahi','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Simandalahi','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(105,'Sinaga Simanjorang','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Simanjorang','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(106,'Sinaga Porti','L','mitologis',0,NULL,NULL,36,33,6,'Submarga Sinaga',NULL,NULL,NULL,'Sinaga Porti','Toba',NULL,'Wikipedia - Daftar marga Batak','sedang',NULL),(107,'Samosir','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Samosir','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(108,'Pakpahan','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Pakpahan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(109,'Gultom','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Gultom','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(110,'Sidari','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Sidari','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(111,'Sitinjak','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Sitinjak','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(112,'Harianja','L','mitologis',0,NULL,NULL,37,34,6,'Submarga Pandiangan',NULL,NULL,NULL,'Harianja','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(113,'Parhusip','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Parhusip','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(114,'Lumban Tungkup','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Lumban Tungkup','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(115,'Lumban Siantar','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Lumban Siantar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(116,'Hutabalian','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Hutabalian','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(117,'Lumban Raja','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Lumban Raja','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(118,'Pusuk','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Pusuk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(119,'Buaton','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Buaton','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(120,'Mahulae (Batuara)','L','mitologis',0,NULL,NULL,38,35,6,'Submarga Nainggolan',NULL,NULL,NULL,'Mahulae (Batuara)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(121,'Togatorop','L','mitologis',0,NULL,NULL,39,36,6,'Submarga Simatupang',NULL,NULL,NULL,'Togatorop','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(122,'Sianturi','L','mitologis',0,NULL,NULL,39,36,6,'Submarga Simatupang',NULL,NULL,NULL,'Sianturi','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(123,'Siburian','L','mitologis',0,NULL,NULL,39,36,6,'Submarga Simatupang',NULL,NULL,NULL,'Siburian','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(124,'Ompusunggu','L','mitologis',0,NULL,NULL,40,37,6,'Submarga Aritonang',NULL,NULL,NULL,'Ompusunggu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(125,'Rajagukguk','L','mitologis',0,NULL,NULL,40,37,6,'Submarga Aritonang',NULL,NULL,NULL,'Rajagukguk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(126,'Simaremare','L','mitologis',0,NULL,NULL,40,37,6,'Submarga Aritonang',NULL,NULL,NULL,'Simaremare','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(127,'Silo (Dongoran)','L','mitologis',0,NULL,NULL,41,38,6,'Submarga Siregar',NULL,NULL,NULL,'Silo (Dongoran)','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(128,'Silali','L','mitologis',0,NULL,NULL,41,38,6,'Submarga Siregar',NULL,NULL,NULL,'Silali','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(129,'Siagian','L','mitologis',0,NULL,NULL,41,38,6,'Submarga Siregar',NULL,NULL,NULL,'Siagian','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(130,'Ritonga','L','mitologis',0,NULL,NULL,41,38,6,'Submarga Siregar',NULL,NULL,NULL,'Ritonga','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(131,'Sormin','L','mitologis',0,NULL,NULL,41,38,6,'Submarga Siregar',NULL,NULL,NULL,'Sormin','Toba/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(132,'Tinambunan','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Tinambunan','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(133,'Tumanggor','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Tumanggor','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(134,'Maharaja','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Maharaja','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(135,'Turutan','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Turutan','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(136,'Nahampun','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Nahampun','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(137,'Pinayungan','L','mitologis',0,NULL,NULL,47,44,6,'Si Onom Hudon - Submarga Simbolon',NULL,NULL,NULL,'Pinayungan','Toba/Pakpak',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(138,'Siallagan','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Siallagan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(139,'Tomok','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Tomok','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(140,'Sidabutar','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Sidabutar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(141,'Sijabat','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Sijabat','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(142,'Gusar','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Gusar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(143,'Siadari','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Siadari','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(144,'Sidabolak','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Sidabolak','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(145,'Rumahorbo','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Rumahorbo','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(146,'Napitu','L','mitologis',0,NULL,NULL,48,45,6,'Submarga Tamba',NULL,NULL,NULL,'Napitu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(147,'Simalango','L','mitologis',0,NULL,NULL,49,46,6,'Submarga Saragi',NULL,NULL,NULL,'Simalango','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(148,'Saing','L','mitologis',0,NULL,NULL,49,46,6,'Submarga Saragi',NULL,NULL,NULL,'Saing','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(149,'Simarmata','L','mitologis',0,NULL,NULL,49,46,6,'Submarga Saragi',NULL,NULL,NULL,'Simarmata','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(150,'Nadeak','L','mitologis',0,NULL,NULL,49,46,6,'Submarga Saragi',NULL,NULL,NULL,'Nadeak','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(151,'Sidabungke','L','mitologis',0,NULL,NULL,49,46,6,'Submarga Saragi',NULL,NULL,NULL,'Sidabungke','Toba/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(152,'Sitanggang','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Sitanggang','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(153,'Manihuruk','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Manihuruk','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(154,'Sidauruk','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Sidauruk','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(155,'Turnip','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Turnip','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(156,'Sitio','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Sitio','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(157,'Sigalingging','L','mitologis',0,NULL,NULL,50,47,6,'Submarga Munte',NULL,NULL,NULL,'Sigalingging','Toba/Pakpak/Simalungun',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(158,'Sitorus','L','mitologis',0,NULL,NULL,51,48,6,'Submarga Raja Mardopang',NULL,NULL,NULL,'Sitorus','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(159,'Sirait','L','mitologis',0,NULL,NULL,51,48,6,'Submarga Raja Mardopang',NULL,NULL,NULL,'Sirait','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(160,'Butarbutar','L','mitologis',0,NULL,NULL,51,48,6,'Submarga Raja Mardopang',NULL,NULL,NULL,'Butarbutar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(161,'Toga Manurung','L','mitologis',0,NULL,NULL,52,49,6,'Putra Raja Mangatur',NULL,NULL,NULL,'Manurung','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(162,'Tampubolon','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Tampubolon','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(163,'Baringbing','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Baringbing','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(164,'Silaen','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Silaen','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(165,'Siahaan','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Siahaan','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(166,'Simanjuntak','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Simanjuntak','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(167,'Hutagaol','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Hutagaol','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(168,'Nasution','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Nasution','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(169,'Panjaitan','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Panjaitan','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(170,'Siagian (Naisuanon)','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Siagian (Naisuanon)','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(171,'Silitonga','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Silitonga','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(172,'Sianipar','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Sianipar','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(173,'Pardosi','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Pardosi','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(174,'Simangunsong','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Simangunsong','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(175,'Marpaung','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Marpaung','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(176,'Napitupulu','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Napitupulu','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(177,'Pardede','L','mitologis',0,NULL,NULL,53,50,6,'Submarga Si Bagot Ni Pohan',NULL,NULL,NULL,'Pardede','Toba/Mandailing',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(178,'Hutahaean','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Hutahaean','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(179,'Hutajulu','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Hutajulu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(180,'Aruan','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Aruan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(181,'Sibarani','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Sibarani','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(182,'Sibuea','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Sibuea','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(183,'Sarumpaet','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Sarumpaet','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(184,'Pangaribuan','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Pangaribuan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(185,'Hutapea (Paet Tua)','L','mitologis',0,NULL,NULL,54,51,6,'Submarga Si Paet Tua',NULL,NULL,NULL,'Hutapea (Paet Tua)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(186,'Sihaloho','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sihaloho','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(187,'Situngkir','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Situngkir','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(188,'Sipangkar','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sipangkar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(189,'Sipayung','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sipayung','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(190,'Sirumasondi','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sirumasondi','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(191,'Sidabutar (Lahi)','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sidabutar (Lahi)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(192,'Sidabariba','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sidabariba','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(193,'Pintubatu','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Pintubatu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(194,'Sigiro','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sigiro','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(195,'Tambun (Tambunan)','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Tambun (Tambunan)','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(196,'Doloksaribu','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Doloksaribu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(197,'Sinurat','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sinurat','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(198,'Naiborhu','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Naiborhu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(199,'Nadapdap','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Nadapdap','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(200,'Pagaraji','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Pagaraji','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(201,'Sunge','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sunge','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(202,'Sidebang','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sidebang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(203,'Sinabariba','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Sinabariba','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(204,'Boliala','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Boliala','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(205,'Ujungsaribu','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Ujungsaribu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(206,'Depari','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Depari','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(207,'Rumasingap','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Rumasingap','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(208,'Rumasondi','L','mitologis',0,NULL,NULL,55,52,6,'Submarga Si Lahi Sabungan',NULL,NULL,NULL,'Rumasondi','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(209,'Naibaho','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Naibaho','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(210,'Sihotang','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sihotang','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(211,'Hasugian','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Hasugian','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(212,'Lingga','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Lingga','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(213,'Sinambela','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sinambela','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(214,'Sihite','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sihite','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(215,'Simanullang','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Simanullang','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(216,'Bangkara','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Bangkara','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(217,'Bintang','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Bintang','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(218,'Ujung','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Ujung','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(219,'Sinamo','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sinamo','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(220,'Mataniari','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Mataniari','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(221,'Sileang','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sileang','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(222,'Sipardabuan','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Sipardabuan','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(223,'Torbandolok','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Torbandolok','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(224,'Simarsoit','L','mitologis',0,NULL,NULL,56,53,6,'Submarga Si Raja Oloan',NULL,NULL,NULL,'Simarsoit','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(225,'Maha','L','mitologis',0,NULL,NULL,57,54,6,'Submarga Si Raja Huta Lima',NULL,NULL,NULL,'Maha','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(226,'Sambo','L','mitologis',0,NULL,NULL,57,54,6,'Submarga Si Raja Huta Lima',NULL,NULL,NULL,'Sambo','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(227,'Pardosi (Huta Lima)','L','mitologis',0,NULL,NULL,57,54,6,'Submarga Si Raja Huta Lima',NULL,NULL,NULL,'Pardosi (Huta Lima)','Toba/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(228,'Simamora','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Simamora','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(229,'Rambe','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Rambe','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(230,'Purba (Sumba)','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Purba (Sumba)','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(231,'Manalu','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Manalu','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(232,'Debataraja','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Debataraja','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(233,'Girsang','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Girsang','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(234,'Tambak','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Tambak','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(235,'Siboro','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Siboro','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(236,'Sitindaon','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Sitindaon','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(237,'Binjori','L','mitologis',0,NULL,NULL,58,9,6,'Submarga Si Raja Sumba',NULL,NULL,NULL,'Binjori','Toba/Simalungun/Karo',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(238,'Rumabutar','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Rumabutar','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(239,'Rumagorga','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Rumagorga','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(240,'Rumahole','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Rumahole','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(241,'Rumaijuk','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Rumaijuk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(242,'Sigukguhi','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Sigukguhi','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(243,'Sorimunggu','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Sorimunggu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(244,'Boangmanalu','L','mitologis',0,NULL,NULL,231,59,7,'Submarga Manalu',NULL,NULL,NULL,'Boangmanalu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(245,'Sitompul','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Sitompul','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(246,'Hasibuan','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Hasibuan','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(247,'Hutabarat','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Hutabarat','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(248,'Panggabean','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Panggabean','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(249,'Hutagalung','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Hutagalung','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(250,'Hutatoruan','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Hutatoruan','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(251,'Simorangkir','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Simorangkir','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(252,'Hutapea (Sobu)','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Hutapea (Sobu)','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(253,'Lumbantobing','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Lumbantobing','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(254,'Mismis','L','mitologis',0,NULL,NULL,59,55,6,'Submarga Si Raja Sobu',NULL,NULL,NULL,'Mismis','Toba/Mandailing/Angkola',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(255,'Marbun','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Marbun','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(256,'Lumbanbatu','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Lumbanbatu','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(257,'Banjarnahor','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Banjarnahor','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(258,'Lumbangaol','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Lumbangaol','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(259,'Sibagariang','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Sibagariang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(260,'Hutauruk','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Hutauruk','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(261,'Simanungkalit','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Simanungkalit','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(262,'Situmeang','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Situmeang','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(263,'Mungkur','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Mungkur','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(264,'Saraan','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Saraan','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL),(265,'Mukur','L','mitologis',0,NULL,NULL,60,56,6,'Submarga Toga Naipospos',NULL,NULL,NULL,'Mukur','Toba',NULL,'W.M. Hutagalung (1926); budaya-indonesia.org','tinggi',NULL);
/*!40000 ALTER TABLE `silsilah_mitolologis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stories`
--

DROP TABLE IF EXISTS `stories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-21  3:58:08
