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
    <link href="<?= TAROMBO_BASE_URL ?>/css/bootstrap.min.css" rel="stylesheet">
    <link href="<?= TAROMBO_BASE_URL ?>/css/style.css" rel="stylesheet">
    <?php if (!empty($extraCss)):
        $cssFile = $extraCss;
        if (!str_starts_with($cssFile, 'http') && !str_starts_with($cssFile, '/')) {
            $cssFile = TAROMBO_BASE_URL . '/css/' . $cssFile;
        }
    ?>
    <link rel="stylesheet" href="<?= e($cssFile) ?>"><?php endif; ?>
    <style>
        .nav-link.active { font-weight: 600; }
        .dropdown-menu { min-width: 220px; }
    </style>
</head>
<body>
