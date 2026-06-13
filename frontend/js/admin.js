// Admin Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function () {
    loadStatistics();
});

async function loadStatistics() {
    const errorDiv = document.getElementById('adminError');
    errorDiv.style.display = 'none';

    try {
        const response = await fetch(`${API_BASE_URL}/admin/statistics`, {
            headers: getAuthHeaders()
        });

        if (response.status === 401) {
            errorDiv.textContent = 'Akses ditolak. Anda harus login sebagai admin.';
            errorDiv.style.display = 'block';
            return;
        }

        const result = await response.json();
        if (!result.success) {
            errorDiv.textContent = result.error?.message || 'Gagal memuat statistik';
            errorDiv.style.display = 'block';
            return;
        }

        const data = result.data;

        // Overview cards
        document.getElementById('statPersons').textContent = data.overview.total_persons;
        document.getElementById('statMarga').textContent = data.overview.total_marga;
        document.getElementById('statMarriages').textContent = data.overview.total_marriages;
        document.getElementById('statUsers').textContent = data.overview.total_users;

        // Sub-suku chart (simple bar representation)
        const subSukuHtml = data.sub_suku_distribution.length
            ? data.sub_suku_distribution.map(s => {
                const max = Math.max(...data.sub_suku_distribution.map(x => x.count));
                const pct = max ? (s.count / max * 100) : 0;
                return `<div class="d-flex align-items-center mb-2">
                    <div style="width:100px">${s.sub_suku}</div>
                    <div class="progress flex-grow-1 mx-2" style="height:20px">
                        <div class="progress-bar bg-primary" style="width:${pct}%"></div>
                    </div>
                    <span class="text-muted">${s.count}</span>
                </div>`;
            }).join('')
            : '<p class="text-muted">Tidak ada data</p>';
        document.getElementById('subSukuChart').innerHTML = subSukuHtml;

        // Gender chart
        const genderHtml = data.gender_distribution.length
            ? data.gender_distribution.map(g => {
                const label = g.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan';
                const color = g.jenis_kelamin === 'L' ? 'bg-primary' : 'bg-danger';
                const total = data.gender_distribution.reduce((s, x) => s + x.count, 0);
                const pct = total ? (g.count / total * 100) : 0;
                return `<div class="d-flex align-items-center mb-2">
                    <div style="width:100px">${label}</div>
                    <div class="progress flex-grow-1 mx-2" style="height:20px">
                        <div class="progress-bar ${color}" style="width:${pct}%"></div>
                    </div>
                    <span class="text-muted">${g.count}</span>
                </div>`;
            }).join('')
            : '<p class="text-muted">Tidak ada data</p>';
        document.getElementById('genderChart').innerHTML = genderHtml;

        // Activity table
        const activityHtml = data.recent_logs.length
            ? data.recent_logs.map(log => `<tr>
                <td><small>${new Date(log.created_at).toLocaleString('id-ID')}</small></td>
                <td><span class="badge bg-${log.action === 'CREATE' ? 'success' : log.action === 'UPDATE' ? 'warning' : 'danger'}">${log.action}</span></td>
                <td>${log.entity_type}</td>
                <td>${log.entity_id}</td>
                <td>${log.performed_by || '-'}</td>
            </tr>`).join('')
            : '<tr><td colspan="5" class="text-center text-muted">Belum ada aktivitas</td></tr>';
        document.getElementById('activityTable').innerHTML = activityHtml;

    } catch (error) {
        console.error('Error loading statistics:', error);
        errorDiv.textContent = 'Gagal memuat statistik. Pastikan Anda login sebagai admin.';
        errorDiv.style.display = 'block';
    }
}
