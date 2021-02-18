import 'package:moor_flutter/moor_flutter.dart';

class BookmarkContent extends Table {

  TextColumn get url => text().customConstraint('UNIQUE')();
  TextColumn get sid => text()();
  TextColumn get title => text()();
  BoolColumn get read => boolean()();
  DateTimeColumn get dueDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {url};
}