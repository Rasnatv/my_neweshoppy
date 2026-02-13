// import 'package:flutter/material.dart';
//
// class IconBox extends StatelessWidget {
//   final double width;
//   final double height;
//   final double borderRadius;
//
//   final IconData icon;
//   final double iconSize;
//   final Color iconColor;
//
//   final List<Color>? gradientColors;
//   final Color? backgroundColor;
//
//   const IconBox({
//     super.key,
//     this.width = 80,
//     this.height = 80,
//     this.borderRadius = 24,
//     required this.icon,
//     this.iconSize = 40,
//     this.iconColor = Colors.white,
//     this.gradientColors,
//     this.backgroundColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: gradientColors == null ? backgroundColor : null,
//         gradient: gradientColors != null
//             ? LinearGradient(
//           colors: gradientColors!,
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         )
//             : null,
//         borderRadius: BorderRadius.circular(borderRadius),
//         boxShadow: [
//           BoxShadow(
//             color: (gradientColors?.first ?? backgroundColor ?? Colors.black)
//                 .withOpacity(0.3),
//             blurRadius: 24,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Icon(
//         icon,
//         size: iconSize,
//         color: iconColor,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  /// ICON
  final IconData? icon;
  final double iconSize;
  final Color iconColor;

  /// IMAGE
  final String? imagePath; // asset or network
  final bool isNetworkImage;

  /// BACKGROUND
  final List<Color>? gradientColors;
  final Color? backgroundColor;

  const IconBox({
    super.key,
    this.width = 80,
    this.height = 80,
    this.borderRadius = 24,

    // icon
    this.icon,
    this.iconSize = 40,
    this.iconColor = Colors.white,

    // image
    this.imagePath,
    this.isNetworkImage = false,

    // background
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
            color: (gradientColors?.first ??
                backgroundColor ??
                Colors.black)
                .withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    /// IMAGE HAS PRIORITY
    if (imagePath != null) {
      return isNetworkImage
          ? Image.network(
        imagePath!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      )
          : Image.asset(
        imagePath!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      );
    }

    /// FALLBACK TO ICON
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }
}
