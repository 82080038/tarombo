// Partuturan Page JavaScript
$(document).ready(function() {
    let allPersons = [];
    
    // Load persons on page load
    loadPersons();
    
    // Calculate button
    $('#calculateBtn').on('click', function() {
        const person1Id = $('#person1Select').val();
        const person2Id = $('#person2Select').val();
        
        if (person1Id && person2Id) {
            calculatePartuturan(person1Id, person2Id);
        } else {
            alert('Pilih dua person untuk menghitung partuturan');
        }
    });
    
    function loadPersons() {
        API.getPersons().then(function(persons) {
            allPersons = persons;
            populatePersonSelects(persons);
        });
    }
    
    function populatePersonSelects(persons) {
        const select1 = $('#person1Select');
        const select2 = $('#person2Select');
        
        select1.empty();
        select1.append('<option value="">Pilih Person 1</option>');
        
        select2.empty();
        select2.append('<option value="">Pilih Person 2</option>');
        
        persons.forEach(function(person) {
            const margaName = person.marga ? person.marga.nama : '';
            const option = `<option value="${person.id}">${person.nama} ${margaName ? '(' + margaName + ')' : ''}</option>`;
            select1.append(option);
            select2.append(option);
        });
    }
    
    function calculatePartuturan(person1Id, person2Id) {
        $('#partuturanResult').html('<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>');
        
        API.calculatePartuturan(person1Id, person2Id).then(function(result) {
            if (result) {
                renderPartuturanResult(result);
            } else {
                $('#partuturanResult').html('<div class="alert alert-danger">Gagal menghitung partuturan</div>');
            }
        });
    }
    
    function renderPartuturanResult(result) {
        const person1 = allPersons.find(p => p.id == result.person1_id);
        const person2 = allPersons.find(p => p.id == result.person2_id);
        
        $('#partuturanResult').html(`
            <div class="alert alert-success">
                <h6>Hasil Perhitungan Partuturan</h6>
                <hr>
                <p><strong>Person 1:</strong> ${person1 ? person1.nama : 'Unknown'}</p>
                <p><strong>Person 2:</strong> ${person2 ? person2.nama : 'Unknown'}</p>
                <hr>
                <p><strong>Hubungan:</strong> ${result.relationship || 'Tidak dapat ditentukan'}</p>
                <p><strong>Generasi:</strong> ${result.generation || '-'}</p>
                <p><strong>Jarak:</strong> ${result.distance || '-'} generasi</p>
            </div>
        `);
    }
});
