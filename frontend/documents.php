<?php
$pageTitle = 'Dokumen & Arsip';
$activePage = 'documents';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <h2>📁 Dokumen & Arsip</h2>
    <p class="text-muted">Foto, video, audio, dan dokumen adat Batak</p>
    <div class="row mb-3">
        <div class="col-md-3">
            <select class="form-select" id="filterDocType">
                <option value="">Semua Jenis</option>
                <option value="photo">Foto</option>
                <option value="video">Video</option>
                <option value="audio">Audio</option>
                <option value="pdf">PDF</option>
                <option value="other">Lainnya</option>
            </select>
        </div>
    </div>
    <div id="documentsList"><p class="text-muted">Memuat...</p></div>
</div>

<?php
$extraJs = TAROMBO_BASE_URL . '/js/documents.js';
require_once __DIR__ . '/includes/footer.php';
?>
