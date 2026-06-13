<?php
$pageTitle = 'Daftar Akun';
$activePage = '';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header"><h5 class="mb-0">📝 Daftar Akun Baru</h5></div>
                <div class="card-body">
                    <form id="registerForm">
                        <div class="mb-3"><label class="form-label">Nama</label><input type="text" class="form-control" id="regName" required></div>
                        <div class="mb-3"><label class="form-label">Email</label><input type="email" class="form-control" id="regEmail" required></div>
                        <div class="mb-3"><label class="form-label">Password</label><input type="password" class="form-control" id="regPassword" required></div>
                        <button type="submit" class="btn btn-success w-100">Daftar</button>
                    </form>
                    <hr>
                    <p class="text-center mb-0">Sudah punya akun? <a href="<?= TAROMBO_BASE_URL ?>/login">Login</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
<script>
document.getElementById('registerForm').addEventListener('submit', function(e) {
    e.preventDefault();
    API.register(document.getElementById('regEmail').value, document.getElementById('regPassword').value, document.getElementById('regName').value).then(r => {
        if (r && r.success) { alert('Berhasil daftar!'); window.location.href = '<?= TAROMBO_BASE_URL ?>/login'; }
        else alert('Daftar gagal');
    });
});
</script>
