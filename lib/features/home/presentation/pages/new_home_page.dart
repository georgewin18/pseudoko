import 'package:experiment_app/core/utils/is_same_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:experiment_app/injection.dart';

import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:experiment_app/features/home/presentation/widgets/build_background_header.dart';
import 'package:experiment_app/features/home/presentation/widgets/build_header.dart';
import 'package:experiment_app/features/home/presentation/widgets/home_calendar.dart';
import 'package:experiment_app/features/home/presentation/widgets/task_list.dart';
import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  DateTime _selectedDate = DateTime.now();
  bool _focusedOnTask = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskNotifier>().fetchMyTasks();
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = getIt<SupabaseClient>().auth.currentUser?.userMetadata?['username'] ?? 'User';
    double headerHeight = MediaQuery.of(context).size.height * (_focusedOnTask ? 0.16 : 0.32);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildBackgroundHeader(headerHeight: headerHeight),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Consumer<TaskNotifier>(
                builder: (context, notifier, child) {
                  if (notifier.myTasksState == NotifierState.loading && notifier.myTasks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (notifier.myTasksState == NotifierState.error) {
                    return Center(child: Text('Failed to fetch tasks: ${notifier.myTaskErrorMessage}'));
                  }

                  final allMyTasks = notifier.myTasks;
                  final filteredTasks = allMyTasks.where((task) {
                    return isSameDay(task.date, _selectedDate);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      buildHeader(
                        name: name,
                        onPressed: () => debugPrint('bell pressed'),
                        isFocusedOnTask: _focusedOnTask,
                        date: _selectedDate,
                      ),

                      const SizedBox(height: 16),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: !_focusedOnTask
                          ? HomeCalendar(
                              key: const ValueKey('calendar'),
                              tasks: allMyTasks,
                              selectedDate: _selectedDate,
                              onDateSelected: _onDateSelected,
                            )
                          : const SizedBox.shrink(key: ValueKey('empty')),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Task List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _focusedOnTask = !_focusedOnTask;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.shade300
                                ),
                              ),
                              child: Icon(
                                _focusedOnTask
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Expanded(
                        child: TaskList(tasks: filteredTasks),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}