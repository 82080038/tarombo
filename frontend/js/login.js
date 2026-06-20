function quickLogin(role) {
    fetch(API_BASE_URL + '/auth/quick-login', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ role: role })
    }).then(r => r.json()).then(data => {
        if (data.success) {
            setAuthToken(data.data.access_token);
            window.location.href = TAROMBO_BASE_URL + '/';
        } else {
            Toast.error('Quick login gagal');
        }
    });
}

document.getElementById('loginForm').addEventListener('submit', function (e) {
    e.preventDefault();
    API.login(
        document.getElementById('loginEmail').value,
        document.getElementById('loginPassword').value
    ).then(r => {
        if (r && r.success) window.location.href = TAROMBO_BASE_URL + '/';
        else Toast.error('Login gagal');
    });
});
