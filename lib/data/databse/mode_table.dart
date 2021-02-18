import 'package:moor_flutter/moor_flutter.dart';

class Modes extends Table {
  TextColumn get userName =>
      text().named('user_name').customConstraint('UNIQUE')();
 TextColumn get watchMode => text().named('watch_mode')();
 @override
 Set<Column> get primaryKey => {userName};
 DateTimeColumn get modifiedDate => dateTime().nullable()();
}