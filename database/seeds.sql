-- Seed data for Tarombo Digital
-- Sample data for testing

USE tarombo;

-- Insert Marga (Clans)
INSERT INTO marga (nama, sub_suku, deskripsi) VALUES
('Simanjuntak', 'Toba', 'Salah satu marga besar di Toba'),
('Marbun', 'Toba', 'Marga dengan cabang-cabang yang banyak'),
('Sihotang', 'Toba', 'Marga yang tersebar di berbagai daerah'),
('Nainggolan', 'Toba', 'Marga asal dari Toba'),
('Siregar', 'Toba', 'Marga besar di Toba'),
('Sinaga', 'Toba', 'Marga dengan sejarah panjang'),
('Pardede', 'Toba', 'Marga dari daerah Toba'),
('Gultom', 'Toba', 'Marga di Toba'),
('Lumbantobing', 'Toba', 'Marga Toba'),
('Situmorang', 'Toba', 'Marga Toba'),
('Sinuraya', 'Karo', 'Marga dari Karo'),
('Barus', 'Karo', 'Marga Karo'),
('Ginting', 'Karo', 'Marga Karo'),
('Tarigan', 'Karo', 'Marga Karo'),
('Sitepu', 'Karo', 'Marga Karo'),
('Karo-karo', 'Karo', 'Marga Karo'),
('Purba', 'Simalungun', 'Marga Simalungun'),
('Damanik', 'Simalungun', 'Marga Simalungun'),
('Saragih', 'Simalungun', 'Marga Simalungun'),
('Hutasoit', 'Mandailing', 'Marga Mandailing'),
('Nasution', 'Mandailing', 'Marga Mandailing'),
('Lubis', 'Mandailing', 'Marga Mandailing'),
('Harahap', 'Mandailing', 'Marga Mandailing'),
('Pulungan', 'Angkola', 'Marga Angkola'),
('Pakpahan', 'Pakpak', 'Marga Pakpak'),
('Manik', 'Pakpak', 'Marga Pakpak');

-- Insert sample Persons (family tree)
INSERT INTO persons (nama, marga_id, jenis_kelamin, tanggal_lahir, tempat_lahir) VALUES
('John Simanjuntak', 1, 'L', '1950-01-15', 'Medan'),
('Mary Simanjuntak', 1, 'P', '1952-03-20', 'Medan'),
('Robert Simanjuntak', 1, 'L', '1975-05-10', 'Jakarta'),
('Sarah Simanjuntak', 1, 'P', '1978-07-25', 'Jakarta'),
('Michael Simanjuntak', 1, 'L', '1980-09-30', 'Bandung'),
('Emily Marbun', 2, 'P', '1977-11-15', 'Surabaya'),
('David Marbun', 2, 'L', '1979-02-28', 'Surabaya'),
('Alice Marbun', 2, 'P', '2005-04-10', 'Jakarta'),
('Charlie Marbun', 2, 'L', '2008-06-20', 'Jakarta'),
('Emma Simanjuntak', 1, 'P', '2006-08-15', 'Bandung');

-- Set relationships (father/mother)
UPDATE persons SET father_id = 1, mother_id = 2 WHERE id IN (3, 4, 5);
UPDATE persons SET father_id = 1, mother_id = 2 WHERE id = 10;
UPDATE persons SET father_id = 3, mother_id = 6 WHERE id IN (8, 9);

-- Insert sample Marriage
INSERT INTO marriages (husband_id, wife_id, tanggal_perkawinan, hula_hula_marga_id, boru_marga_id) VALUES
(3, 6, '2000-12-15', 2, 1);

-- Insert sample User
INSERT INTO users (email, password, nama, role, person_id) VALUES
('admin@tarombo.digital', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin', NULL),
('john@tarombo.digital', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Simanjuntak', 'verified', 1);
