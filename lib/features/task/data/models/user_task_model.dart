import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_task_model.g.dart';

@HiveType(typeId: 4)
class UserTask extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? taskGroupId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final int progress;

  @HiveField(5)
  final DateTime? date;

  @HiveField(6)
  final TimeOfDay? time;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final String groupName;

  @HiveField(9)
  final String myRole;

  UserTask({
    required this.id,
    this.taskGroupId,
    required this.name,
    this.description,
    required this.progress,
    this.date,
    this.time,
    this.createdAt,
    required this.groupName,
    required this.myRole,
  });

  factory UserTask.fromMap(Map<String, dynamic> map) {
    return UserTask(
      id: map['id'] ?? 0,
      taskGroupId: map['task_group_id'],
      name: map['name'],
      description: map['description'],
      progress: map['progress'] ?? 0,

      date: map['date'] == null
        ? null
        : DateTime.tryParse(map['date']),

      time: _parseTimeOfDay(map['time']),

      createdAt: map['created_at'] == null
        ? null
        : DateTime.tryParse(map['created_at']),

      groupName: map['group_name'],
      myRole: map['my_role'] ?? 'viewer',
    );
  }
}

TimeOfDay _parseTimeOfDay(String? timeString) {
  if (timeString == null) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
  try {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  } catch (e) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
}