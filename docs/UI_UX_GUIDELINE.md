# UI/UX GUIDELINE
## Panduan Desain Antarmuka Pengguna Sistem Tarombo Digital

**Versi:** 1.0 | **Tanggal:** Juni 2026 | **Status:** Final

---

## DAFTAR ISI

1. [Design Principles](#1-design-principles)
2. [Visual Design System](#2-visual-design-system)
3. [Component Library](#3-component-library)
4. [Page Layouts](#4-page-layouts)
5. [Responsive Design](#5-responsive-design)
6. [Accessibility](#6-accessibility)
7. [Cultural Considerations](#7-cultural-considerations)

---

## 1. DESIGN PRINCIPLES

### 1.1 Core Principles

| Principle | Description | Implementation |
|-----------|-------------|----------------|
| **Respectful** | Hormati kearifan lokal dan adat Batak | Gunakan terminologi yang tepat, ikon bermakna |
| **Clear** | Informasi harus jelas dan mudah dipahami | Hierarki visual yang kuat, typography yang readable |
| **Connected** | Sistem ini tentang hubungan dan kekerabatan | Visualisasi tree/network yang intuitif |
| **Trustworthy** | Data genealogi adalah data sensitif | Security indicators, privacy controls |
| **Inclusive** | Aksesible untuk semua generasi | Font size adjustable, high contrast, simple navigation |

### 1.2 User Personas

#### Persona 1: Tetua Adat (60-70 tahun)
- **Goals:** Validasi data, mengelola upacara adat
- **Needs:** Font besar, kontras tinggi, proses yang jelas
- **Tech Level:** Low-Medium

#### Persona 2: Verified User (35-50 tahun)
- **Goals:** Input data keluarga, mencari hubungan kekerabatan
- **Needs:** Efisiensi, fitur lengkap, mobile access
- **Tech Level:** Medium-High

#### Persona 3: Young User (20-30 tahun)
- **Goals:** Eksplorasi silsilah, memahami adat
- **Needs:** Visual menarik, social features, gamification
- **Tech Level:** High

---

## 2. VISUAL DESIGN SYSTEM

### 2.1 Color Palette

```
PRIMARY COLORS (Batak Cultural Identity)
─────────────────────────────────────────
Primary 900   │ #1a365d  (Deep Navy)      │ Header, primary buttons
Primary 700   │ #2c5282  (Batak Blue)      │ Active states, links
Primary 500   │ #3182ce  (Heritage Blue)    │ Primary actions
Primary 300   │ #63b3ed  (Light Blue)       │ Hover states
Primary 100   │ #ebf8ff  (Sky)              │ Backgrounds, light elements

EARTH TONES (Traditional Ulos Colors)
─────────────────────────────────────────
Earth 900     │ #3d2914  (Dark Wood)         │ Text, borders
Earth 700     │ #5c3a1e  (Ulos Brown)       │ Secondary buttons
Earth 500     │ #8b5a2b  (Warm Brown)       │ Accents
Earth 300     │ #c4a77d  (Sand)             │ Backgrounds
Earth 100     │ #f5f0e6  (Cream)            │ Page background

SEMANTIC COLORS
─────────────────────────────────────────
Success 500   │ #38a169  (Green)            │ Success states
Warning 500   │ #d69e2e  (Yellow)           │ Warning states
Error 500     │ #e53e3e  (Red)             │ Error states
Info 500      │ #4299e1  (Blue)             │ Info states

TEXT COLORS
─────────────────────────────────────────
Text Primary  │ #1a202c  (Almost Black)     │ Headings, body text
Text Secondary│ #4a5568  (Gray)             │ Secondary text
Text Muted    │ #a0aec0  (Light Gray)       │ Placeholder, disabled
```

### 2.2 Typography

| Element | Font | Size | Weight | Line Height |
|---------|------|------|--------|-------------|
| **H1** | Inter | 32px | 700 | 1.2 |
| **H2** | Inter | 24px | 600 | 1.3 |
| **H3** | Inter | 20px | 600 | 1.4 |
| **H4** | Inter | 18px | 500 | 1.4 |
| **Body Large** | Inter | 18px | 400 | 1.6 |
| **Body** | Inter | 16px | 400 | 1.6 |
| **Body Small** | Inter | 14px | 400 | 1.5 |
| **Caption** | Inter | 12px | 400 | 1.5 |
| **Button** | Inter | 14px | 500 | 1 |
| **Label** | Inter | 12px | 600 | 1.4 |

**Accessibility Font Sizes:**
- Default: 16px base
- Large: 18px base (for elderly users)
- Extra Large: 20px base

### 2.3 Spacing System

```
SPACING SCALE (4px base)
─────────────────────────────────
xs  │ 4px   │ 0.25rem
sm  │ 8px   │ 0.5rem
md  │ 16px  │ 1rem
lg  │ 24px  │ 1.5rem
xl  │ 32px  │ 2rem
2xl │ 48px  │ 3rem
3xl │ 64px  │ 4rem
4xl │ 96px  │ 6rem
```

### 2.4 Border Radius

| Size | Value | Usage |
|------|-------|-------|
| Small | 4px | Inputs, badges |
| Medium | 8px | Buttons, cards |
| Large | 12px | Modals, containers |
| XL | 16px | Feature cards |
| Full | 9999px | Pills, avatars |

---

## 3. COMPONENT LIBRARY

### 3.1 Buttons

**Primary Button:**
```
┌─────────────────────────────┐
│     [    Primary    ]       │
│                             │
│  Background: Primary 500    │
│  Text: White                │
│  Padding: 12px 24px          │
│  Border Radius: 8px          │
│  Font Weight: 500            │
│                             │
│  Hover: Primary 600          │
│  Active: Primary 700         │
│  Disabled: Primary 300       │
└─────────────────────────────┘
```

**Secondary Button:**
```
┌─────────────────────────────┐
│    [   Secondary   ]        │
│                             │
│  Background: White          │
│  Border: Earth 300 (1px)    │
│  Text: Earth 700            │
│                             │
│  Hover: Earth 100           │
│  Active: Earth 200           │
└─────────────────────────────┘
```

**Button Variants:**
- **Primary**: Main actions (Simpan, Lanjutkan, Submit)
- **Secondary**: Cancel, Back
- **Danger**: Delete, Remove (red)
- **Ghost**: Low priority actions
- **Icon**: Actions dengan icon

### 3.2 Cards

**Person Card:**
```
┌─────────────────────────────────────────┐
│ ┌──────┐                                │
│ │ 👤   │  [Person Name]         ●       │
│ │Photo │  Marga: Simanjuntak   Active   │
│ └──────┘  Generation: 5th                 │
│           [Lihat Detail →]               │
└─────────────────────────────────────────┘

Specs:
- Background: White
- Border: 1px solid Earth 200
- Border Radius: 12px
- Shadow: 0 1px 3px rgba(0,0,0,0.1)
- Padding: 16px
- Hover: Shadow increases, slight lift
```

**Family Tree Card:**
```
┌─────────────────────────────────────────┐
│           ┌─────────────┐               │
│           │  Amang Tua  │               │
│           │  [Photo]    │               │
│           └──────┬──────┘               │
│                  │                      │
│      ┌───────────┴───────────┐          │
│      │                       │          │
│ ┌────┴────┐            ┌────┴────┐    │
│ │  Ayah   │◄──────────►│  Inang  │    │
│ │ [Photo] │            │ [Photo] │    │
│ └────┬────┘            └─────────┘    │
│      │                                 │
│ ┌────┴────┐                            │
│ │  Anak   │                            │
│ │ [Photo] │                            │
│ └─────────┘                            │
└─────────────────────────────────────────┘
```

### 3.3 Forms

**Input Field:**
```
Label
┌─────────────────────────────┐
│ Placeholder text            │
└─────────────────────────────┘
Helper text (optional)

Specs:
- Height: 44px (44px min touch target)
- Padding: 12px 16px
- Border: 1px solid Earth 300
- Border Radius: 8px
- Focus: Border Primary 500, Shadow 0 0 0 3px Primary 100
- Error: Border Error 500, Background Error 50
```

**Select/Dropdown:**
```
Pilih Marga
┌─────────────────────────────┐
│ Simanjuntak          ▼      │
└─────────────────────────────┘

Dropdown open:
┌─────────────────────────────┐
│ 🔍 Search marga...          │
├─────────────────────────────┤
│ ⭐ Simanjuntak              │
│    Sinaga                   │
│    Siregar                  │
│    Nainggolan               │
│    ...                      │
└─────────────────────────────┘
```

### 3.4 Navigation

**Main Navigation (Desktop):**
```
┌─────────────────────────────────────────────────────────────────┐
│  🌳 TAROMBO    [Beranda] [Silsilah] [Pencarian] [Adat] [Profil]│
└─────────────────────────────────────────────────────────────────┘

Specs:
- Height: 64px
- Background: White
- Shadow: 0 1px 3px rgba(0,0,0,0.1)
- Active link: Primary 700, underline
- Hover: Primary 100 background
```

**Mobile Navigation:**
```
┌─────────────────────────────┐
│                             │
│        (Content Area)       │
│                             │
├─────────────────────────────┤
│  🏠   🔍   ➕   📖   👤     │
│ Home  Cari  Add  Adat Profil│
└─────────────────────────────┘
```

### 3.5 Status Badges

| Status | Color | Example |
|--------|-------|---------|
| Active | Success | `● Active` |
| Pending | Warning | `● Pending` |
| Inactive | Neutral | `● Inactive` |
| Deceased | Muted | `✝ Deceased` |
| Verified | Primary | `✓ Verified` |
| Draft | Neutral | `○ Draft` |

---

## 4. PAGE LAYOUTS

### 4.1 Dashboard

```
┌─────────────────────────────────────────────────────────────────────┐
│  🌳 TAROMBO DIGITAL          🔍 Search...      🔔 👤 Profil        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │  Selamat datang, John Simanjuntak!                            │  │
│  │  Kamu memiliki 3 permintaan validasi yang menunggu.          │  │
│  │  [Lihat →]                                                  │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌──────────────┐ │
│  │ 📊 Statistik Saya │  │ 👨‍👩‍👧‍👦 Keluarga      │  │ 🔔 Notifikasi│ │
│  │                     │  │                     │  │              │ │
│  │ • 15 Anggota       │  │ • 3 Orang tua     │  │ • 2 Validasi │ │
│  │ • 5 Generasi       │  │ • 2 Saudara       │  │ • 1 Request  │ │
│  │ • 2 Pernikahan     │  │ • 10 Anak/cucu   │  │ • 1 Update   │ │
│  │                     │  │                     │  │              │ │
│  │ [Lihat Detail →]   │  │ [Lihat Tree →]    │  │ [Lihat →]   │ │
│  └─────────────────────┘  └─────────────────────┘  └──────────────┘ │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ 🔔 Aktivitas Terbaru                                         │  │
│  │ ─────────────────────                                       │  │
│  │ • Data anak baru ditambahkan oleh Amang [2 jam lalu]        │  │
│  │ • Validasi diterima dari Dongan Tubu [5 jam lalu]           │  │
│  │ • Pernikahan dicatat: John & Jane [1 hari lalu]             │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 4.2 Family Tree Page

```
┌─────────────────────────────────────────────────────────────────────┐
│  🌳 TAROMBO                    [🔍 Search]    🔔 👤                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │  Silsilah Keluarga: Simanjuntak                                │  │
│  │  [Tree ▼] [Timeline ▼] [Map ▼]        [Zoom -] [+] [Export 📥] │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│                         ┌───────────┐                               │
│                         │ Leluhur   │                               │
│                         │ Generation│                               │
│                         │     1     │                               │
│                         └─────┬─────┘                               │
│                               │                                     │
│              ┌────────────────┼────────────────┐                   │
│              │                │                │                   │
│        ┌─────┴─────┐    ┌─────┴─────┐    ┌─────┴─────┐             │
│        │ Gen 2     │    │ Gen 2     │    │ Gen 2     │             │
│        │ (Active)  │    │           │    │           │             │
│        └─────┬─────┘    └───────────┘    └───────────┘             │
│              │                                                     │
│        ┌─────┴─────┐                                               │
│        │  YOU      │◄──── [Selected - highlighted]                │
│        │  Gen 5    │                                               │
│        └─────┬─────┘                                               │
│              │                                                     │
│      ┌───────┴───────┐                                             │
│  ┌───┴───┐       ┌───┴───┐                                         │
│  │ Gen 6 │       │ Gen 6 │                                         │
│  │ Anak  │       │ Anak  │                                         │
│  └───────┘       └───────┘                                         │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Detail: John Simanjuntak (Gen 5)                             │  │
│  │ ─────────────────────────────────                            │  │
│  │ Lahir: 15 Jan 1990 | Status: Active | Validasi: L3          │  │
│  │ [Lihat Profil Lengkap →]                                     │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 4.3 Marriage Recording Page

```
┌─────────────────────────────────────────────────────────────────────┐
│  🌳 TAROMBO                                        🔔 👤 [Profil]   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ 📋 Pencatatan Pernikahan Adat                                │  │
│  │ ─────────────────────────────────                            │  │
│  │ Step 3 dari 7: Martonggo Raja                                │  │
│  │ [✓]──[✓]──[●]──[○]──[○]──[○]──[○]                          │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │                                                             │  │
│  │  Data Pengantin                                             │  │
│  │  ───────────────                                            │  │
│  │  Pria:  John Simanjuntak ●                                  │  │
│  │  Wanita: Jane Sinaga ● [Valid ✓]                            │  │
│  │                                                             │  │
│  │  ⚠️ Status Marga: Berbeda marga (OK)                       │  │
│  │                                                             │  │
│  │  ─────────────────────────────────                          │  │
│  │                                                             │  │
│  │  Tahapan: Martonggo Raja                                    │  │
│  │                                                             │  │
│  │  Tanggal Pelaksanaan: [15/06/2025 📅]                      │  │
│  │                                                             │  │
│  │  Lokasi:     [Gedung Serbaguna           ]                  │  │
│  │                                                             │  │
│  │  Raja Parhata: [Pilih Raja Parhata... ▼  ]                │  │
│  │                                                             │  │
│  │  Hula-hula Pihak Pria: [Otomatis: Tulang]                  │  │
│  │  Hula-hula Pihak Wanita: [Otomatis: Tulang]                │  │
│  │                                                             │  │
│  │  Dokumentasi: [📎 Upload foto/dokumen]                      │  │
│  │                                                             │  │
│  │  Catatan:                                                   │  │
│  │  ┌───────────────────────────────────────────────────────┐  │  │
│  │  │                                                       │  │  │
│  │  │                                                       │  │  │
│  │  └───────────────────────────────────────────────────────┘  │  │
│  │                                                             │  │
│  │              [ Kembali ]    [ Simpan Draft ]    [ Lanjut ]│  │
│  │                                                             │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. RESPONSIVE DESIGN

### 5.1 Breakpoints

| Device | Width | Target |
|--------|-------|--------|
| Mobile | 320px - 639px | Portrait phones |
| Tablet | 640px - 1023px | Tablets, landscape phones |
| Desktop | 1024px - 1279px | Small laptops |
| Large Desktop | 1280px+ | Standard monitors |
| XL Desktop | 1536px+ | Large monitors |

### 5.2 Responsive Patterns

**Family Tree Responsive:**
```
Desktop (1024px+)
┌────────────────────────────────────────┐
│  Tree with 5 generations visible       │
│  Horizontal layout                     │
│  Side panel with details               │
└────────────────────────────────────────┘

Tablet (768px)
┌────────────────────────┐
│  Tree with pan/zoom   │
│  3 generations        │
│  Bottom sheet details│
└────────────────────────┘

Mobile (375px)
┌──────────────┐
│  Focused on  │
│  selected    │
│  person      │
│  [▲ Ancestors│
│   ▼ Children]│
└──────────────┘
```

**Navigation Responsive:**
- Desktop: Horizontal navbar dengan semua links
- Tablet: Horizontal navbar dengan collapsed menu
- Mobile: Bottom navigation bar dengan 5 key actions

---

## 6. ACCESSIBILITY

### 6.1 WCAG 2.1 Compliance

| Level | Requirements | Status |
|-------|--------------|--------|
| **A** | Text alternatives, keyboard accessible, captions | Required |
| **AA** | Color contrast, resizable text, consistent navigation | Required |
| **AAA** | Enhanced contrast, sign language, extended audio | Optional |

### 6.2 Accessibility Features

**Keyboard Navigation:**
- All interactive elements accessible via Tab
- Escape closes modals/dropdowns
- Enter/Space activates buttons
- Arrow keys navigate within components

**Screen Reader Support:**
```html
<!-- Person card dengan ARIA labels -->
<div role="article" aria-labelledby="person-name-123" aria-describedby="person-info-123">
  <h3 id="person-name-123">John Simanjuntak</h3>
  <div id="person-info-123">
    <span>Marga Simanjuntak</span>
    <span>Generation 5</span>
  </div>
  <button aria-label="Lihat detail John Simanjuntak">
    Lihat Detail
  </button>
</div>
```

**Color Contrast:**
- Normal text: 4.5:1 minimum (AA)
- Large text: 3:1 minimum (AA)
- UI components: 3:1 minimum

**Focus Indicators:**
```css
/* Visible focus styles */
:focus-visible {
  outline: 3px solid #3182ce;
  outline-offset: 2px;
}

/* Skip to main content link */
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #1a365d;
  color: white;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

### 6.3 Accessibility Settings

**User Preferences:**
- Font size: Normal / Large / Extra Large
- High contrast mode
- Reduced motion
- Screen reader optimization

---

## 7. CULTURAL CONSIDERATIONS

### 7.1 Batak Cultural Elements

**Color Symbolism:**
- **Red (Ulos)**: Courage, strength
- **Black**: Earth, humility
- **White**: Purity, new beginnings
- **Gold**: Prosperity, high status

**Design Elements:**
```
┌─────────────────────────────────────────┐
│  Traditional Ulos Pattern Usage          │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ ╔════╦════╗ ╔════╦════╗      │    │
│  │ ║    ║    ║ ║    ║    ║      │    │
│  │ ╠════╬════╣ ╠════╬════╣      │    │  Subtle pattern
│  │ ║    ║    ║ ║    ║    ║      │    │  sebagai border
│  │ ╚════╩════╝ ╚════╩════╝      │    │  atau background
│  └─────────────────────────────────┘    │
│                                         │
└─────────────────────────────────────────┘
```

**Appropriate Imagery:**
- ✓ Traditional Batak houses (Rumah Bolon)
- ✓ Ulos patterns
- ✓ Natural landscapes (Danau Toba)
- ✓ Modern Batak people in traditional settings
- ✗ Avoid: Stereotypical or outdated representations

### 7.2 Language and Terminology

**Batak Terms in UI:**
| Batak | Indonesian | Usage |
|-------|------------|-------|
| Horas | Salam sejahtera | Greeting |
| Amang | Ayah | Panggilan formal |
| Inang | Ibu | Panggilan formal |
| Dongan | Saudara | Context: sesama marga |
| Tulang | Paman | Context: saudara laki ibu |
| Boru | Anak perempuan/istri | Context dependent |

**Cultural Sensitivity:**
- Gunakan terminologi adat yang tepat
- Jelaskan istilah kompleks dengan tooltip
- Hormati larangan dan aturan adat dalam desain workflow
- Berikan konteks budaya pada fitur-fitur adat

---

## LAMPIRAN: Design Tokens

```css
/* CSS Custom Properties */
:root {
  /* Colors */
  --color-primary-900: #1a365d;
  --color-primary-500: #3182ce;
  --color-primary-100: #ebf8ff;
  
  --color-earth-900: #3d2914;
  --color-earth-500: #8b5a2b;
  --color-earth-100: #f5f0e6;
  
  --color-success: #38a169;
  --color-warning: #d69e2e;
  --color-error: #e53e3e;
  
  /* Typography */
  --font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-size-xs: 0.75rem;
  --font-size-sm: 0.875rem;
  --font-size-base: 1rem;
  --font-size-lg: 1.125rem;
  --font-size-xl: 1.25rem;
  --font-size-2xl: 1.5rem;
  
  /* Spacing */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
  
  /* Transitions */
  --transition-fast: 150ms ease;
  --transition-base: 250ms ease;
  --transition-slow: 350ms ease;
}
```

---

**Referensi:** SYSTEM_REQUIREMENT.md, ANALISIS_BUDAYA_BATAK.md

© 2026 Tarombo Digital Project
