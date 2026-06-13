// Marriages Page Logic
document.addEventListener('DOMContentLoaded', function () {
    loadMarriages();
    loadPersonsForSelect();

    document.getElementById('searchMarriage').addEventListener('input', debounce(loadMarriages, 300));
    document.getElementById('filterStatus').addEventListener('change', loadMarriages);
    document.getElementById('saveMarriageBtn').addEventListener('click', saveMarriage);
});

let currentPage = 1;

async function loadMarriages(page = 1) {
    currentPage = page;
    const search = document.getElementById('searchMarriage').value;
    const status = document.getElementById('filterStatus').value;

    try {
        const params = new URLSearchParams();
        params.set('page', page);
        params.set('limit', 20);
        if (status) params.set('status', status);

        const response = await fetch(`${API_BASE_URL}/marriages?${params.toString()}`);
        const result = await response.json();

        if (!result.success) {
            document.getElementById('marriagesTable').innerHTML =
                '<tr><td colspan="6" class="text-center text-danger">Gagal memuat data</td></tr>';
            return;
        }

        renderMarriages(result.data.items);
        renderPagination(result.data.pagination);
    } catch (error) {
        console.error('Error loading marriages:', error);
        document.getElementById('marriagesTable').innerHTML =
            '<tr><td colspan="6" class="text-center text-danger">Error memuat data</td></tr>';
    }
}

function renderMarriages(marriages) {
    const tbody = document.getElementById('marriagesTable');
    if (!marriages || marriages.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center">Belum ada data perkawinan</td></tr>';
        return;
    }

    const search = document.getElementById('searchMarriage').value.toLowerCase();
    const filtered = search
        ? marriages.filter(m =>
            m.husband.nama.toLowerCase().includes(search) ||
            m.wife.nama.toLowerCase().includes(search) ||
            (m.tempat_perkawinan && m.tempat_perkawinan.toLowerCase().includes(search))
        )
        : marriages;

    tbody.innerHTML = filtered.map(m => {
        const stageProgress = m.total_stages
            ? Math.round((m.completed_stages / m.total_stages) * 100)
            : 0;

        return `
        <tr>
            <td><strong>${escapeHtml(m.husband.nama)}</strong><br><small class="text-muted">${escapeHtml(m.husband.marga)}</small></td>
            <td><strong>${escapeHtml(m.wife.nama)}</strong><br><small class="text-muted">${escapeHtml(m.wife.marga)}</small></td>
            <td>${m.tanggal_perkawinan || '-'}</td>
            <td>
                <div class="d-flex align-items-center">
                    <span class="stage-badge stage-${m.completed_stages === m.total_stages ? 'completed' : 'pending'}">${m.completed_stages}/${m.total_stages || 7}</span>
                    <div class="progress progress-thin flex-grow-1 ms-2" style="min-width:40px;">
                        <div class="progress-bar bg-success" style="width:${stageProgress}%"></div>
                    </div>
                </div>
            </td>
            <td><span class="badge bg-${getStatusColor(m.status)}">${getStatusLabel(m.status)}</span></td>
            <td>
                <button class="btn btn-sm btn-outline-primary" onclick="viewMarriage(${m.id})">Detail</button>
            </td>
        </tr>
        `;
    }).join('');
}

function renderPagination(pagination) {
    if (!pagination) return;
    const el = document.getElementById('pagination');
    let html = `<span>Halaman ${pagination.page} dari ${pagination.total_pages} (${pagination.total} total)</span>`;
    html += '<div>';
    if (pagination.page > 1) {
        html += `<button class="btn btn-sm btn-outline-secondary me-1" onclick="loadMarriages(${pagination.page - 1})">Sebelumnya</button>`;
    }
    if (pagination.page < pagination.total_pages) {
        html += `<button class="btn btn-sm btn-outline-secondary" onclick="loadMarriages(${pagination.page + 1})">Selanjutnya</button>`;
    }
    html += '</div>';
    el.innerHTML = html;
}

async function loadPersonsForSelect() {
    try {
        const persons = await API.getPersons();
        const males = persons.filter(p => p.jenis_kelamin === 'L');
        const females = persons.filter(p => p.jenis_kelamin === 'P');

        const hSelect = document.getElementById('husbandSelect');
        const wSelect = document.getElementById('wifeSelect');

        hSelect.innerHTML = '<option value="">Pilih anggota keluarga...</option>' +
            males.map(p => `<option value="${p.id}">${escapeHtml(p.nama)} (${escapeHtml(p.marga?.nama || '')})</option>`).join('');

        wSelect.innerHTML = '<option value="">Pilih anggota keluarga...</option>' +
            females.map(p => `<option value="${p.id}">${escapeHtml(p.nama)} (${escapeHtml(p.marga?.nama || '')})</option>`).join('');
    } catch (e) {
        console.error('Error loading persons:', e);
    }
}

async function saveMarriage() {
    const husbandId = parseInt(document.getElementById('husbandSelect').value);
    const wifeId = parseInt(document.getElementById('wifeSelect').value);
    const date = document.getElementById('marriageDate').value;
    const place = document.getElementById('marriagePlace').value;
    const errorDiv = document.getElementById('marriageError');
    const warningDiv = document.getElementById('marriageWarning');
    const btn = document.getElementById('saveMarriageBtn');

    errorDiv.style.display = 'none';
    warningDiv.style.display = 'none';

    if (!husbandId || !wifeId) {
        errorDiv.textContent = 'Pilih pengantin pria dan wanita';
        errorDiv.style.display = 'block';
        return;
    }

    if (husbandId === wifeId) {
        errorDiv.textContent = 'Pengantin pria dan wanita tidak boleh sama';
        errorDiv.style.display = 'block';
        return;
    }

    btn.disabled = true;
    btn.textContent = 'Menyimpan...';

    try {
        const response = await fetch(`${API_BASE_URL}/marriages`, {
            method: 'POST',
            headers: getAuthHeaders(),
            body: JSON.stringify({
                husband_id: husbandId,
                wife_id: wifeId,
                tanggal_perkawinan: date || null,
                tempat_perkawinan: place || null
            })
        });

        const result = await response.json();

        if (result.success) {
            // Reset form
            document.getElementById('addMarriageForm').reset();
            const modalEl = document.getElementById('addMarriageModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
            loadMarriages();
            showToast('Perkawinan berhasil dicatat!', 'success');
        } else {
            errorDiv.textContent = result.error?.message || 'Gagal menyimpan';
            if (result.error?.details) {
                errorDiv.innerHTML += `<br><small>${JSON.stringify(result.error.details)}</small>`;
            }
            errorDiv.style.display = 'block';
        }
    } catch (error) {
        errorDiv.textContent = 'Gagal terhubung ke server';
        errorDiv.style.display = 'block';
    }

    btn.disabled = false;
    btn.textContent = 'Simpan';
}

async function viewMarriage(id) {
    try {
        const response = await fetch(`${API_BASE_URL}/marriages/${id}`);
        const result = await response.json();

        if (!result.success) {
            showToast('Gagal memuat detail', 'danger');
            return;
        }

        const m = result.data;
        const stagesHtml = m.stages.map(s => `
            <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                <div>
                    <strong>${s.stage_name}</strong>
                    <span class="stage-badge stage-${s.status} ms-2">${s.status.toUpperCase()}</span>
                </div>
                <div class="text-end">
                    ${s.stage_date ? `<small class="text-muted">${s.stage_date}</small>` : ''}
                    ${s.stage_location ? `<small class="text-muted d-block">${escapeHtml(s.stage_location)}</small>` : ''}
                </div>
            </div>
        `).join('');

        const progress = m.total_stages ? Math.round((m.completed_stages / m.total_stages) * 100) : 0;

        document.getElementById('marriageDetailContent').innerHTML = `
            <div class="row mb-3">
                <div class="col-md-6">
                    <h6>Pengantin Pria</h6>
                    <p class="mb-0"><strong>${escapeHtml(m.husband.nama)}</strong></p>
                    <small class="text-muted">Marga: ${escapeHtml(m.husband.marga)}</small>
                </div>
                <div class="col-md-6">
                    <h6>Pengantin Wanita</h6>
                    <p class="mb-0"><strong>${escapeHtml(m.wife.nama)}</strong></p>
                    <small class="text-muted">Marga: ${escapeHtml(m.wife.marga)}</small>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6"><strong>Tanggal:</strong> ${m.tanggal_perkawinan || '-'}</div>
                <div class="col-md-6"><strong>Tempat:</strong> ${escapeHtml(m.tempat_perkawinan) || '-'}</div>
            </div>
            <div class="mb-3">
                <div class="d-flex justify-content-between">
                    <span>Progress Tahapan</span>
                    <span>${progress}%</span>
                </div>
                <div class="progress" style="height: 20px;">
                    <div class="progress-bar bg-success" style="width: ${progress}%"></div>
                </div>
            </div>
            <h6>Tahapan Perkawinan Adat</h6>
            <div class="card">
                <div class="card-body py-1">${stagesHtml || '<p class="text-muted mb-0">Belum ada tahapan</p>'}</div>
            </div>
        `;

        const modal = new bootstrap.Modal(document.getElementById('marriageDetailModal'));
        modal.show();
    } catch (e) {
        showToast('Gagal memuat detail', 'danger');
    }
}

function getStatusColor(status) {
    return { active: 'success', divorced: 'danger', widowed: 'secondary' }[status] || 'secondary';
}

function getStatusLabel(status) {
    return { active: 'Aktif', divorced: 'Bercerai', widowed: 'Duda/Janda' }[status] || status;
}

function showToast(message, type = 'success') {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 250px;';
    toast.innerHTML = `${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button>`;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

function debounce(fn, ms) {
    let t;
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), ms); };
}

function escapeHtml(str) {
    if (!str) return '';
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
}
