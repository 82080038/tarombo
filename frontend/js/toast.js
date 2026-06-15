// Toast Notification System
// Replaces alert() with better UI feedback

const Toast = {
    show: function(message, type = 'info', duration = 3000) {
        // Remove existing toast if any
        const existing = document.querySelector('.toast-notification');
        if (existing) {
            existing.remove();
        }

        // Create toast element
        const toast = document.createElement('div');
        toast.className = `toast-notification toast-${type}`;
        
        const icons = {
            success: '✓',
            error: '✕',
            warning: '⚠',
            info: 'ℹ'
        };

        toast.innerHTML = `
            <div class="toast-content">
                <span class="toast-icon">${icons[type] || icons.info}</span>
                <span class="toast-message">${message}</span>
                <button class="toast-close">&times;</button>
            </div>
        `;

        // Add styles
        const style = document.createElement('style');
        style.textContent = `
            .toast-notification {
                position: fixed;
                top: 20px;
                right: 20px;
                min-width: 300px;
                max-width: 400px;
                padding: 16px;
                border-radius: 8px;
                background: white;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                z-index: 9999;
                animation: slideIn 0.3s ease-out;
            }
            .toast-success { border-left: 4px solid #28a745; }
            .toast-error { border-left: 4px solid #dc3545; }
            .toast-warning { border-left: 4px solid #ffc107; }
            .toast-info { border-left: 4px solid #17a2b8; }
            .toast-content {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .toast-icon {
                font-size: 20px;
                font-weight: bold;
            }
            .toast-message {
                flex: 1;
                font-size: 14px;
            }
            .toast-close {
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
                color: #666;
                padding: 0;
                width: 24px;
                height: 24px;
            }
            .toast-close:hover {
                color: #333;
            }
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Add to DOM
        document.body.appendChild(toast);

        // Close button handler
        toast.querySelector('.toast-close').addEventListener('click', () => {
            this.hide(toast);
        });

        // Auto hide
        if (duration > 0) {
            setTimeout(() => {
                this.hide(toast);
            }, duration);
        }

        return toast;
    },

    hide: function(toast) {
        if (!toast) {
            toast = document.querySelector('.toast-notification');
        }
        if (toast) {
            toast.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(() => toast.remove(), 300);
        }
    },

    success: function(message, duration) {
        return this.show(message, 'success', duration);
    },

    error: function(message, duration) {
        return this.show(message, 'error', duration);
    },

    warning: function(message, duration) {
        return this.show(message, 'warning', duration);
    },

    info: function(message, duration) {
        return this.show(message, 'info', duration);
    }
};
