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

<?php require_once __DIR__ . '/includes/footer.php'; ?>
<script>
document.addEventListener('DOMContentLoaded', async function () {
    try {
        const response = await fetch('<?= API_BASE_URL ?>/punguan');
        const result = await response.json();
        if (!result.success) { document.getElementById('punguanList').innerHTML = '<p class="text-danger">Gagal memuat</p>'; return; }
        const items = result.data || [];
        if (!items.length) { document.getElementById('punguanList').innerHTML = '<p class="text-muted">Belum ada punguan</p>'; return; }
        document.getElementById('punguanList').innerHTML = '<div class="row">' + items.map(p => `
            <div class="col-md-6 mb-3"><div class="card" style="border-left:4px solid #0d6efd;">
                <div class="card-body">
                    <h5 class="card-title">${p.nama}</h5>
                    <p class="mb-1"><span class="badge bg-secondary">${p.marga?.nama || '-'}</span></p>
                    <p class="mb-1">📍 ${p.alamat || '-'}, ${p.kota || '-'}</p>
                    <p class="mb-1">👤 Ketua: ${p.ketua?.nama || '-'}</p>
                    <p class="mb-0"><small class="text-muted">${p.deskripsi || ''}</small></p>
                </div>
            </div></div>
        `).join('') + '</div>';
    } catch (e) { document.getElementById('punguanList').innerHTML = '<p class="text-danger">Error memuat data</p>'; }
});
</script>
