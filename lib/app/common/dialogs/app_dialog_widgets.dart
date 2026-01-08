// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:innsouls_flutter/app/common/style/app_colors.dart';
// import 'package:innsouls_flutter/app/common/style/app_text_style.dart';
// import 'package:innsouls_flutter/app/widgets/app_button.dart';
// import 'package:innsouls_flutter/app/widgets/custom_image_widget.dart';
//
// import '../style/app_colors.dart';
//
// class DialogWidget extends StatelessWidget {
//   final String? title;
//   final String? message;
//   final String? positiveButtonText;
//   final String? negativeButtonText;
//   final VoidCallback? onClickPositive;
//   final VoidCallback? onClickNegative;
//   final String? iconPath;
//   final Color? iconColor;
//
//   const DialogWidget(
//       {super.key,
//       this.title,
//       this.message,
//       this.positiveButtonText,
//       this.negativeButtonText,
//       this.onClickPositive,
//       this.onClickNegative,
//       this.iconColor,
//       this.iconPath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 9.1, sigmaY: 9.1), child: Container(color: Colors.transparent))),
//         Material(
//           color: Colors.transparent.withValues(alpha: 0),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Visibility(
//                   visible: iconPath != null,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         top: 50.sp,
//                         child: Container(
//                           width: context.width * .8,
//                           height: 50.w,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)), color: Colors.white),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: SizedBox(
//                           height: 90.w,
//                           child: Container(
//                             width: 80.w,
//                             height: 80.w,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.white,
//                                 boxShadow: [BoxShadow(color: AppColors.black.withValues(alpha: .2), blurRadius: 5.r, offset: Offset(0, 3.w))]),
//                             child: Center(
//                               child: CircleAvatar(
//                                   radius: 25.r,
//                                   backgroundColor: AppColors.grayBackground,
//                                   child: CustomImageWidget(imageUrl: iconPath, width: 22.sp, height: 22.sp, color: iconColor)),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: iconPath == null
//                           ? BorderRadius.circular(20.r)
//                           : BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
//                       color: Colors.white),
//                   width: MediaQuery.of(context).size.width * .8,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 16.w, right: 16.w),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         if (title != null) ...[
//                           const SizedBox(height: 18),
//                           Text(title ?? '', style: AppTextStyle.rTextRalewayBlack19w700, textAlign: TextAlign.center)
//                         ],
//                         if (message != null && title != null) const SizedBox(height: 8),
//                         if (message != null)
//                           Text(
//                             message!,
//                             style: title == null ? AppTextStyle.rTextRalewayBlack18w400 : AppTextStyle.rTextRalewayBlack13w500,
//                             textAlign: TextAlign.center,
//                           ),
//                         SizedBox(height: 10.sp),
//                         Container(
//                           width: MediaQuery.of(context).size.width * .9,
//                           padding: EdgeInsets.only(left: 12.w, right: 12.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               if ((negativeButtonText ?? '').isNotEmpty)
//                                 AppButton(
//                                   padding: EdgeInsets.all(10.sp),
//                                   buttonColor: AppColors.grayButton,
//                                   onTap: () {
//                                     Get.back();
//                                     if (onClickNegative != null) onClickNegative!.call();
//                                   },
//                                   child: Text(negativeButtonText ?? 'Cancel', style: AppTextStyle.rTextNunitoWhite18w400),
//                                 ),
//                               AppButton(
//                                 onTap: () {
//                                   Get.back();
//                                   if (onClickPositive != null) onClickPositive!.call();
//                                 },
//                                 buttonColor: AppColors.black,
//                                 width: 100.sp,
//                                 padding: EdgeInsets.symmetric(vertical: 10.sp),
//                                 child: Text(positiveButtonText ?? 'Ok', style: AppTextStyle.rTextNunitoWhite18w400),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10.sp),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
