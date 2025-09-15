import 'package:experiment_app/features/invitation/data/models/invitation_model.dart';

abstract class InvitationRepository {
  Future<List<Invitation>> getMyPendingInvitations();
  Future<void> acceptInvitation(String invitationId);
  Future<void> declineInvitation(String invitationId);
}