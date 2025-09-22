import 'package:flutter/foundation.dart';

import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:experiment_app/features/task/data/models/task_group_model.dart';
import 'package:experiment_app/features/task/data/repositories/task_group_repository.dart';

class TaskGroupNotifier extends ChangeNotifier {
  final TaskGroupRepository _repository;
  TaskGroupNotifier(this._repository);

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  List<TaskGroup> _groups = [];
  List<TaskGroup> get groups => _groups;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchTaskGroups() async {
    _state = NotifierState.loading;
    notifyListeners();
    try {
      _groups = await _repository.getTaskGroups();
      _state = NotifierState.loaded;
    } catch (e) {
      _state = NotifierState.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> addGroup(String name, String? description) async {
    try {
      await _repository.createTaskGroup(name, description);
      await fetchTaskGroups();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateGroup(int id, String name, String? description) async {
    try {
      await _repository.updateTaskGroup(id, name, description);
      await fetchTaskGroups();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> deleteGroup(int id) async {
    try {
      await _repository.deleteTaskGroup(id);
      await fetchTaskGroups();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}