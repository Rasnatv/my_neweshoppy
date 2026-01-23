//
// import 'package:eshoppy/app/modules/userlogin/view/sigin.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../modules/userhome/controller/district _controller.dart';
// import '../../modules/userhome/controller/usercategory_controller.dart';
// import '../../modules/userlogin/controller/userlogin_controller.dart';
//
// class AuthService {
//   static final GetStorage box = GetStorage();
//
//   /// 🔥 Logout for any user type (clears storage, controllers, and navigates to login)
//   static void logout({String message = "Logged out successfully"}) {
//     final role = box.read('role'); // 'user' or 'merchant'
//
//     // Remove all stored data
//     box.remove('auth_token');
//     box.remove('user_id');
//     box.remove('role');
//     box.remove('state_userid');
//     box.remove('district_userid');
//     box.remove('main_location_userid');
//     box.remove('user_data'); // optional
//
//     // Delete controllers based on role
//     if (role == 'user') {
//       if (Get.isRegistered<UserLocationController>()) {
//         Get.delete<UserLocationController>(force: true);
//       }
//       if (Get.isRegistered<UserCategoryController>()) {
//         Get.delete<UserCategoryController>(force: true);
//       }
//     }
//     /// 🔥 MOST IMPORTANT — remove login controller
//     if (Get.isRegistered<UserloginController>()) {
//       Get.delete<UserloginController>(force: true);
//     }
//
//     // Add any other merchant controllers here
//
//
//     // Navigate to login
//     Get.offAll(() => const LoginScreen());
//
//     // Show snackbar
//     Get.snackbar(
//       "Logout",
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../modules/userhome/controller/district _controller.dart';
import '../../modules/userhome/controller/usercategory_controller.dart';
import '../../modules/userlogin/controller/userlogin_controller.dart';
import '../../modules/userlogin/view/sigin.dart';

class AuthService {
  static final GetStorage box = GetStorage();

  /// 🔥 Call this on logout button tap
  static void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          /// ❌ Cancel button
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          /// ✅ Logout button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back(); // close dialog
              _logout();   // perform logout
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// 🔥 Actual logout logic
  static void _logout() {
    final role = box.read('role'); // int: 1=user, 2=merchant, 3=admin

    /// 🧹 Clear storage
    box.erase();

    /// 🧹 Delete User controllers
    if (role == 1) {
      if (Get.isRegistered<UserLocationController>()) {
        Get.delete<UserLocationController>(force: true);
      }
      if (Get.isRegistered<UserCategoryController>()) {
        Get.delete<UserCategoryController>(force: true);
      }
    }

    /// 🧹 Delete Login controller (IMPORTANT)
    if (Get.isRegistered<UserloginController>()) {
      Get.delete<UserloginController>(force: true);
    }

    /// 👉 Navigate to Login
    Get.offAll(() => const LoginScreen());

    /// ✅ Snackbar
    Get.snackbar(
      "Logout",
      "Logged out successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}
