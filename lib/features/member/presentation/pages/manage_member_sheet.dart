import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/injection.dart';
import 'package:experiment_app/features/member/presentation/manager/member_notifier.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';

class ManageMemberSheet extends StatefulWidget {
  final int taskGroupId;
  final String ownerId;

  const ManageMemberSheet({
    super.key,
    required this.taskGroupId,
    required this.ownerId,
  });

  @override
  State<ManageMemberSheet> createState() => _ManageMemberSheetState();
}

class _ManageMemberSheetState extends State<ManageMemberSheet> {
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MemberNotifier>().fetchMembers(widget.taskGroupId);
    });
  }

  void _showInviteDialog() {
    _usernameController.clear();
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Member'),
        content: TextFormField(
          controller: _usernameController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'username'),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final username = _usernameController.text.trim();
              if (username.isEmpty) return;

              try {
                await context.read<MemberNotifier>().inviteMember(widget.taskGroupId, username);
                if (mounted) {
                  context.pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Send Invitation'),
          )
        ],
      )
    );
  }

  void _showChangeRoleDialog(GroupMember member) async {
    String selectedRole = member.role;

    final newRole = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Change Role for ${member.username}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<String>(
                    title: const Text('Editor'),
                    subtitle: const Text('Add/Manage tasks.'),
                    value: 'editor',
                    groupValue: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Viewer'),
                    subtitle: const Text('Only view tasks.'),
                    value: 'viewer',
                    groupValue: selectedRole,
                    onChanged: (String? value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    context.pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    context.pop(selectedRole);
                  },
                )
              ],
            );
          },
        );
      }
    );

    if (newRole != null && newRole != member.role) {
      context.read<MemberNotifier>().updateRole(widget.taskGroupId, member.userId, newRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = context.watch<ConnectivityResult>();
    final isOnline = connectivityStatus != ConnectivityResult.none;

    final currentUserId = getIt<SupabaseClient>().auth.currentUser!.id;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Group Members',
                style: TextStyle(fontSize: 18)
              ),
            ),
            body: Consumer<MemberNotifier>(
              builder: (context, notifier, child) {
                if (notifier.state == NotifierState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (notifier.state == NotifierState.error) {
                  return Center(child: Text('Failed to fetch members: ${notifier.errorMessage}'));
                }
                if (notifier.members.isEmpty) {
                  return const Center(child: Text('No members found.'));
                }

                final members = notifier.members;
                return ListView.builder(
                  controller: scrollController,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];

                    final bool canManage = currentUserId == widget.ownerId &&
                      member.userId != currentUserId &&
                      isOnline;

                    return ListTile(
                      title: Text(member.username),
                      subtitle: Text(member.role),

                      trailing: canManage
                        ? PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit_role') {
                              _showChangeRoleDialog(member);
                            } else if (value == 'remove') {
                              notifier.removeMember(widget.taskGroupId, member.userId);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit_role',
                              child: Text('Edit Role'),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          ],
                        )
                      : null,
                    );
                  },
                );
              },
            ),
            floatingActionButton: (currentUserId == widget.ownerId && isOnline)
              ? FloatingActionButton.extended(
                  onPressed: _showInviteDialog,
                  label: const Text('Invite'),
                  icon: const Icon(Icons.person_add),
                )
              : null,
          );
        },
      ),
    );
  }
}