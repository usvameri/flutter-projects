import 'dart:ffi';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/pages/RecordListPage.dart';

import '../models/todo.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({Key? key}) : super(key: key);

  @override
  _RecorderPage createState() => _RecorderPage();
}

class _RecorderPage extends State<RecorderPage> {
  int currentState = 1;
  String text = "Press button for record your notes.";
  String title = "Todo";
  bool? priority = false;
  var _speechToText = stt.SpeechToText();
  bool isListening = false;

  void saveSpeech() async {
    Todo newTodo = Todo(
        title: title,
        description: text,
        priority: priority!,
        done: false,
        createdTime: DateTime.now());
    await TodoDatabase.instance.create(newTodo);
    text = "Press button for record your notes.";
    title = "Todo";
    priority = false;
  }

  void _showDialog(){
    showDialog(
            context: context,
            builder: (BuildContext builder) {
              var titleController = TextEditingController(text: title);
              var textController = TextEditingController(text: text);
              return StatefulBuilder(
                builder: (context, setState){
                      return AlertDialog(
                  scrollable: true,
                  title: Text('Edit Speech Text'),
                  content: Center(
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Title',
                              icon: Icon(Icons.flag),
                            ),
                            controller: titleController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Detail',
                              icon: Icon(Icons.text_format_outlined),
                            ),
                            controller: textController,
                          ),
                          CheckboxListTile(value: priority , title: Transform.translate(offset: const Offset(140, 0),child: Text('Priority'),), onChanged: (value) {
                            setState(() {
                              this.priority = value;
                            },);
                          } )
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            title = titleController.text;
                            text = textController.text;
                          });
                          saveSpeech();
              
                          Navigator.pop(context);
                        },
                        child: Text('Save'))
                  ],
                      );}





                );
              
            });
  }

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
        _showDialog();
        
      });
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
        glowColor: isListening ? Colors.red : Colors.blue,
        child: FloatingActionButton(
          onPressed: () => {listen()},
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: isListening ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
