import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:experiment_app/injection.dart';
import 'package:experiment_app/core/router/app_router.dart';

import 'package:experiment_app/features/task/data/repositories/task_group_repository.dart';
import 'package:experiment_app/features/task/presentation/manager/task_group_notifier.dart';
import 'package:experiment_app/features/task/data/models/task_group_model.dart';

import 'package:experiment_app/features/task/data/repositories/task_repository.dart';
import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';
import 'package:experiment_app/features/task/data/models/task_model.dart';
import 'package:experiment_app/features/task/data/models/user_task_model.dart';

import 'package:experiment_app/features/invitation/data/repositories/invitation_repository.dart';
import 'package:experiment_app/features/invitation/presentation/manager/invitation_notifier.dart';

import 'package:experiment_app/features/member/data/repositories/member_repository.dart';
import 'package:experiment_app/features/member/presentation/manager/member_notifier.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskGroupAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(GroupMemberAdapter());
  Hive.registerAdapter(UserTaskAdapter());

  await Hive.openBox<TaskGroup>('task_groups');
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<GroupMember>('group_members');
  await Hive.openBox<UserTask>('user_tasks');

  setupLocator();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (_) =>
            Connectivity().onConnectivityChanged.map(
              (event) => event.firstOrNull ?? ConnectivityResult.none
            ),
          initialData: ConnectivityResult.mobile,
        ),

        ChangeNotifierProvider(
          create: (_) => TaskGroupNotifier(getIt<TaskGroupRepository>()),
        ),

        ChangeNotifierProvider(
          create: (_) => TaskNotifier(getIt<TaskRepository>()),
        ),

        ChangeNotifierProvider(
          create: (_) => InvitationNotifier(getIt<InvitationRepository>()),
        ),

        ChangeNotifierProvider(
          create: (_) => MemberNotifier(getIt<MemberRepository>()),
        )
      ],
      child: MaterialApp.router(
        title: 'pseuDoKo',
        theme: ThemeData.dark(),
        routerConfig: router,
      ),
    );
  }
}