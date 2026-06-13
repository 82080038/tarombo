<?php
/**
 * Frontend Configuration
 * Base URLs and shared settings
 */
if (!defined('TAROMBO_BASE_URL')) {
    define('TAROMBO_BASE_URL', '/tarombo');
}
if (!defined('API_BASE_URL')) {
    define('API_BASE_URL', '/tarombo/api/v1');
}
if (!defined('FRONTEND_URL')) {
    define('FRONTEND_URL', TAROMBO_BASE_URL);
}

/**
 * Get current user from JWT token (if any)
 */
function getCurrentUser() {
    $token = null;
    if (isset($_COOKIE['tarombo_token'])) {
        $token = $_COOKIE['tarombo_token'];
    } elseif (isset($_SERVER['HTTP_AUTHORIZATION'])) {
        $auth = $_SERVER['HTTP_AUTHORIZATION'];
        if (strpos($auth, 'Bearer ') === 0) {
            $token = substr($auth, 7);
        }
    }
    if (!$token) return null;
    // Decode JWT payload (no verification needed for frontend display)
    $parts = explode('.', $token);
    if (count($parts) !== 3) return null;
    $payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')), true);
    return $payload ?: null;
}

/**
 * Check if user has a specific role
 */
function hasRole($requiredRoles) {
    $user = getCurrentUser();
    if (!$user || !isset($user['role'])) return false;
    if (!is_array($requiredRoles)) $requiredRoles = [$requiredRoles];
    return in_array($user['role'], $requiredRoles);
}

/**
 * Safe output
 */
function e($str) {
    return htmlspecialchars($str ?? '', ENT_QUOTES, 'UTF-8');
}
