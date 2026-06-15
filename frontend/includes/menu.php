<?php
require_once __DIR__ . '/config.php';
if (!isset($activePage)) $activePage = '';
function navActive($page) {
    global $activePage;
    return $activePage === $page ? 'active' : '';
}
$currentUser = getCurrentUser();
$userRole = $currentUser['role'] ?? 'guest';
?>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="<?= TAROMBO_BASE_URL ?>/">🌳 Tarombo Digital</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link <?= navActive('index') ?>" href="index.html">Beranda</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('persons') ?>" href="persons.html">Dongan Tubu</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('family-tree') ?>" href="family-tree.html">Pohon Tarombo</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('partuturan') ?>" href="partuturan.html">Partuturan</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('marriages') ?>" href="marriages.html">Perkawinan</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('ceremonies') ?>" href="ceremonies.html">Acara Adat</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Lainnya</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="punguan.html">🏛️ Punguan</a></li>
                        <li><a class="dropdown-item" href="documents.html">📁 Dokumen</a></li>
                        <li><a class="dropdown-item" href="makam.html">🪦 Makam</a></li>
                        <li><a class="dropdown-item" href="map.html">🗺️ Peta Keluarga</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="assets.php">🏛️ Harta Warisan</a></li>
                        <li><a class="dropdown-item" href="finance.php">💰 Keuangan Punguan</a></li>
                        <li><a class="dropdown-item" href="tanah-ulayat.php">🗺️ Tanah Ulayat</a></li>
                        <li><a class="dropdown-item" href="events.php">📅 Acara & Kalender</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="oral-traditions.php">🎤 Tradisi Lisan</a></li>
                        <li><a class="dropdown-item" href="traditional-knowledge.php">🌱 Pengetahuan Tradisional</a></li>
                        <li><a class="dropdown-item" href="cultural-sites.php">🏛️ Situs Budaya</a></li>
                        <li><a class="dropdown-item" href="history-tracking.php">📊 History Tracking</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="notifications.php">🔔 Notifikasi</a></li>
                        <?php if (hasRole(['admin', 'superadmin'])): ?>
                        <li><a class="dropdown-item" href="backup.php">💾 Backup & Restore</a></li>
                        <li><a class="dropdown-item" href="admin.php">📊 Admin</a></li>
                        <?php endif; ?>
                        <li><a class="dropdown-item" href="assistant.html">🤖 AI Assistant</a></li>
                    </ul>
                </li>
                <li class="nav-item" id="authNavItem">
                    <?php if ($currentUser): ?>
                        <a class="nav-link" href="logout.php">🔓 Logout (<?= e($currentUser['name'] ?? 'User') ?>)</a>
                    <?php else: ?>
                        <a class="nav-link" href="login.html">🔑 Login</a>
                    <?php endif; ?>
                </li>
            </ul>
        </div>
    </div>
</nav>
