import 'package:flutter/material.dart';

import 'package:experiment_app/core/utils/color_utils.dart';
import 'package:experiment_app/features/member/data/models/group_member_model.dart';

class MemberAvatarStack extends StatelessWidget {
  final List<GroupMember> members;
  final double avatarSize;
  final double overlap;

  const MemberAvatarStack({
    super.key,
    required this.members,
    this.avatarSize = 32,
    this.overlap = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    final itemsToDisplay = members.length > 4 ? members.take(3).toList() : members;
    final remainingCount = members.length - itemsToDisplay.length;

    final double totalWidth = itemsToDisplay.isNotEmpty
        ? (itemsToDisplay.length * avatarSize * (1 - overlap)) + (avatarSize * overlap)
        + (remainingCount > 0 ? avatarSize * (1 - overlap) : 0)
        : 0;

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: [

          ...itemsToDisplay.asMap().entries.map((entry) {
            int index = entry.key;
            GroupMember member = entry.value;
            final leftPosition = index * avatarSize * (1 - overlap);

            return Positioned(
              left: leftPosition,
              child: _buildAvatar(member, avatarSize),
            );
          }),

          if (remainingCount > 0)
            Positioned(
              left: itemsToDisplay.length * avatarSize * (1 - overlap),
              child: _buildRemainingCount(remainingCount, avatarSize),
            )
        ],
      ),
    );
  }
}

Widget _buildAvatar(GroupMember member, double avatarSize) {
  final avatarColor = getRandomColorFromString(member.username[0]);

  return CircleAvatar(
    radius: avatarSize / 2,
    backgroundColor: avatarColor,
    child: Text(
      member.username[0].toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildRemainingCount(int count, double avatarSize) {
  return CircleAvatar(
    radius: avatarSize / 2,
    backgroundColor: Colors.grey.shade400,
    child: Text(
      '+$count',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold
      ),
    ),
  );
}