import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[600],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: textColor ?? Colors.grey[600],
        ),
      ),
      onTap: onTap,
    );
  }
}