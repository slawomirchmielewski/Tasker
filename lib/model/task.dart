import 'package:equatable/equatable.dart';
import 'package:tasker/model/subtask.dart';

///
/// Class representing the task model
///
/// [id] represent the id if the task in the db
///
/// [title] represent name of the task,[body] represent the description of the
/// task and [isCompleted] represent the state of the task, if false the task
/// is not completed if true task is completed.
///
class Task extends Equatable {
  /// The id of the task in the db
  final String id;

  /// Title of the task
  final String title;

  /// The main text of the task, mostly contain description of the task
  final String body;

  /// Current state of the task
  final bool isCompleted;

  final List<Subtask> subtasks;

  Task({
    this.id,
    this.title,
    this.body,
    this.isCompleted,
    this.subtasks,
  });

  @override
  List<Object> get props => [title, body, isCompleted, subtasks];

  Task copyWith(
      {String id,
      String title,
      String body,
      bool isCompleted,
      List<Subtask> subtasks}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isCompleted: isCompleted ?? this.isCompleted,
      subtasks: subtasks ?? this.subtasks,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    List<Subtask> sub = [];

    if (map['subtasks'] != null) {
      map['subtasks'].forEach((v) {
        sub.add(new Subtask.fromMap(v));
      });
    }

    return Task(
      title: map['title'] ?? "",
      body: map['body'] ?? "",
      isCompleted: map['isCompleted'] ?? false,
      subtasks: map['subtasks'] != null
          ? List<Subtask>.from(
              map['subtasks'].map((subtask) => Subtask.fromMap(subtask)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "body": this.body,
      "isCompleted": this.isCompleted,
      "subtasks": subtasks != null
          ? subtasks.map((subtask) => subtask.toMap()).toList()
          : null,
    };
  }
}
