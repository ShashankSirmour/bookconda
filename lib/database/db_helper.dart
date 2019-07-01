import 'dart:async';
import 'dart:io' as io;
import 'package:book/model/store_book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHealper {
  static Database _db;
  static const String ID = 'id';
  static const String BOOKID = 'bookId';
  static const String TYPE = 'type';
  static const String DOWNLOADPATH = 'downloadPath';
  static const String DOWNLOADFILENAME = 'downloadFileName';
  static const String IMAGEPATH = 'imagePath';
  static const String TITLE = 'title';
  static const String AUTHOR = 'author';
  static const String EXTENTION = 'extention';
  static const String SIZE = 'size';
  static const String ISBNS = 'isbns';
  static const String PAGE = 'page';
  static const String LANGUAGE = 'language';
  static const String EDITION = 'edition';
  static const String YEARPUBLISED = 'yearPublised';
  static const String PUBLICATION = 'publication';
  static const String DOWNLOADED = 'downloaded';
  static const String TASKID = 'taskId';
  static const String TABLE = 'books';
  static const String DB_NAME = 'books.db';

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,$BOOKID TEXT,$TYPE INTEGER,$DOWNLOADPATH TEXT,$DOWNLOADFILENAME TEXT,$IMAGEPATH TEXT,$TITLE TEXT,$AUTHOR TEXT,$EXTENTION TEXT,$SIZE TEXT,$ISBNS TEXT,$PAGE TEXT,$LANGUAGE TEXT,$EDITION TEXT,$YEARPUBLISED TEXT,$PUBLICATION TEXT,$DOWNLOADED INTEGER,$TASKID TEXT)");
  }

//-----------------------------save-----------------------
  Future<StoreBook> save(StoreBook book) async {
    var dbClient = await db;
    book.id = await dbClient.insert(TABLE, book.toMap());
    return book;
  }

//---------------------------------retrive-------------------

  Future<StoreBook> getBook(String bookId, int type) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE,
        where: "$BOOKID=? AND $TYPE=?", whereArgs: [bookId, type]);

    StoreBook storebooks;

    if (maps.length > 0) {
      storebooks = StoreBook.fromMap(maps[0]);
    }
    return storebooks;
  }

  Future<List<StoreBook>> getALLDownloadingBooks() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM $TABLE WHERE $DOWNLOADED=0");

    List<StoreBook> storebooks = [];
    if (maps.length > 0)
      for (var i = 0; i < maps.length; i++) {
        storebooks.add(StoreBook.fromMap(maps[i]));
      }
    return storebooks;
  }

  Future<List<StoreBook>> getALLDownloadedBooks() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM $TABLE WHERE $DOWNLOADED=1");

    List<StoreBook> storebooks = [];
    if (maps.length > 0)
      for (var i = 0; i < maps.length; i++) {
        storebooks.add(StoreBook.fromMap(maps[i]));
      }

    return storebooks;
  }

//---------------------------------delete----------------------------
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: "$ID=?", whereArgs: [id]);
  }

  Future deletaAllData() async {
    var dbClient = await db;
    dbClient.rawDelete("DELETE FROM $TABLE");
  }

//----------------------------------update-------------------------------
  Future<int> update(StoreBook book) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, book.toMap(), where: "$ID=?", whereArgs: [book.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
