// Partuturan Page JavaScript
$(document).ready(function () {
    let allPersons = [];

    // Load persons on page load
    loadPersons();

    // Calculate button
    $('#calculateBtn').on('click', function () {
        const person1Id = $('#person1Select').val();
        const person2Id = $('#person2Select').val();

        if (person1Id && person2Id) {
            calculatePartuturan(person1Id, person2Id);
        } else {
            alert('Pilih dua anggota untuk menghitung partuturan');
        }
    });

    function loadPersons() {
        API.getPersons().then(function (persons) {
            allPersons = persons;
            populatePersonSelects(persons);
        });
    }

    function populatePersonSelects(persons) {
        const select1 = $('#person1Select');
        const select2 = $('#person2Select');

        select1.empty();
        select1.append('<option value="">Pilih Anggota</option>');

        select2.empty();
        select2.append('<option value="">Pilih Anggota</option>');

        persons.forEach(function (person) {
            const margaName = person.marga ? person.marga.nama : '';
            const option = `<option value="${person.id}">${person.nama} ${margaName ? '(' + margaName + ')' : ''}</option>`;
            select1.append(option);
            select2.append(option);
        });
    }

    function calculatePartuturan(person1Id, person2Id) {
        $('#partuturanResult').html('<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>');

        API.calculatePartuturan(person1Id, person2Id).then(function (result) {
            if (result) {
                renderPartuturanResult(result);
            } else {
                $('#partuturanResult').html('<div class="alert alert-danger">Gagal menghitung partuturan</div>');
            }
        });
    }

    function renderPartuturanResult(result) {
        const fromPerson = result.from_person || {};
        const toPerson = result.to_person || {};
        const path = result.path || [];

        const pathHtml = path.length > 1 ? `
            <p><strong>Jalur:</strong> ${path.map(p => p.nama).join(' → ')}</p>
        ` : '';

        $('#partuturanResult').html(`
            <div class="alert alert-success">
                <h6>Hasil Perhitungan Partuturan</h6>
                <hr>
                <p><strong>Dari:</strong> ${fromPerson.nama || 'Unknown'}</p>
                <p><strong>Ke:</strong> ${toPerson.nama || 'Unknown'}</p>
                <hr>
                <p><strong>Istilah Batak:</strong> <span class="badge bg-primary fs-6">${result.relationship || 'Tidak dapat ditentukan'}</span></p>
                <p><strong>Dalam Bahasa Indonesia:</strong> ${result.indonesian || '-'}</p>
                <p><strong>Penjelasan:</strong> ${result.explanation || '-'}</p>
                ${pathHtml}
            </div>
        `);
    }
});
