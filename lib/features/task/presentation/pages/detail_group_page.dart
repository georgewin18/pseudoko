import 'package:experiment_app/core/utils/is_same_date.dart';
import 'package:experiment_app/core/utils/notifier_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';
import 'package:experiment_app/features/member/presentation/manager/member_notifier.dart';
import 'package:experiment_app/features/task/presentation/widgets/build_group_detail_card.dart';
import 'package:experiment_app/features/task/presentation/widgets/expandable_calendar.dart';
import 'package:experiment_app/features/task/presentation/widgets/task_list.dart';

class DetailGroupPage extends StatefulWidget {
  final int taskGroupId;
  final String groupName;
  final String description;
  final String ownerId;

  const DetailGroupPage({
    super.key,
    required this.taskGroupId,
    required this.groupName,
    required this.description,
    required this.ownerId
  });

  @override
  State<DetailGroupPage> createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskNotifier>().fetchTasks(widget.taskGroupId);
      context.read<MemberNotifier>().fetchMembers(widget.taskGroupId);
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskNotifier, MemberNotifier>(
      builder: (context, taskNotifier, memberNotifier, child) {
        final bool isLoading =
          taskNotifier.state == NotifierState.loading ||
          memberNotifier.state == NotifierState.loading;

        final allTasks = taskNotifier.tasks;
        final members = memberNotifier.members;
        final myRole = taskNotifier.myRole;

        final filteredTasks = allTasks.where((task) {
          return isSameDay(task.date, _selectedDate);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Detail Group'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: isLoading && allTasks.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GroupDetailCard(
                      name: widget.groupName,
                      description: widget.description,
                      onPressed: () {},
                      members: members,
                    ),
                    const SizedBox(height: 16),
                    ExpandableCalendar(
                      tasks: allTasks,
                      selectedDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                    // const SizedBox(height: 16),
                    Expanded(
                      child: TaskList(tasks: filteredTasks),
                    ),
                  ],
                  )
            ),
          ),
          floatingActionButton: (myRole == 'editor')
            ? Transform.translate(
                offset: const Offset(-9, -20),
                child: FloatingActionButton(
                  onPressed: () {
                    context.push('/group/${widget.taskGroupId}/add-task');
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        );
      },
    );
  }
}