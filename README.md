Here is a tailored, production-grade `README.md` for **Scratchpad**, highlighting the technical challenges of local-first mobile architecture, multi-currency state engines, and context-specific product engineering.

```markdown
# Scratchpad

> A context-aware, local-first personal OS and rapid expense tracker engineered for multi-currency liquidity balancing, instant task capture, and daily variable burn visibility.

---

## ⚡ The Problem

Most personal management and productivity apps are inherently Euro- or American-centric. They operate on foundational assumptions that fail in developing economies like Zimbabwe:
1. **Frictionless Card Swipes:** They assume automated bank syncing (Plaid/Yodlee) tied to a single, stable base currency.
2. **Stable Data & Grid Infrastructure:** They depend on persistent cloud connections, failing or lagging during power outages or mobile network drops.
3. **Rigid Categorization Modals:** Logging a $1.50 commuter omnibus (combi) fare or mobile data bundle takes 5+ taps through slow form wizards, making real-time street logging impractical.

In reality, daily liquidity is fragmented across **USD Physical Cash** (small bills), **EcoCash USD**, and **ZiG bank accounts**. 

**Scratchpad** was designed from the ground up to solve this: a high-throughput, offline-first personal command center that turns freeform natural language strings into structured financial transactions and prioritized tasks with zero modal friction.

---

## 🚀 Key Features

* **Universal Natural Language Scratchpad:** A single, instant-focus input bar that parses intent in real time. Typing `$1.50 combi town` logs an expense to the cash ledger; typing `! bursar report 2pm` pins a prioritized operational lever.
* **Zimbabwe-First Multi-Currency Engine:** Native support for dual-denomination tracking (USD & ZiG) with instant one-tap wallet cycling (`USD Cash` ⇄ `EcoCash USD` ⇄ `ZiG Account`).
* **Live "Daily Variable Burn" Ledger:** Real-time running calculation of today's operational micro-expenses (transit, airtime, food) without burying numbers inside complex balance sheets.
* **Top Levers Architecture ("Rule of 3"):** Caps priority daily actions at 3 key items, preventing cognitive overload and task-backlog paralysis.
* **100% Offline-First Persistence (Drift SQLite):** Powered by reactive SQLite streams. Zero network latency, instant cold boot, and full data sovereignty on-device.
* **Gesture-Driven Triage:** Native swipe-to-complete (right) and swipe-to-dismiss (left) interactions with haptic feedback.

---

## 🧠 Parsing Engine Syntax

The regex and keyword parser classifies freeform text dynamically into structured models:

| Raw Input | Parsed Entity | Inferred Attributes |
| :--- | :--- | :--- |
| `$1.50 combi town` | **Expense** | `Amount: 1.50` • `Currency: USD` • `Wallet: USD Cash` • `Category: Transit` |
| `eco 5 bundles` | **Expense** | `Amount: 5.00` • `Currency: USD` • `Wallet: EcoCash USD` • `Category: Data/Airtime` |
| `zig 45 bread` | **Expense** | `Amount: 45.0` • `Currency: ZiG` • `Wallet: ZiG Account` • `Category: Food` |
| `! submit bursar logbook 4pm` | **Top Lever** | `Priority: Critical` • `Due: 16:00` • `Title: submit bursar logbook` |
| `buy 10L diesel tonight` | **Daily Task** | `Priority: Normal` • `Time: Tonight` • `Title: buy 10L diesel` |

---

## 🛠️ Architecture & Data Flow

```text
 ┌────────────────────────────────────────────────────────┐
 │            QuickCaptureBar (TextField)                │
 └──────────────────────────┬─────────────────────────────┘
                            │
                            ▼
              ScratchpadParser (Regex Engine)
              ├── Currency & Symbol Discriminator ($ / eco / zig)
              ├── Localized Keyword Heuristics (combi, bundles, zesa)
              └── Priority Extractor (! / * / time tags)
                            │
                            ▼
                  Drift Database (SQLite)
              ├── Table: HorizonEntries
              └── Reactive Query: watchTodayEntries()
                            │
                            ▼
                 StreamBuilder UI Layer
              ├── Daily Variable Burn Bar (USD / ZiG)
              ├── Top Levers Group (Rule of 3)
              └── Mixed Scratchpad Stream

```

---

## 📦 Tech Stack

* **Framework:** Flutter (Dart) — targeting Mobile (iOS/Android) with unified desktop compatibility (Windows).
* **Local Database Engine:** Drift (Type-safe SQLite abstraction) + `sqlite3_flutter_libs`.
* **Platform Integrations:** `path_provider`, native hardware haptics.
* **Code Generation:** `build_runner`, `drift_dev`.

---

## 🚦 Getting Started

### Prerequisites

* Flutter SDK (3.19.0+)
* Dart SDK (3.3.0+)
* Android Studio / VS Code with Flutter extension
* Windows 11 build tools (if running on Windows desktop)

### Installation

1. **Clone the repository:**
cd scratchpad


2. **Install project dependencies:**

flutter pub get



3. **Generate Drift SQLite Database Mappings:**

dart run build_runner build --delete-conflicting-outputs


4. **Run the Application:**

# Run on connected mobile device or emulator
flutter run

# Or run natively on Windows desktop
flutter run -d windows




---

## 🗺️ Roadmap

* [x] Natural language parser for USD, ZiG, and EcoCash
* [x] Real-time live parsing pill preview
* [x] Drift SQLite persistent local storage
* [x] Swipe gesture triage & dynamic burn header
* [ ] **Nightly Sweep Modal:** 10:00 PM review trigger to carry forward or purge incomplete tasks
* [ ] **Biometric Lockout:** Local authentication protection for cash balances
* [ ] **Supabase Sync Engine:** Vector clock sync bridge to pair with companion desktop client

---

## 📄 License

MIT License. Free for open-source development and personal use.


