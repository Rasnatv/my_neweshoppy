
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../common/utils/validators.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class MerchantChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>(); // ← add form key

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl     = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isLoading = false.obs;

  final currentPasswordVisible = true.obs;
  final newPasswordVisible     = true.obs;
  final confirmPasswordVisible = true.obs;

  final box = GetStorage();

  static const String _changePasswordUrl =
      "https://eshoppy.co.in/api/merchant/change-password";

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  Future<void> changePassword() async {
    // ── DValidator via Form ────────────────────────────────
    if (!formKey.currentState!.validate()) return;

    final currentPassword = currentPasswordCtrl.text.trim();
    final newPassword     = newPasswordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    // ── Cross-field checks (can't live inside a single field validator) ──
    if (currentPassword == newPassword) {
      AppSnackbar.warning("New password must be different from current password");
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackbar.warning("New password and confirmation do not match");
      return;
    }

    // ── Token ──────────────────────────────────────────────
    final token = box.read('auth_token') ?? '';

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(_changePasswordUrl),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "current_password"         : currentPassword,
          "new_password"             : newPassword,
          "new_password_confirmation": confirmPassword,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
        return;
      }

      final data = jsonDecode(response.body);

      if (data['status'] == 1 || data['status'] == "1") {
        currentPasswordCtrl.clear();
        newPasswordCtrl.clear();
        confirmPasswordCtrl.clear();

        currentPasswordVisible.value = true;
        newPasswordVisible.value     = true;
        confirmPasswordVisible.value = true;

        AppSnackbar.success(
          data['message']?.toString().isNotEmpty == true
              ? data['message']
              : 'Password changed successfully.',
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Confirm-password cross-field validator ─────────────
  String? validateConfirmPassword(String? value) {
    final base = DValidator.validatePassword(value);
    if (base != null) return base;
    if (value != newPasswordCtrl.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  // ── Password strength helpers ──────────────────────────
  bool isPasswordStrong(String password) {
    return password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.length >= 8;
  }

  String getPasswordStrength(String password) {
    if (password.isEmpty)    return '';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Fair';
    if (isPasswordStrong(password)) return 'Strong';
    return 'Good';
  }

  Color getPasswordStrengthColor(String password) {
    switch (getPasswordStrength(password)) {
      case 'Weak':   return Colors.red;
      case 'Fair':   return Colors.orange;
      case 'Good':   return Colors.blue;
      case 'Strong': return Colors.green;
      default:       return Colors.grey;
    }
  }
}