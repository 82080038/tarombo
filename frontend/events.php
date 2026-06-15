<?php
$extraJs = 'events.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">📅 Acara & Kalender</h1>
        <button id="addEventBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">+ Tambah Acara</button>
    </div>
    <div id="eventsList" class="space-y-4"></div>
    <div id="loadingState" class="text-center py-8 hidden"><div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div><p class="mt-2 text-gray-600">Memuat data...</p></div>
</div>
<div id="eventModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 p-6">
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-xl font-bold">Tambah Acara</h2>
            <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        <form id="eventForm">
            <div class="space-y-4">
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Judul *</label><input type="text" id="eventJudul" required class="w-full border rounded-lg px-3 py-2"></div>
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Tipe *</label><select id="eventTipe" required class="w-full border rounded-lg px-3 py-2"><option value="rapat_punguan">Rapat Punguan</option><option value="acara_adat">Acara Adat</option><option value="reuni_keluarga">Reuni Keluarga</option><option value="pernikahan">Pernikahan</option><option value="kematian">Kematian</option><option value="ulang_tahun">Ulang Tahun</option><option value="lainnya">Lainnya</option></select></div>
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Mulai *</label><input type="datetime-local" id="eventTanggalMulai" required class="w-full border rounded-lg px-3 py-2"></div>
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Selesai</label><input type="datetime-local" id="eventTanggalSelesai" class="w-full border rounded-lg px-3 py-2"></div>
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Lokasi</label><input type="text" id="eventLokasi" class="w-full border rounded-lg px-3 py-2"></div>
                <div><label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label><textarea id="eventDeskripsi" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea></div>
            </div>
            <div class="mt-6 flex justify-end space-x-3">
                <button type="button" id="cancelBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Simpan</button>
            </div>
        </form>
    </div>
</div>
<?php include 'includes/footer.php'; ?>
