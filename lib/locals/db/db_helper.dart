import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

class DbHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'task';
  static const String _dbName = "todo.db";
  static const String _vTable = 'voltage';
  static const String _wtTable = 'work_type';

  // DATABASE TABLE NAME
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath() + _dbName;
    return openDatabase(
      path,
      version: _version,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute(''' 
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          taskId INTEGER,
          workType TEXT,
          dispatcher TEXT,
          address TEXT,
          plannerDate TEXT,
          voltage REAL,
          job TEXT,
          completionDate TEXT,
          photos TEXT,
          comment TEXT,
          isCompleted INTEGER,
          isSynced INTEGER DEFAULT 0
        );
    ''');

    await db.execute(''' 
        CREATE TABLE $_vTable (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          uid TEXT,
          volt REAL
        );
    ''');

     await db.execute(''' 
        CREATE TABLE $_wtTable (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          uid TEXT,
          title REAL
        );
    ''');
  }

  /// ✅ Récupérer les tâches
  Future<List<TaskEntity>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(_tableName, where: 'isSynced = ?', whereArgs: [0]);
    return result.map((json) => TaskEntity.fromJson(json)).toList();
  }
  
   /// ✅ Insertion d'une tâche avec photos
  Future<int> insertTask(TaskEntity task) async {
    final db = await database;
    return await db.insert(
      _tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTasks(UpdateTaskParams params, int id) async {
    final db = await database;
    try {
      return await db.update(
        _tableName,
        params.toJson(),
        where: "taskId = ?",
        whereArgs: [id]
      );
    } catch (e) {
      log("Error to update task: $e");
      return 0;
    }
  }

  /// ✅ Mettre à jour une tâche
  Future<int> updateTask(TaskEntity task) async {
    final db = await database;
    return await db.update(
      _tableName,
      task.toJson(),
      where: "taskId = ?",
      whereArgs: [task.taskId],
    );
  }

  /// ✅ Supprimer une tâche
  Future<int> deleteTask(int taskId) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: "taskId = ?",
      whereArgs: [taskId],
    );
  }

  /// ✅ Supprimer toutes les tâches
  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete(_tableName);
  }

  Future<void> markAsSynced(int id) async {
    final db = await database;
    await db.update(
      _tableName,
      { "isSynced": 1},
      where: "taskId = ?", whereArgs: [id]
    );
  }

  // Work type operations
  Future<List<Map<String, dynamic>>> getWorkType() async {
    final db = await database;
    return await db.query(_wtTable);
  }

  // Voltage 
  Future<List<Map<String, dynamic>>> getVoltage() async {
    final db = await database;
    return await db.query(_vTable);
  }
}