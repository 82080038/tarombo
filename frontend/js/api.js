// API Configuration
const API_BASE_URL = '/tarombo/api/v1';

// Token management
function getAuthToken() {
    return localStorage.getItem('tarombo_token');
}

function setAuthToken(token) {
    localStorage.setItem('tarombo_token', token);
}

function removeAuthToken() {
    localStorage.removeItem('tarombo_token');
}

function getAuthHeaders() {
    const token = getAuthToken();
    const headers = {
        'Content-Type': 'application/json'
    };
    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }
    return headers;
}

// Check if user is authenticated, show login prompt if not
function requireAuth() {
    if (!getAuthToken()) {
        showLoginPrompt();
        return false;
    }
    return true;
}

// Show login prompt overlay for unauthenticated users
function showLoginPrompt() {
    // Avoid duplicate prompts
    if (document.getElementById('authPromptOverlay')) return;
    const baseUrl = window.TAROMBO_BASE_URL || '/tarombo';
    const overlay = document.createElement('div');
    overlay.id = 'authPromptOverlay';
    overlay.className = 'position-fixed top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center';
    overlay.style.cssText = 'background:rgba(0,0,0,0.5);z-index:9998;';
    overlay.innerHTML = `
        <div class="bg-white rounded-3 shadow-lg p-4 text-center" style="max-width:400px;">
            <div class="mb-3" style="font-size:3rem;">🔒</div>
            <h4 class="fw-bold mb-2">Login Diperlukan</h4>
            <p class="text-muted mb-3">Anda harus login untuk melihat data ini.</p>
            <a href="${baseUrl}/login" class="btn btn-primary px-4">Login Sekarang</a>
            <button class="btn btn-link d-block mt-2 text-muted" onclick="document.getElementById('authPromptOverlay').remove()">Tutup</button>
        </div>
    `;
    document.body.appendChild(overlay);
}

// API Helper Functions
const API = {
    // Auth: Login
    login: async function (email, password) {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email, password })
            });
            const data = await response.json();
            if (data.success && data.data.access_token) {
                setAuthToken(data.data.access_token);
            }
            return data;
        } catch (error) {
            console.error('Error login:', error);
            return { success: false, error: { message: 'Gagal terhubung ke server' } };
        }
    },

    // Auth: Register
    register: async function (userData) {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/register`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(userData)
            });
            return await response.json();
        } catch (error) {
            console.error('Error register:', error);
            return { success: false, error: { message: 'Gagal terhubung ke server' } };
        }
    },

    // Auth: Quick Login (dev only)
    quickLogin: async function (role) {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/quick-login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ role: role || 'admin' })
            });
            const data = await response.json();
            if (data.success && data.data.access_token) {
                setAuthToken(data.data.access_token);
            }
            return data;
        } catch (error) {
            console.error('Error quick login:', error);
            return { success: false, error: { message: 'Gagal terhubung ke server' } };
        }
    },

    // Auth: Get current user
    me: async function () {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/me`, {
                headers: getAuthHeaders()
            });
            if (response.status === 401) {
                removeAuthToken();
                return null;
            }
            const data = await response.json();
            return data.success ? data.data : null;
        } catch (error) {
            console.error('Error fetching me:', error);
            return null;
        }
    },

    // Auth: Logout
    logout: async function () {
        try {
            await fetch(`${API_BASE_URL}/auth/logout`, {
                method: 'POST',
                headers: getAuthHeaders()
            });
        } catch (e) {
            // ignore
        }
        removeAuthToken();
        window.location.href = (window.TAROMBO_BASE_URL || '/tarombo') + '/login';
    },

    // Get all persons
    getPersons: async function () {
        try {
            const response = await fetch(`${API_BASE_URL}/persons`, {
                headers: getAuthHeaders()
            });
            if (response.status === 401) {
                showLoginPrompt();
                return [];
            }
            if (!response.ok) throw new Error('Failed to fetch persons');
            const data = await response.json();
            return data.data;
        } catch (error) {
            console.error('Error fetching persons:', error);
            return [];
        }
    },

    // Get person by ID
    getPerson: async function (id) {
        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`, {
                headers: getAuthHeaders()
            });
            if (response.status === 401) {
                showLoginPrompt();
                return null;
            }
            if (!response.ok) throw new Error('Failed to fetch person');
            const data = await response.json();
            return data.data;
        } catch (error) {
            console.error('Error fetching person:', error);
            return null;
        }
    },

    // Create person
    createPerson: async function (personData) {
        try {
            const response = await fetch(`${API_BASE_URL}/persons`, {
                method: 'POST',
                headers: getAuthHeaders(),
                body: JSON.stringify(personData)
            });
            if (!response.ok) throw new Error('Failed to create person');
            const data = await response.json();
            return data.data;
        } catch (error) {
            console.error('Error creating person:', error);
            return null;
        }
    },

    // Update person
    updatePerson: async function (id, personData) {
        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`, {
                method: 'PUT',
                headers: getAuthHeaders(),
                body: JSON.stringify(personData)
            });
            if (!response.ok) throw new Error('Failed to update person');
            const data = await response.json();
            return data.data;
        } catch (error) {
            console.error('Error updating person:', error);
            return null;
        }
    },

    // Delete person
    deletePerson: async function (id) {
        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`, {
                method: 'DELETE',
                headers: getAuthHeaders()
            });
            if (!response.ok) throw new Error('Failed to delete person');
            return true;
        } catch (error) {
            console.error('Error deleting person:', error);
            return false;
        }
    },

    // Get all marga
    getMarga: async function () {
        try {
            const response = await fetch(`${API_BASE_URL}/marga`);
            if (!response.ok) throw new Error('Failed to fetch marga');
            const data = await response.json();
            return data.data;
        } catch (error) {
            console.error('Error fetching marga:', error);
            return [];
        }
    },

    // Calculate partuturan
    calculatePartuturan: async function (person1Id, person2Id) {
        try {
            const response = await fetch(`${API_BASE_URL}/partuturan/calculate?from=${person1Id}&to=${person2Id}`, {
                headers: getAuthHeaders()
            });
            if (response.status === 401) {
                showLoginPrompt();
                return null;
            }
            if (!response.ok) throw new Error('Failed to calculate partuturan');
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error calculating partuturan:', error);
            return null;
        }
    }
};
