<?php
/**
 * Migration 008: Fitur baru - bona_pasogit, boru_marga, status_hidup, privasi, partuturan, kontribusi
 */

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "=== MIGRATION 008: FITUR BARU ===\n\n";

// ============================================
// 1. ALTER silsilah_mitolologis: tambah kolom baru
// ============================================
echo "1. Alter silsilah_mitolologis...\n";

$cols = $pdo->query("SHOW COLUMNS FROM silsilah_mitolologis")->fetchAll(PDO::FETCH_COLUMN);
$colNames = array_map('strtolower', $cols);

$newCols = [
    'bona_pasogit' => "ADD COLUMN bona_pasogit VARCHAR(200) NULL AFTER wilayah",
    'boru_marga' => "ADD COLUMN boru_marga VARCHAR(200) NULL AFTER pasangan_nama",
    'status_hidup' => "ADD COLUMN status_hidup ENUM('hidup','wafat','mitologis') DEFAULT 'mitologis' AFTER jenis_kelamin",
    'is_private' => "ADD COLUMN is_private TINYINT(1) DEFAULT 0 AFTER status_hidup",
    'tanggal_lahir' => "ADD COLUMN tanggal_lahir VARCHAR(50) NULL AFTER is_private",
    'tanggal_wafat' => "ADD COLUMN tanggal_wafat VARCHAR(50) NULL AFTER tanggal_lahir",
];

foreach ($newCols as $col => $def) {
    if (!in_array($col, $colNames)) {
        $pdo->exec("ALTER TABLE silsilah_mitolologis $def");
        echo "  Added: $col\n";
    } else {
        echo "  Exists: $col\n";
    }
}

// Update status_hidup untuk node mitologis (yang sudah ada = semua mitologis/sejarah)
$pdo->exec("UPDATE silsilah_mitolologis SET status_hidup = 'mitologis' WHERE status_hidup IS NULL OR status_hidup = ''");
echo "  Set status_hidup = 'mitologis' for all existing nodes.\n";

// ============================================
// 2. Tabel partuturan_log (cache hasil perhitungan)
// ============================================
echo "\n2. Create partuturan_log...\n";

$pdo->exec("CREATE TABLE IF NOT EXISTS partuturan_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    node_id_1 INT NOT NULL,
    node_id_2 INT NOT NULL,
    sebutan_batak VARCHAR(100) NULL,
    sebutan_indonesia VARCHAR(100) NULL,
    tingkat_kekerabatan INT NULL,
    jalur TEXT NULL,
    dihitung_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (node_id_1) REFERENCES silsilah_mitolologis(id) ON DELETE CASCADE,
    FOREIGN KEY (node_id_2) REFERENCES silsilah_mitolologis(id) ON DELETE CASCADE,
    UNIQUE KEY uq_partuturan (node_id_1, node_id_2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
echo "  Created partuturan_log.\n";

// ============================================
// 3. Tabel kontribusi (usulan dari komunitas)
// ============================================
echo "\n3. Create kontribusi...\n";

$pdo->exec("CREATE TABLE IF NOT EXISTS kontribusi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    jenis ENUM('tambah_node','edit_node','tambah_marga','koreksi_silsilah','laporan_error') NOT NULL,
    node_id INT NULL,
    marga_id INT NULL,
    data_usulan TEXT NOT NULL,
    catatan TEXT NULL,
    nama_kontributor VARCHAR(200) NULL,
    email_kontributor VARCHAR(200) NULL,
    status ENUM('pending','disetujui','ditolak','selesai') DEFAULT 'pending',
    catatan_admin TEXT NULL,
    dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    diproses_pada TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (node_id) REFERENCES silsilah_mitolologis(id) ON DELETE SET NULL,
    FOREIGN KEY (marga_id) REFERENCES marga(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
echo "  Created kontribusi.\n";

// ============================================
// 4. Update marga: tambah bona_pasogit
// ============================================
echo "\n4. Alter marga: add bona_pasogit...\n";

$margaCols = $pdo->query("SHOW COLUMNS FROM marga")->fetchAll(PDO::FETCH_COLUMN);
$margaColNames = array_map('strtolower', $margaCols);

if (!in_array('bona_pasogit', $margaColNames)) {
    $pdo->exec("ALTER TABLE marga ADD COLUMN bona_pasogit VARCHAR(200) NULL AFTER sub_suku");
    echo "  Added bona_pasogit to marga.\n";
} else {
    echo "  bona_pasogit already exists.\n";
}

// ============================================
// 5. Seed data: bona_pasogit untuk marga utama
// ============================================
echo "\n5. Seed bona_pasogit...\n";

$bonaPasogit = [
    'Tampubolon' => 'Balige',
    'Siahaan' => 'Sianjur Mula-mula',
    'Simanjuntak' => 'Balige',
    'Situmorang' => 'Pangururan',
    'Sinaga' => 'Pangururan',
    'Nainggolan' => 'Nainggolan, Samosir',
    'Simatupang' => 'Pangururan',
    'Aritonang' => 'Pangururan',
    'Siregar' => 'Sipirok',
    'Pandiangan' => 'Pangururan',
    'Simbolon' => 'Sianjur Mula-mula',
    'Tamba' => 'Sianjur Mula-mula',
    'Saragi' => 'Sianjur Mula-mula',
    'Munte' => 'Sianjur Mula-mula',
    'Sihombing' => 'Balige',
    'Simamora' => 'Balige',
    'Naipospos' => 'Sipirok',
    'Naibaho' => 'Balige',
    'Sihotang' => 'Balige',
    'Hasibuan' => 'Sipirok',
    'Hutagalung' => 'Sipirok',
    'Limbong' => 'Pangururan',
    'Sagala' => 'Pangururan',
    'Ambarita' => 'Sihaporas, Simalungun',
    'Lubis' => 'Mandailing',
    'Harahap' => 'Mandailing',
    'Nasution' => 'Mandailing',
    'Batubara' => 'Batubara',
    'Sipahutar' => 'Tapanuli Utara',
    'Tanjung' => 'Tapanuli Utara',
    'Purba' => 'Simalungun',
    'Saragih' => 'Simalungun',
    'Damanik' => 'Simalungun',
    'Ginting' => 'Karo',
    'Karo-karo' => 'Karo',
    'Sembiring' => 'Karo',
    'Tarigan' => 'Karo',
    'Perangin-angin' => 'Karo',
];

$count = 0;
foreach ($bonaPasogit as $marga => $bona) {
    $stmt = $pdo->prepare("UPDATE marga SET bona_pasogit = ? WHERE nama = ? AND bona_pasogit IS NULL");
    $stmt->execute([$bona, $marga]);
    $count += $stmt->rowCount();
}
echo "  Updated {$count} marga with bona_pasogit.\n";

// ============================================
// 6. Seed boru_marga untuk node yang ada pasangan
// ============================================
echo "\n6. Update boru_marga from pasangan_nama...\n";

// Update node yang punya pasangan_nama dengan info marga pasangan
$pdo->exec("UPDATE silsilah_mitolologis SET boru_marga = pasangan_nama WHERE pasangan_nama IS NOT NULL AND pasangan_nama != '' AND boru_marga IS NULL");
echo "  Updated boru_marga from pasangan_nama.\n";

// ============================================
// STATS
// ============================================
echo "\n=== STATS ===\n";
echo "Silsilah columns: " . implode(', ', $pdo->query("SHOW COLUMNS FROM silsilah_mitolologis")->fetchAll(PDO::FETCH_COLUMN)) . "\n";
echo "Marga with bona_pasogit: " . $pdo->query("SELECT COUNT(*) FROM marga WHERE bona_pasogit IS NOT NULL")->fetchColumn() . "\n";
echo "Silsilah with boru_marga: " . $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis WHERE boru_marga IS NOT NULL")->fetchColumn() . "\n";
echo "Tables: silsilah_mitolologis, marga, marga_sub_suku, marga_alias, partuturan_log, kontribusi\n";
echo "\nDone.\n";
