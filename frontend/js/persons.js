// Persons Page JavaScript
$(document).ready(function() {
    let allPersons = [];
    
    // Load persons on page load
    loadPersons();
    loadMarga();
    
    // Search functionality
    $('#searchInput').on('keyup', function() {
        const searchTerm = $(this).val().toLowerCase();
        const filteredPersons = allPersons.filter(person => 
            person.nama.toLowerCase().includes(searchTerm) ||
            (person.marga && person.marga.nama.toLowerCase().includes(searchTerm))
        );
        renderPersons(filteredPersons);
    });
    
    // Save person button
    $('#savePersonBtn').on('click', function() {
        savePerson();
    });
    
    function loadPersons() {
        API.getPersons().then(function(persons) {
            allPersons = persons;
            renderPersons(persons);
        });
    }
    
    function loadMarga() {
        API.getMarga().then(function(margaList) {
            const select = $('#margaSelect');
            select.empty();
            select.append('<option value="">Pilih Marga</option>');
            margaList.forEach(function(marga) {
                select.append(`<option value="${marga.id}">${marga.nama} (${marga.sub_suku})</option>`);
            });
        });
    }
    
    function renderPersons(persons) {
        const tbody = $('#personsTable');
        tbody.empty();
        
        if (persons.length === 0) {
            tbody.append('<tr><td colspan="7" class="text-center">Tidak ada data person</td></tr>');
            return;
        }
        
        persons.forEach(function(person) {
            const margaName = person.marga ? person.marga.nama : '-';
            const genderIcon = person.jenis_kelamin === 'L' ? '♂️' : '♀️';
            const birthDate = person.tanggal_lahir ? new Date(person.tanggal_lahir).toLocaleDateString('id-ID') : '-';
            
            tbody.append(`
                <tr>
                    <td>${person.id}</td>
                    <td><a href="person-detail.html?id=${person.id}">${person.nama}</a></td>
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
        
        // Delete button handlers
        $('.delete-btn').on('click', function() {
            const personId = $(this).data('id');
            if (confirm('Apakah Anda yakin ingin menghapus person ini?')) {
                deletePerson(personId);
            }
        });
    }
    
    function savePerson() {
        const formData = $('#addPersonForm').serializeArray();
        const personData = {};
        formData.forEach(function(item) {
            personData[item.name] = item.value;
        });
        
        API.createPerson(personData).then(function(result) {
            if (result) {
                alert('Person berhasil ditambahkan!');
                $('#addPersonModal').modal('hide');
                $('#addPersonForm')[0].reset();
                loadPersons();
            } else {
                alert('Gagal menambahkan person');
            }
        });
    }
    
    function deletePerson(id) {
        API.deletePerson(id).then(function(success) {
            if (success) {
                alert('Person berhasil dihapus!');
                loadPersons();
            } else {
                alert('Gagal menghapus person');
            }
        });
    }
});
