<?php
$pageTitle = 'Peta Keluarga';
$activePage = 'map';
$extraCss = 'leaflet.css';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <h2>🗺️ Peta Keluarga</h2>
    <p class="text-muted">Visualisasi persebaran geografis anggota keluarga Batak</p>
    <div class="row mb-3">
        <div class="col-md-3">
            <select class="form-select" id="filterMapMarga"><option value="">Semua Marga</option></select>
        </div>
        <div class="col-md-3">
            <select class="form-select" id="filterMapSubSuku"><option value="">Semua Sub-Suku</option></select>
        </div>
        <div class="col-md-6">
            <div id="geoStats" class="d-flex gap-2"></div>
        </div>
    </div>
    <div id="familyMap" style="height:70vh; border-radius:8px;"></div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/leaflet.js,' . TAROMBO_BASE_URL . '/js/map.js';
require_once __DIR__ . '/includes/footer.php';
?>
