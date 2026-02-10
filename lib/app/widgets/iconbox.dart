import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  final IconData icon;
  final double iconSize;
  final Color iconColor;

  final List<Color>? gradientColors;
  final Color? backgroundColor;

  const IconBox({
    super.key,
    this.width = 80,
    this.height = 80,
    this.borderRadius = 24,
    required this.icon,
    this.iconSize = 40,
    this.iconColor = Colors.white,
    this.gradientColors,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: gradientColors == null ? backgroundColor : null,
        gradient: gradientColors != null
            ? LinearGradient(
          colors: gradientColors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ?? backgroundColor ?? Colors.black)
                .withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
