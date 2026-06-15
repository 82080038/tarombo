<?php
$extraJs = 'traditional-knowledge.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🌱 Pengetahuan Tradisional</h1>
        <button id="addKnowledgeBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">+ Tambah Pengetahuan</button>
    </div>
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
                <select id="filterKategori" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Kategori</option>
                    <option value="pertanian">Pertanian</option>
                    <option value="obat_tradisional">Obat Tradisional</option>
                    <option value="konservasi">Konservasi</option>
                    <option value="kerajinan">Kerajinan</option>
                    <option value="kuliner">Kuliner</option>
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
                    <option value="terancam">Terancam</option>
                    <option value="punah">Punah</option>
                </select>
            </div>
        </div>
    </div>
    <div id="knowledgeList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
</div>
<div id="knowledgeModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold">Tambah Pengetahuan Tradisional</h2>
            <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        <form id="knowledgeForm">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Judul *</label>
                    <input type="text" id="knowledgeJudul" required class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kategori *</label>
                    <select id="knowledgeKategori" required class="w-full border rounded-lg px-3 py-2">
                        <option value="pertanian">Pertanian</option>
                        <option value="obat_tradisional">Obat Tradisional</option>
                        <option value="konservasi">Konservasi</option>
                        <option value="kerajinan">Kerajinan</option>
                        <option value="kuliner">Kuliner</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                    <select id="knowledgeMarga" class="w-full border rounded-lg px-3 py-2">
                        <option value="">Tidak ada marga spesifik</option>
                    </select>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi *</label>
                    <textarea id="knowledgeDeskripsi" rows="3" required class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Metode</label>
                    <textarea id="knowledgeMetode" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Bahan</label>
                    <textarea id="knowledgeBahan" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Alat</label>
                    <textarea id="knowledgeAlat" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Manfaat</label>
                    <textarea id="knowledgeManfaat" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Larangan</label>
                    <textarea id="knowledgeLarangan" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Daerah</label>
                    <input type="text" id="knowledgeDaerah" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Pengetahuan Dari</label>
                    <input type="text" id="knowledgeSumber" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Dokumentasi</label>
                    <input type="date" id="knowledgeTanggal" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select id="knowledgeStatus" class="w-full border rounded-lg px-3 py-2">
                        <option value="aktif">Aktif</option>
                        <option value="terancam">Terancam</option>
                        <option value="punah">Punah</option>
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
