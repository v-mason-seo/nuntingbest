// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ReadContentData extends DataClass implements Insertable<ReadContentData> {
  final String url;
  final String sid;
  final DateTime dueDate;
  ReadContentData({@required this.url, @required this.sid, this.dueDate});
  factory ReadContentData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return ReadContentData(
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      sid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}sid']),
      dueDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
    );
  }
  factory ReadContentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return ReadContentData(
      url: serializer.fromJson<String>(json['url']),
      sid: serializer.fromJson<String>(json['sid']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'url': serializer.toJson<String>(url),
      'sid': serializer.toJson<String>(sid),
      'dueDate': serializer.toJson<DateTime>(dueDate),
    };
  }

  @override
  ReadContentCompanion createCompanion(bool nullToAbsent) {
    return ReadContentCompanion(
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      sid: sid == null && nullToAbsent ? const Value.absent() : Value(sid),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  ReadContentData copyWith({String url, String sid, DateTime dueDate}) =>
      ReadContentData(
        url: url ?? this.url,
        sid: sid ?? this.sid,
        dueDate: dueDate ?? this.dueDate,
      );
  @override
  String toString() {
    return (StringBuffer('ReadContentData(')
          ..write('url: $url, ')
          ..write('sid: $sid, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(url.hashCode, $mrjc(sid.hashCode, dueDate.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is ReadContentData &&
          other.url == this.url &&
          other.sid == this.sid &&
          other.dueDate == this.dueDate);
}

class ReadContentCompanion extends UpdateCompanion<ReadContentData> {
  final Value<String> url;
  final Value<String> sid;
  final Value<DateTime> dueDate;
  const ReadContentCompanion({
    this.url = const Value.absent(),
    this.sid = const Value.absent(),
    this.dueDate = const Value.absent(),
  });
  ReadContentCompanion.insert({
    @required String url,
    @required String sid,
    this.dueDate = const Value.absent(),
  })  : url = Value(url),
        sid = Value(sid);
  ReadContentCompanion copyWith(
      {Value<String> url, Value<String> sid, Value<DateTime> dueDate}) {
    return ReadContentCompanion(
      url: url ?? this.url,
      sid: sid ?? this.sid,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

class $ReadContentTable extends ReadContent
    with TableInfo<$ReadContentTable, ReadContentData> {
  final GeneratedDatabase _db;
  final String _alias;
  $ReadContentTable(this._db, [this._alias]);
  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn('url', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _sidMeta = const VerificationMeta('sid');
  GeneratedTextColumn _sid;
  @override
  GeneratedTextColumn get sid => _sid ??= _constructSid();
  GeneratedTextColumn _constructSid() {
    return GeneratedTextColumn(
      'sid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  GeneratedDateTimeColumn _dueDate;
  @override
  GeneratedDateTimeColumn get dueDate => _dueDate ??= _constructDueDate();
  GeneratedDateTimeColumn _constructDueDate() {
    return GeneratedDateTimeColumn(
      'due_date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [url, sid, dueDate];
  @override
  $ReadContentTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'read_content';
  @override
  final String actualTableName = 'read_content';
  @override
  VerificationContext validateIntegrity(ReadContentCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.url.present) {
      context.handle(_urlMeta, url.isAcceptableValue(d.url.value, _urlMeta));
    } else if (url.isRequired && isInserting) {
      context.missing(_urlMeta);
    }
    if (d.sid.present) {
      context.handle(_sidMeta, sid.isAcceptableValue(d.sid.value, _sidMeta));
    } else if (sid.isRequired && isInserting) {
      context.missing(_sidMeta);
    }
    if (d.dueDate.present) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableValue(d.dueDate.value, _dueDateMeta));
    } else if (dueDate.isRequired && isInserting) {
      context.missing(_dueDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {url};
  @override
  ReadContentData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ReadContentData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ReadContentCompanion d) {
    final map = <String, Variable>{};
    if (d.url.present) {
      map['url'] = Variable<String, StringType>(d.url.value);
    }
    if (d.sid.present) {
      map['sid'] = Variable<String, StringType>(d.sid.value);
    }
    if (d.dueDate.present) {
      map['due_date'] = Variable<DateTime, DateTimeType>(d.dueDate.value);
    }
    return map;
  }

  @override
  $ReadContentTable createAlias(String alias) {
    return $ReadContentTable(_db, alias);
  }
}

class BookmarkContentData extends DataClass
    implements Insertable<BookmarkContentData> {
  final String url;
  final String sid;
  final String title;
  final bool read;
  final DateTime dueDate;
  BookmarkContentData(
      {@required this.url,
      @required this.sid,
      @required this.title,
      @required this.read,
      this.dueDate});
  factory BookmarkContentData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return BookmarkContentData(
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      sid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}sid']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      read: boolType.mapFromDatabaseResponse(data['${effectivePrefix}read']),
      dueDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}due_date']),
    );
  }
  factory BookmarkContentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return BookmarkContentData(
      url: serializer.fromJson<String>(json['url']),
      sid: serializer.fromJson<String>(json['sid']),
      title: serializer.fromJson<String>(json['title']),
      read: serializer.fromJson<bool>(json['read']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'url': serializer.toJson<String>(url),
      'sid': serializer.toJson<String>(sid),
      'title': serializer.toJson<String>(title),
      'read': serializer.toJson<bool>(read),
      'dueDate': serializer.toJson<DateTime>(dueDate),
    };
  }

  @override
  BookmarkContentCompanion createCompanion(bool nullToAbsent) {
    return BookmarkContentCompanion(
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      sid: sid == null && nullToAbsent ? const Value.absent() : Value(sid),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      read: read == null && nullToAbsent ? const Value.absent() : Value(read),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
    );
  }

  BookmarkContentData copyWith(
          {String url,
          String sid,
          String title,
          bool read,
          DateTime dueDate}) =>
      BookmarkContentData(
        url: url ?? this.url,
        sid: sid ?? this.sid,
        title: title ?? this.title,
        read: read ?? this.read,
        dueDate: dueDate ?? this.dueDate,
      );
  @override
  String toString() {
    return (StringBuffer('BookmarkContentData(')
          ..write('url: $url, ')
          ..write('sid: $sid, ')
          ..write('title: $title, ')
          ..write('read: $read, ')
          ..write('dueDate: $dueDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      url.hashCode,
      $mrjc(sid.hashCode,
          $mrjc(title.hashCode, $mrjc(read.hashCode, dueDate.hashCode)))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is BookmarkContentData &&
          other.url == this.url &&
          other.sid == this.sid &&
          other.title == this.title &&
          other.read == this.read &&
          other.dueDate == this.dueDate);
}

class BookmarkContentCompanion extends UpdateCompanion<BookmarkContentData> {
  final Value<String> url;
  final Value<String> sid;
  final Value<String> title;
  final Value<bool> read;
  final Value<DateTime> dueDate;
  const BookmarkContentCompanion({
    this.url = const Value.absent(),
    this.sid = const Value.absent(),
    this.title = const Value.absent(),
    this.read = const Value.absent(),
    this.dueDate = const Value.absent(),
  });
  BookmarkContentCompanion.insert({
    @required String url,
    @required String sid,
    @required String title,
    @required bool read,
    this.dueDate = const Value.absent(),
  })  : url = Value(url),
        sid = Value(sid),
        title = Value(title),
        read = Value(read);
  BookmarkContentCompanion copyWith(
      {Value<String> url,
      Value<String> sid,
      Value<String> title,
      Value<bool> read,
      Value<DateTime> dueDate}) {
    return BookmarkContentCompanion(
      url: url ?? this.url,
      sid: sid ?? this.sid,
      title: title ?? this.title,
      read: read ?? this.read,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

class $BookmarkContentTable extends BookmarkContent
    with TableInfo<$BookmarkContentTable, BookmarkContentData> {
  final GeneratedDatabase _db;
  final String _alias;
  $BookmarkContentTable(this._db, [this._alias]);
  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn('url', $tableName, false,
        $customConstraints: 'UNIQUE');
  }

  final VerificationMeta _sidMeta = const VerificationMeta('sid');
  GeneratedTextColumn _sid;
  @override
  GeneratedTextColumn get sid => _sid ??= _constructSid();
  GeneratedTextColumn _constructSid() {
    return GeneratedTextColumn(
      'sid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _readMeta = const VerificationMeta('read');
  GeneratedBoolColumn _read;
  @override
  GeneratedBoolColumn get read => _read ??= _constructRead();
  GeneratedBoolColumn _constructRead() {
    return GeneratedBoolColumn(
      'read',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  GeneratedDateTimeColumn _dueDate;
  @override
  GeneratedDateTimeColumn get dueDate => _dueDate ??= _constructDueDate();
  GeneratedDateTimeColumn _constructDueDate() {
    return GeneratedDateTimeColumn(
      'due_date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [url, sid, title, read, dueDate];
  @override
  $BookmarkContentTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'bookmark_content';
  @override
  final String actualTableName = 'bookmark_content';
  @override
  VerificationContext validateIntegrity(BookmarkContentCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.url.present) {
      context.handle(_urlMeta, url.isAcceptableValue(d.url.value, _urlMeta));
    } else if (url.isRequired && isInserting) {
      context.missing(_urlMeta);
    }
    if (d.sid.present) {
      context.handle(_sidMeta, sid.isAcceptableValue(d.sid.value, _sidMeta));
    } else if (sid.isRequired && isInserting) {
      context.missing(_sidMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.read.present) {
      context.handle(
          _readMeta, read.isAcceptableValue(d.read.value, _readMeta));
    } else if (read.isRequired && isInserting) {
      context.missing(_readMeta);
    }
    if (d.dueDate.present) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableValue(d.dueDate.value, _dueDateMeta));
    } else if (dueDate.isRequired && isInserting) {
      context.missing(_dueDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {url};
  @override
  BookmarkContentData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return BookmarkContentData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(BookmarkContentCompanion d) {
    final map = <String, Variable>{};
    if (d.url.present) {
      map['url'] = Variable<String, StringType>(d.url.value);
    }
    if (d.sid.present) {
      map['sid'] = Variable<String, StringType>(d.sid.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.read.present) {
      map['read'] = Variable<bool, BoolType>(d.read.value);
    }
    if (d.dueDate.present) {
      map['due_date'] = Variable<DateTime, DateTimeType>(d.dueDate.value);
    }
    return map;
  }

  @override
  $BookmarkContentTable createAlias(String alias) {
    return $BookmarkContentTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ReadContentTable _readContent;
  $ReadContentTable get readContent => _readContent ??= $ReadContentTable(this);
  $BookmarkContentTable _bookmarkContent;
  $BookmarkContentTable get bookmarkContent =>
      _bookmarkContent ??= $BookmarkContentTable(this);
  @override
  List<TableInfo> get allTables => [readContent, bookmarkContent];
}
