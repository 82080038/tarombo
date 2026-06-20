// Auth Navigation Manager
// Automatically adds user dropdown or login link to navbar

document.addEventListener('DOMContentLoaded', function () {
    initAuthNav();
    applyRBAC();
});

async function initAuthNav() {
    const navContainer = document.querySelector('.navbar-nav');
    if (!navContainer) return;

    // Remove existing auth nav item if present to allow updates
    const existingAuthNav = document.getElementById('authNavItem');
    if (existingAuthNav) {
        existingAuthNav.remove();
    }

    const token = localStorage.getItem('tarombo_token');
    const li = document.createElement('li');
    li.className = 'nav-item';
    li.id = 'authNavItem';

    if (token) {
        // Try to get user info
        try {
            const response = await fetch(API_BASE_URL + '/auth/me', {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    const user = result.data;
                    li.innerHTML = `
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                👤 ${user.nama}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><span class="dropdown-item-text text-muted small">${user.email}</span></li>
                                <li><span class="dropdown-item-text text-muted small">Role: ${user.role}</span></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" id="logoutBtn">Keluar</a></li>
                            </ul>
                        </div>
                    `;
                    navContainer.appendChild(li);

                    document.getElementById('logoutBtn').addEventListener('click', function (e) {
                        e.preventDefault();
                        localStorage.removeItem('tarombo_token');
                        window.location.href = (window.TAROMBO_BASE_URL || '/tarombo') + '/login';
                    });
                    return;
                }
            }
        } catch (e) {
            // silent fail
        }

        // Token invalid, show login link
        localStorage.removeItem('tarombo_token');
    }

    // Show login/register links
    li.innerHTML = `
        <a class="nav-link" href="${window.TAROMBO_BASE_URL || '/tarombo'}/login">Masuk</a>
    `;
    navContainer.appendChild(li);
}

function applyRBAC() {
    const token = localStorage.getItem('tarombo_token');

    // Show/hide elements that require authentication
    const authRequiredElements = document.querySelectorAll('.auth-required');
    authRequiredElements.forEach(element => {
        if (token) {
            element.style.display = '';
        } else {
            element.style.display = 'none';
        }
    });

    // Show/hide admin-only elements
    const adminRequiredElements = document.querySelectorAll('.admin-required');
    adminRequiredElements.forEach(element => {
        if (!token) {
            element.style.display = 'none';
            return;
        }

        // Decode JWT to check role
        try {
            const payload = JSON.parse(atob(token.split('.')[1]));
            // Allow admin, punguan_admin, and tetua
            if (['admin', 'punguan_admin', 'tetua'].includes(payload.role)) {
                element.style.display = '';
            } else {
                element.style.display = 'none';
            }
        } catch (e) {
            element.style.display = 'none';
        }
    });
}
