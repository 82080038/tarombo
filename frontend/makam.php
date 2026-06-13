<?php
$pageTitle = 'Data Makam';
$activePage = 'makam';
$extraCss = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
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
$extraJs = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
require_once __DIR__ . '/includes/footer.php';
?>
<script>
let map;
document.addEventListener('DOMContentLoaded', async function () {
    map = L.map('makamMap').setView([3.5952, 98.6721], 10);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '&copy; OpenStreetMap' }).addTo(map);
    try {
        const response = await fetch('<?= API_BASE_URL ?>/makam');
        const result = await response.json();
        if (!result.success) { document.getElementById('makamList').innerHTML = '<p class="text-danger">Gagal memuat</p>'; return; }
        const items = result.data || [];
        if (!items.length) { document.getElementById('makamList').innerHTML = '<p class="text-muted">Belum ada data makam</p>'; return; }
        items.forEach(m => { if (m.latitude && m.longitude) { L.marker([m.latitude, m.longitude]).addTo(map).bindPopup(`<b>${m.nama_makam}</b><br>${m.lokasi}`); } });
        document.getElementById('makamList').innerHTML = '<div class="row">' + items.map(m => `
            <div class="col-md-6 mb-3"><div class="card" style="border-left:4px solid #198754;">
                <div class="card-body">
                    <h5 class="card-title">${m.nama_makam}</h5>
                    <p class="mb-1">📍 ${m.lokasi || '-'}</p>
                    <p class="mb-1"><small>Lat: ${m.latitude || '-'}, Lng: ${m.longitude || '-'}</small></p>
                    <p class="mb-1"><small class="text-muted">${m.deskripsi || ''}</small></p>
                    ${m.jalur_ziarah ? `<p class="mb-0"><small>🗺️ Jalur: ${m.jalur_ziarah}</small></p>` : ''}
                </div>
            </div></div>
        `).join('') + '</div>';
    } catch (e) { document.getElementById('makamList').innerHTML = '<p class="text-danger">Error memuat data</p>'; }
});
</script>
