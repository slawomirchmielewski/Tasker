import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/task_bloc/task_bloc.dart';
import 'package:tasker/config/router.dart';
import 'package:tasker/model/task.dart';
import 'package:tasker/view/tasks_list_view.dart';

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
      body: BlocBuilder<TaskBloc, List<Task>>(builder: (context, tasks) {
        if (tasks == null) {
          return Center(child: CircularProgressIndicator());
        }

        return TasksListView(tasks: tasks);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(Router.NEW_TASK_SCREEN);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text("Tasks",
                                style: TextStyle()
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                          ListTile(
                            title: Text("Show completed tasks"),
                            leading: Icon(Icons.visibility),
                            onTap: () {
                              context
                                  .bloc<TaskBloc>()
                                  .add(TaskEventShowCompleted());
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text("Hide completed tasks"),
                            leading: Icon(Icons.visibility_off),
                            onTap: () {
                              context
                                  .bloc<TaskBloc>()
                                  .add(TaskEventHideCompleted());
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text("Sort ascending"),
                            leading: Icon(Icons.sort_by_alpha),
                            onTap: () {
                              context
                                  .bloc<TaskBloc>()
                                  .add(TaskEventSortAscending());
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text("Sort descending"),
                            leading: Icon(Icons.sort_by_alpha),
                            onTap: () {
                              context
                                  .bloc<TaskBloc>()
                                  .add(TaskEventSortDescending());
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
