// Auth Navigation Manager
// Automatically adds user dropdown or login link to navbar

document.addEventListener('DOMContentLoaded', function () {
    initAuthNav();
});

async function initAuthNav() {
    const navContainer = document.querySelector('.navbar-nav');
    if (!navContainer) return;

    // Check if already initialized
    if (document.getElementById('authNavItem')) return;

    const token = localStorage.getItem('tarombo_token');
    const li = document.createElement('li');
    li.className = 'nav-item';
    li.id = 'authNavItem';

    if (token) {
        // Try to get user info
        try {
            const response = await fetch('/tarombo/api/v1/auth/me', {
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
                        window.location.href = 'login.html';
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
        <a class="nav-link" href="login.html">Masuk</a>
    `;
    navContainer.appendChild(li);
}
