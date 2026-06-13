// Partuturan Page JavaScript
$(document).ready(function () {
    let allPersons = [];

    loadPersons();

    // Tab switching
    $('#partuturanTabs').on('click', '.nav-link', function (e) {
        e.preventDefault();
        const tab = $(this).data('tab');
        $('#partuturanTabs .nav-link').removeClass('active');
        $(this).addClass('active');
        $('.tab-content').hide();
        $('#tab-' + tab).show();
    });

    // Calculator
    $('#calculateBtn').on('click', function () {
        const p1 = $('#person1Select').val();
        const p2 = $('#person2Select').val();
        if (p1 && p2) calculatePartuturan(p1, p2);
        else alert('Pilih dua anggota untuk menghitung partuturan');
    });

    // Relation tabs
    $('#relationPersonSelect').on('change', function () {
        if ($(this).val()) loadRelations($(this).val());
    });
    $('#berePersonSelect').on('change', function () {
        if ($(this).val()) loadBere($(this).val());
    });
    $('#paribanPersonSelect').on('change', function () {
        if ($(this).val()) loadPariban($(this).val());
    });

    // URL params for pre-selection
    const urlParams = new URLSearchParams(window.location.search);
    const preFrom = urlParams.get('from');
    if (preFrom) {
        // wait for persons to load then select
        const checkInterval = setInterval(() => {
            if (allPersons.length > 0) {
                clearInterval(checkInterval);
                $('#person1Select').val(preFrom);
            }
        }, 100);
    }

    function loadPersons() {
        API.getPersons().then(function (persons) {
            allPersons = persons;
            const opts = persons.map(p => {
                const marga = p.marga ? p.marga.nama : '';
                return `<option value="${p.id}">${p.nama}${marga ? ' (' + marga + ')' : ''}</option>`;
            }).join('');

            $('#person1Select, #person2Select, #relationPersonSelect, #berePersonSelect, #paribanPersonSelect')
                .each(function () {
                    $(this).append(opts);
                });
        });
    }

    function calculatePartuturan(p1, p2) {
        $('#partuturanResult').html('<div class="text-center"><div class="spinner-border"></div></div>');
        API.calculatePartuturan(p1, p2).then(function (r) {
            if (r) {
                const pathHtml = r.path && r.path.length > 1 ? `<p><strong>Jalur:</strong> ${r.path.map(p => p.nama).join(' → ')}</p>` : '';
                $('#partuturanResult').html(`
                    <div class="alert alert-success">
                        <h6>Hasil Perhitungan Partuturan</h6>
                        <hr>
                        <p><strong>Dari:</strong> ${r.from_person?.nama || 'Unknown'}</p>
                        <p><strong>Ke:</strong> ${r.to_person?.nama || 'Unknown'}</p>
                        <hr>
                        <p><strong>Istilah Batak:</strong> <span class="badge bg-primary fs-6">${r.relationship || '-'}</span></p>
                        <p><strong>Dalam Bahasa Indonesia:</strong> ${r.indonesian || '-'}</p>
                        <p><strong>Penjelasan:</strong> ${r.explanation || '-'}</p>
                        ${pathHtml}
                    </div>
                `);
            } else {
                $('#partuturanResult').html('<div class="alert alert-danger">Gagal menghitung partuturan</div>');
            }
        });
    }

    async function loadRelations(id) {
        $('#tulangResult').html('<div class="text-center"><div class="spinner-border spinner-border-sm"></div></div>');
        $('#namboruResult').html('<div class="text-center"><div class="spinner-border spinner-border-sm"></div></div>');

        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`);
            const result = await response.json();
            if (!result.success) { showEmpty(); return; }

            const rels = result.data.relationships || {};

            // Tulang
            if (rels.tulang && rels.tulang.length) {
                $('#tulangResult').html(`<ul class="list-group list-group-flush">${rels.tulang.map(t =>
                    `<li class="list-group-item py-1">${t.nama} ${t.marga ? '(' + t.marga.nama + ')' : ''}</li>`
                ).join('')}</ul>`);
            } else {
                $('#tulangResult').html('<p class="text-muted small">Tidak ada data Tulang</p>');
            }

            // Namboru
            if (rels.namboru && rels.namboru.length) {
                $('#namboruResult').html(`<ul class="list-group list-group-flush">${rels.namboru.map(n =>
                    `<li class="list-group-item py-1">${n.nama} ${n.marga ? '(' + n.marga.nama + ')' : ''}</li>`
                ).join('')}</ul>`);
            } else {
                $('#namboruResult').html('<p class="text-muted small">Tidak ada data Namboru</p>');
            }
        } catch (e) { showEmpty(); }

        function showEmpty() {
            $('#tulangResult, #namboruResult').html('<p class="text-muted">Gagal memuat data</p>');
        }
    }

    async function loadBere(id) {
        $('#bereResult').html('<div class="text-center"><div class="spinner-border spinner-border-sm"></div></div>');
        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`);
            const result = await response.json();
            if (!result.success) { $('#bereResult').html('<p class="text-muted">Gagal memuat</p>'); return; }

            const bere = result.data.relationships?.bere || [];
            if (bere.length) {
                $('#bereResult').html(`<div class="table-responsive"><table class="table table-sm">
                    <thead><tr><th>Nama</th><th>Melalui</th><th>Hubungan</th></tr></thead>
                    <tbody>${bere.map(b => `<tr><td>${b.person.nama}</td><td>${b.through_sister}</td><td><small>${b.relation}</small></td></tr>`).join('')}</tbody>
                </table></div>`);
            } else {
                $('#bereResult').html('<p class="text-muted">Tidak ada data Bere</p>');
            }
        } catch (e) { $('#bereResult').html('<p class="text-muted">Gagal memuat</p>'); }
    }

    async function loadPariban(id) {
        $('#paribanResult').html('<div class="text-center"><div class="spinner-border spinner-border-sm"></div></div>');
        try {
            const response = await fetch(`${API_BASE_URL}/persons/${id}`);
            const result = await response.json();
            if (!result.success) { $('#paribanResult').html('<p class="text-muted">Gagal memuat</p>'); return; }

            const candidates = result.data.relationships?.pariban_candidates || [];
            if (candidates.length) {
                $('#paribanResult').html(`<div class="table-responsive"><table class="table table-sm">
                    <thead><tr><th>Nama</th><th>Melalui</th><th>Tipe</th><th>Skor</th></tr></thead>
                    <tbody>${candidates.map(c => `<tr>
                        <td><strong>${c.person.nama}</strong> ${c.person.marga ? '(' + c.person.marga.nama + ')' : ''}</td>
                        <td><small>${c.through}</small></td>
                        <td><small>${c.relation_type}</small></td>
                        <td><span class="badge bg-${c.match_score >= 80 ? 'success' : c.match_score >= 60 ? 'warning' : 'secondary'}">${c.match_score}%</span></td>
                    </tr>`).join('')}</tbody>
                </table></div>`);
            } else {
                $('#paribanResult').html('<p class="text-muted">Tidak ada calon Pariban yang ditemukan dalam database</p>');
            }
        } catch (e) { $('#paribanResult').html('<p class="text-muted">Gagal memuat</p>'); }
    }
});
