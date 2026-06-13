<?php
/**
 * Content Layout Helper
 * Provides reusable page layout components
 */

/**
 * Render a page title section with optional subtitle and action button
 */
function renderPageHeader($title, $subtitle = '', $actionHtml = '') {
?>
<div class="row mb-4">
    <div class="col-12">
        <h1><?= e($title) ?></h1>
        <?php if ($subtitle): ?>
        <p class="text-muted lead"><?= e($subtitle) ?></p>
        <?php endif; ?>
        <?php if ($actionHtml): ?>
        <div class="mt-2"><?= $actionHtml ?></div>
        <?php endif; ?>
    </div>
</div>
<?php
}

/**
 * Render an empty state message
 */
function renderEmptyState($message, $icon = '🔍') {
?>
<div class="text-center py-5">
    <div class="display-4 mb-3"><?= $icon ?></div>
    <p class="text-muted"><?= e($message) ?></p>
</div>
<?php
}

/**
 * Render a loading spinner
 */
function renderLoading($targetId) {
?>
<div id="<?= e($targetId) ?>" class="text-center py-4">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Memuat...</span>
    </div>
    <p class="text-muted mt-2">Memuat data...</p>
</div>
<?php
}

/**
 * Render a card component
 */
function renderCard($title, $content, $extraClass = '') {
?>
<div class="card <?= e($extraClass) ?>">
    <div class="card-header"><h5 class="mb-0"><?= e($title) ?></h5></div>
    <div class="card-body"><?= $content ?></div>
</div>
<?php
}
