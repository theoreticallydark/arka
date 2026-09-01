import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/condition.dart';
import '../models/surgery.dart';

class ActiveHealthItem {
  final String junctionId;
  final String id;
  final String name;
  final String iconName;
  final String? assetKey;
  final bool isSurgery;

  const ActiveHealthItem({
    required this.junctionId,
    required this.id,
    required this.name,
    required this.iconName,
    this.assetKey,
    required this.isSurgery,
  });
}

class ConditionRepository {
  final AppDatabase _dbProvider = AppDatabase.instance;

  Future<List<HealthCondition>> getAllConditions() async {
    final db = await _dbProvider.database;
    final maps = await db.query('conditions');
    return maps.map((m) => HealthCondition.fromMap(m)).toList();
  }

  Future<List<Surgery>> getAllSurgeries() async {
    final db = await _dbProvider.database;
    final maps = await db.query('surgeries');
    return maps.map((m) => Surgery.fromMap(m)).toList();
  }

  Future<List<ActiveHealthItem>> getActiveHealthItems(String userId) async {
    final db = await _dbProvider.database;
    final List<ActiveHealthItem> results = [];

    // 1. Fetch active user conditions
    final conditionRows = await db.rawQuery('''
      SELECT uc.id AS junction_id, c.id AS id, c.default_name AS name, c.icon_name AS icon_name, c.asset_key AS asset_key
      FROM user_conditions uc
      INNER JOIN conditions c ON uc.condition_id = c.id
      WHERE uc.user_id = ? AND uc.is_active = 1
    ''', [userId]);

    for (final row in conditionRows) {
      results.add(ActiveHealthItem(
        junctionId: row['junction_id'] as String,
        id: row['id'] as String,
        name: row['name'] as String,
        iconName: row['icon_name'] as String,
        assetKey: row['asset_key'] as String?,
        isSurgery: false,
      ));
    }

    // 2. Fetch active user surgeries
    final surgeryRows = await db.rawQuery('''
      SELECT us.id AS junction_id, s.id AS id, s.default_name AS name, s.icon_name AS icon_name, s.asset_key AS asset_key
      FROM user_surgeries us
      INNER JOIN surgeries s ON us.surgery_id = s.id
      WHERE us.user_id = ? AND us.is_active = 1
    ''', [userId]);

    for (final row in surgeryRows) {
      results.add(ActiveHealthItem(
        junctionId: row['junction_id'] as String,
        id: row['id'] as String,
        name: row['name'] as String,
        iconName: row['icon_name'] as String,
        assetKey: row['asset_key'] as String?,
        isSurgery: true,
      ));
    }

    return results;
  }

  Future<void> markConditionAsRecovered(String junctionId) async {
    final db = await _dbProvider.database;
    await db.update(
      'user_conditions',
      {
        'is_active': 0,
        'resolved_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [junctionId],
    );
  }

  Future<void> markSurgeryAsRecovered(String junctionId) async {
    final db = await _dbProvider.database;
    await db.update(
      'user_surgeries',
      {
        'is_active': 0,
        'resolved_date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [junctionId],
    );
  }

  Future<void> saveUserConditions(String userId, List<String> conditionIds) async {
    final db = await _dbProvider.database;
    final batch = db.batch();
    for (final condId in conditionIds) {
      final userCond = UserCondition(
        id: 'uc_${userId}_$condId',
        userId: userId,
        conditionId: condId,
        isActive: true,
        createdAt: DateTime.now().toIso8601String(),
      );
      batch.insert('user_conditions', userCond.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveUserSurgery(String userId, String surgeryId) async {
    final db = await _dbProvider.database;
    final userSurg = UserSurgery(
      id: 'us_${userId}_$surgeryId',
      userId: userId,
      surgeryId: surgeryId,
      isActive: true,
      createdAt: DateTime.now().toIso8601String(),
    );
    await db.insert('user_surgeries', userSurg.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
