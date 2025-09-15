import 'package:experiment_app/features/member/data/models/group_member_model.dart';

abstract class MemberRepository {
  Future<void> inviteMember(int groupId, String username);
  Future<List<GroupMember>> getGroupMembers(int groupId);
  Future<void> updateMemberRole(int groupId, String memberId, String newRole);
  Future<void> removeMember(int groupId, String memberId);
}