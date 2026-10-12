// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HorizonEntriesTable extends HorizonEntries
    with TableInfo<$HorizonEntriesTable, HorizonEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HorizonEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTopLeverMeta = const VerificationMeta(
    'isTopLever',
  );
  @override
  late final GeneratedColumn<bool> isTopLever = GeneratedColumn<bool>(
    'is_top_lever',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_top_lever" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
    'scheduled_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('usd'),
  );
  static const VerificationMeta _walletMeta = const VerificationMeta('wallet');
  @override
  late final GeneratedColumn<String> wallet = GeneratedColumn<String>(
    'wallet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD Cash'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    isTopLever,
    scheduledTime,
    amount,
    currency,
    wallet,
    category,
    isCompleted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'horizon_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HorizonEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_top_lever')) {
      context.handle(
        _isTopLeverMeta,
        isTopLever.isAcceptableOrUnknown(
          data['is_top_lever']!,
          _isTopLeverMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('wallet')) {
      context.handle(
        _walletMeta,
        wallet.isAcceptableOrUnknown(data['wallet']!, _walletMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HorizonEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HorizonEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isTopLever: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_top_lever'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_time'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      wallet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wallet'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HorizonEntriesTable createAlias(String alias) {
    return $HorizonEntriesTable(attachedDatabase, alias);
  }
}

class HorizonEntry extends DataClass implements Insertable<HorizonEntry> {
  final String id;
  final String type;
  final String title;
  final bool isTopLever;
  final String? scheduledTime;
  final double amount;
  final String currency;
  final String wallet;
  final String category;
  final bool isCompleted;
  final DateTime createdAt;
  const HorizonEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.isTopLever,
    this.scheduledTime,
    required this.amount,
    required this.currency,
    required this.wallet,
    required this.category,
    required this.isCompleted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['is_top_lever'] = Variable<bool>(isTopLever);
    if (!nullToAbsent || scheduledTime != null) {
      map['scheduled_time'] = Variable<String>(scheduledTime);
    }
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['wallet'] = Variable<String>(wallet);
    map['category'] = Variable<String>(category);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HorizonEntriesCompanion toCompanion(bool nullToAbsent) {
    return HorizonEntriesCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      isTopLever: Value(isTopLever),
      scheduledTime: scheduledTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTime),
      amount: Value(amount),
      currency: Value(currency),
      wallet: Value(wallet),
      category: Value(category),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory HorizonEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HorizonEntry(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      isTopLever: serializer.fromJson<bool>(json['isTopLever']),
      scheduledTime: serializer.fromJson<String?>(json['scheduledTime']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      wallet: serializer.fromJson<String>(json['wallet']),
      category: serializer.fromJson<String>(json['category']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'isTopLever': serializer.toJson<bool>(isTopLever),
      'scheduledTime': serializer.toJson<String?>(scheduledTime),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'wallet': serializer.toJson<String>(wallet),
      'category': serializer.toJson<String>(category),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HorizonEntry copyWith({
    String? id,
    String? type,
    String? title,
    bool? isTopLever,
    Value<String?> scheduledTime = const Value.absent(),
    double? amount,
    String? currency,
    String? wallet,
    String? category,
    bool? isCompleted,
    DateTime? createdAt,
  }) => HorizonEntry(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    isTopLever: isTopLever ?? this.isTopLever,
    scheduledTime: scheduledTime.present
        ? scheduledTime.value
        : this.scheduledTime,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    wallet: wallet ?? this.wallet,
    category: category ?? this.category,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
  );
  HorizonEntry copyWithCompanion(HorizonEntriesCompanion data) {
    return HorizonEntry(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      isTopLever: data.isTopLever.present
          ? data.isTopLever.value
          : this.isTopLever,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      wallet: data.wallet.present ? data.wallet.value : this.wallet,
      category: data.category.present ? data.category.value : this.category,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HorizonEntry(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('isTopLever: $isTopLever, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('wallet: $wallet, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    isTopLever,
    scheduledTime,
    amount,
    currency,
    wallet,
    category,
    isCompleted,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HorizonEntry &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.isTopLever == this.isTopLever &&
          other.scheduledTime == this.scheduledTime &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.wallet == this.wallet &&
          other.category == this.category &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class HorizonEntriesCompanion extends UpdateCompanion<HorizonEntry> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<bool> isTopLever;
  final Value<String?> scheduledTime;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> wallet;
  final Value<String> category;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HorizonEntriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.isTopLever = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.wallet = const Value.absent(),
    this.category = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HorizonEntriesCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.isTopLever = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.wallet = const Value.absent(),
    this.category = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title);
  static Insertable<HorizonEntry> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<bool>? isTopLever,
    Expression<String>? scheduledTime,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? wallet,
    Expression<String>? category,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (isTopLever != null) 'is_top_lever': isTopLever,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (wallet != null) 'wallet': wallet,
      if (category != null) 'category': category,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HorizonEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<bool>? isTopLever,
    Value<String?>? scheduledTime,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? wallet,
    Value<String>? category,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HorizonEntriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      isTopLever: isTopLever ?? this.isTopLever,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      wallet: wallet ?? this.wallet,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isTopLever.present) {
      map['is_top_lever'] = Variable<bool>(isTopLever.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (wallet.present) {
      map['wallet'] = Variable<String>(wallet.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HorizonEntriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('isTopLever: $isTopLever, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('wallet: $wallet, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HorizonEntriesTable horizonEntries = $HorizonEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [horizonEntries];
}

typedef $$HorizonEntriesTableCreateCompanionBuilder =
    HorizonEntriesCompanion Function({
      required String id,
      required String type,
      required String title,
      Value<bool> isTopLever,
      Value<String?> scheduledTime,
      Value<double> amount,
      Value<String> currency,
      Value<String> wallet,
      Value<String> category,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$HorizonEntriesTableUpdateCompanionBuilder =
    HorizonEntriesCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<bool> isTopLever,
      Value<String?> scheduledTime,
      Value<double> amount,
      Value<String> currency,
      Value<String> wallet,
      Value<String> category,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HorizonEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HorizonEntriesTable> {
  $$HorizonEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTopLever => $composableBuilder(
    column: $table.isTopLever,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wallet => $composableBuilder(
    column: $table.wallet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HorizonEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HorizonEntriesTable> {
  $$HorizonEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTopLever => $composableBuilder(
    column: $table.isTopLever,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wallet => $composableBuilder(
    column: $table.wallet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HorizonEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HorizonEntriesTable> {
  $$HorizonEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isTopLever => $composableBuilder(
    column: $table.isTopLever,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get wallet =>
      $composableBuilder(column: $table.wallet, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HorizonEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HorizonEntriesTable,
          HorizonEntry,
          $$HorizonEntriesTableFilterComposer,
          $$HorizonEntriesTableOrderingComposer,
          $$HorizonEntriesTableAnnotationComposer,
          $$HorizonEntriesTableCreateCompanionBuilder,
          $$HorizonEntriesTableUpdateCompanionBuilder,
          (
            HorizonEntry,
            BaseReferences<_$AppDatabase, $HorizonEntriesTable, HorizonEntry>,
          ),
          HorizonEntry,
          PrefetchHooks Function()
        > {
  $$HorizonEntriesTableTableManager(
    _$AppDatabase db,
    $HorizonEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HorizonEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HorizonEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HorizonEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isTopLever = const Value.absent(),
                Value<String?> scheduledTime = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> wallet = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HorizonEntriesCompanion(
                id: id,
                type: type,
                title: title,
                isTopLever: isTopLever,
                scheduledTime: scheduledTime,
                amount: amount,
                currency: currency,
                wallet: wallet,
                category: category,
                isCompleted: isCompleted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<bool> isTopLever = const Value.absent(),
                Value<String?> scheduledTime = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> wallet = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HorizonEntriesCompanion.insert(
                id: id,
                type: type,
                title: title,
                isTopLever: isTopLever,
                scheduledTime: scheduledTime,
                amount: amount,
                currency: currency,
                wallet: wallet,
                category: category,
                isCompleted: isCompleted,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HorizonEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HorizonEntriesTable,
      HorizonEntry,
      $$HorizonEntriesTableFilterComposer,
      $$HorizonEntriesTableOrderingComposer,
      $$HorizonEntriesTableAnnotationComposer,
      $$HorizonEntriesTableCreateCompanionBuilder,
      $$HorizonEntriesTableUpdateCompanionBuilder,
      (
        HorizonEntry,
        BaseReferences<_$AppDatabase, $HorizonEntriesTable, HorizonEntry>,
      ),
      HorizonEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HorizonEntriesTableTableManager get horizonEntries =>
      $$HorizonEntriesTableTableManager(_db, _db.horizonEntries);
}
