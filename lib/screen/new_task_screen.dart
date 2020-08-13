import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/new_task_bloc/new_task_bloc.dart';
import 'package:tasker/repository/tasks_repository.dart';
import 'package:tasker/view/new_task_form.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TaskRepository taskRepository =
        RepositoryProvider.of<TaskRepository>(context);

    return BlocProvider<NewTaskBloc>(
      create: (context) => NewTaskBloc(taskRepository: taskRepository),
      child: Builder(
        builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text("New Task"),
              actions: [
                FlatButton(
                    child: Text(
                      "Save",
                      style: Theme.of(context).accentTextTheme.subtitle1,
                    ),
                    onPressed: () {
                      context.bloc<NewTaskBloc>().add(NewTaskEventAddTask());
                      Navigator.of(context).pop();
                    })
              ],
            ),
            body: SafeArea(
              child: NewTaskForm(),
            )),
      ),
    );
  }
}
