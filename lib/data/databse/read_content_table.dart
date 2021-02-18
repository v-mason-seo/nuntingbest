

import 'package:moor_flutter/moor_flutter.dart';

class ReadContent extends Table {

  TextColumn get url => text().customConstraint('UNIQUE')();
  TextColumn get sid => text()();
  DateTimeColumn get dueDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {url};

}


// class Read extends Table {
//   TextColumn get userName =>
//       text().named('user_name').customConstraint('UNIQUE')();
//  TextColumn get watchMode => text().named('watch_mode')();
//  @override
//  Set<Column> get primaryKey => {userName};
//  DateTimeColumn get modifiedDate => dateTime().nullable()();
// }