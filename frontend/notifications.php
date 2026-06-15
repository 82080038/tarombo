<?php
$extraJs = 'notifications.js';
include 'includes/header.php';
?>
<div class="container mx-auto px-4 py-8">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-gray-800">🔔 Notifikasi</h1>
        <div class="flex space-x-2">
            <button id="markAllReadBtn" class="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg auth-required">
                Tandai Semua Dibaca
            </button>
            <button id="refreshBtn" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
                🔄 Refresh
            </button>
        </div>
    </div>
    
    <!-- Notification Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Filter Status</label>
                <select id="filterStatus" class="w-full border rounded-lg px-3 py-2">
                    <option value="all">Semua</option>
                    <option value="unread">Belum Dibaca</option>
                    <option value="read">Sudah Dibaca</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tipe</label>
                <select id="filterType" class="w-full border rounded-lg px-3 py-2">
                    <option value="all">Semua Tipe</option>
                    <option value="info">Info</option>
                    <option value="success">Success</option>
                    <option value="warning">Warning</option>
                    <option value="error">Error</option>
                    <option value="system">System</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Entitas</label>
                <select id="filterEntity" class="w-full border rounded-lg px-3 py-2">
                    <option value="all">Semua Entitas</option>
                    <option value="person">Person</option>
                    <option value="asset">Asset</option>
                    <option value="transaction">Transaction</option>
                    <option value="oral_tradition">Tradisi Lisan</option>
                    <option value="traditional_knowledge">Pengetahuan Tradisional</option>
                    <option value="cultural_site">Situs Budaya</option>
                </select>
            </div>
            <div class="flex items-end">
                <button id="applyFilters" class="w-full bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg">
                    Terapkan Filter
                </button>
            </div>
        </div>
    </div>
    
    <!-- Unread Count -->
    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
        <div class="flex items-center justify-between">
            <div>
                <span class="text-blue-800 font-medium">Notifikasi Belum Dibaca:</span>
                <span id="unreadCount" class="text-2xl font-bold text-blue-600 ml-2">0</span>
            </div>
            <button id="showUnreadOnly" class="text-blue-600 hover:text-blue-800 text-sm">
                Tampilkan hanya yang belum dibaca
            </button>
        </div>
    </div>
    
    <!-- Notifications List -->
    <div id="notificationsList" class="space-y-3">
        <div class="text-center py-8 text-gray-500">
            <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            <p class="mt-2">Memuat notifikasi...</p>
        </div>
    </div>
    
    <!-- Empty State -->
    <div id="emptyState" class="hidden text-center py-12">
        <div class="text-6xl mb-4">🔕</div>
        <h3 class="text-xl font-medium text-gray-700 mb-2">Tidak ada notifikasi</h3>
        <p class="text-gray-500">Anda tidak memiliki notifikasi saat ini</p>
    </div>
</div>

<!-- Notification Detail Modal -->
<div id="notificationModal" class="fixed inset-0 bg-black bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-lg mx-4">
        <div class="p-6">
            <div class="flex justify-between items-start mb-4">
                <div>
                    <span id="modalType" class="px-2 py-1 text-xs rounded-full"></span>
                    <h2 id="modalTitle" class="text-xl font-bold mt-2"></h2>
                </div>
                <button id="closeModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
            </div>
            <div id="modalContent" class="text-gray-600 mb-4"></div>
            <div id="modalEntity" class="bg-gray-50 rounded-lg p-3 mb-4 hidden">
                <p class="text-sm"><strong>Entitas:</strong> <span id="modalEntityType"></span></p>
                <p class="text-sm"><strong>ID:</strong> <span id="modalEntityId"></span></p>
                <p class="text-sm"><strong>Aksi:</strong> <span id="modalAction"></span></p>
            </div>
            <div class="flex justify-between items-center text-sm text-gray-500">
                <span id="modalDate"></span>
                <button id="goToEntity" class="text-blue-600 hover:text-blue-800 hidden">
                    Lihat Entitas →
                </button>
            </div>
        </div>
    </div>
</div>

<?php include 'includes/footer.php'; ?>
