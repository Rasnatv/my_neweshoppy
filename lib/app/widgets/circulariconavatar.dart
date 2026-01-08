import 'package:flutter/material.dart';

import '../common/style/app_colors.dart';


class CircleIconAvatar extends StatelessWidget {
  final IconData icon;
  final double radius;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const CircleIconAvatar({
    super.key,
    required this.icon,
    this.radius = 45,
    this.iconSize = 50,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
      backgroundColor ?? AppColors.kPrimary.withOpacity(0.1),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? AppColors.kPrimary,
      ),
    );
  }
}
