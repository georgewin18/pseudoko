import 'package:hive/hive.dart';

part 'group_member_model.g.dart';

@HiveType(typeId: 3)
class GroupMember extends HiveObject {
  @HiveField(0)
  final int groupId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String role;

  GroupMember({
    required this.groupId,
    required this.userId,
    required this.username,
    required this.role,
  });

  factory GroupMember.fromMap(Map<String, dynamic> map) {
    if (map['task_group_id'] == null) {
      throw Exception("Data from server is invalid");
    }
    return GroupMember(
      groupId: map['task_group_id'],
      userId: map['user_id'],
      username: map['username'],
      role: map['role'] ?? 'viewer',
    );
  }
}