import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:flutter/foundation.dart';

import 'package:experiment_app/features/member/data/repositories/member_repository.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';

class MemberNotifier extends ChangeNotifier {
  final MemberRepository _repository;
  MemberNotifier(this._repository);

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;

  List<GroupMember> _members = [];
  List<GroupMember> get members => _members;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchMembers(int groupId) async {
    _state = NotifierState.loading;
    notifyListeners();

    try {
      _members = await _repository.getGroupMembers(groupId);
      _state = NotifierState.loaded;
    } catch (e) {
      _state = NotifierState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> inviteMember(int groupId, String username) async {
    try {
      await _repository.inviteMember(groupId, username);
    } catch (e) {
      debugPrint("Error inviting member: $e");
    }
  }

  Future<void> updateRole(int groupId, String memberId, String newRole) async {
    try {
      await _repository.updateMemberRole(groupId, memberId, newRole);
      await fetchMembers(groupId);
    } catch (e) {
      debugPrint('Error updating member role: $e');
    }
  }

  Future<void> removeMember(int groupId, String memberId) async {
    try {
      final memberIndex = _members.indexWhere((member) => member.userId == memberId);
      if (memberIndex != -1) {
        _members.removeAt(memberIndex);
        notifyListeners();
      }

      await _repository.removeMember(groupId, memberId);
    } catch (e) {
      debugPrint('Error removing member: $e');
      await fetchMembers(groupId);
    }
  }
}