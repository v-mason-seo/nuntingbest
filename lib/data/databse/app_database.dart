import 'package:moor_flutter/moor_flutter.dart';
import 'bookmark_content_table.dart';
import 'read_content_table.dart';

part 'app_database.g.dart';

//
// flutter packages pub run build_runner build
//
@UseMoor(tables: [ReadContent, BookmarkContent])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
    : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: false,
        )));

  @override
  int get schemaVersion => 1;

  //-------------------------------------------

  Future<List<ReadContentData>> getAllReadContent(int limit) => (select(readContent)
                                                          ..limit(limit)
                                                          ..orderBy([(t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc)])
                                                          ).get();


  Stream<List<ReadContentData>> watchAllReadContent() => select(readContent).watch();


  Future insertReadContent(ReadContentData readContentData) => into(readContent).insert(readContentData, orReplace: true);


  //-------------------------------------------


  Future<BookmarkContentData> getBookmarkContent(String url) 
      => (select(bookmarkContent)..where((t) => t.url.equals(url))).getSingle();


  Stream<List<BookmarkContentData>> watchAllBookmarkContent() => select(bookmarkContent).watch();


  Future insertBookmarkContent(BookmarkContentData bookmarkContentData) => into(bookmarkContent).insert(bookmarkContentData, orReplace: true);


  //-------------------------------------------
  

  //Future<List<ReadContent>> get allWatchingModes2 => select(readContent).get();

  //Future<List<ReadData>> get allWatchingModes1111 => select(read).get();
  //Future<List<Mode>> get allWatchingModes3333 => select(modes).get();
  //Stream<List<Mode>> get watchAllModes33333333 => select(modes).watch();
}