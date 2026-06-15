// Map Page JavaScript
let map;
let markers = [];

document.addEventListener('DOMContentLoaded', async function () {
    map = L.map('familyMap').setView([-2.5, 120], 5);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '&copy; OpenStreetMap' }).addTo(map);
    
    populateFilters();
    loadGeoData();
    
    document.getElementById('filterMapMarga').addEventListener('change', loadGeoData);
    document.getElementById('filterMapSubSuku').addEventListener('change', loadGeoData);
});

async function populateFilters() {
    try {
        const margas = await API.getMarga();
        const mSelect = document.getElementById('filterMapMarga');
        margas.forEach(m => { mSelect.innerHTML += `<option value="${m.id}">${m.nama}</option>`; });
        
        const subSet = [...new Set(margas.map(m => m.sub_suku))].sort();
        const sSelect = document.getElementById('filterMapSubSuku');
        subSet.forEach(s => { sSelect.innerHTML += `<option value="${s}">${s}</option>`; });
    } catch (e) {
        console.error('Error populating filters:', e);
    }
}

async function loadGeoData() {
    markers.forEach(m => map.removeLayer(m));
    markers = [];
    
    const margaId = document.getElementById('filterMapMarga').value;
    const subSuku = document.getElementById('filterMapSubSuku').value;
    
    try {
        const params = new URLSearchParams();
        if (margaId) params.set('marga_id', margaId);
        if (subSuku) params.set('sub_suku', subSuku);

        const response = await fetch(`${API_BASE_URL}/geo/persons?${params.toString()}`);
        const result = await response.json();

        if (!result.success) return;

        const items = result.data || [];
        const bounds = [];

        items.forEach(loc => {
            if (loc.latitude && loc.longitude) {
                const marker = L.marker([loc.latitude, loc.longitude])
                    .addTo(map)
                    .bindPopup(`<b>${loc.person?.nama || 'Unknown'}</b><br>${loc.person?.marga?.nama || ''}<br>${loc.lokasi}`);
                markers.push(marker);
                bounds.push([loc.latitude, loc.longitude]);
            }
        });

        if (bounds.length) map.fitBounds(bounds, { padding: [30, 30] });

        // Load statistics
        const statRes = await fetch(`${API_BASE_URL}/geo/statistics`);
        const statResult = await statRes.json();
        
        if (statResult.success) {
            const stats = statResult.data;
            document.getElementById('geoStats').innerHTML = `
                <span class="badge bg-primary">Total Lokasi: ${stats.total_locations}</span>
                <span class="badge bg-success">Kota: ${Object.keys(stats.by_city).length}</span>
            `;
        }
    } catch (e) {
        console.error('Error loading geo data:', e);
    }
}
