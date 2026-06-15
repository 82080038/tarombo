<?php
$pageTitle = 'Acara Adat';
$activePage = 'ceremonies';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2>🎉 Acara Adat</h2>
            <p class="text-muted mb-0">Kelola upacara adat Batak — Perkawinan, Saur Matua, Kelahiran</p>
        </div>
        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCeremonyModal">+ Buat Acara</button>
    </div>
    <div class="row mb-3">
        <div class="col-md-3">
            <select class="form-select" id="filterCeremonyType">
                <option value="">Semua Jenis</option>
                <option value="MARRIAGE">Perkawinan</option>
                <option value="DEATH_SAUR_MATUA">Saur Matua (Kematian)</option>
                <option value="BIRTH">Kelahiran</option>
                <option value="OTHER">Lainnya</option>
            </select>
        </div>
        <div class="col-md-3">
            <select class="form-select" id="filterCeremonyStatus">
                <option value="">Semua Status</option>
                <option value="PLANNED">Direncanakan</option>
                <option value="ONGOING">Berlangsung</option>
                <option value="COMPLETED">Selesai</option>
                <option value="CANCELLED">Dibatalkan</option>
            </select>
        </div>
    </div>
    <div id="ceremoniesList"><p class="text-muted">Memuat...</p></div>
</div>

<div class="modal fade" id="addCeremonyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Buat Acara Adat</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addCeremonyForm">
                    <div class="mb-3"><label class="form-label">Jenis Acara</label><select class="form-select" id="ceremonyType" required><option value="MARRIAGE">Perkawinan</option><option value="DEATH_SAUR_MATUA">Saur Matua</option><option value="BIRTH">Kelahiran</option><option value="OTHER">Lainnya</option></select></div>
                    <div class="mb-3"><label class="form-label">Nama Acara</label><input type="text" class="form-control" id="ceremonyName" required placeholder="Contoh: Pernikahan Budi & Sari"></div>
                    <div class="mb-3"><label class="form-label">Tanggal</label><input type="date" class="form-control" id="ceremonyDate"></div>
                    <div class="mb-3"><label class="form-label">Lokasi</label><input type="text" class="form-control" id="ceremonyLocation" placeholder="Contoh: Jakarta"></div>
                    <div class="mb-3"><label class="form-label">Catatan</label><textarea class="form-control" id="ceremonyNotes" rows="2"></textarea></div>
                    <div class="alert alert-danger" id="ceremonyError" style="display:none;"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" id="saveCeremonyBtn">Simpan</button>
            </div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/ceremonies.js';
require_once __DIR__ . '/includes/footer.php';
?>
