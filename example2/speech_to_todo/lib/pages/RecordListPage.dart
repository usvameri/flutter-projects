import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/models/todo.dart';
import 'package:speech_to_todo/widgets/categoryCard.dart';

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
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    TodoDatabase.instance.delete(this.selectedItem);
                    setState(() {
                      refreshTodos();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItem = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        }).whenComplete(() {
      setState(() {
        selectedItem = 0;
      });
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

  Future updateDone(Todo todo) async {
    var doneState = todo.done ? false : true;
    var newTodo = todo.copy(done: doneState);
    await TodoDatabase.instance.update(newTodo);
    refreshTodos();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Text(
                    'Daily',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Montlyh',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CategoryCard(
                data: todos,
              ),
              Row(
                children: [
                  Center(
                    widthFactor: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        onPressed: () => setState(() {
                          refreshTodos();
                        }),
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
//  return Scaffold(
//       body: ListView.builder(
//           itemCount: todos.length,
//           itemBuilder: (context, index) {
//             final item = todos[index];
//             return ListTile(
//               leading: item.done ? Icon(Icons.check_box_outlined) : Icon(Icons.check_box_outline_blank),
//               iconColor: selectedItem == item.id ? Colors.white : Colors.blue,
//               title: Text(item.title),
//               subtitle: Text(item.description),
//               trailing: Wrap(children: [Text((item.createdTime.hour.toString() + ':'+ item.createdTime.minute.toString() + ' ' +item.createdTime.day.toString() + '/' + item.createdTime.month.toString()+ '/' + item.createdTime.year.toString()), style: TextStyle(fontSize: 12),)]),
//               textColor: selectedItem == item.id ? Colors.white : Colors.blue,
//               tileColor: selectedItem == item.id ? Colors.blue : null,
//               onTap: () {
//                 updateDone(item);
//               },
//               onLongPress: () {
//                 setState(() {
//                   selectedItem = item.id;
//                   deleteTodo();
//                 });
//               },
//             );
//           }),
//       floatingActionButton: CircleAvatar(
//         backgroundColor: Colors.blue,
//         child: IconButton(
//           onPressed: () => setState(() {
//             refreshTodos();
//           }),
//           icon: Icon(Icons.refresh),
//           color: Colors.white,
          
//         ),
//       ),
//     );