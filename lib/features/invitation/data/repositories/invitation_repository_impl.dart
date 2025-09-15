import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/invitation/data/repositories/invitation_repository.dart';
import 'package:experiment_app/features/invitation/data/models/invitation_model.dart';

class InvitationRepositoryImpl implements InvitationRepository {
  final SupabaseClient supabase;
  InvitationRepositoryImpl({required this.supabase});

  @override
  Future<List<Invitation>> getMyPendingInvitations() async {
    try {
      final data = await supabase.rpc('get_my_pending_invitations');

      final dataList = data as List;
      return dataList.map((item) => Invitation.fromMap(item)).toList();
    } on PostgrestException catch (e) {
      debugPrint('Supabase error fetching invitations: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error fetching invitations: $e');
      throw Exception('Failed to fetch invitations. Check your connection');
    }
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    try {
      await supabase.rpc('accept_invitation', params: {
        'p_invitation_id': invitationId,
      });
    } on PostgrestException catch (e) {
      debugPrint('Supabase error accepting invitation: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error accepting invitation: $e');
      throw Exception('Failed to accept invitation. Check your connection');
    }
  }

  @override
  Future<void> declineInvitation(String invitationId) async {
    try {
      await supabase.rpc('decline_invitation', params: {
        'p_invitation_id': invitationId,
      });
    } on PostgrestException catch (e) {
      debugPrint('Supabase error declining invitation: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      debugPrint('Generic error declining invitation: $e');
      throw Exception('Failed to decline invitation. Check your connection');
    }
  }
}