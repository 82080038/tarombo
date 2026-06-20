const AssetsAPI = {
    assets: {
        getAll: (params) => fetch(`${API_BASE_URL}/assets?${new URLSearchParams(params)}`, { headers: getAuthHeaders() }).then(r => r.json()),
        getById: (id) => fetch(`${API_BASE_URL}/assets/${id}`, { headers: getAuthHeaders() }).then(r => r.json()),
        create: (data) => fetch(`${API_BASE_URL}/assets`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getAuthToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        update: (id, data) => fetch(`${API_BASE_URL}/assets/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getAuthToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        delete: (id) => fetch(`${API_BASE_URL}/assets/${id}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json()),
        transfer: (id, data) => fetch(`${API_BASE_URL}/assets/${id}/transfer`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getAuthToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        getInheritanceHistory: (id) => fetch(`${API_BASE_URL}/assets/${id}/inheritance`, { headers: getAuthHeaders() }).then(r => r.json())
    },
    persons: {
        getAll: () => fetch(`${API_BASE_URL}/persons`, { headers: getAuthHeaders() }).then(r => r.json())
    },
    marga: {
        getAll: () => fetch(`${API_BASE_URL}/marga`).then(r => r.json())
    }
};

let currentAssets = [];

document.addEventListener('DOMContentLoaded', () => {
    loadAssets();
    loadMarga();
    loadPersons();
    setupEventListeners();
});

function loadAssets() {
    document.getElementById('loadingState').classList.remove('hidden');
    document.getElementById('assetsList').innerHTML = '';

    const params = {
        tipe: document.getElementById('filterTipe').value,
        marga_id: document.getElementById('filterMarga').value,
        status: document.getElementById('filterStatus').value
    };

    AssetsAPI.assets.getAll(params)
        .then(response => {
            if (response.success) {
                currentAssets = response.data;
                renderAssets(response.data);
            } else {
                Toast.error('Gagal memuat aset');
            }
        })
        .catch(error => {
            console.error('Error loading assets:', error);
            Toast.error('Terjadi kesalahan saat memuat aset');
        })
        .finally(() => {
            document.getElementById('loadingState').classList.add('hidden');
        });
}

function renderAssets(assets) {
    const container = document.getElementById('assetsList');

    if (assets.length === 0) {
        container.innerHTML = `
            <div class="col-span-full text-center py-8 text-gray-500">
                <p class="text-lg">Tidak ada aset ditemukan</p>
            </div>
        `;
        return;
    }

    container.innerHTML = assets.map(asset => `
        <div class="bg-white rounded-lg shadow hover:shadow-md transition-shadow p-4">
            <div class="flex justify-between items-start mb-2">
                <span class="px-2 py-1 text-xs rounded-full ${getTipeColor(asset.tipe)}">${formatTipe(asset.tipe)}</span>
                <span class="px-2 py-1 text-xs rounded-full ${getStatusColor(asset.status)}">${formatStatus(asset.status)}</span>
            </div>
            <h3 class="font-bold text-lg mb-2">${asset.nama}</h3>
            <p class="text-gray-600 text-sm mb-2">${asset.deskripsi || 'Tidak ada deskripsi'}</p>
            <div class="text-sm text-gray-500 mb-2">
                <p>Nilai: ${formatCurrency(asset.nilai_estimasi)}</p>
                <p>Lokasi: ${asset.lokasi || '-'}</p>
                <p>Pemilik: ${asset.pemilik ? asset.pemilik.nama : 'Tidak ada'}</p>
            </div>
            <div class="flex space-x-2 mt-3">
                <button onclick="viewAsset(${asset.id})" class="text-blue-600 hover:text-blue-800 text-sm">Detail</button>
                <button onclick="editAsset(${asset.id})" class="text-green-600 hover:text-green-800 text-sm auth-required">Edit</button>
                <button onclick="transferAsset(${asset.id})" class="text-purple-600 hover:text-purple-800 text-sm auth-required">Transfer</button>
                <button onclick="deleteAsset(${asset.id})" class="text-red-600 hover:text-red-800 text-sm auth-required">Hapus</button>
            </div>
        </div>
    `).join('');

    applyRBAC();
}

function loadMarga() {
    AssetsAPI.marga.getAll()
        .then(response => {
            if (response.success) {
                const margaSelect = document.getElementById('filterMarga');
                const assetMargaSelect = document.getElementById('assetMarga');

                const options = response.data.map(m => `<option value="${m.id}">${m.nama}</option>`).join('');
                margaSelect.innerHTML = '<option value="">Semua Marga</option>' + options;
                assetMargaSelect.innerHTML = '<option value="">Tidak ada marga</option>' + options;
            }
        });
}

function loadPersons() {
    AssetsAPI.persons.getAll()
        .then(response => {
            if (response.success) {
                const pemilikSelect = document.getElementById('assetPemilik');
                const transferPemilikSelect = document.getElementById('transferPemilikBaru');

                const options = response.data.map(p => `<option value="${p.id}">${p.nama}</option>`).join('');
                pemilikSelect.innerHTML = '<option value="">Tidak ada pemilik</option>' + options;
                transferPemilikSelect.innerHTML = options;
            }
        });
}

function setupEventListeners() {
    document.getElementById('addAssetBtn').addEventListener('click', () => openModal());
    document.getElementById('closeModal').addEventListener('click', closeModal);
    document.getElementById('cancelBtn').addEventListener('click', closeModal);
    document.getElementById('assetForm').addEventListener('submit', saveAsset);
    document.getElementById('applyFilters').addEventListener('click', loadAssets);

    document.getElementById('closeTransferModal').addEventListener('click', closeTransferModal);
    document.getElementById('cancelTransferBtn').addEventListener('click', closeTransferModal);
    document.getElementById('transferForm').addEventListener('submit', executeTransfer);
}

function openModal(asset = null) {
    const modal = document.getElementById('assetModal');
    const form = document.getElementById('assetForm');
    const title = document.getElementById('modalTitle');

    form.reset();
    document.getElementById('assetId').value = '';

    if (asset) {
        title.textContent = 'Edit Aset';
        document.getElementById('assetId').value = asset.id;
        document.getElementById('assetNama').value = asset.nama;
        document.getElementById('assetTipe').value = asset.tipe;
        document.getElementById('assetNilai').value = asset.nilai_estimasi || '';
        document.getElementById('assetTanggal').value = asset.tanggal_perolehan || '';
        document.getElementById('assetCara').value = asset.cara_perolehan || 'lainnya';
        document.getElementById('assetDeskripsi').value = asset.deskripsi || '';
        document.getElementById('assetLokasi').value = asset.lokasi || '';
        document.getElementById('assetStatus').value = asset.status;
        document.getElementById('assetPemilik').value = asset.pemilik_saat_ini_id || '';
        document.getElementById('assetMarga').value = asset.marga_id || '';
    } else {
        title.textContent = 'Tambah Aset';
    }

    modal.classList.remove('hidden');
}

function closeModal() {
    document.getElementById('assetModal').classList.add('hidden');
}

function saveAsset(e) {
    e.preventDefault();

    const id = document.getElementById('assetId').value;
    const data = {
        nama: document.getElementById('assetNama').value,
        tipe: document.getElementById('assetTipe').value,
        nilai_estimasi: document.getElementById('assetNilai').value || null,
        tanggal_perolehan: document.getElementById('assetTanggal').value || null,
        cara_perolehan: document.getElementById('assetCara').value,
        deskripsi: document.getElementById('assetDeskripsi').value,
        lokasi: document.getElementById('assetLokasi').value,
        status: document.getElementById('assetStatus').value,
        pemilik_saat_ini_id: document.getElementById('assetPemilik').value || null,
        marga_id: document.getElementById('assetMarga').value || null
    };

    const promise = id ? AssetsAPI.assets.update(id, data) : AssetsAPI.assets.create(data);

    promise.then(response => {
        if (response.success) {
            Toast.success(id ? 'Aset berhasil diperbarui' : 'Aset berhasil ditambahkan');
            closeModal();
            loadAssets();
        } else {
            Toast.error(response.error || 'Gagal menyimpan aset');
        }
    }).catch(error => {
        console.error('Error saving asset:', error);
        Toast.error('Terjadi kesalahan saat menyimpan aset');
    });
}

function viewAsset(id) {
    AssetsAPI.assets.getById(id)
        .then(response => {
            if (response.success) {
                const asset = response.data;
                alert(`
Detail Aset:
Nama: ${asset.nama}
Tipe: ${formatTipe(asset.tipe)}
Nilai: ${formatCurrency(asset.nilai_estimasi)}
Deskripsi: ${asset.deskripsi || '-'}
Lokasi: ${asset.lokasi || '-'}
Status: ${formatStatus(asset.status)}
Pemilik: ${asset.pemilik ? asset.pemilik.nama : 'Tidak ada'}
Marga: ${asset.marga ? asset.marga.nama : 'Tidak ada'}
                `);
            }
        });
}

function editAsset(id) {
    const asset = currentAssets.find(a => a.id === id);
    if (asset) {
        openModal(asset);
    }
}

function deleteAsset(id) {
    if (confirm('Apakah Anda yakin ingin menghapus aset ini?')) {
        AssetsAPI.assets.delete(id)
            .then(response => {
                if (response.success) {
                    Toast.success('Aset berhasil dihapus');
                    loadAssets();
                } else {
                    Toast.error(response.error || 'Gagal menghapus aset');
                }
            })
            .catch(error => {
                console.error('Error deleting asset:', error);
                Toast.error('Terjadi kesalahan saat menghapus aset');
            });
    }
}

function transferAsset(id) {
    const modal = document.getElementById('transferModal');
    document.getElementById('transferAssetId').value = id;
    document.getElementById('transferTanggal').value = new Date().toISOString().split('T')[0];
    modal.classList.remove('hidden');
}

function closeTransferModal() {
    document.getElementById('transferModal').classList.add('hidden');
    document.getElementById('transferForm').reset();
}

function executeTransfer(e) {
    e.preventDefault();

    const id = document.getElementById('transferAssetId').value;
    const data = {
        pemilik_baru_id: document.getElementById('transferPemilikBaru').value,
        tanggal_transfer: document.getElementById('transferTanggal').value,
        cara_transfer: document.getElementById('transferCara').value,
        alasan_transfer: document.getElementById('transferAlasan').value
    };

    AssetsAPI.assets.transfer(id, data)
        .then(response => {
            if (response.success) {
                Toast.success('Kepemilikan aset berhasil ditransfer');
                closeTransferModal();
                loadAssets();
            } else {
                Toast.error(response.error || 'Gagal transfer kepemilikan');
            }
        })
        .catch(error => {
            console.error('Error transferring asset:', error);
            Toast.error('Terjadi kesalahan saat transfer kepemilikan');
        });
}

function formatTipe(tipe) {
    const types = {
        'tanah': 'Tanah',
        'rumah': 'Rumah',
        'kendaraan': 'Kendaraan',
        'pusaka_adat': 'Pusaka Adat',
        'emas_perhiasan': 'Emas/Perhiasan',
        'tanaman': 'Tanaman',
        'ternak': 'Ternak',
        'lainnya': 'Lainnya'
    };
    return types[tipe] || tipe;
}

function formatStatus(status) {
    const statuses = {
        'aktif': 'Aktif',
        'terjual': 'Terjual',
        'hilang': 'Hilang',
        'rusak': 'Rusak',
        'disewakan': 'Disewakan'
    };
    return statuses[status] || status;
}

function getTipeColor(tipe) {
    const colors = {
        'tanah': 'bg-green-100 text-green-800',
        'rumah': 'bg-blue-100 text-blue-800',
        'kendaraan': 'bg-yellow-100 text-yellow-800',
        'pusaka_adat': 'bg-purple-100 text-purple-800',
        'emas_perhiasan': 'bg-yellow-100 text-yellow-800',
        'tanaman': 'bg-green-100 text-green-800',
        'ternak': 'bg-orange-100 text-orange-800',
        'lainnya': 'bg-gray-100 text-gray-800'
    };
    return colors[tipe] || 'bg-gray-100 text-gray-800';
}

function getStatusColor(status) {
    const colors = {
        'aktif': 'bg-green-100 text-green-800',
        'terjual': 'bg-red-100 text-red-800',
        'hilang': 'bg-red-100 text-red-800',
        'rusak': 'bg-orange-100 text-orange-800',
        'disewakan': 'bg-blue-100 text-blue-800'
    };
    return colors[status] || 'bg-gray-100 text-gray-800';
}

function formatCurrency(value) {
    if (!value) return '-';
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value);
}
