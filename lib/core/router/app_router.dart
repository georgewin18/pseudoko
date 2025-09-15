import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/auth/presentation/manager/auth_notifier.dart';
import 'package:experiment_app/features/auth/presentation/pages/splash_page.dart';
import 'package:experiment_app/features/auth/presentation/pages/login_page.dart';
import 'package:experiment_app/features/auth/presentation/pages/register_page.dart';

import 'package:experiment_app/features/invitation/presentation/pages/invitation_page.dart';

import 'package:experiment_app/features/task/presentation/pages/home_page.dart';
import 'package:experiment_app/features/task/presentation/pages/my_task_page.dart';
import 'package:experiment_app/features/task/presentation/pages/task_detail_page.dart';

import 'package:experiment_app/injection.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',

  refreshListenable: getIt<AuthNotifier>(),

  redirect: (context, state) {
    final session = getIt<SupabaseClient>().auth.currentSession;
    final isLoggedIn = session != null;

    final onAuthRoute =
      state.matchedLocation == '/login' ||
      state.matchedLocation == '/register';

    if (isLoggedIn && onAuthRoute) {
      return '/home';
    }

    if (!isLoggedIn && !onAuthRoute) {
      if (state.matchedLocation == '/') {
        return '/login';
      }
      return '/login';
    }

    if (isLoggedIn && state.matchedLocation == '/') {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'group/:groupId',
          builder: (context, state) {
            final groupId = int.parse(state.pathParameters['groupId']!);
            final extra = state.extra as Map<String, dynamic>;
            return TaskDetailPage(
              taskGroupId: groupId,
              groupName: extra['groupName'],
              ownerId: extra['ownerId'],
            );
          }
        ),
      ],
    ),
    GoRoute(
      path: '/my-tasks',
      builder: (context, state) => const MyTasksPage(),
    ),

    GoRoute(
      path: '/invitations',
      builder: (context, state) => const InvitationPage(),
    ),
  ]
);