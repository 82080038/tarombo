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
                <li class="nav-item"><a class="nav-link <?= navActive('index') ?>" href="<?= TAROMBO_BASE_URL ?>/">Beranda</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('persons') ?>" href="<?= TAROMBO_BASE_URL ?>/persons">Dongan Tubu</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('family-tree') ?>" href="<?= TAROMBO_BASE_URL ?>/family-tree">Pohon Tarombo</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('partuturan') ?>" href="<?= TAROMBO_BASE_URL ?>/partuturan">Partuturan</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('marriages') ?>" href="<?= TAROMBO_BASE_URL ?>/marriages">Perkawinan</a></li>
                <li class="nav-item"><a class="nav-link <?= navActive('ceremonies') ?>" href="<?= TAROMBO_BASE_URL ?>/ceremonies">Acara Adat</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Lainnya</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/punguan">🏛️ Punguan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/documents">📁 Dokumen</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/makam">🪦 Makam</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/map">🗺️ Peta Keluarga</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/assets">🏛️ Harta Warisan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/finance">💰 Keuangan Punguan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/tanah-ulayat">🗺️ Tanah Ulayat</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/events">📅 Acara & Kalender</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/oral-traditions">🎤 Tradisi Lisan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/traditional-knowledge">🌱 Pengetahuan Tradisional</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/cultural-sites">🏛️ Situs Budaya</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/history-tracking">📊 History Tracking</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/notifications">🔔 Notifikasi</a></li>
                        <?php if (hasRole(['admin', 'superadmin'])): ?>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/backup">💾 Backup & Restore</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/admin">📊 Admin</a></li>
                        <?php endif; ?>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/assistant">🤖 AI Assistant</a></li>
                    </ul>
                </li>
                <li class="nav-item" id="authNavItem">
                    <?php if ($currentUser): ?>
                        <a class="nav-link" href="<?= TAROMBO_BASE_URL ?>/logout">🔓 Logout (<?= e($currentUser['name'] ?? 'User') ?>)</a>
                    <?php else: ?>
                        <a class="nav-link" href="<?= TAROMBO_BASE_URL ?>/login">🔑 Login</a>
                    <?php endif; ?>
                </li>
            </ul>
        </div>
    </div>
</nav>
