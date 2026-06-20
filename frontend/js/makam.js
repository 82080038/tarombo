// Makam Page JavaScript
let map;

document.addEventListener('DOMContentLoaded', async function () {
    map = L.map('makamMap').setView([3.5952, 98.6721], 10);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '&copy; OpenStreetMap' }).addTo(map);

    loadMakamData();
});

async function loadMakamData() {
    try {
        const response = await fetch(`${API_BASE_URL}/makam`, {
            headers: getAuthHeaders()
        });
        const result = await response.json();

        if (!result.success) {
            document.getElementById('makamList').innerHTML = '<p class="text-danger">Gagal memuat</p>';
            return;
        }

        const items = result.data || [];
        if (!items.length) {
            document.getElementById('makamList').innerHTML = '<p class="text-muted">Belum ada data makam</p>';
            return;
        }

        // Add markers to map
        items.forEach(m => {
            if (m.latitude && m.longitude) {
                L.marker([m.latitude, m.longitude])
                    .addTo(map)
                    .bindPopup(`<b>${m.nama_makam}</b><br>${m.lokasi}`);
            }
        });

        // Render list
        document.getElementById('makamList').innerHTML = '<div class="row">' + items.map(m => `
            <div class="col-md-6 mb-3">
                <div class="card" style="border-left:4px solid #198754;">
                    <div class="card-body">
                        <h5 class="card-title">${m.nama_makam}</h5>
                        <p class="mb-1">📍 ${m.lokasi || '-'}</p>
                        <p class="mb-1"><small>Lat: ${m.latitude || '-'}, Lng: ${m.longitude || '-'}</small></p>
                        <p class="mb-1"><small class="text-muted">${m.deskripsi || ''}</small></p>
                        ${m.jalur_ziarah ? `<p class="mb-0"><small>🗺️ Jalur: ${m.jalur_ziarah}</small></p>` : ''}
                    </div>
                </div>
            </div>
        `).join('') + '</div>';
    } catch (e) {
        console.error('Error loading makam data:', e);
        document.getElementById('makamList').innerHTML = '<p class="text-danger">Error memuat data</p>';
    }
}
