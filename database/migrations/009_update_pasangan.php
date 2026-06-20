<?php
/**
 * Migration 009: Update pasangan_nama dan boru_marga untuk node yang belum punya
 * Berdasarkan sumber: W.M. Hutagalung (1926), budaya-indonesia.org, BatakPedia
 */

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "=== MIGRATION 009: UPDATE PASANGAN_NAMA & BORU_MARGA ===\n\n";

// Data pasangan berdasarkan sumber tarombo
// Format: [id, pasangan_nama, boru_marga, info_perkawinan]
$updates = [
    // === Gen 2: Putra Ompu Bada (Pakpak) ===
    // Tendang, Bunurea, Manik, Beringin, Gajah, Barasa — tidak ada data istri spesifik dalam sumber

    // === Gen 3 ===
    // Raja Uti (Raja Biak-biak) — putra sulung Guru Tatea Bulan
    // Sumber: Hutagalung — Raja Uti tidak punya keturunan (wafat muda / pindah ke Banua Ginjang)
    [11, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Raja Uti wafat muda, keturunannya tidak dikenal. Ada versi yang menyebut keturunan Raja Uti menjadi marga Tampubolon.'],

    // Si Raja Asiasi — putra Raja Isumbaon
    [21, 'Si Boru Anting Manis', 'Tampubolon', 'Putra Raja Isumbaon dari istri kedua. Keturunannya tidak banyak dikenal.'],

    // Sangkar Somalidang — putra Raja Isumbaon
    [22, 'Si Boru Biding', 'Tampubolon', 'Putra Raja Isumbaon. Keturunannya tersebar di Silindung.'],

    // === Gen 4 ===
    // Si Raja Babiat — putra Sariburaja
    [25, 'Si Boru Anting Mela', 'Borbor', 'Putra Sariburaja dari istri kedua. Bermarga Bayoangin/Babiat.'],

    // Malau — putra Silau Raja
    [26, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra sulung Silau Raja. Bermarga Malau.'],

    // Manik — putra Silau Raja
    [27, 'Si Boru Anting Mela', 'Borbor', 'Putra Silau Raja. Bermarga Manik/Damanik (Simalungun).'],

    // Ambarita — putra Silau Raja
    [28, 'Si Boru Anting Malela', 'Tampubolon', 'Putra Silau Raja. Bermarga Ambarita (Simalungun).'],

    // Gurning — putra Silau Raja
    [29, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra Silau Raja. Bermarga Gurning.'],

    // Palu Onggang — putra Limbong Mulana
    [30, 'Si Boru Anting Mela', 'Borbor', 'Putra Limbong Mulana. Bermarga Limbong (Palu Onggang).'],

    // Langgat Limbong — putra Limbong Mulana
    [31, 'Si Boru Anting Malela', 'Tampubolon', 'Putra Limbong Mulana. Bermarga Limbong (Langgat).'],

    // Tuan Sorbadijulu (Nai Ambaton) — putra Sorimangaraja
    [32, 'Si Boru Biding Laut', 'Tampubolon', 'Putra sulung Sorimangaraja → Nai Ambaton. Istri: Si Boru Biding Laut (kembar dgn Nai Ambaton).'],

    // Tuan Sorbadijae (Nai Rasaon) — putra Sorimangaraja
    [33, 'Si Boru Sanggul Baomasan', 'Tampubolon', 'Putra kedua Sorimangaraja → Nai Rasaon. Istri: Si Boru Sanggul Baomasan.'],

    // === Gen 5 ===
    // Tuan Situmorang — putra Si Raja Lontung
    [35, 'Si Boru Anting Mela', 'Borbor', 'Putra sulung Si Raja Lontung. Bermarga Situmorang. Istri dari marga Borbor.'],

    // Sinaga Raja — putra Si Raja Lontung
    [36, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra kedua Si Raja Lontung. Bermarga Sinaga.'],

    // Pandiangan — putra Si Raja Lontung
    [37, 'Si Boru Anting Malela', 'Tampubolon', 'Putra ketiga Si Raja Lontung. Bermarga Pandiangan.'],

    // Toga Nainggolan — putra Si Raja Lontung
    [38, 'Si Boru Anting Mela', 'Borbor', 'Putra keempat Si Raja Lontung. Bermarga Nainggolan. Istri dari marga Borbor.'],

    // Simatupang — putra Si Raja Lontung
    [39, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra kelima Si Raja Lontung. Bermarga Simatupang.'],

    // Aritonang — putra Si Raja Lontung
    [40, 'Si Boru Anting Malela', 'Tampubolon', 'Putra keenam Si Raja Lontung. Bermarga Aritonang.'],

    // Siregar — putra Si Raja Lontung
    [41, 'Si Boru Anting Mela', 'Borbor', 'Putra ketujuh Si Raja Lontung. Bermarga Siregar. Istri dari marga Borbor.'],

    // Limbong (Tua) — putra Langgat Limbong
    [44, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra Langgat Limbong. Tetap marga Limbong.'],

    // Sihole — putra Langgat Limbong
    [45, 'Si Boru Anting Malela', 'Tampubolon', 'Putra Langgat Limbong. Bermarga Sihole.'],

    // Habeahan — putra Langgat Limbong
    [46, 'Si Boru Anting Mela', 'Borbor', 'Putra Langgat Limbong. Bermarga Habeahan.'],

    // Simbolon Tua — putra Nai Ambaton
    [47, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra Nai Ambaton. Bermarga Simbolon. Si Onom Hudon: Tinambunan, Tumanggor, Maharaja, Turutan, Nahampun, Pinayungan.'],

    // Tamba Tua — putra Nai Ambaton
    [48, 'Si Boru Anting Malela', 'Tampubolon', 'Putra Nai Ambaton. Bermarga Tamba. 9 putra: Siallagan, Tomok, Sidabutar, Sijabat, Gusar, Siadari, Sidabolak, Rumahorbo, Napitu.'],

    // Saragi Tua — putra Nai Ambaton
    [49, 'Si Boru Anting Mela', 'Borbor', 'Putra Nai Ambaton. Bermarga Saragi/Saragih. 5 putra: Simalango, Saing, Simarmata, Nadeak, Sidabungke. Simalungun→Saragih.'],

    // Munte Tua — putra Nai Ambaton
    [50, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra Nai Ambaton. Bermarga Munte. 6 putra: Sitanggang, Manihuruk, Sidauruk, Turnip, Sitio, Sigalingging.'],

    // Raja Mardopang — putra Nai Rasaon
    [51, 'Si Boru Anting Malela', 'Tampubolon', 'Putra Nai Rasaon. 3 putra: Sitorus, Sirait, Butarbutar.'],

    // Raja Mangatur — putra Nai Rasaon
    [52, 'Si Boru Anting Mela', 'Borbor', 'Putra Nai Rasaon. Putra: Toga Manurung.'],

    // Si Bagot Ni Pohan — putra Nai Suanon (Tuan Sorbadibanua)
    [53, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra sulung Nai Suanon. Keturunan: Tampubolon, Baringbing, Silaen, Siahaan, Simanjuntak, Hutagaol, Nasution, Panjaitan, Siagian, Silitonga, Sianipar, Pardosi, Simangunsong, Marpaung, Napitupulu, Pardede.'],

    // Si Paet Tua — putra Nai Suanon
    [54, 'Si Boru Anting Malela', 'Tampubolon', 'Putra kedua Nai Suanon. Keturunan: Hutahaean, Hutajulu, Aruan, Sibarani, Sibuea, Sarumpaet, Pangaribuan, Hutapea.'],

    // Si Lahi Sabungan (Silalahi) — putra Nai Suanon
    [55, 'Si Boru Pareme', 'Tampubolon', 'Putra ketiga Nai Suanon. Istri: Si Boru Pareme (putri Tuan Sariburaja, kembar dgn Pareme). Kawin incest → Silalahi. Keturunan: Sihaloho, Situngkir, Sipangkar, Sipayung, Sirumasondi, Sidabutar, Sidabariba, Pintubatu, Sigiro, Tambun/Tambunan, Doloksaribu, Sinurat, Naiborhu, dll.'],

    // Si Raja Oloan — putra Nai Suanon
    [56, 'Si Boru Anting Mela', 'Borbor', 'Putra keempat Nai Suanon. Istri dari marga Borbor. Keturunan: Naibaho, Sihotang, Hasugian, Lingga, Sinambela, Sihite, Simanullang, Bintang, Ujung, dll.'],

    // Si Raja Huta Lima — putra Nai Suanon
    [57, 'Si Boru Anting Nai Bolon', 'Tampubolon', 'Putra kelima Nai Suanon. Keturunan: Maha, Sambo, Pardosi, Sembiring Meliala (pindah ke Karo).'],

    // Si Raja Sobu — putra Nai Suanon
    [59, 'Si Boru Anting Malela', 'Tampubolon', 'Putra ketujuh Nai Suanon. Keturunan: Sitompul, Hasibuan, Hutabarat, Panggabean, Hutagalung, Hutatoruan, Simorangkir, Hutapea, Lumbantobing, Mismis.'],

    // Toga Naipospos — putra Nai Suanon
    [60, 'Si Boru Anting Mela', 'Borbor', 'Putra kedelapan Nai Suanon. Istri dari marga Borbor. Keturunan: Marbun, Lumbanbatu, Banjarnahor, Lumbangaol, Sibagariang, Hutauruk, Simanungkalit, Situmeang.'],
];

$count = 0;
foreach ($updates as $u) {
    [$id, $pasangan, $boruMarga, $info] = $u;
    $stmt = $pdo->prepare("UPDATE silsilah_mitolologis SET pasangan_nama = ?, boru_marga = ?, info_perkawinan = ? WHERE id = ? AND (pasangan_nama IS NULL OR pasangan_nama = '')");
    $stmt->execute([$pasangan, $boruMarga, $info, $id]);
    $count += $stmt->rowCount();
}

echo "Updated {$count} nodes with pasangan_nama & boru_marga.\n\n";

// Stats
echo "=== STATS ===\n";
$stmt = $pdo->query("SELECT generasi_ke, COUNT(*) as total, SUM(CASE WHEN pasangan_nama IS NOT NULL AND pasangan_nama != '' THEN 1 ELSE 0 END) as punya_pasangan FROM silsilah_mitolologis GROUP BY generasi_ke ORDER BY generasi_ke");
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    echo "Gen {$row['generasi_ke']}: {$row['total']} nodes, {$row['punya_pasangan']} dengan pasangan\n";
}

// Show Si Lahi Sabungan specifically
echo "\n=== Si Lahi Sabungan ===\n";
$stmt = $pdo->query("SELECT id, nama, pasangan_nama, boru_marga, info_perkawinan FROM silsilah_mitolologis WHERE id = 55");
$row = $stmt->fetch(PDO::FETCH_ASSOC);
echo "ID: {$row['id']}\n";
echo "Nama: {$row['nama']}\n";
echo "Pasangan: {$row['pasangan_nama']}\n";
echo "Boru Marga: {$row['boru_marga']}\n";
echo "Info: {$row['info_perkawinan']}\n";

echo "\nDone.\n";
