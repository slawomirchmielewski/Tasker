import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/bloc/simple_bloc_observer.dart';
import 'package:tasker/repository/tasks_repository.dart';
import 'package:tasker/tasker.dart';

void main() {
  // Create instance of the firestore db
  WidgetsFlutterBinding.ensureInitialized();

  final Firestore _firestore = Firestore.instance;

  // Create main bloc observer
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TaskRepository>(
          create: (context) => TaskRepository(firestore: _firestore),
        )
      ],
      child: Tasker(),
    ),
  );
}
