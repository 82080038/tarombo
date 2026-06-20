// AI Tarombo Assistant
let currentUser = null;
let allPersons = [];

document.addEventListener('DOMContentLoaded', async function () {
    preloadData();
    const token = localStorage.getItem('tarombo_token');
    if (token) {
        try { const user = await API.me(); currentUser = user; } catch (e) { }
    }
});

async function preloadData() {
    try { allPersons = await API.getPersons(); } catch (e) { }
}

function setQuery(text) {
    document.getElementById('queryInput').value = text;
    sendQuery();
}

async function sendQuery() {
    const input = document.getElementById('queryInput');
    const text = input.value.trim();
    if (!text) return;
    input.value = '';
    addMessage(text, 'user');
    const response = await processQuery(text);
    addMessage(response, 'bot');
}

function addMessage(html, from) {
    const box = document.getElementById('chatBox');
    const wrapper = document.createElement('div');
    wrapper.className = 'mb-3';
    const align = from === 'user' ? 'text-end' : 'text-start';
    const bg = from === 'user' ? 'bg-primary text-white' : 'bg-light';
    wrapper.innerHTML = `<div class="${align}"><div class="d-inline-block ${bg} p-3 rounded" style="max-width:80%;">${html}</div></div>`;
    box.appendChild(wrapper);
    box.scrollTop = box.scrollHeight;
}

async function processQuery(text) {
    const q = text.toLowerCase();
    if (q.includes('dalihan na tolu') || q.includes('somba') || q.includes('manat') || q.includes('martula')) {
        return `<strong>Dalihan Na Tolu</strong> adalah tiga pilar adat Batak:<br>
        <strong>1. Somba</strong> — Hormat kepada yang lebih tua/dalam adat<br>
        <strong>2. Manat</strong> — Adil dalam bertindak dan mengambil keputusan<br>
        <strong>3. Martula-tula</strong> — Saling melengkapi antar marga dalam acara adat`;
    }
    if (q.includes('tarombo') || q.includes('silsilah') || q.includes('arti tarombo')) {
        return `<strong>Tarombo</strong> adalah silsilah keluarga Batak yang menelusuri garis keturunan dari leluhur hingga generasi sekarang. Orang yang tidak mengetahui tarombonya disebut <em>nalilu</em> (terasing).`;
    }
    if (q.includes('tulang') && (q.includes('saya') || q.includes('aku'))) {
        if (!currentUser) return 'Silakan <a href="login">login</a> terlebih dahulu agar saya bisa mengetahui identitas Anda.';
        const linked = allPersons.find(p => p.nama.toLowerCase().includes(currentUser.nama.toLowerCase().split(' ')[0]));
        if (!linked) return 'Data Anda belum terhubung dengan person di sistem. Silakan hubungi admin.';
        try {
            const res = await fetch(`${API_BASE_URL}/persons/${linked.id}`, { headers: getAuthHeaders() });
            const result = await res.json();
            const tulang = result.data?.relationships?.tulang || [];
            if (!tulang.length) return `Anda (${linked.nama}) tidak memiliki data Tulang dalam sistem. Tulang adalah saudara laki-laki dari ibu Anda.`;
            return `Tulang Anda (${linked.nama}):<br><ul class="mb-0 ps-3">${tulang.map(t => `<li>${t.nama}</li>`).join('')}</ul>`;
        } catch (e) { return 'Gagal mengambil data.'; }
    }
    if (q.includes('pariban') && (q.includes('saya') || q.includes('aku') || q.includes('ideal'))) {
        if (!currentUser) return 'Silakan <a href="login">login</a> terlebih dahulu.';
        const linked = allPersons.find(p => p.nama.toLowerCase().includes(currentUser.nama.toLowerCase().split(' ')[0]));
        if (!linked) return 'Data Anda belum terhubung dengan person di sistem.';
        try {
            const res = await fetch(`${API_BASE_URL}/persons/${linked.id}`, { headers: getAuthHeaders() });
            const result = await res.json();
            const candidates = result.data?.relationships?.pariban_candidates || [];
            if (!candidates.length) return 'Tidak ditemukan calon Pariban untuk Anda dalam database.';
            const top = candidates.slice(0, 3);
            return `Calon Pariban ideal untuk Anda (${linked.nama}):<br><ul class="mb-0 ps-3">${top.map(c => `<li><strong>${c.person.nama}</strong> — skor ${c.match_score}%</li>`).join('')}</ul>`;
        } catch (e) { return 'Gagal mengambil data.'; }
    }
    if (q.includes('partuturan') || q.includes('panggilan') || q.includes('sebutan')) {
        return `<strong>Partuturan</strong> adalah sistem panggilan/penyebutan dalam adat Batak berdasarkan hubungan kekerabatan. Contoh:<br>
        <ul class="mb-0 ps-3"><li><strong>Inang</strong> — Ibu</li><li><strong>Amang</strong> — Ayah</li><li><strong>Tulang</strong> — Saudara laki-laki ibu</li><li><strong>Namboru</strong> — Saudara perempuan ayah</li><li><strong>Bere</strong> — Anak dari saudara perempuan</li><li><strong>Pariban</strong> — Pasangan ideal</li></ul>`;
    }
    if (q.includes('marga') && (q.includes('apa') || q.includes('artinya'))) {
        return `<strong>Marga</strong> adalah nama keluarga besar (klan) dalam masyarakat Batak. Marga menentukan:<br>
        <ul class="mb-0 ps-3"><li>Dalihan Na Tolu (Hula-hula, Boru, Dongan Tubu)</li><li>Larangan perkawinan sesama marga</li><li>Identitas dan kebanggaan keluarga</li></ul>`;
    }
    if (q.includes('saur matua') || q.includes('kematian')) {
        return `<strong>Saur Matua</strong> adalah upacara adat kematian dalam tradisi Batak. Prosesinya meliputi:<br>
        <ul class="mb-0 ps-3"><li>Mangongkal holi (memindahkan tulang)</li><li>Manenean (doa bersama)</li><li>Pesta adat sebagai tanda penghormatan terakhir</li></ul>`;
    }
    if (q.includes('larangan') || q.includes('nikah') || q.includes('perkawinan') || q.includes('marhataisangsang')) {
        return `Dalam adat Batak, terdapat aturan perkawinan:<br>
        <ul class="mb-0 ps-3"><li><strong>Dilarang</strong> menikah sesama marga</li><li><strong>Dilarang</strong> menikah antara marga tertentu (contoh: Marbun-Sihotang)</li><li><strong>Hula-hula</strong> = pihak pemberi perempuan</li><li><strong>Boru</strong> = pihak menerima perempuan</li></ul>`;
    }
    return `Maaf, saya belum memahami pertanyaan tersebut. Silakan coba salah satu topik:<br>
    <span class="badge bg-light text-dark border" style="cursor:pointer" onclick="setQuery('Apa itu Dalihan Na Tolu?')">Dalihan Na Tolu</span>
    <span class="badge bg-light text-dark border" style="cursor:pointer" onclick="setQuery('Jelaskan Partuturan')">Partuturan</span>
    <span class="badge bg-light text-dark border" style="cursor:pointer" onclick="setQuery('Apa itu Saur Matua?')">Saur Matua</span>`;
}
