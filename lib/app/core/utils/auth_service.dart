
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modules/product/controller/cartcontroller.dart';
import '../../modules/userhome/controller/district _controller.dart';
import '../../modules/userhome/controller/usercategory_controller.dart';
import '../../modules/userlogin/controller/userlogin_controller.dart';


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


  static void _logout() {
    /// 🔐 Get current token before removing it
    final token = box.read('auth_token');

    /// 🧹 Remove token-specific location data
    if (token != null) {
      box.remove('state_$token');
      box.remove('district_$token');
      box.remove('main_location_$token');
    }

    /// 🔐 Remove auth token
    box.remove('auth_token');

    /// 🧹 Clear and delete controllers
    if (Get.isRegistered<UserLocationController>()) {
      final controller = Get.find<UserLocationController>();
      controller.selectedState.value = '';
      controller.selectedDistrict.value = '';
      controller.selectedMainLocation.value = '';
      controller.districts.clear();
      controller.mainLocations.clear();
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

    /// 🚀 Go to login
    Get.offAllNamed('/login');
  }
}