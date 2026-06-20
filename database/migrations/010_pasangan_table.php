<?php
/**
 * Migration 010: Tabel pasangan (istri) + kolom ibu_id di silsilah_mitolologis
 * 
 * Memisahkan data istri ke tabel terpisah karena:
 * - 1 raja bisa punya multiple istri
 * - Keturunan harus di-track per istri (ibu)
 * - Istri bukan bagian dari pohon patrilineal Batak
 */

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "=== MIGRATION 010: TABEL PASANGAN + IBU_ID ===\n\n";

// 1. Buat tabel pasangan
$pdo->exec("CREATE TABLE IF NOT EXISTS pasangan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    silsilah_node_id INT NOT NULL COMMENT 'ID suami di silsilah_mitolologis',
    nama VARCHAR(200) NOT NULL COMMENT 'Nama istri',
    boru_marga VARCHAR(200) NULL COMMENT 'Marga asal istri (marga ayah)',
    urutan_istri INT DEFAULT 1 COMMENT 'Istri ke berapa (1, 2, 3)',
    info_perkawinan TEXT NULL,
    wilayah VARCHAR(100) NULL,
    sumber VARCHAR(200) DEFAULT 'W.M. Hutagalung (1926)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (silsilah_node_id) REFERENCES silsilah_mitolologis(id) ON DELETE CASCADE,
    INDEX idx_silsilah_node (silsilah_node_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
echo "Tabel 'pasangan' dibuat.\n";

// 2. Tambah kolom ibu_id
try {
    $pdo->exec("ALTER TABLE silsilah_mitolologis ADD COLUMN ibu_id INT NULL AFTER orang_tuan_id");
    echo "Kolom 'ibu_id' ditambahkan ke silsilah_mitolologis.\n";
} catch (Exception $e) {
    echo "Kolom ibu_id sudah ada: " . $e->getMessage() . "\n";
}

try {
    $pdo->exec("ALTER TABLE silsilah_mitolologis ADD FOREIGN KEY (ibu_id) REFERENCES pasangan(id) ON DELETE SET NULL");
} catch (Exception $e) {
    // ignore if already exists
}

// 3. Migrasi data pasangan_nama → tabel pasangan
// Handle multi-istri (ada '&' atau 'istri 1/2/3')

// Mapping manual untuk multi-istri
$multiIstri = [
    // Tuan Sariburaja (id=12) — 3 istri
    12 => [
        ['Si Boru Pareme (kembar)', 'Tampubolon', 1, 'Kembar dgn Pareme. Kawin incest → diusir. Keturunan: Si Raja Lontung, Si Raja Borbor, Si Raja Babiat'],
        ['Nai Margiring Laut', 'Tampubolon', 2, 'Istri kedua. Keturunan: Tuan Sorimangaraja'],
        ['Harimau Betina', null, 3, 'Istri ketua (mitos). Keturunan: Si Raja Babiat (versi lain)'],
    ],
    // Tuan Sorimangaraja (id=20) — 3 istri
    20 => [
        ['Si Boru Anting Malela (Nai Rasaon)', 'Tampubolon', 1, 'Istri 1 → Nai Rasaon. Keturunan: Tuan Sorbadijae (Nai Rasaon), Raja Mardopang, Raja Mangatur'],
        ['Si Boru Biding Laut (Nai Ambaton)', 'Tampubolon', 2, 'Istri 2 → Nai Ambaton. Keturunan: Tuan Sorbadijulu (Nai Ambaton), Simbolon, Tamba, Saragi, Munte'],
        ['Si Boru Sanggul Baomasan (Nai Suanon)', 'Tampubolon', 3, 'Istri 3 → Nai Suanon. Keturunan: Tuan Sorbadibanua (Nai Suanon)'],
    ],
    // Tuan Sorbadibanua / Nai Suanon (id=34) — 2 istri
    34 => [
        ['Putri Sariburaja', 'Tampubolon', 1, 'Istri 1 (putri Sariburaja). 5 putra: Si Bagot Ni Pohan, Si Paet Tua, Si Lahi Sabungan, Si Raja Oloan, Si Raja Huta Lima'],
        ['Boru Sibasopaet', 'Tampubolon', 2, 'Istri 2. 3 putra: Si Raja Sumba, Si Raja Sobu, Toga Naipospos'],
    ],
    // Si Raja Sumba (id=58) — 2 istri
    58 => [
        ['Si Boru Anakpandan', 'Tampubolon', 1, 'Istri 1 (putri Lontung). Keturunan: Simamora, Rambe, Purba, Manalu, Debataraja, Girsang, Tambak, Siboro, Sitindaon, Binjori'],
        ['Si Boru Panggabean', 'Tampubolon', 2, 'Istri 2 (putri Lontung). Keturunan: Sihombing si Opat Ama → Silaban, Lumbantoruan, Nababan, Hutasoit'],
    ],
];

// Single-istri: ambil dari pasangan_nama yang sudah ada
$stmt = $pdo->query("SELECT id, nama, pasangan_nama, boru_marga, info_perkawinan FROM silsilah_mitolologis WHERE pasangan_nama IS NOT NULL AND pasangan_nama != '' AND id NOT IN (12, 16, 17, 18, 20, 34, 58) ORDER BY generasi_ke, id");
$singleNodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Insert multi-istri dulu
echo "\n--- Migrasi multi-istri ---\n";
$istriIdMap = []; // [node_id][urutan] => pasangan.id
foreach ($multiIstri as $nodeId => $istriList) {
    foreach ($istriList as $istri) {
        [$nama, $boruMarga, $urutan, $info] = $istri;
        $stmt = $pdo->prepare("INSERT INTO pasangan (silsilah_node_id, nama, boru_marga, urutan_istri, info_perkawinan) VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$nodeId, $nama, $boruMarga, $urutan, $info]);
        $pasanganId = $pdo->lastInsertId();
        $istriIdMap[$nodeId][$urutan] = $pasanganId;
        echo "  Node $nodeId → Istri $urutan: $nama (pasangan.id=$pasanganId)\n";
    }
}

// Insert single-istri
echo "\n--- Migrasi single-istri ---\n";
foreach ($singleNodes as $node) {
    // Skip yang sudah masuk multi-istri (16, 17, 18 adalah node istri Sorimangaraja, bukan suami)
    // 16, 17, 18 adalah node perempuan (istri Sorimangaraja) — mereka punya pasangan_nama = 'Tuan Sorimangaraja'
    // Tapi mereka adalah node istri, bukan suami. Jadi kita skip node perempuan yang pasangan_nama-nya adalah nama suami
    if ($node['nama'] === $node['pasangan_nama']) continue; // skip self-referencing
    
    $nama = trim($node['pasangan_nama']);
    // Clean up: ambil nama pertama sebelum '&'
    if (strpos($nama, '&') !== false) {
        $nama = trim(explode('&', $nama)[0]);
    }
    
    $stmt = $pdo->prepare("INSERT INTO pasangan (silsilah_node_id, nama, boru_marga, urutan_istri, info_perkawinan) VALUES (?, ?, ?, 1, ?)");
    $stmt->execute([$node['id'], $nama, $node['boru_marga'], $node['info_perkawinan']]);
    $pasanganId = $pdo->lastInsertId();
    $istriIdMap[$node['id']][1] = $pasanganId;
    echo "  Node {$node['id']} → Istri 1: $nama (pasangan.id=$pasanganId)\n";
}

// 4. Update ibu_id untuk anak-anak
echo "\n--- Update ibu_id untuk keturunan ---\n";

// Mapping anak → istri berdasarkan sumber
// Tuan Sariburaja (12): 
//   Istri 1 (Si Boru Pareme) → Si Raja Lontung (23), Si Raja Borbor (24)
//   Istri 2 (Nai Margiring Laut) → Tuan Sorimangaraja (20)
//   Istri 3 (Harimau) → Si Raja Babiat (25)
$anakIbuMap = [
    // Tuan Sariburaja (12)
    [23, 12, 1], // Si Raja Lontung ← Si Boru Pareme
    [24, 12, 1], // Si Raja Borbor ← Si Boru Pareme
    [20, 12, 2], // Tuan Sorimangaraja ← Nai Margiring Laut
    [25, 12, 1], // Si Raja Babiat ← Si Boru Pareme (versi utama)
    
    // Tuan Sorimangaraja (20)
    // Istri 1 (Nai Rasaon) → Tuan Sorbadijae (33), Raja Mardopang (51), Raja Mangatur (52)
    // Istri 2 (Nai Ambaton) → Tuan Sorbadijulu (32)
    // Istri 3 (Nai Suanon) → Tuan Sorbadibanua (34)
    [33, 20, 1], // Tuan Sorbadijae (Nai Rasaon)
    [51, 20, 1], // Raja Mardopang
    [52, 20, 1], // Raja Mangatur
    [32, 20, 2], // Tuan Sorbadijulu (Nai Ambaton)
    [34, 20, 3], // Tuan Sorbadibanua (Nai Suanon)
    
    // Tuan Sorbadibanua / Nai Suanon (34)
    // Istri 1 (Putri Sariburaja) → Si Bagot Ni Pohan (53), Si Paet Tua (54), Si Lahi Sabungan (55), Si Raja Oloan (56), Si Raja Huta Lima (57)
    // Istri 2 (Boru Sibasopaet) → Si Raja Sumba (58), Si Raja Sobu (59), Toga Naipospos (60)
    [53, 34, 1], // Si Bagot Ni Pohan
    [54, 34, 1], // Si Paet Tua
    [55, 34, 1], // Si Lahi Sabungan
    [56, 34, 1], // Si Raja Oloan
    [57, 34, 1], // Si Raja Huta Lima
    [58, 34, 2], // Si Raja Sumba
    [59, 34, 2], // Si Raja Sobu
    [60, 34, 2], // Toga Naipospos
    
    // Si Raja Sumba (58)
    // Istri 1 (Si Boru Anakpandan) → Simamora, Rambe, Purba, Manalu, Debataraja, Girsang, Tambak, Siboro, Sitindaon, Binjori
    // Istri 2 (Si Boru Panggabean) → Sihombing si Opat Ama (Borsak Jungjungan, Borsak Sirumonggur, Borsak Mangatasi, Borsak Bimbinan)
    // Anak Si Raja Sumba: cari orang_tuan_id = 58
];

// Untuk Si Raja Sumba, perlu cari anak-anaknya dan bagi ke 2 istri
$stmt = $pdo->query("SELECT id, nama FROM silsilah_mitolologis WHERE orang_tuan_id = 58 ORDER BY id");
$sumbaChildren = $stmt->fetchAll(PDO::FETCH_ASSOC);
// Sihombing si Opat Ama → istri 2 (Si Boru Panggabean)
// Lainnya → istri 1 (Si Boru Anakpandan)
$sihombingNames = ['Borsak Jungjungan (Silaban)', 'Borsak Sirumonggur (Lumbantoruan)', 'Borsak Mangatasi (Nababan)', 'Borsak Bimbinan (Hutasoit)'];
foreach ($sumbaChildren as $child) {
    if (in_array($child['nama'], $sihombingNames)) {
        $anakIbuMap[] = [$child['id'], 58, 2];
    } else {
        $anakIbuMap[] = [$child['id'], 58, 1];
    }
}

// Untuk node single-istri (Gen 3-5), semua anak → ibu_id = istri ke-1
// Ambil semua node yang punya pasangan di istriIdMap dan punya anak
foreach ($istriIdMap as $nodeId => $istriArr) {
    if (isset($istriArr[1]) && count($istriArr) === 1) {
        // Single istri — semua anak dapat ibu_id ini
        $stmt = $pdo->query("SELECT id FROM silsilah_mitolologis WHERE orang_tuan_id = $nodeId");
        $children = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($children as $childId) {
            // Skip jika sudah ada di anakIbuMap
            $found = false;
            foreach ($anakIbuMap as $a) {
                if ($a[0] == $childId) { $found = true; break; }
            }
            if (!$found) {
                $anakIbuMap[] = [$childId, $nodeId, 1];
            }
        }
    }
}

// Execute updates
$updateCount = 0;
foreach ($anakIbuMap as $map) {
    [$childId, $suamiId, $urutan] = $map;
    if (isset($istriIdMap[$suamiId][$urutan])) {
        $ibuId = $istriIdMap[$suamiId][$urutan];
        $stmt = $pdo->prepare("UPDATE silsilah_mitolologis SET ibu_id = ? WHERE id = ? AND (ibu_id IS NULL)");
        $stmt->execute([$ibuId, $childId]);
        $updateCount += $stmt->rowCount();
    }
}
echo "Updated $updateCount anak dengan ibu_id.\n";

// 5. Tampilkan hasil untuk Si Lahi Sabungan
echo "\n=== HASIL: Si Lahi Sabungan (id=55) ===\n";
$stmt = $pdo->query("
    SELECT s.id, s.nama, s.generasi_ke, s.orang_tuan_id,
           p.nama as nama_ibu, p.boru_marga as ibu_marga, p.urutan_istri
    FROM silsilah_mitolologis s
    LEFT JOIN pasangan p ON s.ibu_id = p.id
    WHERE s.id = 55
");
$row = $stmt->fetch(PDO::FETCH_ASSOC);
echo "ID: {$row['id']}\n";
echo "Nama: {$row['nama']}\n";
echo "Generasi: {$row['generasi_ke']}\n";
echo "Ayah (orang_tuan_id): {$row['orang_tuan_id']}\n";
echo "Ibu: {$row['nama_ibu']} (marga: {$row['ibu_marga']}, istri ke-{$row['urutan_istri']})\n";

// Tampilkan istri Si Lahi Sabungan
echo "\n--- Istri Si Lahi Sabungan ---\n";
$stmt = $pdo->query("SELECT * FROM pasangan WHERE silsilah_node_id = 55");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "  Istri {$row['urutan_istri']}: {$row['nama']} (marga: {$row['boru_marga']}) — id={$row['id']}\n";
}

// Tampilkan anak-anak Si Lahi Sabungan dengan ibu
echo "\n--- Anak Si Lahi Sabungan (dengan ibu) ---\n";
$stmt = $pdo->query("
    SELECT s.id, s.nama, s.marga_turunan, p.nama as nama_ibu
    FROM silsilah_mitolologis s
    LEFT JOIN pasangan p ON s.ibu_id = p.id
    WHERE s.orang_tuan_id = 55
    ORDER BY s.id
");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $ibu = $row['nama_ibu'] ?? '(belum di-set)';
    echo "  [{$row['id']}] {$row['nama']} ({$row['marga_turunan']}) — Ibu: $ibu\n";
}

// Tampilkan Tuan Sorbadibanua (multi-istri)
echo "\n=== Tuan Sorbadibanua (id=34) — Multi-Istri ===\n";
$stmt = $pdo->query("SELECT * FROM pasangan WHERE silsilah_node_id = 34 ORDER BY urutan_istri");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "  Istri {$row['urutan_istri']}: {$row['nama']} (marga: {$row['boru_marga']}) — id={$row['id']}\n";
}
echo "\n  Anak per istri:\n";
$stmt = $pdo->query("
    SELECT s.id, s.nama, s.marga_turunan, p.nama as nama_ibu, p.urutan_istri
    FROM silsilah_mitolologis s
    LEFT JOIN pasangan p ON s.ibu_id = p.id
    WHERE s.orang_tuan_id = 34
    ORDER BY p.urutan_istri, s.id
");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $istriKe = $row['urutan_istri'] ?? '?';
    $ibu = $row['nama_ibu'] ?? '(belum di-set)';
    echo "    [Istri $istriKe] [{$row['id']}] {$row['nama']} — Ibu: $ibu\n";
}

// Stats
echo "\n=== STATS ===\n";
$totalPasangan = $pdo->query("SELECT COUNT(*) FROM pasangan")->fetchColumn();
$totalIbu = $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis WHERE ibu_id IS NOT NULL")->fetchColumn();
$totalAnak = $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis WHERE orang_tuan_id IS NOT NULL")->fetchColumn();
echo "Total pasangan (istri): $totalPasangan\n";
echo "Anak dengan ibu_id: $totalIbu / $totalAnak\n";

echo "\nDone.\n";
