import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

import 'package:experiment_app/features/task/data/repositories/task_group_repository.dart';
import 'package:experiment_app/features/task/data/repositories/task_group_repository_impl.dart';
import 'package:experiment_app/features/task/data/models/task_group_model.dart';
import 'package:experiment_app/features/auth/presentation/manager/auth_notifier.dart';

import 'package:experiment_app/features/task/data/repositories/task_repository.dart';
import 'package:experiment_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/data/models/user_task_model.dart';

import 'package:experiment_app/features/invitation/data/repositories/invitation_repository.dart';
import 'package:experiment_app/features/invitation/data/repositories/invitation_repository_impl.dart';

import 'package:experiment_app/features/member/data/repositories/member_repository.dart';
import 'package:experiment_app/features/member/data/repositories/member_repository_impl.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getIt.registerLazySingleton<TaskGroupRepository>(
    () => TaskGroupRepositoryImpl(
      supabase: getIt<SupabaseClient>(),
      taskGroupBox: getIt<Box<TaskGroup>>(),
    ),
  );

  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      supabase: getIt<SupabaseClient>(),
      taskBox: getIt<Box<Task>>(),
      userTaskBox: getIt<Box<UserTask>>(),
    ),
  );

  getIt.registerLazySingleton<InvitationRepository>(
    () => InvitationRepositoryImpl(supabase: getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(
      supabase: getIt<SupabaseClient>(),
      memberBox: getIt<Box<GroupMember>>(),
    ),
  );

  getIt.registerLazySingleton<AuthNotifier>(
    () => AuthNotifier()
  );

  getIt.registerLazySingleton<Box<TaskGroup>>(() => Hive.box('task_groups'));

  getIt.registerLazySingleton<Box<Task>>(() => Hive.box('tasks'));

  getIt.registerLazySingleton<Box<GroupMember>>(() => Hive.box('group_members'));

  getIt.registerLazySingleton<Box<UserTask>>(() => Hive.box('user_tasks'));
}