import 'package:experiment_app/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/injection.dart';

class ProfileNotifier extends ChangeNotifier {
  final ProfileRepository _repository;
  ProfileNotifier(this._repository);

  User? _currentUser;
  User? get currentUser => _currentUser;

  void loadCurrentUser() {
    _currentUser = getIt<SupabaseClient>().auth.currentUser;
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    await _repository.updateUsername(newUsername);

    await getIt<SupabaseClient>().auth.updateUser(
      UserAttributes(data: {'username': newUsername}),
    );

    loadCurrentUser();
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final supabase = getIt<SupabaseClient>();
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null || currentUser.email == null) {
      throw Exception('User not found or does not have email');
    }

    try {
      await supabase.auth.signInWithPassword(
        email: currentUser.email!,
        password: currentPassword,
      );

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login credentials')) {
        throw Exception('Invalid current password');
      }
      throw Exception('Error: ${e.message}');
    } catch (e) {
      throw Exception('Something went wrong. Please try again later');
    }
  }

  Future<void> signOut() async {
    try {
      await getIt<SupabaseClient>().auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout. Please try again later');
    }
  }
}