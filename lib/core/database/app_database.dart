import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Tables
class HorizonEntries extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()(); // 'task' or 'expense'
  TextColumn get title => text()();
  BoolColumn get isTopLever => boolean().withDefault(const Constant(false))();
  TextColumn get scheduledTime => text().nullable()();

  // Expense specifics
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get currency =>
      text().withDefault(const Constant('usd'))(); // 'usd' or 'zig'
  TextColumn get wallet => text().withDefault(const Constant('USD Cash'))();
  TextColumn get category => text().withDefault(const Constant('general'))();

  // State
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withLength(min: 2, max: 10)();
  TextColumn get category => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CurrencyBudgets extends Table {
  TextColumn get currency => text()();
  RealColumn get monthlyLimit => real()();

  @override
  Set<Column> get primaryKey => {currency};
}

@DriftDatabase(tables: [HorizonEntries, Expenses, CurrencyBudgets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(expenses);
        await m.createTable(currencyBudgets);
      }
    },
  );

  // Stream all entries created today (live updates)
  Stream<List<HorizonEntry>> watchTodayEntries() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (select(horizonEntries)
          ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startOfDay))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  // Insert or update an entry
  Future<int> insertEntry(HorizonEntriesCompanion entry) =>
      into(horizonEntries).insertOnConflictUpdate(entry);

  // Toggle completion
  Future<void> toggleCompleted(String id, bool currentState) {
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id))).write(
      HorizonEntriesCompanion(isCompleted: Value(!currentState)),
    );
  }

  // Cycle wallet
  Future<void> updateWallet(String id, String nextWallet) {
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id))).write(
      HorizonEntriesCompanion(wallet: Value(nextWallet)),
    );
  }

  // Delete an entry
  Future<int> deleteEntry(String id) {
    return (delete(horizonEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Streams the expenses for [month] and [currency], newest first.
  Stream<List<Expense>> watchExpensesForMonth(DateTime month, String currency) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    return (select(expenses)
          ..where(
            (t) =>
                t.currency.equals(currency) &
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerThanValue(end),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.id),
          ]))
        .watch();
  }

  /// Streams the monthly budget for [currency], or a default when unset.
  Stream<double> watchMonthlyBudget(String currency) {
    return (select(
      currencyBudgets,
    )..where((t) => t.currency.equals(currency))).watchSingleOrNull().map(
      (row) => row?.monthlyLimit ?? (currency == 'USD' ? 500.0 : 15000.0),
    );
  }

  Future<int> insertExpense({
    required double amount,
    required String currency,
    required String category,
    required String note,
    required DateTime date,
  }) {
    return into(expenses).insert(
      ExpensesCompanion.insert(
        amount: amount,
        currency: currency,
        category: category,
        note: Value(note),
        date: date,
      ),
    );
  }

  Future<int> deleteExpense(int id) {
    return (delete(expenses)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setMonthlyBudget(String currency, double limit) {
    return into(currencyBudgets).insertOnConflictUpdate(
      CurrencyBudgetsCompanion.insert(currency: currency, monthlyLimit: limit),
    );
  }

  // Fetch all incomplete tasks from today
  Future<List<HorizonEntry>> getIncompleteTodayTasks() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return (select(horizonEntries)..where(
          (tbl) =>
              tbl.type.equals('task') &
              tbl.isCompleted.equals(false) &
              tbl.createdAt.isBiggerOrEqualValue(startOfDay),
        ))
        .get();
  }

  // Roll over to tomorrow (bumps timestamp to start of tomorrow)
  Future<void> rollTaskToTomorrow(String id) {
    final tomorrowMorning = DateTime.now().add(const Duration(days: 1));
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id))).write(
      HorizonEntriesCompanion(createdAt: Value(tomorrowMorning)),
    );
  }

  // Move to backlog (demotes priority)
  Future<void> demoteToBacklog(String id) {
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id))).write(
      const HorizonEntriesCompanion(isTopLever: Value(false)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'personal_os.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
