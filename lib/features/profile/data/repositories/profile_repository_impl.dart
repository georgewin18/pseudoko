import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:experiment_app/features/profile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient supabase;
  ProfileRepositoryImpl({required this.supabase});

  @override
  Future<void> updateUsername(String newUsername) async {
    await supabase.rpc('update_my_username', params: {
      'p_new_username': newUsername
    });
  }
}