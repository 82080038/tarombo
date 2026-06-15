<?php
/**
 * Logout Handler
 * Clears the authentication token and redirects to login
 */
require_once __DIR__ . '/includes/config.php';

// Clear the token cookie
if (isset($_COOKIE['tarombo_token'])) {
    setcookie('tarombo_token', '', time() - 3600, '/');
}

// Redirect to login page
header('Location: ' . TAROMBO_BASE_URL . '/login.html');
exit;
