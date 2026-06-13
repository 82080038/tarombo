// Person Detail Page JavaScript
let currentPerson = null;
let allPersons = [];
let allMargas = [];

$(document).ready(function () {
    const urlParams = new URLSearchParams(window.location.search);
    const personId = urlParams.get('id');

    if (personId) {
        loadPersonDetail(personId);
        preloadData();
    } else {
        $('#personDetail').html('<div class="alert alert-danger">ID Anggota tidak ditemukan</div>');
    }

    $('#saveEditBtn').on('click', savePersonEdit);
});

async function preloadData() {
    allMargas = await API.getMarga();
    allPersons = await API.getPersons();
}

function loadPersonDetail(id) {
    API.getPerson(id).then(function (person) {
        if (person) {
            currentPerson = person;
            renderPersonDetail(person);
        } else {
            $('#personDetail').html('<div class="alert alert-danger">Anggota tidak ditemukan</div>');
        }
    });
}

function renderPersonDetail(person) {
    const margaName = person.marga ? person.marga.nama : '-';
    const subSuku = person.marga ? person.marga.sub_suku : '-';
    const genderIcon = person.jenis_kelamin === 'L' ? '♂️' : '♀️';
    const genderText = person.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan';
    const birthDate = person.tanggal_lahir ? new Date(person.tanggal_lahir).toLocaleDateString('id-ID', {
        year: 'numeric', month: 'long', day: 'numeric'
    }) : '-';
    const deathDate = person.tanggal_meninggal ? new Date(person.tanggal_meninggal).toLocaleDateString('id-ID', {
        year: 'numeric', month: 'long', day: 'numeric'
    }) : '-';

    const fatherName = person.father ? person.father.nama : '-';
    const motherName = person.mother ? person.mother.nama : '-';

    // Siblings
    const siblings = [];
    if (person.father && person.father.children) {
        person.father.children.forEach(c => {
            if (c.id !== person.id) siblings.push(c);
        });
    }
    const siblingsHtml = siblings.length
        ? `<ul class="list-unstyled mb-0">${siblings.map(s => `<li>${s.nama} ${s.jenis_kelamin === 'L' ? '(L)' : '(P)'}</li>`).join('')}</ul>`
        : '-';

    $('#personDetail').html(`
        <div class="col-md-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Informasi Anggota</h5>
                    <span class="badge bg-${person.status === 'active' ? 'success' : 'secondary'}">${person.status}</span>
                </div>
                <div class="card-body">
                    <table class="table table-sm">
                        <tr><th style="width:30%">ID</th><td>${person.id}</td></tr>
                        <tr><th>Nama</th><td><strong>${person.nama}</strong></td></tr>
                        <tr><th>Marga</th><td>${margaName} <span class="text-muted">(${subSuku})</span></td></tr>
                        <tr><th>Jenis Kelamin</th><td>${genderIcon} ${genderText}</td></tr>
                        <tr><th>Tanggal Lahir</th><td>${birthDate}</td></tr>
                        <tr><th>Huta Asal</th><td>${person.tempat_lahir || '-'}</td></tr>
                        <tr><th>Tanggal Meninggal</th><td>${deathDate}</td></tr>
                        <tr><th>Amang (Ayah)</th><td>${fatherName}</td></tr>
                        <tr><th>Inang (Ibu)</th><td>${motherName}</td></tr>
                        <tr><th>Dongan Tubu (Saudara)</th><td>${siblingsHtml}</td></tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card mb-3">
                <div class="card-header"><h5 class="mb-0">Aksi</h5></div>
                <div class="card-body">
                    <button class="btn btn-primary w-100 mb-2" onclick="openEditModal()">✏️ Edit</button>
                    <button class="btn btn-info w-100 mb-2" onclick="window.location.href='family-tree.html?root=${person.id}'">🌳 Lihat Pohon Tarombo</button>
                    <button class="btn btn-warning w-100" onclick="window.location.href='partuturan.html?from=${person.id}'">🔗 Hitung Partuturan</button>
                </div>
            </div>
            ${person.relationships && person.relationships.tulang && person.relationships.tulang.length ? `
            <div class="card mb-3">
                <div class="card-header"><h5 class="mb-0">Tulang (Saudara Laki Ibu)</h5></div>
                <div class="card-body"><ul class="list-group list-group-flush">${person.relationships.tulang.map(t => `<li class="list-group-item py-1">${t.nama}</li>`).join('')}</ul></div>
            </div>` : ''}
            ${person.relationships && person.relationships.namboru && person.relationships.namboru.length ? `
            <div class="card">
                <div class="card-header"><h5 class="mb-0">Namboru (Saudara Perempuan Ayah)</h5></div>
                <div class="card-body"><ul class="list-group list-group-flush">${person.relationships.namboru.map(n => `<li class="list-group-item py-1">${n.nama}</li>`).join('')}</ul></div>
            </div>` : ''}
        </div>
    `);
}

function openEditModal() {
    if (!currentPerson) return;
    const p = currentPerson;

    $('#editPersonId').val(p.id);
    $('#editNama').val(p.nama);
    $('#editJenisKelamin').val(p.jenis_kelamin);
    $('#editTanggalLahir').val(p.tanggal_lahir || '');
    $('#editTempatLahir').val(p.tempat_lahir || '');
    $('#editTanggalMeninggal').val(p.tanggal_meninggal || '');

    // Populate marga dropdown
    const margaOpts = allMargas.map(m => `<option value="${m.id}" ${m.id === p.marga_id ? 'selected' : ''}>${m.nama}</option>`).join('');
    $('#editMargaId').html(margaOpts);

    // Populate father/mother dropdowns
    const maleOpts = allPersons.filter(pp => pp.jenis_kelamin === 'L' && pp.id !== p.id)
        .map(pp => `<option value="${pp.id}" ${pp.id === p.father_id ? 'selected' : ''}>${pp.nama}</option>`).join('');
    const femaleOpts = allPersons.filter(pp => pp.jenis_kelamin === 'P' && pp.id !== p.id)
        .map(pp => `<option value="${pp.id}" ${pp.id === p.mother_id ? 'selected' : ''}>${pp.nama}</option>`).join('');

    $('#editFatherId').html('<option value="">- Tidak ada -</option>' + maleOpts);
    $('#editMotherId').html('<option value="">- Tidak ada -</option>' + femaleOpts);

    $('#editError').hide();
    const modal = new bootstrap.Modal(document.getElementById('editPersonModal'));
    modal.show();
}

async function savePersonEdit() {
    const id = parseInt($('#editPersonId').val());
    const data = {
        nama: $('#editNama').val(),
        marga_id: parseInt($('#editMargaId').val()),
        jenis_kelamin: $('#editJenisKelamin').val(),
        tanggal_lahir: $('#editTanggalLahir').val() || null,
        tempat_lahir: $('#editTempatLahir').val() || null,
        tanggal_meninggal: $('#editTanggalMeninggal').val() || null,
        father_id: $('#editFatherId').val() ? parseInt($('#editFatherId').val()) : null,
        mother_id: $('#editMotherId').val() ? parseInt($('#editMotherId').val()) : null,
    };

    const errorDiv = $('#editError');
    errorDiv.hide();

    const btn = $('#saveEditBtn');
    btn.prop('disabled', true).text('Menyimpan...');

    try {
        const result = await API.updatePerson(id, data);
        if (result) {
            const modalEl = document.getElementById('editPersonModal');
            bootstrap.Modal.getInstance(modalEl).hide();
            loadPersonDetail(id);
            showToast('Data anggota berhasil diperbarui!', 'success');
        } else {
            errorDiv.text('Gagal menyimpan perubahan').show();
        }
    } catch (e) {
        errorDiv.text('Gagal terhubung ke server').show();
    }

    btn.prop('disabled', false).text('Simpan Perubahan');
}

function showToast(message, type) {
    const toast = document.createElement('div');
    toast.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 250px;';
    toast.innerHTML = `${message}<button type="button" class="btn-close" data-bs-dismiss="alert"></button>`;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

