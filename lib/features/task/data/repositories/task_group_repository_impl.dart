import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/task/data/models/task_group_model.dart';
import 'package:experiment_app/features/task/data/repositories/task_group_repository.dart';

class TaskGroupRepositoryImpl implements TaskGroupRepository {
  final SupabaseClient supabase;
  final Box<TaskGroup> taskGroupBox;

  TaskGroupRepositoryImpl({required this.supabase, required this.taskGroupBox});

  @override
  Future<List<TaskGroup>> getTaskGroups() async {
    try {
      final data = await supabase.rpc('get_my_task_groups');
      final groups = (data as List).map((item) => TaskGroup.fromMap(item)).toList();

      await taskGroupBox.clear();
      await taskGroupBox.addAll(groups);

      return groups;
    } catch (e) {
      debugPrint("Failed to fetch from network, using local cache: $e");
      return taskGroupBox.values.toList();
    }
  }

  @override
  Future<void> createTaskGroup(String name, String? description) async {
    try {
      await supabase.rpc('create_new_task_group', params: {
        'name': name,
        'description': description,
      });
    } catch (e) {
      throw Exception('Failed to create task group: $e');
    }
  }

  @override
  Future<void> updateTaskGroup(int id, String name, String? description) async {
    try {
      await supabase.rpc('update_my_task_group', params: {
        'task_group_id': id,
        'new_name': name,
        'new_description': description,
      });
    } catch (e) {
      throw Exception('Failed to update task group: $e');
    }
  }

  @override
  Future<void> deleteTaskGroup(int id) async {
    try {
      await supabase.rpc('delete_my_task_group', params: {
        'task_group_id': id,
      });
    } catch (e) {
      throw Exception('Failed to delete task group: $e');
    }
  }
}