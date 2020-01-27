import 'package:async/async.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'employee.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String TABLE = 'employee';
  static const String DB_Name = 'employee.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory DocumentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(DocumentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,$NAME TEXT)");
  }

  Future<employee> save(employee emp) async {
    var DBClient = await db;
    emp.id = await DBClient.insert(TABLE, emp.toMap());

    return emp;
  }

  Future<List<employee>> geEmployees() async {
    var dbclient = await db;
    List<Map> maps = await dbclient.query(TABLE, columns: [ID, NAME]);
    List<employee> emps = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        emps.add(employee.fromMap(maps[i]));
      }
    }
    return emps;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID=?', whereArgs: [id]);
  }

  Future<int> update(employee employ) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, employ.toMap(),
        where: '$ID = ?', whereArgs: [employ.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
