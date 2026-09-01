import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/default_clinical_data.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('arka_health_v1.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        date_of_birth TEXT NOT NULL,
        height_cm REAL,
        weight_kg REAL,
        preferred_language TEXT NOT NULL,
        is_onboarded INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. Conditions Master Table
    await db.execute('''
      CREATE TABLE conditions (
        id TEXT PRIMARY KEY,
        name_key TEXT NOT NULL,
        default_name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        asset_key TEXT,
        category TEXT NOT NULL
      )
    ''');

    // 3. User Conditions Junction Table
    await db.execute('''
      CREATE TABLE user_conditions (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        condition_id TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        resolved_date TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (condition_id) REFERENCES conditions(id)
      )
    ''');

    // 4. Surgeries Master Table
    await db.execute('''
      CREATE TABLE surgeries (
        id TEXT PRIMARY KEY,
        name_key TEXT NOT NULL,
        default_name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        asset_key TEXT,
        category TEXT NOT NULL
      )
    ''');

    // 5. User Surgeries Junction Table
    await db.execute('''
      CREATE TABLE user_surgeries (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        surgery_id TEXT NOT NULL,
        surgery_date TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        resolved_date TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (surgery_id) REFERENCES surgeries(id)
      )
    ''');

    // 6. Symptoms Master Table
    await db.execute('''
      CREATE TABLE symptoms (
        id TEXT PRIMARY KEY,
        name_key TEXT NOT NULL,
        default_name TEXT NOT NULL,
        description_key TEXT,
        default_description TEXT,
        icon_name TEXT NOT NULL,
        asset_key TEXT,
        measurement_type TEXT NOT NULL,
        unit TEXT,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 7. User Symptoms Junction Table
    await db.execute('''
      CREATE TABLE user_symptoms (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        symptom_id TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (symptom_id) REFERENCES symptoms(id)
      )
    ''');

    // 8. Symptom Logs Table
    await db.execute('''
      CREATE TABLE symptom_logs (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        symptom_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        numeric_value REAL,
        boolean_value INTEGER,
        text_value TEXT,
        note_text TEXT,
        voice_file_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (symptom_id) REFERENCES symptoms(id)
      )
    ''');

    // Seed master catalog
    await _seedCatalog(db);
  }

  Future<void> _seedCatalog(Database db) async {
    final batch = db.batch();

    for (final cond in DefaultClinicalData.conditions) {
      batch.insert('conditions', cond.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    for (final surg in DefaultClinicalData.surgeries) {
      batch.insert('surgeries', surg.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    for (final sym in DefaultClinicalData.allSymptoms) {
      batch.insert('symptoms', sym.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('symptom_logs');
    await db.delete('user_symptoms');
    await db.delete('user_conditions');
    await db.delete('user_surgeries');
    await db.delete('users');
  }
}
