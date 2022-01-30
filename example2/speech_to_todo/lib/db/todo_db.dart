import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:speech_to_todo/models/todo.dart';
import 'package:path/path.dart'; //join func

//also rawDelete/rawInsert/rawQuery/rawUpdate can be use
//TODO: get items with conditions like => get only done records
class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase.init();

  static Database? _database;

  TodoDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!; //return db if exist

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final intType = 'INTEGER NOT NULL'; // defined for maybe using later
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';
    final datetimeType = 'DATETIME NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTodos (
      ${TodoFields.id} $idType,
      ${TodoFields.title} $textType,
      ${TodoFields.description} $textType,
      ${TodoFields.priority} $boolType,
      ${TodoFields.done} $boolType,
      ${TodoFields.createdTime} $textType
    )
    ''');
  }

  Future Close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    // final json = todo.toJson();
    // final columns =
    //     '${TodoFields.title}, ${TodoFields.description}, ${TodoFields.done}, ${TodoFields.priority}, ${TodoFields.createdTime}';
    // final values =
    //     '${json[TodoFields.title]}, ${json[TodoFields.description]}, ${json[TodoFields.done]}, ${json[TodoFields.priority]}, ${json[TodoFields.createdTime]}';

    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTodos, todo.toJson());
    return todo.copy(id: id);
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return db.update(tableTodos, todo.toJson(),
        where: '$TodoFields.id = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db
        .delete(tableTodos, where: '${TodoFields.id} = ?', whereArgs: [id]);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableTodos,
        columns: TodoFields.values,
        where:
            '${TodoFields.id} = ?', //question mark is for sql injection attack
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found'); // or return null
    }
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;

    final orderBy = '${TodoFields.createdTime} ASC';
    final result = await db.query(tableTodos, orderBy: orderBy);
    return result.map((item) => Todo.fromJson(item)).toList();
  }
}
