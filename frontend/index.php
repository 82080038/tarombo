<?php
// Redirect to dashboard for better user experience
header('Location: ' . (defined('TAROMBO_BASE_URL') ? TAROMBO_BASE_URL : '/tarombo') . '/dashboard');
exit();
?>
