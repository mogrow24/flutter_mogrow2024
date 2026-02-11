// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $InstallInfosTable extends InstallInfos
    with TableInfo<$InstallInfosTable, InstallInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _installDateMeta =
      const VerificationMeta('installDate');
  @override
  late final GeneratedColumn<DateTime> installDate = GeneratedColumn<DateTime>(
      'install_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, installDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'InstallInfos';
  @override
  VerificationContext validateIntegrity(Insertable<InstallInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('install_date')) {
      context.handle(
          _installDateMeta,
          installDate.isAcceptableOrUnknown(
              data['install_date']!, _installDateMeta));
    } else if (isInserting) {
      context.missing(_installDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      installDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}install_date'])!,
    );
  }

  @override
  $InstallInfosTable createAlias(String alias) {
    return $InstallInfosTable(attachedDatabase, alias);
  }
}

class InstallInfo extends DataClass implements Insertable<InstallInfo> {
  final int id;
  final DateTime installDate;
  const InstallInfo({required this.id, required this.installDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['install_date'] = Variable<DateTime>(installDate);
    return map;
  }

  InstallInfosCompanion toCompanion(bool nullToAbsent) {
    return InstallInfosCompanion(
      id: Value(id),
      installDate: Value(installDate),
    );
  }

  factory InstallInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallInfo(
      id: serializer.fromJson<int>(json['id']),
      installDate: serializer.fromJson<DateTime>(json['installDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'installDate': serializer.toJson<DateTime>(installDate),
    };
  }

  InstallInfo copyWith({int? id, DateTime? installDate}) => InstallInfo(
        id: id ?? this.id,
        installDate: installDate ?? this.installDate,
      );
  @override
  String toString() {
    return (StringBuffer('InstallInfo(')
          ..write('id: $id, ')
          ..write('installDate: $installDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, installDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallInfo &&
          other.id == this.id &&
          other.installDate == this.installDate);
}

class InstallInfosCompanion extends UpdateCompanion<InstallInfo> {
  final Value<int> id;
  final Value<DateTime> installDate;
  const InstallInfosCompanion({
    this.id = const Value.absent(),
    this.installDate = const Value.absent(),
  });
  InstallInfosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime installDate,
  }) : installDate = Value(installDate);
  static Insertable<InstallInfo> custom({
    Expression<int>? id,
    Expression<DateTime>? installDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (installDate != null) 'install_date': installDate,
    });
  }

  InstallInfosCompanion copyWith(
      {Value<int>? id, Value<DateTime>? installDate}) {
    return InstallInfosCompanion(
      id: id ?? this.id,
      installDate: installDate ?? this.installDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (installDate.present) {
      map['install_date'] = Variable<DateTime>(installDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallInfosCompanion(')
          ..write('id: $id, ')
          ..write('installDate: $installDate')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subTitleMeta =
      const VerificationMeta('subTitle');
  @override
  late final GeneratedColumn<String> subTitle = GeneratedColumn<String>(
      'sub_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gemstoneMeta =
      const VerificationMeta('gemstone');
  @override
  late final GeneratedColumn<String> gemstone = GeneratedColumn<String>(
      'gemstone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateDivMeta =
      const VerificationMeta('dateDiv');
  @override
  late final GeneratedColumn<String> dateDiv = GeneratedColumn<String>(
      'date_div', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
      'desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<bool> status = GeneratedColumn<bool>(
      'status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("status" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _selectedMoodMeta =
      const VerificationMeta('selectedMood');
  @override
  late final GeneratedColumn<String> selectedMood = GeneratedColumn<String>(
      'selected_mood', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<DateTime> createDate = GeneratedColumn<DateTime>(
      'create_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        goalId,
        title,
        subTitle,
        gemstone,
        dateDiv,
        startDate,
        endDate,
        desc,
        reason,
        isCompleted,
        status,
        selectedMood,
        createDate,
        updateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sub_title')) {
      context.handle(_subTitleMeta,
          subTitle.isAcceptableOrUnknown(data['sub_title']!, _subTitleMeta));
    }
    if (data.containsKey('gemstone')) {
      context.handle(_gemstoneMeta,
          gemstone.isAcceptableOrUnknown(data['gemstone']!, _gemstoneMeta));
    } else if (isInserting) {
      context.missing(_gemstoneMeta);
    }
    if (data.containsKey('date_div')) {
      context.handle(_dateDivMeta,
          dateDiv.isAcceptableOrUnknown(data['date_div']!, _dateDivMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('desc')) {
      context.handle(
          _descMeta, desc.isAcceptableOrUnknown(data['desc']!, _descMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('selected_mood')) {
      context.handle(
          _selectedMoodMeta,
          selectedMood.isAcceptableOrUnknown(
              data['selected_mood']!, _selectedMoodMeta));
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      subTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sub_title']),
      gemstone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gemstone'])!,
      dateDiv: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_div']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      desc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status'])!,
      selectedMood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}selected_mood']),
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_date']),
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date']),
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String goalId;
  final String title;
  final String? subTitle;
  final String gemstone;
  final String? dateDiv;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? desc;
  final String? reason;
  final bool isCompleted;
  final bool status;
  final String? selectedMood;
  final DateTime? createDate;
  final DateTime? updateDate;
  const Goal(
      {required this.goalId,
      required this.title,
      this.subTitle,
      required this.gemstone,
      this.dateDiv,
      this.startDate,
      this.endDate,
      this.desc,
      this.reason,
      required this.isCompleted,
      required this.status,
      this.selectedMood,
      this.createDate,
      this.updateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goal_id'] = Variable<String>(goalId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subTitle != null) {
      map['sub_title'] = Variable<String>(subTitle);
    }
    map['gemstone'] = Variable<String>(gemstone);
    if (!nullToAbsent || dateDiv != null) {
      map['date_div'] = Variable<String>(dateDiv);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || desc != null) {
      map['desc'] = Variable<String>(desc);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['status'] = Variable<bool>(status);
    if (!nullToAbsent || selectedMood != null) {
      map['selected_mood'] = Variable<String>(selectedMood);
    }
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<DateTime>(createDate);
    }
    if (!nullToAbsent || updateDate != null) {
      map['update_date'] = Variable<DateTime>(updateDate);
    }
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      goalId: Value(goalId),
      title: Value(title),
      subTitle: subTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subTitle),
      gemstone: Value(gemstone),
      dateDiv: dateDiv == null && nullToAbsent
          ? const Value.absent()
          : Value(dateDiv),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      desc: desc == null && nullToAbsent ? const Value.absent() : Value(desc),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      isCompleted: Value(isCompleted),
      status: Value(status),
      selectedMood: selectedMood == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedMood),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
      updateDate: updateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(updateDate),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      goalId: serializer.fromJson<String>(json['goalId']),
      title: serializer.fromJson<String>(json['title']),
      subTitle: serializer.fromJson<String?>(json['subTitle']),
      gemstone: serializer.fromJson<String>(json['gemstone']),
      dateDiv: serializer.fromJson<String?>(json['dateDiv']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      desc: serializer.fromJson<String?>(json['desc']),
      reason: serializer.fromJson<String?>(json['reason']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      status: serializer.fromJson<bool>(json['status']),
      selectedMood: serializer.fromJson<String?>(json['selectedMood']),
      createDate: serializer.fromJson<DateTime?>(json['createDate']),
      updateDate: serializer.fromJson<DateTime?>(json['updateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<String>(goalId),
      'title': serializer.toJson<String>(title),
      'subTitle': serializer.toJson<String?>(subTitle),
      'gemstone': serializer.toJson<String>(gemstone),
      'dateDiv': serializer.toJson<String?>(dateDiv),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'desc': serializer.toJson<String?>(desc),
      'reason': serializer.toJson<String?>(reason),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'status': serializer.toJson<bool>(status),
      'selectedMood': serializer.toJson<String?>(selectedMood),
      'createDate': serializer.toJson<DateTime?>(createDate),
      'updateDate': serializer.toJson<DateTime?>(updateDate),
    };
  }

  Goal copyWith(
          {String? goalId,
          String? title,
          Value<String?> subTitle = const Value.absent(),
          String? gemstone,
          Value<String?> dateDiv = const Value.absent(),
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<String?> desc = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          bool? isCompleted,
          bool? status,
          Value<String?> selectedMood = const Value.absent(),
          Value<DateTime?> createDate = const Value.absent(),
          Value<DateTime?> updateDate = const Value.absent()}) =>
      Goal(
        goalId: goalId ?? this.goalId,
        title: title ?? this.title,
        subTitle: subTitle.present ? subTitle.value : this.subTitle,
        gemstone: gemstone ?? this.gemstone,
        dateDiv: dateDiv.present ? dateDiv.value : this.dateDiv,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        desc: desc.present ? desc.value : this.desc,
        reason: reason.present ? reason.value : this.reason,
        isCompleted: isCompleted ?? this.isCompleted,
        status: status ?? this.status,
        selectedMood:
            selectedMood.present ? selectedMood.value : this.selectedMood,
        createDate: createDate.present ? createDate.value : this.createDate,
        updateDate: updateDate.present ? updateDate.value : this.updateDate,
      );
  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('subTitle: $subTitle, ')
          ..write('gemstone: $gemstone, ')
          ..write('dateDiv: $dateDiv, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('desc: $desc, ')
          ..write('reason: $reason, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('selectedMood: $selectedMood, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      goalId,
      title,
      subTitle,
      gemstone,
      dateDiv,
      startDate,
      endDate,
      desc,
      reason,
      isCompleted,
      status,
      selectedMood,
      createDate,
      updateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.goalId == this.goalId &&
          other.title == this.title &&
          other.subTitle == this.subTitle &&
          other.gemstone == this.gemstone &&
          other.dateDiv == this.dateDiv &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.desc == this.desc &&
          other.reason == this.reason &&
          other.isCompleted == this.isCompleted &&
          other.status == this.status &&
          other.selectedMood == this.selectedMood &&
          other.createDate == this.createDate &&
          other.updateDate == this.updateDate);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> goalId;
  final Value<String> title;
  final Value<String?> subTitle;
  final Value<String> gemstone;
  final Value<String?> dateDiv;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> desc;
  final Value<String?> reason;
  final Value<bool> isCompleted;
  final Value<bool> status;
  final Value<String?> selectedMood;
  final Value<DateTime?> createDate;
  final Value<DateTime?> updateDate;
  final Value<int> rowid;
  const GoalsCompanion({
    this.goalId = const Value.absent(),
    this.title = const Value.absent(),
    this.subTitle = const Value.absent(),
    this.gemstone = const Value.absent(),
    this.dateDiv = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.desc = const Value.absent(),
    this.reason = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.selectedMood = const Value.absent(),
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String goalId,
    required String title,
    this.subTitle = const Value.absent(),
    required String gemstone,
    this.dateDiv = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.desc = const Value.absent(),
    this.reason = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.selectedMood = const Value.absent(),
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : goalId = Value(goalId),
        title = Value(title),
        gemstone = Value(gemstone);
  static Insertable<Goal> custom({
    Expression<String>? goalId,
    Expression<String>? title,
    Expression<String>? subTitle,
    Expression<String>? gemstone,
    Expression<String>? dateDiv,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? desc,
    Expression<String>? reason,
    Expression<bool>? isCompleted,
    Expression<bool>? status,
    Expression<String>? selectedMood,
    Expression<DateTime>? createDate,
    Expression<DateTime>? updateDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (title != null) 'title': title,
      if (subTitle != null) 'sub_title': subTitle,
      if (gemstone != null) 'gemstone': gemstone,
      if (dateDiv != null) 'date_div': dateDiv,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (desc != null) 'desc': desc,
      if (reason != null) 'reason': reason,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (status != null) 'status': status,
      if (selectedMood != null) 'selected_mood': selectedMood,
      if (createDate != null) 'create_date': createDate,
      if (updateDate != null) 'update_date': updateDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? goalId,
      Value<String>? title,
      Value<String?>? subTitle,
      Value<String>? gemstone,
      Value<String?>? dateDiv,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<String?>? desc,
      Value<String?>? reason,
      Value<bool>? isCompleted,
      Value<bool>? status,
      Value<String?>? selectedMood,
      Value<DateTime?>? createDate,
      Value<DateTime?>? updateDate,
      Value<int>? rowid}) {
    return GoalsCompanion(
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      gemstone: gemstone ?? this.gemstone,
      dateDiv: dateDiv ?? this.dateDiv,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      desc: desc ?? this.desc,
      reason: reason ?? this.reason,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      selectedMood: selectedMood ?? this.selectedMood,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subTitle.present) {
      map['sub_title'] = Variable<String>(subTitle.value);
    }
    if (gemstone.present) {
      map['gemstone'] = Variable<String>(gemstone.value);
    }
    if (dateDiv.present) {
      map['date_div'] = Variable<String>(dateDiv.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (selectedMood.present) {
      map['selected_mood'] = Variable<String>(selectedMood.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<DateTime>(createDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('subTitle: $subTitle, ')
          ..write('gemstone: $gemstone, ')
          ..write('dateDiv: $dateDiv, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('desc: $desc, ')
          ..write('reason: $reason, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('selectedMood: $selectedMood, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gemstoneMeta =
      const VerificationMeta('gemstone');
  @override
  late final GeneratedColumn<String> gemstone = GeneratedColumn<String>(
      'gemstone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goalTitleMeta =
      const VerificationMeta('goalTitle');
  @override
  late final GeneratedColumn<String> goalTitle = GeneratedColumn<String>(
      'goal_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
      'repeat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatCodeMeta =
      const VerificationMeta('repeatCode');
  @override
  late final GeneratedColumn<String> repeatCode = GeneratedColumn<String>(
      'repeat_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatGroupIdMeta =
      const VerificationMeta('repeatGroupId');
  @override
  late final GeneratedColumn<String> repeatGroupId = GeneratedColumn<String>(
      'repeat_group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatStartDateMeta =
      const VerificationMeta('repeatStartDate');
  @override
  late final GeneratedColumn<DateTime> repeatStartDate =
      GeneratedColumn<DateTime>('repeat_start_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _repeatEndDateMeta =
      const VerificationMeta('repeatEndDate');
  @override
  late final GeneratedColumn<DateTime> repeatEndDate =
      GeneratedColumn<DateTime>('repeat_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<DateTime> createDate = GeneratedColumn<DateTime>(
      'create_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES goals(goal_id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        gemstone,
        goalTitle,
        repeat,
        repeatCode,
        repeatGroupId,
        repeatStartDate,
        repeatEndDate,
        status,
        isCompleted,
        isContinue,
        date,
        createDate,
        updateDate,
        goalId
      ];
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
    } else if (isInserting) {
      context.missing(_gemstoneMeta);
    }
    if (data.containsKey('goal_title')) {
      context.handle(_goalTitleMeta,
          goalTitle.isAcceptableOrUnknown(data['goal_title']!, _goalTitleMeta));
    } else if (isInserting) {
      context.missing(_goalTitleMeta);
    }
    if (data.containsKey('repeat')) {
      context.handle(_repeatMeta,
          repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta));
    }
    if (data.containsKey('repeat_code')) {
      context.handle(
          _repeatCodeMeta,
          repeatCode.isAcceptableOrUnknown(
              data['repeat_code']!, _repeatCodeMeta));
    }
    if (data.containsKey('repeat_group_id')) {
      context.handle(
          _repeatGroupIdMeta,
          repeatGroupId.isAcceptableOrUnknown(
              data['repeat_group_id']!, _repeatGroupIdMeta));
    }
    if (data.containsKey('repeat_start_date')) {
      context.handle(
          _repeatStartDateMeta,
          repeatStartDate.isAcceptableOrUnknown(
              data['repeat_start_date']!, _repeatStartDateMeta));
    }
    if (data.containsKey('repeat_end_date')) {
      context.handle(
          _repeatEndDateMeta,
          repeatEndDate.isAcceptableOrUnknown(
              data['repeat_end_date']!, _repeatEndDateMeta));
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
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      gemstone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gemstone'])!,
      goalTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_title'])!,
      repeat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat']),
      repeatCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_code']),
      repeatGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat_group_id']),
      repeatStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}repeat_start_date']),
      repeatEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}repeat_end_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isContinue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_continue'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_date']),
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date']),
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final String id;
  final String title;
  final String gemstone;
  final String goalTitle;
  final String? repeat;
  final String? repeatCode;
  final String? repeatGroupId;
  final DateTime? repeatStartDate;
  final DateTime? repeatEndDate;
  final bool status;
  final bool isCompleted;
  final bool isContinue;
  final DateTime? date;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String goalId;
  const Todo(
      {required this.id,
      required this.title,
      required this.gemstone,
      required this.goalTitle,
      this.repeat,
      this.repeatCode,
      this.repeatGroupId,
      this.repeatStartDate,
      this.repeatEndDate,
      required this.status,
      required this.isCompleted,
      required this.isContinue,
      this.date,
      this.createDate,
      this.updateDate,
      required this.goalId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['gemstone'] = Variable<String>(gemstone);
    map['goal_title'] = Variable<String>(goalTitle);
    if (!nullToAbsent || repeat != null) {
      map['repeat'] = Variable<String>(repeat);
    }
    if (!nullToAbsent || repeatCode != null) {
      map['repeat_code'] = Variable<String>(repeatCode);
    }
    if (!nullToAbsent || repeatGroupId != null) {
      map['repeat_group_id'] = Variable<String>(repeatGroupId);
    }
    if (!nullToAbsent || repeatStartDate != null) {
      map['repeat_start_date'] = Variable<DateTime>(repeatStartDate);
    }
    if (!nullToAbsent || repeatEndDate != null) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate);
    }
    map['status'] = Variable<bool>(status);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_continue'] = Variable<bool>(isContinue);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<DateTime>(createDate);
    }
    if (!nullToAbsent || updateDate != null) {
      map['update_date'] = Variable<DateTime>(updateDate);
    }
    map['goal_id'] = Variable<String>(goalId);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      gemstone: Value(gemstone),
      goalTitle: Value(goalTitle),
      repeat:
          repeat == null && nullToAbsent ? const Value.absent() : Value(repeat),
      repeatCode: repeatCode == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatCode),
      repeatGroupId: repeatGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatGroupId),
      repeatStartDate: repeatStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatStartDate),
      repeatEndDate: repeatEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEndDate),
      status: Value(status),
      isCompleted: Value(isCompleted),
      isContinue: Value(isContinue),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
      updateDate: updateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(updateDate),
      goalId: Value(goalId),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      gemstone: serializer.fromJson<String>(json['gemstone']),
      goalTitle: serializer.fromJson<String>(json['goalTitle']),
      repeat: serializer.fromJson<String?>(json['repeat']),
      repeatCode: serializer.fromJson<String?>(json['repeatCode']),
      repeatGroupId: serializer.fromJson<String?>(json['repeatGroupId']),
      repeatStartDate: serializer.fromJson<DateTime?>(json['repeatStartDate']),
      repeatEndDate: serializer.fromJson<DateTime?>(json['repeatEndDate']),
      status: serializer.fromJson<bool>(json['status']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isContinue: serializer.fromJson<bool>(json['isContinue']),
      date: serializer.fromJson<DateTime?>(json['date']),
      createDate: serializer.fromJson<DateTime?>(json['createDate']),
      updateDate: serializer.fromJson<DateTime?>(json['updateDate']),
      goalId: serializer.fromJson<String>(json['goalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'gemstone': serializer.toJson<String>(gemstone),
      'goalTitle': serializer.toJson<String>(goalTitle),
      'repeat': serializer.toJson<String?>(repeat),
      'repeatCode': serializer.toJson<String?>(repeatCode),
      'repeatGroupId': serializer.toJson<String?>(repeatGroupId),
      'repeatStartDate': serializer.toJson<DateTime?>(repeatStartDate),
      'repeatEndDate': serializer.toJson<DateTime?>(repeatEndDate),
      'status': serializer.toJson<bool>(status),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isContinue': serializer.toJson<bool>(isContinue),
      'date': serializer.toJson<DateTime?>(date),
      'createDate': serializer.toJson<DateTime?>(createDate),
      'updateDate': serializer.toJson<DateTime?>(updateDate),
      'goalId': serializer.toJson<String>(goalId),
    };
  }

  Todo copyWith(
          {String? id,
          String? title,
          String? gemstone,
          String? goalTitle,
          Value<String?> repeat = const Value.absent(),
          Value<String?> repeatCode = const Value.absent(),
          Value<String?> repeatGroupId = const Value.absent(),
          Value<DateTime?> repeatStartDate = const Value.absent(),
          Value<DateTime?> repeatEndDate = const Value.absent(),
          bool? status,
          bool? isCompleted,
          bool? isContinue,
          Value<DateTime?> date = const Value.absent(),
          Value<DateTime?> createDate = const Value.absent(),
          Value<DateTime?> updateDate = const Value.absent(),
          String? goalId}) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        gemstone: gemstone ?? this.gemstone,
        goalTitle: goalTitle ?? this.goalTitle,
        repeat: repeat.present ? repeat.value : this.repeat,
        repeatCode: repeatCode.present ? repeatCode.value : this.repeatCode,
        repeatGroupId:
            repeatGroupId.present ? repeatGroupId.value : this.repeatGroupId,
        repeatStartDate: repeatStartDate.present
            ? repeatStartDate.value
            : this.repeatStartDate,
        repeatEndDate:
            repeatEndDate.present ? repeatEndDate.value : this.repeatEndDate,
        status: status ?? this.status,
        isCompleted: isCompleted ?? this.isCompleted,
        isContinue: isContinue ?? this.isContinue,
        date: date.present ? date.value : this.date,
        createDate: createDate.present ? createDate.value : this.createDate,
        updateDate: updateDate.present ? updateDate.value : this.updateDate,
        goalId: goalId ?? this.goalId,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('gemstone: $gemstone, ')
          ..write('goalTitle: $goalTitle, ')
          ..write('repeat: $repeat, ')
          ..write('repeatCode: $repeatCode, ')
          ..write('repeatGroupId: $repeatGroupId, ')
          ..write('repeatStartDate: $repeatStartDate, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('status: $status, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isContinue: $isContinue, ')
          ..write('date: $date, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('goalId: $goalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      gemstone,
      goalTitle,
      repeat,
      repeatCode,
      repeatGroupId,
      repeatStartDate,
      repeatEndDate,
      status,
      isCompleted,
      isContinue,
      date,
      createDate,
      updateDate,
      goalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.gemstone == this.gemstone &&
          other.goalTitle == this.goalTitle &&
          other.repeat == this.repeat &&
          other.repeatCode == this.repeatCode &&
          other.repeatGroupId == this.repeatGroupId &&
          other.repeatStartDate == this.repeatStartDate &&
          other.repeatEndDate == this.repeatEndDate &&
          other.status == this.status &&
          other.isCompleted == this.isCompleted &&
          other.isContinue == this.isContinue &&
          other.date == this.date &&
          other.createDate == this.createDate &&
          other.updateDate == this.updateDate &&
          other.goalId == this.goalId);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> gemstone;
  final Value<String> goalTitle;
  final Value<String?> repeat;
  final Value<String?> repeatCode;
  final Value<String?> repeatGroupId;
  final Value<DateTime?> repeatStartDate;
  final Value<DateTime?> repeatEndDate;
  final Value<bool> status;
  final Value<bool> isCompleted;
  final Value<bool> isContinue;
  final Value<DateTime?> date;
  final Value<DateTime?> createDate;
  final Value<DateTime?> updateDate;
  final Value<String> goalId;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.gemstone = const Value.absent(),
    this.goalTitle = const Value.absent(),
    this.repeat = const Value.absent(),
    this.repeatCode = const Value.absent(),
    this.repeatGroupId = const Value.absent(),
    this.repeatStartDate = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isContinue = const Value.absent(),
    this.date = const Value.absent(),
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.goalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    required String title,
    required String gemstone,
    required String goalTitle,
    this.repeat = const Value.absent(),
    this.repeatCode = const Value.absent(),
    this.repeatGroupId = const Value.absent(),
    this.repeatStartDate = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.status = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isContinue = const Value.absent(),
    this.date = const Value.absent(),
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    required String goalId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        gemstone = Value(gemstone),
        goalTitle = Value(goalTitle),
        goalId = Value(goalId);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? gemstone,
    Expression<String>? goalTitle,
    Expression<String>? repeat,
    Expression<String>? repeatCode,
    Expression<String>? repeatGroupId,
    Expression<DateTime>? repeatStartDate,
    Expression<DateTime>? repeatEndDate,
    Expression<bool>? status,
    Expression<bool>? isCompleted,
    Expression<bool>? isContinue,
    Expression<DateTime>? date,
    Expression<DateTime>? createDate,
    Expression<DateTime>? updateDate,
    Expression<String>? goalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (gemstone != null) 'gemstone': gemstone,
      if (goalTitle != null) 'goal_title': goalTitle,
      if (repeat != null) 'repeat': repeat,
      if (repeatCode != null) 'repeat_code': repeatCode,
      if (repeatGroupId != null) 'repeat_group_id': repeatGroupId,
      if (repeatStartDate != null) 'repeat_start_date': repeatStartDate,
      if (repeatEndDate != null) 'repeat_end_date': repeatEndDate,
      if (status != null) 'status': status,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isContinue != null) 'is_continue': isContinue,
      if (date != null) 'date': date,
      if (createDate != null) 'create_date': createDate,
      if (updateDate != null) 'update_date': updateDate,
      if (goalId != null) 'goal_id': goalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? gemstone,
      Value<String>? goalTitle,
      Value<String?>? repeat,
      Value<String?>? repeatCode,
      Value<String?>? repeatGroupId,
      Value<DateTime?>? repeatStartDate,
      Value<DateTime?>? repeatEndDate,
      Value<bool>? status,
      Value<bool>? isCompleted,
      Value<bool>? isContinue,
      Value<DateTime?>? date,
      Value<DateTime?>? createDate,
      Value<DateTime?>? updateDate,
      Value<String>? goalId,
      Value<int>? rowid}) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      gemstone: gemstone ?? this.gemstone,
      goalTitle: goalTitle ?? this.goalTitle,
      repeat: repeat ?? this.repeat,
      repeatCode: repeatCode ?? this.repeatCode,
      repeatGroupId: repeatGroupId ?? this.repeatGroupId,
      repeatStartDate: repeatStartDate ?? this.repeatStartDate,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      isContinue: isContinue ?? this.isContinue,
      date: date ?? this.date,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      goalId: goalId ?? this.goalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (gemstone.present) {
      map['gemstone'] = Variable<String>(gemstone.value);
    }
    if (goalTitle.present) {
      map['goal_title'] = Variable<String>(goalTitle.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (repeatCode.present) {
      map['repeat_code'] = Variable<String>(repeatCode.value);
    }
    if (repeatGroupId.present) {
      map['repeat_group_id'] = Variable<String>(repeatGroupId.value);
    }
    if (repeatStartDate.present) {
      map['repeat_start_date'] = Variable<DateTime>(repeatStartDate.value);
    }
    if (repeatEndDate.present) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate.value);
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
    if (createDate.present) {
      map['create_date'] = Variable<DateTime>(createDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('gemstone: $gemstone, ')
          ..write('goalTitle: $goalTitle, ')
          ..write('repeat: $repeat, ')
          ..write('repeatCode: $repeatCode, ')
          ..write('repeatGroupId: $repeatGroupId, ')
          ..write('repeatStartDate: $repeatStartDate, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('status: $status, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isContinue: $isContinue, ')
          ..write('date: $date, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('goalId: $goalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _surveyMoodMeta =
      const VerificationMeta('surveyMood');
  @override
  late final GeneratedColumn<String> surveyMood = GeneratedColumn<String>(
      'survey_mood', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _surveyCommentMeta =
      const VerificationMeta('surveyComment');
  @override
  late final GeneratedColumn<String> surveyComment = GeneratedColumn<String>(
      'survey_comment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<bool> status = GeneratedColumn<bool>(
      'status', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("status" IN (0, 1))'),
      defaultValue: Constant(false));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<DateTime> createDate = GeneratedColumn<DateTime>(
      'create_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updateDateMeta =
      const VerificationMeta('updateDate');
  @override
  late final GeneratedColumn<DateTime> updateDate = GeneratedColumn<DateTime>(
      'update_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
      'goal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES goals(goal_id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [
        recordId,
        surveyMood,
        surveyComment,
        status,
        date,
        createDate,
        updateDate,
        goalId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(Insertable<Record> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('survey_mood')) {
      context.handle(
          _surveyMoodMeta,
          surveyMood.isAcceptableOrUnknown(
              data['survey_mood']!, _surveyMoodMeta));
    } else if (isInserting) {
      context.missing(_surveyMoodMeta);
    }
    if (data.containsKey('survey_comment')) {
      context.handle(
          _surveyCommentMeta,
          surveyComment.isAcceptableOrUnknown(
              data['survey_comment']!, _surveyCommentMeta));
    } else if (isInserting) {
      context.missing(_surveyCommentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    if (data.containsKey('update_date')) {
      context.handle(
          _updateDateMeta,
          updateDate.isAcceptableOrUnknown(
              data['update_date']!, _updateDateMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta,
          goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Record map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Record(
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      surveyMood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}survey_mood'])!,
      surveyComment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}survey_comment'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}status'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_date']),
      updateDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_date']),
      goalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_id'])!,
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class Record extends DataClass implements Insertable<Record> {
  final String recordId;
  final String surveyMood;
  final String surveyComment;
  final bool status;
  final DateTime date;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String goalId;
  const Record(
      {required this.recordId,
      required this.surveyMood,
      required this.surveyComment,
      required this.status,
      required this.date,
      this.createDate,
      this.updateDate,
      required this.goalId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_id'] = Variable<String>(recordId);
    map['survey_mood'] = Variable<String>(surveyMood);
    map['survey_comment'] = Variable<String>(surveyComment);
    map['status'] = Variable<bool>(status);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<DateTime>(createDate);
    }
    if (!nullToAbsent || updateDate != null) {
      map['update_date'] = Variable<DateTime>(updateDate);
    }
    map['goal_id'] = Variable<String>(goalId);
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      recordId: Value(recordId),
      surveyMood: Value(surveyMood),
      surveyComment: Value(surveyComment),
      status: Value(status),
      date: Value(date),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
      updateDate: updateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(updateDate),
      goalId: Value(goalId),
    );
  }

  factory Record.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Record(
      recordId: serializer.fromJson<String>(json['recordId']),
      surveyMood: serializer.fromJson<String>(json['surveyMood']),
      surveyComment: serializer.fromJson<String>(json['surveyComment']),
      status: serializer.fromJson<bool>(json['status']),
      date: serializer.fromJson<DateTime>(json['date']),
      createDate: serializer.fromJson<DateTime?>(json['createDate']),
      updateDate: serializer.fromJson<DateTime?>(json['updateDate']),
      goalId: serializer.fromJson<String>(json['goalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordId': serializer.toJson<String>(recordId),
      'surveyMood': serializer.toJson<String>(surveyMood),
      'surveyComment': serializer.toJson<String>(surveyComment),
      'status': serializer.toJson<bool>(status),
      'date': serializer.toJson<DateTime>(date),
      'createDate': serializer.toJson<DateTime?>(createDate),
      'updateDate': serializer.toJson<DateTime?>(updateDate),
      'goalId': serializer.toJson<String>(goalId),
    };
  }

  Record copyWith(
          {String? recordId,
          String? surveyMood,
          String? surveyComment,
          bool? status,
          DateTime? date,
          Value<DateTime?> createDate = const Value.absent(),
          Value<DateTime?> updateDate = const Value.absent(),
          String? goalId}) =>
      Record(
        recordId: recordId ?? this.recordId,
        surveyMood: surveyMood ?? this.surveyMood,
        surveyComment: surveyComment ?? this.surveyComment,
        status: status ?? this.status,
        date: date ?? this.date,
        createDate: createDate.present ? createDate.value : this.createDate,
        updateDate: updateDate.present ? updateDate.value : this.updateDate,
        goalId: goalId ?? this.goalId,
      );
  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('recordId: $recordId, ')
          ..write('surveyMood: $surveyMood, ')
          ..write('surveyComment: $surveyComment, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('goalId: $goalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordId, surveyMood, surveyComment, status,
      date, createDate, updateDate, goalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Record &&
          other.recordId == this.recordId &&
          other.surveyMood == this.surveyMood &&
          other.surveyComment == this.surveyComment &&
          other.status == this.status &&
          other.date == this.date &&
          other.createDate == this.createDate &&
          other.updateDate == this.updateDate &&
          other.goalId == this.goalId);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<String> recordId;
  final Value<String> surveyMood;
  final Value<String> surveyComment;
  final Value<bool> status;
  final Value<DateTime> date;
  final Value<DateTime?> createDate;
  final Value<DateTime?> updateDate;
  final Value<String> goalId;
  final Value<int> rowid;
  const RecordsCompanion({
    this.recordId = const Value.absent(),
    this.surveyMood = const Value.absent(),
    this.surveyComment = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    this.goalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsCompanion.insert({
    required String recordId,
    required String surveyMood,
    required String surveyComment,
    this.status = const Value.absent(),
    required DateTime date,
    this.createDate = const Value.absent(),
    this.updateDate = const Value.absent(),
    required String goalId,
    this.rowid = const Value.absent(),
  })  : recordId = Value(recordId),
        surveyMood = Value(surveyMood),
        surveyComment = Value(surveyComment),
        date = Value(date),
        goalId = Value(goalId);
  static Insertable<Record> custom({
    Expression<String>? recordId,
    Expression<String>? surveyMood,
    Expression<String>? surveyComment,
    Expression<bool>? status,
    Expression<DateTime>? date,
    Expression<DateTime>? createDate,
    Expression<DateTime>? updateDate,
    Expression<String>? goalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordId != null) 'record_id': recordId,
      if (surveyMood != null) 'survey_mood': surveyMood,
      if (surveyComment != null) 'survey_comment': surveyComment,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (createDate != null) 'create_date': createDate,
      if (updateDate != null) 'update_date': updateDate,
      if (goalId != null) 'goal_id': goalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsCompanion copyWith(
      {Value<String>? recordId,
      Value<String>? surveyMood,
      Value<String>? surveyComment,
      Value<bool>? status,
      Value<DateTime>? date,
      Value<DateTime?>? createDate,
      Value<DateTime?>? updateDate,
      Value<String>? goalId,
      Value<int>? rowid}) {
    return RecordsCompanion(
      recordId: recordId ?? this.recordId,
      surveyMood: surveyMood ?? this.surveyMood,
      surveyComment: surveyComment ?? this.surveyComment,
      status: status ?? this.status,
      date: date ?? this.date,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      goalId: goalId ?? this.goalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (surveyMood.present) {
      map['survey_mood'] = Variable<String>(surveyMood.value);
    }
    if (surveyComment.present) {
      map['survey_comment'] = Variable<String>(surveyComment.value);
    }
    if (status.present) {
      map['status'] = Variable<bool>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<DateTime>(createDate.value);
    }
    if (updateDate.present) {
      map['update_date'] = Variable<DateTime>(updateDate.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('recordId: $recordId, ')
          ..write('surveyMood: $surveyMood, ')
          ..write('surveyComment: $surveyComment, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('createDate: $createDate, ')
          ..write('updateDate: $updateDate, ')
          ..write('goalId: $goalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsImagesTable extends RecordsImages
    with TableInfo<$RecordsImagesTable, RecordsImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES records(record_id) ON DELETE CASCADE');
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assetEntityIdMeta =
      const VerificationMeta('assetEntityId');
  @override
  late final GeneratedColumn<String> assetEntityId = GeneratedColumn<String>(
      'asset_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createDateMeta =
      const VerificationMeta('createDate');
  @override
  late final GeneratedColumn<DateTime> createDate = GeneratedColumn<DateTime>(
      'create_date', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordId, path, assetEntityId, createDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'RecordsImages';
  @override
  VerificationContext validateIntegrity(Insertable<RecordsImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('asset_entity_id')) {
      context.handle(
          _assetEntityIdMeta,
          assetEntityId.isAcceptableOrUnknown(
              data['asset_entity_id']!, _assetEntityIdMeta));
    } else if (isInserting) {
      context.missing(_assetEntityIdMeta);
    }
    if (data.containsKey('create_date')) {
      context.handle(
          _createDateMeta,
          createDate.isAcceptableOrUnknown(
              data['create_date']!, _createDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordsImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordsImage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      assetEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}asset_entity_id'])!,
      createDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_date']),
    );
  }

  @override
  $RecordsImagesTable createAlias(String alias) {
    return $RecordsImagesTable(attachedDatabase, alias);
  }
}

class RecordsImage extends DataClass implements Insertable<RecordsImage> {
  final int id;
  final String recordId;
  final String path;
  final String assetEntityId;
  final DateTime? createDate;
  const RecordsImage(
      {required this.id,
      required this.recordId,
      required this.path,
      required this.assetEntityId,
      this.createDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<String>(recordId);
    map['path'] = Variable<String>(path);
    map['asset_entity_id'] = Variable<String>(assetEntityId);
    if (!nullToAbsent || createDate != null) {
      map['create_date'] = Variable<DateTime>(createDate);
    }
    return map;
  }

  RecordsImagesCompanion toCompanion(bool nullToAbsent) {
    return RecordsImagesCompanion(
      id: Value(id),
      recordId: Value(recordId),
      path: Value(path),
      assetEntityId: Value(assetEntityId),
      createDate: createDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createDate),
    );
  }

  factory RecordsImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordsImage(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      path: serializer.fromJson<String>(json['path']),
      assetEntityId: serializer.fromJson<String>(json['assetEntityId']),
      createDate: serializer.fromJson<DateTime?>(json['createDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<String>(recordId),
      'path': serializer.toJson<String>(path),
      'assetEntityId': serializer.toJson<String>(assetEntityId),
      'createDate': serializer.toJson<DateTime?>(createDate),
    };
  }

  RecordsImage copyWith(
          {int? id,
          String? recordId,
          String? path,
          String? assetEntityId,
          Value<DateTime?> createDate = const Value.absent()}) =>
      RecordsImage(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        path: path ?? this.path,
        assetEntityId: assetEntityId ?? this.assetEntityId,
        createDate: createDate.present ? createDate.value : this.createDate,
      );
  @override
  String toString() {
    return (StringBuffer('RecordsImage(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('path: $path, ')
          ..write('assetEntityId: $assetEntityId, ')
          ..write('createDate: $createDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, path, assetEntityId, createDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordsImage &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.path == this.path &&
          other.assetEntityId == this.assetEntityId &&
          other.createDate == this.createDate);
}

class RecordsImagesCompanion extends UpdateCompanion<RecordsImage> {
  final Value<int> id;
  final Value<String> recordId;
  final Value<String> path;
  final Value<String> assetEntityId;
  final Value<DateTime?> createDate;
  const RecordsImagesCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.path = const Value.absent(),
    this.assetEntityId = const Value.absent(),
    this.createDate = const Value.absent(),
  });
  RecordsImagesCompanion.insert({
    this.id = const Value.absent(),
    required String recordId,
    required String path,
    required String assetEntityId,
    this.createDate = const Value.absent(),
  })  : recordId = Value(recordId),
        path = Value(path),
        assetEntityId = Value(assetEntityId);
  static Insertable<RecordsImage> custom({
    Expression<int>? id,
    Expression<String>? recordId,
    Expression<String>? path,
    Expression<String>? assetEntityId,
    Expression<DateTime>? createDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (path != null) 'path': path,
      if (assetEntityId != null) 'asset_entity_id': assetEntityId,
      if (createDate != null) 'create_date': createDate,
    });
  }

  RecordsImagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? recordId,
      Value<String>? path,
      Value<String>? assetEntityId,
      Value<DateTime?>? createDate}) {
    return RecordsImagesCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      path: path ?? this.path,
      assetEntityId: assetEntityId ?? this.assetEntityId,
      createDate: createDate ?? this.createDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (assetEntityId.present) {
      map['asset_entity_id'] = Variable<String>(assetEntityId.value);
    }
    if (createDate.present) {
      map['create_date'] = Variable<DateTime>(createDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsImagesCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('path: $path, ')
          ..write('assetEntityId: $assetEntityId, ')
          ..write('createDate: $createDate')
          ..write(')'))
        .toString();
  }
}

class $RepeatExcludesTable extends RepeatExcludes
    with TableInfo<$RepeatExcludesTable, RepeatExclude> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepeatExcludesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _todoIdMeta = const VerificationMeta('todoId');
  @override
  late final GeneratedColumn<String> todoId = GeneratedColumn<String>(
      'todo_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repeatGroupIdMeta =
      const VerificationMeta('repeatGroupId');
  @override
  late final GeneratedColumn<String> repeatGroupId = GeneratedColumn<String>(
      'repeat_group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _excludedDateMeta =
      const VerificationMeta('excludedDate');
  @override
  late final GeneratedColumn<DateTime> excludedDate = GeneratedColumn<DateTime>(
      'excluded_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, todoId, repeatGroupId, excludedDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'RepeatExcludes';
  @override
  VerificationContext validateIntegrity(Insertable<RepeatExclude> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('todo_id')) {
      context.handle(_todoIdMeta,
          todoId.isAcceptableOrUnknown(data['todo_id']!, _todoIdMeta));
    } else if (isInserting) {
      context.missing(_todoIdMeta);
    }
    if (data.containsKey('repeat_group_id')) {
      context.handle(
          _repeatGroupIdMeta,
          repeatGroupId.isAcceptableOrUnknown(
              data['repeat_group_id']!, _repeatGroupIdMeta));
    } else if (isInserting) {
      context.missing(_repeatGroupIdMeta);
    }
    if (data.containsKey('excluded_date')) {
      context.handle(
          _excludedDateMeta,
          excludedDate.isAcceptableOrUnknown(
              data['excluded_date']!, _excludedDateMeta));
    } else if (isInserting) {
      context.missing(_excludedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepeatExclude map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepeatExclude(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      todoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}todo_id'])!,
      repeatGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}repeat_group_id'])!,
      excludedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}excluded_date'])!,
    );
  }

  @override
  $RepeatExcludesTable createAlias(String alias) {
    return $RepeatExcludesTable(attachedDatabase, alias);
  }
}

class RepeatExclude extends DataClass implements Insertable<RepeatExclude> {
  final int id;
  final String todoId;
  final String repeatGroupId;
  final DateTime excludedDate;
  const RepeatExclude(
      {required this.id,
      required this.todoId,
      required this.repeatGroupId,
      required this.excludedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['todo_id'] = Variable<String>(todoId);
    map['repeat_group_id'] = Variable<String>(repeatGroupId);
    map['excluded_date'] = Variable<DateTime>(excludedDate);
    return map;
  }

  RepeatExcludesCompanion toCompanion(bool nullToAbsent) {
    return RepeatExcludesCompanion(
      id: Value(id),
      todoId: Value(todoId),
      repeatGroupId: Value(repeatGroupId),
      excludedDate: Value(excludedDate),
    );
  }

  factory RepeatExclude.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepeatExclude(
      id: serializer.fromJson<int>(json['id']),
      todoId: serializer.fromJson<String>(json['todoId']),
      repeatGroupId: serializer.fromJson<String>(json['repeatGroupId']),
      excludedDate: serializer.fromJson<DateTime>(json['excludedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'todoId': serializer.toJson<String>(todoId),
      'repeatGroupId': serializer.toJson<String>(repeatGroupId),
      'excludedDate': serializer.toJson<DateTime>(excludedDate),
    };
  }

  RepeatExclude copyWith(
          {int? id,
          String? todoId,
          String? repeatGroupId,
          DateTime? excludedDate}) =>
      RepeatExclude(
        id: id ?? this.id,
        todoId: todoId ?? this.todoId,
        repeatGroupId: repeatGroupId ?? this.repeatGroupId,
        excludedDate: excludedDate ?? this.excludedDate,
      );
  @override
  String toString() {
    return (StringBuffer('RepeatExclude(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('repeatGroupId: $repeatGroupId, ')
          ..write('excludedDate: $excludedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, todoId, repeatGroupId, excludedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepeatExclude &&
          other.id == this.id &&
          other.todoId == this.todoId &&
          other.repeatGroupId == this.repeatGroupId &&
          other.excludedDate == this.excludedDate);
}

class RepeatExcludesCompanion extends UpdateCompanion<RepeatExclude> {
  final Value<int> id;
  final Value<String> todoId;
  final Value<String> repeatGroupId;
  final Value<DateTime> excludedDate;
  const RepeatExcludesCompanion({
    this.id = const Value.absent(),
    this.todoId = const Value.absent(),
    this.repeatGroupId = const Value.absent(),
    this.excludedDate = const Value.absent(),
  });
  RepeatExcludesCompanion.insert({
    this.id = const Value.absent(),
    required String todoId,
    required String repeatGroupId,
    required DateTime excludedDate,
  })  : todoId = Value(todoId),
        repeatGroupId = Value(repeatGroupId),
        excludedDate = Value(excludedDate);
  static Insertable<RepeatExclude> custom({
    Expression<int>? id,
    Expression<String>? todoId,
    Expression<String>? repeatGroupId,
    Expression<DateTime>? excludedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todoId != null) 'todo_id': todoId,
      if (repeatGroupId != null) 'repeat_group_id': repeatGroupId,
      if (excludedDate != null) 'excluded_date': excludedDate,
    });
  }

  RepeatExcludesCompanion copyWith(
      {Value<int>? id,
      Value<String>? todoId,
      Value<String>? repeatGroupId,
      Value<DateTime>? excludedDate}) {
    return RepeatExcludesCompanion(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      repeatGroupId: repeatGroupId ?? this.repeatGroupId,
      excludedDate: excludedDate ?? this.excludedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (todoId.present) {
      map['todo_id'] = Variable<String>(todoId.value);
    }
    if (repeatGroupId.present) {
      map['repeat_group_id'] = Variable<String>(repeatGroupId.value);
    }
    if (excludedDate.present) {
      map['excluded_date'] = Variable<DateTime>(excludedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepeatExcludesCompanion(')
          ..write('id: $id, ')
          ..write('todoId: $todoId, ')
          ..write('repeatGroupId: $repeatGroupId, ')
          ..write('excludedDate: $excludedDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  late final $InstallInfosTable installInfos = $InstallInfosTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  late final $RecordsImagesTable recordsImages = $RecordsImagesTable(this);
  late final $RepeatExcludesTable repeatExcludes = $RepeatExcludesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [installInfos, goals, todos, records, recordsImages, repeatExcludes];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('goals',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('todos', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('goals',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('RecordsImages', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
