<?php
$pageTitle = 'Daftar Dongan Tubu';
$activePage = 'persons';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <div class="row">
        <div class="col-12">
            <h1>Daftar Dongan Tubu (Anggota Keluarga)</h1>
            <div class="row g-2 mb-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" id="searchInput" placeholder="Cari nama anggota...">
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="filterMarga"><option value="">Semua Marga</option></select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="filterSubSuku"><option value="">Semua Sub-Suku</option></select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" id="filterGender">
                        <option value="">Semua Gender</option>
                        <option value="L">Laki-laki</option>
                        <option value="P">Perempuan</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button class="btn btn-outline-secondary w-100" id="resetFilterBtn">Reset</button>
                </div>
            </div>
            <button class="btn btn-primary mb-3 auth-required" data-bs-toggle="modal" data-bs-target="#addPersonModal">+ Tambah Anggota</button>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead><tr><th>ID</th><th>Nama</th><th>Marga</th><th>Jenis Kelamin</th><th>Tanggal Lahir</th><th>Tempat Lahir</th><th>Tindakan</th></tr></thead>
                    <tbody id="personsTable"><tr><td colspan="7" class="text-center">Memuat data...</td></tr></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addPersonModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Tambah Anggota</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body">
                <form id="addPersonForm">
                    <div class="mb-3"><label class="form-label">Nama</label><input type="text" class="form-control" name="nama" required></div>
                    <div class="mb-3"><label class="form-label">Marga</label><select class="form-select" name="marga_id" id="margaSelect" required></select></div>
                    <div class="mb-3"><label class="form-label">Jenis Kelamin</label><select class="form-select" name="jenis_kelamin" required><option value="L">Laki-laki</option><option value="P">Perempuan</option></select></div>
                    <div class="mb-3"><label class="form-label">Tanggal Lahir</label><input type="date" class="form-control" name="tanggal_lahir"></div>
                    <div class="mb-3"><label class="form-label">Tempat Lahir (Huta Asal)</label><input type="text" class="form-control" name="tempat_lahir"></div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" id="savePersonBtn">Simpan</button>
            </div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/persons.js';
require_once __DIR__ . '/includes/footer.php';
?>
