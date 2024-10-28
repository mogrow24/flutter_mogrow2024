// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gemstoneMeta =
      const VerificationMeta('gemstone');
  @override
  late final GeneratedColumn<String> gemstone = GeneratedColumn<String>(
      'gemstone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
      'repeat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<bool> status = GeneratedColumn<bool>(
      'status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("status" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _isContinueMeta =
      const VerificationMeta('isContinue');
  @override
  late final GeneratedColumn<bool> isContinue = GeneratedColumn<bool>(
      'is_continue', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_continue" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, gemstone, repeat, status, isCompleted, isContinue, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('gemstone')) {
      context.handle(_gemstoneMeta,
          gemstone.isAcceptableOrUnknown(data['gemstone']!, _gemstoneMeta));
    }
    if (data.containsKey('repeat')) {
      context.handle(_repeatMeta,
          repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('is_continue')) {
      context.handle(
          _isContinueMeta,
          isContinue.isAcceptableOrUnknown(
              data['is_continue']!, _isContinueMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      gemstone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gemstone']),
      repeat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isContinue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_continue'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final int id;
  final String title;
  final String? gemstone;
  final String? repeat;
  final bool status;
  final bool isCompleted;
  final bool isContinue;
  final DateTime? date;
  const Todo(
      {required this.id,
      required this.title,
      this.gemstone,
      this.repeat,
      required this.status,
      required this.isCompleted,
      required this.isContinue,
      this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || gemstone != null) {
      map['gemstone'] = Variable<String>(gemstone);
    }
    if (!nullToAbsent || repeat != null) {
      map['repeat'] = Variable<String>(repeat);
    }
    map['status'] = Variable<bool>(status);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_continue'] = Variable<bool>(isContinue);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      gemstone: gemstone == null && nullToAbsent
          ? const Value.absent()
          : Value(gemstone),
      repeat:
          repeat == null && nullToAbsent ? const Value.absent() : Value(repeat),
      status: Value(status),
      isCompleted: Value(isCompleted),
      isContinue: Value(isContinue),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      gemstone: serializer.fromJson<String?>(json['gemstone']),
      repeat: serializer.fromJson<String?>(json['repeat']),
      status: serializer.fromJson<bool>(json['status']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isContinue: serializer.fromJson<bool>(json['isContinue']),
      date: serializer.fromJson<DateTime?>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'gemstone': serializer.toJson<String?>(gemstone),
      'repeat': serializer.toJson<String?>(repeat),
      'status': serializer.toJson<bool>(status),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isContinue': serializer.toJson<bool>(isContinue),
      'date': serializer.toJson<DateTime?>(date),
    };
  }

  Todo copyWith(
          {int? id,
          String? title,
          Value<String?> gemstone = const Value.absent(),
          Value<String?> repeat = const Value.absent(),
          bool? status,
          bool? isCompleted,
          bool? isContinue,
          Value<DateTime?> date = const Value.absent()}) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        gemstone: gemstone.present ? gemstone.value : this.gemstone,
        repeat: repeat.present ? repeat.value : this.repeat,
        status: status ?? this.status,
        isCompleted: isCompleted ?? this.isCompleted,
        isContinue: isContinue ?? this.isContinue,
        date: date.present ? date.value : this.date,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('gemstone: $gemstone, ')
          ..write('repeat: $repeat, ')
          ..write('status: $status, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isContinue: $isContinue, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, gemstone, repeat, status, isCompleted, isContinue, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.gemstone == this.gemstone &&
          other.repeat == this.repeat &&
          other.status == this.status &&
          other.isCompleted == this.isCompleted &&
          other.isContinue == this.isContinue &&
          other.date == this.date);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> gemstone;
  final Value<String?> repeat;
  final Value<bool> status;
  final Value<bool> isCompleted;
  final Value<bool> isContinue;
  final Value<DateTime?> date;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.gemstone = const Value.absent(),
    this.repeat = const Value.absent(),
    this.status = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isContinue = const Value.absent(),
    this.date = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.gemstone = const Value.absent(),
    this.repeat = const Value.absent(),
    this.status = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isContinue = const Value.absent(),
    this.date = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? gemstone,
    Expression<String>? repeat,
    Expression<bool>? status,
    Expression<bool>? isCompleted,
    Expression<bool>? isContinue,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (gemstone != null) 'gemstone': gemstone,
      if (repeat != null) 'repeat': repeat,
      if (status != null) 'status': status,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isContinue != null) 'is_continue': isContinue,
      if (date != null) 'date': date,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? gemstone,
      Value<String?>? repeat,
      Value<bool>? status,
      Value<bool>? isCompleted,
      Value<bool>? isContinue,
      Value<DateTime?>? date}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      gemstone: gemstone ?? this.gemstone,
      repeat: repeat ?? this.repeat,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      isContinue: isContinue ?? this.isContinue,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (gemstone.present) {
      map['gemstone'] = Variable<String>(gemstone.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isContinue.present) {
      map['is_continue'] = Variable<bool>(isContinue.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('gemstone: $gemstone, ')
          ..write('repeat: $repeat, ')
          ..write('status: $status, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isContinue: $isContinue, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $TodosTable todos = $TodosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todos];
}
