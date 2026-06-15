<?php
$extraJs = 'cultural-sites.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🏛️ Situs Budaya</h1>
        <button id="addSiteBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">+ Tambah Situs</button>
    </div>
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tipe</label>
                <select id="filterTipe" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Tipe</option>
                    <option value="makam_leluhur">Makam Leluhur</option>
                    <option value="situs_adat">Situs Adat</option>
                    <option value="tempat_suci">Tempat Suci</option>
                    <option value="monumen">Monumen</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                <select id="filterMarga" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Marga</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status Konservasi</label>
                <select id="filterStatus" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Status</option>
                    <option value="terjaga">Terjaga</option>
                    <option value="terancam">Terancam</option>
                    <option value="rusak">Rusak</option>
                    <option value="hilang">Hilang</option>
                </select>
            </div>
        </div>
    </div>
    <div id="sitesList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
</div>
<div id="siteModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold">Tambah Situs Budaya</h2>
            <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        <form id="siteForm">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nama *</label>
                    <input type="text" id="siteNama" required class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tipe *</label>
                    <select id="siteTipe" required class="w-full border rounded-lg px-3 py-2">
                        <option value="makam_leluhur">Makam Leluhur</option>
                        <option value="situs_adat">Situs Adat</option>
                        <option value="tempat_suci">Tempat Suci</option>
                        <option value="monumen">Monumen</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                    <select id="siteMarga" class="w-full border rounded-lg px-3 py-2">
                        <option value="">Tidak ada marga spesifik</option>
                    </select>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <textarea id="siteDeskripsi" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Alamat</label>
                    <textarea id="siteAlamat" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kota</label>
                    <input type="text" id="siteKota" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Provinsi</label>
                    <input type="text" id="siteProvinsi" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Latitude</label>
                    <input type="number" id="siteLatitude" step="0.00000001" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                    <input type="number" id="siteLongitude" step="0.00000001" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Sejarah</label>
                    <textarea id="siteSejarah" rows="3" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status Konservasi</label>
                    <select id="siteStatus" class="w-full border rounded-lg px-3 py-2">
                        <option value="terjaga">Terjaga</option>
                        <option value="terancam">Terancam</option>
                        <option value="rusak">Rusak</option>
                        <option value="hilang">Hilang</option>
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
<?php include 'includes/footer.php'; ?>
