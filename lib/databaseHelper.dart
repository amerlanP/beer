import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'can_data.db');

    // Only copy if the database doesn't already exist
    // if (!await File(path).exists()) {
    //   // Load database from asset and copy
    //   ByteData data = await rootBundle.load(join('assets', 'can_data.db'));
    //   List<int> bytes =
    //   data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    //
    //   // Write the copied database to the device
    //   await File(path).writeAsBytes(bytes);
    // }

    // ALWAYS LOAD DATABASE IN CASE OF CHANGE
    // Load database from asset and copy
    ByteData data = await rootBundle.load(join('assets', 'can_data.db'));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write the copied database to the device
    await File(path).writeAsBytes(bytes);

    return await openDatabase(path, readOnly: true);
  }

  // Example function to get data from the database
  Future<List<Map<String, dynamic>>> getData({String? query}) async {
    Database db = await database;
    if (query != null) {
      return await db.query('my_table', where: 'CanIdentifier LIKE ?', whereArgs: ['%$query%']);
    } else {
      return await db.query('my_table');
    }

  }

  Future<List<Map<String, dynamic>>> getDataWithFilters(Map<String, dynamic> filters) async {
    Database db = await database;
    String query = 'SELECT * FROM my_table WHERE 1=1';
    List<String> whereArgs = [];

    if (filters['minPrice'] != null && filters['minPrice'].isNotEmpty) {
      query += ' AND Price >= ?';
      whereArgs.add(filters['minPrice']);
    }

    if (filters['maxPrice'] != null && filters['maxPrice'].isNotEmpty) {
      query += ' AND Price <= ?';
      whereArgs.add(filters['maxPrice']);
    }

    if (filters['city'] != null && filters['city'].isNotEmpty) {
      query += ' AND City LIKE ?';
      whereArgs.add('%${filters['city']}%');
    }

    if (filters['state'] != null && filters['state'].isNotEmpty) {
      query += ' AND State LIKE ?';
      whereArgs.add('%${filters['state']}%');
    }

    if (filters['brand'] != null && filters['brand'].isNotEmpty) {
      query += ' AND Brand LIKE ?';
      whereArgs.add('%${filters['brand']}%');
    }

    if (filters['types'] != null && filters['types'].isNotEmpty) {
      query += ' AND Type IN (${filters['types'].map((type) => '?').join(',')})';
      whereArgs.addAll(filters['types']);
    }

    return await db.rawQuery(query, whereArgs);
  }
}