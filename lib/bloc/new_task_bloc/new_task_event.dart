part of 'new_task_bloc.dart';

abstract class NewTaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NewTaskEventSetTitle extends NewTaskEvent {
  final String title;

  NewTaskEventSetTitle({this.title});

  @override
  List<Object> get props => [title];
}

class NewTaskEventAddSubtask extends NewTaskEvent {
  final Subtask subtask;

  NewTaskEventAddSubtask({this.subtask});

  @override
  List<Object> get props => [subtask];
}

class NewTaskEventRemoveSubtask extends NewTaskEvent {
  final int index;

  NewTaskEventRemoveSubtask({this.index});

  @override
  List<Object> get props => [index];
}

class NewTaskEventUpdateTask extends NewTaskEvent {
  final String title;
  final List<Subtask> subtasks;

  NewTaskEventUpdateTask({this.title, this.subtasks});

  @override
  List<Object> get props => [title, subtasks];
}

class NewTaskEventUpdateSubtask extends NewTaskEvent {
  final List<Subtask> subtasks;

  NewTaskEventUpdateSubtask({this.subtasks});

  @override
  List<Object> get props => [subtasks];
}

class NewTaskEventAddTask extends NewTaskEvent {}

class NewTaskEventInit extends NewTaskEvent {}
