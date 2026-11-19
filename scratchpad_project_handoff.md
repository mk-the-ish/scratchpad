# Scratchpad — Project Architecture & Handoff Specification

## 1. Project Overview & Objectives
**Scratchpad** is a local-first, offline-capable personal life management and daily expense tracking mobile application built with **Flutter** and **Drift (SQLite)**.

### Core Motivations
* **Zero-Latency Offline Execution:** Personal financial logging and daily task management must work instantaneously without network dependency, cloud sync delays, or subscription lock-in.
* **Multi-Currency Reality (USD & ZiG):** Designed around real-world dual-currency cash and mobile money workflows (specifically **USD** and **ZiG**), keeping balances, budgets, and monthly outflow analytics cleanly separated by currency rather than forcing fragile exchange-rate conversions.
* **Unified Personal Utility:** Consolidates daily financial tracking, quick scratchpad notes, and daily tasks/routines into a single lightweight local SQLite database.

### Primary Goals
1. **Sub-5-Second Expense Entry:** A thumb-friendly quick-entry flow for logging daily expenses with currency selection, category chips, optional notes, and date overrides.
2. **Real-Time Reactive Analytics:** Instant calculation of monthly spending totals, category distribution breakdowns, and customizable monthly budget caps per currency.
3. **Clean Local Architecture:** Strict separation between the Drift persistence layer, domain models/streams, and Material 3 UI components.
4. **Data Portability:** Local JSON/CSV export and backup capabilities so the user retains full ownership of their SQLite data.

---

## 2. Tech Stack & Environment
* **Framework:** Flutter (Material 3)
* **Local Database:** Drift (`drift`, `sqlite3_flutter_libs`, `path_provider`, `path`)
* **Code Generation:** `drift_dev`, `build_runner`
* **Target Platform:** Android (`compileSdk` / `targetSdk` 35, JDK 21)
* **Typography & Palette:**
  * Primary Display/UI Font: `Plus Jakarta Sans`
  * Monospace Numeric/Ledger Font: `JetBrains Mono`
  * Color Tokens:
    * Primary Accent (`transitTeal`): `#0D9488`
    * Dark Surface (`obsidianDeep`): `#0F172A`
    * Background (`cloudWhite`): `#F8FAFC`
    * Secondary Text (`safeSlate`): `#334155`
    * Warning (`alertAmber`): `#F59E0B`
    * Success (`activeMint`): `#10B981`
    * Borders (`cardBorder`): `#E2E8F0`

---

## 3. What Has Been Accomplished So Far

### A. Build & Android Toolchain Resolution
* Configured Gradle to run with **Java 21** (`C:\Program Files\Java\jdk-21`).
* Resolved native SQLite/JNI compilation requirements by installing **Android SDK Platform 35** (`platforms;android-35`), NDK v27, and Build-Tools v35.

### B. Theme & Design Tokens
* Defined centralized color tokens in `lib/core/theme/app_tokens.dart` (`AppColors`).

### C. Expense Tracking UI & Analytics Module
Created the complete UI layer for expense tracking and monthly analytics:
1. **`SpendingAnalyticsCard` (`lib/features/expenses/widgets/spending_analytics_card.dart`)**:
   * Displays monthly outflow totals formatted per selected currency (`USD` vs `ZiG`).
   * Includes an interactive `USD` / `ZiG` segmented toggle.
   * Renders a custom segmented horizontal category breakdown bar with percentage legend chips.
   * Displays progress toward a monthly budget limit with an amber warning threshold at $\ge 85\%$.
2. **`AddExpenseSheet` (`lib/features/expenses/widgets/add_expense_sheet.dart`)**:
   * Modal bottom sheet with currency switcher, numeric decimal input, category `ChoiceChip` selector (`Food & Groceries`, `Transport & Fuel`, `Data & Airtime`, `Utilities & Bills`, `Software & Gear`, `Other`), note input, and date picker.
3. **`ExpensesScreen` (`lib/features/expenses/expenses_screen.dart`)**:
   * Month-by-month navigation header (`< Month Year >`).
   * Reactive `StreamBuilder` driving the analytics card and chronological transaction list.
   * Swipe-to-delete (`Dismissible`) on transaction tiles and a Floating Action Button (`+ Add Expense`).
4. **`EditBudgetDialog` (`lib/features/expenses/widgets/edit_budget_dialog.dart`)**:
   * Modal dialog allowing the user to update the monthly spending cap for the currently selected currency.

### D. Drift Database Schema & Reactive Queries
Designed the Drift schema and reactive DAO methods:
* **Tables:**
  * `Expenses`: `id` (auto-increment), `amount` (real), `currency` (text), `category` (text), `note` (text), `date` (dateTime), `createdAt` (dateTime).
  * `CurrencyBudgets`: `currency` (text primary key), `monthlyLimit` (real).
* **Streams & Mutations:**
  * `watchExpensesForMonth(DateTime month, String currency)`
  * `watchMonthlyBudget(String currency)`
  * `insertExpense(...)`, `deleteExpense(int id)`, `setMonthlyBudget(String currency, double limit)`

---

## 4. ⚠️ Important Note for the Coding Agent (Path Reconciliation)
During iterative code generation without direct workspace access, two different file paths were referenced for the Drift database file:
* `lib/core/database/app_database.dart` (earlier scaffold)
* `lib/data/local/app_database.dart` (later expense-module scaffold)

**Immediate Action Required by Agent:**
1. Inspect the existing `lib/` directory tree first to see which database path (`lib/core/database/` vs `lib/data/local/`) and existing tables/providers are already present in the repository.
2. **Consolidate into a single `AppDatabase` file** (do not create duplicate database instances or conflicting `app_database.g.dart` files).
3. Merge the `Expenses` and `CurrencyBudgets` tables/queries into the canonical `AppDatabase` class, re-run `dart run build_runner build --delete-conflicting-outputs`, and update imports in `main.dart` and `ExpensesScreen` accordingly.

---

## 5. Remaining Roadmap (To Be Accomplished)

1. **Wire Live Budget Editing into `ExpensesScreen`:**
   * Connect `db.watchMonthlyBudget(_selectedCurrency)` to `SpendingAnalyticsCard`'s `budgetLimit` parameter.
   * Wrap the budget footer row in a `GestureDetector` to launch `EditBudgetDialog` and persist updates via `db.setMonthlyBudget(...)`.
2. **Transaction UX Enhancements:**
   * Add an **Undo `SnackBar`** when a transaction is dismissed/deleted (re-inserting the deleted record if tapped).
   * Group transaction tiles under sticky/clean date section headers (`Today`, `Yesterday`, and formatted dates).
   * Add tap-to-edit functionality on existing transaction tiles.
3. **Daily Spend Velocity Chart:**
   * Add a lightweight custom-painted bar/sparkline chart showing daily spending distribution across the active month.
4. **Life Manager Modules (Shared Drift Database):**
   * **Tasks / Daily Planner:** Drift table + UI for daily to-dos, priorities, and completion state.
   * **Quick Scratchpad Notes:** Drift table + UI for fast markdown/plain-text notes and pinned ideas.
   * **Unified Navigation:** Bottom `NavigationBar` switching cleanly between **Expenses**, **Tasks**, and **Notes**.
5. **Local Backup & Export:**
   * Export transactions and notes to `.csv` and `.json` via `share_plus` / file picker, plus full SQLite/JSON restore.