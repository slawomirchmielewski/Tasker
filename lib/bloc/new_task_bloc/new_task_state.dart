part of 'new_task_bloc.dart';

abstract class NewTaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewTaskStateInitial extends NewTaskState {}

class NewTaskStateSubtaskAdded extends NewTaskState {}

class NewTaskStateSubtaskRemoved extends NewTaskState {}

class NewTaskStateSubtaskUpdated extends NewTaskState {}

class NewTaskStateTaskUpdated extends NewTaskState {
  final String title;
  final List<Subtask> subtasks;

  NewTaskStateTaskUpdated({this.title, this.subtasks});

  @override
  List<Object> get props => [title, subtasks];
}
