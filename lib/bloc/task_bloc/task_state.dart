part of 'task_bloc.dart';

///
/// Class to represent state of the task bloc
///
abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskStateInitial extends TaskState {}

class TaskStateLoading extends TaskState {}

class TaskStateError extends TaskState {}

class TaskStateLoaded extends TaskState {
  final List<Task> tasks;

  TaskStateLoaded({this.tasks});
  @override
  List<Object> get props => [tasks];
}

class TaskStateAdded extends TaskState {
  final Task task;

  TaskStateAdded({this.task});

  @override
  List<Object> get props => [task];
}

class TaskStateDeleted extends TaskState {
  final Task task;

  TaskStateDeleted({this.task});

  @override
  List<Object> get props => [task];
}
