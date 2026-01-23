

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_home/view/admin_home.dart';
import '../../landingview/view/landing_screen.dart';
import '../../merchant_home/views/merchant_home.dart';

class UserloginController extends GetxController {
  // Text Controllers
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Reactive States
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // Storage
  final GetStorage box = GetStorage();

  // API URL
  final String loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Main submit method with role-based login
  Future<void> submit() async {
    final String email = username.text.trim();
    final String pass = password.text.trim();

    // Basic validation
    if (email.isEmpty || pass.isEmpty) {
      _showError("Email and password are required");
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      // Try login with each role (User: 1, Merchant: 2, Admin: 3)
      for (int role in [1, 2, 3]) {
        final bool success = await _loginWithRole(
          email: email,
          password: pass,
          role: role,
        );

        if (success) {
          isLoading.value = false;
          return;
        }
      }

      // If no role worked, show error
      _showError("Invalid email or password");
    } catch (e) {
      _showError("Something went wrong. Please try again.");
      debugPrint("Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Login attempt with specific role
  Future<bool> _loginWithRole({
    required String email,
    required String password,
    required int role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "email": email,
          "password": password,
          "role": role.toString(),
        },
      ).timeout(const Duration(seconds: 30));

      // Parse response
      final Map<String, dynamic> body = jsonDecode(response.body);
      final status = body['status'];
      final bool isSuccess =
          status == true || status == 1 || status == "1" || status == "true";

      if (!isSuccess) {
        return false;
      }

      final data = body['data'];

      if (data == null) {
        return false;
      }

      // Store auth data
      await _saveAuthData(data);

      // Navigate based on role
      _navigateToHome(data['role']);

      // Show success message
      _showSuccess(body['message'] ?? "Login successful!");

      return true;
    } catch (e) {
      debugPrint("Login with role $role failed: $e");
      return false;
    }
  }

  /// Save authentication data to local storage
  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await box.write("auth_token", data['auth_token']);
    await box.write("role", data['role']);
    await box.write("user_data", data);
    await box.write("is_logged_in", true);
  }

  /// Navigate to appropriate home screen based on role
  void _navigateToHome(int role) {
    switch (role) {
      case 1:
        Get.offAll(
              () => LandingView(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case 2:
        Get.offAll(
              () => MerchantDashboardPage(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case 3:
        Get.offAll(
              () => AdminDashboard(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      default:
        _showError("Invalid user role");
    }
  }

  /// Show error snackbar
  void _showError(String message) {
    Get.snackbar(
      "Login Failed",
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Show success snackbar
  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Clear all fields
  void clearFields() {
    username.clear();
    password.clear();
    isPasswordVisible.value = false;
  }
}