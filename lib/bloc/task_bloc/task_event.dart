part of 'task_bloc.dart';

///
/// This class the task that will executed by the task bloc
///
abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskEventGetTasks extends TaskEvent {}

class TaskEventSortAscending extends TaskEvent {}

class TaskEventSortDescending extends TaskEvent {}

class TaskEventHideCompleted extends TaskEvent {}

class TaskEventShowCompleted extends TaskEvent {}

class TaskEventUpdateStream extends TaskEvent {
  final List<Task> tasks;

  TaskEventUpdateStream({this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskEventDeleteTask extends TaskEvent {
  final String taskId;

  TaskEventDeleteTask({this.taskId});

  @override
  List<Object> get props => [taskId];
}

class TaskEventChangeTaskState extends TaskEvent {
  final Task task;

  TaskEventChangeTaskState({this.task});

  @override
  // TODO: implement props
  List<Object> get props => [task];
}

class TaskEventChangeSubTaskState extends TaskEvent {
  final Task task;
  final Subtask subtask;
  final int index;

  TaskEventChangeSubTaskState({this.task, this.subtask, this.index});

  @override
  List<Object> get props => [task, subtask, index];
}
