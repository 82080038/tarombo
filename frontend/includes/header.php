<?php
require_once __DIR__ . '/config.php';
if (!isset($pageTitle)) $pageTitle = 'Tarombo Digital';
if (!isset($activePage)) $activePage = '';
?><!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= e($pageTitle) ?> — Tarombo Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <?php if (!empty($extraCss)): ?>
    <link rel="stylesheet" href="<?= e($extraCss) ?>"><?php endif; ?>
    <style>
        .nav-link.active { font-weight: 600; }
        .dropdown-menu { min-width: 220px; }
    </style>
</head>
<body>
