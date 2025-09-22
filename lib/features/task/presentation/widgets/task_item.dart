import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class TaskItem extends StatelessWidget {
  final VoidCallback onTap;
  final String taskName;
  final TimeOfDay? taskTime;
  final String? taskDescription;
  final String? taskAttachment;
  final int taskProgress;

  const TaskItem({
    super.key,
    required this.onTap,
    required this.taskName,
    this.taskTime,
    this.taskDescription,
    this.taskAttachment,
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

                      if (taskDescription != null && taskDescription!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            taskDescription!,
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

            if (taskAttachment != null && taskAttachment!.isNotEmpty) ...[
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  debugPrint('Attachment clicked: $taskAttachment');
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      )
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.paperclip,
                        color: Colors.lightBlueAccent,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],

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