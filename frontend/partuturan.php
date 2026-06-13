<?php
$pageTitle = 'Partuturan & Hubungan Kekerabatan';
$activePage = 'partuturan';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <h1>🔮 Partuturan & Hubungan Kekerabatan</h1>
    <p class="lead">Hitung hubungan kekerabatan, cari Tulang, Namboru, Bere, dan Pariban sesuai adat Batak</p>

    <ul class="nav nav-tabs mt-3" id="partuturanTabs">
        <li class="nav-item"><a class="nav-link active" href="#" data-tab="calculator">Kalkulator</a></li>
        <li class="nav-item"><a class="nav-link" href="#" data-tab="relations">Tulang & Namboru</a></li>
        <li class="nav-item"><a class="nav-link" href="#" data-tab="bere">Bere</a></li>
        <li class="nav-item"><a class="nav-link" href="#" data-tab="pariban">Pariban</a></li>
    </ul>

    <div class="tab-content mt-3" id="tab-calculator">
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header"><h5 class="mb-0">Pilih Dua Anggota</h5></div>
                    <div class="card-body">
                        <div class="mb-3"><label class="form-label">Anggota Pertama</label><select class="form-select" id="person1Select"><option value="">Pilih Anggota</option></select></div>
                        <div class="mb-3"><label class="form-label">Anggota Kedua</label><select class="form-select" id="person2Select"><option value="">Pilih Anggota</option></select></div>
                        <button class="btn btn-primary" id="calculateBtn">Hitung Partuturan</button>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header"><h5 class="mb-0">Hasil Partuturan</h5></div>
                    <div class="card-body" id="partuturanResult"><p class="text-muted">Pilih dua anggota untuk menghitung partuturan</p></div>
                </div>
            </div>
        </div>
    </div>

    <div class="tab-content mt-3" id="tab-relations" style="display:none;">
        <div class="row">
            <div class="col-md-4"><div class="card"><div class="card-header"><h5 class="mb-0">Pilih Anggota</h5></div><div class="card-body"><select class="form-select" id="relationPersonSelect"><option value="">Pilih Anggota</option></select></div></div></div>
            <div class="col-md-4"><div class="card"><div class="card-header"><h5 class="mb-0">Tulang (Saudara Laki Ibu)</h5></div><div class="card-body" id="tulangResult"><p class="text-muted">Pilih anggota untuk melihat Tulang</p></div></div></div>
            <div class="col-md-4"><div class="card"><div class="card-header"><h5 class="mb-0">Namboru (Saudara Perempuan Ayah)</h5></div><div class="card-body" id="namboruResult"><p class="text-muted">Pilih anggota untuk melihat Namboru</p></div></div></div>
        </div>
    </div>

    <div class="tab-content mt-3" id="tab-bere" style="display:none;">
        <div class="row">
            <div class="col-md-4"><div class="card"><div class="card-header"><h5 class="mb-0">Pilih Anggota</h5></div><div class="card-body"><select class="form-select" id="berePersonSelect"><option value="">Pilih Anggota</option></select></div></div></div>
            <div class="col-md-8"><div class="card"><div class="card-header"><h5 class="mb-0">Bere (Anak dari Saudara Perempuan)</h5></div><div class="card-body" id="bereResult"><p class="text-muted">Pilih anggota untuk melihat Bere</p></div></div></div>
        </div>
    </div>

    <div class="tab-content mt-3" id="tab-pariban" style="display:none;">
        <div class="row">
            <div class="col-md-4"><div class="card"><div class="card-header"><h5 class="mb-0">Pilih Anggota</h5></div><div class="card-body"><select class="form-select" id="paribanPersonSelect"><option value="">Pilih Anggota</option></select></div></div></div>
            <div class="col-md-8"><div class="card"><div class="card-header"><h5 class="mb-0">Pariban (Pasangan Ideal Menurut Adat)</h5></div><div class="card-body" id="paribanResult"><p class="text-muted">Pilih anggota untuk melihat calon Pariban</p></div></div></div>
        </div>
    </div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/partuturan.js';
require_once __DIR__ . '/includes/footer.php';
?>
