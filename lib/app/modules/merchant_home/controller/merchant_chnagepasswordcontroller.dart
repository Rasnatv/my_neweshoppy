
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MerchantChangePasswordController extends GetxController {
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  var isLoading = false.obs;

  // Password visibility toggles
  final currentPasswordVisible = true.obs;
  final newPasswordVisible = true.obs;
  final confirmPasswordVisible = true.obs;

  final box = GetStorage();

  final String changePasswordUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/change-password";

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordCtrl.text.trim();
    final newPassword = newPasswordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    // Validation
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "All fields are required",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        "Validation Error",
        "New password must be at least 8 characters long",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Validation Error",
        "New password and confirmation do not match",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (currentPassword == newPassword) {
      Get.snackbar(
        "Validation Error",
        "New password must be different from current password",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.warning_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      // Read token saved after login
      final token = box.read('auth_token');
      if (token == null) {
        Get.snackbar(
          "Authentication Error",
          "Please login first to change password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        isLoading.value = false;
        return;
      }

      final response = await http.post(
        Uri.parse(changePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "current_password": currentPassword,
          "new_password": newPassword,
          "new_password_confirmation": confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && (data['status'] == 1 || data['status'] == "1")) {
        // Success
        Get.snackbar(
          "Success",
          data['message'] ?? "Password changed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );

        // Clear fields after success
        currentPasswordCtrl.clear();
        newPasswordCtrl.clear();
        confirmPasswordCtrl.clear();

        // Reset password visibility
        currentPasswordVisible.value = true;
        newPasswordVisible.value = true;
        confirmPasswordVisible.value = true;

        // Optional: Navigate back after successful password change
        Future.delayed(const Duration(seconds: 2), () {
          Get.back();
        });
      } else if (response.statusCode == 401) {
        // Unauthorized - wrong current password
        Get.snackbar(
          "Authentication Error",
          "Current password is incorrect",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      } else {
        // Other errors
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to change password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Network Error",
        "Something went wrong. Please check your internet connection.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      print("Error changing password: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to validate password strength
  bool isPasswordStrong(String password) {
    // At least 8 characters, one uppercase, one lowercase, one number
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasMinLength = password.length >= 8;

    return hasUppercase && hasLowercase && hasDigits && hasMinLength;
  }

  // Optional: Add password strength indicator
  String getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Fair';
    if (isPasswordStrong(password)) return 'Strong';
    return 'Good';
  }

  Color getPasswordStrengthColor(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Fair':
        return Colors.orange;
      case 'Good':
        return Colors.blue;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}