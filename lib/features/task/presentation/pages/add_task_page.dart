import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:experiment_app/features/task/presentation/manager/task_notifier.dart';
import 'package:experiment_app/features/task/presentation/widgets/build_dropdown.dart';
import 'package:experiment_app/features/task/presentation/widgets/build_section_title.dart';
import 'package:experiment_app/features/task/presentation/widgets/input_decoration.dart';
import 'package:experiment_app/features/task/presentation/widgets/select_datetime.dart';


class AddTaskPage extends StatefulWidget {
  final int taskGroupId;
  const AddTaskPage({super.key, required this.taskGroupId});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _notesController = TextEditingController();
  final _attachmentController = TextEditingController();

  DateTime? _selectedDateTime;
  String? _selectedRepeat = "No Repeat";
  bool _isLoading = false;

  @override
  void dispose() {
    _taskNameController.dispose();
    _notesController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  Future<void> _onAddTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a deadline'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repeatValue = _selectedRepeat == 'No Repeat'
        ? 'none'
        : _selectedRepeat!.toLowerCase();

      await context.read<TaskNotifier>().addTask(
        widget.taskGroupId,
        _taskNameController.text.trim(),
        description: _notesController.text.trim(),
        attachment: _attachmentController.text.trim(),
        deadline: _selectedDateTime,
        repeatInterval: repeatValue,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
            backgroundColor: Colors.green,
          )
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deadlineController = TextEditingController();
    if (_selectedDateTime != null) {
      deadlineController.text = DateFormat('EEE, dd MMM yyyy - HH:mm').format(_selectedDateTime!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle('Task Name', isRequired: true),
                        TextFormField(
                          controller: _taskNameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: buildInputDecoration('Add Task Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a task name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        buildSectionTitle('Deadline', isRequired: true),
                        TextFormField(
                          controller: deadlineController,
                          readOnly: true,
                          decoration: buildInputDecoration(
                            'EEE, dd MMM yyyy - HH:mm',
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                          ),
                          onTap: () async {
                            final pickedDateTime = await selectDateTime(context);
                            if (pickedDateTime != null) {
                              setState(() => _selectedDateTime = pickedDateTime);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a deadline';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        buildSectionTitle('Repeat'),
                        buildDropdown(
                          ['No Repeat', 'Weekly', 'Monthly'],
                          _selectedRepeat,
                          (value) => setState(() => _selectedRepeat = value),
                        ),

                        const SizedBox(height: 16),

                        buildSectionTitle('Notes'),
                        TextFormField(
                          controller: _notesController,
                          decoration: buildInputDecoration('').copyWith(
                            alignLabelWithHint: true
                          ),
                          maxLines: 3,
                        ),

                        const SizedBox(height: 16),

                        buildSectionTitle('Attachment'),
                        TextFormField(
                          controller: _attachmentController,
                          decoration: buildInputDecoration('Add Attachment'),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onAddTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7B6EF2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black26,
                    ),
                    child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}