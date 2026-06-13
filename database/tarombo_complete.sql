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
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
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
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (1,'John Simanjuntak',32,'L',NULL,NULL,'1950-01-15','Medan',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(2,'Mary Simanjuntak',32,'P',NULL,NULL,'1952-03-20','Medan',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(3,'Robert Simanjuntak',32,'L',1,2,'1975-05-10','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(4,'Sarah Simanjuntak',32,'P',1,2,'1978-07-25','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(5,'Michael Simanjuntak',32,'L',1,2,'1980-09-30','Bandung',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(6,'Emily Marbun',33,'P',NULL,NULL,'1977-11-15','Surabaya',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(7,'David Marbun',33,'L',NULL,NULL,'1979-02-28','Surabaya',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(8,'Alice Marbun',33,'P',3,6,'2005-04-10','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(9,'Charlie Marbun',33,'L',3,6,'2008-06-20','Jakarta',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(10,'Emma Simanjuntak',32,'P',1,2,'2006-08-15','Bandung',NULL,'active',NULL,NULL,NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49');
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

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@tarombo.digital','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','Administrator','admin',NULL,'active',NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(2,'john@tarombo.digital','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','John Simanjuntak','verified',1,'active',NULL,'2026-06-13 17:28:49','2026-06-13 17:28:49'),(3,'testnew@tarombo.digital','$2y$10$UUMwj.z6G/kRW0eRjGYpIep79tkSsvBgjHuog.4C4urvlaz5l5bVy','Test User','user',NULL,'active',NULL,'2026-06-13 14:31:20','2026-06-13 14:31:20');
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

-- Dump completed on 2026-06-14  3:59:49
