import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:experiment_app/features/task/data/models/task_group_model.dart';
import 'package:experiment_app/features/task/presentation/manager/task_group_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskGroupNotifier>().fetchTaskGroups();
    });
  }

  void _showGroupDialog({TaskGroup? group}) async {
    final isEditing = group != null;
    final nameController = TextEditingController(text: group?.name);
    final descriptionController = TextEditingController(text: group?.description);

    showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Group' : 'Create New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();

                if (name.isNotEmpty) {
                  final notifier = context.read<TaskGroupNotifier>();
                  final connectivity = context.read<ConnectivityResult>();

                  if (connectivity == ConnectivityResult.none) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No internet connection. Can't save group"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  if (isEditing) {
                    notifier.updateGroup(group.id, name, description);
                  } else {
                    notifier.addGroup(name, description);
                  }
                  context.pop();
                }
              },
              child: const Text('Save'),
            )
          ],
        );
      }
    );
  }

  void _deleteGroup(TaskGroup group) async {
    final connectivity = context.read<ConnectivityResult>();
    if (connectivity == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection. Can't delete group"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
            'Are you sure you want to delete ${group.name}? All tasks within this group will also be deleted.'
        ),
        actions: [
          TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Cancel')
          ),
          TextButton(
              onPressed: () => context.pop(true),
              child: const Text('Delete')
          ),
        ],
      )
    );

    if (mounted && confirmed == true) {
      try {
        await  context.read<TaskGroupNotifier>().deleteGroup(group.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${group.name}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete group: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<TaskGroupNotifier>().fetchTaskGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = context.watch<ConnectivityResult>();
    final isOnline = connectivityStatus != ConnectivityResult.none;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOnline ? 'Task Groups' : 'Task Groups (Offline)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Invitations',
            onPressed: () {
              context.push('/invitations');
            },
          ),
        ],
      ),
      body: Consumer<TaskGroupNotifier>(
        builder: (context, notifier, child) {
          if (notifier.state == NotifierState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.state == NotifierState.error) {
            return Center(child: Text('Error: ${notifier.errorMessage}'));
          }
          if (notifier.groups.isEmpty) {
            return const Center(child: Text('No groups found.'));
          }

          final groups = notifier.groups;
          return RefreshIndicator(
            onRefresh: () => notifier.fetchTaskGroups(),
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final bool canManageGroup = group.myRole == 'editor';

                return ListTile(
                  title: Text(group.name),
                  subtitle: Text(group.description ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    context.push(
                      '/group/${group.id}',
                      extra: {
                        'groupName': group.name,
                        'description': group.description ?? '',
                        'ownerId': group.ownerId,
                      }
                    );
                  },
                  trailing: canManageGroup
                    ? PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showGroupDialog(group: group);
                          } else if (value == 'delete') {
                            _deleteGroup(group);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red
                              ),
                            )
                          ),
                        ],
                      )
                    : null
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isOnline ? () => _showGroupDialog() : null,
        backgroundColor: isOnline ? Theme.of(context).colorScheme.primary : Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}