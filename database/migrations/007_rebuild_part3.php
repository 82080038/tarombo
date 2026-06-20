<?php
/**
 * Migration 007 Part 3: marga_sub_suku + marga_alias
 */

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "=== Part 3: SUB-SUKU + ALIAS ===\n\n";

// ============================================
// MARGA_SUB_SUKU: Populate from marga.sub_suku
// ============================================
echo "Populating marga_sub_suku...\n";

$stmt = $pdo->query("SELECT id, nama, sub_suku FROM marga");
$insertSS = $pdo->prepare("INSERT IGNORE INTO marga_sub_suku (marga_id, sub_suku, is_native) VALUES (?, ?, 1)");
$count = 0;
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    if ($row['sub_suku']) {
        $insertSS->execute([$row['id'], $row['sub_suku']]);
        $count++;
    }
}
echo "  Inserted {$count} native sub-suku entries.\n";

// Cross-suku marga (marga yang ada di multiple sub-suku)
// Data from Wikipedia tabel: Y = ada di sub-suku tersebut
$crossSuku = [
    // Format: [marga_nama, [sub_suku_list]]
    ['Ambarita', ['Toba', 'Simalungun']],
    ['Aritonang', ['Toba', 'Simalungun']],
    ['Batubara', ['Toba', 'Angkola', 'Mandailing']],
    ['Berampu', ['Toba', 'Pakpak']],
    ['Beringin', ['Toba', 'Pakpak']],
    ['Bintang', ['Toba', 'Karo']],
    ['Buaton', ['Toba', 'Pakpak']],
    ['Damanik', ['Simalungun', 'Karo']],
    ['Dalimunthe', ['Angkola', 'Mandailing', 'Simalungun']],
    ['Dongoran', ['Toba', 'Angkola']],
    ['Ginting', ['Karo', 'Pakpak']],
    ['Girsang', ['Toba', 'Simalungun']],
    ['Harahap', ['Toba', 'Mandailing', 'Angkola']],
    ['Hasibuan', ['Toba', 'Angkola', 'Mandailing']],
    ['Hutapea', ['Toba', 'Angkola']],
    ['Hutasoit', ['Toba', 'Karo']],
    ['Hutasuhut', ['Toba', 'Mandailing', 'Angkola']],
    ['Lingga', ['Toba', 'Karo']],
    ['Lubis', ['Toba', 'Mandailing']],
    ['Manalu', ['Toba', 'Simalungun', 'Karo']],
    ['Manik', ['Toba', 'Karo', 'Simalungun', 'Pakpak']],
    ['Marpaung', ['Toba', 'Angkola']],
    ['Munte', ['Toba', 'Pakpak', 'Simalungun', 'Angkola', 'Mandailing']],
    ['Nasution', ['Mandailing', 'Angkola', 'Toba']],
    ['Nainggolan', ['Toba', 'Angkola']],
    ['Panggabean', ['Toba', 'Mandailing', 'Angkola']],
    ['Pakpahan', ['Toba', 'Angkola']],
    ['Pardosi', ['Toba', 'Karo']],
    ['Pasaribu', ['Toba', 'Angkola']],
    ['Pohan', ['Toba', 'Pasisi']],
    ['Pulungan', ['Toba', 'Mandailing', 'Angkola']],
    ['Purba', ['Simalungun', 'Toba', 'Karo', 'Pakpak']],
    ['Rambe', ['Toba', 'Mandailing', 'Simalungun']],
    ['Ritonga', ['Toba', 'Angkola']],
    ['Saragih', ['Simalungun', 'Toba', 'Pakpak']],
    ['Sarumpaet', ['Toba', 'Angkola', 'Mandailing']],
    ['Sibarani', ['Toba', 'Angkola']],
    ['Sidauruk', ['Toba', 'Simalungun']],
    ['Sihaloho', ['Toba', 'Pakpak']],
    ['Sihombing', ['Toba', 'Karo']],
    ['Sihotang', ['Toba', 'Pakpak']],
    ['Sigalingging', ['Toba', 'Pakpak']],
    ['Silaban', ['Toba', 'Karo']],
    ['Simalango', ['Toba', 'Simalungun']],
    ['Simarmata', ['Toba', 'Simalungun']],
    ['Simatupang', ['Toba', 'Angkola']],
    ['Simbolon', ['Toba', 'Pakpak', 'Karo']],
    ['Sinambela', ['Toba', 'Karo', 'Pakpak']],
    ['Sipahutar', ['Toba', 'Mandailing', 'Angkola']],
    ['Sitorus', ['Toba', 'Angkola']],
    ['Sitanggang', ['Toba', 'Pakpak']],
    ['Sitio', ['Toba', 'Simalungun']],
    ['Sitompul', ['Toba', 'Karo']],
    ['Sormin', ['Toba', 'Angkola']],
    ['Tambunan', ['Toba', 'Angkola']],
    ['Tampubolon', ['Toba', 'Angkola']],
    ['Tanjung', ['Toba', 'Mandailing', 'Angkola']],
    ['Tarihoran', ['Toba', 'Angkola']],
    ['Tinambunan', ['Toba', 'Pakpak']],
    ['Tumanggor', ['Toba', 'Pakpak', 'Karo']],
    ['Turnip', ['Toba', 'Simalungun']],
    ['Turutan', ['Toba', 'Pakpak']],
    ['Ujung', ['Toba', 'Karo', 'Pakpak']],
];

$insertCross = $pdo->prepare("INSERT IGNORE INTO marga_sub_suku (marga_id, sub_suku, is_native, keterangan) VALUES (?, ?, 0, 'Cross-suku')");
$count = 0;
foreach ($crossSuku as $cs) {
    $stmt = $pdo->prepare("SELECT id FROM marga WHERE nama = ?");
    $stmt->execute([$cs[0]]);
    $mid = $stmt->fetchColumn();
    if (!$mid) continue;
    foreach ($cs[1] as $ss) {
        $insertCross->execute([$mid, $ss]);
        $count++;
    }
}
echo "  Inserted {$count} cross-suku entries.\n";
echo "  Total marga_sub_suku: " . $pdo->query("SELECT COUNT(*) FROM marga_sub_suku")->fetchColumn() . "\n";

// ============================================
// MARGA_ALIAS: Cross-sub-suku name variations
// ============================================
echo "Populating marga_alias...\n";

$aliases = [
    ['Munte', 'Dalimunthe', 'Angkola/Mandailing', 'Munte di Angkola/Mandailing disebut Dalimunthe'],
    ['Munte', 'Munthe', 'Simalungun', 'Munte di Simalungun disebut Munthe'],
    ['Munte', 'Dalimunte', 'Angkola', 'Variasi Dalimunthe'],
    ['Naibaho', 'Bako', 'Pakpak', 'Naibaho di Pakpak disebut Bako'],
    ['Naibaho', 'Baho', 'Pakpak', 'Variasi Bako'],
    ['Sihaloho', 'Kaloko', 'Pakpak', 'Sihaloho di Pakpak disebut Kaloko'],
    ['Sihotang', 'Siketang', 'Pakpak', 'Sihotang di Pakpak disebut Siketang'],
    ['Limbong', 'Lembeng', 'Pakpak', 'Limbong di Pakpak disebut Lembeng'],
    ['Sidabutar', 'Sinabutar', 'Pakpak', 'Sidabutar di Pakpak disebut Sinabutar'],
    ['Berutu', 'Barutu', 'Pakpak', 'Variasi penulisan'],
    ['Bunurea', 'Banuarea', 'Pakpak', 'Variasi penulisan'],
    ['Naipospos', 'Pospos', 'Angkola', 'Naipospos di Angkola disebut Pospos'],
    ['Simbolon', 'Siambaton', 'Pakpak', 'Simbolon di Pakpak'],
    ['Saragih', 'Saragi', 'Toba', 'Saragih di Toba disebut Saragi'],
    ['Damanik', 'Manik', 'Toba', 'Damanik berasal dari Manik (Silau Raja)'],
    ['Sembiring', 'Meliala', 'Karo', 'Sembiring/Meliala dari Si Raja Huta Lima (Toba)'],
    ['Ginting', 'Manik', 'Karo', 'Ginting Manik berasal dari Manik (Silau Raja)'],
    ['Sibabiat', 'Babiat', 'Mandailing', 'Variasi Bayoangin/Babiat'],
    ['Sibabiat', 'Bayoangin', 'Mandailing', 'Marga asli Si Raja Babiat'],
    ['Tambunan', 'Tambun', 'Toba', 'Tambunan = Tambun (Si Lahi Sabungan)'],
    ['Siregar', 'Dongoran', 'Angkola', 'Siregar Dongoran di Angkola'],
    ['Siregar', 'Ritonga', 'Angkola', 'Siregar Ritonga di Angkola'],
    ['Siregar', 'Sormin', 'Angkola', 'Siregar Sormin di Angkola'],
    ['Siregar', 'Siagian', 'Angkola', 'Siregar Siagian di Angkola'],
    ['Hutapea', 'Hutapea', 'Angkola', 'Hutapea juga di Angkola'],
    ['Purba', 'Purba Pakpak', 'Pakpak', 'Purba di Pakpak = Sidapakpak'],
    ['Barasa', 'Berasa', 'Pakpak', 'Variasi penulisan'],
    ['Tendang', 'Tendang', 'Pakpak', 'Submarga Ompu Bada'],
    ['Lumbantoruan', 'Tobing', 'Toba', 'Lumbantoruan = Lumban Tobing'],
    ['Lumbantobing', 'Tobing', 'Toba', 'Variasi penulisan'],
    ['Siringoringo', 'Ringo', 'Toba', 'Variasi penulisan'],
    ['Ompusunggu', 'Ompu Sunggu', 'Toba', 'Variasi penulisan'],
    ['Togatorop', 'Sitogatorop', 'Toba', 'Variasi penulisan'],
    ['Simargolang', 'Imargolang', 'Toba', 'Variasi penulisan'],
    ['Pardosi', 'Dosi', 'Toba', 'Variasi penulisan'],
    ['Sihole', 'Limbong Sihole', 'Toba', 'Sihole = submarga Limbong'],
];

$insertAlias = $pdo->prepare("INSERT INTO marga_alias (marga_id, alias_nama, sub_suku, keterangan, sumber) VALUES (?, ?, ?, ?, ?)");
$count = 0;
foreach ($aliases as $a) {
    $stmt = $pdo->prepare("SELECT id FROM marga WHERE nama = ?");
    $stmt->execute([$a[0]]);
    $mid = $stmt->fetchColumn();
    if (!$mid) continue;
    $insertAlias->execute([$mid, $a[1], $a[2], $a[3], 'Wikipedia; budaya-indonesia.org']);
    $count++;
}
echo "  Inserted {$count} aliases.\n";

// ============================================
// FINAL STATS
// ============================================
echo "\n=== FINAL STATS ===\n";
echo "Total silsilah nodes: " . $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis")->fetchColumn() . "\n";
echo "Total marga: " . $pdo->query("SELECT COUNT(*) FROM marga")->fetchColumn() . "\n";
echo "Marga linked to silsilah: " . $pdo->query("SELECT COUNT(*) FROM marga WHERE silsilah_node_id IS NOT NULL")->fetchColumn() . "\n";
echo "Marga with induk: " . $pdo->query("SELECT COUNT(*) FROM marga WHERE marga_induk_id IS NOT NULL")->fetchColumn() . "\n";
echo "Marga sub-suku entries: " . $pdo->query("SELECT COUNT(*) FROM marga_sub_suku")->fetchColumn() . "\n";
echo "Marga aliases: " . $pdo->query("SELECT COUNT(*) FROM marga_alias")->fetchColumn() . "\n";

echo "\nSub-suku distribution:\n";
$stmt = $pdo->query("SELECT sub_suku, COUNT(*) as total FROM marga_sub_suku GROUP BY sub_suku ORDER BY total DESC");
foreach ($stmt as $r) {
    echo "  {$r['sub_suku']}: {$r['total']}\n";
}

echo "\nKelompok marga:\n";
$stmt = $pdo->query("SELECT kelompok_marga, COUNT(*) as total FROM marga WHERE kelompok_marga IS NOT NULL GROUP BY kelompok_marga ORDER BY total DESC");
foreach ($stmt as $r) {
    echo "  {$r['kelompok_marga']}: {$r['total']}\n";
}

echo "\nAll done!\n";
