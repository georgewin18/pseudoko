import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/invitation/presentation/manager/invitation_notifier.dart';

class InvitationPage extends StatefulWidget {
  const InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvitationNotifier>().fetchMyInvitations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Invitations'),
      ),
      body: Consumer<InvitationNotifier>(
        builder: (context, notifier, child) {
          if (notifier.state == NotifierState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.state == NotifierState.error) {
            return Center(child: Text('Failed to fetch invitations: ${notifier.errorMessage}'));
          }
          if (notifier.invitations.isEmpty) {
            return const Center(child: Text('No invitations found.'));
          }

          final invitations = notifier.invitations;

          return RefreshIndicator(
            onRefresh: () => notifier.fetchMyInvitations(),
            child: ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Invitation to "${invitation.groupName}"'),
                    subtitle: Text('From: ${invitation.invitedByUsername}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            context.read<InvitationNotifier>().decline(invitation.invitationId);
                          },
                          tooltip: 'Decline',
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            context.read<InvitationNotifier>().accept(invitation.invitationId);
                          },
                          tooltip: 'Accept',
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}