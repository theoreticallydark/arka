import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/symptom_log.dart';

class LogRepository {
  final AppDatabase _dbProvider = AppDatabase.instance;

  Future<void> insertLog(SymptomLog log) async {
    final db = await _dbProvider.database;
    await db.insert(
      'symptom_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLog(SymptomLog log) async {
    final db = await _dbProvider.database;
    await db.update(
      'symptom_logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<void> deleteLog(String logId) async {
    final db = await _dbProvider.database;
    await db.delete(
      'symptom_logs',
      where: 'id = ?',
      whereArgs: [logId],
    );
  }

  Future<List<SymptomLog>> getLogsForUser(String userId, {String? filterSymptomId}) async {
    final db = await _dbProvider.database;
    String whereClause = 'sl.user_id = ?';
    List<dynamic> whereArgs = [userId];

    if (filterSymptomId != null && filterSymptomId.isNotEmpty) {
      whereClause += ' AND sl.symptom_id = ?';
      whereArgs.add(filterSymptomId);
    }

    final rows = await db.rawQuery('''
      SELECT sl.*, s.default_name AS symptom_name, s.icon_name AS symptom_icon, 
             s.asset_key AS symptom_asset_key, s.unit AS symptom_unit, s.measurement_type AS measurement_type
      FROM symptom_logs sl
      INNER JOIN symptoms s ON sl.symptom_id = s.id
      WHERE $whereClause
      ORDER BY sl.timestamp DESC
    ''', whereArgs);

    return rows.map((r) => SymptomLog.fromMap(r)).toList();
  }

  Future<List<SymptomLog>> getRecentLogs(String userId, {int limit = 5}) async {
    final db = await _dbProvider.database;
    final rows = await db.rawQuery('''
      SELECT sl.*, s.default_name AS symptom_name, s.icon_name AS symptom_icon, 
             s.asset_key AS symptom_asset_key, s.unit AS symptom_unit, s.measurement_type AS measurement_type
      FROM symptom_logs sl
      INNER JOIN symptoms s ON sl.symptom_id = s.id
      WHERE sl.user_id = ?
      ORDER BY sl.timestamp DESC
      LIMIT ?
    ''', [userId, limit]);

    return rows.map((r) => SymptomLog.fromMap(r)).toList();
  }
}
