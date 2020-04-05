import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:qr_reader/src/models/scan.dart';
export 'package:qr_reader/src/models/scan.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'scan.db');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        return await db.execute('CREATE TABLE Scans ('
            'id INTEGER PRIMARY KEY,'
            'type TEXT,'
            'value TEXT'
            ')');
      },
    );
  }

  // Create rsgisters
  Future<int> newScanRaw(Scan scan) async {
    final Database db = await database;
    final res = await db.rawInsert(
      "INSERT INTO Scans (id, type, value) "
      "VALUES (${scan.id},'${scan.type}','${scan.value} )'",
    );

    return res;
  }

  Future<int> newScan(Scan scan) async {
    final Database db = await database;
    final res = await db.insert('scans', scan.toJson());
    return res;
  }

  // Get information
  Future<Scan> getScanById(int id) async {
    final Database db = await database;
    final res = await db.query(
      'scans',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? Scan.fromJson(res.first) : null;
  }

  Future<List<Scan>> getScans() async {
    final Database db = await database;
    final res = await db.query('scans');

    return res.isNotEmpty ? res.map((r) => Scan.fromJson(r)).toList() : [];
  }

  Future<List<Scan>> getScansByType(String type) async {
    final Database db = await database;
    final res = await db.rawQuery(
      'SELECT * FROM Scans '
      'WHERE Type = $type',
    );

    return res.isNotEmpty ? res.map((r) => Scan.fromJson(r)).toList() : [];
  }

  // Update
  Future<int> updateScan(Scan scan) async {
    final Database db = await database;
    final res = await db.update(
      'scans',
      scan.toJson(),
      where: 'id = ?',
      whereArgs: [scan.id],
    );

    return res;
  }

  // Delete scan
  Future<int> deleteScan(int id) async {
    final Database db = await database;
    final res = await db.delete(
      'scans',
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  Future<int> deleteAllScans() async {
    final Database db = await database;
    final res = await db.rawDelete("DELETE FROM 'scans'");
    return res;
  }
}
