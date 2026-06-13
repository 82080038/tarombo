// API Configuration
const API_BASE_URL = '/tarombo/api/v1';

// API Helper Functions
const API = {
    // Get all persons
    getPersons: async function () {
        try {
            const response = await fetch(`${API_BASE_URL}/persons`);
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
            const response = await fetch(`${API_BASE_URL}/persons/${id}`);
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
                headers: {
                    'Content-Type': 'application/json',
                },
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
                headers: {
                    'Content-Type': 'application/json',
                },
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
                method: 'DELETE'
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
            const response = await fetch(`${API_BASE_URL}/partuturan/calculate?from=${person1Id}&to=${person2Id}`);
            if (!response.ok) throw new Error('Failed to calculate partuturan');
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error calculating partuturan:', error);
            return null;
        }
    }
};
