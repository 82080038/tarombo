<?php
$extraJs = 'oral-traditions.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🎤 Tradisi Lisan Batak</h1>
        <button id="addTraditionBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">+ Tambah Tradisi</button>
    </div>
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
                <select id="filterKategori" class="w-full border rounded-lg px-3 py-2">
                    <option value="">Semua Kategori</option>
                    <option value="umpasa">Umpasa</option>
                    <option value="cerita_rakyat">Cerita Rakyat</option>
                    <option value="lagu_adat">Lagu Adat</option>
                    <option value="mantra">Mantra</option>
                    <option value="doa">Doa Adat</option>
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
    <div id="traditionsList" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
</div>
<div id="traditionModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold">Tambah Tradisi Lisan</h2>
            <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        <form id="traditionForm">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Judul *</label>
                    <input type="text" id="traditionJudul" required class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kategori *</label>
                    <select id="traditionKategori" required class="w-full border rounded-lg px-3 py-2">
                        <option value="umpasa">Umpasa</option>
                        <option value="cerita_rakyat">Cerita Rakyat</option>
                        <option value="lagu_adat">Lagu Adat</option>
                        <option value="mantra">Mantra</option>
                        <option value="doa">Doa Adat</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Marga</label>
                    <select id="traditionMarga" class="w-full border rounded-lg px-3 py-2">
                        <option value="">Tidak ada marga spesifik</option>
                    </select>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Konten *</label>
                    <textarea id="traditionKonten" rows="3" required class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Bahasa Asli</label>
                    <textarea id="traditionBahasaAsli" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Terjemahan</label>
                    <textarea id="traditionTerjemahan" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Transliterasi</label>
                    <textarea id="traditionTransliterasi" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Daerah</label>
                    <input type="text" id="traditionDaerah" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Narator</label>
                    <input type="text" id="traditionNarator" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Rekam</label>
                    <input type="date" id="traditionTanggal" class="w-full border rounded-lg px-3 py-2">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select id="traditionStatus" class="w-full border rounded-lg px-3 py-2">
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
