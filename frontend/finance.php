<?php
$extraJs = 'finance.js';
include 'includes/header.php';
?>

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-gray-800 mb-6">💰 Keuangan Punguan</h1>

    <!-- Financial Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div class="bg-white rounded-lg shadow p-4">
            <h3 class="text-sm font-medium text-gray-500">Pemasukan</h3>
            <p id="totalPemasukan" class="text-2xl font-bold text-green-600">Rp 0</p>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <h3 class="text-sm font-medium text-gray-500">Pengeluaran</h3>
            <p id="totalPengeluaran" class="text-2xl font-bold text-red-600">Rp 0</p>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <h3 class="text-sm font-medium text-gray-500">Saldo</h3>
            <p id="totalSaldo" class="text-2xl font-bold text-blue-600">Rp 0</p>
        </div>
        <div class="bg-white rounded-lg shadow p-4">
            <h3 class="text-sm font-medium text-gray-500">Sisa Anggaran</h3>
            <p id="sisaAnggaran" class="text-2xl font-bold text-purple-600">Rp 0</p>
        </div>
    </div>

    <!-- Tabs -->
    <div class="bg-white rounded-lg shadow mb-6">
        <div class="border-b">
            <nav class="flex space-x-4 px-4">
                <button onclick="switchTab('transactions')" id="tabTransactions" class="tab-btn py-4 px-1 border-b-2 border-blue-500 text-blue-600 font-medium">
                    Transaksi
                </button>
                <button onclick="switchTab('budgets')" id="tabBudgets" class="tab-btn py-4 px-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 font-medium">
                    Anggaran
                </button>
                <button onclick="switchTab('iuran')" id="tabIuran" class="tab-btn py-4 px-1 border-b-2 border-transparent text-gray-500 hover:text-gray-700 font-medium">
                    Iuran
                </button>
            </nav>
        </div>

        <!-- Transactions Tab -->
        <div id="transactionsTab" class="p-4">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Daftar Transaksi</h2>
                <button id="addTransactionBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                    + Tambah Transaksi
                </button>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tipe</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kategori</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jumlah</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Deskripsi</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Aksi</th>
                        </tr>
                    </thead>
                    <tbody id="transactionsList" class="bg-white divide-y divide-gray-200">
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Budgets Tab -->
        <div id="budgetsTab" class="p-4 hidden">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Daftar Anggaran</h2>
                <button id="addBudgetBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                    + Tambah Anggaran
                </button>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tahun</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Kategori</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Anggaran</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Terpakai</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Sisa</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Deskripsi</th>
                        </tr>
                    </thead>
                    <tbody id="budgetsList" class="bg-white divide-y divide-gray-200">
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Iuran Tab -->
        <div id="iuranTab" class="p-4 hidden">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Daftar Iuran</h2>
                <button id="addIuranBtn" class="auth-required bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                    + Tambah Iuran
                </button>
            </div>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Anggota</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jumlah</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Periode</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal Bayar</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Aksi</th>
                        </tr>
                    </thead>
                    <tbody id="iuranList" class="bg-white divide-y divide-gray-200">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Transaction Modal -->
<div id="transactionModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Tambah Transaksi</h2>
                <button id="closeTransactionModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="transactionForm">
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tipe *</label>
                        <select id="transactionTipe" required class="w-full border rounded-lg px-3 py-2">
                            <option value="masuk">Pemasukan</option>
                            <option value="keluar">Pengeluaran</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kategori *</label>
                        <select id="transactionKategori" required class="w-full border rounded-lg px-3 py-2">
                            <option value="iuran">Iuran</option>
                            <option value="sumbangan">Sumbangan</option>
                            <option value="acara_adat">Acara Adat</option>
                            <option value="sosial">Sosial</option>
                            <option value="operasional">Operasional</option>
                            <option value="pembangunan">Pembangunan</option>
                            <option value="lainnya">Lainnya</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah *</label>
                        <input type="number" id="transactionJumlah" required step="0.01" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal *</label>
                        <input type="date" id="transactionTanggal" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                        <textarea id="transactionDeskripsi" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                </div>
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancelTransactionBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Budget Modal -->
<div id="budgetModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Tambah Anggaran</h2>
                <button id="closeBudgetModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="budgetForm">
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tahun *</label>
                        <input type="number" id="budgetTahun" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Kategori *</label>
                        <input type="text" id="budgetKategori" required class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Anggaran *</label>
                        <input type="number" id="budgetAnggaran" required step="0.01" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                        <textarea id="budgetDeskripsi" rows="2" class="w-full border rounded-lg px-3 py-2"></textarea>
                    </div>
                </div>
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancelBudgetBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Iuran Modal -->
<div id="iuranModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
        <div class="p-6">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Tambah Iuran</h2>
                <button id="closeIuranModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <form id="iuranForm">
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Anggota</label>
                        <select id="iuranPerson" class="w-full border rounded-lg px-3 py-2">
                            <option value="">Pilih anggota</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah *</label>
                        <input type="number" id="iuranJumlah" required step="0.01" class="w-full border rounded-lg px-3 py-2">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Periode *</label>
                        <select id="iuranPeriode" required class="w-full border rounded-lg px-3 py-2">
                            <option value="bulanan">Bulanan</option>
                            <option value="tahunan">Tahunan</option>
                            <option value="sekali">Sekali</option>
                        </select>
                    </div>
                </div>
                <div class="mt-6 flex justify-end space-x-3">
                    <button type="button" id="cancelIuranBtn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">Batal</button>
                    <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>
