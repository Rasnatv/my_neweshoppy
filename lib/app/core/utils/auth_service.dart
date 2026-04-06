
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modules/product/controller/cartcontroller.dart';
import '../../modules/profile/controller/editprofile_controller.dart';
import '../../modules/userhome/controller/district _controller.dart';
import '../../modules/userhome/controller/usercategory_controller.dart';
import '../../modules/userlogin/controller/admin_logincontroller.dart';
import '../../modules/userlogin/controller/userlogin_controller.dart';
import '../../modules/userlogin/view/login.dart';


class AuthService {
  static final GetStorage box = GetStorage();

  // static void showLogoutDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text("Logout"),
  //       content: const Text("Are you sure you want to logout?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           onPressed: () {
  //             Get.back();
  //             _logout();
  //           },
  //           child: const Text("Logout"),
  //         ),
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
  static void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFA32D2D),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),

              // Title
              const Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              const Text(
                "You'll need to sign in again to access\nyour account and cart.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B6B6B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Sign out button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    _logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE24B4A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign out",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1A1A1A),
                    side: const BorderSide(color: Color(0xFFD0D0D0), width: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );
  }
  static void _logout() async {
    /// 🔐 Read token FIRST
    final token = box.read('auth_token');

    /// 🧹 Clear token-specific cached data
    if (token != null) {
      box.remove('state_$token');
      box.remove('district_$token');
      box.remove('main_location_$token');
    }
    await box.remove('token');
    await box.remove('is_logged_in');
    await box.remove('role');
    await box.remove('user');

    if (Get.isRegistered<UserLocationController>()) {
      Get.delete<UserLocationController>(force: true);
    }

    if (Get.isRegistered<CartController>()) {
      Get.delete<CartController>(force: true);
    }

    if (Get.isRegistered<UserCategoryController>()) {
      Get.delete<UserCategoryController>(force: true);
    }

    if (Get.isRegistered<UserloginController>()) {
      Get.delete<UserloginController>(force: true);
    }
    if (Get.isRegistered<EditProfileController>()) {
      Get.delete<EditProfileController>(force: true);
    }
    // if (Get.isRegistered<AdminLoginController>()) {
    //   Get.delete<AdminLoginController>(force: true);
    // }
    Get.offAll(LoginPageView());
    //Get.offAllNamed('/login');
  }

}

