import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color purple = Color(0xFF7B6EF2);
    final double logoSize = 160;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: purple,
              blurRadius: 150,
              spreadRadius: 16,
            )
          ]
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        )
      )
    );
  }
}