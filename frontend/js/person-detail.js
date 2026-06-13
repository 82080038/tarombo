// Person Detail Page JavaScript
$(document).ready(function() {
    // Get person ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const personId = urlParams.get('id');
    
    if (personId) {
        loadPersonDetail(personId);
    } else {
        $('#personDetail').html('<div class="alert alert-danger">Person ID tidak ditemukan</div>');
    }
    
    function loadPersonDetail(id) {
        API.getPerson(id).then(function(person) {
            if (person) {
                renderPersonDetail(person);
            } else {
                $('#personDetail').html('<div class="alert alert-danger">Person tidak ditemukan</div>');
            }
        });
    }
    
    function renderPersonDetail(person) {
        const margaName = person.marga ? person.marga.nama : '-';
        const subSuku = person.marga ? person.marga.sub_suku : '-';
        const genderIcon = person.jenis_kelamin === 'L' ? '♂️' : '♀️';
        const genderText = person.jenis_kelamin === 'L' ? 'Laki-laki' : 'Perempuan';
        const birthDate = person.tanggal_lahir ? new Date(person.tanggal_lahir).toLocaleDateString('id-ID', { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        }) : '-';
        const deathDate = person.tanggal_meninggal ? new Date(person.tanggal_meninggal).toLocaleDateString('id-ID', { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        }) : '-';
        
        const fatherName = person.father ? person.father.nama : '-';
        const motherName = person.mother ? person.mother.nama : '-';
        
        $('#personDetail').html(`
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Informasi Person</h5>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <tr>
                                <th>ID</th>
                                <td>${person.id}</td>
                            </tr>
                            <tr>
                                <th>Nama</th>
                                <td>${person.nama}</td>
                            </tr>
                            <tr>
                                <th>Marga</th>
                                <td>${margaName} (${subSuku})</td>
                            </tr>
                            <tr>
                                <th>Jenis Kelamin</th>
                                <td>${genderIcon} ${genderText}</td>
                            </tr>
                            <tr>
                                <th>Tanggal Lahir</th>
                                <td>${birthDate}</td>
                            </tr>
                            <tr>
                                <th>Tempat Lahir</th>
                                <td>${person.tempat_lahir || '-'}</td>
                            </tr>
                            <tr>
                                <th>Tanggal Meninggal</th>
                                <td>${deathDate}</td>
                            </tr>
                            <tr>
                                <th>Ayah</th>
                                <td>${fatherName}</td>
                            </tr>
                            <tr>
                                <th>Ibu</th>
                                <td>${motherName}</td>
                            </tr>
                            <tr>
                                <th>Status</th>
                                <td><span class="badge bg-${person.status === 'active' ? 'success' : 'secondary'}">${person.status}</span></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Aksi</h5>
                    </div>
                    <div class="card-body">
                        <button class="btn btn-primary btn-block mb-2" onclick="alert('Edit functionality coming soon')">Edit</button>
                        <button class="btn btn-info btn-block mb-2" onclick="window.location.href='family-tree.html?root=${person.id}'">Lihat Family Tree</button>
                        <button class="btn btn-warning btn-block" onclick="alert('Partuturan calculation coming soon')">Hitung Partuturan</button>
                    </div>
                </div>
            </div>
        `);
    }
});
