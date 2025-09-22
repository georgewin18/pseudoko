import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:experiment_app/features/task/data/models/user_task_model.dart';
import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key});

  @override
  State<MyTasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskNotifier>().fetchMyTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
      ),
      body: Consumer<TaskNotifier>(
        builder: (context, notifier, child) {
          if (notifier.myTasksState == NotifierState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.myTasksState == NotifierState.error) {
            return Center(
              child: Text(
                'Failed to fetch tasks: ${notifier.myTaskErrorMessage}'
              )
            );
          }
          if (notifier.myTasks.isEmpty) {
            return const Center(
              child: Text(
                "You don't have any tasks",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final myTasks = notifier.myTasks;

          return RefreshIndicator(
            onRefresh: () => notifier.fetchMyTasks(),
            child: GroupedListView<UserTask, String>(
              elements: myTasks,
              groupBy: (task) => task.groupName,
              groupSeparatorBuilder: (String groupName) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  groupName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              itemBuilder: (context, UserTask task) {
                final bool isEditor = task.myRole == 'editor';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: CheckboxListTile(
                    title: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.progress == 100
                          ? TextDecoration.lineThrough
                          : TextDecoration.none
                      ),
                    ),
                    subtitle: task.description != null && task.description!.isNotEmpty
                      ? Text(
                          task.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                    value: task.progress == 100,
                    onChanged: isEditor
                      ? (bool? newValue) {
                          final newProgress = newValue == true ? 100 : 0;
                          if (task.taskGroupId != null) {
                            context.read<TaskNotifier>().updateTask(
                              task.taskGroupId!,
                              taskId: task.id,
                              progress: newProgress,
                            );
                          }
                        }
                      : null,
                  ),
                );
              },
              order: GroupedListOrder.ASC,
            ),
          );
        },
      ),
    );
  }
}