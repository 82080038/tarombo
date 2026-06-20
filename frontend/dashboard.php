<?php
$pageTitle = 'Dashboard';
$activePage = 'dashboard';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
require_once __DIR__ . '/includes/content.php';

$currentUser = getCurrentUser();
$isLoggedIn = $currentUser !== null;
$userName = $currentUser['name'] ?? $currentUser['email'] ?? 'Pengguna';
$userRole = $currentUser['role'] ?? 'guest';

$roleLabels = [
    'admin' => 'Administrator Sistem',
    'punguan_admin' => 'Admin Punguan',
    'tetua' => 'Tetua Adat',
    'verified' => 'User Terverifikasi',
    'user' => 'User',
];
$roleLabel = $roleLabels[$userRole] ?? $userRole;
?>

<div class="container mt-4">

    <!-- ===== WELCOME HEADER ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="dashboard-welcome">
                <?php if ($isLoggedIn): ?>
                <h2>🌳 Selamat Datang, <?= e($userName) ?>!</h2>
                <p class="mb-0">
                    <span class="badge bg-light text-primary"><?= e($roleLabel) ?></span>
                    <span class="ms-2">Kelola dan jelajahi silsilah kekerabatan Batak Anda.</span>
                </p>
                <?php else: ?>
                <h2>🌳 Selamat Datang di Tarombo Digital</h2>
                <p class="mb-0">Sistem silsilah dan kekerabatan adat Batak &mdash; Menjaga warisan leluhur untuk generasi mendatang.</p>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- ===== BANNER: POHON SILSILAH BATAK (menonjol untuk guest) ===== -->
    <?php if (!$isLoggedIn): ?>
    <div class="row mb-4">
        <div class="col-12">
            <a href="<?= TAROMBO_BASE_URL ?>/silsilah" class="text-decoration-none">
                <div class="card border-0 shadow" style="background: linear-gradient(135deg, #1a5d1a, #2d8f2d); color: white;">
                    <div class="card-body d-flex align-items-center py-4 px-4">
                        <div class="me-4">
                            <span style="font-size: 3rem;">🌳</span>
                        </div>
                        <div class="flex-grow-1">
                            <h3 class="mb-1 fw-bold">Lihat Pohon Silsilah Batak Lengkap</h3>
                            <p class="mb-0 opacity-75">Dari Si Raja Batak hingga 123 marga modern &mdash; 26 tokoh, 5 kelompok induk, 9 generasi</p>
                        </div>
                        <div class="ms-3">
                            <span class="btn btn-light btn-lg fw-bold">Jelajahi &rarr;</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>
    <?php endif; ?>

    <!-- ===== QUICK STATS (hanya untuk yang sudah login) ===== -->
    <?php if ($isLoggedIn): ?>
    <div class="row mb-4" id="dashStats">
        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card stat-card text-center h-100">
                <div class="card-body">
                    <div class="stat-icon">👥</div>
                    <h3 id="dashStatPersons" class="mb-0">-</h3>
                    <p class="text-muted mb-0">Anggota Keluarga</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card stat-card text-center h-100">
                <div class="card-body">
                    <div class="stat-icon">🌳</div>
                    <h3 id="dashStatMarga" class="mb-0">-</h3>
                    <p class="text-muted mb-0">Marga Terdaftar</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card stat-card text-center h-100">
                <div class="card-body">
                    <div class="stat-icon">💍</div>
                    <h3 id="dashStatMarriages" class="mb-0">-</h3>
                    <p class="text-muted mb-0">Perkawinan Tercatat</p>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-sm-6 mb-3">
            <div class="card stat-card text-center h-100">
                <div class="card-body">
                    <div class="stat-icon">🏛️</div>
                    <h3 id="dashStatPunguan" class="mb-0">-</h3>
                    <p class="text-muted mb-0">Punguan Aktif</p>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

    <!-- ===== VALUE PROPOSITION (untuk guest) ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card border-0 bg-light">
                <div class="card-body text-center py-4">
                    <h4 class="mb-3">🌿 Mengapa Tarombo Digital?</h4>
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <div class="h1 text-primary">�</div>
                            <h6 class="fw-bold">Silsilah Lengkap</h6>
                            <p class="small text-muted">Dari Si Raja Batak hingga 123 marga modern, terverifikasi</p>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="h1 text-success">🌳</div>
                            <h6 class="fw-bold">Pohon Tarombo</h6>
                            <p class="small text-muted">Visualisasi silsilah dari generasi ke generasi</p>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="h1 text-warning">💍</div>
                            <h6 class="fw-bold">Adat Terjaga</h6>
                            <p class="small text-muted">Pencatatan perkawinan adat Batak 7 tahapan yang valid</p>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="h1 text-info">🔮</div>
                            <h6 class="fw-bold">Partuturan Otomatis</h6>
                            <p class="small text-muted">Hitung kekerabatan sesuai Dalihan Na Tolu</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== FITUR APLIKASI (untuk guest) ===== -->
    <div class="row mb-3">
        <div class="col-12">
            <h3 class="mb-3">🌟 Fitur Lengkap</h3>
            <p class="text-muted">Tarombo Digital adalah platform modern untuk melestarikan kekerabatan adat Batak:</p>
        </div>
    </div>

    <div class="row mb-4">
        <!-- Feature 0: Silsilah Mitologis Batak -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-primary text-white">📜</div>
                    <h5 class="card-title mt-3">Silsilah Batak</h5>
                    <p class="card-text">Pelajari silsilah lengkap dari Si Raja Batak hingga 123 marga modern. Dari mitologi penciptaan hingga 5 kelompok induk marga.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/silsilah" class="btn btn-sm btn-outline-primary">Lihat Silsilah →</a>
                </div>
            </div>
        </div>

        <!-- Feature 1: Partuturan Engine -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-primary text-white">🔮</div>
                    <h5 class="card-title mt-3">Partuturan Otomatis</h5>
                    <p class="card-text">Hitung hubungan kekerabatan Batak secara otomatis: Tulang, Namboru, Bere, Pariban, Hula-hula, Dongan Tubu &mdash; sesuai aturan <em>Dalihan Na Tolu</em>.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/partuturan" class="btn btn-sm btn-outline-primary">Coba →</a>
                </div>
            </div>
        </div>

        <!-- Feature 2: Visualisasi Pohon Tarombo -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-success text-white">🌳</div>
                    <h5 class="card-title mt-3">Pohon Tarombo</h5>
                    <p class="card-text">Lihat silsilah keluarga dalam visualisasi interaktif dari sundut ke sundut. Telusuri garis keturunan patrilineal dengan mudah.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/family-tree" class="btn btn-sm btn-outline-success">Lihat →</a>
                </div>
            </div>
        </div>

        <!-- Feature 3: Validasi Perkawinan Adat -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-warning text-white">💍</div>
                    <h5 class="card-title mt-3">Validasi Perkawinan</h5>
                    <p class="card-text">Pencatatan perkawinan adat Batak dari <em>Mangarisika</em> sampai <em>Paulak Une</em>, dengan validasi aturan exogami (tidak boleh sesama marga).</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/marriages" class="btn btn-sm btn-outline-warning">Lihat →</a>
                </div>
            </div>
        </div>

        <!-- Feature 4: AI Assistant -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-dark text-white">🤖</div>
                    <h5 class="card-title mt-3">AI Assistant</h5>
                    <p class="card-text">Tanyakan apapun tentang adat Batak, partuturan, Dalihan Na Tolu, ritual, dan tradisi. Didukung AI yang memahami konteks budaya.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/assistant" class="btn btn-sm btn-outline-dark">Tanya →</a>
                </div>
            </div>
        </div>

        <!-- Feature 5: Peta & Makam -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-secondary text-white">🗺️</div>
                    <h5 class="card-title mt-3">Peta Keluarga & Makam</h5>
                    <p class="card-text">Visualisasikan persebaran geografis anggota keluarga di seluruh Indonesia. Dokumentasikan lokasi makam leluhur dengan koordinat GPS.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/map" class="btn btn-sm btn-outline-secondary">Buka →</a>
                </div>
            </div>
        </div>

        <!-- Feature 6: Warisan Budaya -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-danger text-white">🎭</div>
                    <h5 class="card-title mt-3">Warisan Budaya</h5>
                    <p class="card-text">Catat tradisi lisan, pengetahuan tradisional, dan situs budaya. Jaga warisan leluhur untuk generasi mendatang.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/oral-traditions" class="btn btn-sm btn-outline-danger">Jelajahi →</a>
                </div>
            </div>
        </div>

        <!-- Feature 7: Manajemen Punguan -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-info text-white">🏛️</div>
                    <h5 class="card-title mt-3">Manajemen Punguan</h5>
                    <p class="card-text">Kelola profil punguan, harta warisan, keuangan, tanah ulayat, dan acara punguan dalam satu platform terintegrasi.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/punguan" class="btn btn-sm btn-outline-info">Kelola →</a>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== CARA KERJA (untuk guest) ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">🔄 Cara Kerja Tarombo Digital</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 text-center mb-3">
                            <div class="step-number">1</div>
                            <h6 class="fw-bold">Daftar & Login</h6>
                            <p class="small text-muted">Buat akun gratis dan verifikasi identitas Anda</p>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="step-number">2</div>
                            <h6 class="fw-bold">Input Data Keluarga</h6>
                            <p class="small text-muted">Masukkan data anggota keluarga dan hubungan kekerabatan</p>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="step-number">3</div>
                            <h6 class="fw-bold">Partuturan Otomatis</h6>
                            <p class="small text-muted">Sistem menghitung hubungan kekerabatan secara otomatis</p>
                        </div>
                        <div class="col-md-3 text-center mb-3">
                            <div class="step-number">4</div>
                            <h6 class="fw-bold">Kelola Punguan</h6>
                            <p class="small text-muted">Kelola acara, harta warisan, dan dokumentasi keluarga</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php if ($isLoggedIn): ?>
    <!-- ===== FEATURE SHOWCASE LENGKAP (untuk yang sudah login) ===== -->
    <div class="row mb-3">
        <div class="col-12">
            <h4 class="mb-3">📋 Semua Fitur</h4>
        </div>
    </div>
    <div class="row mb-4">
        <!-- Feature 5: Perkawinan -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-warning text-white">💍</div>
                    <h5 class="card-title mt-3">Validasi Perkawinan</h5>
                    <p class="card-text">Pencatatan 7 tahapan perkawinan adat Batak dengan validasi aturan exogami.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/marriages" class="btn btn-sm btn-outline-warning">Lihat →</a>
                </div>
            </div>
        </div>

        <!-- Feature 6: Peta & Makam -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-secondary text-white">🗺️</div>
                    <h5 class="card-title mt-3">Peta Keluarga & Makam</h5>
                    <p class="card-text">Visualisasikan persebaran geografis keluarga dan dokumentasikan lokasi makam.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/map" class="btn btn-sm btn-outline-secondary">Buka →</a>
                </div>
            </div>
        </div>

        <!-- Feature 7: Warisan Budaya -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-danger text-white">🎭</div>
                    <h5 class="card-title mt-3">Warisan Budaya</h5>
                    <p class="card-text">Catat tradisi lisan, pengetahuan tradisional, dan situs budaya.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/oral-traditions" class="btn btn-sm btn-outline-danger">Jelajahi →</a>
                </div>
            </div>
        </div>

        <!-- Feature 8: History Tracking -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-primary text-white">📊</div>
                    <h5 class="card-title mt-3">History Tracking</h5>
                    <p class="card-text">Lacak setiap perubahan data dengan audit log lengkap untuk transparansi.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/history-tracking" class="btn btn-sm btn-outline-primary">Lihat →</a>
                </div>
            </div>
        </div>

        <!-- Feature 9: Keamanan & Privasi -->
        <div class="col-md-6 col-lg-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body">
                    <div class="feature-icon bg-success text-white">🛡️</div>
                    <h5 class="card-title mt-3">Keamanan Berlapis</h5>
                    <p class="card-text">Enkripsi AES-256, RBAC, JWT, TLS 1.3, audit log, dan data masking.</p>
                    <span class="badge bg-success">Enterprise-Grade Security</span>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

    <?php if ($isLoggedIn): ?>
    <!-- ===== COMPARISON: Tarombo Digital vs Aplikasi Lain (hanya untuk yang sudah login) ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">⚖️ Perbandingan dengan Aplikasi Lain</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Fitur</th>
                                    <th class="text-center text-primary"><strong>Tarombo Digital</strong></th>
                                    <th class="text-center text-muted">Ancestry / MyHeritage</th>
                                    <th class="text-center text-muted">FamilySearch</th>
                                    <th class="text-center text-muted">tarombo.siboro.org</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Silsilah Batak (patrilineal)</td>
                                    <td class="text-center text-success">✅ Penuh</td>
                                    <td class="text-center text-muted">❌ Universal</td>
                                    <td class="text-center text-muted">❌ Universal</td>
                                    <td class="text-center text-warning">⚠️ Dasar</td>
                                </tr>
                                <tr>
                                    <td>Partuturan (Tulang, Bere, dll)</td>
                                    <td class="text-center text-success">✅ Otomatis</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>Validasi Perkawinan Adat (7 tahapan)</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>Dalihan Na Tolu / Rakut Sitelu</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>Manajemen Punguan</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>Harta Warisan & Tanah Ulayat</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>AI Assistant Budaya Batak</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>6 Sub-Suku Batak (Toba, Karo, dll)</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-muted">❌</td>
                                    <td class="text-center text-warning">⚠️ Toba only</td>
                                </tr>
                                <tr>
                                    <td>Enkripsi & RBAC</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-warning">⚠️</td>
                                    <td class="text-center text-muted">❌</td>
                                </tr>
                                <tr>
                                    <td>Gratis untuk Komunitas</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-danger">❌ Berbayar</td>
                                    <td class="text-center text-success">✅</td>
                                    <td class="text-center text-success">✅</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p class="text-muted small mt-2 mb-0">
                        <em>Tarombo Digital adalah satu-satunya platform genealogy yang memahami sistem kekerabatan Batak secara mendalam &mdash; dari Dalihan Na Tolu hingga perhitungan partuturan otomatis.</em>
                    </p>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

    <!-- ===== CALL TO ACTION: Untuk Punguan / Guest ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card bg-primary text-white">
                <div class="card-body text-center py-4">
                    <?php if ($isLoggedIn): ?>
                    <h4 class="mb-3">🏛️ Untuk Punguan / Keluarga Besar</h4>
                    <p class="mb-3">Tarombo Digital membantu punguan mengelola silsilah, keuangan, harta warisan, tanah ulayat, dan acara adat dalam satu sistem terintegrasi yang aman dan terdokumentasi.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/punguan" class="btn btn-light btn-lg">Kelola Punguan Anda →</a>
                    <?php else: ?>
                    <h4 class="mb-3">🌳 Mulai Perjalanan Anda</h4>
                    <p class="mb-3">Daftar sekarang untuk mengelola silsilah keluarga, menghitung partuturan, dan mengakses fitur lengkap Tarombo Digital.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/login" class="btn btn-light btn-lg me-2">🔑 Masuk</a>
                    <a href="<?= TAROMBO_BASE_URL ?>/register" class="btn btn-outline-light btn-lg">📝 Daftar</a>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== RECENT ACTIVITY (hanya untuk yang sudah login) ===== -->
    <?php if ($isLoggedIn): ?>
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">📋 Aktivitas Terbaru</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead>
                                <tr><th>Waktu</th><th>Aksi</th><th>Entitas</th><th>Oleh</th></tr>
                            </thead>
                            <tbody id="dashActivityTable">
                                <tr><td colspan="4" class="text-center text-muted">Memuat aktivitas...</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <?php endif; ?>

</div>

<?php
$extraJs = 'dashboard.js';
require_once __DIR__ . '/includes/footer.php';
?>
