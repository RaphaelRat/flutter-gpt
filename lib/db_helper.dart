import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE messages (
      id $idType,
      text $textType,
      isSentByMe $boolType,
      timestamp $textType
    )
    ''');
  }

  Future<int> addMessage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('messages', row);
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    Database db = await instance.database;
    return await db.query('messages');
  }

  Future<void> clearMessages() async {
    Database db = await instance.database;
    await db.delete('messages');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
