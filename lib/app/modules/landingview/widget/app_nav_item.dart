//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Add this
// import 'package:get/get.dart';
// import '../../../common/style/app_colors.dart';
// import '../../../common/style/dimens.dart';
// import '../controller/landing_controller.dart';
//
// class AppNavItem extends GetWidget<LandingController> {
//   const AppNavItem({
//     super.key,
//     required this.value,
//     required this.iconPath,
//     this.padding,
//   });
//
//   final LandingItem value;
//   final String iconPath;
//   final EdgeInsets? padding;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LandingController>(
//       builder: (controller) {
//         final bool isSelected = controller.selectedPage == value;
//         return InkWell(
//           onTap: () => controller.changePage(page: value),
//           child: Padding(
//             padding: padding ?? EdgeInsets.zero,
//             child: SizedBox(
//               height: 60.sp,
//               width: 60.sp,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SvgPicture.asset(
//                       iconPath,
//                       height: 24.sp,
//                       width: 24.sp,
//                       color: isSelected ? AppColors.kPrimary : AppColors.grayButton,
//                     ),
//                     Dimens.kSizedBoxH6,
//                     Container(
//                       height: 3.sp,
//                       width: 12.sp,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(3.r),
//                         color: isSelected ? AppColors.kPrimary : Colors.transparent,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/dimens.dart';
import '../controller/landing_controller.dart';

class AppNavItem extends GetWidget<LandingController> {
  const AppNavItem({
    super.key,
    required this.value,
    required this.iconPath,
    required this.label,
    this.padding,
  });

  final LandingItem value;
  final String iconPath;
  final String label; // NEW
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingController>(
      builder: (controller) {
        final bool isSelected = controller.selectedPage == value;

        return InkWell(
          onTap: () => controller.changePage(page: value),
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(vertical: 6.h),
            child: SizedBox(
              width: 60.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    height: 24.sp,
                    width: 24.sp,
                    color: isSelected ? AppColors.kPrimary : AppColors.grayButton,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.kPrimary : AppColors.grayButton,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
