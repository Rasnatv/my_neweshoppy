//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/controllers/auth_controller.dart';
// import 'app_dialog_widgets.dart';
//
// class AppDialogs {
//   static networkErrorDialog() =>
//       show(title: 'No internet connection', message: '');
//
//   static somethingWentWrong({String? message}) => show(
//     title: 'Something went wrong',
//     message: message ?? 'Please try again',
//   );
//
//   static Future show<T>({
//     String? title,
//     String? message,
//     VoidCallback? onClickPositive,
//     VoidCallback? onClickNegative,
//     String? positiveButtonText,
//     String? negativeButtonText,
//     String? dialogId,
//     String? iconPath,
//     bool isDismissible = false,
//   }) async {
//     await Get.dialog<T>(
//       DialogWidget(
//         title: title,
//         message: message,
//         onClickNegative: onClickNegative,
//         onClickPositive: onClickPositive,
//         negativeButtonText: negativeButtonText,
//         positiveButtonText: positiveButtonText,
//         iconPath: iconPath,
//       ),
//       barrierDismissible: isDismissible,
//       name: dialogId,
//     );
//   }
//
//   static void confirmLogout() {
//     show(
//       title: "Confirm Logout",
//       message: "Are you sure you want to logout?",
//       positiveButtonText: "Logout",
//       negativeButtonText: "Back",
//       onClickPositive: () {
//         Get.back(); // close dialog
//         Get.find<AuthController>().logout();
//       },
//     );
//
//   }
//   static void orderPlacedDialog(VoidCallback onContinue) {
//     show(
//       title: "Order Placed",
//       message: "Your order has been placed successfully.",
//       positiveButtonText: "Continue Shopping",
//       iconPath: "assets/icons/shopping_bag.png", // Ensure this icon exists
//       onClickPositive: () {
//         Get.back(); // Close dialog
//         onContinue(); // Navigate
//       },
//     );
//   }
//
// }
