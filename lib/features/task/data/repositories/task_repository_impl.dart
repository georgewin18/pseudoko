import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/task/data/repositories/task_repository.dart';
import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/data/models/user_task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SupabaseClient supabase;
  final Box<Task> taskBox;
  final Box<UserTask> userTaskBox;

  TaskRepositoryImpl({
    required this.supabase,
    required this.taskBox,
    required this.userTaskBox,
  });

  @override
  Future<List<Task>> getTasksForGroup(int groupId) async {
    try {
      final data = await supabase.rpc('get_tasks_for_group', params: {
        'group_id': groupId,
      });
      final tasks = (data as List).map((item) => Task.fromMap(item)).toList();

      final oldTaskKeys = taskBox.values
        .where((task) => task.taskGroupId == groupId)
        .map((task) => task.key)
        .toList();
      await taskBox.deleteAll(oldTaskKeys);
      await taskBox.addAll(tasks);

      return tasks;
    } catch (e) {
      debugPrint('Failed to fetch from network, using local cache: $e');
      return taskBox.values.where((task) => task.taskGroupId == groupId).toList();
    }
  }

  @override
  Future<void> createTask(int groupId, String name, {String? description}) async {
    try {
      await supabase.rpc('create_new_task', params: {
        'group_id': groupId,
        'task_name': name,
        'task_description': description,
      });
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<void> updateTask({
    required int taskId,
    String? name,
    String? description,
    String? attachment,
    int? progress,
    DateTime? date,
    TimeOfDay? time,
  }) async {
    try {
      await supabase.rpc('update_task', params: {
        'task_id': taskId,
        'new_name': name,
        'new_description': description,
        'new_attachment': attachment,
        'new_progress': progress,
        'new_date': date?.toIso8601String(),
        'new_time': time == null ? null : '${time.hour}:${time.minute}:00',
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(int taskId) async {
    try {
      await supabase.rpc('delete_task', params: {
        'task_id': taskId,
      });
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<String?> getMyRole(int groupId) async {
    try {
      final role = await supabase.rpc('get_my_role_in_group', params: {
        'p_group_id': groupId,
      });
      return role as String?;
    } catch (e) {
      debugPrint('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Future<List<UserTask>> getMyTasks() async {
    try {
      final data = await supabase.rpc('get_my_tasks');
      final myTasks = (data as List).map((item) => UserTask.fromMap(item)).toList();

      await userTaskBox.clear();
      await userTaskBox.addAll(myTasks);

      return myTasks;
    } catch (e) {
      debugPrint('Failed to fetch from network, using local cache: $e');
      return userTaskBox.values.toList();
    }
  }
}