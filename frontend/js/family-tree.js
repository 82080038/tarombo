// Family Tree Page JavaScript
$(document).ready(function () {
    let allPersons = [];

    // Load persons on page load
    loadPersons();

    // Root person selection change
    $('#rootPersonSelect').on('change', function () {
        const rootId = $(this).val();
        if (rootId) {
            renderFamilyTree(rootId);
        } else {
            $('#familyTreeContainer').html('<div class="text-center"><p class="text-muted">Pilih anggota untuk menampilkan pohon tarombo</p></div>');
        }
    });

    function loadPersons() {
        API.getPersons().then(function (persons) {
            allPersons = persons;
            populateRootSelect(persons);
        });
    }

    function populateRootSelect(persons) {
        const select = $('#rootPersonSelect');
        select.empty();
        select.append('<option value="">Pilih Anggota</option>');
        persons.forEach(function (person) {
            const margaName = person.marga ? person.marga.nama : '';
            select.append(`<option value="${person.id}">${person.nama} ${margaName ? '(' + margaName + ')' : ''}</option>`);
        });
    }

    function renderFamilyTree(rootId) {
        const rootPerson = allPersons.find(p => p.id == rootId);
        if (!rootPerson) return;

        // Build tree data
        const treeData = buildTreeData(rootPerson, allPersons);

        // Clear container
        $('#familyTreeContainer').empty();

        // Simple tree rendering (can be enhanced with D3.js)
        renderSimpleTree(treeData);
    }

    function buildTreeData(person, allPersons, visited = new Set()) {
        if (visited.has(person.id)) return null;
        visited.add(person.id);

        const children = allPersons.filter(p => p.father_id == person.id || p.mother_id == person.id);

        return {
            id: person.id,
            nama: person.nama,
            marga: person.marga ? person.marga.nama : '',
            jenis_kelamin: person.jenis_kelamin,
            children: children.map(child => buildTreeData(child, allPersons, visited)).filter(c => c !== null)
        };
    }

    function renderSimpleTree(treeData) {
        const container = $('#familyTreeContainer');

        function renderNode(node, level = 0) {
            const indent = level * 30;
            const genderIcon = node.jenis_kelamin === 'L' ? '♂️' : '♀️';
            const genderClass = node.jenis_kelamin === 'L' ? 'text-primary' : 'text-danger';

            let html = `
                <div style="margin-left: ${indent}px; margin-bottom: 10px;">
                    <div class="card p-2" style="display: inline-block; min-width: 200px;">
                        <strong>${genderIcon} ${node.nama}</strong>
                        ${node.marga ? `<br><small class="text-muted">${node.marga}</small>` : ''}
                    </div>
                </div>
            `;

            if (node.children && node.children.length > 0) {
                node.children.forEach(child => {
                    html += renderNode(child, level + 1);
                });
            }

            return html;
        }

        container.html(renderNode(treeData));
    }
});
