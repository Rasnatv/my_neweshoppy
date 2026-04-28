
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  // ✅ Role received from login screen via Get.arguments
  late final int role;

  @override
  void onInit() {
    super.onInit();
    // Expecting role passed as int from login: Get.toNamed(Routes.FORGOTPSWD, arguments: selectedRole)
    final args = Get.arguments;
    role = (args is int) ? args : 1;
  }

  Future<void> sendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackbar.error("Please enter email");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.error("Enter a valid email address");
      return;
    }

    try {
      isLoading.value = true;

      // ✅ Dismiss keyboard before API call + navigation
      FocusManager.instance.primaryFocus?.unfocus();

      final response = await http.post(
        Uri.parse(
          "https://eshoppy.co.in/api/forgot-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "role": role, // ✅ role included
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1 || data["status"] == "1") {
          AppSnackbar.success(data["message"] ?? "OTP sent successfully");

          // ✅ Pass both email and role forward
          Get.toNamed(
            Routes.CHECKEMAIL,
            arguments: {
              "email": email,
              "role": role,
            },
          );
        } else {
          AppSnackbar.error(data["message"] ?? "Failed to send OTP");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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