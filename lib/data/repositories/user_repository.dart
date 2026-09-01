import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/user_profile.dart';

class UserRepository {
  final AppDatabase _dbProvider = AppDatabase.instance;

  Future<UserProfile?> getCurrentUser() async {
    final db = await _dbProvider.database;
    final maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<void> saveUser(UserProfile user) async {
    final db = await _dbProvider.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLanguage(String userId, String languageCode) async {
    final db = await _dbProvider.database;
    await db.update(
      'users',
      {
        'preferred_language': languageCode,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
