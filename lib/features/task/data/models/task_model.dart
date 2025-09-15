import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? taskGroupId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? attachment;

  @HiveField(5)
  final int progress;

  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final TimeOfDay time;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final String? createdBy;

  @HiveField(10)
  final DateTime? updatedAt;

  @HiveField(11)
  final String? updatedBy;

  Task({
    required this.id,
    this.taskGroupId,
    required this.name,
    this.description,
    this.attachment,
    required this.progress,
    required this.date,
    required this.time,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      taskGroupId: map['task_group_id'],
      name: map['name'] ?? '',
      description: map['description'],
      attachment: map['attachment'],
      progress: map['progress'] ?? 0,

      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),

      time: _parseTimeOfDay(map['time']),

      createdAt: map['created_at'] == null
        ? null
        : DateTime.parse(map['created_at']),

      createdBy: map['created_by'],

      updatedAt: map['updated_at'] == null
        ? null
        : DateTime.parse(map['updated_at']),

      updatedBy: map['updated_by'],
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

@HiveType(typeId: 2)
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 2;

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readByte();
    final minute = reader.readByte();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeByte(obj.hour);
    writer.writeByte(obj.minute);
  }
}