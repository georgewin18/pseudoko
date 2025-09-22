import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'package:experiment_app/features/member/data/models/group_member_model.dart';
import 'package:experiment_app/features/task/presentation/widgets/member_avatar_stack.dart';

class GroupDetailCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onPressed;
  final List<GroupMember> members;

  const GroupDetailCard({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF7B6EF2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ]
                ),
              ),

              GestureDetector(
                onTap: onPressed,
                child: Icon(
                  LucideIcons.pen,
                  color: Colors.white,
                  size: 18,
                ),
              )
            ],
          ),

          SizedBox(height: 8),

          MemberAvatarStack(members: members),
        ],
      ),
    );
  }
}