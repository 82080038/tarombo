// Dashboard data loader
// Fetches stats and recent activity for the dashboard page

document.addEventListener('DOMContentLoaded', function () {
    const token = localStorage.getItem('tarombo_token');
    if (token) {
        loadDashboardStats();
        loadRecentActivity();
    }
});

async function loadDashboardStats() {
    const token = localStorage.getItem('tarombo_token');
    if (!token) return;

    try {
        const headers = { 'Authorization': `Bearer ${token}` };

        const [personsRes, margaRes, marriagesRes] = await Promise.allSettled([
            fetch(API_BASE_URL + '/persons?limit=1', { headers }),
            fetch(API_BASE_URL + '/marga?limit=1', { headers }),
            fetch(API_BASE_URL + '/marriages?limit=1', { headers })
        ]);

        if (personsRes.status === 'fulfilled' && personsRes.value.ok) {
            const data = await personsRes.value.json();
            const count = data.meta?.total ?? data.data?.length ?? '-';
            const el = document.getElementById('dashStatPersons');
            if (el) el.textContent = count;
        }

        if (margaRes.status === 'fulfilled' && margaRes.value.ok) {
            const data = await margaRes.value.json();
            const count = data.meta?.total ?? data.data?.length ?? '-';
            const el = document.getElementById('dashStatMarga');
            if (el) el.textContent = count;
        }

        if (marriagesRes.status === 'fulfilled' && marriagesRes.value.ok) {
            const data = await marriagesRes.value.json();
            const count = data.meta?.total ?? data.data?.length ?? '-';
            const el = document.getElementById('dashStatMarriages');
            if (el) el.textContent = count;
        }

        const punguanEl = document.getElementById('dashStatPunguan');
        if (punguanEl) {
            try {
                const punguanRes = await fetch(API_BASE_URL + '/punguan?limit=1', { headers });
                if (punguanRes.ok) {
                    const data = await punguanRes.json();
                    punguanEl.textContent = data.meta?.total ?? data.data?.length ?? '-';
                } else {
                    punguanEl.textContent = '-';
                }
            } catch {
                punguanEl.textContent = '-';
            }
        }
    } catch (e) {
        console.error('Dashboard stats error:', e);
    }
}

async function loadRecentActivity() {
    const token = localStorage.getItem('tarombo_token');
    if (!token) return;

    const tbody = document.getElementById('dashActivityTable');
    if (!tbody) return;

    try {
        const res = await fetch(API_BASE_URL + '/history?limit=10', {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (!res.ok) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Belum ada aktivitas.</td></tr>';
            return;
        }

        const data = await res.json();
        const items = data.data ?? [];

        if (items.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Belum ada aktivitas terbaru.</td></tr>';
            return;
        }

        tbody.innerHTML = items.map(item => {
            const time = item.changed_at ? new Date(item.changed_at).toLocaleString('id-ID') : '-';
            const action = item.action || '-';
            const entity = `${item.entity_type || '-'} #${item.entity_id || '-'}`;
            const by = item.changed_by || '-';
            return `<tr><td>${time}</td><td><span class="badge bg-info">${action}</span></td><td>${entity}</td><td>${by}</td></tr>`;
        }).join('');
    } catch (e) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">Tidak dapat memuat aktivitas.</td></tr>';
    }
}
