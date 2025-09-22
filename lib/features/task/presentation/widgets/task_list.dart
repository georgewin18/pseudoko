import 'package:flutter/material.dart';

import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/presentation/widgets/task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tasks",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(
              bottom: 8
          ),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),

        Expanded(
          child: tasks.isEmpty
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
            padding: EdgeInsets.only(bottom: 64),
            itemCount: tasks.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                onTap: () {
                  debugPrint('${task.name} clicked');
                },
                taskName: task.name,
                taskTime: task.time,
                taskDescription: task.description,
                taskAttachment: task.attachment,
                taskProgress: task.progress,
              );
            },
          ),
        ),
      ],
    );
  }
}