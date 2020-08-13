import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/task_bloc/task_bloc.dart';
import 'package:tasker/config/router.dart';
import 'package:tasker/view/tasks_list_view.dart';
import 'package:tasker/widget/error_message.dart';

///
/// Screen to represent main content of the application
/// after application is open will navigate to this screen
///
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.bloc<TaskBloc>().add(TaskEventGetTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        if (state is TaskStateLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TaskStateLoaded) {
          return TasksListView(tasks: state.tasks);
        }
        if (state is TaskStateError) {
          return ErrorMessage();
        }

        return Container();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text("New Task"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(Router.NEW_TASK_SCREEN);
        },
      ),
    );
  }
}
