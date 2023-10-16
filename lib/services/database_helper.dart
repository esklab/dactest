import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'profiles.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {
      await db.execute('''
          CREATE TABLE profiles (
            id INTEGER PRIMARY KEY,
            username TEXT,
            firstName TEXT,
            lastName TEXT,
            email TEXT,
            phone TEXT,
            city TEXT,
            country TEXT,
            postcode TEXT
          )
      ''');
    });
  }

  Future<int> insertProfile(Map<String, dynamic> profile) async {
    final dbClient = await db;
    return await dbClient!.insert('profiles', profile);
  }

  Future<List<Map<String, dynamic>>> getProfiles() async {
    final dbClient = await db;
    final list = await dbClient!.query('profiles');
    return list;
  }

  Future<int> updateProfile(Map<String, dynamic> profile) async {
    final dbClient = await db;
    return await dbClient!.update('profiles', profile, where: 'id = ?', whereArgs: [profile['id']]);
  }

  Future<int> deleteProfile(int id) async {
    final dbClient = await db;
    return await dbClient!.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final dbClient = await db;
    dbClient!.close();
  }
}
