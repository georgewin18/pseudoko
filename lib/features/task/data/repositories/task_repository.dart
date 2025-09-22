import 'package:flutter/material.dart';

import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/data/models/user_task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasksForGroup(int groupId);
  Future<void> createTask(int groupId, String name, {
    String? description,
    String? attachment,
    DateTime? deadline,
    String? repeatInterval,
  });

  Future<void> updateTask({
    required int taskId,
    String? name,
    String? description,
    String? attachment,
    int? progress,
    DateTime? date,
    TimeOfDay? time,
  });

  Future<void> deleteTask(int taskId);
  Future<String?> getMyRole(int groupId);
  Future<List<UserTask>> getMyTasks();
}