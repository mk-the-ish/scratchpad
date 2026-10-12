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
  TextColumn get currency => text().withDefault(const Constant('usd'))(); // 'usd' or 'zig'
  TextColumn get wallet => text().withDefault(const Constant('USD Cash'))();
  TextColumn get category => text().withDefault(const Constant('general'))();
  
  // State
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [HorizonEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id)))
        .write(HorizonEntriesCompanion(isCompleted: Value(!currentState)));
  }

  // Cycle wallet
  Future<void> updateWallet(String id, String nextWallet) {
    return (update(horizonEntries)..where((tbl) => tbl.id.equals(id)))
        .write(HorizonEntriesCompanion(wallet: Value(nextWallet)));
  }

  // Delete an entry
  Future<int> deleteEntry(String id) {
    return (delete(horizonEntries)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'personal_os.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}