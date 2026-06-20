<?php
require_once __DIR__ . '/config.php';
if (!isset($activePage)) $activePage = '';
function navActive($page) {
    global $activePage;
    return $activePage === $page ? 'active' : '';
}
$currentUser = getCurrentUser();
$userRole = $currentUser['role'] ?? 'guest';
$isLoggedIn = $currentUser !== null;
?>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="<?= TAROMBO_BASE_URL ?>/">🌳 Tarombo Digital</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                                
                <!-- ===== MENU: DATA SILSILAH (auth-required) ===== -->
                <li class="nav-item auth-required" style="display:none;"><a class="nav-link <?= navActive('persons') ?>" href="<?= TAROMBO_BASE_URL ?>/persons">Dongan Tubu</a></li>
                <li class="nav-item auth-required" style="display:none;"><a class="nav-link <?= navActive('family-tree') ?>" href="<?= TAROMBO_BASE_URL ?>/family-tree">Pohon Tarombo</a></li>
                <li class="nav-item auth-required" style="display:none;"><a class="nav-link <?= navActive('partuturan') ?>" href="<?= TAROMBO_BASE_URL ?>/partuturan">Partuturan</a></li>
                <li class="nav-item auth-required" style="display:none;"><a class="nav-link <?= navActive('ceremonies') ?>" href="<?= TAROMBO_BASE_URL ?>/ceremonies">Acara Adat</a></li>
                <li class="nav-item auth-required" style="display:none;"><a class="nav-link <?= navActive('marriages') ?>" href="<?= TAROMBO_BASE_URL ?>/marriages">Perkawinan</a></li>
                
                <li class="nav-item"><a class="nav-link <?= navActive('dashboard') ?><?= navActive('index') ?>" href="<?= TAROMBO_BASE_URL ?>/dashboard">📊 Dashboard</a></li>

                <!-- ===== DROPDOWN: KELUARGA & BUDAYA (semua user) ===== -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Keluarga & Budaya 📖</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/silsilah">📜 Silsilah Batak</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/map">🗺️ Peta Keluarga</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/makam">🪦 Makam</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/oral-traditions">🎤 Tradisi Lisan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/traditional-knowledge">🌱 Pengetahuan Tradisional</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/cultural-sites">🏛️ Situs Budaya</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/assistant">🤖 AI Assistant</a></li>
                        <li class="auth-required" style="display:none;"><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/history-tracking">📊 History Tracking</a></li>
                    </ul>
                </li>

                <!-- ===== DROPDOWN: PUNGUAN (auth-required) ===== -->
                <li class="nav-item dropdown auth-required" style="display:none;">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Punguan</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/punguan">🏛️ Profil Punguan</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/documents">📁 Dokumen</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/notifications">🔔 Notifikasi</a></li>
                        <li><hr class="dropdown-divider punguan-admin-only"></li>
                        <li class="punguan-admin-only"><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/assets">🏛️ Harta Warisan</a></li>
                        <li class="punguan-admin-only"><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/finance">💰 Keuangan Punguan</a></li>
                        <li class="punguan-admin-only"><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/tanah-ulayat">🗺️ Tanah Ulayat</a></li>
                        <li class="punguan-admin-only"><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/events">📅 Acara & Kalender</a></li>
                    </ul>
                </li>

                <!-- ===== DROPDOWN: ADMIN (admin-only) ===== -->
                <li class="nav-item dropdown admin-only" style="display:none;">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Sistem</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/admin">📊 Admin Panel</a></li>
                        <li><a class="dropdown-item" href="<?= TAROMBO_BASE_URL ?>/backup">💾 Backup & Restore</a></li>
                    </ul>
                </li>

                <!-- ===== AUTH NAV (diisi oleh auth-nav.js) ===== -->
                <li class="nav-item" id="authNavItem">
                    <?php if ($currentUser): ?>
                        <a class="nav-link" href="<?= TAROMBO_BASE_URL ?>/logout">🔓 Logout (<?= e($currentUser['name'] ?? 'User') ?>)</a>
                    <?php else: ?>
                        <a class="nav-link" href="<?= TAROMBO_BASE_URL ?>/login">🔑 Masuk</a>
                    <?php endif; ?>
                </li>
            </ul>
        </div>
    </div>
</nav>
