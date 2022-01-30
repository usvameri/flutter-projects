import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/models/todo.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final int todoId;
  const DetailPage({Key? key, required this.todoId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Todo todo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshTodo(); // first get model of widget
  }

  Future refreshTodo() async {
    setState(() {
      isLoading = true;
    });
    this.todo = await TodoDatabase.instance.readTodo(widget.todoId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(todo.createdTime),
                    style: TextStyle(color: Colors.white38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    todo.description,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  )
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        // await Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => AddEditNotePage(note: note),
        // ));

        refreshTodo();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await TodoDatabase.instance.delete(widget.todoId);

          Navigator.of(context).pop();
        },
      );
}



// class DetailPage extends StatelessWidget{
//   const DetailPage({Key? key}) : super(key: key);

//     @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

