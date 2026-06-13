<?php
require_once __DIR__ . '/config.php';
if (!isset($activePage)) $activePage = '';
function navActive($page) {
    global $activePage;
    return $activePage === $page ? 'active' : '';
}
?><nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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
                        <?php if (hasRole(['admin', 'tetua'])): ?>
                        <li><a class="dropdown-item" href="admin.html">📊 Admin</a></li>
                        <?php endif; ?>
                        <li><a class="dropdown-item" href="assistant.html">🤖 AI Assistant</a></li>
                    </ul>
                </li>
                <li class="nav-item" id="authNavItem"><a class="nav-link" href="login.html">🔑 Login</a></li>
            </ul>
        </div>
    </div>
</nav>
