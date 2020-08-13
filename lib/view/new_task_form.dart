import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/new_task_bloc/new_task_bloc.dart';
import 'package:tasker/config/dims.dart';
import 'package:tasker/model/subtask.dart';

class NewTaskForm extends StatefulWidget {
  NewTaskForm({Key key}) : super(key: key);

  @override
  _NewTaskFormState createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  TextEditingController _taskEditingController;
  TextEditingController _subtaskEditingController;

  bool _isNewSubtaskCompleted = false;

  @override
  void initState() {
    super.initState();
    context.bloc<NewTaskBloc>().add(NewTaskEventInit());
    _taskEditingController = TextEditingController();
    _taskEditingController.addListener(() {
      context
          .bloc<NewTaskBloc>()
          .add(NewTaskEventSetTitle(title: _taskEditingController.text));
    });
    _subtaskEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewTaskBloc, NewTaskState>(builder: (context, state) {
      if (state is NewTaskStateTaskUpdated) {
        print(state.subtasks.length);

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dims.medium),
              child: TextFormField(
                controller: _taskEditingController,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                    hintText: "Title", border: InputBorder.none),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    state.subtasks == null ? 1 : state.subtasks.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.subtasks.length) {
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(_isNewSubtaskCompleted == true
                            ? CupertinoIcons.check_mark_circled
                            : CupertinoIcons.circle),
                        onPressed: () {
                          setState(() {
                            _isNewSubtaskCompleted = !_isNewSubtaskCompleted;
                          });
                        },
                      ),
                      title: TextFormField(
                        controller: _subtaskEditingController,
                        decoration: InputDecoration(
                            hintText: "New subtask", border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        icon: Icon(CupertinoIcons.add),
                        onPressed: () {
                          if (_subtaskEditingController.text != "") {
                            context.bloc<NewTaskBloc>().add(
                                  NewTaskEventAddSubtask(
                                    subtask: Subtask(
                                      title: _subtaskEditingController.text,
                                      isCompleted: _isNewSubtaskCompleted,
                                    ),
                                  ),
                                );
                            setState(() {
                              _subtaskEditingController.text = "";
                              _isNewSubtaskCompleted = false;
                            });
                          }
                        },
                      ),
                    );
                  }
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(state.subtasks[index].isCompleted == true
                          ? CupertinoIcons.check_mark_circled
                          : CupertinoIcons.circle),
                      onPressed: () {
                        Subtask subtask = state.subtasks[index].copyWith(
                            isCompleted: !state.subtasks[index].isCompleted);

                        state.subtasks[index] = subtask;

                        context.bloc<NewTaskBloc>().add(
                              NewTaskEventUpdateSubtask(
                                  subtasks: state.subtasks),
                            );
                      },
                    ),
                    title: Text(state.subtasks[index].title),
                    trailing: IconButton(
                      onPressed: () {
                        if (state.subtasks.length > 0) {
                          context
                              .bloc<NewTaskBloc>()
                              .add(NewTaskEventRemoveSubtask(index: 0));
                        }
                      },
                      icon: Icon(CupertinoIcons.delete),
                    ),
                  );
                })
          ],
        );
      }

      return Container();
    });
  }
}
