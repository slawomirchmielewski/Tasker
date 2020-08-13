import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasker/model/subtask.dart';
import 'package:tasker/model/task.dart';
import 'package:tasker/repository/tasks_repository.dart';
import 'package:meta/meta.dart';

part 'task_event.dart';
part 'task_state.dart';

///
/// Class to represent task bloc,
///
/// This class will handle all the tasks operations
/// adding new tasks, deleting current tasks,
/// and getting task from the [_taskRepository]
///
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc({@required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TaskStateInitial());

  List<Task> _tasks;

  StreamSubscription _tasksStreamSubscription;

  @override
  void onEvent(TaskEvent event) {
    super.onEvent(event);
    if (event is TaskEventChangeTaskState) {
      _updateTaskTate(event.task);
    } else if (event is TaskEventChangeSubTaskState) {
      _updateSubtask(event.task, event.subtask, event.index);
    } else if (event is TaskEventDeleteTask) {
      _deleteTask(event.taskId);
    }
  }

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is TaskEventGetTasks) {
      yield* _mapTaskEventGetTaskToState();
    } else if (event is TaskEventUpdateStream) {
      yield* _mapTaskEventUpdateStreamToState(event.tasks);
    }
  }

  Stream<TaskState> _mapTaskEventGetTaskToState() async* {
    if (_tasks == null) {
      yield TaskStateLoading();

      try {
        _tasksStreamSubscription?.cancel();
        _tasksStreamSubscription = _taskRepository.getTasks().listen((query) {
          _tasks = [];

          if (query.documents != null) {
            for (var document in query.documents) {
              Task task = Task.fromMap(document.data);
              _tasks.add(task.copyWith(id: document.documentID));
            }
          }

          add(TaskEventUpdateStream(tasks: _tasks));
        });
      } catch (_) {
        yield TaskStateError();
      }
    }
  }

  @override
  Future<void> close() {
    _tasksStreamSubscription.cancel();
    return super.close();
  }

  Stream<TaskState> _mapTaskEventUpdateStreamToState(List<Task> tasks) async* {
    yield TaskStateLoaded(tasks: tasks);
  }

  void _updateTaskTate(Task task) {
    bool isCompleted = !task.isCompleted;

    _taskRepository.updateTask(
        task.id, task.copyWith(isCompleted: isCompleted).toMap());
  }

  void _updateSubtask(Task task, Subtask subtask, int index) {
    List<Subtask> subtasks = task.subtasks;

    Subtask s = subtasks[index].copyWith(isCompleted: !subtask.isCompleted);

    subtasks[index] = s;

    _taskRepository.updateTask(
        task.id, task.copyWith(subtasks: subtasks).toMap());

    _tasks = null;
    add(TaskEventGetTasks());
  }

  void _deleteTask(String taskId) {
    _taskRepository.deleteTask(taskId);
  }
}
