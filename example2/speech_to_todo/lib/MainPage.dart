// import 'dart:html';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/models/todo.dart';
import 'package:speech_to_todo/pages/HomePage.dart';
import 'package:speech_to_todo/pages/RecordListPage.dart';
import 'package:speech_to_todo/pages/RecorderPage.dart';
import 'package:speech_to_todo/widgets/note_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  bool isListening = false;
  int currentIndex = 0;
  final screens = [HomePage(), RecorderPage(), RecordListPage()];
  String text = "Press button for record your notes.";
  var _speechToText = stt.SpeechToText();
  void listen() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification) => print("$errorNotification"),
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        _speechToText.listen(
            onResult: (result) => setState(() {
                  text = result.recognizedWords;
                }));
      }
    } else {
      setState(() {
        isListening = false;
        _speechToText.stop();
      });
      Todo newTodo = Todo(
          title: 'Note',
          description: this.text,
          priority: true,
          done: false,
          createdTime: DateTime.now());
      await TodoDatabase.instance.create(newTodo);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      appBar: AppBar(
        title: Text(
          "TODO APP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.mic),
              label: 'Record',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
              backgroundColor: Colors.red),
        ],
      ),
    );
  }
}



//  body: SingleChildScrollView(
//         child: Container(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               text = text,
//             ),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//         animate: isListening,
//         repeat: true,
//         endRadius: 80,
//         duration: Duration(milliseconds: 1000),
//         glowColor: Colors.blue,
//         child: FloatingActionButton(
//           onPressed: () => {listen()},
//           child: Icon(isListening ? Icons.mic : Icons.mic_none),
//           backgroundColor: isListening ? Colors.red : Colors.blue,
//         ),
//       ),
//     );