
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class NewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  late final String email;
  late final String otp;
  late final int role; // ✅ role received here too

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    otp = args['otp'];
    role = args['role'] ?? 1; // ✅ default to user if missing
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  Future<void> updatePassword() async {
    if (isLoading.value) return;

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      AppSnackbar.error("Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.error("Passwords do not match");
      return;
    }

    if (password.length < 6) {
      AppSnackbar.error("Password must be at least 6 characters");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://eshoppy.co.in/api/reset-password"
          //"https://rasma.astradevelops.in/e_shoppyy/public/api/reset-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "password": password,
          "password_confirmation": confirmPassword,
          "role": role, // ✅ role included
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1 || data["status"] == "1") {
          AppSnackbar.success(data["message"] ?? "Password updated successfully");
          Get.offAllNamed('/login');
        } else {
          AppSnackbar.error(data["message"] ?? "Failed to reset password");
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
}