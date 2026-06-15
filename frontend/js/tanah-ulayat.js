const API = {
    tanah: {
        getAll: (params) => fetch(`${API_BASE_URL}/tanah-ulayat?${new URLSearchParams(params)}`).then(r => r.json()),
        getById: (id) => fetch(`${API_BASE_URL}/tanah-ulayat/${id}`).then(r => r.json()),
        create: (data) => fetch(`${API_BASE_URL}/tanah-ulayat`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        update: (id, data) => fetch(`${API_BASE_URL}/tanah-ulayat/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        delete: (id) => fetch(`${API_BASE_URL}/tanah-ulayat/${id}`, {
            method: 'DELETE',
            headers: { 'Authorization': `Bearer ${getToken()}` }
        }).then(r => r.json())
    },
    persons: {
        getAll: () => fetch(`${API_BASE_URL}/persons`).then(r => r.json())
    },
    marga: {
        getAll: () => fetch(`${API_BASE_URL}/marga`).then(r => r.json())
    }
};

let currentTanah = [];

document.addEventListener('DOMContentLoaded', () => {
    loadTanah();
    loadMarga();
    loadPersons();
    setupEventListeners();
});

function loadTanah() {
    document.getElementById('loadingState').classList.remove('hidden');
    document.getElementById('tanahList').innerHTML = '';
    
    const params = {
        marga_id: document.getElementById('filterMarga').value,
        status: document.getElementById('filterStatus').value
    };
    
    API.tanah.getAll(params)
        .then(response => {
            if (response.success) {
                currentTanah = response.data;
                renderTanah(response.data);
            } else {
                Toast.error('Gagal memuat tanah ulayat');
            }
        })
        .catch(error => {
            console.error('Error loading tanah:', error);
            Toast.error('Terjadi kesalahan saat memuat tanah ulayat');
        })
        .finally(() => {
            document.getElementById('loadingState').classList.add('hidden');
        });
}

function renderTanah(tanahList) {
    const container = document.getElementById('tanahList');
    
    if (tanahList.length === 0) {
        container.innerHTML = `
            <div class="col-span-full text-center py-8 text-gray-500">
                <p class="text-lg">Tidak ada tanah ulayat ditemukan</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = tanahList.map(tanah => `
        <div class="bg-white rounded-lg shadow hover:shadow-md transition-shadow p-4">
            <div class="flex justify-between items-start mb-2">
                <span class="px-2 py-1 text-xs rounded-full ${getStatusColor(tanah.status)}">${formatStatus(tanah.status)}</span>
                ${tanah.marga ? `<span class="px-2 py-1 text-xs rounded-full bg-purple-100 text-purple-800">${tanah.marga.nama}</span>` : ''}
            </div>
            <h3 class="font-bold text-lg mb-2">${tanah.nama}</h3>
            <p class="text-gray-600 text-sm mb-2">${tanah.deskripsi || 'Tidak ada deskripsi'}</p>
            <div class="text-sm text-gray-500 mb-2">
                <p>Luas: ${tanah.luas_hektar ? tanah.luas_hektar + ' Ha' : '-'}</p>
                <p>Lokasi: ${tanah.lokasi || '-'}</p>
                <p>Pengelola: ${tanah.pengelola ? tanah.pengelola.nama : 'Tidak ada'}</p>
            </div>
            ${tanah.latitude && tanah.longitude ? `
                <div class="mt-2 p-2 bg-gray-100 rounded text-xs">
                    <p>📍 ${tanah.latitude}, ${tanah.longitude}</p>
                </div>
            ` : ''}
            <div class="flex space-x-2 mt-3">
                <button onclick="viewTanah(${tanah.id})" class="text-blue-600 hover:text-blue-800 text-sm">Detail</button>
                <button onclick="editTanah(${tanah.id})" class="text-green-600 hover:text-green-800 text-sm auth-required">Edit</button>
                <button onclick="deleteTanah(${tanah.id})" class="text-red-600 hover:text-red-800 text-sm auth-required">Hapus</button>
            </div>
        </div>
    `).join('');
    
    applyRBAC();
}

function loadMarga() {
    API.marga.getAll()
        .then(response => {
            if (response.success) {
                const filterMargaSelect = document.getElementById('filterMarga');
                const tanahMargaSelect = document.getElementById('tanahMarga');
                
                const options = response.data.map(m => `<option value="${m.id}">${m.nama}</option>`).join('');
                filterMargaSelect.innerHTML = '<option value="">Semua Marga</option>' + options;
                tanahMargaSelect.innerHTML = options;
            }
        });
}

function loadPersons() {
    API.persons.getAll()
        .then(response => {
            if (response.success) {
                const pengelolaSelect = document.getElementById('tanahPengelola');
                
                const options = response.data.map(p => `<option value="${p.id}">${p.nama}</option>`).join('');
                pengelolaSelect.innerHTML = '<option value="">Tidak ada pengelola</option>' + options;
            }
        });
}

function setupEventListeners() {
    document.getElementById('addTanahBtn').addEventListener('click', () => openModal());
    document.getElementById('closeModal').addEventListener('click', closeModal);
    document.getElementById('cancelBtn').addEventListener('click', closeModal);
    document.getElementById('tanahForm').addEventListener('submit', saveTanah);
    document.getElementById('applyFilters').addEventListener('click', loadTanah);
}

function openModal(tanah = null) {
    const modal = document.getElementById('tanahModal');
    const form = document.getElementById('tanahForm');
    const title = document.getElementById('modalTitle');
    
    form.reset();
    document.getElementById('tanahId').value = '';
    
    if (tanah) {
        title.textContent = 'Edit Tanah Ulayat';
        document.getElementById('tanahId').value = tanah.id;
        document.getElementById('tanahNama').value = tanah.nama;
        document.getElementById('tanahMarga').value = tanah.marga_id;
        document.getElementById('tanahLuas').value = tanah.luas_hektar || '';
        document.getElementById('tanahDeskripsi').value = tanah.deskripsi || '';
        document.getElementById('tanahLokasi').value = tanah.lokasi || '';
        document.getElementById('tanahStatus').value = tanah.status;
        document.getElementById('tanahLatitude').value = tanah.latitude || '';
        document.getElementById('tanahLongitude').value = tanah.longitude || '';
        document.getElementById('tanahPengelola').value = tanah.pengelola_id || '';
        document.getElementById('tanahBatas').value = tanah.batas_wilayah || '';
    } else {
        title.textContent = 'Tambah Tanah Ulayat';
    }
    
    modal.classList.remove('hidden');
}

function closeModal() {
    document.getElementById('tanahModal').classList.add('hidden');
}

function saveTanah(e) {
    e.preventDefault();
    
    const id = document.getElementById('tanahId').value;
    const data = {
        nama: document.getElementById('tanahNama').value,
        marga_id: document.getElementById('tanahMarga').value,
        luas_hektar: document.getElementById('tanahLuas').value || null,
        deskripsi: document.getElementById('tanahDeskripsi').value,
        lokasi: document.getElementById('tanahLokasi').value,
        status: document.getElementById('tanahStatus').value,
        latitude: document.getElementById('tanahLatitude').value || null,
        longitude: document.getElementById('tanahLongitude').value || null,
        pengelola_id: document.getElementById('tanahPengelola').value || null,
        batas_wilayah: document.getElementById('tanahBatas').value
    };
    
    const promise = id ? API.tanah.update(id, data) : API.tanah.create(data);
    
    promise.then(response => {
        if (response.success) {
            Toast.success(id ? 'Tanah ulayat berhasil diperbarui' : 'Tanah ulayat berhasil ditambahkan');
            closeModal();
            loadTanah();
        } else {
            Toast.error(response.error || 'Gagal menyimpan tanah ulayat');
        }
    }).catch(error => {
        console.error('Error saving tanah:', error);
        Toast.error('Terjadi kesalahan saat menyimpan tanah ulayat');
    });
}

function viewTanah(id) {
    const tanah = currentTanah.find(t => t.id === id);
    if (tanah) {
        alert(`
Detail Tanah Ulayat:
Nama: ${tanah.nama}
Marga: ${tanah.marga ? tanah.marga.nama : 'Tidak ada'}
Luas: ${tanah.luas_hektar ? tanah.luas_hektar + ' Ha' : '-'}
Deskripsi: ${tanah.deskripsi || '-'}
Lokasi: ${tanah.lokasi || '-'}
Status: ${formatStatus(tanah.status)}
Pengelola: ${tanah.pengelola ? tanah.pengelola.nama : 'Tidak ada'}
Koordinat: ${tanah.latitude && tanah.longitude ? `${tanah.latitude}, ${tanah.longitude}` : '-'}
Batas Wilayah: ${tanah.batas_wilayah || '-'}
        `);
    }
}

function editTanah(id) {
    const tanah = currentTanah.find(t => t.id === id);
    if (tanah) {
        openModal(tanah);
    }
}

function deleteTanah(id) {
    if (confirm('Apakah Anda yakin ingin menghapus tanah ulayat ini?')) {
        API.tanah.delete(id)
            .then(response => {
                if (response.success) {
                    Toast.success('Tanah ulayat berhasil dihapus');
                    loadTanah();
                } else {
                    Toast.error(response.error || 'Gagal menghapus tanah ulayat');
                }
            })
            .catch(error => {
                console.error('Error deleting tanah:', error);
                Toast.error('Terjadi kesalahan saat menghapus tanah ulayat');
            });
    }
}

function formatStatus(status) {
    const statuses = {
        'aktif': 'Aktif',
        'sengketa': 'Sengketa',
        'dijual': 'Dijual',
        'disewakan': 'Disewakan'
    };
    return statuses[status] || status;
}

function getStatusColor(status) {
    const colors = {
        'aktif': 'bg-green-100 text-green-800',
        'sengketa': 'bg-red-100 text-red-800',
        'dijual': 'bg-yellow-100 text-yellow-800',
        'disewakan': 'bg-blue-100 text-blue-800'
    };
    return colors[status] || 'bg-gray-100 text-gray-800';
}
