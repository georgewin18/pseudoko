import 'package:hive/hive.dart';

part 'task_group_model.g.dart';

@HiveType(typeId: 0)
class TaskGroup extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? ownerId;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final int notStartedCount;

  @HiveField(5)
  final int ongoingCount;

  @HiveField(6)
  final int completedCount;

  @HiveField(7)
  final DateTime? createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  @HiveField(9)
  final String? updatedBy;

  @HiveField(10)
  final String myRole;

  TaskGroup({
    required this.id,
    required this.name,
    this.ownerId,
    this.description,
    required this.notStartedCount,
    required this.ongoingCount,
    required this.completedCount,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    required this.myRole,
  });

  factory TaskGroup.fromMap(Map<String, dynamic> map) {
    return TaskGroup(
      id: map['id'],
      name: map['name'] ?? '',
      ownerId: map['owner_id'],
      description: map['description'],
      notStartedCount: map['not_started_count'] ?? 0,
      ongoingCount: map['ongoing_count'] ?? 0,
      completedCount: map['completed_count'] ?? 0,

      createdAt: map['created_at'] == null
        ? null
        : DateTime.parse(map['created_at']),

      updatedAt: map['updated_at'] == null
        ? null
        : DateTime.parse(map['updated_at']),

      updatedBy: map['updated_by'],
      myRole: map['my_role'] ?? 'viewer',
    );
  }
}