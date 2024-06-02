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

    // Load database from asset and copy
    ByteData data = await rootBundle.load(join('assets', 'can_data.db'));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write the copied database to the device
    await File(path).writeAsBytes(bytes);

    return await openDatabase(path, readOnly: true);
  }

  // Example function to get data from the database
  Future<List<Map<String, dynamic>>> getData(String table) async {
    Database db = await database;
    return await db.query(table);
  }
}