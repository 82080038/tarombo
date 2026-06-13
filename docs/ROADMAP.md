# ROADMAP
## Peta Jalan Pengembangan Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Executive Summary](#1-executive-summary)
2. [Phase 1: Foundation (Q3 2026)](#2-phase-1-foundation-q3-2026)
3. [Phase 2: Core Features (Q4 2026)](#3-phase-2-core-features-q4-2026)
4. [Phase 3: Enhancement (Q1 2027)](#4-phase-3-enhancement-q1-2027)
5. [Phase 4: Scale (Q2-Q3 2027)](#5-phase-4-scale-q2-q3-2027)
6. [Phase 5: Ecosystem (Q4 2027+)](#6-phase-5-ecosystem-q4-2027)
7. [Milestones & KPIs](#7-milestones--kpis)

---

## 1. EXECUTIVE SUMMARY

### 1.1 Timeline Overview

```
2026 Q3        2026 Q4        2027 Q1        2027 Q2        2027 Q4
  │              │              │              │              │
  ▼              ▼              ▼              ▼              ▼
┌─────┐        ┌─────┐        ┌─────┐        ┌─────┐        ┌─────┐
│FOUND│───────▶│CORE │───────▶│ENHNC│───────▶│SCALE│───────▶│ECOSY│
│ATION│        │FEATR│        │EMENT│        │     │        │STEM │
└─────┘        └─────┘        └─────┘        └─────┘        └─────┘
  │              │              │              │              │
 MVP Launch    Public Beta    v1.0 Release   v2.0 Release   v3.0 & Beyond
```

### 1.2 Development Approach

| Aspect | Strategy |
|--------|----------|
| **Methodology** | Agile Scrum dengan 2-week sprints |
| **Priority** | Culture-first, tech follows adat needs |
| **User Involvement** | Tetua adat sebagai advisors dari awal |
| **Quality** | Unit test >80%, security audit tiap release |
| **Deployment** | CI/CD dengan feature flags |

---

## 2. PHASE 1: FOUNDATION (Q3 2026)

### 2.1 Objectives
- Build technical foundation
- Launch MVP untuk internal testing
- Validasi konsep dengan komunitas kecil

### 2.2 Key Deliverables

```
PHASE 1: FOUNDATION (Jul - Sep 2026)
═══════════════════════════════════════════════════════════════════════════

Sprint 1-2: Infrastructure & Auth
├── Setup development environment
├── CI/CD pipeline
├── Database schema implementation
├── Authentication system (JWT + 2FA)
└── Basic user management

Sprint 3-4: Core Person & Marga
├── Person CRUD API
├── Marga database (100+ marga Toba)
├── Family tree visualization (basic)
└── Basic search functionality

Sprint 5-6: Family Relationships
├── Parent-child relationships
├── Marriage recording (basic)
├── Simple partuturan calculation
└── Data validation workflow

MILESTONE: Internal Alpha Launch
├── Internal team testing
├── 100 test users (friends & family)
└── Bug fixes dan refinement
```

### 2.3 Success Criteria

| Criteria | Target |
|----------|--------|
| **System Stability** | 99.5% uptime |
| **Test Coverage** | >70% code coverage |
| **User Feedback** | NPS >20 dari 100 alpha users |
| **Performance** | API response <500ms |
| **Security** | No critical vulnerabilities |

---

## 3. PHASE 2: CORE FEATURES (Q4 2026)

### 3.1 Objectives
- Launch public beta
- Implement fitur adat lengkap
- Build initial user base

### 3.2 Key Deliverables

```
PHASE 2: CORE FEATURES (Oct - Dec 2026)
═══════════════════════════════════════════════════════════════════════════

Sprint 7-8: Advanced Partuturan & Search
├── Advanced partuturan algorithm
├── Pariban detection
├── Full-text search dengan Elasticsearch
├── Fuzzy matching untuk nama
└── Geolocation features

Sprint 9-10: Marriage Adat System
├── 7 tahapan pernikahan workflow
├── Ulos distribution tracking
├── Ceremony planner (basic)
├── Raja Parhata tools
└── Tata tertib generator

Sprint 11-12: UI/UX Polish & Mobile
├── Responsive design completion
├── Mobile app (React Native) - MVP
├── Accessibility improvements
├── Performance optimization
└── Security hardening

MILESTONE: Public Beta Launch
├── Open registration (limited)
├── 1.000 beta users target
├── Premium tier preview
└── Community feedback integration
```

### 3.3 Feature Completeness

| Feature | Phase 1 | Phase 2 |
|---------|---------|---------|
| User Registration | ✓ Basic | ✓ Full |
| Person CRUD | ✓ | ✓ |
| Family Tree | ✓ 3 gen | ✓ Unlimited |
| Partuturan | ✓ Basic | ✓ Full |
| Marriage Recording | ✓ Basic | ✓ 7 Stages |
| Search | ✓ Basic | ✓ Advanced |
| Mobile App | - | ✓ MVP |
| Ceremony Tools | - | ✓ Basic |
| Admin Dashboard | - | ✓ |

### 3.4 Success Criteria

| Criteria | Target |
|----------|--------|
| **Registered Users** | 1.000 users |
| **Active Users (MAU)** | 600 users |
| **Data Entries** | 5.000 person records |
| **Marriages Recorded** | 100 marriages |
| **User Retention** | 60% (Day 7) |
| **App Store Rating** | >4.0 (jika mobile app launch) |

---

## 4. PHASE 3: ENHANCEMENT (Q1 2027)

### 4.1 Objectives
- v1.0 stable release
- Monetization activation
- Multi-sub-suku support

### 4.2 Key Deliverables

```
PHASE 3: ENHANCEMENT (Jan - Mar 2027)
═══════════════════════════════════════════════════════════════════════════

Sprint 13-14: Multi-Sub-Suku Support
├── Karo marga system (merga)
├── Simalungun system (sisadapur)
├── Mandailing adaptations
├── Sub-suku specific workflows
└── Cross-sub-suku marriage support

Sprint 15-16: Premium Features & Monetization
├── Subscription system implementation
├── Payment gateway integration
├── Premium feature gating
├── Family account system
└── Tetua verification workflow

Sprint 17-18: Advanced Ceremonies & Death Records
├── Death ceremony tracking (saur matua)
├── Waris calculation system
├── Advanced ceremony planner
├── Document generation (PDF exports)
└── Photo/media management

MILESTONE: v1.0 General Availability
├── Full production release
├── All core features stable
├── Monetization active
└── 5.000 users target
```

### 4.3 New Features

| Feature | Description |
|---------|-------------|
| **Multi-Batak Support** | Toba, Karo, Simalungun, Mandailing, Angkola, Pakpak |
| **Waris Calculator** | Auto-calculate inheritance based on adat |
| **Document Export** | GEDCOM, PDF reports, family tree posters |
| **Photo Gallery** | Media management untuk keluarga |
| **Event Calendar** | Acara adat reminder dan tracking |
| **Advanced Analytics** | Admin dashboard dengan insights |

### 4.4 Success Criteria

| Criteria | Target |
|----------|--------|
| **Total Users** | 5.000 users |
| **Paying Users** | 500 users (10% conversion) |
| **Monthly Revenue** | Rp 50jt |
| **Data Quality** | 80% validated records |
| **Uptime** | 99.9% |
| **Support Tickets** | <48h response time |

---

## 5. PHASE 4: SCALE (Q2-Q3 2027)

### 5.1 Objectives
- Scale infrastructure untuk 100K+ users
- B2B offerings launch
- AI/ML features integration

### 5.2 Key Deliverables

```
PHASE 4: SCALE (Apr - Sep 2027)
═══════════════════════════════════════════════════════════════════════════

Sprint 19-22: Scalability & Performance
├── Microservices architecture
├── Database sharding (jika diperlukan)
├── CDN global deployment
├── Advanced caching strategies
└── Load testing & optimization

Sprint 23-26: AI/ML Features
├── Smart name matching (fuzzy logic)
├── Automatic relationship suggestions
├── Duplicate detection AI
├── Genealogy gap filling suggestions
└── Predictive adat compliance checking

Sprint 27-30: B2B Platform
├── API platform launch
├── Developer documentation
├── White label solutions
├── Enterprise dashboard
└── Research partnership tools

MILESTONE: v2.0 Scale Release
├── 40.000 users
├── B2B revenue stream active
├── International expansion (diaspora)
└── Mobile app v2.0
```

### 5.3 Technical Architecture Evolution

```
Phase 1-2: Monolith
┌─────────────────────────────────────┐
│           Single App Server         │
│  (API + Frontend + Background Jobs) │
└─────────────────────────────────────┘

Phase 3-4: Modular Monolith
┌─────────────────────────────────────┐
│         API Gateway                 │
└─────────┬───────────────────────────┘
          │
    ┌─────┴─────┬──────────┬─────────┐
    ▼           ▼          ▼         ▼
┌───────┐  ┌───────┐ ┌────────┐ ┌────────┐
│ Auth  │  │ Core  │ │ Adat   │ │ Search │
│Module │  │Module │ │ Module │ │ Module │
└───────┘  └───────┘ └────────┘ └────────┘

Phase 5+: Microservices
┌─────────────────────────────────────┐
│      API Gateway + Load Balancer    │
└─────────┬───────────────────────────┘
          │
    ┌─────┼─────┬──────────┬──────────┬────────┐
    ▼     ▼     ▼          ▼          ▼        ▼
┌────┐┌────┐┌────┐   ┌────────┐  ┌────────┐ ┌────────┐
│Auth││Core││Adat│   │Search  │  │ML      │ │B2B     │
│Svc ││Svc ││Svc │   │Service │  │Service │ │Platform│
└────┘└────┘└────┘   └────────┘  └────────┘ └────────┘
```

### 5.4 Success Criteria

| Criteria | Target |
|----------|--------|
| **Total Users** | 40.000 users |
| **MAU** | 25.000 users |
| **API Customers** | 10 B2B clients |
| **Monthly Revenue** | Rp 500jt |
| **System Capacity** | 100.000 concurrent users |
| **International Users** | 10% dari total |

---

## 6. PHASE 5: ECOSYSTEM (Q4 2027+)

### 6.1 Objectives
- Platform ecosystem development
- Advanced AI features
- Cultural preservation initiatives

### 6.2 Key Deliverables

```
PHASE 5: ECOSYSTEM (Q4 2027 dan seterusnya)
═══════════════════════════════════════════════════════════════════════════

Ongoing: Community & Culture
├── Tarombo educational content
├── Collaboration dengan sekolah/universitas
├── Cultural event sponsorship
├── Museum partnerships
└── Digital heritage projects

Ongoing: AI Innovation
├── Natural language processing untuk bahasa Batak
├── Voice recognition untuk doa/umpasa
├── Automated genealogy research assistant
├── Smart matching untuk pariban
└── Predictive cultural insights

Ongoing: Platform Expansion
├── Marketplace untuk produk budaya Batak
├── Travel integration (wisata budaya)
├── Integration dengan government services
├── International diaspora network
└── Research grants platform

MILESTONE: v3.0 Ecosystem
├── 150.000+ users
├── Platform revenue >Rp 2M/bulan
├── Cultural impact measurable
└── Sustainable business model
```

### 6.3 Future Feature Ideas

| Feature | Description | Priority |
|---------|-------------|----------|
| **AR/VR Ancestry** | Virtual visits to ancestral villages | Medium |
| **Blockchain Records** | Immutable genealogy records | Low |
| **DNA Integration** | Genetic genealogy support | Low |
| **Voice Interface** | Speech-to-text untuk bahasa Batak | Medium |
| **Education Platform** | Online courses tentang adat | High |
| **Social Features** | Community forums, stories | Medium |

---

## 7. MILESTONES & KPIs

### 7.1 Key Milestones Summary

| Milestone | Date | Key Deliverable |
|-----------|------|-----------------|
| **MVP Complete** | Aug 2026 | Internal alpha dengan core features |
| **Public Beta** | Dec 2026 | 1.000 public beta users |
| **v1.0 GA** | Mar 2027 | General availability, monetization on |
| **B2B Launch** | Jun 2027 | API platform dan white label |
| **v2.0 Scale** | Sep 2027 | 40.000 users, enterprise ready |
| **v3.0 Ecosystem** | Dec 2027 | Full platform ecosystem |

### 7.2 KPI Dashboard

```
                    Year 1     Year 2     Year 3     Year 4     Year 5
                    ─────      ─────      ─────      ─────      ─────
Users (Total)       5K         15K        40K        80K        150K
MAU                 3K         10K        25K        50K        100K
Premium Users       250        1.5K       4K         10K        20K
Revenue (jt)        500        2.000      6.000      12.000     25.000
Marga Covered       100        125        150        175        200+
Ceremonies          100        500        2K         5K         12K
B2B Clients         0          2          10         25         50

Data Quality        60%        75%        85%        90%        95%
Uptime              99.5%      99.8%      99.9%      99.95%     99.99%
NPS Score           30         40         50         60         70+
```

### 7.3 Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| **Low Adoption** | Medium | High | Community outreach, free tier emphasis |
| **Technical Debt** | Medium | High | Code reviews, refactoring sprints |
| **Cultural Resistance** | Low | High | Tetua involvement, education |
| **Competition** | Low | Medium | Differentiation via adat authenticity |
| **Funding** | Medium | High | Multiple revenue streams, grants |
| **Data Privacy Concerns** | Medium | High | Transparency, encryption, opt-in |

### 7.4 Decision Gates

| Gate | Criteria | Decision |
|------|----------|----------|
| **Phase 1 → 2** | Alpha NPS >20, <100 critical bugs | Proceed to public beta |
| **Phase 2 → 3** | Beta retention >60%, <50 high bugs | Proceed to v1.0 |
| **Phase 3 → 4** | >5K users, >Rp 50jt revenue | Proceed to scale |
| **Phase 4 → 5** | >40K users, >10 B2B clients | Proceed to ecosystem |

---

## LAMPIRAN: Sprint Calendar (Phase 1-2)

```
2026
Jul │ Aug │ Sep │ Oct │ Nov │ Dec │
────┼─────┼─────┼─────┼─────┼─────┤
S1  │ S3  │ S5  │ S7  │ S9  │ S11 │
S2  │ S4  │ S6  │ S8  │ S10 │ S12 │
────┼─────┼─────┼─────┼─────┼─────┤
    │ MVP │     │     │Beta │     │
    │     │Alpha│     │     │Launch│
```

### Sprint Template

| Week | Activities |
|------|------------|
| **Week 1** | Planning, design, story breakdown |
| **Week 2** | Development, daily standups |
| **Week 3** | Development, testing |
| **Week 4** | QA, bug fixes, demo, retrospective |

---

**Referensi:** SEMUA DOKUMEN LAINNYA

© 2026 Tarombo Digital Project

---

## DOKUMEN REFERENSI LENGKAP

| Dokumen | Deskripsi | Status |
|---------|-----------|--------|
| TAROMBO_DIGITAL_BATAK.md | ✅ Overview proyek | Created |
| ANALISIS_BUDAYA_BATAK.md | ✅ Analisis budaya komprehensif | **Completed** |
| KAMUS_ISTILAH_ADAT_BATAK.md | ✅ Kamus terminologi | **Completed** |
| BUSINESS_RULE.md | ✅ Aturan bisnis | **Completed** |
| USE_CASE.md | ✅ Use case lengkap | **Completed** |
| WORKFLOW_ADAT.md | ✅ Workflow prosesi adat | **Completed** |
| SYSTEM_REQUIREMENT.md | ✅ Kebutuhan sistem | **Completed** |
| ERD.md | ✅ Entity Relationship Diagram | **Completed** |
| DATABASE_DESIGN.md | ✅ Desain database | **Completed** |
| SQL_SCHEMA.md | ✅ Skema SQL | **Completed** |
| API_SPECIFICATION.md | ✅ Spesifikasi API | **Completed** |
| SECURITY_ARCHITECTURE.md | ✅ Arsitektur keamanan | **Completed** |
| UI_UX_GUIDELINE.md | ✅ Panduan UI/UX | **Completed** |
| MONETIZATION_MODEL.md | ✅ Model bisnis | **Completed** |
| ROADMAP.md | ✅ Peta jalan | **Completed** |

**TOTAL: 15 Dokumen**
**SEMUA TAHAP SELESAI ✅**
