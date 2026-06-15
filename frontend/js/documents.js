// Documents Page JavaScript
document.addEventListener('DOMContentLoaded', function () {
    loadDocuments();
    document.getElementById('filterDocType').addEventListener('change', loadDocuments);
});

const docIcons = { photo: '📷', video: '🎬', audio: '🎵', pdf: '📄', other: '📎' };
const accessColors = { public: 'success', restricted: 'warning', confidential: 'danger' };

async function loadDocuments() {
    try {
        const type = document.getElementById('filterDocType').value;
        const params = new URLSearchParams();
        if (type) params.set('type', type);

        const response = await fetch(`${API_BASE_URL}/documents?${params.toString()}`);
        const result = await response.json();

        if (!result.success) {
            document.getElementById('documentsList').innerHTML = '<p class="text-danger">Gagal memuat</p>';
            return;
        }

        const items = result.data || [];
        if (!items.length) {
            document.getElementById('documentsList').innerHTML = '<p class="text-muted">Belum ada dokumen</p>';
            return;
        }

        document.getElementById('documentsList').innerHTML = '<div class="row">' + items.map(d => `
            <div class="col-md-4 mb-3">
                <div class="card" style="transition:transform .15s;">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div style="font-size:2.5rem;">${docIcons[d.document_type] || '📎'}</div>
                            <span class="badge bg-${accessColors[d.access_level] || 'secondary'}">${d.access_level}</span>
                        </div>
                        <h6 class="card-title mt-2">${d.title}</h6>
                        <p class="mb-1"><small class="text-muted">${d.description || ''}</small></p>
                        <p class="mb-0"><small>${d.person?.nama ? '👤 ' + d.person.nama : ''}</small></p>
                    </div>
                </div>
            </div>
        `).join('') + '</div>';
    } catch (e) {
        console.error('Error loading documents:', e);
        document.getElementById('documentsList').innerHTML = '<p class="text-danger">Error memuat data</p>';
    }
}
