<?php
$pageTitle = 'Detail Anggota';
$activePage = 'persons';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <a href="<?= TAROMBO_BASE_URL ?>/persons" class="btn btn-secondary mb-3">&larr; Kembali</a>
            <h1>Detail Anggota</h1>
        </div>
    </div>
    <div class="row" id="personDetail">
        <div class="col-12"><div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div></div>
    </div>
</div>

<div class="modal fade" id="editPersonModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Edit Anggota</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="editPersonForm">
                    <input type="hidden" id="editPersonId">
                    <div class="mb-3"><label class="form-label">Nama</label><input type="text" class="form-control" id="editNama" required></div>
                    <div class="mb-3"><label class="form-label">Marga</label><select class="form-select" id="editMargaId" required></select></div>
                    <div class="mb-3"><label class="form-label">Jenis Kelamin</label><select class="form-select" id="editJenisKelamin" required><option value="L">Laki-laki</option><option value="P">Perempuan</option></select></div>
                    <div class="mb-3"><label class="form-label">Tanggal Lahir</label><input type="date" class="form-control" id="editTanggalLahir"></div>
                    <div class="mb-3"><label class="form-label">Huta Asal (Tempat Lahir)</label><input type="text" class="form-control" id="editTempatLahir"></div>
                    <div class="mb-3"><label class="form-label">Tanggal Meninggal</label><input type="date" class="form-control" id="editTanggalMeninggal"></div>
                    <div class="mb-3"><label class="form-label">Amang (Ayah)</label><select class="form-select" id="editFatherId"><option value="">- Tidak ada -</option></select></div>
                    <div class="mb-3"><label class="form-label">Inang (Ibu)</label><select class="form-select" id="editMotherId"><option value="">- Tidak ada -</option></select></div>
                    <div class="alert alert-danger" id="editError" style="display:none;"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" id="saveEditBtn">Simpan Perubahan</button>
            </div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/person-detail.js';
require_once __DIR__ . '/includes/footer.php';
?>
