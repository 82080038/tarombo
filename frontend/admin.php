<?php
$pageTitle = 'Admin Dashboard';
$activePage = 'admin';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <h2>📊 Dashboard Admin</h2>
    <p class="text-muted">Statistik dan manajemen sistem Tarombo Digital</p>
    <div id="adminError" class="alert alert-danger" style="display: none;"></div>
    <div class="row mt-4" id="statsCards">
        <div class="col-md-3"><div class="card mb-3" style="border-left:4px solid #0d6efd;"><div class="card-body"><h6 class="text-muted">Total Anggota</h6><h3 id="statPersons">-</h3></div></div></div>
        <div class="col-md-3"><div class="card mb-3" style="border-left:4px solid #198754;"><div class="card-body"><h6 class="text-muted">Total Marga</h6><h3 id="statMarga">-</h3></div></div></div>
        <div class="col-md-3"><div class="card mb-3" style="border-left:4px solid #dc3545;"><div class="card-body"><h6 class="text-muted">Total Perkawinan</h6><h3 id="statMarriages">-</h3></div></div></div>
        <div class="col-md-3"><div class="card mb-3" style="border-left:4px solid #ffc107;"><div class="card-body"><h6 class="text-muted">Total User</h6><h3 id="statUsers">-</h3></div></div></div>
    </div>
    <div class="row mt-4">
        <div class="col-md-6"><div class="card"><div class="card-header"><h5 class="mb-0">Distribusi per Sub-Suku</h5></div><div class="card-body" id="subSukuChart"><p class="text-muted">Memuat...</p></div></div></div>
        <div class="col-md-6"><div class="card"><div class="card-header"><h5 class="mb-0">Distribusi Gender</h5></div><div class="card-body" id="genderChart"><p class="text-muted">Memuat...</p></div></div></div>
    </div>
    <div class="row mt-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header"><h5 class="mb-0">Aktivitas Terbaru</h5></div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead><tr><th>Waktu</th><th>Aksi</th><th>Entitas</th><th>ID</th><th>Oleh</th></tr></thead>
                            <tbody id="activityTable"><tr><td colspan="5" class="text-center text-muted">Memuat...</td></tr></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/admin.js';
require_once __DIR__ . '/includes/footer.php';
?>
