import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoist/models/task.dart';
import 'package:todoist/models/todo.dart';

class DbHelper {
  // Creating a database for `tasks`
  Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
        join(
          await getDatabasesPath(),
          'todoist.db',
          // ignore: void_checks
        ), onCreate: (db, version) {
      db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
      );
      db.execute(
        'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)',
      );

      return db;
    }, version: 1);
  }

  // Function to inset `Task`
  Future<int> insetTask(Task task) async {
    int taskId = 0;
    Database db = await database();
    await db
        .insert(
          'tasks',
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
        .then((value) => {taskId = value});

    return taskId;
  }

  // Function to inset `Todo`
  Future<void> insetTodo(Todo todo) async {
    Database db = await database();
    await db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Function to get `Tasks` list
  Future<List<Task>> getTasks() async {
    Database db = await database();
    List<Map<String, dynamic>> taskMap = await db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  // Function to get `Todo` list
  Future<List<Todo>> getTodo(int taskId) async {
    Database db = await database();
    List<Map<String, dynamic>> todoMap =
        await db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskId'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }
}
