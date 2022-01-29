final String tableTodos = "todos";

class TodoFields {
  // column names of todos table
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String done = 'done';
  static final String priority = 'priority';
  static final String createdTime = 'createdTime';
}

class Todo {
  final int? id;
  final String title;
  final String description;
  final bool done;
  final bool priority;
  final DateTime createdTime;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.priority,
    required this.createdTime,
  });

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.priority: priority ? 1 : 0,
        TodoFields.done: done ? 1 : 0,
        TodoFields.createdTime: createdTime.toIso8601String()
      };

  Todo copy({
    int? id,
    String? title,
    String? description,
    bool? priority,
    bool? done,
    DateTime? createdTime,
  }) =>
      Todo(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          priority: priority ?? this.priority,
          done: done ?? this.done,
          createdTime: createdTime ?? this.createdTime);
}
