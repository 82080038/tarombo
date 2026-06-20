<?php
$pageTitle = 'Pohon Silsilah Batak';
$activePage = 'silsilah';
$extraCss = 'silsilah.css';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
require_once __DIR__ . '/includes/content.php';

// Connect to database
$socket = '/opt/lampp/var/mysql/mysql.sock';
$pdo = new PDO("mysql:unix_socket=$socket;dbname=tarombo", 'root', 'root');
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Get silsilah node count
$totalSilsilah = $pdo->query("SELECT COUNT(*) FROM silsilah_mitolologis")->fetchColumn();

// Get silsilah nodes with ibu info for detail view
$stmt = $pdo->query("
    SELECT s.id, s.nama, s.jenis_kelamin, s.generasi_ke, s.marga_turunan, s.wilayah, s.bona_pasogit, s.peran,
           s.orang_tuan_id,
           ot.nama AS nama_ayah,
           p.id AS ibu_id, p.nama AS nama_ibu, p.boru_marga AS ibu_marga, p.urutan_istri,
           s.info_perkawinan
    FROM silsilah_mitolologis s
    LEFT JOIN silsilah_mitolologis ot ON s.orang_tuan_id = ot.id
    LEFT JOIN pasangan p ON s.ibu_id = p.id
    ORDER BY s.generasi_ke, s.id
");
$allNodes = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Get all pasangan grouped by node (istri → suami)
$stmt = $pdo->query("SELECT * FROM pasangan ORDER BY silsilah_node_id, urutan_istri");
$allPasangan = [];
$allSuami = []; // reverse: pasangan id → suami node id
foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $p) {
    if (!isset($allPasangan[$p['silsilah_node_id']])) $allPasangan[$p['silsilah_node_id']] = [];
    $allPasangan[$p['silsilah_node_id']][] = $p;
    $allSuami[$p['id']] = $p['silsilah_node_id'];
}

// For female nodes in silsilah, find their suami by matching nama to pasangan.nama
$stmt = $pdo->query("
    SELECT p.id AS pasangan_id, p.nama AS pasangan_nama, p.silsilah_node_id AS suami_id,
           s.nama AS suami_nama, s.marga_turunan AS suami_marga
    FROM pasangan p
    JOIN silsilah_mitolologis s ON p.silsilah_node_id = s.id
");
$suamiLookup = []; // pasangan_nama (lowercase) → [{suami_id, suami_nama, suami_marga, urutan_istri}]
foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
    $key = strtolower(trim($row['pasangan_nama']));
    if (!isset($suamiLookup[$key])) $suamiLookup[$key] = [];
    $suamiLookup[$key][] = $row;
}

// Get children grouped by parent
$stmt = $pdo->query("
    SELECT s.orang_tuan_id, s.id, s.nama, s.marga_turunan, s.jenis_kelamin,
           p.nama AS nama_ibu
    FROM silsilah_mitolologis s
    LEFT JOIN pasangan p ON s.ibu_id = p.id
    WHERE s.orang_tuan_id IS NOT NULL
    ORDER BY s.orang_tuan_id, s.id
");
$allChildren = [];
foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $c) {
    if (!isset($allChildren[$c['orang_tuan_id']])) $allChildren[$c['orang_tuan_id']] = [];
    $allChildren[$c['orang_tuan_id']][] = $c;
}

// Get marga grouped by kelompok
$stmt = $pdo->query("SELECT nama, sub_suku, kelompok_marga FROM marga WHERE kelompok_marga IS NOT NULL ORDER BY kelompok_marga, nama");
$allMarga = $stmt->fetchAll(PDO::FETCH_ASSOC);

$margaByKelompok = [];
foreach ($allMarga as $m) {
    $kelompok = $m['kelompok_marga'];
    if (!isset($margaByKelompok[$kelompok])) $margaByKelompok[$kelompok] = [];
    $margaByKelompok[$kelompok][] = $m;
}

$totalMarga = count($allMarga);

// Sub-suku statistics
$stmt = $pdo->query("SELECT sub_suku, COUNT(*) as total FROM marga GROUP BY sub_suku ORDER BY total DESC");
$subSukuStats = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Marga in multiple sub-suku
$stmt = $pdo->query("SELECT m.nama, m.id, COUNT(DISTINCT ms.sub_suku) as sukucount, GROUP_CONCAT(DISTINCT ms.sub_suku ORDER BY ms.sub_suku SEPARATOR ', ') as subuku FROM marga m JOIN marga_sub_suku ms ON m.id = ms.marga_id GROUP BY m.id HAVING sukucount > 1 ORDER BY sukucount DESC, m.nama");
$multiSukuMarga = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Marga aliases
$stmt = $pdo->query("SELECT m.nama as marga_asli, ma.alias_nama, ma.sub_suku, ma.keterangan FROM marga_alias ma JOIN marga m ON ma.marga_id = m.id ORDER BY m.nama, ma.sub_suku");
$margaAliases = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Total marga (all, not just with kelompok)
$totalAllMarga = $pdo->query("SELECT COUNT(*) FROM marga")->fetchColumn();
$totalAliases = count($margaAliases);
$totalMultiSuku = count($multiSukuMarga);

$kelompokColors = [
    'Lontung' => 'primary',
    'Borbor' => 'warning',
    'Naiambaton' => 'info',
    'Nairasaon' => 'success',
    'Naisuanon' => 'danger',
    'Silau Raja' => 'secondary',
    'Sagala' => 'dark',
    'Limbong' => 'secondary',
    'Campuran' => 'secondary',
];
?>

<div class="container mt-4">
    <div class="dashboard-welcome mb-4">
        <h2>🌳 Pohon Silsilah Batak Lengkap</h2>
        <p class="mb-0">Dari penciptaan dunia hingga <?= $totalMarga ?> marga modern &mdash; <?= $totalSilsilah ?> tokoh, 8 kelompok induk, 9 generasi</p>
    </div>

    <!-- ===== KOSMOLOGI ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h5 class="mb-0">🌌 Kosmologi Batak &mdash; Tiga Dunia</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="card border-primary h-100 text-center">
                                <div class="card-body">
                                    <div style="font-size: 2.5rem;">🏔️</div>
                                    <h5>Banua Ginjang</h5>
                                    <p class="small text-muted">Dunia atas (langit)<br>Tempat: Mulajadi Na Bolon, Batara Guru</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-success h-100 text-center">
                                <div class="card-body">
                                    <div style="font-size: 2.5rem;">🌍</div>
                                    <h5>Banua Tonga</h5>
                                    <p class="small text-muted">Dunia tengah (bumi)<br>Tempat manusia dan Si Raja Batak</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-danger h-100 text-center">
                                <div class="card-body">
                                    <div style="font-size: 2.5rem;">🐍</div>
                                    <h5>Banua Toru</h5>
                                    <p class="small text-muted">Dunia bawah<br>Tempat Naga Padoha</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== DETAIL TOKOH SILSILAH ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-info">
                <div class="card-header bg-info text-white d-flex align-items-center justify-content-between">
                    <h5 class="mb-0">👥 Detail Tokoh Silsilah</h5>
                    <span class="small"><?= $totalSilsilah ?> tokoh · <?= count($allPasangan) ?> pasangan</span>
                </div>
                <div class="card-body">
                    <p class="text-muted">Pilih tokoh untuk melihat info lengkap: ayah, ibu, istri, dan keturunan.</p>
                    <div class="row g-3 mb-3">
                        <div class="col-md-8">
                            <input type="text" id="tokohSearch" class="form-control" placeholder="🔍 Cari tokoh... (cth: Si Lahi Sabungan, Guru Tatea Bulan)">
                        </div>
                        <div class="col-md-4">
                            <select id="tokohFilter" class="form-select">
                                <option value="0">Semua Generasi</option>
                                <?php for ($g = 1; $g <= 8; $g++): ?>
                                    <option value="<?= $g ?>">Generasi <?= $g ?></option>
                                <?php endfor; ?>
                            </select>
                        </div>
                    </div>
                    <div id="tokohList" class="row" style="max-height: 400px; overflow-y: auto;">
                        <?php foreach ($allNodes as $n): ?>
                            <div class="col-md-4 col-sm-6 mb-2 tokoh-item" data-nama="<?= strtolower(htmlspecialchars($n['nama'])) ?>" data-gen="<?= $n['generasi_ke'] ?>" data-id="<?= $n['id'] ?>">
                                <div class="card border-<?= $n['jenis_kelamin'] === 'P' ? 'danger' : 'primary' ?> h-100" style="cursor: pointer;" onclick="showTokohDetail(<?= $n['id'] ?>)">
                                    <div class="card-body p-2">
                                        <div class="d-flex align-items-center">
                                            <span class="me-1"><?= $n['jenis_kelamin'] === 'P' ? '♀' : '♂' ?></span>
                                            <div>
                                                <strong class="small"><?= htmlspecialchars($n['nama']) ?></strong>
                                                <?php if ($n['marga_turunan']): ?>
                                                    <span class="badge bg-secondary ms-1" style="font-size:0.6rem"><?= htmlspecialchars($n['marga_turunan']) ?></span>
                                                <?php endif; ?>
                                                <div class="small text-muted">Gen <?= $n['generasi_ke'] ?><?= $n['wilayah'] ? ' · ' . htmlspecialchars($n['wilayah']) : '' ?></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                    <div id="tokohDetail" class="mt-3" style="display:none;">
                        <hr>
                        <div id="tokohDetailContent"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== DAFTAR MARGA PER KELOMPOK ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-warning">
                    <h5 class="mb-0">🏛️ Daftar Lengkap Marga per Kelompok</h5>
                </div>
                <div class="card-body">
                    <?php foreach ($margaByKelompok as $kelompok => $margaList): ?>
                        <div class="mb-4">
                            <h6 class="fw-bold text-<?= $kelompokColors[$kelompok] ?? 'secondary' ?>">
                                <span class="badge bg-<?= $kelompokColors[$kelompok] ?? 'secondary' ?> me-2"><?= count($margaList) ?></span>
                                Kelompok <?= htmlspecialchars($kelompok) ?>
                            </h6>
                            <div class="row ms-3">
                                <?php foreach ($margaList as $m): ?>
                                    <div class="col-md-3 col-sm-6 mb-2">
                                        <div class="card border-<?= $kelompokColors[$kelompok] ?? 'secondary' ?> h-100">
                                            <div class="card-body p-2">
                                                <strong><?= htmlspecialchars($m['nama']) ?></strong>
                                                <div class="small text-muted"><?= htmlspecialchars($m['sub_suku']) ?></div>
                                            </div>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== SUB-SUKU & PENAMAAN MARGA ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-secondary">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">🌍 Sub-Suku Batak &amp; Variasi Penamaan Marga</h5>
                </div>
                <div class="card-body">
                    <p>Suku Batak terbagi menjadi <strong>6 sub-suku utama</strong>: Toba, Karo, Pakpak/Dairi, Simalungun, Angkola, dan Mandailing. Total tercatat <strong><?= $totalAllMarga ?> marga</strong> di database, dengan <strong><?= $totalMultiSuku ?> marga</strong> yang tersebar di lebih dari satu sub-suku, dan <strong><?= $totalAliases ?> alias</strong> (nama berbeda untuk marga yang sama).</p>

                    <!-- Statistik per sub-suku -->
                    <h6 class="fw-bold mt-3 mb-2">📊 Distribusi Marga per Sub-Suku</h6>
                    <div class="row mb-4">
                        <?php foreach ($subSukuStats as $ss): ?>
                            <div class="col-md-2 col-sm-4 mb-2 text-center">
                                <div class="card border-primary h-100">
                                    <div class="card-body p-2">
                                        <div class="fs-4 fw-bold text-primary"><?= $ss['total'] ?></div>
                                        <div class="small">Batak <?= htmlspecialchars($ss['sub_suku']) ?></div>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <!-- Marga di multiple sub-suku -->
                    <h6 class="fw-bold mt-4 mb-2">🔗 Marga yang Muncul di Multiple Sub-Suku</h6>
                    <p class="small text-muted">Marga-marga ini ada di lebih dari satu sub-suku karena persebaran migrasi atau karena memang berasal dari leluhur yang sama.</p>
                    <div class="table-responsive mb-4">
                        <table class="table table-sm table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Marga</th>
                                    <th>Jumlah Sub-Suku</th>
                                    <th>Sub-Suku</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($multiSukuMarga as $ms): ?>
                                    <tr>
                                        <td class="fw-bold"><?= htmlspecialchars($ms['nama']) ?></td>
                                        <td><span class="badge bg-primary"><?= $ms['sukucount'] ?></span></td>
                                        <td><?= htmlspecialchars($ms['subuku']) ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <!-- Alias / nama berbeda -->
                    <h6 class="fw-bold mt-4 mb-2">📝 Alias Marga — Satu Marga, Banyak Nama</h6>
                    <p class="small text-muted">Marga yang sama dapat memiliki nama berbeda di sub-suku lain. Ini bukan marga yang berbeda, melainkan variasi penamaan dari leluhur yang sama.</p>
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Marga (Nama Asli)</th>
                                    <th>Alias / Nama Lain</th>
                                    <th>Sub-Suku</th>
                                    <th>Keterangan</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($margaAliases as $alias): ?>
                                    <tr>
                                        <td class="fw-bold text-primary"><?= htmlspecialchars($alias['marga_asli']) ?></td>
                                        <td class="fw-bold text-danger"><?= htmlspecialchars($alias['alias_nama']) ?></td>
                                        <td><span class="badge bg-secondary"><?= htmlspecialchars($alias['sub_suku']) ?></span></td>
                                        <td class="small"><?= htmlspecialchars($alias['keterangan']) ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>

                    <div class="alert alert-info mt-3 mb-0">
                        <strong>💡 Mengapa ini terjadi?</strong>
                        <ul class="mb-0 mt-2">
                            <li><strong>Variasi ejaan</strong>: Tinambunan → Tinambunen, Tumanggor → Tumangger</li>
                            <li><strong>Nama singkat berbeda</strong>: Naibaho → Bako (Pakpak), Sihaloho → Kaloko (Pakpak)</li>
                            <li><strong>Sub-marga jadi marga mandiri</strong>: Siregar → Dongoran/Ritonga/Siagian (Angkola)</li>
                            <li><strong>Marga Toba jadi marga induk</strong>: Sinaga, Purba, Saragih → marga induk Simalungun</li>
                            <li><strong>Marga Toba jadi sub-marga Karo</strong>: Munte → Ginting Munte, Manik → Ginting Manik</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== PARTUTURAN CHECKER ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-success">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0">🔍 Partuturan Checker — Hitung Sebutan Kekerabatan Batak</h5>
                </div>
                <div class="card-body">
                    <p class="text-muted">Pilih dua orang dari pohon silsilah untuk mengetahui sebutan kekerabatan (partuturan) Batak di antara mereka.</p>
                    <div class="row g-3 mb-3">
                        <div class="col-md-5">
                            <label class="form-label fw-bold">Orang 1:</label>
                            <select id="partuturanNode1" class="form-select"><option value="">— Pilih orang —</option></select>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label fw-bold">Orang 2:</label>
                            <select id="partuturanNode2" class="form-select"><option value="">— Pilih orang —</option></select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button id="btnHitungPartuturan" class="btn btn-success w-100">🔍 Hitung</button>
                        </div>
                    </div>
                    <div id="partuturanResult" class="alert alert-success d-none">
                        <h6 class="alert-heading">Hasil Partuturan</h6>
                        <div id="partuturanContent"></div>
                    </div>
                    <div id="partuturanError" class="alert alert-danger d-none"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== KONTRIBUSI KOMUNITAS ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-warning">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0">✍️ Kontribusi Komunitas — Usulkan Koreksi atau Data Baru</h5>
                </div>
                <div class="card-body">
                    <p class="text-muted">Bantu kami melengkapi data silsilah. Usulan Anda akan ditinjau oleh admin sebelum dipublikasikan.</p>
                    <form id="kontribusiForm">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Jenis Usulan:</label>
                                <select id="kontribusiJenis" class="form-select" required>
                                    <option value="">— Pilih jenis —</option>
                                    <option value="tambah_node">Tambah tokoh baru ke silsilah</option>
                                    <option value="edit_node">Koreksi data tokoh yang ada</option>
                                    <option value="tambah_marga">Tambah marga yang hilang</option>
                                    <option value="koreksi_silsilah">Koreksi hubungan silsilah</option>
                                    <option value="laporan_error">Laporkan error/data salah</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Nama Anda:</label>
                                <input type="text" id="kontribusiNama" class="form-control" placeholder="Nama (opsional)">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Email:</label>
                                <input type="email" id="kontribusiEmail" class="form-control" placeholder="Email (opsional)">
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold">Detail Usulan:</label>
                                <textarea id="kontribusiDetail" class="form-control" rows="4" placeholder="Jelaskan usulan atau koreksi Anda secara detail. Contoh: 'Toga Sihombing seharusnya anak Si Raja Sumba, bukan Si Raja Oloan'" required></textarea>
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn btn-warning">📤 Kirim Usulan</button>
                                <span id="kontribusiStatus" class="ms-3"></span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== SHARE ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-primary">
                <div class="card-body text-center">
                    <h5 class="mb-3">📤 Bagikan Pohon Silsilah Ini</h5>
                    <a href="https://wa.me/?text=Lihat%20Pohon%20Silsilah%20Batak%20-%20Tarombo%20Digital%3A%20<?= urlencode(TAROMBO_BASE_URL . '/silsilah') ?>" target="_blank" rel="noopener" class="btn btn-success btn-lg me-2">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-whatsapp me-1" viewBox="0 0 16 16"><path d="M13.601 2.326A7.854 7.854 0 0 0 7.994 0C3.627 0 .068 3.558.064 7.926c0 1.399.366 2.76 1.057 3.965L0 16l4.204-1.102a7.933 7.933 0 0 0 3.79.965h.004c4.368 0 7.926-3.558 7.93-7.93A7.898 7.898 0 0 0 13.6 2.326zM7.994 14.521a6.573 6.573 0 0 1-3.356-.92l-.24-.144-2.494.654.666-2.433-.156-.251a6.56 6.56 0 0 1-1.007-3.505c0-3.626 2.957-6.584 6.591-6.584a6.56 6.56 0 0 1 4.66 1.931 6.587 6.587 0 0 1 1.928 4.66c-.004 3.639-2.961 6.582-6.592 6.582zm3.615-4.934c-.197-.099-1.17-.578-1.353-.646-.182-.065-.315-.099-.445.099-.132.197-.513.646-.627.775-.114.131-.232.148-.43.05-.197-.099-.837-.308-1.592-.985-.59-.525-.985-1.175-1.103-1.372-.114-.197-.011-.304.088-.403.087-.088.197-.232.296-.346.1-.114.131-.198.198-.33.065-.131.033-.248-.05-.346-.099-.099-.445-.578-.608-.775-.165-.197-.33-.165-.43-.099-.132.065-.248.099-.346.099-.131.033-.248-.033-.346-.05-.197-.099-.837-.308-1.592-.985-.59-.525-.985-1.175-1.103-1.372-.114-.197-.011-.304.088-.403.087-.088.197-.232.296-.346.1-.114.131-.198.198-.33.065-.131.033-.248-.05-.346z"/></svg>
                        Share ke WhatsApp
                    </a>
                    <button onclick="navigator.clipboard.writeText('<?= TAROMBO_BASE_URL ?>/silsilah').then(()=>alert('Link disalin!'))" class="btn btn-outline-primary btn-lg">📋 Salin Link</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== SUMBER DAN REFERENSI ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-info">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">📚 Sumber & Referensi</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-warning mb-3">
                        <strong>⚠️ Catatan Penting:</strong> Silsilah ini disusun berdasarkan turiturian (cerita turun-temurun) dan tarombo yang ditulis sejak tahun 1920-an. Seperti dikatakan oleh Manguji Nababan (Pusat Dokumentasi dan Pengkajian Kebudayaan Batak, Universitas Nomensen), tradisi menulis tarombo baru ada sejak tahun 1920-an, dimulai oleh W.M. Hutagalung. Penulisan tarombo yang dituliskan secara turun-temurun terkadang mengaburkan garis batas antara mitos dan realitas. Jika Anda menemukan ketidaksesuaian, silakan hubungi kami untuk koreksi.
                    </div>
                    <p class="fw-bold mb-2">Data silsilah ini dikumpulkan dari sumber-sumber berikut:</p>
                    <ol class="mb-0">
                        <li class="mb-2">
                            <strong>W.M. Hutagalung</strong>, "PUSTAHA BATAK: Tarombo dohot Turiturian ni Bangso Batak" (1926) — Sumber utama tarombo Batak yang paling banyak dirujuk.
                        </li>
                        <li class="mb-2">
                            <strong>BPODT (Badan Pelaksana Otorita Danau Toba)</strong> — <a href="https://bpodt.kemenpar.go.id/jejak-batak-siraja-batak/" target="_blank" rel="noopener">Jejak Batak: Siraja Batak</a> — Referensi resmi pemerintah tentang asal-usul Batak.
                        </li>
                        <li class="mb-2">
                            <strong>Budaya-Indonesia.org</strong> — <a href="https://budaya-indonesia.org/TAROMBO-Silsilah-Keluarga-dalam-adat-Batak" target="_blank" rel="noopener">TAROMBO: Silsilah Keluarga dalam Adat Batak</a> — Penjelasan detail keturunan marga.
                        </li>
                        <li class="mb-2">
                            <strong>BatakPedia</strong> — <a href="https://batakpedia.org/mengenal-asal-usul-raja-batak/" target="_blank" rel="noopener">Mengenal Asal Usul Raja Batak</a> — Analisis sejarah dan mitologi.
                        </li>
                        <li class="mb-2">
                            <strong>TobaTobo.com</strong> — <a href="https://www.tobatabo.com/news/batak/118" target="_blank" rel="noopener">Suku Batak dan Jenis-Jenisnya</a> — Struktur marga dan sub-suku.
                        </li>
                        <li class="mb-2">
                            <strong>Wikipedia Indonesia</strong> — <a href="https://id.wikipedia.org/wiki/Siraja_Batak" target="_blank" rel="noopener">Si Raja Batak</a> — Ensiklopedia umum.
                        </li>
                        <li class="mb-2">
                            <strong>Sibatakjalanjalan.com</strong> — <a href="https://www.sibatakjalanjalan.com/2020/04/sejarah-dan-legenda-pomparan-si-raja-batak-lengkap.html" target="_blank" rel="noopener">Sejarah dan Legenda Pomparan Si Raja Batak</a> — Detail kelompok marga.
                        </li>
                    </ol>
                    <hr class="my-3">
                    <p class="small text-muted mb-0">
                        <strong>Disclaimer:</strong> Situs ini bertujuan mendokumentasikan warisan budaya Batak. Data silsilah bersifat mitologis-legendaris dan dapat berbeda antar versi tarombo. Untuk verifikasi silsilah keluarga pribadi, silakan konsultasi dengan tetua marga atau ahli tarombo setempat. Jika ada koreksi, silakan email kami di <a href="mailto:info@tarombo.id">info@tarombo.id</a>.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== CTA ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card bg-primary text-white">
                <div class="card-body text-center py-4">
                    <h4 class="mb-3">🌳 Cari Silsilah Keluarga Anda</h4>
                    <p class="mb-3">Login untuk melihat silsilah keluarga Anda, menghitung partuturan, dan terhubung dengan marga lain.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/login" class="btn btn-light btn-lg me-2">🔑 Masuk</a>
                    <a href="<?= TAROMBO_BASE_URL ?>/register" class="btn btn-outline-light btn-lg">📝 Daftar</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// ===== DETAIL TOKOH SILSILAH =====
const allNodesData = <?= json_encode($allNodes) ?>;
const allPasanganData = <?= json_encode($allPasangan) ?>;
const allChildrenData = <?= json_encode($allChildren) ?>;
const suamiLookup = <?= json_encode($suamiLookup) ?>;

function showTokohDetail(id) {
    const node = allNodesData.find(n => n.id == id);
    if (!node) return;
    
    const detailDiv = document.getElementById('tokohDetail');
    const contentDiv = document.getElementById('tokohDetailContent');
    
    // Istri/Suami list depending on gender
    let pasanganHtml = '';
    let pasanganTitle = '';
    let pasanganIcon = '';
    
    if (node.jenis_kelamin === 'P') {
        // Female node — find suami by matching nama to pasangan.nama
        pasanganTitle = '👨 Suami';
        pasanganIcon = '💕';
        const key = node.nama.toLowerCase().trim();
        const suamiList = suamiLookup[key] || [];
        if (suamiList.length > 0) {
            pasanganHtml = suamiList.map(s => `
                <div class="d-flex align-items-center mb-1">
                    <span class="badge bg-primary me-2" style="font-size:0.65rem">Suami</span>
                    <a href="javascript:void(0)" onclick="showTokohDetail(${s.suami_id})" class="text-decoration-none">
                        <strong>${s.suami_nama}</strong>
                    </a>
                    ${s.suami_marga ? `<span class="badge bg-secondary ms-1" style="font-size:0.6rem">${s.suami_marga}</span>` : ''}
                </div>
            `).join('');
        } else {
            pasanganHtml = '<span class="text-muted">Tidak ada data suami</span>';
        }
    } else {
        // Male node — show istri list
        pasanganTitle = '💕 Istri / Pasangan';
        pasanganIcon = '💕';
        const istriList = allPasanganData[id] || [];
        if (istriList.length > 0) {
            pasanganHtml = istriList.map(i => `
                <div class="d-flex align-items-center mb-1">
                    <span class="badge bg-${i.urutan_istri > 1 ? 'warning' : 'danger'} me-2" style="font-size:0.65rem">Istri ${i.urutan_istri}</span>
                    <strong>${i.nama}</strong>
                    ${i.boru_marga ? `<span class="badge bg-secondary ms-1" style="font-size:0.6rem">Boru ${i.boru_marga}</span>` : ''}
                </div>
            `).join('');
        } else {
            pasanganHtml = '<span class="text-muted">Tidak ada data istri</span>';
        }
    }
    
    // Children list
    const children = allChildrenData[id] || [];
    let childrenHtml = '<span class="text-muted">Tidak ada keturunan</span>';
    if (children.length > 0) {
        childrenHtml = children.map(c => `
            <div class="d-flex align-items-center mb-1">
                <span class="me-1">${c.jenis_kelamin === 'P' ? '♀' : '♂'}</span>
                <a href="javascript:void(0)" onclick="showTokohDetail(${c.id})" class="text-decoration-none">
                    <strong>${c.nama}</strong>
                </a>
                ${c.marga_turunan ? `<span class="badge bg-secondary ms-1" style="font-size:0.6rem">${c.marga_turunan}</span>` : ''}
                ${c.nama_ibu ? `<span class="small text-muted ms-2">♀ ${c.nama_ibu}</span>` : ''}
            </div>
        `).join('');
    }
    
    // Ayah link
    let ayahHtml = '<span class="text-muted">Leluhur awal (tidak ada data orang tua)</span>';
    if (node.nama_ayah) {
        ayahHtml = `<a href="javascript:void(0)" onclick="showTokohDetail(${node.orang_tuan_id})" class="text-decoration-none"><strong>${node.nama_ayah}</strong></a>`;
    }
    
    // Ibu info
    let ibuHtml = '<span class="text-muted">Leluhur awal (tidak ada data orang tua)</span>';
    if (node.nama_ibu) {
        ibuHtml = `<strong>${node.nama_ibu}</strong>`;
        if (node.ibu_marga) ibuHtml += ` <span class="badge bg-secondary ms-1" style="font-size:0.6rem">Boru ${node.ibu_marga}</span>`;
        if (node.urutan_istri) ibuHtml += ` <span class="badge bg-warning ms-1" style="font-size:0.6rem">Istri ke-${node.urutan_istri}</span>`;
    }
    
    const genderIcon = node.jenis_kelamin === 'P' ? '♀' : '♂';
    const genderColor = node.jenis_kelamin === 'P' ? 'danger' : 'primary';
    
    contentDiv.innerHTML = `
        <div class="row g-3">
            <div class="col-md-4">
                <div class="card border-${genderColor} h-100">
                    <div class="card-header bg-${genderColor} text-white py-2">
                        <strong>${genderIcon} ${node.nama}</strong>
                    </div>
                    <div class="card-body p-3">
                        <table class="table table-sm mb-0">
                            <tr><td class="fw-bold text-muted" style="width:35%">Generasi</td><td>Gen ${node.generasi_ke}</td></tr>
                            ${node.marga_turunan ? `<tr><td class="fw-bold text-muted">Marga</td><td><span class="badge bg-secondary">${node.marga_turunan}</span></td></tr>` : ''}
                            ${node.wilayah ? `<tr><td class="fw-bold text-muted">Wilayah</td><td>${node.wilayah}</td></tr>` : ''}
                            ${node.bona_pasogit ? `<tr><td class="fw-bold text-muted">Bona Pasogit</td><td>${node.bona_pasogit}</td></tr>` : ''}
                            ${node.peran ? `<tr><td class="fw-bold text-muted">Peran</td><td class="small">${node.peran}</td></tr>` : ''}
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-success h-100">
                    <div class="card-header bg-success text-white py-2"><strong>👨 Orang Tua</strong></div>
                    <div class="card-body p-3">
                        <div class="mb-2">
                            <div class="small text-muted fw-bold">Ayah:</div>
                            <div class="ms-2">${ayahHtml}</div>
                        </div>
                        <div class="mb-0">
                            <div class="small text-muted fw-bold">Ibu:</div>
                            <div class="ms-2">${ibuHtml}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-danger h-100">
                    <div class="card-header bg-danger text-white py-2"><strong>${pasanganTitle}</strong></div>
                    <div class="card-body p-3">
                        ${pasanganHtml}
                    </div>
                </div>
            </div>
            <div class="col-12">
                <div class="card border-warning">
                    <div class="card-header bg-warning text-dark py-2 d-flex align-items-center justify-content-between">
                        <strong>👶 Keturunan (${children.length})</strong>
                    </div>
                    <div class="card-body p-3">
                        <div style="max-height: 300px; overflow-y: auto;">
                            ${childrenHtml}
                        </div>
                    </div>
                </div>
            </div>
            ${node.info_perkawinan ? `
            <div class="col-12">
                <div class="alert alert-info mb-0">
                    <strong>📋 Info Perkawinan:</strong> ${node.info_perkawinan}
                </div>
            </div>` : ''}
        </div>
    `;
    
    detailDiv.style.display = 'block';
    detailDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

// Search & filter
document.getElementById('tokohSearch')?.addEventListener('input', filterTokoh);
document.getElementById('tokohFilter')?.addEventListener('change', filterTokoh);

function filterTokoh() {
    const query = document.getElementById('tokohSearch').value.toLowerCase();
    const genFilter = parseInt(document.getElementById('tokohFilter').value);
    
    document.querySelectorAll('.tokoh-item').forEach(item => {
        const nama = item.dataset.nama;
        const gen = parseInt(item.dataset.gen);
        const matchQuery = !query || nama.includes(query);
        const matchGen = genFilter === 0 || gen === genFilter;
        item.style.display = (matchQuery && matchGen) ? '' : 'none';
    });
}

// ===== PARTUTURAN CHECKER =====
const API_URL = '<?= TAROMBO_BASE_URL ?>/api/partuturan.php';

// Populate dropdowns with silsilah nodes
async function loadPartuturanDropdowns() {
    try {
        const res = await fetch(API_URL + '?action=search_nodes&q=');
        const data = await res.json();
        if (!data.success) return;
        
        const options = data.results.map(n => 
            `<option value="${n.id}">${n.nama} (${n.marga_turunan || 'tanpa marga'}) — Gen ${n.generasi_ke}</option>`
        ).join('');
        
        document.getElementById('partuturanNode1').innerHTML = '<option value="">— Pilih orang —</option>' + options;
        document.getElementById('partuturanNode2').innerHTML = '<option value="">— Pilih orang —</option>' + options;
    } catch(e) { console.error('Load dropdowns error:', e); }
}

document.getElementById('btnHitungPartuturan')?.addEventListener('click', async () => {
    const n1 = document.getElementById('partuturanNode1').value;
    const n2 = document.getElementById('partuturanNode2').value;
    const resultDiv = document.getElementById('partuturanResult');
    const errorDiv = document.getElementById('partuturanError');
    const contentDiv = document.getElementById('partuturanContent');
    
    resultDiv.classList.add('d-none');
    errorDiv.classList.add('d-none');
    
    if (!n1 || !n2) {
        errorDiv.textContent = 'Pilih dua orang terlebih dahulu.';
        errorDiv.classList.remove('d-none');
        return;
    }
    
    try {
        const res = await fetch(API_URL + '?action=partuturan&node1=' + n1 + '&node2=' + n2);
        const data = await res.json();
        
        if (data.error) {
            errorDiv.textContent = data.error;
            errorDiv.classList.remove('d-none');
            return;
        }
        
        const r = data.result;
        contentDiv.innerHTML = `
            <table class="table table-sm mb-0">
                <tr><td class="fw-bold" style="width:30%">Orang 1</td><td>${data.node1?.nama || '?'} ${data.node1?.marga_turunan ? '(' + data.node1.marga_turunan + ')' : ''}</td></tr>
                <tr><td class="fw-bold">Orang 2</td><td>${data.node2?.nama || '?'} ${data.node2?.marga_turunan ? '(' + data.node2.marga_turunan + ')' : ''}</td></tr>
                <tr><td class="fw-bold">Sebutan Batak</td><td><span class="badge bg-success fs-6">${r.sebutan_batak || '?'}</span></td></tr>
                <tr><td class="fw-bold">Bahasa Indonesia</td><td>${r.sebutan_indonesia || '?'}</td></tr>
                <tr><td class="fw-bold">Tingkat Kekerabatan</td><td>${r.tingkat >= 0 ? 'Generasi ke-' + r.tingkat : 'Tidak terhubung'}</td></tr>
                <tr><td class="fw-bold">Jalur</td><td class="small text-muted">${r.jalur || '-'}</td></tr>
            </table>
        `;
        resultDiv.classList.remove('d-none');
    } catch(e) {
        errorDiv.textContent = 'Error: ' + e.message;
        errorDiv.classList.remove('d-none');
    }
});

// ===== KONTRIBUSI FORM =====
document.getElementById('kontribusiForm')?.addEventListener('submit', async (e) => {
    e.preventDefault();
    const status = document.getElementById('kontribusiStatus');
    status.innerHTML = '<span class="text-muted">Mengirim...</span>';
    
    const payload = {
        jenis: document.getElementById('kontribusiJenis').value,
        nama_kontributor: document.getElementById('kontribusiNama').value,
        email_kontributor: document.getElementById('kontribusiEmail').value,
        data_usulan: { detail: document.getElementById('kontribusiDetail').value },
        catatan: document.getElementById('kontribusiDetail').value,
    };
    
    try {
        const res = await fetch(API_URL + '?action=kontribusi', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload),
        });
        const data = await res.json();
        
        if (data.success) {
            status.innerHTML = '<span class="text-success">✅ Usulan berhasil dikirim! Admin akan meninjau.</span>';
            document.getElementById('kontribusiForm').reset();
        } else {
            status.innerHTML = '<span class="text-danger">❌ ' + (data.error || 'Gagal mengirim') + '</span>';
        }
    } catch(err) {
        status.innerHTML = '<span class="text-danger">❌ Error: ' + err.message + '</span>';
    }
});

// Init
loadPartuturanDropdowns();
</script>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
