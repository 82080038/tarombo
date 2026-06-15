<?php
$extraJs = 'backup.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-gray-800 mb-6">💾 Backup & Restore</h1>
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <!-- Export Section -->
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-bold mb-4">📤 Export Data</h2>
            <p class="text-gray-600 mb-4">Download seluruh data aplikasi dalam format JSON untuk backup.</p>
            
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tipe Export</label>
                    <select id="exportType" class="w-full border rounded-lg px-3 py-2">
                        <option value="all">Semua Data</option>
                        <option value="persons">Persons (Anggota)</option>
                        <option value="marga">Marga</option>
                        <option value="assets">Assets (Harta Warisan)</option>
                        <option value="transactions">Transaksi</option>
                        <option value="oral_traditions">Tradisi Lisan</option>
                        <option value="traditional_knowledge">Pengetahuan Tradisional</option>
                        <option value="cultural_sites">Situs Budaya</option>
                    </select>
                </div>
                <button id="exportBtn" class="w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg auth-required">
                    Download Backup
                </button>
            </div>
        </div>
        
        <!-- Import Section -->
        <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-xl font-bold mb-4">📥 Import Data</h2>
            <p class="text-gray-600 mb-4">Restore data dari file backup JSON. Perhatian: ini akan menimpa data yang ada.</p>
            
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">File Backup</label>
                    <input type="file" id="importFile" accept=".json" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div id="importPreview" class="hidden bg-gray-50 rounded-lg p-4">
                    <h3 class="font-medium mb-2">Preview File:</h3>
                    <div id="previewContent" class="text-sm text-gray-600"></div>
                </div>
                <button id="importBtn" class="w-full bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg auth-required" disabled>
                    Restore Data
                </button>
            </div>
        </div>
    </div>
    
    <!-- Backup History -->
    <div class="bg-white rounded-lg shadow p-6">
        <h2 class="text-xl font-bold mb-4">📋 Riwayat Backup</h2>
        <div id="backupHistory" class="space-y-3">
            <p class="text-gray-500">Memuat riwayat backup...</p>
        </div>
    </div>
</div>

<!-- Import Progress Modal -->
<div id="importModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 p-6">
        <h2 class="text-xl font-bold mb-4">Memproses Import</h2>
        <div class="mb-4">
            <div class="w-full bg-gray-200 rounded-full h-4">
                <div id="importProgress" class="bg-blue-600 h-4 rounded-full transition-all duration-300" style="width: 0%"></div>
            </div>
            <p id="importStatus" class="text-sm text-gray-600 mt-2">Memulai import...</p>
        </div>
        <div id="importResults" class="hidden">
            <h3 class="font-medium mb-2">Hasil Import:</h3>
            <div id="resultsContent" class="text-sm"></div>
        </div>
        <button id="closeImportModal" class="mt-4 w-full bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg hidden">
            Tutup
        </button>
    </div>
</div>

<?php include 'includes/footer.php'; ?>
