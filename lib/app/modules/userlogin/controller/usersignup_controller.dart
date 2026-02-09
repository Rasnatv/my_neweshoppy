
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

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  final box = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

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
        }),
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // final token = decodedData["data"]["auth_token"];
        final token = decodedData["data"]["auth_token"];

        /// 🔑 SAVE FULL AUTH STATE (MANDATORY)
        await box.write("auth_token", token);
        await box.write("is_logged_in", true);
        await box.write("role", 1); // user role
        await box.write("user_data", decodedData["data"]);


        /// 🔑 Save token
        // await box.write("auth_token", token);

        /// 🔥 FORCE load locations (FIX)
        if (Get.isRegistered<UserLocationController>()) {
          Get.find<UserLocationController>().fetchLocations();
        }

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
          decodedData["message"] ?? "Signup failed",
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
}
