import 'package:experiment_app/features/home/presentation/widgets/task_item.dart';
import 'package:experiment_app/features/task/data/models/user_task_model.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<UserTask> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
      ? const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 32,
            ),
            child: Text(
              "No tasks yet. Create your first task!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        )
      : ListView.builder(
          padding: EdgeInsets.only(
            top: 8,
            bottom: 32
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskItem(
              onTap: () {
                debugPrint('${task.name} clicked');
              },
              taskName: task.name,
              taskTime: task.time,
              taskGroupName: task.groupName,
              taskProgress: task.progress,
            );
          },
        );
  }
}