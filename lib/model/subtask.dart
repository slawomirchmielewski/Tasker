import 'package:equatable/equatable.dart';

class Subtask extends Equatable {
  final String title;
  final bool isCompleted;

  Subtask({this.isCompleted, this.title});

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      title: map["title"] ?? "",
      isCompleted: map["isCompleted"] ?? false,
    );
  }

  Subtask copyWith({String title, bool isCompleted}) {
    return Subtask(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": this.title,
      "isCompleted": this.isCompleted,
    };
  }

  @override
  List<Object> get props => [title, isCompleted];
}
