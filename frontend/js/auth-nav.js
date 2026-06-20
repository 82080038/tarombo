// Auth Navigation Manager
// Handles role-based menu visibility: guest, user, punguan_admin, admin, RBAC

document.addEventListener('DOMContentLoaded', function () {
    initAuthNav();
    applyRBAC();
});

async function initAuthNav() {
    const navContainer = document.querySelector('.navbar-nav');
    if (!navContainer) return;

    const existingAuthNav = document.getElementById('authNavItem');
    if (existingAuthNav) {
        existingAuthNav.remove();
    }

    const token = localStorage.getItem('tarombo_token');
    const li = document.createElement('li');
    li.className = 'nav-item';
    li.id = 'authNavItem';

    if (token) {
        try {
            const response = await fetch(API_BASE_URL + '/auth/me', {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    const user = result.data;
                    const roleLabels = {
                        'admin': 'Administrator',
                        'punguan_admin': 'Admin Punguan',
                        'tetua': 'Tetua Adat',
                        'verified': 'User Terverifikasi',
                        'user': 'User',
                        'guest': 'Tamu'
                    };
                    const roleLabel = roleLabels[user.role] || user.role;
                    li.innerHTML = `
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <span class="badge bg-light text-primary me-1">${roleLabel}</span> 👤 ${user.nama}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><span class="dropdown-item-text text-muted small">${user.email}</span></li>
                                <li><span class="dropdown-item-text text-muted small">Role: ${user.role}</span></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${window.TAROMBO_BASE_URL || '/tarombo'}/dashboard">📊 Dashboard</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" id="logoutBtn">🚪 Keluar</a></li>
                            </ul>
                        </div>
                    `;
                    navContainer.appendChild(li);

                    document.getElementById('logoutBtn').addEventListener('click', function (e) {
                        e.preventDefault();
                        localStorage.removeItem('tarombo_token');
                        window.location.href = (window.TAROMBO_BASE_URL || '/tarombo') + '/';
                    });
                    return;
                }
            }
        } catch (e) {
            // silent fail
        }
        localStorage.removeItem('tarombo_token');
    }

    // Show login/register links for guests
    li.innerHTML = `
        <a class="nav-link" href="${window.TAROMBO_BASE_URL || '/tarombo'}/login">🔑 Masuk</a>
    `;
    navContainer.appendChild(li);
}

function applyRBAC() {
    const token = localStorage.getItem('tarombo_token');
    let role = 'guest';

    if (token) {
        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            role = payload.role || 'user';
        } catch (e) {
            role = 'user';
        }
    }

    // --- auth-required: visible to any logged-in user ---
    document.querySelectorAll('.auth-required').forEach(el => {
        el.style.display = token ? '' : 'none';
    });

    // --- punguan-admin-only: visible to punguan_admin, tetua, admin ---
    const punguanAdminRoles = ['punguan_admin', 'tetua', 'admin'];
    document.querySelectorAll('.punguan-admin-only').forEach(el => {
        el.style.display = punguanAdminRoles.includes(role) ? '' : 'none';
    });

    // --- admin-only: visible to admin only (system admin) ---
    document.querySelectorAll('.admin-only').forEach(el => {
        el.style.display = (role === 'admin') ? '' : 'none';
    });

    // --- admin-required: visible to admin, punguan_admin, tetua (legacy compatibility) ---
    const adminRoles = ['admin', 'punguan_admin', 'tetua'];
    document.querySelectorAll('.admin-required').forEach(el => {
        el.style.display = adminRoles.includes(role) ? '' : 'none';
    });

    // --- verified-only: visible to verified, tetua, punguan_admin, admin ---
    const verifiedRoles = ['verified', 'tetua', 'punguan_admin', 'admin'];
    document.querySelectorAll('.verified-only').forEach(el => {
        el.style.display = verifiedRoles.includes(role) ? '' : 'none';
    });

    // --- tetua-only: visible to tetua, admin ---
    document.querySelectorAll('.tetua-only').forEach(el => {
        el.style.display = ['tetua', 'admin'].includes(role) ? '' : 'none';
    });
}
