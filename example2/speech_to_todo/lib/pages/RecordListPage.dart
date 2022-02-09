import 'dart:ffi';

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
  int? selectedItem = 0;
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

  Future deleteTodo() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    TodoDatabase.instance.delete(this.selectedItem);
                    setState(() {
                      refreshTodos();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Delete')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
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
    return Scaffold(
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final item = todos[index];
            return ListTile(
              leading: Icon(Icons.filter_none_outlined),
              iconColor: selectedItem == item.id ? Colors.white : Colors.blue,
              title: Text(item.title),
              subtitle: Text(item.description),
              textColor: selectedItem == item.id ? Colors.white : Colors.blue,
              tileColor: selectedItem == item.id ? Colors.blue : null,
              onLongPress: () {
                setState(() {
                  selectedItem = item.id;
                  deleteTodo();
                });
              },
            );
          }),
      floatingActionButton: IconButton(
        onPressed: () => setState(() {
          refreshTodos();
        }),
        icon: Icon(Icons.refresh),
        color: Colors.blue,
      ),
    );
  }
}
