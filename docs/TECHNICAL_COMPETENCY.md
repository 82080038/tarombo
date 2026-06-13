# TECHNICAL COMPETENCY MATRIX
## Kompetensi Teknis Programmer untuk Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Overview](#1-overview)
2. [Backend Engineer Competencies](#2-backend-engineer-competencies)
3. [Frontend Engineer Competencies](#3-frontend-engineer-competencies)
4. [Mobile Engineer Competencies](#4-mobile-engineer-competencies)
5. [Data/AI Engineer Competencies](#5-dataai-engineer-competencies)
6. [DevOps Engineer Competencies](#6-devops-engineer-competencies)
7. [QA Engineer Competencies](#7-qa-engineer-competencies)
8. [Required Soft Skills](#8-required-soft-skills)

---

## 1. OVERVIEW

### 1.1 Tech Stack Summary

```
TAROMBO DIGITAL TECH STACK
═══════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND LAYER                           │
│  • React 18+ / Next.js 14 (Web)                              │
│  • TypeScript (Strict mode)                                  │
│  • TailwindCSS + shadcn/ui                                   │
│  • D3.js / Cytoscape.js (Tree Visualization)                 │
│  • React Query / TanStack Query                              │
│  • PWA (Progressive Web App)                                 │
├─────────────────────────────────────────────────────────────┤
│                    MOBILE LAYER                               │
│  • React Native (Cross-platform)                             │
│  • OR Flutter 3.x (Alternative)                              │
│  • Offline-first architecture                                │
│  • Biometric auth (Face ID / Fingerprint)                    │
├─────────────────────────────────────────────────────────────┤
│                    BACKEND LAYER                              │
│  • Node.js (NestJS) OR Go (Gin/Echo)                       │
│  • PostgreSQL 15+ (Primary DB)                               │
│  • Redis (Caching, Sessions)                                 │
│  • Neo4j / Apache Age (Graph DB for relationships)           │
│  • Elasticsearch (Full-text search)                          │
│  • MinIO / AWS S3 (Object storage)                          │
├─────────────────────────────────────────────────────────────┤
│                    DATA & AI LAYER                            │
│  • Python (FastAPI)                                          │
│  • TensorFlow / PyTorch (ML models)                          │
│  • spaCy / HuggingFace (NLP)                                 │
│  • Apache Airflow (Data pipelines)                           │
│  • Pandas, NumPy (Data processing)                           │
├─────────────────────────────────────────────────────────────┤
│                    INFRASTRUCTURE                             │
│  • Docker & Kubernetes                                        │
│  • AWS / GCP / DigitalOcean                                  │
│  • Terraform (Infrastructure as Code)                        │
│  • GitHub Actions (CI/CD)                                      │
│  • Prometheus + Grafana (Monitoring)                         │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Competency Levels

| Level | Deskripsi | Pengalaman |
|-------|-----------|------------|
| **L1 - Beginner** | Dapat coding dengan supervisi | 0-2 tahun |
| **L2 - Intermediate** | Dapat bekerja independently | 2-4 tahun |
| **L3 - Advanced** | Dapat lead feature/module | 4-7 tahun |
| **L4 - Expert** | Dapat architect system | 7+ tahun |

---

## 2. BACKEND ENGINEER COMPETENCIES

### 2.1 Core Backend Engineer (Genealogy)

#### **Wajib Kuasai (Must Have):**

**A. Programming Languages (Pilih Satu Stack):**
```
OPTION 1 - Node.js Stack:
├── JavaScript/TypeScript (ES2022+)
├── Node.js runtime internals
├── Async/await, Event loop, Streams
└── Package management (npm/yarn/pnpm)

OPTION 2 - Go Stack:
├── Go 1.21+
├── Goroutines, Channels
├── Interface composition
└── Error handling patterns
```

**B. Frameworks:**
- **NestJS** (Node.js) - Modular architecture, Dependency injection
- **Gin/Echo** (Go) - High-performance routing, Middleware
- **FastAPI** (Python) - Type hints, Async, Auto docs (untuk AI service)

**C. Databases (Wajib Kuasai SEMUA):**
```
RELATIONAL DATABASE:
├── PostgreSQL 15+
│   ├── Complex JOINs (recursive CTEs)
│   ├── Window functions (ROW_NUMBER, LAG, LEAD)
│   ├── JSON/JSONB operations
│   ├── Full-text search (tsvector, tsquery)
│   ├── Partitioning strategies
│   └── Performance tuning (EXPLAIN ANALYZE)
│
GRAPH DATABASE (CRITICAL untuk Tarombo):
├── Neo4j OR Apache Age (PostgreSQL extension)
│   ├── Cypher query language
│   ├── Graph traversal algorithms
│   ├── Shortest path algorithms
│   ├── Relationship depth queries
│   └── Graph modeling (nodes, edges, properties)
│
CACHE & QUEUE:
├── Redis
│   ├── Data structures (strings, hashes, sets, sorted sets)
│   ├── Pub/sub messaging
│   ├── Caching strategies (LRU, TTL)
│   └── Redis Sentinel/Cluster
│
SEARCH ENGINE:
├── Elasticsearch
│   ├── Index mapping, analyzers
│   ├── Query DSL (bool, match, filter)
│   ├── Aggregations
│   └── Relevance scoring
```

**D. Algorithms & Data Structures (CRITICAL):**
```
TREE ALGORITHMS (Untuk Genealogy):
├── Tree traversal (DFS: pre/in/post order, BFS)
├── Lowest Common Ancestor (LCA) algorithms
├── Tree reconstruction from traversal data
├── AVL Trees / Red-Black Trees (self-balancing)
└── B-Trees (database indexing)

GRAPH ALGORITHMS (Untuk Relationship Engine):
├── Breadth-First Search (BFS)
├── Depth-First Search (DFS)
├── Dijkstra's shortest path
├── A* pathfinding (heuristic optimization)
├── Union-Find (disjoint sets)
└── Topological sorting

RECURSIVE ALGORITHMS:
├── Recursive CTEs (SQL)
├── Memoization (dynamic programming)
├── Backtracking algorithms
└── Divide and conquer
```

**E. API Design:**
```
REST API:
├── Resource modeling
├── HTTP methods (GET, POST, PUT, DELETE, PATCH)
├── Status codes (2xx, 4xx, 5xx)
├── Pagination (cursor-based, offset-based)
├── Filtering, Sorting
├── Rate limiting strategies
└── Idempotency keys

GRAPHQL (Optional tapi recommended):
├── Schema definition
├── Resolvers
├── Query/Mutation/Subscription
├── DataLoader (N+1 problem)
└── Federation (microservices)
```

**F. Security:**
- JWT implementation (access/refresh tokens)
- OAuth 2.0 / OpenID Connect
- Role-Based Access Control (RBAC)
- SQL Injection prevention
- XSS/CSRF protection
- Input validation (Zod, Joi, class-validator)
- Encryption at rest and in transit
- Hashing (bcrypt, Argon2)

**G. Testing:**
- Unit testing (Jest, Mocha, Go testing)
- Integration testing (Supertest, httpexpect)
- E2E testing (optional)
- Test coverage (target: 80%+)
- Mocking (Sinon, Mockery)

---

#### **Nice to Have:**
- Batak cultural knowledge (big plus!)
- Experience dengan genealogy apps
- Knowledge of Indonesian market
- Golang (jika menggunakan Node.js)
- Event-driven architecture (Kafka, RabbitMQ)

---

### 2.2 Backend Engineer (Adat Engine) - SPECIALIZED

#### **Competencies tambahan selain 2.1:**

**A. Rule Engine Development:**
```
BUSINESS RULES ENGINE:
├── Rule definition DSL (Domain Specific Language)
├── Rule parser & evaluator
├── Condition-action patterns
├── Rule chaining & priorities
├── Dynamic rule loading (hot reload)
└── Rule versioning
```

**B. Complex Calculation Engine:**
```
PARTUTURAN CALCULATION:
├── Recursive relationship resolution
├── Context-aware calculations (acara vs sehari-hari)
├── Multi-path resolution
├── Ambiguity resolution
└── Caching calculation results

DALIHAN NA TOLU ENGINE:
├── Dynamic trio calculation
├── Event-based relationship switching
├── Priority/weighting systems
└── Conflict detection
```

**C. Mathematical Competencies:**
- Set theory (union, intersection, difference)
- Graph theory (adjacency matrices, incidence lists)
- Boolean logic (AND, OR, NOT, XOR)
- Probability (bayesian inference untuk AI)

---

## 3. FRONTEND ENGINEER COMPETENCIES

### 3.1 Core Frontend Engineer

#### **Wajib Kuasai (Must Have):**

**A. JavaScript/TypeScript:**
```
TYPESCRIPT (Strict Mode):
├── Type system (primitive, object, union, intersection)
├── Generics (T, K extends keyof T)
├── Type guards, Type assertions
├── Utility types (Partial, Required, Pick, Omit)
├── Declaration files (.d.ts)
├── Decorators (experimental)
└── Module resolution

JAVASCRIPT (ES2022+):
├── Async/await, Promises
├── ES Modules (import/export)
├── Array/Object methods (map, filter, reduce)
├── Destructuring, Spread operator
├── Optional chaining (?.), Nullish coalescing (??)
└── Proxies, Reflect API
```

**B. React.js (18+):**
```
CORE REACT:
├── JSX, Components (functional/class)
├── Props, State management
├── Hooks (useState, useEffect, useContext, useReducer)
├── Custom hooks
├── React lifecycle
├── Performance optimization (React.memo, useMemo, useCallback)
├── Error boundaries
├── Suspense, Lazy loading
└── Concurrent features (startTransition, useDeferredValue)

STATE MANAGEMENT:
├── React Query / TanStack Query (CRITICAL - server state)
├── Zustand / Redux Toolkit (client state)
├── Context API (dependency injection)
└── State machines (XState - untuk complex workflows)
```

**C. Styling & UI:**
```
CSS FRAMEWORKS:
├── TailwindCSS (wajib)
│   ├── Utility-first approach
   ├── Custom configuration (tailwind.config.js)
   ├── JIT compiler
   ├── Responsive design (mobile-first)
   └── Dark mode
│
├── shadcn/ui (component library)
│   ├── Radix UI primitives
   ├── Accessible components
   └── Customizable themes
│
CSS ADVANCED:
├── Flexbox, CSS Grid
├── CSS variables (custom properties)
├── Animations, Transitions
├── Container queries
└── CSS modules / CSS-in-JS (optional)
```

**D. Data Visualization (CRITICAL untuk Family Tree):**
```
TREE VISUALIZATION:
├── D3.js (wajib untuk custom visualizations)
│   ├── SVG manipulation
   ├── Scales (linear, ordinal, time)
   ├── Layouts (tree, cluster, force)
   ├── Transitions, Interactions
   └── Zoom, Pan
│
├── Cytoscape.js (graph library)
│   ├── Node-edge styling
   ├── Layout algorithms (dagre, cola, springy)
   ├── Event handling (click, hover, drag)
   └── Performance (webgl rendering)
│
├── React Flow / React DnD (drag & drop)
└── HTML5 Canvas (untuk large datasets)

ALTERNATIVE:
├── vis.js / vis-network
├── gojs (commercial, powerful)
└── AntV G6 (Chinese, good documentation)
```

**E. Performance:**
- Code splitting, Lazy loading
- Bundle optimization (Tree shaking)
- Image optimization (WebP, lazy loading)
- Caching strategies (service workers)
- Core Web Vitals (LCP, FID, CLS)
- Lighthouse optimization

**F. Testing:**
- Jest / Vitest (unit testing)
- React Testing Library (component testing)
- Playwright / Cypress (E2E testing)
- Visual regression testing (Storybook, Chromatic)

**G. Build Tools:**
- Vite (recommended, fast)
- Webpack (if needed for complex configs)
- ESLint, Prettier (code quality)
- Husky (git hooks)

---

#### **Nice to Have:**
- Next.js 14 (SSR, SSG, App Router)
- WebAssembly (untuk heavy calculations di browser)
- Web Workers (untuk background processing)
- PWA development (offline capabilities)
- React Native (crossover ke mobile)

---

### 3.2 Frontend Engineer (Adat UI) - SPECIALIZED

#### **Competencies tambahan:**

**A. Complex Workflow Design:**
```
STEPPER/WIZARD PATTERNS:
├── Multi-step forms (ceremony workflows)
├── State persistence between steps
├── Validation per step
├── Progress indicators
└── Back/forward navigation

DYNAMIC FORMS:
├── Form arrays (tambah multiple participants)
├── Conditional fields
├── Form dependencies
├── Real-time validation
└── Auto-save drafts
```

**B. Cultural UX Considerations:**
- Right-to-left (RTL) layouts (untuk Arab influence di Mandailing)
- Accessibility (WCAG 2.1 AA compliance)
- Offline-first design (untuk area dengan koneksi buruk)
- Low-bandwidth optimizations

---

## 4. MOBILE ENGINEER COMPETENCIES

### 4.1 React Native Engineer

#### **Wajib Kuasai:**

**A. React Native Core:**
```
REACT NATIVE:
├── Components (View, Text, Image, ScrollView)
├── Navigation (React Navigation v6)
├── Hooks (useState, useEffect, useCallback)
├── Platform-specific code (iOS vs Android)
├── AsyncStorage / MMKV (local storage)
├── Push notifications (FCM, APNS)
├── Deep linking
└── App signing, Publishing (App Store, Play Store)
```

**B. Offline-First Architecture (CRITICAL):**
```
OFFLINE CAPABILITIES:
├── SQLite / WatermelonDB (local database)
├── Sync strategies (push, pull, bidirectional)
├── Conflict resolution
├── Queue system untuk pending actions
├── Background sync
└── Network state monitoring
```

**C. Native Modules (untuk fitur khusus):**
- Camera access (upload foto)
- GPS/Geolocation (makam locations)
- Biometric authentication
- File system access
- Contacts integration (optional)

**D. Performance:**
- Hermes engine
- Bundle size optimization
- Image optimization
- List virtualization (FlatList optimization)
- Memory management

---

### 4.2 Flutter Engineer (Alternative)

#### **Wajib Kuasai:**
- Dart programming
- Flutter widgets (Material, Cupertino)
- State management (Bloc, Riverpod, GetX)
- Navigation 2.0
- Platform channels (native integration)

---

## 5. DATA/AI ENGINEER COMPETENCIES

### 5.1 ML Engineer

#### **Wajib Kuasai:**

**A. Python Programming:**
```
PYTHON:
├── Python 3.10+
├── Type hints (mypy)
├── Asyncio (async/await)
├── Data classes, Pydantic
├── FastAPI ( untuk ML serving)
└── Testing (pytest)
```

**B. Machine Learning:**
```
ML FRAMEWORKS:
├── TensorFlow 2.x OR PyTorch
│   ├── Model building (Sequential, Functional API)
   ├── Training loops
   ├── Transfer learning
   └── Model serving (TF Serving, TorchServe)
│
├── scikit-learn
│   ├── Classification, Regression
   ├── Clustering
   ├── Feature engineering
   └── Model evaluation
```

**C. NLP (Natural Language Processing):**
```
NLP STACK:
├── spaCy (production-grade NLP)
│   ├── Tokenization, NER
   ├── Dependency parsing
   └── Custom components
│
├── HuggingFace Transformers
│   ├── BERT, GPT models
   ├── Fine-tuning
   └── Pipeline usage
│
├── Regex patterns (untuk nama Batak)
└── Fuzzy matching (Levenshtein distance)
```

**D. Graph Algorithms untuk AI:**
```
GRAPH ML:
├── Graph Neural Networks (GNN)
├── Node2Vec, GraphSAGE
├── Link prediction
├── Community detection
└── NetworkX (graph analysis)
```

**E. Data Processing:**
```
DATA STACK:
├── Pandas (DataFrames, manipulation)
├── NumPy (arrays, mathematical operations)
├── Dask (parallel processing)
├── Apache Arrow (columnar data)
└── SQLAlchemy (database interaction)
```

---

### 5.2 Data Engineer

#### **Wajib Kuasai:**

**A. Data Pipelines:**
```
ORCHESTRATION:
├── Apache Airflow
│   ├── DAGs (Directed Acyclic Graphs)
   ├── Operators (Python, Bash, SQL)
   ├── Scheduling (cron, intervals)
   └── Monitoring (SLAs, retries)
│
├── dbt (data transformation)
│   ├── Models
   ├── Tests
   └── Documentation
```

**B. Data Warehousing:**
- BigQuery (Google) OR Redshift (AWS)
- Data modeling (star schema, snowflake)
- ETL/ELT patterns
- Data quality checks (Great Expectations)

**C. Streaming (Optional):**
- Apache Kafka (event streaming)
- Apache Spark (big data processing)

---

## 6. DEVOPS ENGINEER COMPETENCIES

### 6.1 Core DevOps

#### **Wajib Kuasai:**

**A. Containerization:**
```
DOCKER:
├── Dockerfile optimization
├── Multi-stage builds
├── Docker Compose
├── Image security scanning
└── Container registries (Docker Hub, ECR, GCR)
```

**B. Kubernetes:**
```
KUBERNETES:
├── Pods, Deployments, Services
├── ConfigMaps, Secrets
├── Ingress controllers
├── Helm charts
├── RBAC (Role-Based Access Control)
├── Monitoring (Prometheus, Grafana)
├── Logging (ELK stack, Loki)
└── Auto-scaling (HPA, VPA)
```

**C. Cloud Platforms (Pilih satu, know others):**
```
AWS:
├── EC2, ECS, EKS (compute)
├── RDS, Aurora (database)
├── S3 (object storage)
├── CloudFront (CDN)
├── Route53 (DNS)
├── IAM (security)
├── CloudWatch (monitoring)
└── Lambda (serverless)

GCP:
├── Compute Engine, GKE
├── Cloud SQL, Cloud Spanner
├── Cloud Storage
├── Cloud CDN
├── Cloud DNS
└── Stackdriver

DigitalOcean:
├── Droplets
├── Kubernetes (managed)
├── Spaces (S3-compatible)
├── Databases (managed)
└── App Platform
```

**D. Infrastructure as Code:**
```
IAC TOOLS:
├── Terraform (wajib)
│   ├── HCL syntax
   ├── State management
   ├── Modules
   └── Workspaces
│
├── Ansible (configuration management)
└── Pulumi (alternative to Terraform)
```

**E. CI/CD:**
```
CI/CD PIPELINES:
├── GitHub Actions (wajib)
│   ├── Workflows (YAML)
   ├── Actions (reusable)
   ├── Secrets management
   └── Matrix builds
│
├── GitLab CI / Jenkins (alternative)
└── ArgoCD (GitOps untuk Kubernetes)
```

**F. Security & Compliance:**
- SSL/TLS certificates (Let's Encrypt, cert-manager)
- Secrets management (HashiCorp Vault, AWS Secrets Manager)
- Security scanning (Trivy, Snyk)
- Backup & disaster recovery
- GDPR / PDP Law compliance

---

## 7. QA ENGINEER COMPETENCIES

### 7.1 Core QA

#### **Wajib Kuasai:**

**A. Testing Types:**
```
TESTING PYRAMID:
├── Unit Tests
│   ├── Jest (JavaScript)
   ├── Pytest (Python)
   └── Go testing
│
├── Integration Tests
│   ├── API testing (Postman, REST Assured)
   └── Database testing
│
├── E2E Tests
│   ├── Playwright (recommended)
   ├── Cypress
   └── Selenium
│
├── Performance Tests
│   ├── k6 (load testing)
   ├── Artillery
   └── JMeter
│
└── Security Tests
    ├── OWASP ZAP
    └── Burp Suite
```

**B. Test Automation:**
- Page Object Model (POM) pattern
- Test data management
- Test environment setup
- Parallel test execution
- Visual regression testing

**C. Cultural Testing (UNIQUE untuk Tarombo):**
```
ADAT VALIDATION TESTING:
├── Partuturan calculation verification
├── Marga inheritance rules testing
├── Dalihan Na Tolu accuracy
├── Ceremony workflow validation
└── Tetua approval workflow testing
```

---

## 8. REQUIRED SOFT SKILLS

### 8.1 Universal Soft Skills (Semua Roles)

| Skill | Level | Deskripsi |
|-------|-------|-----------|
| **Problem Solving** | L3 | Mampu breakdown complex problems |
| **Communication** | L3 | Clear technical writing, documentation |
| **Teamwork** | L3 | Collaborative, code reviews |
| **Learning Agility** | L3 | Cepat adaptasi teknologi baru |
| **Cultural Sensitivity** | L2 | Respect terhadap adat Batak |

### 8.2 Role-Specific Soft Skills

| Role | Special Soft Skills |
|------|---------------------|
| **Backend** | System thinking, algorithm design |
| **Frontend** | UX empathy, visual thinking |
| **Mobile** | Resource constraint thinking |
| **Data/AI** | Statistical thinking, experimentation |
| **DevOps** | Reliability mindset, automation obsession |
| **QA** | Attention to detail, edge case hunter |

---

## LAMPIRAN: LEARNING PATH

### A. Backend Engineer Learning Path (6 bulan)

```
BULAN 1-2: Foundations
├── JavaScript/TypeScript mastery
├── PostgreSQL deep dive
├── REST API design
└── Basic algorithms

BULAN 3-4: Specialization
├── Graph databases (Neo4j)
├── Tree/graph algorithms
├── Redis caching
└── Security best practices

BULAN 5-6: Tarombo-Specific
├── Genealogy data modeling
├── Partuturan algorithms
├── Relationship engine design
└── Cultural domain knowledge
```

### B. Frontend Engineer Learning Path (6 bulan)

```
BULAN 1-2: React Mastery
├── React hooks, patterns
├── TypeScript strict mode
├── TailwindCSS, shadcn/ui
└── State management (React Query)

BULAN 3-4: Visualization
├── D3.js fundamentals
├── Tree layouts (hierarchy, cluster)
├── Interactive features (zoom, pan, drag)
└── Performance optimization

BULAN 5-6: Integration
├── Family tree component architecture
├── Real-time collaboration
├── Offline capabilities
└── Cultural UX patterns
```

### C. Certification Recommendations

| Role | Recommended Certifications |
|------|---------------------------|
| Backend | AWS Certified Developer, PostgreSQL certification |
| Frontend | React certification (Meta), TypeScript expertise |
| Mobile | Google Associate Android Developer |
| Data/AI | TensorFlow Developer Certificate |
| DevOps | CKA (Certified Kubernetes Administrator), AWS Solutions Architect |
| QA | ISTQB Certified Tester |

---

## RINGKASAN KRITIKAL SUCCESS FACTORS

```
═══════════════════════════════════════════════════════════════

UNTUK MENYELESAIKAN TAROMBO DIGITAL, PROGRAMMER HARUS:

1. ALGORITHMS (Semua roles)
   └── Tree & Graph algorithms adalah CORE competency

2. DOMAIN KNOWLEDGE (Backend + Frontend Adat)
   └── Batak kinship systems, Dalihan Na Tolu, Partuturan

3. DATA MODELING (Backend)
   └── Graph databases, recursive relationships, complex hierarchies

4. VISUALIZATION (Frontend)
   └── Tree layouts, interactive diagrams, large dataset rendering

5. OFFLINE-FIRST (Mobile)
   └── Sync strategies, conflict resolution, background processing

6. CULTURAL SENSITIVITY (All roles)
   └── Respect adat, validate dengan Tetua, preserve authenticity

═══════════════════════════════════════════════════════════════
```

---

## LAMPIRAN B: ALTERNATIVE STACK (PHP + jQuery + Bootstrap + MySQL)

> **PENTING:** Dokumen ini berfokus pada Modern Stack (React/Node.js/PostgreSQL). Namun, jika tim memiliki keahlian **PHP + jQuery + Bootstrap + MySQL**, berikut analisis dan rekomendasi **Hybrid Architecture**.

### B.1 Bisa vs Tidak Bisa dengan PHP/jQuery

#### ✅ **BISA Dilakukan dengan PHP/jQuery:**

| Fitur | Implementasi | Tingkat Kesulitan |
|-------|--------------|-------------------|
| **CRUD Person** | PHP form + MySQL table | Mudah |
| **Basic family tree** | jQuery + CSS tree | Sedang (terbatas) |
| **User authentication** | PHP session/JWT | Mudah |
| **Simple partuturan** | PHP function + MySQL query | Sedang |
| **Admin dashboard** | Bootstrap + PHP | Mudah |

#### ❌ **SULIT / TIDAK BISA dengan PHP/jQuery:**

| Fitur | Masalah | Solusi Modern |
|-------|---------|---------------|
| **Interactive D3 Tree** | jQuery tidak designed untuk complex SVG | React + D3.js |
| **Graph relationships** | MySQL joins lambat untuk deep recursion | Neo4j Graph DB |
| **Real-time updates** | PHP request-response, tidak ada websocket | Socket.io + Node.js |
| **Mobile app** | PHP = server-side, tidak bisa jadi mobile app | React Native |
| **Offline-first** | PHP butuh internet, tidak bisa offline | Service Workers |
| **AI/NLP queries** | PHP tidak optimal untuk ML/AI | Python + TensorFlow |

### B.2 Hybrid Architecture (REKOMENDASI)

**Kompromi terbaik:** PHP untuk **Backend API**, React + D3.js untuk **Frontend**.

```
HYBRID ARCHITECTURE
═══════════════════════════════════════════════════════════════

         FRONTEND (React + D3.js)
         ┌─────────────────────────┐
         │  React App (Web)        │
         │  D3.js Tree Viz           │
         │  Mobile App (optional)    │
         └───────────┬─────────────┘
                     │
              REST API / JSON
                     │
         BACKEND (PHP 8.x)
         ┌─────────────────────────┐
         │  PHP REST API             │
         │  - /api/persons           │
         │  - /api/partuturan        │
         │  - /auth/*                │
         └───────────┬─────────────┘
                     │
         DATABASE (MySQL 8.x)
         ┌─────────────────────────┐
         │  persons table            │
         │  marga table              │
         │  relationships            │
         └─────────────────────────┘
```

#### **Contoh: PHP API Endpoint untuk Partuturan**

```php
<?php
// api/partuturan.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // CORS untuk React

$from_id = $_GET['from'] ?? null;
$to_id = $_GET['to'] ?? null;

if (!$from_id || !$to_id) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing parameters']);
    exit;
}

// Query ke database MySQL
$relationship = calculatePartuturan($from_id, $to_id);

// Return JSON untuk React/D3.js
$response = [
    'from_person' => getPerson($from_id),
    'to_person' => getPerson($to_id),
    'relationship' => $relationship,
    'path' => getPath($from_id, $to_id),
    'generation_gap' => calculateGenerationGap($from_id, $to_id)
];

echo json_encode($response);
?>
```

#### **Contoh: React consume PHP API**

```javascript
// React component
import { useEffect, useState } from 'react';
import * as d3 from 'd3';

function FamilyTree({ personId }) {
  const [treeData, setTreeData] = useState(null);
  
  useEffect(() => {
    // Call PHP API
    fetch(`/api/persons/${personId}/tree`)
      .then(res => res.json())
      .then(data => {
        setTreeData(data);
        renderD3Tree(data); // D3.js untuk visualization
      });
  }, [personId]);
  
  return <div id="tree-container" />;
}
```

### B.3 Keuntungan Hybrid Architecture

| Aspek | Benefit |
|-------|---------|
| **Leverage existing skill** | Tim tetap pakai PHP/MySQL yang dikuasai |
| **Modern visualization** | React + D3.js untuk tree yang powerful |
| **Future-proof** | Bisa gradual migration ke Node.js |
| **Mobile-ready** | React bisa di-convert ke React Native |
| **Hire easier** | React developer lebih mudah ditemukan |

### B.4 Team Composition untuk Hybrid

| Role | Skill | Status |
|------|-------|--------|
| **Backend Lead** | PHP 8.x + MySQL | Anda |
| **Backend Dev** | PHP + REST API | Hire 1-2 |
| **Frontend Lead** | React + D3.js | **HARUS Hire** |
| **Frontend Dev** | React + TypeScript | Hire 1-2 |
| **DevOps** | Server management | Part-time |

### B.5 Risiko Pure PHP/jQuery (Tanpa Hybrid)

```
TECHNICAL DEBT WARNING:
─────────────────────────────────────────────────────────────
• JQuery spaghetti code untuk complex tree
• MySQL recursive queries lambat dengan deep trees
• Tidak ada ecosystem untuk modern visualization
• Maintenance nightmare di masa depan
• Sulit hire developer yang mau kerja dengan jQuery (legacy)
• Tidak bisa buat mobile app
```

### B.6 Kesimpulan

> **"Gunakan PHP untuk Backend API, tapi Frontend HARUS pakai React + D3.js untuk fitur competitive advantage: interactive family tree, complex partuturan visualization, dan future mobile app capabilities."**

© 2026 Tarombo Digital Project
