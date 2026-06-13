<?php
$pageTitle = 'Beranda';
$activePage = 'index';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
require_once __DIR__ . '/includes/content.php';
?>

<div class="container mt-5">
    <?= renderPageHeader(
        'Horas! Selamat Datang di Tarombo Digital',
        'Sistem silsilah dan kekerabatan adat Batak — Menjaga warisan leluhur untuk generasi mendatang'
    ) ?>

    <div class="row mt-4">
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">🌳 Pohon Tarombo</h5>
                    <p class="card-text">Lihat silsilah keluarga lengkap dengan visualisasi pohon kekerabatan.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/family-tree" class="btn btn-primary">Lihat Pohon</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">👥 Dongan Tubu</h5>
                    <p class="card-text">Daftar anggota keluarga dengan filter marga, sub-suku, dan gender.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/persons" class="btn btn-success">Lihat Anggota</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">🔮 Partuturan</h5>
                    <p class="card-text">Hitung hubungan kekerabatan: Tulang, Namboru, Bere, Pariban.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/partuturan" class="btn btn-info">Hitung Partuturan</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">💒 Perkawinan</h5>
                    <p class="card-text">Pencatatan 7 tahapan perkawinan adat Batak dari Mangarisika sampai Paulak Une.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/marriages" class="btn btn-warning">Lihat Perkawinan</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">🗺️ Peta Keluarga</h5>
                    <p class="card-text">Visualisasi persebaran geografis anggota keluarga di seluruh Indonesia.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/map" class="btn btn-secondary">Buka Peta</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100">
                <div class="card-body text-center">
                    <h5 class="card-title">🤖 AI Assistant</h5>
                    <p class="card-text">Tanyakan apapun tentang adat Batak, partuturan, dan kekerabatan.</p>
                    <a href="<?= TAROMBO_BASE_URL ?>/assistant" class="btn btn-dark">Tanya AI</a>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
