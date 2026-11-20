-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.43 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db_pengaduan_fasilitas
CREATE DATABASE IF NOT EXISTS `db_pengaduan_fasilitas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_pengaduan_fasilitas`;

-- Dumping structure for table db_pengaduan_fasilitas.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.categories: ~4 rows (approximately)
INSERT INTO `categories` (`category_id`, `category_name`, `description`) VALUES
	(1, 'Peralatan Komputer', 'Perangkat komputer dan perlengkapan pendukungnya.'),
	(2, 'Perabot Ruangan', 'Perabot yang digunakan di lingkungan Program Studi Informatika.'),
	(3, 'Instalasi Listrik', 'Peralatan dan instalasi kelistrikan.'),
	(4, 'Fasilitas Ruangan', 'Fasilitas pendukung kegiatan belajar dan aktivitas di ruangan.');

-- Dumping structure for table db_pengaduan_fasilitas.complaints
CREATE TABLE IF NOT EXISTS `complaints` (
  `complaint_id` int NOT NULL AUTO_INCREMENT,
  `reporter_id` int NOT NULL,
  `facility_id` int NOT NULL,
  `complaint_title` varchar(150) NOT NULL,
  `complaint_description` text NOT NULL,
  `complaint_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Menunggu Verifikasi','Diproses','Selesai') NOT NULL DEFAULT 'Menunggu Verifikasi',
  `is_published` tinyint(1) NOT NULL DEFAULT '0',
  `verified_by` int DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  PRIMARY KEY (`complaint_id`),
  KEY `reporter_id` (`reporter_id`),
  KEY `facility_id` (`facility_id`),
  KEY `verified_by` (`verified_by`),
  KEY `idx_complaints_status` (`status`),
  KEY `idx_complaints_published` (`is_published`),
  CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `complaints_ibfk_2` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `complaints_ibfk_3` FOREIGN KEY (`verified_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.complaints: ~1 rows (approximately)
INSERT INTO `complaints` (`complaint_id`, `reporter_id`, `facility_id`, `complaint_title`, `complaint_description`, `complaint_date`, `status`, `is_published`, `verified_by`, `verified_at`) VALUES
	(1, 2, 1, 'Komputer tidak dapat dinyalakan', 'Komputer di laboratorium tidak dapat dinyalakan meskipun sudah dihubungkan ke sumber listrik.', '2026-11-20 04:18:59', 'Diproses', 0, 1, '2026-11-20 11:24:15');

-- Dumping structure for table db_pengaduan_fasilitas.complaint_photos
CREATE TABLE IF NOT EXISTS `complaint_photos` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `complaint_id` int NOT NULL,
  `photo_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`photo_id`),
  KEY `complaint_id` (`complaint_id`),
  CONSTRAINT `complaint_photos_ibfk_1` FOREIGN KEY (`complaint_id`) REFERENCES `complaints` (`complaint_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.complaint_photos: ~0 rows (approximately)

-- Dumping structure for table db_pengaduan_fasilitas.complaint_updates
CREATE TABLE IF NOT EXISTS `complaint_updates` (
  `update_id` int NOT NULL AUTO_INCREMENT,
  `complaint_id` int NOT NULL,
  `admin_id` int NOT NULL,
  `status` enum('Menunggu Verifikasi','Diproses','Selesai') NOT NULL,
  `follow_up_note` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`update_id`),
  KEY `admin_id` (`admin_id`),
  KEY `idx_updates_complaint` (`complaint_id`),
  CONSTRAINT `complaint_updates_ibfk_1` FOREIGN KEY (`complaint_id`) REFERENCES `complaints` (`complaint_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `complaint_updates_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.complaint_updates: ~1 rows (approximately)
INSERT INTO `complaint_updates` (`update_id`, `complaint_id`, `admin_id`, `status`, `follow_up_note`, `updated_at`) VALUES
	(1, 1, 1, 'Diproses', 'Pengaduan telah diverifikasi oleh Admin. Kerusakan komputer akan diperiksa lebih lanjut oleh petugas laboratorium.', '2026-11-20 04:23:04');

-- Dumping structure for table db_pengaduan_fasilitas.facilities
CREATE TABLE IF NOT EXISTS `facilities` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `facility_name` varchar(150) NOT NULL,
  `location_detail` varchar(255) NOT NULL,
  `description` text,
  `condition_status` enum('Baik','Rusak Ringan','Rusak Berat') NOT NULL DEFAULT 'Baik',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`facility_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `facilities_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.facilities: ~12 rows (approximately)
INSERT INTO `facilities` (`facility_id`, `category_id`, `facility_name`, `location_detail`, `description`, `condition_status`, `created_at`) VALUES
	(1, 1, 'Komputer', 'Laboratorium Komputer', 'Perangkat komputer untuk praktikum.', 'Baik', '2026-11-20 04:10:04'),
	(2, 1, 'Monitor', 'Laboratorium Komputer', 'Monitor komputer laboratorium.', 'Baik', '2026-11-20 04:10:04'),
	(3, 1, 'Keyboard', 'Laboratorium Komputer', 'Keyboard untuk perangkat komputer.', 'Baik', '2026-11-20 04:10:04'),
	(4, 1, 'Mouse', 'Laboratorium Komputer', 'Mouse untuk perangkat komputer.', 'Baik', '2026-11-20 04:10:04'),
	(5, 2, 'Kursi Mahasiswa', 'Ruang Kelas 1', 'Kursi untuk mahasiswa.', 'Baik', '2026-11-20 04:10:04'),
	(6, 2, 'Meja Dosen', 'Ruang Dosen', 'Meja kerja dosen.', 'Baik', '2026-11-20 04:10:04'),
	(7, 3, 'Stop Kontak', 'Ruang Kelas 1', 'Stop kontak untuk kebutuhan listrik.', 'Baik', '2026-11-20 04:10:04'),
	(8, 3, 'Lampu', 'Ruang Kelas 1', 'Lampu penerangan ruangan.', 'Baik', '2026-11-20 04:10:04'),
	(9, 4, 'AC', 'Ruang Kelas 1', 'Pendingin ruangan.', 'Baik', '2026-11-20 04:10:04'),
	(10, 4, 'Proyektor', 'Ruang Kelas 1', 'Proyektor untuk pembelajaran.', 'Baik', '2026-11-20 04:10:04'),
	(11, 4, 'Papan Tulis', 'Ruang Kelas 1', 'Papan untuk kegiatan pembelajaran.', 'Baik', '2026-11-20 04:10:04'),
	(12, 4, 'AC', 'Laboratorium Komputer', 'Pendingin ruangan laboratorium.', 'Baik', '2026-11-20 04:10:04');

-- Dumping structure for table db_pengaduan_fasilitas.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('Pelapor','Admin') NOT NULL DEFAULT 'Pelapor',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table db_pengaduan_fasilitas.users: ~2 rows (approximately)
INSERT INTO `users` (`user_id`, `full_name`, `username`, `password_hash`, `role`, `created_at`) VALUES
	(1, 'Administrator Prodi', 'admin', '$2y$10$WQvEFXUibEU/ojhXm8OVBOXUbVFoBdgffHG3LRwh7OlxVU/H2NrT.', 'Admin', '2026-11-20 04:13:36'),
	(2, 'Mahasiswa Informatika', 'mahasiswa', '$2y$10$CKsNZrti47w19F2dO1u0tOG0s5VSpDElDBby7gNMeaVwIn.Tzdfva', 'Pelapor', '2026-11-20 04:16:12');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
