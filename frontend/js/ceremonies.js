// Ceremonies Page JavaScript
document.addEventListener('DOMContentLoaded', function () {
    loadCeremonies();

    document.getElementById('filterCeremonyType').addEventListener('change', loadCeremonies);
    document.getElementById('filterCeremonyStatus').addEventListener('change', loadCeremonies);
    document.getElementById('saveCeremonyBtn').addEventListener('click', saveCeremony);
});

async function loadCeremonies() {
    const type = document.getElementById('filterCeremonyType').value;
    const status = document.getElementById('filterCeremonyStatus').value;
    const errorDiv = document.getElementById('ceremonyError');
    errorDiv.style.display = 'none';

    try {
        const params = new URLSearchParams();
        if (type) params.set('type', type);
        if (status) params.set('status', status);

        const response = await fetch(`${API_BASE_URL}/ceremonies?${params.toString()}`, {
            headers: getAuthHeaders()
        });
        const result = await response.json();

        if (!result.success) {
            document.getElementById('ceremoniesList').innerHTML = '<p class="text-danger">Gagal memuat data</p>';
            return;
        }

        const items = result.data || [];
        if (!items.length) {
            document.getElementById('ceremoniesList').innerHTML = '<p class="text-muted">Belum ada acara adat</p>';
            return;
        }

        const statusColors = {
            'PLANNED': 'primary',
            'ONGOING': 'warning',
            'COMPLETED': 'success',
            'CANCELLED': 'secondary'
        };

        const statusLabels = {
            'PLANNED': 'Direncanakan',
            'ONGOING': 'Berlangsung',
            'COMPLETED': 'Selesai',
            'CANCELLED': 'Dibatalkan'
        };

        document.getElementById('ceremoniesList').innerHTML = '<div class="row">' + items.map(c => `
            <div class="col-md-6 mb-3">
                <div class="card ceremony-${c.status.toLowerCase()}">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <h5 class="card-title">${c.nama}</h5>
                            <span class="badge bg-${statusColors[c.status] || 'secondary'}">${statusLabels[c.status] || c.status}</span>
                        </div>
                        <p class="mb-1"><small class="text-muted">Jenis: ${c.ceremony_type}</small></p>
                        <p class="mb-1">📅 ${c.tanggal ? new Date(c.tanggal).toLocaleDateString('id-ID') : '-'}</p>
                        <p class="mb-1">📍 ${c.lokasi || '-'}</p>
                        <p class="mb-0"><small class="text-muted">${c.catatan || ''}</small></p>
                    </div>
                </div>
            </div>
        `).join('') + '</div>';
    } catch (error) {
        console.error('Error loading ceremonies:', error);
        document.getElementById('ceremoniesList').innerHTML = '<p class="text-danger">Error memuat data</p>';
    }
}

async function saveCeremony() {
    const errorDiv = document.getElementById('ceremonyError');
    errorDiv.style.display = 'none';

    const ceremonyData = {
        ceremony_type: document.getElementById('ceremonyType').value,
        nama: document.getElementById('ceremonyName').value,
        tanggal: document.getElementById('ceremonyDate').value,
        lokasi: document.getElementById('ceremonyLocation').value,
        catatan: document.getElementById('ceremonyNotes').value
    };

    // Basic validation
    if (!ceremonyData.nama) {
        errorDiv.textContent = 'Nama acara wajib diisi';
        errorDiv.style.display = 'block';
        return;
    }

    try {
        const response = await fetch(`${API_BASE_URL}/ceremonies`, {
            method: 'POST',
            headers: getAuthHeaders(),
            body: JSON.stringify(ceremonyData)
        });

        const result = await response.json();

        if (result.success) {
            Toast.success('Acara adat berhasil ditambahkan!');
            const modal = bootstrap.Modal.getInstance(document.getElementById('addCeremonyModal'));
            modal.hide();
            document.getElementById('addCeremonyForm').reset();
            loadCeremonies();
        } else {
            errorDiv.textContent = result.error?.message || 'Gagal menambahkan acara';
            errorDiv.style.display = 'block';
        }
    } catch (error) {
        console.error('Error saving ceremony:', error);
        errorDiv.textContent = 'Gagal terhubung ke server';
        errorDiv.style.display = 'block';
    }
}
