// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todoapp/Models/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'todo_database.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        dateTime TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  Future<int> insertTodo(Todo todo) async {
    var db = await database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<Todo>> getTodos() async {
    var db = await database;
    var result = await db.query('todos');
    return result.map((map) => Todo.fromMap(map)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    var db = await database;
    return await db
        .update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    var db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
