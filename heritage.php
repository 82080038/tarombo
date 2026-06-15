<?php
$extraJs = 'heritage.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-gray-800 mb-6">📚 Sejarah & Tradisi</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Tradisi Adat</h2>
                <button id="addTraditionBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm">+ Tambah</button>
            </div>
            <div id="traditionsList" class="space-y-3"></div>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Cerita Keluarga</h2>
                <button id="addStoryBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm">+ Tambah</button>
            </div>
            <div id="storiesList" class="space-y-3"></div>
        </div>
    </div>
</div>
<?php include 'includes/footer.php'; ?>
