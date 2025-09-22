import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final VoidCallback onTap;
  final String taskName;
  final String taskGroupName;
  final TimeOfDay? taskTime;
  final int taskProgress;

  const TaskItem({
    super.key,
    required this.onTap,
    required this.taskName,
    required this.taskGroupName,
    this.taskTime,
    required this.taskProgress,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    if (taskProgress < 50) {
      progressColor = Colors.red;
    } else if (taskProgress < 100) {
      progressColor = Colors.yellow;
    } else {
      progressColor = Colors.green;
    }

    String formattedTime = '--:--';
    if (taskTime != null) {
      final hour = taskTime!.hour.toString().padLeft(2, '0');
      final minute = taskTime!.minute.toString().padLeft(2, '0');
      formattedTime = '$hour:$minute';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade300,
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          taskGroupName,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: taskProgress / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(
                    '$taskProgress%',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}