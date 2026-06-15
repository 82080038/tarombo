<?php
$extraJs = 'assets.js';
include 'includes/header.php';
?>

<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🏛️ Harta Warisan</h1>
        <button id="addAssetBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
            + Tambah Aset
        </button>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tipe Aset</label>
                <select id="filterTipe" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Tipe</option>
                    <option value="tanah">Tanah</option>
                    <option value="rumah">Rumah</option>
                    <option value="kendaraan">Kendaraan</option>
                    <option value="pusaka_adat">Pusaka Adat</option>
                    <option value="emas_perhiasan">Emas/Perhiasan</option>
                    <option value="tanaman">Tanaman</option>
                    <option value="ternak">Ternak</option>
                    <option value="lainnya">Lainnya</option>
                </select>
            </div>
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
                    <option value="terjual">Terjual</option>
                    <option value="hilang">Hilang</option>
                    <option value="rusak">Rusak</option>
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

    <!-- Assets List -->
    <div id="assetsList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- Assets will be loaded here -->
    </div>

    <!-- Loading State -->
    <div id="loadingState" class="text-center py-8 hidden">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        <p class="mt-2 text-gray-600">Memuat data...</p>
    </div>
</div>

<!-- Add/Edit Asset Modal -->
<div id="assetModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 id="modalTitle" class="text-xl font-bold">Tambah Aset</h2>
                <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="assetForm">
                <input type="hidden" id="assetId">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nama Aset *</label>
                        <input type="text" id="assetNama" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tipe Aset *</label>
                        <select id="assetTipe" required class="w-full border rounded-lg px-3 py-2">
                            <option value="tanah">Tanah</option>
                            <option value="rumah">Rumah</option>
                            <option value="kendaraan">Kendaraan</option>
                            <option value="pusaka_adat">Pusaka Adat</option>
                            <option value="emas_perhiasan">Emas/Perhiasan</option>
                            <option value="tanaman">Tanaman</option>
                            <option value="ternak">Ternak</option>
                            <option value="lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nilai Estimasi</label>
                        <input type="number" id="assetNilai" step="0.01" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Perolehan</label>
                        <input type="date" id="assetTanggal" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Cara Perolehan</label>
                        <select id="assetCara" class="w-full border rounded-lg px-3 py-2">
                            <option value="warisan">Warisan</option>
                            <option value="beli">Beli</option>
                            <option value="hadiah">Hadiah</option>
                            <option value="hadiah_adat">Hadiah Adat</option>
                            <option value="lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                        <textarea id="assetDeskripsi" rows="3" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi</label>
                        <input type="text" id="assetLokasi" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                        <select id="assetStatus" class="w-full border rounded-lg px-3 py-2">
                            <option value="aktif">Aktif</option>
                            <option value="terjual">Terjual</option>
                            <option value="hilang">Hilang</option>
                            <option value="rusak">Rusak</option>
                            <option value="disewakan">Disewakan</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Pemilik Saat Ini</label>
                        <select id="assetPemilik" class="w-full border rounded-lg px-3 py-2">
                            <option value="">Tidak ada pemilik</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                        <select id="assetMarga" class="w-full border rounded-lg px-3 py-2">
                            <option value="">Tidak ada marga</option>
                        </select>
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

<!-- Transfer Ownership Modal -->
<div id="transferModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Transfer Kepemilikan</h2>
                <button id="closeTransferModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="transferForm">
                <input type="hidden" id="transferAssetId">
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Pemilik Baru *</label>
                        <select id="transferPemilikBaru" required class="w-full border rounded-lg px-3 py-2">
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Transfer *</label>
                        <input type="date" id="transferTanggal" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Cara Transfer</label>
                        <select id="transferCara" class="w-full border rounded-lg px-3 py-2">
                            <option value="warisan_adat">Warisan Adat</option>
                            <option value="hibah">Hibah</option>
                            <option value="jual_beli">Jual Beli</option>
                            <option value="tukar_menukar">Tukar Menukar</option>
                            <option value="lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Alasan Transfer</label>
                        <textarea id="transferAlasan" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                </div>
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancelTransferBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                    <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">Transfer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>
