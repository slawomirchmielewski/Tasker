import 'package:flutter/material.dart';
import 'package:tasker/screen/home_screen.dart';
import 'package:tasker/screen/new_task_screen.dart';
import 'package:tasker/screen/task_screen.dart';

class Router {
  static const String HOME_SCREEN = '/home';
  static const String TASK_SCREEN = '/task';
  static const String NEW_TASK_SCREEN = '/newTask';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case TASK_SCREEN:
        return MaterialPageRoute(builder: (_) => TaskScreen());
      case NEW_TASK_SCREEN:
        return MaterialPageRoute(builder: (_) => NewTaskScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
