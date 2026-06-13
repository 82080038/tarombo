# IMPLEMENTATION GUIDE
## Panduan Implementasi untuk Development Team

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Executive Summary](#1-executive-summary)
2. [Pre-Development Checklist](#2-pre-development-checklist)
3. [Development Phase Guide](#3-development-phase-guide)
4. [Ambiguity Resolution](#4-ambiguity-resolution)
5. [Technical Decisions Log](#5-technical-decisions-log)
6. [Risk Mitigation](#6-risk-mitigation)
7. [Definition of Done](#7-definition-of-done)

---

## 1. EXECUTIVE SUMMARY

### 1.1 Purpose

Dokumen ini mengkonversi **18 dokumen spesifikasi** menjadi **panduan implementasi yang actionable** untuk development team. Tidak ada lagi "mengambang" - setiap requirement memiliki:
- ✅ Acceptance criteria yang jelas
- ✅ Technical approach yang konkret
- ✅ Definition of Done (DoD)
- ✅ Test scenarios

### 1.2 Quick Reference

```
JIKA RAGU, LIHAT DOKUMEN INI:
═══════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────┐
│  Butuh aturan bisnis?  →  BUSINESS_RULE.md (BR-001 s/d BR-XXX) │
│  Butuh use case?       →  USE_CASE.md (UC-001 s/d UC-050)      │
│  Butuh database?       →  SQL_SCHEMA.md (tabel & relation)    │
│  Butuh API?            →  API_SPECIFICATION.md (endpoint)       │
│  Butuh workflow?       →  WORKFLOW_ADAT.md (alur proses)      │
│  Butuh UI?             →  UI_UX_GUIDELINE.md (mockup)         │
│  Butuh security?       →  SECURITY_ARCHITECTURE.md            │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. PRE-DEVELOPMENT CHECKLIST

### 2.1 Environment Setup (Week 1)

| # | Task | Responsible | Output | Verification |
|---|------|-------------|--------|--------------|
| 1 | Setup Git repository | Tech Lead | Repo initialized | `git log` shows initial commit |
| 2 | Setup CI/CD pipeline | DevOps | GitHub Actions working | Green build on push |
| 3 | Setup development database | Backend Lead | PostgreSQL running | Can connect via psql |
| 4 | Setup staging environment | DevOps | Staging URL accessible | Health check passes |
| 5 | Setup project management | PM | Jira/Linear board ready | All epics created |
| 6 | Setup communication channels | PM | Slack/Discord ready | Team joined |
| 7 | Cultural advisor onboarding | CPO | Tetua introduced | Meeting completed |
| 8 | Team kickoff meeting | CEO | All members aligned | Meeting minutes documented |

### 2.2 Technical Setup (Week 1-2)

**Backend (PHP 8.x + Node.js hybrid):**
```bash
# 1. Install dependencies
composer install          # PHP dependencies
npm install               # Node.js dependencies

# 2. Database setup
php artisan migrate       # Run migrations
php artisan db:seed       # Seed initial data

# 3. Graph database (Neo4j)
docker run -p 7474:7474 -p 7687:7687 neo4j:latest

# 4. Redis for caching
docker run -p 6379:6379 redis:latest

# 5. Verification
php artisan serve         # Backend runs on :8000
npm run dev               # Frontend dev server
```

**Frontend (React + D3.js):**
```bash
# 1. Create React app with TypeScript
npx create-react-app tarombo-frontend --template typescript

# 2. Install dependencies
npm install d3 react-query tailwindcss @radix-ui/react-*

# 3. Verification
npm start                 # App runs on :3000
npm test                  # Tests pass
```

### 2.3 Documentation Access Setup

| Resource | URL/Location | Access Level |
|----------|--------------|--------------|
| **MASTER_INDEX.md** | `/docs/MASTER_INDEX.md` | All team |
| **BUSINESS_RULE.md** | `/docs/BUSINESS_RULE.md` | All team |
| **API_SPECIFICATION.md** | `/docs/API_SPECIFICATION.md` | Backend, Frontend |
| **SQL_SCHEMA.md** | `/docs/SQL_SCHEMA.md` | Backend, DevOps |
| **UI_UX_GUIDELINE.md** | `/docs/UI_UX_GUIDELINE.md` | Frontend, Design |
| **Tetua Contact List** | `/docs/internal/tetua-contacts.md` | PM, CPO |
| **Staging Environment** | `https://staging.tarombo.digital` | All team |

---

## 3. DEVELOPMENT PHASE GUIDE

### 3.1 Phase 1: Core Genealogy (Sprint 1-4)

**Goal:** MVP dengan basic CRUD person dan family tree visualization.

#### Sprint 1: Person Management

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| P1-001 | Create person | Can add person with nama, marga, jenis_kelamin | BR-SYS-001, BR-MRG-001 | Input valid data → Person created → Appears in list |
| P1-002 | Edit person | Can update person data | BR-SYS-002 | Edit nama → Save → Data updated → Audit log created |
| P1-003 | Delete person | Can soft-delete person | BR-SYS-003, BR-HIS-003 | Delete → Status changed to 'deleted' → Not visible in tree but preserved |
| P1-004 | View person detail | Can see person with relationships | BR-ACC-001 | Click person → Detail modal opens → Shows parents, spouses, children |

**Technical Implementation:**
```php
// Backend: app/Http/Controllers/PersonController.php
class PersonController extends Controller
{
    /**
     * Create person (P1-001)
     * POST /api/persons
     * Business Rule: BR-SYS-001, BR-MRG-001
     */
    public function store(CreatePersonRequest $request)
    {
        // 1. Validate marga exists
        $marga = Marga::findOrFail($request->marga_id);
        
        // 2. Validate uniqueness (BR-SYS-002)
        $this->validateUniquePerson($request);
        
        // 3. Create person
        $person = Person::create([
            'nama' => $request->nama,
            'marga_id' => $request->marga_id,
            'jenis_kelamin' => $request->jenis_kelamin,
            'status' => 'active',
            'created_by' => auth()->id()
        ]);
        
        // 4. Create audit log (BR-HIS-001)
        AuditLog::create([
            'action' => 'CREATE',
            'entity_type' => 'person',
            'entity_id' => $person->id,
            'old_values' => null,
            'new_values' => $person->toArray(),
            'performed_by' => auth()->id()
        ]);
        
        return response()->json($person, 201);
    }
}
```

```javascript
// Frontend: src/components/PersonForm.tsx
const PersonForm: React.FC<Props> = ({ onSubmit }) => {
  const { register, handleSubmit, formState: { errors } } = useForm<PersonInput>();
  
  // P1-001 Acceptance: Form validates required fields
  // BR-SYS-001: Marga must be selected from valid marga list
  // BR-MRG-001: Marga inheritance follows patrilineal rule
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Input 
        {...register('nama', { required: 'Nama wajib diisi' })}
        label="Nama Lengkap"
        error={errors.nama?.message}
      />
      
      <MargaSelect 
        {...register('marga_id', { required: 'Marga wajib dipilih' })}
        label="Marga"
        helperText="Marga diturunkan dari ayah (patrilineal)"
      />
      
      <GenderSelect 
        {...register('jenis_kelamin', { required: true })}
        label="Jenis Kelamin"
      />
      
      <Button type="submit">Simpan</Button>
    </form>
  );
};
```

#### Sprint 2: Relationship Management

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| R2-001 | Add parent-child | Can link parent to child | BR-MRG-002 | Set father → Child's marga auto-set to father's marga |
| R2-002 | Add spouse | Can link husband-wife | BR-PRK-006, BR-PRK-007 | Create marriage → Validate not same marga → Set hula-hula/boru |
| R2-003 | Remove relationship | Can unlink with reason | BR-HIS-004 | Remove → Soft delete → Audit trail created |
| R2-004 | View tree | Can see family tree visualization | UC-04 | Load page → Tree renders → Can zoom/pan |

**Technical Implementation:**
```php
// Backend: Marriage validation (R2-002)
class MarriageController extends Controller
{
    public function store(CreateMarriageRequest $request)
    {
        $husband = Person::find($request->husband_id);
        $wife = Person::find($request->wife_id);
        
        // BR-PRK-006: Same marga marriage forbidden
        if ($husband->marga_id === $wife->marga_id) {
            throw new BusinessRuleException(
                'BR-PRK-006',
                'Perkawinan sesama marga dilarang'
            );
        }
        
        // BR-PRK-007: Specific marga pairs forbidden
        $forbiddenPairs = [
            ['Marbun', 'Sihotang'],
            ['Nainggolan', 'Siregar']
        ];
        
        foreach ($forbiddenPairs as $pair) {
            if (
                ($husband->marga->nama === $pair[0] && $wife->marga->nama === $pair[1]) ||
                ($husband->marga->nama === $pair[1] && $wife->marga->nama === $pair[0])
            ) {
                throw new BusinessRuleException(
                    'BR-PRK-007',
                    "Perkawinan {$pair[0]} - {$pair[1]} dilarang"
                );
            }
        }
        
        // Create marriage
        $marriage = Marriage::create([
            'husband_id' => $husband->id,
            'wife_id' => $wife->id,
            'tanggal_perkawinan' => $request->tanggal_perkawinan,
            'hula_hula_marga_id' => $wife->marga_id,  // Pemberi perempuan
            'boru_marga_id' => $husband->marga_id,    // Penerima perempuan
        ]);
        
        return response()->json($marriage, 201);
    }
}
```

```javascript
// Frontend: Tree visualization (R2-004)
import * as d3 from 'd3';

const FamilyTree: React.FC = () => {
  const svgRef = useRef<SVGSVGElement>(null);
  const { data: treeData } = useQuery(['tree', rootId], fetchTreeData);
  
  useEffect(() => {
    if (!treeData || !svgRef.current) return;
    
    // D3.js tree layout
    const svg = d3.select(svgRef.current);
    const root = d3.hierarchy(treeData);
    
    const treeLayout = d3.tree()
      .size([height, width])
      .separation((a, b) => (a.parent == b.parent ? 1 : 2) / a.depth);
    
    treeLayout(root);
    
    // Render nodes
    svg.selectAll('.node')
      .data(root.descendants())
      .join('g')
      .attr('class', 'node')
      .attr('transform', d => `translate(${d.y},${d.x})`)
      .on('click', handleNodeClick)  // Navigate to person detail
      .call(d3.drag()                 // Drag to rearrange
        .on('start', dragStarted)
        .on('drag', dragged)
        .on('end', dragEnded)
      );
    
    // Add zoom and pan
    svg.call(d3.zoom()
      .extent([[0, 0], [width, height]])
      .scaleExtent([0.1, 4])
      .on('zoom', zoomed)
    );
  }, [treeData]);
  
  return <svg ref={svgRef} width={width} height={height} />;
};
```

#### Sprint 3: Partuturan Engine

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| PT3-001 | Calculate Tulang | Show mother's brothers | BR-TUL-001, BR-TUL-002 | Input person → List Tulang with priority |
| PT3-002 | Calculate Namboru | Show father's sisters | BR-NBR-001, BR-NBR-002 | Input person → List Namboru |
| PT3-003 | Calculate Bere | Show sister's children | BR-BER-001 | Input person → List Bere |
| PT3-004 | Calculate Partuturan | Show address term between two people | BR-KKB-001 | Select two people → Show "Namboru", "Tulang", etc. |

**Technical Implementation:**
```php
// Backend: Partuturan calculation service
class PartuturanService
{
    /**
     * Calculate Tulang (mother's brothers)
     * Formula: IBU → SAUDARA LAKI-LAKI
     * BR-TUL-001, BR-TUL-002
     */
    public function calculateTulang(Person $person): array
    {
        // 1. Find mother
        $mother = $person->mother;
        if (!$mother) {
            return []; // No mother → No Tulang
        }
        
        // 2. Find mother's brothers (siblings with male gender)
        $tulangList = $mother->siblings()
            ->where('jenis_kelamin', 'L')
            ->with(['marga', 'children'])
            ->get();
        
        // 3. Calculate priority (BR-TUL-002)
        return $tulangList->map(function ($tulang) use ($person) {
            $priority = $this->calculateTulangPriority($tulang, $person);
            
            return [
                'person' => $tulang,
                'priority' => $priority,
                'distance' => $this->calculateDistance($person, $tulang),
                'is_alive' => $tulang->status === 'active',
                'children_count' => $tulang->children->count()
            ];
        })->sortBy('priority')->values()->all();
    }
    
    /**
     * Calculate relationship between two people
     * BR-KKB-001: Partuturan calculation
     */
    public function calculateRelationship(Person $from, Person $to): RelationshipResult
    {
        // 1. Find path using BFS
        $path = $this->findShortestPath($from, $to);
        
        // 2. Analyze path pattern
        $pattern = $this->analyzePathPattern($path);
        
        // 3. Map to partuturan term
        $partuturan = $this->mapToPartuturan($pattern, $from, $to);
        
        return new RelationshipResult(
            term: $partuturan->term,
            indonesian: $partuturan->indonesian,
            path: $path,
            explanation: $this->generateExplanation($path, $partuturan)
        );
    }
    
    private function findShortestPath(Person $from, Person $to): array
    {
        // BFS algorithm for family tree
        $queue = [[$from, [$from]]];
        $visited = [$from->id => true];
        
        while (!empty($queue)) {
            [$current, $path] = array_shift($queue);
            
            if ($current->id === $to->id) {
                return $path;
            }
            
            // Explore all relationships
            $relations = array_merge(
                $current->parents->all(),
                $current->children->all(),
                $current->spouses->all()
            );
            
            foreach ($relations as $next) {
                if (!isset($visited[$next->id])) {
                    $visited[$next->id] = true;
                    $queue[] = [$next, array_merge($path, [$next])];
                }
            }
        }
        
        throw new NoPathFoundException();
    }
}
```

#### Sprint 4: User Management & Auth

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| U4-001 | Register user | Can create account with email/HP | BR-SYS-001, BR-SYS-002 | Register → Verify email → Account active |
| U4-002 | Login | Can login with credentials | BR-ACC-001 | Login → JWT token → Access protected routes |
| U4-003 | Claim identity | Can link account to person in tree | WF-02 | Search person → Submit claim → Tetua approves |
| U4-004 | Role management | Admin can assign roles | BR-ACC-002 | Change role → Permissions updated → Audit log |

### 3.2 Phase 2: Adat Engine (Sprint 5-8)

#### Sprint 5: Dalihan Na Tolu Calculation

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| DNT5-001 | Calculate Hula-hula | Identify pihak pemberi perempuan | BR-HUL-001, BR-HUL-002 | Select person → List Hula-hula per acara |
| DNT5-002 | Calculate Boru | Identify pihak penerima perempuan | BR-BOR-001 | Select person → List Boru per acara |
| DNT5-003 | Calculate Dongan Tubu | Identify sesama marga | BR-DTG-001, BR-DTG-002 | Select person → Filter by marga/branch |
| DNT5-004 | Full Dalihan Na Tolu | Show complete trio structure | BR-DNT-001 | Generate → Hula-hula + Dongan Tubu + Boru |

#### Sprint 6: Ceremony Management

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| C6-001 | Create ceremony | Can create adat event | BR-ACR-001 | Create → Set type (wedding/death) → Save |
| C6-002 | Assign participants | Add people to ceremony roles | BR-ACR-002 | Assign Hula-hula role → Validate marga |
| C6-003 | Generate tata tertib | Auto-generate protocol | UC-20 | Generate → PDF with roles & responsibilities |
| C6-004 | Invitation list | Generate invitation based on scope | UC-21 | Set scope → Generate list → Export |

#### Sprint 7-8: Advanced Features

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| A7-001 | Punguan management | CRUD for organization | BR-PUN-001 | Create punguan → Add members → Manage |
| A7-002 | Iuran tracking | Record and verify payments | BR-PUN-002 | Input payment → Verify → Financial report |
| A7-003 | Bantuan duka | Calculate and disburse assistance | BR-BND-001 | Input death → Validate membership → Calculate |
| A7-004 | Document upload | Store and manage media | BR-DOK-001 | Upload → Set permissions → Access control |

### 3.3 Phase 3: AI & Advanced (Sprint 9-12)

#### Sprint 9-10: AI Tarombo

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| AI9-001 | NLP query | Understand natural language questions | BR-AIT-001 | "Siapa Tulang saya?" → Parse → Answer |
| AI9-002 | Relationship inference | Suggest relationships from data | BR-AIT-002 | Analyze pattern → Suggest → Evidence |
| AI9-003 | Explainable AI | Show reasoning path | BR-AIT-003 | Query → Result + Path explanation |

#### Sprint 11-12: Polish & Scale

**Stories:**
| ID | Story | Acceptance Criteria | Business Rule | Test Scenario |
|----|-------|---------------------|---------------|---------------|
| P11-001 | Performance optimization | Load time < 2s | Non-functional | Lighthouse score > 90 |
| P11-002 | Security audit | Pass penetration test | SECURITY | No critical vulnerabilities |
| P11-003 | Mobile app launch | iOS + Android published | Non-functional | Available on App Store/Play Store |
| P11-004 | Production deployment | Live with monitoring | Non-functional | 99.9% uptime |

---

## 4. AMBIGUITY RESOLUTION

### 4.1 Common Ambiguities & Solutions

| Ambiguity | Source Document | Resolution | Implementation |
|-----------|-----------------|------------|----------------|
| **"User biasa" vs "Verified User"** | USE_CASE.md | UC-01 s/d UC-06 = User Biasa, UC-07+ = Verified | Role field in `users` table: `role ENUM('guest', 'user', 'verified', 'tetua', 'admin')` |
| **Partuturan context** | KAMUS_ISTILAH | Ada perbedaan acara vs sehari-hari | `context` parameter: `context ENUM('daily', 'wedding', 'death', 'baptism')` |
| **Marga validation** | BUSINESS_RULE | BR-MRG-001 vs BR-PRK-006 | Implement sebagai middleware: `MargaValidationMiddleware` |
| **Privacy levels** | ANALISIS_BUDAYA | 4 levels: Public, Restricted, Confidential, Sensitive | `privacy_level ENUM('public', 'restricted', 'confidential', 'sensitive')` |
| **Sub-suku config** | BUSINESS_RULE | 6 sub-suku dengan aturan berbeda | `sub_suku_config` table dengan JSON rules |

### 4.2 Decision Trees

```
SAAT RAGU IMPLEMENTASI:
═══════════════════════════════════════════════════════════════

1. User melakukan perubahan data?
   ├── Ya → Masuk antrian verifikasi (BR-VAL-001)
   └── Tidak → Langsung update (jika admin)

2. Perubahan melibatkan hubungan kritis (ayah/ibu)?
   ├── Ya → Require 2-level approval (WF-05)
   └── Tidak → Single verifikator approval (WF-06)

3. Perkawinan dicek?
   ├── Sesama marga → REJECT (BR-PRK-006)
   ├── Specific forbidden pair → REJECT (BR-PRK-007)
   └── Different marga, not forbidden → APPROVE

4. Query partuturan untuk acara?
   ├── Wedding → Hula-hula = pihak pemberi perempuan
   ├── Death → Hula-hula = mayat's family
   └── Default → Daily context (no special rules)
```

### 4.3 Edge Cases Handling

| Edge Case | Scenario | Solution |
|-----------|----------|----------|
| **Orphan node** | Person tanpa parent di tree | Allow, mark as `is_root = true`, bisa jadi entry point |
| **Circular relationship** | A → B → C → A | Validation di API, graph algorithm detect cycle |
| **Multiple marriages** | Polygamy (Mandailing) | `marriages` table dengan `is_current` flag |
| **Same person, different data** | Conflict antar sources | Workflow verifikasi dengan evidence comparison |
| **Missing generation** | Gap di tree | Allow, tandai dengan `generation_estimated = true` |
| **Conversion religion** | Adat vs agama conflict | Store both, prioritaskan sesuai context acara |

---

## 5. TECHNICAL DECISIONS LOG

### 5.1 Decisions Made

| # | Decision | Alternatives | Rationale | Impact |
|---|----------|--------------|-----------|--------|
| 1 | **PHP Backend + React Frontend** | Pure Node.js | Leverage existing PHP skill, hire React dev | Hybrid architecture |
| 2 | **PostgreSQL + Neo4j** | Single MySQL | Relational untuk data, Graph untuk relationships | Dual database |
| 3 | **REST API (not GraphQL)** | GraphQL | Simpler untuk tim PHP, easier caching | Standard REST |
| 4 | **BFS untuk path finding** | DFS, A* | BFS guarantees shortest path | Algorithm choice |
| 5 | **JWT for auth** | Session-based | Stateless, mobile-friendly | Authentication |
| 6 | **Soft delete semua** | Hard delete | Audit trail, data recovery | Data retention |
| 7 | **Event-driven untuk audit** | Synchronous audit | Non-blocking, async processing | Performance |

### 5.2 Pending Decisions (Butuh input)

| # | Decision | Options | Tim yang harus decide | Deadline |
|---|----------|---------|----------------------|----------|
| 1 | **Payment gateway** | Midtrans, Xendit, Stripe | COO + CTO | Sprint 7 |
| 2 | **Push notification** | Firebase, OneSignal, custom | Tech Lead | Sprint 4 |
| 3 | **File storage** | AWS S3, MinIO, local | DevOps | Sprint 2 |
| 4 | **Search engine** | Elasticsearch, PostgreSQL FTS, Algolia | Backend Lead | Sprint 3 |

---

## 6. RISK MITIGATION

### 6.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Tree visualization performance** | High | High | Virtual scrolling, lazy loading, WebGL for large trees |
| **Graph database learning curve** | High | Medium | Training, hire consultant, gradual migration |
| **Partuturan calculation accuracy** | Medium | Critical | Tetua validation, extensive testing, human review |
| **Mobile offline sync** | Medium | High | Robust conflict resolution, extensive testing |
| **Scalability dengan data besar** | Medium | High | Partitioning, caching, CDN, load balancing |

### 6.2 Cultural Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Tetua resistance** | Medium | Critical | Early involvement, education, show benefits |
| **Adat variation conflicts** | High | Medium | Configurable rules per sub-suku |
| **Community trust** | Medium | High | Transparency, audit trail, tetua validation |
| **Privacy concerns** | High | Medium | Granular privacy, encryption, consent |

### 6.3 Business Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Free competitor (FamilySearch)** | High | Medium | Differentiation, cultural features, tetua network |
| **Slow user adoption** | Medium | High | Community engagement, education, ease of use |
| **Revenue model failure** | Low | High | Multiple streams, B2B focus, pivot ready |

---

## 7. DEFINITION OF DONE

### 7.1 Universal DoD (Semua Stories)

```
DEFINITION OF DONE
═══════════════════════════════════════════════════════════════

✅ Code complete dan pushed ke repo
✅ Unit tests written dan passing (coverage > 80%)
✅ Integration tests passing
✅ Code review approved oleh 1 senior dev
✅ Documentation updated (API docs, README)
✅ No critical atau high security vulnerabilities
✅ Performance acceptable (response time < 500ms)
✅ Accepts criteria dari story terpenuhi
✅ Tested di staging environment
✅ Business rules implemented sesuai BR-XXX
✅ Audit logging implemented
✅ Error handling proper (tidak ada silent failures)
```

### 7.2 DoD per Story Type

**Backend Stories:**
- API endpoint sesuai spec
- Request/response validation
- Error handling dengan proper HTTP codes
- Database migration (if schema change)
- Business rule validation middleware

**Frontend Stories:**
- UI sesuai mockup
- Responsive design (mobile, tablet, desktop)
- Loading states dan error states
- Form validation client-side
- Accessibility (ARIA labels, keyboard nav)

**Database Stories:**
- Migration script
- Rollback script
- Index untuk performance
- Data seeding (if needed)
- Schema documentation

**Integration Stories:**
- End-to-end tests
- Third-party service mocking
- Fallback mechanisms
- Timeout handling

---

## APPENDIX: QUICK REFERENCE

### A. File Structure

```
tarombo-digital/
├── backend/
│   ├── app/
│   │   ├── Http/
│   │   │   └── Controllers/
│   │   │       ├── PersonController.php
│   │   │       ├── MarriageController.php
│   │   │       └── PartuturanController.php
│   │   ├── Services/
│   │   │   ├── PartuturanService.php
│   │   │   ├── DalihanNaToluService.php
│   │   │   └── RelationshipService.php
│   │   └── Models/
│   │       ├── Person.php
│   │       ├── Marga.php
│   │       └── Marriage.php
│   ├── database/
│   │   └── migrations/
│   └── tests/
│       └── Feature/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── PersonForm.tsx
│   │   │   ├── FamilyTree.tsx
│   │   │   └── PartuturanCalculator.tsx
│   │   ├── services/
│   │   │   └── api.ts
│   │   └── hooks/
│   │       └── usePartuturan.ts
│   └── tests/
├── mobile/
│   └── (React Native atau Flutter)
├── docs/
│   └── (semua 18 dokumen)
└── docker/
    └── docker-compose.yml
```

### B. Useful Commands

```bash
# Development
php artisan serve              # Start backend
npm run dev                    # Start frontend
php artisan test               # Run backend tests
npm test                       # Run frontend tests

# Database
php artisan migrate:fresh --seed   # Reset & seed DB
php artisan db:seed --class=MargaSeeder

# Code quality
./vendor/bin/phpstan analyse   # Static analysis
./vendor/bin/pint              # PHP CS Fixer
npm run lint                   # ESLint

# Deployment
git push origin main           # Trigger CI/CD
```

### C. Emergency Contacts

| Role | Name | Contact | Responsibility |
|------|------|---------|----------------|
| Tech Lead | TBD | tech-lead@tarombo.digital | Technical decisions |
| CPO | TBD | cpo@tarombo.digital | Product decisions |
| Cultural Advisor | Tetua Board | tetua@tarombo.digital | Adat validation |
| DevOps | TBD | devops@tarombo.digital | Infrastructure |

---

## CONCLUSION

> **"Dokumen ini adalah bridge antara 18 dokumen spesifikasi dan actual implementation. Dengan acceptance criteria yang jelas, technical approach yang konkret, dan definition of done yang terdefinisi, development team tidak akan mengambang."**

**Next Action:** Setup development environment dan mulai Sprint 1.

© 2026 Tarombo Digital Project
