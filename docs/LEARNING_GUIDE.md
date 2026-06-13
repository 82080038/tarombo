# LEARNING GUIDE
## Panduan Pembelajaran Teknologi untuk Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Overview](#1-overview)
2. [Backend Engineer (12 weeks)](#2-backend-engineer-12-weeks)
3. [Frontend Engineer (12 weeks)](#3-frontend-engineer-12-weeks)
4. [Quick Reference](#4-quick-reference)

---

## 1. OVERVIEW

### Technology Stack

| Layer | Technologies | Learning Priority |
|-------|--------------|-------------------|
| **Backend** | PHP 8.x, PostgreSQL, Neo4j | 🔴 High |
| **Frontend** | React 18, TypeScript, D3.js | 🔴 High |
| **Mobile** | React Native | 🟡 Medium |
| **DevOps** | Docker, GitHub Actions | 🟢 Low |

---

## 2. BACKEND ENGINEER (12 weeks)

### Week 1-2: PHP 8.x Modern

```php
<?php
// PHP 8.x Features untuk Tarombo

// 1. Named Arguments
createPerson(nama: 'John', marga: $marga, jenisKelamin: 'L');

// 2. Union Types
function findPerson(int|string $id): Person|null {}

// 3. Match Expression
$kategori = match($acara) {
    'pernikahan' => 'Pemberkatan',
    'kematian' => 'Saur Matua',
    default => 'Acara Adat'
};

// 4. Nullsafe Operator
$hulaHula = $person?->mother?->siblings()?->first();

// 5. Constructor Property Promotion
class Person {
    public function __construct(
        public string $nama,
        public Marga $marga,
        private ?Person $father = null,
    ) {}
}

// 6. Enums
enum StatusVerifikasi: string {
    case DRAFT = 'draft';
    case PENDING = 'pending';
    case VERIFIED = 'verified';
}
```

**Resources:**
- PHP The Right Way (https://phptherightway.com/)
- Laravel Documentation (https://laravel.com/docs/)

**Project:** REST API untuk Marga Management

---

### Week 3-4: PostgreSQL Advanced

```sql
-- Recursive CTE untuk Family Tree (CRITICAL)
WITH RECURSIVE tree AS (
    SELECT id, nama, parent_id, 0 as depth
    FROM persons WHERE parent_id IS NULL
    UNION ALL
    SELECT p.id, p.nama, p.parent_id, t.depth + 1
    FROM persons p
    JOIN tree t ON p.parent_id = t.id
)
SELECT * FROM tree;

-- Window Functions
SELECT 
    nama,
    marga_id,
    ROW_NUMBER() OVER (PARTITION BY marga_id ORDER BY created_at) as no_urut
FROM persons;

-- JSON Operations
SELECT 
    nama,
    data->>'tempat_lahir' as tempat_lahir
FROM persons
WHERE data @> '{"status": "menikah"}';
```

**Resources:**
- PostgreSQL Tutorial (https://www.postgresqltutorial.com/)
- Use The Index, Luke (https://use-the-index-luke.com/)

**Project:** Database dengan 100K dummy records + recursive queries

---

### Week 5-6: Neo4j Graph Database

```cypher
-- Create nodes
CREATE (p:Person {id: 1, nama: 'John', marga: 'Simanjuntak'})
CREATE (c:Person {id: 2, nama: 'Jane', marga: 'Simanjuntak'})

-- Create relationship
CREATE (p)-[:PARENT_OF]->(c)

-- Find shortest path
MATCH path = shortestPath(
    (a:Person {id: 1})-[*]-(b:Person {id: 5})
)
RETURN path

-- Find all Tulang (mother's brothers)
MATCH (person:Person {id: 1})-[:CHILD_OF]->(mother:Person)
MATCH (mother)-[:SIBLING_OF]->(tulang:Person)
WHERE tulang.jenis_kelamin = 'L'
RETURN tulang
```

**Resources:**
- Neo4j Graph Academy (https://neo4j.com/graphacademy/)
- Cypher Reference Card

**Project:** Graph-based Relationship Finder dengan 1000 persons

---

### Week 7-8: Algorithms untuk Genealogy

```php
<?php
// BFS untuk find relatives by level
function findRelativesByLevel(Person $start, int $maxDepth): array {
    $queue = [[$start, 0]];
    $visited = [$start->id => true];
    $result = [];
    
    while (!empty($queue)) {
        [$current, $depth] = array_shift($queue);
        
        if ($depth > $maxDepth) continue;
        
        $result[] = ['person' => $current, 'depth' => $depth];
        
        foreach ($current->getAllRelations() as $next) {
            if (!isset($visited[$next->id])) {
                $visited[$next->id] = true;
                $queue[] = [$next, $depth + 1];
            }
        }
    }
    
    return $result;
}

// Lowest Common Ancestor (LCA)
function findLCA(Person $p, Person $q): ?Person {
    $ancestorsP = getAllAncestors($p);
    $ancestorsQ = getAllAncestors($q);
    
    foreach ($ancestorsP as $ancestor) {
        if (in_array($ancestor, $ancestorsQ)) {
            return $ancestor;
        }
    }
    return null;
}
```

**Resources:**
- Introduction to Algorithms (CLRS)
- LeetCode (https://leetcode.com/) - Tree & Graph problems

**Project:** Partuturan Calculator (Tulang, Namboru, Bere)

---

### Week 9-10: REST API & Security

```php
<?php
// Laravel Controller dengan Business Rules
class MarriageController extends Controller
{
    public function store(Request $request)
    {
        $husband = Person::find($request->husband_id);
        $wife = Person::find($request->wife_id);
        
        // BR-PRK-006: Same marga forbidden
        if ($husband->marga_id === $wife->marga_id) {
            throw new BusinessRuleException('BR-PRK-006');
        }
        
        // BR-PRK-007: Forbidden pairs
        $forbidden = [['Marbun', 'Sihotang'], ['Nainggolan', 'Siregar']];
        foreach ($forbidden as $pair) {
            if (in_array($husband->marga->nama, $pair) && 
                in_array($wife->marga->nama, $pair)) {
                throw new BusinessRuleException('BR-PRK-007');
            }
        }
        
        return Marriage::create([...]);
    }
}

// JWT Authentication
$token = JWTAuth::fromUser($user);

// Middleware untuk Role Check
public function handle($request, Closure $next, $role)
{
    if (!auth()->user()->hasRole($role)) {
        return response()->json(['error' => 'Forbidden'], 403);
    }
    return $next($request);
}
```

**Resources:**
- REST API Design Rulebook (Mark Masse)
- OWASP API Security Top 10

**Project:** Secure API dengan JWT + Role-based access

---

### Week 11-12: Business Rules Engine

```php
<?php
// Business Rules Engine untuk Batak Culture
class BusinessRuleEngine
{
    private array $rules = [];
    
    public function register(string $code, callable $rule): void
    {
        $this->rules[$code] = $rule;
    }
    
    public function validate(string $code, $context): ValidationResult
    {
        if (!isset($this->rules[$code])) {
            throw new RuleNotFoundException($code);
        }
        
        return ($this->rules[$code])($context);
    }
}

// Register rules
$engine->register('BR-MRG-001', function($context) {
    // Patrilineal inheritance
    if ($context['father']) {
        return ValidationResult::success([
            'marga' => $context['father']->marga
        ]);
    }
    return ValidationResult::failure('Father required for marga inheritance');
});

$engine->register('BR-PRK-006', function($context) {
    // No same marga marriage
    if ($context['husband']->marga_id === $context['wife']->marga_id) {
        return ValidationResult::failure('Same marga marriage forbidden');
    }
    return ValidationResult::success();
});
```

**Resources:**
- Rules Engines (Martin Fowler)
- Domain-Driven Design (Eric Evans)

**Project:** Implement 20+ Business Rules dari BUSINESS_RULE.md

---

## 3. FRONTEND ENGINEER (12 weeks)

### Week 1-2: React + TypeScript

```tsx
// React dengan TypeScript strict mode
import { useState, useEffect } from 'react';

interface Person {
    id: string;
    nama: string;
    marga: Marga;
    jenisKelamin: 'L' | 'P';
    father?: Person;
    mother?: Person;
}

const PersonCard: React.FC<{ person: Person }> = ({ person }) => {
    return (
        <div className="bg-white rounded-lg shadow p-4">
            <h3 className="text-lg font-bold">{person.nama}</h3>
            <p className="text-gray-600">Marga {person.marga.nama}</p>
        </div>
    );
};

// React Query untuk data fetching
import { useQuery } from '@tanstack/react-query';

const usePerson = (id: string) => {
    return useQuery({
        queryKey: ['person', id],
        queryFn: () => fetch(`/api/persons/${id}`).then(r => r.json()),
    });
};
```

**Resources:**
- React Documentation (https://react.dev/)
- TypeScript Handbook (https://www.typescriptlang.org/docs/)
- Epic React by Kent C. Dodds

**Project:** Person Management UI dengan React Query

---

### Week 3-4: TailwindCSS + Component Architecture

```tsx
// Design System dengan Tailwind
const Button: React.FC<{
    variant?: 'primary' | 'secondary' | 'danger';
    size?: 'sm' | 'md' | 'lg';
    children: React.ReactNode;
}> = ({ variant = 'primary', size = 'md', children }) => {
    const classes = `
        rounded font-medium transition-colors
        ${variant === 'primary' ? 'bg-blue-600 text-white hover:bg-blue-700' : ''}
        ${variant === 'secondary' ? 'bg-gray-200 text-gray-800 hover:bg-gray-300' : ''}
        ${variant === 'danger' ? 'bg-red-600 text-white hover:bg-red-700' : ''}
        ${size === 'sm' ? 'px-3 py-1 text-sm' : ''}
        ${size === 'md' ? 'px-4 py-2' : ''}
        ${size === 'lg' ? 'px-6 py-3 text-lg' : ''}
    `;
    
    return <button className={classes}>{children}</button>;
};

// Form dengan shadcn/ui
import { Input, Label, Select } from '@/components/ui';

const PersonForm: React.FC = () => {
    return (
        <form className="space-y-4">
            <div>
                <Label htmlFor="nama">Nama Lengkap</Label>
                <Input id="nama" placeholder="Masukkan nama" />
            </div>
            <div>
                <Label htmlFor="marga">Marga</Label>
                <Select id="marga" options={margaOptions} />
            </div>
        </form>
    );
};
```

**Resources:**
- TailwindCSS Documentation
- shadcn/ui (https://ui.shadcn.com/)
- Radix UI (https://www.radix-ui.com/)

**Project:** Design System untuk Tarombo

---

### Week 5-8: D3.js & Tree Visualization (CRITICAL)

```tsx
import * as d3 from 'd3';
import { useRef, useEffect } from 'react';

const FamilyTree: React.FC<{ data: TreeNode }> = ({ data }) => {
    const svgRef = useRef<SVGSVGElement>(null);
    
    useEffect(() => {
        if (!svgRef.current) return;
        
        const svg = d3.select(svgRef.current);
        const root = d3.hierarchy(data);
        
        // Tree layout
        const treeLayout = d3.tree()
            .size([height, width])
            .separation((a, b) => (a.parent == b.parent ? 1 : 2) / a.depth);
        
        treeLayout(root);
        
        // Render links
        svg.selectAll('.link')
            .data(root.links())
            .join('path')
            .attr('class', 'link')
            .attr('d', d3.linkHorizontal()
                .x(d => d.y)
                .y(d => d.x)
            );
        
        // Render nodes
        const node = svg.selectAll('.node')
            .data(root.descendants())
            .join('g')
            .attr('class', 'node')
            .attr('transform', d => `translate(${d.y},${d.x})`)
            .on('click', (e, d) => handleNodeClick(d.data));
        
        node.append('circle')
            .attr('r', 20)
            .attr('fill', d => d.data.jenisKelamin === 'L' ? '#3b82f6' : '#ec4899');
        
        node.append('text')
            .text(d => d.data.nama)
            .attr('dy', 35);
        
        // Zoom & Pan
        svg.call(d3.zoom()
            .extent([[0, 0], [width, height]])
            .scaleExtent([0.1, 4])
            .on('zoom', (e) => svg.select('g').attr('transform', e.transform))
        );
    }, [data]);
    
    return <svg ref={svgRef} width={800} height={600} />;
};
```

**Resources:**
- D3.js Documentation (https://d3js.org/)
- Observable (https://observablehq.com/)
- React + D3 integration patterns

**Project:** Interactive Family Tree dengan zoom, pan, drag

---

### Week 9-10: Advanced Patterns & Performance

```tsx
// Performance: React.memo, useMemo, useCallback
const PersonList: React.FC<{ persons: Person[] }> = React.memo(({ persons }) => {
    const sortedPersons = useMemo(() => 
        persons.sort((a, b) => a.nama.localeCompare(b.nama)),
        [persons]
    );
    
    const handleSelect = useCallback((id: string) => {
        // handle selection
    }, []);
    
    return (
        <VirtualList
            items={sortedPersons}
            renderItem={(person) => (
                <PersonCard 
                    key={person.id} 
                    person={person}
                    onSelect={handleSelect}
                />
            )}
        />
    );
});

// Form dengan React Hook Form + Zod
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

const schema = z.object({
    nama: z.string().min(2, 'Nama minimal 2 karakter'),
    marga: z.string().uuid('Pilih marga'),
    tanggalLahir: z.date().optional(),
});

const CreatePersonForm: React.FC = () => {
    const { register, handleSubmit, formState: { errors } } = useForm({
        resolver: zodResolver(schema),
    });
    
    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            <Input {...register('nama')} error={errors.nama?.message} />
            <Button type="submit">Simpan</Button>
        </form>
    );
};
```

**Resources:**
- Advanced React Patterns
- Web Vitals (https://web.dev/vitals/)

**Project:** Offline-first PWA dengan Service Workers

---

### Week 11-12: Cultural UX Integration

```tsx
// Cultural Context dalam UX
const CeremonyWorkflow: React.FC = () => {
    const [step, setStep] = useState(1);
    
    // Stepper untuk ceremony creation
    const steps = [
        { id: 1, label: 'Jenis Acara', description: 'Pilih jenis acara adat' },
        { id: 2, label: 'Suhut', description: 'Tentukan tuan rumah' },
        { id: 3, label: 'Hula-Hula', description: 'Pihak pemberi perempuan' },
        { id: 4, label: 'Boru', description: 'Pihak menerima perempuan' },
        { id: 5, label: 'Review', description: 'Review dan generate tata tertib' },
    ];
    
    return (
        <div className="max-w-4xl mx-auto">
            <Stepper steps={steps} currentStep={step} />
            
            {step === 1 && <AcaraTypeSelector />}
            {step === 2 && <SuhutSelector />}
            {step === 3 && <HulaHulaSelector />}
            {step === 4 && <BoruSelector />}
            {step === 5 && <ReviewAndGenerate />}
        </div>
    );
};

// Partuturan Calculator dengan cultural context
const PartuturanCalculator: React.FC = () => {
    const [personA, setPersonA] = useState<Person | null>(null);
    const [personB, setPersonB] = useState<Person | null>(null);
    const [context, setContext] = useState<'daily' | 'wedding' | 'death'>('daily');
    
    const { data: result } = usePartuturan(personA?.id, personB?.id, context);
    
    return (
        <div className="p-6 bg-amber-50 rounded-lg border-2 border-amber-200">
            <h2 className="text-xl font-bold text-amber-900 mb-4">
                Kalkulator Partuturan
            </h2>
            
            <ContextSelector value={context} onChange={setContext} />
            
            <div className="grid grid-cols-2 gap-4 my-4">
                <PersonSelector 
                    label="Orang A" 
                    value={personA} 
                    onSelect={setPersonA} 
                />
                <PersonSelector 
                    label="Orang B" 
                    value={personB} 
                    onSelect={setPersonB} 
                />
            </div>
            
            {result && (
                <div className="bg-white p-4 rounded shadow">
                    <h3 className="text-2xl font-bold text-center">
                        {result.term}
                    </h3>
                    <p className="text-center text-gray-600">
                        {result.indonesian}
                    </p>
                    <div className="mt-4 text-sm">
                        <p>Jalur: {result.pathDescription}</p>
                    </div>
                </div>
            )}
        </div>
    );
};
```

**Resources:**
- UI_UX_GUIDELINE.md (internal)
- Analisis Budaya Batak (internal)

**Project:** Adat Ceremony Workflow dengan Tata Tertib generator

---

## 4. QUICK REFERENCE

### Git Commands

```bash
# Basic
git clone <repo>
git checkout -b feature/nama-fitur
git add .
git commit -m "feat: deskripsi"
git push origin feature/nama-fitur

# Advanced
git rebase main
git merge --no-ff
git cherry-pick <commit>
git stash / git stash pop
```

### HTTP Status Codes

| Code | Meaning | Usage |
|------|---------|-------|
| 200 | OK | GET success |
| 201 | Created | POST success |
| 400 | Bad Request | Validation error |
| 401 | Unauthorized | Not authenticated |
| 403 | Forbidden | No permission |
| 404 | Not Found | Resource tidak ada |
| 422 | Unprocessable | Business rule error |
| 500 | Server Error | Internal error |

### SQL Quick Reference

```sql
-- Select
SELECT * FROM persons WHERE marga_id = 1;

-- Join
SELECT p.nama, m.nama as marga 
FROM persons p 
JOIN marga m ON p.marga_id = m.id;

-- Recursive CTE
WITH RECURSIVE ancestors AS (
    SELECT id, nama, father_id, 0 as level
    FROM persons WHERE id = 1
    UNION ALL
    SELECT p.id, p.nama, p.father_id, a.level + 1
    FROM persons p
    JOIN ancestors a ON p.id = a.father_id
)
SELECT * FROM ancestors;

-- Aggregation
SELECT marga_id, COUNT(*) as jumlah 
FROM persons 
GROUP BY marga_id;
```

### React Hooks Quick Reference

```tsx
// useState
const [count, setCount] = useState(0);

// useEffect
useEffect(() => {
    // side effect
    return () => {
        // cleanup
    };
}, [dependency]);

// useCallback
const handleClick = useCallback(() => {
    // function
}, [dependency]);

// useMemo
const expensive = useMemo(() => {
    return computeExpensiveValue(a, b);
}, [a, b]);

// Custom Hook
function usePerson(id: string) {
    return useQuery({
        queryKey: ['person', id],
        queryFn: () => fetchPerson(id),
    });
}
```

---

## CONCLUSION

> **"24 weeks (12 backend + 12 frontend) untuk master teknologi Tarombo Digital. Fokus pada practical projects yang langsung relevan dengan domain genealogy dan Batak culture."**

**Prinsip Belajar:**
1. Contextual - Dalam konteks genealogy/culture
2. Progressive - Dari basic ke advanced
3. Hands-on - Project-based learning
4. Collaborative - Bersama tim

**Next Steps:**
1. Mulai dari Week 1 sesuai role
2. Build projects secara bertahap
3. Code review dengan senior
4. Integrate dengan cultural knowledge

© 2026 Tarombo Digital Project
