import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class TaskRepository {
  Firestore _firestore;

  TaskRepository({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final String tasks = "tasks";

  /// Add new task to the db
  Future<bool> addTask(Map<String, dynamic> map) async {
    return await _firestore
        .collection(tasks)
        .add(map)
        .then((value) => true)
        .catchError((_) => false);
  }

  /// Get stream of all tasks
  Stream<QuerySnapshot> getTasks() {
    return _firestore.collection(tasks).snapshots();
  }

  /// Get task once per request
  Future<QuerySnapshot> getTasksAsync() async {
    return _firestore.collection(tasks).getDocuments();
  }

  /// Get task by the by its id that match the document id in the db
  Future<DocumentSnapshot> getTaskById(String taskId) {
    return _firestore.collection(tasks).document(taskId).get();
  }

  /// Delete task with provided id
  Future<bool> deleteTask(String tasksId) async {
    return await _firestore
        .collection(tasks)
        .document(tasksId)
        .delete()
        .then((value) => true)
        .catchError((_) => false);
  }

  void updateTask(String taskId, Map<String, dynamic> map) {
    _firestore.collection(tasks).document(taskId).updateData(map);
  }
}
