
import 'package:sqliteproj/database/db_helper.dart';
import 'package:sqliteproj/model/todo_model.dart';



class TodoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Todo todo) async {
    return await dbHelper.insert(todo.toMap());
  }

  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAll();
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<int> update(Todo todo) async {
    return await dbHelper.update(todo.toMap());
  }

  Future<int> delete(int id) async {
    return await dbHelper.delete(id);
  }
}
