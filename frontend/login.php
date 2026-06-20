<?php
$pageTitle = 'Login';
$activePage = '';
$extraJs = '/tarombo/js/login.js';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header"><h5 class="mb-0">🔑 Login</h5></div>
                <div class="card-body">
                    <form id="loginForm">
                        <div class="mb-3"><label class="form-label">Email</label><input type="email" class="form-control" id="loginEmail" required></div>
                        <div class="mb-3"><label class="form-label">Password</label><input type="password" class="form-control" id="loginPassword" required></div>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>
                    <hr>
                    <div class="text-center">
                        <p class="mb-2">Quick Login (Dev)</p>
                        <button class="btn btn-sm btn-outline-secondary" onclick="quickLogin('user')">User</button>
                        <button class="btn btn-sm btn-outline-info" onclick="quickLogin('verified')">Verified</button>
                        <button class="btn btn-sm btn-outline-success" onclick="quickLogin('punguan_admin')">Punguan Admin</button>
                        <button class="btn btn-sm btn-outline-warning" onclick="quickLogin('admin')">Admin</button>
                    </div>
                    <hr>
                    <p class="text-center mb-0">Belum punya akun? <a href="<?= TAROMBO_BASE_URL ?>/register">Daftar</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
