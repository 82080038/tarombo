<?php
$pageTitle = 'Pohon Tarombo';
$activePage = 'family-tree';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <h1>Pohon Tarombo</h1>
            <p class="lead">Visualisasi silsilah keluarga Batak dari Sundut ke Sundut</p>
        </div>
    </div>
    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card">
                <div class="card-header"><h5 class="mb-0">Pilih Akar Keluarga</h5></div>
                <div class="card-body">
                    <select class="form-select" id="rootPersonSelect"><option value="">Pilih Anggota</option></select>
                    <button class="btn btn-primary mt-3 w-100" id="generateTreeBtn">Generate Pohon</button>
                </div>
            </div>
        </div>
        <div class="col-md-8">
            <div class="card">
                <div class="card-header"><h5 class="mb-0">Visualisasi</h5></div>
                <div class="card-body" id="familyTreeContainer"><p class="text-muted">Pilih akar keluarga untuk melihat visualisasi</p></div>
            </div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/family-tree.js';
require_once __DIR__ . '/includes/footer.php';
?>
