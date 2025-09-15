import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/data/repositories/task_repository.dart';

import 'package:experiment_app/features/task/data/models/user_task_model.dart';

enum NotifierState { initial, loading, loaded, error }

class TaskNotifier extends ChangeNotifier {
  final TaskRepository _repository;
  TaskNotifier(this._repository);

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String? _myRole;
  String? get myRole => _myRole;

  NotifierState _myTasksState = NotifierState.initial;
  NotifierState get myTasksState => _myTasksState;

  List<UserTask> _myTasks =[];
  List<UserTask> get myTasks => _myTasks;

  String _myTasksErrorMessage = '';
  String get myTaskErrorMessage => _myTasksErrorMessage;

  Future<void> fetchTasks(int groupId) async {
    _state = NotifierState.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.getTasksForGroup(groupId),
        _repository.getMyRole(groupId),
      ]);

      _tasks = results[0] as List<Task>;
      _myRole = results[1] as String?;
      _state = NotifierState.loaded;
    } catch (e) {
      _state = NotifierState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchMyTasks() async {
    _myTasksState = NotifierState.loading;
    notifyListeners();
    try {
      _myTasks = await _repository.getMyTasks();
      _myTasksState = NotifierState.loaded;
    } catch (e) {
      _myTasksState = NotifierState.error;
      _myTasksErrorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> addTask(int groupId, String name, {String? description}) async {
    try {
      await _repository.createTask(groupId, name, description: description);
      await fetchTasks(groupId);
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> updateTask(
    int groupId, {
    required int taskId,
    String? name,
    String? description,
    String? attachment,
    int? progress,
    DateTime? date,
    TimeOfDay? time,
  }) async {
    try {
      await _repository.updateTask(
        taskId: taskId,
        name: name,
        description: description,
        attachment: attachment,
        progress: progress,
        date: date,
        time: time,
      );
      await fetchTasks(groupId);
    } catch (e) {
      debugPrint('Error updating task: $e');
    }
  }

  Future<void> removeTask(int taskId, int groupId) async {
    try {
      await _repository.deleteTask(taskId);
      await fetchTasks(groupId);
    } catch (e) {
      debugPrint('Error removing task: $e');
    }
  }
}