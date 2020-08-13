import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasker/model/subtask.dart';
import 'package:tasker/model/task.dart';
import 'package:tasker/repository/tasks_repository.dart';
import 'package:meta/meta.dart';

part 'new_task_event.dart';
part 'new_task_state.dart';

///
/// Class representing bloc for the creation of new task
///
class NewTaskBloc extends Bloc<NewTaskEvent, NewTaskState> {
  TaskRepository _taskRepository;

  NewTaskBloc({@required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(NewTaskStateInitial());

  String _title = "";
  List<Subtask> _subtasks = [];

  @override
  void onEvent(NewTaskEvent event) {
    super.onEvent(event);
    if (event is NewTaskEventSetTitle) {
      _title = event.title;
    } else if (event is NewTaskEventAddTask) {
      _taskRepository.addTask(Task(title: _title, subtasks: _subtasks).toMap());
    }
  }

  @override
  Stream<NewTaskState> mapEventToState(
    NewTaskEvent event,
  ) async* {
    if (event is NewTaskEventAddSubtask) {
      _subtasks.add(event.subtask);
      yield NewTaskStateSubtaskAdded();
    } else if (event is NewTaskEventRemoveSubtask) {
      _subtasks.removeAt(0);
      yield NewTaskStateSubtaskRemoved();
    } else if (event is NewTaskEventInit) {
    } else if (event is NewTaskEventUpdateSubtask) {
      _subtasks = event.subtasks;
      yield NewTaskStateSubtaskUpdated();
    }

    yield NewTaskStateTaskUpdated(title: _title, subtasks: _subtasks);
  }
}
