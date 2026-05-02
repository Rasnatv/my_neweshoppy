
import 'package:flutter/material.dart';

class SmoothBottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at top-left
    path.lineTo(0, size.height - 40);

    // Smooth left curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height,
    );

    // Smooth right curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height - 40,
    );

    // Top-right
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
