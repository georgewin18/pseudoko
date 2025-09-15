import 'package:experiment_app/features/task/data/models/task_group_model.dart';

abstract class TaskGroupRepository {
  Future<List<TaskGroup>> getTaskGroups();
  Future<void> createTaskGroup(String name, String? description);
  Future<void> updateTaskGroup(int id, String name, String? description);
  Future<void> deleteTaskGroup(int id);
}