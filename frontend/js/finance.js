const API = {
    finance: {
        getTransactions: (params) => fetch(`${API_BASE_URL}/finance/transactions?${new URLSearchParams(params)}`).then(r => r.json()),
        createTransaction: (data) => fetch(`${API_BASE_URL}/finance/transactions`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        verifyTransaction: (id) => fetch(`${API_BASE_URL}/finance/transactions/${id}/verify`, {
            method: 'PUT',
            headers: { 'Authorization': `Bearer ${getToken()}` }
        }).then(r => r.json()),
        getBudgets: (params) => fetch(`${API_BASE_URL}/finance/budgets?${new URLSearchParams(params)}`).then(r => r.json()),
        createBudget: (data) => fetch(`${API_BASE_URL}/finance/budgets`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        getIuran: (params) => fetch(`${API_BASE_URL}/finance/iuran?${new URLSearchParams(params)}`).then(r => r.json()),
        createIuran: (data) => fetch(`${API_BASE_URL}/finance/iuran`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        payIuran: (id, data) => fetch(`${API_BASE_URL}/finance/iuran/${id}/pay`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${getToken()}` },
            body: JSON.stringify(data)
        }).then(r => r.json()),
        getSummary: (params) => fetch(`${API_BASE_URL}/finance/summary?${new URLSearchParams(params)}`).then(r => r.json())
    },
    persons: {
        getAll: () => fetch(`${API_BASE_URL}/persons`).then(r => r.json())
    }
};

document.addEventListener('DOMContentLoaded', () => {
    loadFinancialSummary();
    loadTransactions();
    loadBudgets();
    loadIuran();
    loadPersons();
    setupEventListeners();
});

function loadFinancialSummary() {
    API.finance.getSummary({ tahun: new Date().getFullYear() })
        .then(response => {
            if (response.success) {
                document.getElementById('totalPemasukan').textContent = formatCurrency(response.data.pemasukan);
                document.getElementById('totalPengeluaran').textContent = formatCurrency(response.data.pengeluaran);
                document.getElementById('totalSaldo').textContent = formatCurrency(response.data.saldo);
                document.getElementById('sisaAnggaran').textContent = formatCurrency(response.data.sisa_anggaran);
            }
        });
}

function loadTransactions() {
    API.finance.getTransactions({})
        .then(response => {
            if (response.success) {
                renderTransactions(response.data);
            }
        });
}

function renderTransactions(transactions) {
    const container = document.getElementById('transactionsList');
    
    if (transactions.length === 0) {
        container.innerHTML = '<tr><td colspan="7" class="px-6 py-4 text-center text-gray-500">Tidak ada transaksi</td></tr>';
        return;
    }
    
    container.innerHTML = transactions.map(t => `
        <tr>
            <td class="px-6 py-4 whitespace-nowrap">${formatDate(t.tanggal)}</td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-2 py-1 text-xs rounded-full ${t.tipe === 'masuk' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                    ${t.tipe === 'masuk' ? 'Pemasukan' : 'Pengeluaran'}
                </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">${formatKategori(t.kategori)}</td>
            <td class="px-6 py-4 whitespace-nowrap font-medium ${t.tipe === 'masuk' ? 'text-green-600' : 'text-red-600'}">
                ${formatCurrency(t.jumlah)}
            </td>
            <td class="px-6 py-4 whitespace-nowrap">${t.deskripsi || '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-2 py-1 text-xs rounded-full ${getStatusColor(t.status)}">${formatStatus(t.status)}</span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
                ${t.status === 'pending' ? `<button onclick="verifyTransaction(${t.id})" class="text-green-600 hover:text-green-800 text-sm auth-required">Verifikasi</button>` : '-'}
            </td>
        </tr>
    `).join('');
    
    applyRBAC();
}

function loadBudgets() {
    API.finance.getBudgets({ tahun: new Date().getFullYear() })
        .then(response => {
            if (response.success) {
                renderBudgets(response.data);
            }
        });
}

function renderBudgets(budgets) {
    const container = document.getElementById('budgetsList');
    
    if (budgets.length === 0) {
        container.innerHTML = '<tr><td colspan="6" class="px-6 py-4 text-center text-gray-500">Tidak ada anggaran</td></tr>';
        return;
    }
    
    container.innerHTML = budgets.map(b => `
        <tr>
            <td class="px-6 py-4 whitespace-nowrap">${b.tahun}</td>
            <td class="px-6 py-4 whitespace-nowrap">${b.kategori}</td>
            <td class="px-6 py-4 whitespace-nowrap">${formatCurrency(b.anggaran)}</td>
            <td class="px-6 py-4 whitespace-nowrap">${formatCurrency(b.terpakai)}</td>
            <td class="px-6 py-4 whitespace-nowrap font-medium ${b.anggaran - b.terpakai >= 0 ? 'text-green-600' : 'text-red-600'}">
                ${formatCurrency(b.anggaran - b.terpakai)}
            </td>
            <td class="px-6 py-4 whitespace-nowrap">${b.deskripsi || '-'}</td>
        </tr>
    `).join('');
}

function loadIuran() {
    API.finance.getIuran({})
        .then(response => {
            if (response.success) {
                renderIuran(response.data);
            }
        });
}

function renderIuran(iuranList) {
    const container = document.getElementById('iuranList');
    
    if (iuranList.length === 0) {
        container.innerHTML = '<tr><td colspan="6" class="px-6 py-4 text-center text-gray-500">Tidak ada iuran</td></tr>';
        return;
    }
    
    container.innerHTML = iuranList.map(i => `
        <tr>
            <td class="px-6 py-4 whitespace-nowrap">${i.person ? i.person.nama : 'Tidak ada'}</td>
            <td class="px-6 py-4 whitespace-nowrap">${formatCurrency(i.jumlah)}</td>
            <td class="px-6 py-4 whitespace-nowrap">${formatPeriode(i.periode)}</td>
            <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-2 py-1 text-xs rounded-full ${i.status === 'lunas' ? 'bg-green-100 text-green-800' : i.status === 'terlambat' ? 'bg-red-100 text-red-800' : 'bg-yellow-100 text-yellow-800'}">
                    ${formatStatus(i.status)}
                </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">${i.tanggal_bayar ? formatDate(i.tanggal_bayar) : '-'}</td>
            <td class="px-6 py-4 whitespace-nowrap">
                ${i.status !== 'lunas' ? `<button onclick="payIuran(${i.id})" class="text-green-600 hover:text-green-800 text-sm auth-required">Bayar</button>` : '-'}
            </td>
        </tr>
    `).join('');
    
    applyRBAC();
}

function loadPersons() {
    API.persons.getAll()
        .then(response => {
            if (response.success) {
                const select = document.getElementById('iuranPerson');
                const options = response.data.map(p => `<option value="${p.id}">${p.nama}</option>`).join('');
                select.innerHTML = '<option value="">Pilih anggota</option>' + options;
            }
        });
}

function setupEventListeners() {
    document.getElementById('addTransactionBtn').addEventListener('click', () => openTransactionModal());
    document.getElementById('closeTransactionModal').addEventListener('click', closeTransactionModal);
    document.getElementById('cancelTransactionBtn').addEventListener('click', closeTransactionModal);
    document.getElementById('transactionForm').addEventListener('submit', saveTransaction);
    
    document.getElementById('addBudgetBtn').addEventListener('click', () => openBudgetModal());
    document.getElementById('closeBudgetModal').addEventListener('click', closeBudgetModal);
    document.getElementById('cancelBudgetBtn').addEventListener('click', closeBudgetModal);
    document.getElementById('budgetForm').addEventListener('submit', saveBudget);
    
    document.getElementById('addIuranBtn').addEventListener('click', () => openIuranModal());
    document.getElementById('closeIuranModal').addEventListener('click', closeIuranModal);
    document.getElementById('cancelIuranBtn').addEventListener('click', closeIuranModal);
    document.getElementById('iuranForm').addEventListener('submit', saveIuran);
}

function switchTab(tab) {
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('border-blue-500', 'text-blue-600');
        btn.classList.add('border-transparent', 'text-gray-500');
    });
    
    document.getElementById('tab' + tab.charAt(0).toUpperCase() + tab.slice(1)).classList.remove('border-transparent', 'text-gray-500');
    document.getElementById('tab' + tab.charAt(0).toUpperCase() + tab.slice(1)).classList.add('border-blue-500', 'text-blue-600');
    
    document.getElementById('transactionsTab').classList.add('hidden');
    document.getElementById('budgetsTab').classList.add('hidden');
    document.getElementById('iuranTab').classList.add('hidden');
    document.getElementById(tab + 'Tab').classList.remove('hidden');
}

function openTransactionModal() {
    document.getElementById('transactionModal').classList.remove('hidden');
    document.getElementById('transactionTanggal').value = new Date().toISOString().split('T')[0];
}

function closeTransactionModal() {
    document.getElementById('transactionModal').classList.add('hidden');
    document.getElementById('transactionForm').reset();
}

function saveTransaction(e) {
    e.preventDefault();
    
    const data = {
        punguan_id: 1,
        tipe: document.getElementById('transactionTipe').value,
        kategori: document.getElementById('transactionKategori').value,
        jumlah: document.getElementById('transactionJumlah').value,
        tanggal: document.getElementById('transactionTanggal').value,
        deskripsi: document.getElementById('transactionDeskripsi').value
    };
    
    API.finance.createTransaction(data)
        .then(response => {
            if (response.success) {
                Toast.success('Transaksi berhasil ditambahkan');
                closeTransactionModal();
                loadTransactions();
                loadFinancialSummary();
            } else {
                Toast.error(response.error || 'Gagal menambahkan transaksi');
            }
        });
}

function verifyTransaction(id) {
    API.finance.verifyTransaction(id)
        .then(response => {
            if (response.success) {
                Toast.success('Transaksi berhasil diverifikasi');
                loadTransactions();
                loadFinancialSummary();
            } else {
                Toast.error(response.error || 'Gagal memverifikasi transaksi');
            }
        });
}

function openBudgetModal() {
    document.getElementById('budgetModal').classList.remove('hidden');
    document.getElementById('budgetTahun').value = new Date().getFullYear();
}

function closeBudgetModal() {
    document.getElementById('budgetModal').classList.add('hidden');
    document.getElementById('budgetForm').reset();
}

function saveBudget(e) {
    e.preventDefault();
    
    const data = {
        punguan_id: 1,
        tahun: document.getElementById('budgetTahun').value,
        kategori: document.getElementById('budgetKategori').value,
        anggaran: document.getElementById('budgetAnggaran').value,
        deskripsi: document.getElementById('budgetDeskripsi').value
    };
    
    API.finance.createBudget(data)
        .then(response => {
            if (response.success) {
                Toast.success('Anggaran berhasil ditambahkan');
                closeBudgetModal();
                loadBudgets();
                loadFinancialSummary();
            } else {
                Toast.error(response.error || 'Gagal menambahkan anggaran');
            }
        });
}

function openIuranModal() {
    document.getElementById('iuranModal').classList.remove('hidden');
}

function closeIuranModal() {
    document.getElementById('iuranModal').classList.add('hidden');
    document.getElementById('iuranForm').reset();
}

function saveIuran(e) {
    e.preventDefault();
    
    const data = {
        punguan_id: 1,
        person_id: document.getElementById('iuranPerson').value || null,
        jumlah: document.getElementById('iuranJumlah').value,
        periode: document.getElementById('iuranPeriode').value
    };
    
    API.finance.createIuran(data)
        .then(response => {
            if (response.success) {
                Toast.success('Iuran berhasil ditambahkan');
                closeIuranModal();
                loadIuran();
            } else {
                Toast.error(response.error || 'Gagal menambahkan iuran');
            }
        });
}

function payIuran(id) {
    API.finance.payIuran(id, { tanggal_bayar: new Date().toISOString().split('T')[0] })
        .then(response => {
            if (response.success) {
                Toast.success('Iuran berhasil dibayar');
                loadIuran();
            } else {
                Toast.error(response.error || 'Gagal membayar iuran');
            }
        });
}

function formatCurrency(value) {
    if (!value) return 'Rp 0';
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value);
}

function formatDate(date) {
    if (!date) return '-';
    return new Date(date).toLocaleDateString('id-ID');
}

function formatKategori(kategori) {
    const categories = {
        'iuran': 'Iuran',
        'sumbangan': 'Sumbangan',
        'acara_adat': 'Acara Adat',
        'sosial': 'Sosial',
        'operasional': 'Operasional',
        'pembangunan': 'Pembangunan',
        'lainnya': 'Lainnya'
    };
    return categories[kategori] || kategori;
}

function formatStatus(status) {
    const statuses = {
        'pending': 'Pending',
        'verified': 'Terverifikasi',
        'rejected': 'Ditolak',
        'lunas': 'Lunas',
        'belum': 'Belum',
        'terlambat': 'Terlambat'
    };
    return statuses[status] || status;
}

function formatPeriode(periode) {
    const periodes = {
        'bulanan': 'Bulanan',
        'tahunan': 'Tahunan',
        'sekali': 'Sekali'
    };
    return periodes[periode] || periode;
}

function getStatusColor(status) {
    const colors = {
        'pending': 'bg-yellow-100 text-yellow-800',
        'verified': 'bg-green-100 text-green-800',
        'rejected': 'bg-red-100 text-red-800',
        'lunas': 'bg-green-100 text-green-800',
        'belum': 'bg-yellow-100 text-yellow-800',
        'terlambat': 'bg-red-100 text-red-800'
    };
    return colors[status] || 'bg-gray-100 text-gray-800';
}
