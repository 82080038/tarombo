<?php
$extraJs = 'locations.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🏠 Rumah Keluarga</h1>
        <button id="addRumahBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">+ Tambah Rumah</button>
    </div>
    <div id="rumahList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
</div>
<?php include 'includes/footer.php'; ?>
