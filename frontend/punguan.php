<?php
$pageTitle = 'Punguan & Organisasi';
$activePage = 'punguan';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <h2>🏛️ Punguan & Organisasi Marga</h2>
    <p class="text-muted">Organisasi marga Batak — Pengurus, Anggota, dan Iuran</p>
    <div id="punguanList"><p class="text-muted">Memuat...</p></div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/punguan.js';
require_once __DIR__ . '/includes/footer.php';
?>
