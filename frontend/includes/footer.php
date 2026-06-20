<?php
?>
<footer class="mt-5 py-3 bg-light text-center">
    <div class="container">
        <p class="mb-0">&copy; 2024 Tarombo Digital. Horas! 🌳</p>
    </div>
</footer>

<script src="<?= TAROMBO_BASE_URL ?>/js/jquery.min.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/bootstrap.bundle.min.js"></script>
<script>window.TAROMBO_BASE_URL = '<?= TAROMBO_BASE_URL ?>';</script>
<script src="<?= TAROMBO_BASE_URL ?>/js/toast.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/api.js"></script>
<script src="<?= TAROMBO_BASE_URL ?>/js/auth-nav.js"></script>
<?php if (!empty($extraJs)): ?>
<?php
$jsFiles = explode(',', $extraJs);
foreach ($jsFiles as $jsFile):
    $jsFile = trim($jsFile);
    if (!empty($jsFile)):
        if (!str_starts_with($jsFile, 'http') && !str_starts_with($jsFile, '/')) {
            $jsFile = TAROMBO_BASE_URL . '/js/' . $jsFile;
        }
?>
<script src="<?= e($jsFile) ?>"></script>
<?php
    endif;
endforeach;
?>
<?php endif; ?>
</body>
</html>
