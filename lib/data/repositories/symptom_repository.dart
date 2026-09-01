import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/symptom.dart';

class SymptomRepository {
  final AppDatabase _dbProvider = AppDatabase.instance;

  Future<List<Symptom>> getAllSymptoms() async {
    final db = await _dbProvider.database;
    final maps = await db.query('symptoms');
    return maps.map((m) => Symptom.fromMap(m)).toList();
  }

  Future<List<Symptom>> getUserTrackedSymptoms(String userId) async {
    final db = await _dbProvider.database;
    final rows = await db.rawQuery('''
      SELECT s.*
      FROM user_symptoms us
      INNER JOIN symptoms s ON us.symptom_id = s.id
      WHERE us.user_id = ? AND us.is_enabled = 1
      ORDER BY us.sort_order ASC
    ''', [userId]);

    return rows.map((r) => Symptom.fromMap(r)).toList();
  }

  Future<void> saveUserSymptoms(String userId, List<String> symptomIds) async {
    final db = await _dbProvider.database;
    final batch = db.batch();

    // Disable existing or replace
    batch.delete('user_symptoms', where: 'user_id = ?', whereArgs: [userId]);

    for (int i = 0; i < symptomIds.length; i++) {
      final symId = symptomIds[i];
      final userSym = UserSymptom(
        id: 'usym_${userId}_$symId',
        userId: userId,
        symptomId: symId,
        sortOrder: i,
        isEnabled: true,
      );
      batch.insert('user_symptoms', userSym.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> toggleUserSymptom(String userId, String symptomId, bool isEnabled) async {
    final db = await _dbProvider.database;
    final existing = await db.query(
      'user_symptoms',
      where: 'user_id = ? AND symptom_id = ?',
      whereArgs: [userId, symptomId],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'user_symptoms',
        {'is_enabled': isEnabled ? 1 : 0},
        where: 'user_id = ? AND symptom_id = ?',
        whereArgs: [userId, symptomId],
      );
    } else {
      final userSym = UserSymptom(
        id: 'usym_${userId}_$symptomId',
        userId: userId,
        symptomId: symptomId,
        sortOrder: 99,
        isEnabled: isEnabled,
      );
      await db.insert('user_symptoms', userSym.toMap());
    }
  }
}
