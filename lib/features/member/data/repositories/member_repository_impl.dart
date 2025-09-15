import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/member/data/repositories/member_repository.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  final SupabaseClient supabase;
  final Box<GroupMember> memberBox;

  MemberRepositoryImpl({required this.supabase, required this.memberBox});

  @override
  Future<void> inviteMember(int groupId, String username) async {
    try {
      await supabase.rpc('invite_member_to_group', params: {
        'p_group_id': groupId,
        'p_invited_username': username,
      });
    } on PostgrestException catch (e) {
      debugPrint('Supabase error inviting member: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error inviting member: $e');
      throw Exception('Failed to send invitation. Check your connection');
    }
  }

  @override
  Future<List<GroupMember>> getGroupMembers(int groupId) async {
    try {
      final data = await supabase.rpc('get_group_members', params: {
        'p_group_id': groupId,
      });
      final members = (data as List).map((item) => GroupMember.fromMap(item)).toList();

      final oldMemberKeys = memberBox.values
        .where((member) => member.groupId == groupId)
        .map((member) => member.key)
        .toList();
      await memberBox.deleteAll(oldMemberKeys);
      await memberBox.addAll(members);

      return members;
    } on PostgrestException catch (e) {
      debugPrint('Supabase error fetching group members: ${e.message}');
      return memberBox.values.where((member) => member.groupId == groupId).toList();
    } catch (e) {
      debugPrint('Generic error fetching group members: $e');
      return memberBox.values.where((member) => member.groupId == groupId).toList();
    }
  }

  @override
  Future<void> updateMemberRole(int groupId, String memberId, String newRole) async {
    try {
      await supabase.rpc('update_member_role', params: {
        'p_group_id': groupId,
        'p_member_id': memberId,
        'p_new_role': newRole,
      });
    } on PostgrestException catch (e) {
      debugPrint('Supabase error updating member role: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error updating member role: $e');
      throw Exception("Failed to update member role. Check your connection");
    }
  }

  @override
  Future<void> removeMember(int groupId, String memberId) async {
    try {
      await supabase.rpc('remove_member_from_group', params: {
        'p_group_id': groupId,
        'p_member_id': memberId,
      });
    } on PostgrestException catch (e) {
      debugPrint('Supabase error removing member: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error removing member: $e');
      throw Exception("Failed to remove member. Check your connection");
    }
  }
}