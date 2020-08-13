import 'package:flutter/material.dart';
import 'package:tasker/bloc/task_bloc/task_bloc.dart';
import 'package:tasker/config/dims.dart';
import 'package:tasker/model/task.dart';
import 'package:tasker/widget/task_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksListView extends StatelessWidget {
  final List<Task> tasks;

  TasksListView({Key key, this.tasks})
      : assert(tasks != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dims.small),
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskCard(
        title: Text(tasks[index].title),
        body: tasks[index].body != "" ? Text(tasks[index].body) : null,
        isCompleted: tasks[index].isCompleted,
        subtasks: tasks[index].subtasks,
        onDismissed: () {
          context
              .bloc<TaskBloc>()
              .add(TaskEventDeleteTask(taskId: tasks[index].id));
        },
        onSubtaskIconClicked: (subtask, i) {
          context.bloc<TaskBloc>().add(
                TaskEventChangeSubTaskState(
                    task: tasks[index], subtask: subtask, index: i),
              );
        },
        onTaskIconClicked: () => context.bloc<TaskBloc>().add(
              TaskEventChangeTaskState(task: tasks[index]),
            ),
      ),
    );
  }
}
