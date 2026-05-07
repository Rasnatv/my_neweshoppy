
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ← import DValidator
import '../../../common/utils/validators.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class NewPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>(); // ← Form key for validation

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  late final String email;
  late final String otp;
  late final int role;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    otp = args['otp'];
    role = args['role'] ?? 1;
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordHidden.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.toggle();

  // Validator for confirm password field — checks match against password
  String? validateConfirmPassword(String? value) {
    final baseError = DValidator.validateEmptyText("Confirm password", value);
    if (baseError != null) return baseError;
    if (value != passwordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> updatePassword() async {
    // Trigger all field validators at once
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return;

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("https://eshoppy.co.in/api/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "password": password,
          "password_confirmation": confirmPassword,
          "role": role,
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