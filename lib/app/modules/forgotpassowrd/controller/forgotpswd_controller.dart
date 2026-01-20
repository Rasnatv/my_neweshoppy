
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendOtp() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter email");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/forgot-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "role": 1,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == "1") {
        Get.snackbar("Success", data["message"]);

        // ✅ CORRECT NAVIGATION
        Get.toNamed(
          Routes.CHECKEMAIL,
          arguments: emailController.text.trim(),
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to send OTP",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
