<?php
$pageTitle = 'Data Makam';
$activePage = 'makam';
$extraCss = 'leaflet.css';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <h2>🪦 Data Makam Leluhur</h2>
    <p class="text-muted">Dokumentasi makam dan jalur ziarah</p>
    <div id="makamMap" style="height:400px; border-radius:8px;" class="mb-4"></div>
    <div id="makamList"><p class="text-muted">Memuat...</p></div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/leaflet.js,' . TAROMBO_BASE_URL . '/js/makam.js';
require_once __DIR__ . '/includes/footer.php';
?>
