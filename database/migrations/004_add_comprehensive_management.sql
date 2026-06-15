USE tarombo;
SET FOREIGN_KEY_CHECKS = 0;

-- Create tables without foreign keys first
CREATE TABLE IF NOT EXISTS assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    tipe ENUM('tanah', 'rumah', 'kendaraan', 'pusaka_adat', 'emas_perhiasan', 'tanaman', 'ternak', 'lainnya') NOT NULL,
    deskripsi TEXT,
    nilai_estimasi DECIMAL(15,2),
    tanggal_perolehan DATE,
    cara_perolehan ENUM('warisan', 'beli', 'hadiah', 'hadiah_adat', 'lainnya'),
    lokasi VARCHAR(255),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    foto_path VARCHAR(500),
    status ENUM('aktif', 'terjual', 'hilang', 'rusak', 'disewakan') DEFAULT 'aktif',
    pemilik_saat_ini_id INT,
    marga_id INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tipe (tipe),
    INDEX idx_pemilik (pemilik_saat_ini_id),
    INDEX idx_marga (marga_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS inheritance_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    pemilik_lama_id INT,
    pemilik_baru_id INT NOT NULL,
    tanggal_transfer DATE NOT NULL,
    cara_transfer ENUM('warisan_adat', 'hibah', 'jual_beli', 'tukar_menukar', 'lainnya'),
    alasan_transfer TEXT,
    saksi_id INT,
    dokumen_id INT,
    catatan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_asset (asset_id),
    INDEX idx_pemilik_baru (pemilik_baru_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    punguan_id INT NOT NULL,
    tipe ENUM('masuk', 'keluar') NOT NULL,
    kategori ENUM('iuran', 'sumbangan', 'acara_adat', 'sosial', 'operasional', 'pembangunan', 'lainnya') NOT NULL,
    jumlah DECIMAL(15,2) NOT NULL,
    tanggal DATE NOT NULL,
    deskripsi TEXT,
    person_id INT,
    bukti_dokumen_id INT,
    status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    verified_by INT,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_punguan (punguan_id),
    INDEX idx_tipe (tipe),
    INDEX idx_tanggal (tanggal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    punguan_id INT NOT NULL,
    tahun INT NOT NULL,
    kategori VARCHAR(100) NOT NULL,
    anggaran DECIMAL(15,2) NOT NULL,
    terpakai DECIMAL(15,2) DEFAULT 0,
    deskripsi TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_budget (punguan_id, tahun, kategori),
    INDEX idx_tahun (tahun)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS iuran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    punguan_id INT NOT NULL,
    person_id INT,
    jumlah DECIMAL(15,2) NOT NULL DEFAULT 0,
    periode ENUM('bulanan', 'tahunan', 'sekali') DEFAULT 'bulanan',
    status ENUM('lunas', 'belum', 'terlambat') DEFAULT 'belum',
    tanggal_bayar DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_punguan (punguan_id),
    INDEX idx_person (person_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tanah_ulayat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    marga_id INT NOT NULL,
    deskripsi TEXT,
    luas_hektar DECIMAL(10,2),
    lokasi VARCHAR(255),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    batas_wilayah TEXT,
    status ENUM('aktif', 'sengketa', 'dijual', 'disewakan') DEFAULT 'aktif',
    pengelola_id INT,
    foto_path VARCHAR(500),
    peta_path VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_marga (marga_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tanah_boundaries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tanah_ulayat_id INT NOT NULL,
    titik_urutan INT NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    deskripsi_titik VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tanah (tanah_ulayat_id),
    INDEX idx_urutan (titik_urutan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    tipe ENUM('rapat_punguan', 'acara_adat', 'reuni_keluarga', 'pernikahan', 'kematian', 'ulang_tahun', 'lainnya') NOT NULL,
    tanggal_mulai DATETIME NOT NULL,
    tanggal_selesai DATETIME,
    lokasi VARCHAR(255),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    punguan_id INT,
    person_id INT,
    max_peserta INT,
    status ENUM('terjadwal', 'berlangsung', 'selesai', 'dibatalkan') DEFAULT 'terjadwal',
    reminder_sent BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tanggal (tanggal_mulai),
    INDEX idx_tipe (tipe),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS event_attendees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    person_id INT NOT NULL,
    status ENUM('hadir', 'tidak_hadir', 'ragu_ragu', 'menunggu') DEFAULT 'menunggu',
    catatan TEXT,
    tanggal_respon TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_attendee (event_id, person_id),
    INDEX idx_event (event_id),
    INDEX idx_person (person_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS traditions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    kategori ENUM('adat_perkawinan', 'adat_kematian', 'adat_lahir', 'adat_punguan', 'tradisi_lainnya') NOT NULL,
    deskripsi TEXT,
    asal_usul TEXT,
    prosedur TEXT,
    marga_id INT,
    status ENUM('aktif', 'tidak_aktif') DEFAULT 'aktif',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_kategori (kategori),
    INDEX idx_marga (marga_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS stories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    tipe ENUM('sejarah_keluarga', 'cerita_leluhur', 'dongeng_adat', 'pengalaman_pribadi', 'lainnya') NOT NULL,
    konten TEXT NOT NULL,
    person_id INT,
    penulis_id INT,
    marga_id INT,
    tanggal_kejadian DATE,
    lokasi VARCHAR(255),
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tipe (tipe),
    INDEX idx_marga (marga_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    konten TEXT NOT NULL,
    tipe ENUM('umum', 'punguan', 'marga', 'acara', 'lainnya') NOT NULL,
    punguan_id INT,
    marga_id INT,
    pengirim_id INT NOT NULL,
    prioritas ENUM('normal', 'penting', 'urgent') DEFAULT 'normal',
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    tanggal_publish TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tipe (tipe),
    INDEX idx_status (status),
    INDEX idx_tanggal (tanggal_publish)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pengirim_id INT NOT NULL,
    penerima_id INT,
    subjek VARCHAR(255),
    konten TEXT NOT NULL,
    status ENUM('terkirim', 'dibaca', 'dihapus') DEFAULT 'terkirim',
    parent_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_pengirim (pengirim_id),
    INDEX idx_penerima (penerima_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tipe ENUM('acara', 'pesan', 'pengumuman', 'iuran', 'lainnya') NOT NULL,
    judul VARCHAR(255) NOT NULL,
    konten TEXT,
    link VARCHAR(500),
    status ENUM('unread', 'read', 'archived') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_tipe (tipe)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS rumah_keluarga (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    person_id INT NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    kota VARCHAR(100),
    provinsi VARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    tipe ENUM('rumah_utama', 'rumah_kediaman', 'rumah_adat', 'rumah_villa', 'lainnya') DEFAULT 'rumah_kediaman',
    status ENUM('dihuni', 'kosong', 'disewakan', 'dijual') DEFAULT 'dihuni',
    foto_path VARCHAR(500),
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_person (person_id),
    INDEX idx_kota (kota)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample data
INSERT INTO assets (nama, tipe, deskripsi, nilai_estimasi, tanggal_perolehan, cara_perolehan, lokasi, marga_id, status) VALUES
('Tanah Pusaka Simanjuntak', 'tanah', 'Tanah warisan leluhur di Medan', 500000000, '1950-01-01', 'warisan', 'Medan', 32, 'aktif'),
('Rumah Adat Batak', 'rumah', 'Rumah bolon tradisional', 200000000, '1960-06-15', 'warisan', 'Tobasa', 1, 'aktif'),
('Ulos Batak', 'pusaka_adat', 'Koleksi ulos warisan keluarga', 5000000, '1970-01-01', 'warisan', NULL, 32, 'aktif');

INSERT INTO tanah_ulayat (nama, marga_id, deskripsi, luas_hektar, lokasi, latitude, longitude, status) VALUES
('Tanah Ulayat Simanjuntak', 32, 'Tanah ulayat marga Simanjuntak di daerah Toba', 50, 'Toba Samosir', 2.500000, 99.000000, 'aktif'),
('Tanah Ulayat Marbun', 33, 'Tanah ulayat marga Marbun di Humbang Hasundutan', 30, 'Humbang Hasundutan', 2.300000, 99.100000, 'aktif');

INSERT INTO events (judul, deskripsi, tipe, tanggal_mulai, tanggal_selesai, lokasi, punguan_id, status, created_by) VALUES
('Rapat Tahunan Punguan Simanjuntak', 'Rapat evaluasi dan perencanaan tahunan punguan', 'rapat_punguan', '2026-12-15 09:00:00', '2026-12-15 15:00:00', 'Jakarta', 1, 'terjadwal', 1);

INSERT INTO traditions (nama, kategori, deskripsi, asal_usul, marga_id, status) VALUES
('Mangulosi', 'adat_perkawinan', 'Tradisi memberkati pengantin dengan ulos', 'Tradisi Batak kuno', 1, 'aktif'),
('Martumpol', 'adat_perkawinan', 'Lamaran resmi dengan pemberian pasu', 'Tradisi Batak kuno', 1, 'aktif');

INSERT INTO stories (judul, tipe, konten, marga_id, status, penulis_id) VALUES
('Asal Usul Marga Simanjuntak', 'sejarah_keluarga', 'Marga Simanjuntak berasal dari daerah Toba dan merupakan keturunan dari...', 32, 'published', 1);

INSERT INTO announcements (judul, konten, tipe, punguan_id, pengirim_id, prioritas, status, tanggal_publish) VALUES
('Undangan Rapat Tahunan', 'Diharapkan kehadiran seluruh anggota punguan Simanjuntak Jakarta pada tanggal 15 Desember 2026', 'punguan', 1, 1, 'penting', 'published', NOW());

INSERT INTO notifications (user_id, tipe, judul, konten, link, status) VALUES
(2, 'acara', 'Rapat Tahunan', 'Undangan rapat tahunan punguan', '/events/1', 'unread'),
(3, 'pengumuman', 'Undangan Rapat', 'Undangan rapat tahunan punguan', '/announcements/1', 'unread');

INSERT INTO rumah_keluarga (nama, person_id, alamat, kota, provinsi, tipe, status) VALUES
('Rumah Keluarga Simanjuntak', 1, 'Jl. Batak No. 1', 'Medan', 'Sumatera Utara', 'rumah_kediaman', 'dihuni'),
('Rumah Adat', 3, 'Desa Tomok', 'Toba Samosir', 'Sumatera Utara', 'rumah_adat', 'dihuni');

SET FOREIGN_KEY_CHECKS = 1;
