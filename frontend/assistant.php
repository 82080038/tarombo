<?php
$pageTitle = 'AI Tarombo Assistant';
$activePage = 'assistant';
require_once __DIR__ . '/includes/header.php';
require_once __DIR__ . '/includes/menu.php';
?>

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <span><strong>🤖 AI Tarombo Assistant</strong></span>
                    <small>Asisten Kekerabatan Adat Batak</small>
                </div>
                <div class="card-body" id="chatBox" style="max-height:60vh; overflow-y:auto;">
                    <div class="mb-3"><div class="d-inline-block bg-light p-3 rounded" style="max-width:80%;">
                        <p class="mb-1">Horas! Saya adalah AI Tarombo Assistant.</p>
                        <p class="mb-0">Saya bisa membantu dengan pertanyaan tentang Partuturan, adat Batak, Tulang, Namboru, Bere, dan Pariban.</p>
                    </div></div>
                </div>
                <div class="card-footer">
                    <div class="d-flex flex-wrap gap-2 mb-2" id="suggestionChips">
                        <span class="badge bg-light text-dark border suggestion-chip" style="cursor:pointer" onclick="setQuery('Apa itu Dalihan Na Tolu?')">Apa itu Dalihan Na Tolu?</span>
                        <span class="badge bg-light text-dark border suggestion-chip" style="cursor:pointer" onclick="setQuery('Jelaskan Partuturan')">Jelaskan Partuturan</span>
                        <span class="badge bg-light text-dark border suggestion-chip" style="cursor:pointer" onclick="setQuery('Apa itu Saur Matua?')">Apa itu Saur Matua?</span>
                    </div>
                    <div class="input-group">
                        <input type="text" class="form-control" id="queryInput" placeholder="Tanyakan sesuatu..." onkeydown="if(event.key==='Enter') sendQuery()">
                        <button class="btn btn-primary" onclick="sendQuery()">Kirim</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
<script src="<?= TAROMBO_BASE_URL ?>/js/assistant.js"></script>
