
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../landingview/view/landing_screen.dart';

import '../../userhome/controller/district _controller.dart';

class UsersignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final box = GetStorage();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    /// 🔥 READ LOCATION FROM STORAGE
    final String? state = box.read('state');
    final String? district = box.read('district');
    final String? mainLocation = box.read('main_location');

    if (state == null || district == null || mainLocation == null) {
      Get.snackbar(
        "Location Required",
        "Please select your location before signup",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/user/signup",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),

          /// ✅ LOCATION FIELDS
          "state": state,
          "district": district,
          "main_location": mainLocation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// 🔥 CLEAR LOCATION AFTER SIGNUP
        // if (Get.isRegistered<UserDistrictController>()) {
        //   Get.find<UserDistrictController>().resetLocationState();
        // }

        box.remove('state');
        box.remove('district');
        box.remove('main_location');

        Get.snackbar(
          "Success",
          "Signup Successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => LandingView());
      } else {
        Get.snackbar(
          "Error",
          "Signup failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
