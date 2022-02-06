import 'package:flutter/material.dart';
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/models/todo.dart';

class RecordListPage extends StatefulWidget {
  const RecordListPage({Key? key}) : super(key: key);
  @override
  _RecordListPage createState() => _RecordListPage();
}

class _RecordListPage extends State<RecordListPage> {
  List<Todo> todos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshTodos();
  }

  @override
  void dispose() {
    TodoDatabase.instance.Close();
    super.dispose();
  }

  Future refreshTodos() async {
    setState(() {
      isLoading = true;
    });
    this.todos = await TodoDatabase.instance.readAllTodos();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final item = todos[index];
          return ListTile(
            leading: Icon(Icons.filter_none_outlined),
            iconColor: Colors.blue,
            title: Text(item.title),
            subtitle: Text(item.description),
            textColor: Colors.blue,
          );
        });
  }
}
