import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/member/presentation/pages/manage_member_sheet.dart';
import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';

class TaskDetailPage extends StatefulWidget {
  final int taskGroupId;
  final String groupName;
  final String ownerId;

  const TaskDetailPage({
    super.key,
    required this.taskGroupId,
    required this.groupName,
    required this.ownerId,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskNotifier>().fetchTasks(widget.taskGroupId);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _createTask() {
    final connectivity = context.read<ConnectivityResult>();
    if (connectivity == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection. Can't create task."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = context.read<TaskNotifier>();
    if (notifier.myRole != 'editor') return;

    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskNotifier>().addTask(widget.taskGroupId, title);
      _titleController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = context.watch<ConnectivityResult>();
    final isOnline = connectivityStatus != ConnectivityResult.none;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          IconButton(
            icon: Icon(Icons.groups),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return ManageMemberSheet(
                    taskGroupId: widget.taskGroupId,
                    ownerId: widget.ownerId,
                  );
                }
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<TaskNotifier>(
              builder: (context, notifier, child) {
                if (notifier.state == NotifierState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (notifier.state == NotifierState.error) {
                  return Center(child: Text('Error loading tasks: ${notifier.errorMessage}'));
                }
                if (notifier.tasks.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }

                final tasks = notifier.tasks;
                final bool isEditor = notifier.myRole == 'editor';

                return RefreshIndicator(
                  onRefresh: () => notifier.fetchTasks(widget.taskGroupId),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return AbsorbPointer(
                        absorbing: !isEditor,
                        child: Dismissible(
                          key: ValueKey(task.id),
                          direction: isOnline
                            ? isEditor
                              ? DismissDirection.endToStart
                              : DismissDirection.none
                            : DismissDirection.none,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            notifier.removeTask(task.id, widget.taskGroupId);
                          },
                          child: CheckboxListTile(
                            title: Text(
                              task.name,
                              style: TextStyle(
                                decoration: task.progress == 100
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                            ),
                            value: task.progress == 100,
                            onChanged: isOnline
                              ? isEditor
                                ? (bool? newValue) {
                                    final newProgress = newValue == true ? 100 : 0;
                                    notifier.updateTask(
                                      widget.taskGroupId,
                                      taskId: task.id,
                                      progress: newProgress,
                                    );
                                  }
                                : null
                              : null,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            )
          ),

          Consumer<TaskNotifier>(
            builder: (context, notifier, child) {
              if (isOnline) {
                if (notifier.myRole == 'editor') {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Enter a task',
                                border: OutlineInputBorder(),
                              ),
                              onFieldSubmitted: (_) => _createTask(),
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton.filled(
                            icon: const Icon(Icons.add),
                            onPressed: _createTask,
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
              }
            }
          ),
        ]
      ),
    );
  }
}