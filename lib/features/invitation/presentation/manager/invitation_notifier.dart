import 'package:flutter/foundation.dart';

import 'package:experiment_app/features/invitation/data/repositories/invitation_repository.dart';
import 'package:experiment_app/features/invitation/data/models/invitation_model.dart';

enum NotifierState { initial, loading, loaded, error }

class InvitationNotifier extends ChangeNotifier {
  final InvitationRepository _repository;
  InvitationNotifier(this._repository);

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  List<Invitation> _invitations = [];
  List<Invitation> get invitations => _invitations;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchMyInvitations() async {
    _state = NotifierState.loading;
    notifyListeners();

    try {
      _invitations = await _repository.getMyPendingInvitations();
      _state = NotifierState.loaded;
    } catch (e) {
      _state = NotifierState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> accept(String invitationId) async {
    try {
      await _repository.acceptInvitation(invitationId);
      await fetchMyInvitations();
    } catch (e) {
      debugPrint("Error accepting invitation: $e");
      await fetchMyInvitations();
    }
  }

  Future<void> decline(String invitationId) async {
    try {
      await _repository.declineInvitation(invitationId);
      await fetchMyInvitations();
    } catch (e) {
      debugPrint("Error declining invitation: $e");
      await fetchMyInvitations();
    }
  }
}