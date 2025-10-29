import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  // Singleton pattern (একটাই instance থাকবে)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;
  static const String userTable = 'users';

  // ✅ Getter for database instance
  Future<Database> get database async {
    _db ??= await initDB();
    return _db!;
  }

  // ✅ Initialize the database
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $userTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // ✅ Insert new user
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(
      userTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Get user for login
  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      userTable,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  // ✅ Check if user already exists by email
  Future<UserModel?> checkEmailExists(String email) async {
    final db = await database;
    final res = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email],
    );
    if (res.isNotEmpty) return UserModel.fromMap(res.first);
    return null;
  }

  // ✅ (Optional) Get all users — debugging বা future use এর জন্য
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final res = await db.query(userTable);
    return res.map((e) => UserModel.fromMap(e)).toList();
  }

  // ✅ Delete all users (for testing/reset)
  Future<int> clearUsers() async {
    final db = await database;
    return await db.delete(userTable);
  }
}
