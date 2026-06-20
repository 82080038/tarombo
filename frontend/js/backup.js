const BackupAPI = {
    backup: {
        export: (type) => fetch(`${API_BASE_URL}/backup/export${type !== 'all' ? '/' + type : ''}`, {
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.blob()),
        import: (file) => {
            const formData = new FormData();
            formData.append('backup', file);
            return fetch(`${API_BASE_URL}/backup/import`, {
                method: 'POST',
                headers: { 'Authorization': `Bearer ${getAuthToken()}` },
                body: formData
            }).then(r => r.json());
        },
        getHistory: () => fetch(`${API_BASE_URL}/backup/history`, {
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json())
    }
};

document.addEventListener('DOMContentLoaded', () => {
    loadBackupHistory();
    setupEventListeners();
});

function setupEventListeners() {
    document.getElementById('exportBtn').addEventListener('click', exportData);
    document.getElementById('importFile').addEventListener('change', handleFileSelect);
    document.getElementById('importBtn').addEventListener('click', importData);
    document.getElementById('closeImportModal').addEventListener('click', closeImportModal);
}

function exportData() {
    const type = document.getElementById('exportType').value;
    
    Toast.info('Memulai export data...');
    
    BackupAPI.backup.export(type)
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `tarombo_backup_${type}_${new Date().toISOString().split('T')[0]}.json`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
            Toast.success('Backup berhasil didownload');
        })
        .catch(error => {
            console.error('Export error:', error);
            Toast.error('Gagal melakukan export data');
        });
}

function handleFileSelect(e) {
    const file = e.target.files[0];
    const importBtn = document.getElementById('importBtn');
    const preview = document.getElementById('importPreview');
    const previewContent = document.getElementById('previewContent');
    
    if (file) {
        importBtn.disabled = false;
        
        // Preview file
        const reader = new FileReader();
        reader.onload = (event) => {
            try {
                const data = JSON.parse(event.target.result);
                preview.classList.remove('hidden');
                previewContent.innerHTML = `
                    <p><strong>Version:</strong> ${data.version || 'Unknown'}</p>
                    <p><strong>Exported:</strong> ${data.exported_at || 'Unknown'}</p>
                    <p><strong>Tables:</strong> ${Object.keys(data.data || {}).length}</p>
                    <p><strong>Size:</strong> ${(file.size / 1024).toFixed(2)} KB</p>
                `;
            } catch (error) {
                preview.classList.remove('hidden');
                previewContent.innerHTML = '<p class="text-red-600">File tidak valid atau bukan format JSON</p>';
                importBtn.disabled = true;
            }
        };
        reader.readAsText(file);
    } else {
        importBtn.disabled = true;
        preview.classList.add('hidden');
    }
}

function importData() {
    const file = document.getElementById('importFile').files[0];
    if (!file) {
        Toast.error('Pilih file backup terlebih dahulu');
        return;
    }
    
    if (!confirm('PERINGATAN: Import akan menimpa data yang ada. Lanjutkan?')) {
        return;
    }
    
    const modal = document.getElementById('importModal');
    const progress = document.getElementById('importProgress');
    const status = document.getElementById('importStatus');
    const results = document.getElementById('importResults');
    const resultsContent = document.getElementById('resultsContent');
    const closeBtn = document.getElementById('closeImportModal');
    
    modal.classList.remove('hidden');
    progress.style.width = '0%';
    status.textContent = 'Memulai import...';
    results.classList.add('hidden');
    closeBtn.classList.add('hidden');
    
    // Simulate progress
    let progressValue = 0;
    const progressInterval = setInterval(() => {
        progressValue += 10;
        if (progressValue < 90) {
            progress.style.width = progressValue + '%';
        }
    }, 200);
    
    BackupAPI.backup.import(file)
        .then(response => {
            clearInterval(progressInterval);
            progress.style.width = '100%';
            
            if (response.success) {
                status.textContent = 'Import berhasil!';
                status.classList.add('text-green-600');
                
                results.classList.remove('hidden');
                resultsContent.innerHTML = `
                    <p class="text-green-600 mb-2">✓ Data berhasil diimport</p>
                    <p><strong>Tables imported:</strong> ${response.imported_tables.join(', ')}</p>
                    ${response.errors && response.errors.length > 0 ? `
                        <p class="text-orange-600 mt-2"><strong>Errors:</strong></p>
                        <ul class="list-disc list-inside text-sm">
                            ${response.errors.map(e => `<li>${e.table}: ${e.error}</li>`).join('')}
                        </ul>
                    ` : ''}
                `;
                
                Toast.success('Data berhasil diimport');
                loadBackupHistory();
            } else {
                status.textContent = 'Import gagal!';
                status.classList.add('text-red-600');
                
                results.classList.remove('hidden');
                resultsContent.innerHTML = `<p class="text-red-600">${response.error}</p>`;
                
                Toast.error('Gagal mengimport data');
            }
        })
        .catch(error => {
            clearInterval(progressInterval);
            progress.style.width = '100%';
            status.textContent = 'Import gagal!';
            status.classList.add('text-red-600');
            
            results.classList.remove('hidden');
            resultsContent.innerHTML = `<p class="text-red-600">Terjadi kesalahan: ${error.message}</p>`;
            
            Toast.error('Terjadi kesalahan saat import');
        })
        .finally(() => {
            closeBtn.classList.remove('hidden');
        });
}

function closeImportModal() {
    document.getElementById('importModal').classList.add('hidden');
    document.getElementById('importFile').value = '';
    document.getElementById('importBtn').disabled = true;
    document.getElementById('importPreview').classList.add('hidden');
}

function loadBackupHistory() {
    const container = document.getElementById('backupHistory');
    
    BackupAPI.backup.getHistory()
        .then(response => {
            if (response.success) {
                if (response.data.length === 0) {
                    container.innerHTML = '<p class="text-gray-500">Belum ada riwayat backup</p>';
                    return;
                }
                
                container.innerHTML = response.data.map(record => `
                    <div class="border-l-4 border-blue-500 pl-3 py-2">
                        <div class="flex justify-between items-start">
                            <span class="px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">${record.action}</span>
                            <span class="text-xs text-gray-500">${new Date(record.changed_at).toLocaleString('id-ID')}</span>
                        </div>
                        <p class="text-sm font-medium">${record.entity_type} #${record.entity_id}</p>
                        <p class="text-xs text-gray-500">${record.changed_by ? 'Oleh: ' + record.changed_by : 'System'}</p>
                    </div>
                `).join('');
            } else {
                container.innerHTML = '<p class="text-gray-500">Gagal memuat riwayat backup</p>';
            }
        })
        .catch(error => {
            console.error('Error loading backup history:', error);
            container.innerHTML = '<p class="text-gray-500">Terjadi kesalahan saat memuat riwayat</p>';
        });
}
