<?php
$extraJs = 'tanah-ulayat.js';
include 'includes/header.php';
?>

<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🗺️ Tanah Ulayat</h1>
        <button id="addTanahBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
            + Tambah Tanah Ulayat
        </button>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                <select id="filterMarga" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Marga</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <select id="filterStatus" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Status</option>
                    <option value="aktif">Aktif</option>
                    <option value="sengketa">Sengketa</option>
                    <option value="dijual">Dijual</option>
                    <option value="disewakan">Disewakan</option>
                </select>
            </div>
            <div class="flex items-end">
                <button id="applyFilters" class="w-full bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg">
                    Terapkan Filter
                </button>
            </div>
        </div>
    </div>

    <!-- Tanah List -->
    <div id="tanahList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Tanah will be loaded here -->
    </div>

    <!-- Loading State -->
    <div id="loadingState" class="text-center py-8 hidden">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        <p class="mt-2 text-gray-600">Memuat data...</p>
    </div>
</div>

<!-- Add/Edit Tanah Modal -->
<div id="tanahModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 id="modalTitle" class="text-xl font-bold">Tambah Tanah Ulayat</h2>
                <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="tanahForm">
                <input type="hidden" id="tanahId">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nama Tanah *</label>
                        <input type="text" id="tanahNama" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Marga *</label>
                        <select id="tanahMarga" required class="w-full border rounded-lg px-3 py-2">
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Luas (Hektar)</label>
                        <input type="number" id="tanahLuas" step="0.01" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                        <textarea id="tanahDeskripsi" rows="3" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi</label>
                        <input type="text" id="tanahLokasi" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="tanahStatus" class="w-full border rounded-lg px-3 py-2">
                            <option value="aktif">Aktif</option>
                            <option value="sengketa">Sengketa</option>
                            <option value="dijual">Dijual</option>
                            <option value="disewakan">Disewakan</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Latitude</label>
                        <input type="number" id="tanahLatitude" step="0.00000001" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                        <input type="number" id="tanahLongitude" step="0.00000001" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Pengelola</label>
                        <select id="tanahPengelola" class="w-full border rounded-lg px-3 py-2">
                            <option value="">Tidak ada pengelola</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Batas Wilayah</label>
                        <textarea id="tanahBatas" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                </div>
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancelBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>
