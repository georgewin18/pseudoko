import 'package:experiment_app/features/home/presentation/pages/new_home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:experiment_app/features/auth/presentation/manager/auth_notifier.dart';
import 'package:experiment_app/features/auth/presentation/pages/splash_page.dart';
import 'package:experiment_app/features/auth/presentation/pages/signin_page.dart';
import 'package:experiment_app/features/auth/presentation/pages/signup_page.dart';

import 'package:experiment_app/features/invitation/presentation/pages/invitation_page.dart';

import 'package:experiment_app/features/task/presentation/pages/home_page.dart';
import 'package:experiment_app/features/task/presentation/pages/detail_group_page.dart';
import 'package:experiment_app/features/task/presentation/pages/add_task_page.dart';

import 'package:experiment_app/features/profile/presentation/pages/profile_page.dart';
import 'package:experiment_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:experiment_app/features/profile/presentation/pages/change_password_page.dart';

import 'package:experiment_app/injection.dart';
import 'package:experiment_app/core/router/shell_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',

  refreshListenable: getIt<AuthNotifier>(),

  redirect: (context, state) {
    final session = getIt<SupabaseClient>().auth.currentSession;
    final isLoggedIn = session != null;

    final onAuthRoute =
      state.matchedLocation == '/sign-in' ||
      state.matchedLocation == '/sign-up';

    if (isLoggedIn && onAuthRoute) {
      return '/home';
    }

    if (!isLoggedIn && !onAuthRoute) {
      if (state.matchedLocation == '/') {
        return '/sign-in';
      }
      return '/sign-in';
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
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),

    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpPage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return ShellPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),

        GoRoute(
          path: '/my-tasks',
          builder: (context, state) => const NewHomePage(),
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'edit-profile',
              builder: (context, state) => const EditProfilePage(),
            ),

            GoRoute(
              path: 'change-password',
              builder: (context, state) => const ChangePasswordPage(),
            )
          ]
        ),
      ],
    ),

    GoRoute(
      path: '/group/:groupId',
      builder: (context, state) {
        final groupId = int.parse(state.pathParameters['groupId']!);
        final extra = state.extra as Map<String, dynamic>;
        return DetailGroupPage(
          taskGroupId: groupId,
          groupName: extra['groupName'] as String,
          description: extra['description'] as String,
          ownerId: extra['ownerId'] as String,
        );
      },
      routes: [
        GoRoute(
          path: 'add-task',
          builder: (context, state) {
            final groupId = int.parse(state.pathParameters['groupId']!);
            return AddTaskPage(taskGroupId: groupId);
          }
        )
      ]
    ),

    GoRoute(
      path: '/invitations',
      builder: (context, state) => const InvitationPage(),
    ),
  ]
);