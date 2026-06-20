<?php
/**
 * Migration 007 Part 2: Silsilah tree (Si Raja Batak → marga)
 * Tanpa mitologi dewa. Langsung dari Si Raja Batak.
 * Sumber: W.M. Hutagalung (1926), budaya-indonesia.org
 */

$pdo = new PDO('mysql:unix_socket=/opt/lampp/var/mysql/mysql.sock;dbname=tarombo', 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "=== Part 2: SILSILAH TREE (Si Raja Batak → Marga) ===\n\n";

function ins($pdo, $nama, $jk, $ortu, $gen, $peran, $pasangan, $info, $margaT, $wilayah, $sumber, $kepastian) {
    $stmt = $pdo->prepare("INSERT INTO silsilah_mitolologis (nama, jenis_kelamin, orang_tuan_id, generasi_ke, peran, pasangan_nama, info_perkawinan, marga_turunan, wilayah, sumber, tingkat_kepastian) VALUES (?,?,?,?,?,?,?,?,?,?,?)");
    $stmt->execute([$nama, $jk, $ortu, $gen, $peran, $pasangan, $info, $margaT, $wilayah, $sumber, $kepastian]);
    return $pdo->lastInsertId();
}

$src_hutagalung = 'W.M. Hutagalung (1926); budaya-indonesia.org';
$src_wiki = 'Wikipedia - Daftar marga Batak';

// ============================================
// ROOT: Ompu Bada (Pakpak/Dairi - terpisah dari Si Raja Batak)
// ============================================
echo "Root: Ompu Bada...\n";
$ob = ins($pdo, 'Ompu Bada', 'L', null, 1, 'Leluhur Pakpak/Dairi (BUKAN keturunan Si Raja Batak)', NULL, 'Sudah ada di Tanah Dairi sebelum Si Raja Batak. Ahli kapur barus. Si Onom Kodin = 6 periuk', NULL, 'Tanah Dairi', $src_hutagalung, 'sedang');
foreach (['Tendang'=>'Tendang','Bunurea'=>'Bunurea/Banuarea','Manik (Ompu Bada)'=>'Manik Kecupak','Beringin'=>'Beringin','Gajah'=>'Gajah','Barasa'=>'Barasa/Berasa'] as $nama=>$mt) {
    ins($pdo, $nama, 'L', $ob, 2, 'Putra Ompu Bada - Si Onom Kodin', NULL, 'Tidak terhubung ke Si Raja Batak', $mt, 'Pakpak/Dairi', $src_hutagalung, 'sedang');
}

// ============================================
// MAIN TREE: Si Raja Batak (Gen 1)
// ============================================
echo "Main tree: Si Raja Batak...\n";
$g1 = ins($pdo, 'Si Raja Batak', 'L', null, 1, 'Leluhur bangso Batak', 'Si Boru Nai Mula Uji', 'Bermukim di Pusuk Buhit, Sianjur Mula-mula', NULL, 'Pusuk Buhit', 'BPODT; '.$src_hutagalung, 'tinggi');

// Gen 2: 2 putra
$g2a = ins($pdo, 'Guru Tatea Bulan (Tuan Doli)', 'L', $g1, 2, 'Putra sulung Si Raja Batak', 'Si Boru Soping Sopang', 'Golongan Tatea Bulan = Pemberi Perempuan (Hula-hula)', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
$g2b = ins($pdo, 'Raja Isumbaon', 'L', $g1, 2, 'Putra kedua Si Raja Batak', 'Si Boru Anting Sabungan', 'Golongan Isombaon = Laki-laki (Boru)', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');

// ============================================
// Gen 3: Anak Guru Tatea Bulan (5 putra + 4 putri)
// ============================================
echo "Gen 3: Guru Tatea Bulan children...\n";

$g3_uti = ins($pdo, 'Raja Uti (Raja Biak-biak)', 'L', $g2a, 3, 'Putra sulung Guru Tatea Bulan', NULL, 'Sakti. Batu Hobon peninggalannya. Tidak ada marga langsung', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
$g3_sari = ins($pdo, 'Tuan Sariburaja', 'L', $g2a, 3, 'Putra kedua Guru Tatea Bulan', 'Si Boru Pareme (kembar) & Nai Margiring Laut & harimau betina', 'Kembar dgn Pareme. Kawin incest→diusir. Harimau→Si Raja Babiat', NULL, 'Hutan Sabulan', $src_hutagalung, 'tinggi');
$g3_lim = ins($pdo, 'Limbong Mulana', 'L', $g2a, 3, 'Putra ketiga Guru Tatea Bulan', 'Si Boru Pinta Omas', 'Bermarga Limbong', 'Limbong', 'Toba', $src_hutagalung, 'tinggi');
$g3_sag = ins($pdo, 'Sagala Raja', 'L', $g2a, 3, 'Putra keempat Guru Tatea Bulan', 'Si Boru Anting Sabungan', 'Bermarga Sagala', 'Sagala', 'Toba/Pakpak', $src_hutagalung, 'tinggi');
$g3_sil = ins($pdo, 'Silau Raja', 'L', $g2a, 3, 'Putra kelima Guru Tatea Bulan', 'Si Boru Anting Menalam', '4 putra: Malau, Manik, Ambarita, Gurning', NULL, 'Toba', $src_hutagalung, 'tinggi');

// Putri Guru Tatea Bulan → istri Sorimangaraja
ins($pdo, 'Si Boru Anting Malela (Nai Rasaon)', 'P', $g2a, 3, 'Putri GTB → istri Sorimangaraja', 'Tuan Sorimangaraja', 'Istri 1 → Nai Rasaon', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Boru Biding Laut (Nai Ambaton)', 'P', $g2a, 3, 'Putri GTB → istri Sorimangaraja', 'Tuan Sorimangaraja', 'Istri 2 → Nai Ambaton', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Boru Sanggul Baomasan (Nai Suanon)', 'P', $g2a, 3, 'Putri GTB → istri Sorimangaraja', 'Tuan Sorimangaraja', 'Istri 3 → Nai Suanon', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Boru Pareme', 'P', $g2a, 3, 'Putri GTB (kembar Sariburaja)', 'Tuan Sariburaja', 'Kawin incest → Si Raja Lontung', NULL, 'Hutan Sabulan', $src_hutagalung, 'tinggi');

// Gen 3: Anak Raja Isumbaon
$g3_sori = ins($pdo, 'Tuan Sorimangaraja', 'L', $g2b, 3, 'Putra sulung Raja Isumbaon', 'Nai Rasaon, Nai Ambaton, Nai Suanon', '3 istri → 3 kelompok besar', NULL, 'Pusuk Buhit', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Raja Asiasi', 'L', $g2b, 3, 'Putra kedua Raja Isumbaon', NULL, NULL, NULL, 'Pusuk Buhit', $src_hutagalung, 'sedang');
ins($pdo, 'Sangkar Somalidang', 'L', $g2b, 3, 'Putra ketiga Raja Isumbaon', NULL, NULL, NULL, 'Pusuk Buhit', $src_hutagalung, 'sedang');

// ============================================
// Gen 4: Anak Sariburaja
// ============================================
echo "Gen 4: Sariburaja children...\n";
$g4_lon = ins($pdo, 'Si Raja Lontung', 'L', $g3_sari, 4, 'Putra Sariburaja dari Si Boru Pareme', 'Si Boru Anak Pardomuan', '7 putra + 2 putri = Si Sia Marina', 'Lontung', 'Toba', $src_hutagalung, 'tinggi');
$g4_bor = ins($pdo, 'Si Raja Borbor', 'L', $g3_sari, 4, 'Putra Sariburaja dari Nai Margiring Laut', 'Si Boru Anting Mela', 'Bermarga Borbor', 'Borbor', 'Toba/Angkola/Mandailing', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Raja Babiat', 'L', $g3_sari, 4, 'Putra Sariburaja dari harimau betina', NULL, 'Mandailing. Marga Bayoangin', 'Bayoangin/Babiat', 'Mandailing', $src_hutagalung, 'sedang');

// Gen 4: Anak Silau Raja
ins($pdo, 'Malau', 'L', $g3_sil, 4, 'Putra sulung Silau Raja', NULL, NULL, 'Malau', 'Toba', $src_hutagalung, 'tinggi');
$g4_manik = ins($pdo, 'Manik', 'L', $g3_sil, 4, 'Putra kedua Silau Raja', NULL, 'Manik→Karo(Ginting Manik), Simalungun(Damanik), Pakpak(Manik Kecupak)', 'Manik/Damanik', 'Toba/Karo/Simalungun/Pakpak', $src_hutagalung, 'tinggi');
ins($pdo, 'Ambarita', 'L', $g3_sil, 4, 'Putra ketiga Silau Raja', NULL, 'Pindah ke Simalungun', 'Ambarita', 'Toba/Simalungun', $src_hutagalung, 'tinggi');
ins($pdo, 'Gurning', 'L', $g3_sil, 4, 'Putra keempat Silau Raja', NULL, NULL, 'Gurning', 'Toba', $src_hutagalung, 'tinggi');

// Gen 4: Anak Limbong Mulana
ins($pdo, 'Palu Onggang', 'L', $g3_lim, 4, 'Putra sulung Limbong Mulana', NULL, NULL, 'Limbong', 'Toba', $src_hutagalung, 'tinggi');
$g4_lang = ins($pdo, 'Langgat Limbong', 'L', $g3_lim, 4, 'Putra kedua Limbong Mulana', NULL, '3 putra: Limbong, Sihole, Habeahan', NULL, 'Toba', $src_hutagalung, 'tinggi');

// Gen 4: Anak Sorimangaraja
$g4_na = ins($pdo, 'Tuan Sorbadijulu (Nai Ambaton)', 'L', $g3_sori, 4, 'Putra Sorimangaraja dari Nai Ambaton', NULL, '4 putra: Simbolon, Tamba, Saragi, Munte', 'Nai Ambaton', 'Toba', $src_hutagalung, 'tinggi');
$g4_nr = ins($pdo, 'Tuan Sorbadijae (Nai Rasaon)', 'L', $g3_sori, 4, 'Putra Sorimangaraja dari Nai Rasaon', NULL, '2 putra: Raja Mardopang, Raja Mangatur', 'Nai Rasaon', 'Toba', $src_hutagalung, 'tinggi');
$g4_ns = ins($pdo, 'Tuan Sorbadibanua (Nai Suanon)', 'L', $g3_sori, 4, 'Putra Sorimangaraja dari Nai Suanon', 'Putri Sariburaja (istri 1) & Boru Sibasopaet (istri 2)', 'Istri 1: 5 putra. Istri 2: 3 putra', 'Nai Suanon', 'Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 5: LONTUNG (7 putra + 2 putri)
// ============================================
echo "Gen 5: Lontung children...\n";
$g5_stm = ins($pdo, 'Tuan Situmorang', 'L', $g4_lon, 5, 'Putra sulung Si Raja Lontung', NULL, 'Sub: Siringoringo, Lumban Nahor, Lumban Pande, Suhutnihuta, Sitohang, Rumapea, Padang, Solin, Sihotang', 'Situmorang', 'Toba', $src_hutagalung, 'tinggi');
$g5_sin = ins($pdo, 'Sinaga Raja', 'L', $g4_lon, 5, 'Putra kedua Si Raja Lontung', NULL, 'Sub: Sidagurgur, Sidahambang, Simandalahi, dll', 'Sinaga', 'Toba', $src_hutagalung, 'tinggi');
$g5_pan = ins($pdo, 'Pandiangan', 'L', $g4_lon, 5, 'Putra ketiga Si Raja Lontung', NULL, '6 putra: Samosir, Pakpahan, Gultom, Sidari, Sitinjak, Harianja', 'Pandiangan', 'Toba', $src_hutagalung, 'tinggi');
$g5_nai = ins($pdo, 'Toga Nainggolan', 'L', $g4_lon, 5, 'Putra keempat Si Raja Lontung', NULL, '8 putra: Parhusip, Lumban Tungkup, Lumban Siantar, Hutabalian, Lumban Raja, Pusuk, Buaton, Mahulae', 'Nainggolan', 'Toba', $src_hutagalung, 'tinggi');
$g5_sim = ins($pdo, 'Simatupang', 'L', $g4_lon, 5, 'Putra kelima Si Raja Lontung', NULL, '3 putra: Togatorop, Sianturi, Siburian', 'Simatupang', 'Toba', $src_hutagalung, 'tinggi');
$g5_ari = ins($pdo, 'Aritonang', 'L', $g4_lon, 5, 'Putra keenam Si Raja Lontung', NULL, '3 putra: Ompusunggu, Rajagukguk, Simaremare', 'Aritonang', 'Toba', $src_hutagalung, 'tinggi');
$g5_sir = ins($pdo, 'Siregar', 'L', $g4_lon, 5, 'Putra ketujuh Si Raja Lontung', NULL, '5 putra: Silo/Dongoran, Silali, Siagian, Ritonga, Sormin', 'Siregar', 'Toba/Angkola', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Boru Anakpandan', 'P', $g4_lon, 5, 'Putri Si Raja Lontung', 'Toga Sihombing', '→ Sihombing si Opat Ama', 'Sihombing (via anak)', 'Toba', $src_hutagalung, 'tinggi');
ins($pdo, 'Si Boru Panggabean', 'P', $g4_lon, 5, 'Putri Si Raja Lontung', 'Toga Simamora', '→ Simamora', 'Simamora (via anak)', 'Toba', $src_hutagalung, 'tinggi');

// Gen 5: Limbong children
ins($pdo, 'Limbong (Tua)', 'L', $g4_lang, 5, 'Putra sulung Langgat Limbong', NULL, 'Tetap marga Limbong', 'Limbong', 'Toba', $src_hutagalung, 'tinggi');
ins($pdo, 'Sihole', 'L', $g4_lang, 5, 'Putra kedua Langgat Limbong', NULL, NULL, 'Sihole', 'Toba', $src_hutagalung, 'tinggi');
ins($pdo, 'Habeahan', 'L', $g4_lang, 5, 'Putra ketiga Langgat Limbong', NULL, NULL, 'Habeahan', 'Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 5: NAI AMBATON (4 putra)
// ============================================
echo "Gen 5: Nai Ambaton children...\n";
$g5_simb = ins($pdo, 'Simbolon Tua', 'L', $g4_na, 5, 'Putra sulung Nai Ambaton', NULL, 'Si Onom Hudon: Tinambunan, Tumanggor, Maharaja, Turutan, Nahampun, Pinayungan. Juga Berampu, Pasi', 'Simbolon', 'Toba/Pakpak/Karo', $src_hutagalung, 'tinggi');
$g5_tam = ins($pdo, 'Tamba Tua', 'L', $g4_na, 5, 'Putra kedua Nai Ambaton', NULL, '9 putra: Siallagan, Tomok, Sidabutar, Sijabat, Gusar, Siadari, Sidabolak, Rumahorbo, Napitu', 'Tamba', 'Toba', $src_hutagalung, 'tinggi');
$g5_sar = ins($pdo, 'Saragi Tua', 'L', $g4_na, 5, 'Putra ketiga Nai Ambaton', NULL, '5 putra: Simalango, Saing, Simarmata, Nadeak, Sidabungke. Simalungun→Saragih', 'Saragi/Saragih', 'Toba/Simalungun', $src_hutagalung, 'tinggi');
$g5_mun = ins($pdo, 'Munte Tua', 'L', $g4_na, 5, 'Putra keempat Nai Ambaton', NULL, '6 putra: Sitanggang, Manihuruk, Sidauruk, Turnip, Sitio, Sigalingging', 'Munte', 'Toba/Pakpak/Simalungun', $src_hutagalung, 'tinggi');

// ============================================
// Gen 5: NAI RASAON (2 putra)
// ============================================
$g5_mdp = ins($pdo, 'Raja Mardopang', 'L', $g4_nr, 5, 'Putra sulung Nai Rasaon', NULL, '3 putra: Sitorus, Sirait, Butarbutar', 'Nai Rasaon', 'Toba', $src_hutagalung, 'tinggi');
$g5_mgt = ins($pdo, 'Raja Mangatur', 'L', $g4_nr, 5, 'Putra kedua Nai Rasaon', NULL, 'Putra: Toga Manurung', 'Nai Rasaon', 'Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 5: NAI SUANON (8 putra: 5 istri-1 + 3 istri-2)
// ============================================
echo "Gen 5: Nai Suanon children...\n";

// Istri 1 (Putri Sariburaja)
$g5_bag = ins($pdo, 'Si Bagot Ni Pohan', 'L', $g4_ns, 5, 'Putra sulung Nai Suanon (istri 1)', NULL, 'Keturunan: Tampubolon, Baringbing, Silaen, Siahaan, Simanjuntak, Hutagaol, Nasution, Panjaitan, Siagian, Silitonga, Sianipar, Pardosi, Simangunsong, Marpaung, Napitupulu, Pardede', 'Pohan/Tampubolon', 'Toba/Mandailing', $src_hutagalung, 'tinggi');
$g5_paet = ins($pdo, 'Si Paet Tua', 'L', $g4_ns, 5, 'Putra kedua Nai Suanon (istri 1)', NULL, 'Keturunan: Hutahaean, Hutajulu, Aruan, Sibarani, Sibuea, Sarumpaet, Pangaribuan, Hutapea', 'Naisuanon (Paet Tua)', 'Toba', $src_hutagalung, 'tinggi');
$g5_lahi = ins($pdo, 'Si Lahi Sabungan (Silalahi)', 'L', $g4_ns, 5, 'Putra ketiga Nai Suanon (istri 1)', NULL, 'Keturunan: Sihaloho, Situngkir, Sipangkar, Sipayung, Sirumasondi, Sidabutar, Sidabariba, Pintubatu, Sigiro, Tambun/Tambunan, Doloksaribu, Sinurat, Naiborhu, dll', 'Silalahi', 'Toba', $src_hutagalung, 'tinggi');
$g5_oloan = ins($pdo, 'Si Raja Oloan', 'L', $g4_ns, 5, 'Putra keempat Nai Suanon (istri 1)', NULL, 'Keturunan: Naibaho, Sihotang, Hasugian, Lingga, Sinambela, Sihite, Simanullang, Bintang, Ujung, dll', 'Naisuanon (Oloan)', 'Toba/Karo', $src_hutagalung, 'tinggi');
$g5_hutalima = ins($pdo, 'Si Raja Huta Lima', 'L', $g4_ns, 5, 'Putra kelima Nai Suanon (istri 1)', NULL, 'Keturunan: Maha, Sambo, Pardosi, Sembiring Meliala (pindah ke Karo)', 'Naisuanon (Huta Lima)', 'Toba/Karo', $src_hutagalung, 'tinggi');

// Istri 2 (Boru Sibasopaet)
$g5_sumba = ins($pdo, 'Si Raja Sumba', 'L', $g4_ns, 5, 'Putra keenam Nai Suanon (istri 2)', 'Si Boru Anakpandan & Si Boru Panggabean (putri Lontung)', 'Keturunan: Simamora, Rambe, Purba, Manalu, Debataraja, Girsang, Tambak, Siboro, Sihombing. Sihombing si Opat Ama: Silaban, Lumbantoruan, Nababan, Hutasoit', 'Naisuanon (Sumba)', 'Toba/Simalungun/Karo', $src_hutagalung, 'tinggi');
$g5_sobu = ins($pdo, 'Si Raja Sobu', 'L', $g4_ns, 5, 'Putra ketujuh Nai Suanon (istri 2)', NULL, 'Keturunan: Sitompul, Hasibuan, Hutabarat, Panggabean, Hutagalung, Hutatoruan, Simorangkir, Hutapea, Lumbantobing, Mismis', 'Naisuanon (Sobu)', 'Toba/Mandailing/Angkola', $src_hutagalung, 'tinggi');
$g5_naipos = ins($pdo, 'Toga Naipospos', 'L', $g4_ns, 5, 'Putra kedelapan Nai Suanon (istri 2)', NULL, 'Keturunan: Marbun, Lumbanbatu, Banjarnahor, Lumbangaol, Sibagariang, Hutauruk, Simanungkalit, Situmeang', 'Naipospos', 'Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 6: BORBOR → Datu Taladibabana → 6 putra
// ============================================
echo "Gen 6: Borbor lineage...\n";
// Si Raja Borbor → [beberapa generasi] → Datu Taladibabana (gen 6 = ~6 generasi dari Borbor)
$g6_datu = ins($pdo, 'Datu Taladibabana', 'L', $g4_bor, 6, 'Cucu beberapa generasi dari Si Raja Borbor', NULL, '6 putra = asal marga Borbor cabang. Sumber: W.M. Hutagalung (1926)', 'Borbor', 'Toba/Angkola/Mandailing', $src_hutagalung, 'sedang');

// 6 putra Datu Taladibabana (Gen 7)
$borbor_anak = [
    ['Datu Dalu (Sahangmaima)', 'Borbor (induk)', 'Toba/Angkola'],
    ['Sipahutar', 'Sipahutar', 'Toba'],
    ['Harahap', 'Harahap', 'Toba/Mandailing/Angkola'],
    ['Tanjung', 'Tanjung', 'Toba/Mandailing/Angkola'],
    ['Datu Pulungan', 'Pulungan', 'Toba/Mandailing'],
    ['Simargolang', 'Imargolang', 'Toba'],
];
foreach ($borbor_anak as $b) {
    ins($pdo, $b[0], 'L', $g6_datu, 7, 'Putra Datu Taladibabana', NULL, NULL, $b[1], $b[2], $src_hutagalung, 'tinggi');
}

// Gen 8: Anak Datu Dalu (12 marga)
$dalu_anak = [
    ['Pasaribu', 'Pasaribu', 'Toba/Angkola'],
    ['Batubara', 'Batubara', 'Toba/Angkola/Mandailing'],
    ['Habeahan (Borbor)', 'Habeahan', 'Toba'],
    ['Bondar', 'Bondar', 'Toba'],
    ['Gorat', 'Gorat', 'Toba'],
    ['Tinendang', 'Tinendang', 'Toba'],
    ['Tangkar', 'Tangkar', 'Toba'],
    ['Matondang', 'Matondang', 'Toba/Angkola'],
    ['Saruksuk', 'Saruksuk', 'Toba'],
    ['Tarihoran', 'Tarihoran', 'Toba/Angkola'],
    ['Parapat', 'Parapat', 'Toba'],
    ['Rangkuti', 'Rangkuti', 'Mandailing'],
];
// Get Datu Dalu id
$stmt = $pdo->prepare("SELECT id FROM silsilah_mitolologis WHERE nama = 'Datu Dalu (Sahangmaima)'");
$stmt->execute();
$dalu_id = $stmt->fetchColumn();
foreach ($dalu_anak as $d) {
    ins($pdo, $d[0], 'L', $dalu_id, 8, 'Keturunan Datu Dalu', NULL, NULL, $d[1], $d[2], $src_hutagalung, 'tinggi');
}

// Gen 8: Anak Datu Pulungan → Lubis, Hutasuhut
$stmt = $pdo->prepare("SELECT id FROM silsilah_mitolologis WHERE nama = 'Datu Pulungan'");
$stmt->execute();
$pul_id = $stmt->fetchColumn();
ins($pdo, 'Lubis', 'L', $pul_id, 8, 'Keturunan Datu Pulungan', NULL, 'Marga besar Mandailing', 'Lubis', 'Mandailing/Toba', $src_hutagalung, 'tinggi');
ins($pdo, 'Hutasuhut', 'L', $pul_id, 8, 'Keturunan Datu Pulungan', NULL, NULL, 'Hutasuhut', 'Mandailing/Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 6: SIHOMBING SI OPAT AMA (dari Si Raja Sumba)
// ============================================
echo "Gen 6: Sihombing si Opat Ama...\n";
$sihombing_anak = [
    ['Borsak Jungjungan (Silaban)', 'Silaban', 'Toba'],
    ['Borsak Sirumonggur (Lumbantoruan)', 'Lumbantoruan', 'Toba'],
    ['Borsak Mangatasi (Nababan)', 'Nababan', 'Toba'],
    ['Borsak Bimbinan (Hutasoit)', 'Hutasoit', 'Toba'],
];
foreach ($sihombing_anak as $s) {
    ins($pdo, $s[0], 'L', $g5_sumba, 6, 'Sihombing si Opat Ama (putra Si Raja Sumba dari Si Boru Anakpandan)', NULL, NULL, $s[1], $s[2], $src_hutagalung, 'tinggi');
}

// ============================================
// Gen 6: Sub-marga LONTUNG
// ============================================
echo "Gen 6: Lontung sub-marga...\n";

// Situmorang sub
$stm_sub = ['Siringoringo','Lumban Nahor','Lumban Pande','Suhutnihuta','Sitohang','Rumapea','Padang','Solin','Sihotang Toruan','Sihorang Tonga-tonga','Sihotang Uruk'];
foreach ($stm_sub as $s) {
    ins($pdo, $s, 'L', $g5_stm, 6, 'Submarga Situmorang', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Sinaga sub
$sin_sub = ['Sidagurgur','Sidahambang','Sidahapitu','Sidahoro','Sidalogan','Sidasuhut','Simaibang','Simandalahi','Simanjorang','Porti'];
foreach ($sin_sub as $s) {
    ins($pdo, 'Sinaga '.$s, 'L', $g5_sin, 6, 'Submarga Sinaga', NULL, NULL, 'Sinaga '.$s, 'Toba', $src_wiki, 'sedang');
}

// Pandiangan sub
foreach (['Samosir','Pakpahan','Gultom','Sidari','Sitinjak','Harianja'] as $s) {
    ins($pdo, $s, 'L', $g5_pan, 6, 'Submarga Pandiangan', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Nainggolan sub
$nai_sub = ['Parhusip','Lumban Tungkup','Lumban Siantar','Hutabalian','Lumban Raja','Pusuk','Buaton','Mahulae (Batuara)'];
foreach ($nai_sub as $s) {
    ins($pdo, $s, 'L', $g5_nai, 6, 'Submarga Nainggolan', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Simatupang sub
foreach (['Togatorop','Sianturi','Siburian'] as $s) {
    ins($pdo, $s, 'L', $g5_sim, 6, 'Submarga Simatupang', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Aritonang sub
foreach (['Ompusunggu','Rajagukguk','Simaremare'] as $s) {
    ins($pdo, $s, 'L', $g5_ari, 6, 'Submarga Aritonang', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Siregar sub
foreach (['Silo (Dongoran)','Silali','Siagian','Ritonga','Sormin'] as $s) {
    ins($pdo, $s, 'L', $g5_sir, 6, 'Submarga Siregar', NULL, NULL, $s, 'Toba/Angkola', $src_hutagalung, 'tinggi');
}

// ============================================
// Gen 6: Sub-marga NAI AMBATON
// ============================================
echo "Gen 6: Nai Ambaton sub-marga...\n";

// Simbolon sub (Si Onom Hudon)
$simb_sub = ['Tinambunan','Tumanggor','Maharaja','Turutan','Nahampun','Pinayungan'];
foreach ($simb_sub as $s) {
    ins($pdo, $s, 'L', $g5_simb, 6, 'Si Onom Hudon - Submarga Simbolon', NULL, NULL, $s, 'Toba/Pakpak', $src_hutagalung, 'tinggi');
}

// Tamba sub
$tam_sub = ['Siallagan','Tomok','Sidabutar','Sijabat','Gusar','Siadari','Sidabolak','Rumahorbo','Napitu'];
foreach ($tam_sub as $s) {
    ins($pdo, $s, 'L', $g5_tam, 6, 'Submarga Tamba', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Saragi sub
$sar_sub = ['Simalango','Saing','Simarmata','Nadeak','Sidabungke'];
foreach ($sar_sub as $s) {
    ins($pdo, $s, 'L', $g5_sar, 6, 'Submarga Saragi', NULL, NULL, $s, 'Toba/Simalungun', $src_hutagalung, 'tinggi');
}

// Munte sub
$mun_sub = ['Sitanggang','Manihuruk','Sidauruk','Turnip','Sitio','Sigalingging'];
foreach ($mun_sub as $s) {
    ins($pdo, $s, 'L', $g5_mun, 6, 'Submarga Munte', NULL, NULL, $s, 'Toba/Pakpak/Simalungun', $src_hutagalung, 'tinggi');
}

// ============================================
// Gen 6: Sub-marga NAI RASAON
// ============================================
foreach (['Sitorus','Sirait','Butarbutar'] as $s) {
    ins($pdo, $s, 'L', $g5_mdp, 6, 'Submarga Raja Mardopang', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}
ins($pdo, 'Toga Manurung', 'L', $g5_mgt, 6, 'Putra Raja Mangatur', NULL, NULL, 'Manurung', 'Toba', $src_hutagalung, 'tinggi');

// ============================================
// Gen 6: Sub-marga NAI SUANON
// ============================================
echo "Gen 6: Nai Suanon sub-marga...\n";

// Si Bagot Ni Pohan sub
$bagot_sub = ['Tampubolon','Baringbing','Silaen','Siahaan','Simanjuntak','Hutagaol','Nasution','Panjaitan','Siagian (Naisuanon)','Silitonga','Sianipar','Pardosi','Simangunsong','Marpaung','Napitupulu','Pardede'];
foreach ($bagot_sub as $s) {
    ins($pdo, $s, 'L', $g5_bag, 6, 'Submarga Si Bagot Ni Pohan', NULL, NULL, $s, 'Toba/Mandailing', $src_hutagalung, 'tinggi');
}

// Si Paet Tua sub
$paet_sub = ['Hutahaean','Hutajulu','Aruan','Sibarani','Sibuea','Sarumpaet','Pangaribuan','Hutapea (Paet Tua)'];
foreach ($paet_sub as $s) {
    ins($pdo, $s, 'L', $g5_paet, 6, 'Submarga Si Paet Tua', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Si Lahi Sabungan sub
$lahi_sub = ['Sihaloho','Situngkir','Sipangkar','Sipayung','Sirumasondi','Sidabutar (Lahi)','Sidabariba','Pintubatu','Sigiro','Tambun (Tambunan)','Doloksaribu','Sinurat','Naiborhu','Nadapdap','Pagaraji','Sunge','Sidebang','Sinabariba','Boliala','Ujungsaribu','Depari','Rumasingap','Rumasondi'];
foreach ($lahi_sub as $s) {
    ins($pdo, $s, 'L', $g5_lahi, 6, 'Submarga Si Lahi Sabungan', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// Si Raja Oloan sub
$oloan_sub = ['Naibaho','Sihotang','Hasugian','Lingga','Sinambela','Sihite','Simanullang','Bangkara','Bintang','Ujung','Sinamo','Mataniari','Sileang','Sipardabuan','Torbandolok','Simarsoit'];
foreach ($oloan_sub as $s) {
    ins($pdo, $s, 'L', $g5_oloan, 6, 'Submarga Si Raja Oloan', NULL, NULL, $s, 'Toba/Karo', $src_hutagalung, 'tinggi');
}

// Si Raja Huta Lima sub
foreach (['Maha','Sambo','Pardosi (Huta Lima)'] as $s) {
    ins($pdo, $s, 'L', $g5_hutalima, 6, 'Submarga Si Raja Huta Lima', NULL, NULL, $s, 'Toba/Karo', $src_hutagalung, 'tinggi');
}

// Si Raja Sumba sub
$sumba_sub = ['Simamora','Rambe','Purba (Sumba)','Manalu','Debataraja','Girsang','Tambak','Siboro','Sitindaon','Binjori'];
foreach ($sumba_sub as $s) {
    ins($pdo, $s, 'L', $g5_sumba, 6, 'Submarga Si Raja Sumba', NULL, NULL, $s, 'Toba/Simalungun/Karo', $src_hutagalung, 'tinggi');
}

// Manalu sub-marga
$manalu_sub = ['Rumabutar','Rumagorga','Rumahole','Rumaijuk','Sigukguhi','Sorimunggu','Boangmanalu'];
foreach ($manalu_sub as $s) {
    // Get Manalu node id
    $stmt = $pdo->prepare("SELECT id FROM silsilah_mitolologis WHERE nama = 'Manalu' AND orang_tuan_id = ?");
    $stmt->execute([$g5_sumba]);
    $manalu_id = $stmt->fetchColumn();
    if ($manalu_id) {
        ins($pdo, $s, 'L', $manalu_id, 7, 'Submarga Manalu', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
    }
}

// Si Raja Sobu sub
$sobu_sub = ['Sitompul','Hasibuan','Hutabarat','Panggabean','Hutagalung','Hutatoruan','Simorangkir','Hutapea (Sobu)','Lumbantobing','Mismis'];
foreach ($sobu_sub as $s) {
    ins($pdo, $s, 'L', $g5_sobu, 6, 'Submarga Si Raja Sobu', NULL, NULL, $s, 'Toba/Mandailing/Angkola', $src_hutagalung, 'tinggi');
}

// Toga Naipospos sub
$naipos_sub = ['Marbun','Lumbanbatu','Banjarnahor','Lumbangaol','Sibagariang','Hutauruk','Simanungkalit','Situmeang','Mungkur','Saraan','Mukur'];
foreach ($naipos_sub as $s) {
    ins($pdo, $s, 'L', $g5_naipos, 6, 'Submarga Toga Naipospos', NULL, NULL, $s, 'Toba', $src_hutagalung, 'tinggi');
}

// ============================================
// Gen 6: Karo link (Sembiring dari Huta Lima)
// ============================================
echo "Gen 6: Karo links...\n";
// Sembiring berasal dari Si Raja Huta Lima (Pardosi/Sembiring Meliala)
// Sudah dicatat di info Si Raja Huta Lima

// Ginting berasal dari Manik (Silau Raja) - sudah dicatat di info Manik

// ============================================
// LINK MARGA TO SILSILAH NODES
// ============================================
echo "Linking marga to silsilah nodes...\n";

// Build mapping: marga_turunan → silsilah node id
$stmt = $pdo->query("SELECT id, marga_turunan FROM silsilah_mitolologis WHERE marga_turunan IS NOT NULL");
$nodeMap = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $mt = $row['marga_turunan'];
    // Map common variations
    $mt = str_replace([' (induk)', ' (Tua)', ' (Sahangmaima)', ' (Nai Ambaton)', ' (Parna)'], '', $mt);
    $nodeMap[$mt] = $row['id'];
}

// Link marga by matching nama to marga_turunan
foreach ($nodeMap as $mt => $nodeId) {
    // Try exact match
    $pdo->exec("UPDATE marga SET silsilah_node_id = {$nodeId} WHERE nama = " . $pdo->quote($mt) . " AND silsilah_node_id IS NULL");
    // Try partial match (marga_turunan contains marga nama)
    $pdo->exec("UPDATE marga SET silsilah_node_id = {$nodeId} WHERE silsilah_node_id IS NULL AND " . $pdo->quote($mt) . " LIKE CONCAT('%', nama, '%') AND nama NOT IN (SELECT nama FROM marga WHERE silsilah_node_id IS NOT NULL)");
}

// Manual links for key marga
$manualLinks = [
    'Sihombing' => $g5_sumba,
    'Silalahi' => $g5_lahi,
    'Pohan' => $g5_bag,
    'Tampubolon' => $g5_bag,
    'Borbor' => $g4_bor,
    'Limbong' => $g3_lim,
    'Sagala' => $g3_sag,
    'Simbolon' => $g5_simb,
    'Tamba' => $g5_tam,
    'Saragi' => $g5_sar,
    'Saragih' => $g5_sar,
    'Munte' => $g5_mun,
    'Sitorus' => $g5_mdp,
    'Sirait' => $g5_mdp,
    'Butarbutar' => $g5_mdp,
    'Manurung' => $g5_mgt,
    'Situmorang' => $g5_stm,
    'Sinaga' => $g5_sin,
    'Pandiangan' => $g5_pan,
    'Nainggolan' => $g5_nai,
    'Simatupang' => $g5_sim,
    'Aritonang' => $g5_ari,
    'Siregar' => $g5_sir,
    'Naipospos' => $g5_naipos,
    'Naibaho' => $g5_oloan,
    'Sihotang' => $g5_oloan,
    'Hasibuan' => $g5_sobu,
    'Hutagalung' => $g5_sobu,
    'Simamora' => $g5_sumba,
    'Purba' => $g5_sumba,
    'Manalu' => $g5_sumba,
    'Ambarita' => $g3_sil,
    'Malau' => $g3_sil,
    'Gurning' => $g3_sil,
    'Manik' => $g4_manik,
    'Damanik' => $g4_manik,
    'Sihole' => $g4_lang,
    'Habeahan' => $g4_lang,
    'Sipahutar' => $g6_datu,
    'Harahap' => $g6_datu,
    'Tanjung' => $g6_datu,
    'Pulungan' => $g6_datu,
    'Lubis' => $g6_datu,
    'Hutasuhut' => $g6_datu,
    'Pasaribu' => $g6_datu,
    'Batubara' => $g6_datu,
    'Tarihoran' => $g6_datu,
    'Rangkuti' => $g6_datu,
    'Matondang' => $g6_datu,
    'Silaban' => $g5_sumba,
    'Lumbantoruan' => $g5_sumba,
    'Nababan' => $g5_sumba,
    'Hutasoit' => $g5_sumba,
];

foreach ($manualLinks as $margaNama => $nodeId) {
    $pdo->exec("UPDATE marga SET silsilah_node_id = {$nodeId} WHERE nama = " . $pdo->quote($margaNama) . " AND silsilah_node_id IS NULL");
}

// ============================================
// STATS
// ============================================
echo "\n=== STATS ===\n";
echo "Total silsilah nodes: " . $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis")->fetchColumn() . "\n";
echo "Nodes with marga_turunan: " . $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis WHERE marga_turunan IS NOT NULL")->fetchColumn() . "\n";
echo "Total marga: " . $pdo->query("SELECT COUNT(*) FROM marga")->fetchColumn() . "\n";
echo "Marga linked to silsilah: " . $pdo->query("SELECT COUNT(*) FROM marga WHERE silsilah_node_id IS NOT NULL")->fetchColumn() . "\n";
echo "Marga with induk: " . $pdo->query("SELECT COUNT(*) FROM marga WHERE marga_induk_id IS NOT NULL")->fetchColumn() . "\n";

echo "\nGenerasi:\n";
$stmt = $pdo->query("SELECT generasi_ke, COUNT(*) as total FROM silsilah_mitolologis GROUP BY generasi_ke ORDER BY generasi_ke");
foreach ($stmt as $r) {
    echo "  Gen{$r['generasi_ke']}: {$r['total']} nodes\n";
}

echo "\nPart 2 done.\n";
