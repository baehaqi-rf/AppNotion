# AppFlowy Monorepo (1:1 REA Replikasi Produksi)

Replikasi 1:1 *ground-truth* dari repositori resmi [AppFlowy-IO/AppFlowy](https://github.com/AppFlowy-IO/AppFlowy) yang dikonfigurasi menggunakan arsitektur **Flutter Monorepo** standar industri berbasis **Melos** dan **Dart Workspace**.

---

## 🏛️ Arsitektur Monorepo

```
PROJECT FLUTTER/
├── melos.yaml                     # Konfigurasi Melos Orchestrator
├── pubspec.yaml                   # Root Workspace Pubspec (Dart 3.5+ Workspace & overrides)
├── analysis_options.yaml          # Standard Monorepo Linting & Static Analysis
├── README.md                      # Dokumentasi komprehensif monorepo
├── apps/
│   └── appflowy/                  # Aplikasi Utama AppFlowy Client (1:1 Ground Truth)
│       ├── lib/                   # Arsitektur modul feature: AI, Workspace, User, Document, Database
│       ├── assets/                # Full-fidelity Vector Icons (16x, 20x, 24x, 32x, 40x), Images, i18n
│       ├── android/               # Native Android Shell
│       ├── ios/                   # Native iOS Shell
│       ├── windows/               # Native Windows Desktop Runner
│       ├── macos/                 # Native macOS Desktop Runner
│       ├── linux/                 # Native Linux Desktop Runner
│       └── web/                   # Web Platform Runner
├── packages/
│   ├── appflowy_backend/          # Rust-FFI client bridge, event dispatch, protobuf RPCs
│   ├── appflowy_popover/          # Floating popover, overlay positioning, dropdown menus
│   ├── appflowy_result/           # Functional Result monad (Ok/Err failure encapsulation)
│   ├── appflowy_ui/               # Design tokens, AppFlowy color palettes, typography, UI widgets
│   ├── flowy_infra/               # Event buses, loggers, platform utilities, plugins infra
│   ├── flowy_infra_ui/            # Atomic UI controls, buttons, tooltips, context menus
│   └── flowy_svg/                 # Zero-loss SVG vector parsing and rendering
├── rust-lib/                      # Crate Backend Rust Asli (flowy-core, flowy-sqlite, dart-ffi, dsb.)
├── scripts/                       # Skrip otomatisasi build, code-gen, packaging distribusi
└── resources/                     # Asset Flowy Icons & translations i18n
```

---

## 📦 Paket-Paket Monorepo

| Package | Tipe | Path | Deskripsi |
| :--- | :--- | :--- | :--- |
| `appflowy` | Application | `apps/appflowy` | Aplikasi utama AppFlowy (Notion alternative open-source) |
| `appflowy_backend` | Plugin/FFI | `packages/appflowy_backend` | FFI Bridge komunikasi Dart ↔ Rust backend & Protobuf |
| `appflowy_popover` | Package | `packages/appflowy_popover` | Overlay & context popover positioning engine |
| `appflowy_result` | Package | `packages/appflowy_result` | Monad Result & handling error fungsional |
| `appflowy_ui` | Package | `packages/appflowy_ui` | Sistem desain visual, theme, typography, & token UI |
| `flowy_infra` | Package | `packages/flowy_infra` | Infrastruktur utilitas, event bus, date/time, & logger |
| `flowy_infra_ui` | Package | `packages/flowy_infra_ui` | Komponen tombol, input dialog, dan dropdown menu |
| `flowy_svg` | Package | `packages/flowy_svg` | Engine render aset SVG vektor performa tinggi |

---

## ⚡ Perintah Melos

Seluruh skrip berikut dapat dijalankan dari root direktori proyek:

```bash
# Melakukan bootstrap dan linking semua package
dart run melos bootstrap

# Menampilkan daftar paket dalam workspace
dart run melos list

# Menampilkan graph dependensi antar paket
dart run melos list --graph

# Analisis static linting pada semua paket
dart run melos run analyze

# Format kode Dart di seluruh monorepo
dart run melos run format

# Menjalankan unit test di semua paket
dart run melos run test

# Membersihkan cache build
dart run melos run clean
```

### Menjalankan Aplikasi AppFlowy

```bash
# Menjalankan di Windows Desktop
dart run melos run run:windows

# Menjalankan di Chrome Web
dart run melos run run:web

# Menjalankan di Android
dart run melos run run:android

# Menjalankan di macOS Desktop
dart run melos run run:macos

# Menjalankan di Linux Desktop
dart run melos run run:linux

# Menjalankan di iOS
dart run melos run run:ios
```

---

## 🔬 Kepatuhan Metode REA (Reverse Engineer Anything) 1:1

1. **Zero-Interpretation Policy:** Seluruh kode sumber diekstrak langsung dari repositori ground-truth AppFlowy tanpa aproksimasi atau desain tiruan generik.
2. **Full-Fidelity Structure:** Struktur folder, modularisasi internal, dan penamaan kelas CSS/Widget dipertahankan secara utuh.
3. **Vector & Typography Parity:** Seluruh ikon SVG (resolusi 16px, 20px, 24px, 32px, 40px) dan font bawaan (*Poppins*, *Roboto Mono*) disertakan 1:1.
4. **Unified Workspace Resolution:** Menggunakan Dart 3.5+ workspace dan Melos 8.10 untuk manajemen ketergantungan paket monorepo secara atomik.
