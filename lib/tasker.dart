import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/task_bloc/task_bloc.dart';
import 'package:tasker/config/router.dart';
import 'package:tasker/repository/tasks_repository.dart';

///
/// Represent a main point of the application
///
/// This class is the place to create instances of all blocs
/// needed to manage the app data on the launch
///
class Tasker extends StatefulWidget {
  @override
  _TaskerState createState() => _TaskerState();
}

class _TaskerState extends State<Tasker> {
  TaskRepository _taskRepository;

  @override
  void initState() {
    super.initState();
    _taskRepository ??= RepositoryProvider.of<TaskRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(taskRepository: _taskRepository),
        )
      ],
      child: MaterialApp(
        title: 'Tasker',
        onGenerateRoute: Router.generateRoute,
        initialRoute: Router.HOME_SCREEN,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
