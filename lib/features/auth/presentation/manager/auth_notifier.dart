import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/injection.dart';

class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _authSubscription;

  AuthNotifier() {
    _authSubscription = getIt<SupabaseClient>().auth.onAuthStateChange.listen(
      (data) {
        notifyListeners();
      }
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}