<?php
$pageTitle = 'Perkawinan Adat';
$activePage = 'marriages';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2>💒 Perkawinan Adat</h2>
            <p class="text-muted mb-0">Pencatatan perkawinan menurut adat Batak — 7 tahapan: Mangarisika sampai Paulak Une</p>
        </div>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addMarriageModal">+ Tambah Perkawinan</button>
    </div>
    <div class="row mb-3">
        <div class="col-md-3"><select class="form-select" id="filterStatus"><option value="">Semua Status</option><option value="active">Aktif</option><option value="divorced">Cerai</option></select></div>
        <div class="col-md-4"><input type="text" class="form-control" id="searchMarriage" placeholder="Cari perkawinan..."></div>
    </div>
    <div id="marriagesList"><p class="text-muted">Memuat...</p></div>
</div>

<div class="modal fade" id="addMarriageModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Tambah Perkawinan</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addMarriageForm">
                    <div class="mb-3"><label class="form-label">Suami (Laki-laki)</label><select class="form-select" id="husbandSelect" required></select></div>
                    <div class="mb-3"><label class="form-label">Istri (Perempuan)</label><select class="form-select" id="wifeSelect" required></select></div>
                    <div class="mb-3"><label class="form-label">Tanggal Perkawinan</label><input type="date" class="form-control" id="marriageDate"></div>
                    <div class="mb-3"><label class="form-label">Lokasi</label><input type="text" class="form-control" id="marriageLocation" placeholder="Contoh: Medan"></div>
                    <div class="alert alert-danger" id="marriageError" style="display:none;"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" id="saveMarriageBtn">Simpan</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="marriageDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Detail Perkawinan</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body" id="marriageDetailBody"></div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/marriages.js';
require_once __DIR__ . '/includes/footer.php';
?>
