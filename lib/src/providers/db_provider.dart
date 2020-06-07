import 'dart:io';

import 'package:path/path.dart';
import 'package:qr_reader/src/models/scan_model.dart';
export 'package:qr_reader/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "ScansDb.db");

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  nuevoScanRaw(ScanModel model) async {
    final db = await database;
    final res = await db.rawInsert("INSERT INTO Scans ( id, tipo, valor ) "
        "VALUES ( ${model.id}, '${model.tipo}', '${model.valor}'  )");
    return res;
  }

  nuevoScan(ScanModel model) async {
    final db = await database;
    final res = await db.insert("Scans", model.toJson());
    return res;
  }

  Future<ScanModel> getScanbyId(int id) async {
    final db = await database;
    final res = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;
    final res = await db.query("Scans");

    if (res.isEmpty) return [];

    return res.map((x) => ScanModel.fromJson(x)).toList();
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERe Tipo='$tipo'");

    if (res.isEmpty) return [];

    return res.map((x) => ScanModel.fromJson(x)).toList();
  }

  Future<int> updateScan(ScanModel mode) async {
    final db = await database;
    final res = await db
        .update("Scans", mode.toJson(), where: 'id= ?', whereArgs: [mode.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete("Scans", where: 'id= ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete("DELETE FROM Scans");
    return res;
  }
}
