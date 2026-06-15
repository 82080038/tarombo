<?php
$extraJs = 'history-tracking.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-gray-800 mb-6">📊 History Tracking</h1>
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tipe Entitas</label>
                <select id="entityType" class="w-full border rounded-lg px-3 py-2">
                    <option value="person">Person (Orang)</option>
                    <option value="asset">Asset (Harta Warisan)</option>
                    <option value="tanah_ulayat">Tanah Ulayat</option>
                    <option value="event">Event (Acara)</option>
                    <option value="transaction">Transaction (Transaksi)</option>
                    <option value="rumah_keluarga">Rumah Keluarga</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">ID Entitas</label>
                <input type="number" id="entityId" class="w-full border rounded-lg px-3 py-2" placeholder="Masukkan ID">
            </div>
            <div class="flex items-end">
                <button id="loadHistory" class="w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">Tampilkan History</button>
            </div>
        </div>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow p-4">
            <h2 class="text-xl font-bold mb-4">📋 Change History</h2>
            <div id="historyList" class="space-y-3"></div>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <h2 class="text-xl font-bold mb-4">📅 Timeline Events</h2>
            <div id="timelineList" class="space-y-3"></div>
        </div>
    </div>
</div>
<?php include 'includes/footer.php'; ?>
