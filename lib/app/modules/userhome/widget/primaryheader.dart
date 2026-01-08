// import 'package:abc/app/common/style/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'curved edge.dart';
// import 'dcircularcontainer.dart';
// class DPrimaryHeader extends StatelessWidget {
//   const DPrimaryHeader({super.key, required this.child,  this.height=380, });
//
//   final Widget child;
//   final double? height;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         width: double.infinity,
//         height: 230,
//         color: AppColors.kPrimary,
//         padding: EdgeInsets.all(0),
//         child: Stack(
//             children: [
//               Positioned(top:-50,right: -250,
//                   child: DcircularContainer(backgroundcolor: AppColors.white.withOpacity(0.1),)),
//               Positioned(top:60,right: -300,
//                   child: DcircularContainer(backgroundcolor: AppColors.white.withOpacity(0.1),)),
//               child
//
//             ]),
//
//
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../common/style/app_colors.dart';
import 'dcircularcontainer.dart';

class DPrimaryHeader extends StatelessWidget {
  const DPrimaryHeader({
    super.key,
    required this.child,
    this.height = 230,
  });

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Stack(
        children: [
          // 🌈 Gradient Background + Glass Blur
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kPrimary.withOpacity(0.55),
                  AppColors.kPrimary.withOpacity(0.80),
                  AppColors.kPrimary.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 💎 Glass blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: height,
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          // ✨ Decorative Floating Glass Circles
          Positioned(
            top: -60,
            right: -120,
            child: _glassCircle(240),
          ),
          Positioned(
            top: 40,
            right: -160,
            child: _glassCircle(260),
          ),
          Positioned(
            top: -40,
            left: -80,
            child: _glassCircle(180),
          ),

          // ⭐ Child Section (Search bar, dropdown, etc.)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: child,
          ),
        ],
      ),
    );
  }

  /// Glass Circular Container
  Widget _glassCircle(double size) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.07),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
