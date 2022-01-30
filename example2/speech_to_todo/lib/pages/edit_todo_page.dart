import 'package:flutter/material.dart';
import 'package:speech_to_todo/db/todo_db.dart';
import 'package:speech_to_todo/models/todo.dart';
import 'package:speech_to_todo/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Todo? todo;

  const AddEditNotePage({
    Key? key,
    this.todo,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.todo?.priority ?? false;
    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            // number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.todo != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final todo = widget.todo!.copy(
      priority: isImportant,
      title: title,
      description: description,
    );

    await TodoDatabase.instance.update(todo);
  }

  Future addNote() async {
    final note = Todo(
      title: title,
      priority: true,
      done: false,
      description: description,
      createdTime: DateTime.now(),
    );

    await TodoDatabase.instance.create(note);
  }
}
