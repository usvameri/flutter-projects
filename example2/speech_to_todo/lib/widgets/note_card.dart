import 'package:flutter/material.dart';

class CustomNoteCard extends StatefulWidget {
  final String title;
  final String description;
  DateTime? date;
  bool? isDone;
  int? priority;

  CustomNoteCard(
      {Key? key,
      required this.title,
      required this.description,
      bool? this.isDone = false,
      int? this.priority = 10,
      DateTime? this.date})
      : super(key: key);

  @override
  _CustomNoteCardState createState() => _CustomNoteCardState();
}

class _CustomNoteCardState extends State<CustomNoteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
