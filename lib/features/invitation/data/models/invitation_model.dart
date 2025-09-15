class Invitation {
  final String invitationId;
  final int groupId;
  final String groupName;
  final String invitedByUsername;

  Invitation({
    required this.invitationId,
    required this.groupId,
    required this.groupName,
    required this.invitedByUsername,
  });

  factory Invitation.fromMap(Map<String, dynamic> map) {
    if (map['invitation_id'] == null || map['group_id'] == null) {
      throw FormatException("Invitation data from server is invalid");
    }
    return Invitation(
      invitationId: map['invitation_id'],
      groupId: map['group_id'],
      groupName: map['group_name'] ?? '',
      invitedByUsername: map['invited_by_username'],
    );
  }
}