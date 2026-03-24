
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modules/product/controller/cartcontroller.dart';
import '../../modules/profile/controller/editprofile_controller.dart';
import '../../modules/userhome/controller/district _controller.dart';
import '../../modules/userhome/controller/usercategory_controller.dart';
import '../../modules/userlogin/controller/userlogin_controller.dart';
import '../../modules/userlogin/view/login.dart';


class AuthService {
  static final GetStorage box = GetStorage();

  static void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back();
              _logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      barrierDismissible: false,
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
    Get.offAll(LoginPageView());
    //Get.offAllNamed('/login');
  }

}

