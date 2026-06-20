const NotificationsAPI = {
    notifications: {
        getAll: (params) => fetch(`${API_BASE_URL}/communication/notifications?${new URLSearchParams(params)}`, {
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json()),
        markAsRead: (id) => fetch(`${API_BASE_URL}/communication/notifications/${id}/read`, {
            method: 'PUT',
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json()),
        markAllAsRead: () => fetch(`${API_BASE_URL}/communication/notifications/mark-all-read`, {
            method: 'PUT',
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json()),
        getUnreadCount: () => fetch(`${API_BASE_URL}/communication/notifications/unread-count`, {
            headers: { 'Authorization': `Bearer ${getAuthToken()}` }
        }).then(r => r.json())
    }
};

let currentNotifications = [];

document.addEventListener('DOMContentLoaded', () => {
    loadNotifications();
    loadUnreadCount();
    setupEventListeners();
});

function setupEventListeners() {
    document.getElementById('refreshBtn').addEventListener('click', () => {
        loadNotifications();
        loadUnreadCount();
    });
    document.getElementById('markAllReadBtn').addEventListener('click', markAllAsRead);
    document.getElementById('applyFilters').addEventListener('click', loadNotifications);
    document.getElementById('showUnreadOnly').addEventListener('click', () => {
        document.getElementById('filterStatus').value = 'unread';
        loadNotifications();
    });
    document.getElementById('closeModal').addEventListener('click', closeModal);
}

function loadNotifications() {
    const container = document.getElementById('notificationsList');
    const emptyState = document.getElementById('emptyState');

    const params = {
        status: document.getElementById('filterStatus').value === 'all' ? null : document.getElementById('filterStatus').value,
        type: document.getElementById('filterType').value === 'all' ? null : document.getElementById('filterType').value,
        entity_type: document.getElementById('filterEntity').value === 'all' ? null : document.getElementById('filterEntity').value
    };

    // Remove null params
    Object.keys(params).forEach(key => params[key] === null && delete params[key]);

    container.innerHTML = `
        <div class="text-center py-8 text-gray-500">
            <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            <p class="mt-2">Memuat notifikasi...</p>
        </div>
    `;

    NotificationsAPI.notifications.getAll(params)
        .then(response => {
            if (response.success) {
                currentNotifications = response.data;
                renderNotifications(response.data);
            } else {
                container.innerHTML = '<p class="text-red-500 text-center py-8">Gagal memuat notifikasi</p>';
            }
        })
        .catch(error => {
            console.error('Error loading notifications:', error);
            container.innerHTML = '<p class="text-red-500 text-center py-8">Terjadi kesalahan saat memuat notifikasi</p>';
        });
}

function renderNotifications(notifications) {
    const container = document.getElementById('notificationsList');
    const emptyState = document.getElementById('emptyState');

    if (notifications.length === 0) {
        container.innerHTML = '';
        emptyState.classList.remove('hidden');
        return;
    }

    emptyState.classList.add('hidden');

    container.innerHTML = notifications.map(n => `
        <div class="bg-white rounded-lg shadow p-4 border-l-4 ${getTypeBorderColor(n.type)} ${!n.is_read ? 'bg-blue-50' : ''} cursor-pointer hover:shadow-md transition-shadow" onclick="viewNotification(${n.id})">
            <div class="flex justify-between items-start">
                <div class="flex-1">
                    <div class="flex items-center space-x-2 mb-2">
                        <span class="px-2 py-1 text-xs rounded-full ${getTypeColor(n.type)}">${formatType(n.type)}</span>
                        ${!n.is_read ? '<span class="w-2 h-2 bg-blue-600 rounded-full"></span>' : ''}
                    </div>
                    <h3 class="font-bold text-lg mb-1">${n.title}</h3>
                    <p class="text-gray-600 text-sm mb-2">${n.message}</p>
                    ${n.entity_type ? `
                        <div class="text-xs text-gray-500">
                            <span class="bg-gray-100 px-2 py-1 rounded">${formatEntityType(n.entity_type)}</span>
                            ${n.action ? `<span class="ml-2">${formatAction(n.action)}</span>` : ''}
                        </div>
                    ` : ''}
                </div>
                <div class="text-xs text-gray-500 ml-4">
                    ${formatDate(n.created_at)}
                </div>
            </div>
        </div>
    `).join('');
}

function loadUnreadCount() {
    NotificationsAPI.notifications.getUnreadCount()
        .then(response => {
            if (response.success) {
                document.getElementById('unreadCount').textContent = response.data.count;
            }
        })
        .catch(error => {
            console.error('Error loading unread count:', error);
        });
}

function viewNotification(id) {
    const notification = currentNotifications.find(n => n.id === id);
    if (!notification) return;

    // Mark as read
    if (!notification.is_read) {
        NotificationsAPI.notifications.markAsRead(id)
            .then(response => {
                if (response.success) {
                    notification.is_read = true;
                    loadUnreadCount();
                    renderNotifications(currentNotifications);
                }
            });
    }

    // Show modal
    const modal = document.getElementById('notificationModal');
    const modalType = document.getElementById('modalType');
    const modalTitle = document.getElementById('modalTitle');
    const modalContent = document.getElementById('modalContent');
    const modalEntity = document.getElementById('modalEntity');
    const modalEntityType = document.getElementById('modalEntityType');
    const modalEntityId = document.getElementById('modalEntityId');
    const modalAction = document.getElementById('modalAction');
    const modalDate = document.getElementById('modalDate');
    const goToEntity = document.getElementById('goToEntity');

    modalType.textContent = formatType(notification.type);
    modalType.className = `px-2 py-1 text-xs rounded-full ${getTypeColor(notification.type)}`;
    modalTitle.textContent = notification.title;
    modalContent.textContent = notification.message;
    modalDate.textContent = formatDate(notification.created_at);

    if (notification.entity_type) {
        modalEntity.classList.remove('hidden');
        modalEntityType.textContent = formatEntityType(notification.entity_type);
        modalEntityId.textContent = notification.entity_id;
        modalAction.textContent = formatAction(notification.action);

        goToEntity.classList.remove('hidden');
        goToEntity.onclick = () => {
            window.location.href = `/${notification.entity_type === 'person' ? 'person-detail' : notification.entity_type}.php?id=${notification.entity_id}`;
        };
    } else {
        modalEntity.classList.add('hidden');
        goToEntity.classList.add('hidden');
    }

    modal.classList.remove('hidden');
}

function closeModal() {
    document.getElementById('notificationModal').classList.add('hidden');
}

function markAllAsRead() {
    NotificationsAPI.notifications.markAllAsRead()
        .then(response => {
            if (response.success) {
                Toast.success('Semua notifikasi ditandai sebagai dibaca');
                loadNotifications();
                loadUnreadCount();
            } else {
                Toast.error('Gagal menandai semua notifikasi');
            }
        })
        .catch(error => {
            console.error('Error marking all as read:', error);
            Toast.error('Terjadi kesalahan');
        });
}

function formatType(type) {
    const types = {
        'info': 'Info',
        'success': 'Success',
        'warning': 'Warning',
        'error': 'Error',
        'system': 'System'
    };
    return types[type] || type;
}

function formatEntityType(type) {
    const types = {
        'person': 'Person',
        'asset': 'Asset',
        'transaction': 'Transaction',
        'oral_tradition': 'Tradisi Lisan',
        'traditional_knowledge': 'Pengetahuan Tradisional',
        'cultural_site': 'Situs Budaya'
    };
    return types[type] || type;
}

function formatAction(action) {
    const actions = {
        'created': 'Dibuat',
        'updated': 'Diperbarui',
        'deleted': 'Dihapus',
        'transferred': 'Ditransfer',
        'verified': 'Diverifikasi'
    };
    return actions[action] || action;
}

function getTypeColor(type) {
    const colors = {
        'info': 'bg-blue-100 text-blue-800',
        'success': 'bg-green-100 text-green-800',
        'warning': 'bg-yellow-100 text-yellow-800',
        'error': 'bg-red-100 text-red-800',
        'system': 'bg-gray-100 text-gray-800'
    };
    return colors[type] || 'bg-gray-100 text-gray-800';
}

function getTypeBorderColor(type) {
    const colors = {
        'info': 'border-blue-500',
        'success': 'border-green-500',
        'warning': 'border-yellow-500',
        'error': 'border-red-500',
        'system': 'border-gray-500'
    };
    return colors[type] || 'border-gray-500';
}

function formatDate(date) {
    if (!date) return '-';
    const d = new Date(date);
    const now = new Date();
    const diff = now - d;

    if (diff < 60000) return 'Baru saja';
    if (diff < 3600000) return `${Math.floor(diff / 60000)} menit lalu`;
    if (diff < 86400000) return `${Math.floor(diff / 3600000)} jam lalu`;
    if (diff < 604800000) return `${Math.floor(diff / 86400000)} hari lalu`;

    return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });
}
