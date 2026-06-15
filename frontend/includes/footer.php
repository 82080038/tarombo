?>
<footer class="mt-5 py-3 bg-light text-center">
    <div class="container">
        <p class="mb-0">&copy; 2024 Tarombo Digital. Horas! 🌳</p>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/toast.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/api.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/auth-nav.js"></script>
<?php if (!empty($extraJs)): ?>
<?php
$jsFiles = explode(',', $extraJs);
foreach ($jsFiles as $jsFile):
    $jsFile = trim($jsFile);
    if (!empty($jsFile)):
?>
<script src="<?= e($jsFile) ?>"></script>
<?php
    endif;
endforeach;
?>
<?php endif; ?>
</body>
</html>
