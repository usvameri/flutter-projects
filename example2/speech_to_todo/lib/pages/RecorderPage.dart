import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_todo/db/todo_db.dart';

import '../models/todo.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({Key? key}) : super(key: key);

  @override
  _RecorderPage createState() => _RecorderPage();
}

class _RecorderPage extends State<RecorderPage> {
  int currentState = 1;
  String text = "Press button for record your notes.";
  var _speechToText = stt.SpeechToText();
  bool isListening = false;

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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text = text,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        repeat: true,
        endRadius: 80,
        duration: Duration(milliseconds: 1000),
        glowColor: Colors.blue,
        child: FloatingActionButton(
          onPressed: () => {listen()},
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: isListening ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
