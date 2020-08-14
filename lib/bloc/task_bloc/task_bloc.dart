import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
class TaskBloc extends Bloc<TaskEvent, List<Task>> {
  final TaskRepository _taskRepository;

  TaskBloc({@required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(null);

  List<Task> _tasks;
  List<Task> _uncompletedTask;

  bool _completedTaskVisible = true;

  bool _isSortedAscending;

  StreamSubscription _tasksStreamSubscription;

  @override
  void onEvent(TaskEvent event) {
    super.onEvent(event);
    if (event is TaskEventGetTasks) {
      _fetchTasks();
    } else if (event is TaskEventChangeTaskState) {
      _updateTaskTate(event.task);
    } else if (event is TaskEventDeleteTask) {
      _deleteTask(event.taskId);
    } else if (event is TaskEventHideCompleted) {
      _hideCompletedTasks();
    } else if (event is TaskEventShowCompleted) {
      _showCompletedTasks();
    }
  }

  @override
  Stream<List<Task>> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is TaskEventUpdateStream) {
      yield* _mapTaskEventUpdateStreamToState(event.tasks);
    } else if (event is TaskEventChangeSubTaskState) {
      yield* _mapTaskEventChangeSubTaskToState(
          event.task, event.subtask, event.index);
    } else if (event is TaskEventSortAscending) {
      yield* _mapTaskEventSortAscendingToState();
    } else if (event is TaskEventSortDescending) {
      yield* mapTaskEventSortDescendingToState();
    }
  }

  void _fetchTasks() {
    if (_tasks == null) {
      try {
        _tasksStreamSubscription?.cancel();
        _tasksStreamSubscription =
            _taskRepository.getTasks().listen((snapshot) {
          _getTask(snapshot);
        });
      } catch (_) {
        print("Something wrong");
      }
    }
  }

  @override
  Future<void> close() {
    _tasksStreamSubscription.cancel();
    return super.close();
  }

  Stream<List<Task>> _mapTaskEventUpdateStreamToState(List<Task> tasks) async* {
    yield tasks;
  }

  void _updateTaskTate(Task task) {
    bool isCompleted = !task.isCompleted;

    _taskRepository.updateTask(
        task.id, task.copyWith(isCompleted: isCompleted).toMap());
  }

  Stream<List<Task>> _mapTaskEventChangeSubTaskToState(
      Task task, Subtask subtask, int index) async* {
    List<Subtask> subtasks = task.subtasks;

    Subtask s = subtasks[index].copyWith(isCompleted: !subtask.isCompleted);

    subtasks[index] = s;

    _taskRepository.updateTask(
        task.id, task.copyWith(subtasks: subtasks).toMap());

    _taskRepository.getTasksAsync().then((snapshot) {
      _getTask(snapshot);
    });
  }

  void _getTask(QuerySnapshot snapshot) {
    _tasks = [];
    _uncompletedTask = [];

    if (snapshot.documents != null) {
      for (var document in snapshot.documents) {
        Task task = Task.fromMap(document.data);
        _tasks.add(task.copyWith(id: document.documentID));
      }
    }

    _uncompletedTask =
        _tasks.where((element) => element.isCompleted == false).toList();

    if (_isSortedAscending == true) {
      _sortAscending();
    } else if (_isSortedAscending == false) {
      _sortDescending();
    }

    add(TaskEventUpdateStream(
        tasks: _completedTaskVisible == false ? _uncompletedTask : _tasks));
  }

  void _deleteTask(String taskId) {
    _taskRepository.deleteTask(taskId);
  }

  Stream<List<Task>> _mapTaskEventSortAscendingToState() async* {
    _isSortedAscending = true;
    _sortAscending();
    yield _completedTaskVisible == false
        ? List.from(_uncompletedTask)
        : List.from(_tasks);
  }

  Stream<List<Task>> mapTaskEventSortDescendingToState() async* {
    _isSortedAscending = false;
    _sortDescending();
    yield _completedTaskVisible == false
        ? List.from(_uncompletedTask)
        : List.from(_tasks);
  }

  void _sortAscending() {
    _tasks.sort((a, b) => a.title.compareTo(b.title));
    _uncompletedTask.sort((a, b) => a.title.compareTo(b.title));
  }

  void _sortDescending() {
    _tasks.sort((a, b) => b.title.compareTo(a.title));
    _uncompletedTask.sort((a, b) => b.title.compareTo(a.title));
  }

  void _hideCompletedTasks() {
    _completedTaskVisible = false;
    add(TaskEventUpdateStream(
        tasks: _completedTaskVisible == false ? _uncompletedTask : _tasks));
  }

  void _showCompletedTasks() {
    _completedTaskVisible = true;
    add(TaskEventUpdateStream(
        tasks: _completedTaskVisible == false ? _uncompletedTask : _tasks));
  }
}
