// Persons Page JavaScript
$(document).ready(function () {
    let allPersons = [];
    let allMargas = [];

    loadPersons();
    loadMarga();

    // Filter events
    $('#searchInput').on('keyup', debounce(applyFilters, 200));
    $('#filterMarga, #filterSubSuku, #filterGender').on('change', applyFilters);
    $('#resetFilterBtn').on('click', function () {
        $('#searchInput').val('');
        $('#filterMarga').val('');
        $('#filterSubSuku').val('');
        $('#filterGender').val('');
        applyFilters();
    });

    $('#savePersonBtn').on('click', function () { savePerson(); });

    function loadPersons() {
        API.getPersons().then(function (persons) {
            allPersons = persons;
            renderPersons(persons);
        });
    }

    function loadMarga() {
        API.getMarga().then(function (margaList) {
            allMargas = margaList;
            // Populate add-person modal select
            const select = $('#margaSelect');
            select.empty();
            select.append('<option value="">Pilih Marga</option>');
            margaList.forEach(function (marga) {
                select.append(`<option value="${marga.id}">${marga.nama} (${marga.sub_suku})</option>`);
            });
            // Populate filter dropdowns
            const margaFilter = $('#filterMarga');
            margaFilter.empty();
            margaFilter.append('<option value="">Semua Marga</option>');
            margaList.forEach(function (m) {
                margaFilter.append(`<option value="${m.id}">${m.nama}</option>`);
            });

            // Sub-suku filter (unique)
            const subSukuSet = [...new Set(margaList.map(m => m.sub_suku))].sort();
            const subSukuFilter = $('#filterSubSuku');
            subSukuFilter.empty();
            subSukuFilter.append('<option value="">Semua Sub-Suku</option>');
            subSukuSet.forEach(function (s) {
                subSukuFilter.append(`<option value="${s}">${s}</option>`);
            });
        });
    }

    function applyFilters() {
        const search = $('#searchInput').val().toLowerCase();
        const margaId = $('#filterMarga').val();
        const subSuku = $('#filterSubSuku').val();
        const gender = $('#filterGender').val();

        const filtered = allPersons.filter(person => {
            const fullName = person.full_name || person.nama;
            const matchSearch = !search ||
                fullName.toLowerCase().includes(search) ||
                (person.marga && person.marga.nama.toLowerCase().includes(search));
            const matchMarga = !margaId || (person.marga_id === parseInt(margaId));
            const matchSubSuku = !subSuku || (person.marga && person.marga.sub_suku === subSuku);
            const matchGender = !gender || person.jenis_kelamin === gender;
            return matchSearch && matchMarga && matchSubSuku && matchGender;
        });

        renderPersons(filtered);
    }

    function renderPersons(persons) {
        const tbody = $('#personsTable');
        tbody.empty();

        if (persons.length === 0) {
            tbody.append('<tr><td colspan="7" class="text-center">Tidak ada data anggota</td></tr>');
            return;
        }

        persons.forEach(function (person) {
            const fullName = person.full_name || person.nama;
            const margaName = person.marga ? person.marga.nama : '-';
            const genderIcon = person.jenis_kelamin === 'L' ? '♂️' : '♀️';
            const birthDate = person.tanggal_lahir ? new Date(person.tanggal_lahir).toLocaleDateString('id-ID') : '-';

            tbody.append(`
                <tr>
                    <td>${person.id}</td>
                    <td><a href="person-detail.html?id=${person.id}">${fullName}</a></td>
                    <td>${margaName}</td>
                    <td>${genderIcon} ${person.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan'}</td>
                    <td>${birthDate}</td>
                    <td>${person.tempat_lahir || '-'}</td>
                    <td>
                        <button class="btn btn-sm btn-info" onclick="window.location.href='person-detail.html?id=${person.id}'">Detail</button>
                        <button class="btn btn-sm btn-danger delete-btn" data-id="${person.id}">Hapus</button>
                    </td>
                </tr>
            `);
        });

        $('.delete-btn').on('click', function () {
            const personId = $(this).data('id');
            if (confirm('Apakah Anda yakin ingin menghapus person ini?')) {
                deletePerson(personId);
            }
        });
    }

    function savePerson() {
        const formData = $('#addPersonForm').serializeArray();
        const personData = {};
        formData.forEach(function (item) { personData[item.name] = item.value; });
        
        // Basic validation
        if (!personData.nama || !personData.marga_id || !personData.jenis_kelamin) {
            Toast.warning('Nama, Marga, dan Jenis Kelamin wajib diisi');
            return;
        }
        
        API.createPerson(personData).then(function (result) {
            if (result) {
                Toast.success('Anggota berhasil ditambahkan!');
                $('#addPersonModal').modal('hide');
                $('#addPersonForm')[0].reset();
                loadPersons();
            } else {
                Toast.error('Gagal menambahkan anggota. Silakan coba lagi.');
            }
        });
    }

    function deletePerson(id) {
        if (confirm('Apakah Anda yakin ingin menghapus anggota ini? Tindakan ini tidak dapat dibatalkan.')) {
            API.deletePerson(id).then(function (success) {
                if (success) {
                    Toast.success('Anggota berhasil dihapus!');
                    loadPersons();
                } else {
                    Toast.error('Gagal menghapus anggota. Silakan coba lagi.');
                }
            });
        }
    }

    function debounce(fn, ms) {
        let t;
        return function () {
            clearTimeout(t);
            t = setTimeout(() => fn.apply(this, arguments), ms);
        };
    }
});
