import 'dart:collection';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights1 = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
 


  


  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          ),
        ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}




// // import 'dart:html';

// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/material.dart';
// import 'package:highlight_text/highlight_text.dart';
// // import 'package:speech_recognition/speech_recognition.dart' ;
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Todo App',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: SpeechScreen(),
//     );
//   }
// }

// class SpeechScreen extends StatefulWidget {
//   @override
//   _SpeechScreenState createState() => _SpeechScreenState();
// }

// class _SpeechScreenState extends State<SpeechScreen> {
//   final Map<String, HighlightedWord> _hightlights = {
//     'flutter': HighlightedWord(
//       onTap: () => print('flutter'),
//       textStyle:
//           const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
//     ),
//     'voice': HighlightedWord(
//       onTap: () => print('voice'),
//       textStyle:
//           const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
//     ),
//     'hello': HighlightedWord(
//       onTap: () => print('hello'),
//       textStyle:
//           const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//     )
//   };

//   stt.SpeechToText? _speech;
//   bool _isListening = false;
//   String _text = 'Press the button and start listenig';
//   double _confidence = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Condidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//         animate: _isListening,
//         glowColor: Theme.of(context).primaryColor,
//         endRadius: 75.0,
//         duration: const Duration(milliseconds: 2000),
//         repeatPauseDuration: const Duration(milliseconds: 2000),
//         repeat: true,
//         child: FloatingActionButton(
//           onPressed: _listen,
//           child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//         ),
//       ),
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
//           child: TextHighlight(
//             text: _text,
//             words: _hightlights,
//             textStyle: const TextStyle(
//                 fontSize: 32.0,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w400),
//           ),
//         ),
//       ),
//     );
//   }

//   void _listen() async {
//     // TODO:Fix this
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (status) => print('onStatus: $status'),
//         onError: (status) => print('onError: $status'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) => setState(() {
//             _text = result.recognizedWords;
//             if (result.hasConfidenceRating && result.confidence > 0) {
//               _confidence = result.confidence;
//             }
//           }),
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
// }




















// class VoiceHome extends StatefulWidget {
//   @override
//   _VoiceHomeState createState() => _VoiceHomeState();
// }

// class _VoiceHomeState extends State<VoiceHome> {
//   SpeechRecognition _speechRecognition = SpeechRecognition();
//   bool _isAvailable = false;
//   bool _isListening = false;

//   String resultText = "";

//   @override
//   void initState(){
//     super.initState();
//     initSpeechRecognizer();
//   }

//   void initSpeechRecognizer(){
//     _speechRecognition = SpeechRecognition();
//       _speechRecognition.setAvailabilityHandler(
//         (bool result) => setState(() => _isAvailable = result),);
//         // set new value to isAvailable with setstate func > boolean result and return setState func

//       _speechRecognition.setRecognitionStartedHandler(
//         () => setState(() => _isListening = true),);
//         // pass true value to isListening field when recognizer is started

//       _speechRecognition.setRecognitionResultHandler(
//         (String text) => setState(() => resultText = text),);

//       _speechRecognition.setRecognitionCompleteHandler(
//         () => setState(() => _isListening = false),);

//       _speechRecognition.activate().then((value) => setState(() => _isAvailable = value));

//       // _speechRecognition.activate.then(
//       //   (value) => setState(() => _isAvailable = value),);
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                 FloatingActionButton(mini: true,child: Icon(Icons.cancel), onPressed: () {
//                   if(_isListening)
//                     _speechRecognition.stop().then(
//                       (value) => setState(() {
//                         _isListening = value;
//                         resultText = "";
//                       }),
//                     );
//                   },
//                 ),
//                 FloatingActionButton(backgroundColor: Colors.blue, child: Icon(Icons.mic),onPressed: () {
//                   if(_isAvailable && !_isListening)
//                     _speechRecognition.listen(locale: "tr_TR").then((value) => print('$value'));
//                 }),
//                 FloatingActionButton( mini: true,backgroundColor: Colors.deepOrange,child: Icon(Icons.stop),onPressed: () {
//                   if(_isListening)
//                     _speechRecognition.stop().then((value) => setState(() => _isListening = value));
//                 },
//                 ),
//               ],

//             ),
//             Container(
//               child: Text(resultText),
//               width: MediaQuery.of(context).size.width * 0.6,
//               decoration: BoxDecoration(
//                 color: Colors.cyanAccent[100],
//                 borderRadius: BorderRadius.circular(6.0)
//               ),
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 22.0
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VoiceHome extends StatefulWidget {
//   @override
//   _VoiceHomeState createState() => _VoiceHomeState();
// }

// class _VoiceHomeState extends State<VoiceHome> {
//   SpeechRecognition _speechRecognition = SpeechRecognition();
//   bool _isAvailable = false;
//   bool _isListening = false;

//   String resultText = "";

//   @override
//   void initState(){
//     super.initState();
//     initSpeechRecognizer();
//   }

//   void initSpeechRecognizer(){
//     _speechRecognition = SpeechRecognition();
//       _speechRecognition.setAvailabilityHandler(
//         (bool result) => setState(() => _isAvailable = result),);
//         // set new value to isAvailable with setstate func > boolean result and return setState func

//       _speechRecognition.setRecognitionStartedHandler(
//         () => setState(() => _isListening = true),);
//         // pass true value to isListening field when recognizer is started

//       _speechRecognition.setRecognitionResultHandler(
//         (String text) => setState(() => resultText = text),);

//       _speechRecognition.setRecognitionCompleteHandler(
//         () => setState(() => _isListening = false),);

//       _speechRecognition.activate().then((value) => setState(() => _isAvailable = value));

//       // _speechRecognition.activate.then(
//       //   (value) => setState(() => _isAvailable = value),);
//   }

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                 FloatingActionButton(mini: true,child: Icon(Icons.cancel), onPressed: () {
//                   if(_isListening)
//                     _speechRecognition.stop().then(
//                       (value) => setState(() {
//                         _isListening = value;
//                         resultText = "";
//                       }),
//                     );
//                   },
//                 ),
//                 FloatingActionButton(backgroundColor: Colors.blue, child: Icon(Icons.mic),onPressed: () {
//                   if(_isAvailable && !_isListening)
//                     _speechRecognition.listen(locale: "tr_TR").then((value) => print('$value'));
//                 }),
//                 FloatingActionButton( mini: true,backgroundColor: Colors.deepOrange,child: Icon(Icons.stop),onPressed: () {
//                   if(_isListening)
//                     _speechRecognition.stop().then((value) => setState(() => _isListening = value));
//                 },
//                 ),
//               ],

//             ),
//             Container(
//               child: Text(resultText),
//               width: MediaQuery.of(context).size.width * 0.6,
//               decoration: BoxDecoration(
//                 color: Colors.cyanAccent[100],
//                 borderRadius: BorderRadius.circular(6.0)
//               ),
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 22.0
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
