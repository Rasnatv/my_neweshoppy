
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_home/view/admin_home.dart';
import '../../landingview/view/landing_screen.dart';
import '../../merchant_home/views/merchant_home.dart';

class UserloginController extends GetxController {
  // // Text Controllers
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Reactive states
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxInt selectedRole = 1.obs; // Default to User (1)

  // Storage
  final GetStorage box = GetStorage();

  // API URL
  final String loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  // Role definitions
  final Map<int, RoleInfo> roles = {
    1: RoleInfo(
      id: 1,
      name: 'User',
      icon: Icons.person_outline_rounded,
      description: 'Shop amazing products',
      color: const Color(0xFF2196F3),
    ),
    2: RoleInfo(
      id: 2,
      name: 'Merchant',
      icon: Icons.storefront_outlined,
      description: 'Manage your store',
      color: const Color(0xFFFF9800),
    ),
    3: RoleInfo(
      id: 3,
      name: 'Admin',
      icon: Icons.admin_panel_settings_outlined,
      description: 'System administration',
      color: const Color(0xFF9C27B0),
    ),
  };

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void setRole(int role) {
    selectedRole.value = role;
  }
  Future<void> submit() async {
    final email = username.text.trim();
    final pass = password.text.trim();

    // Validation
    if (email.isEmpty || pass.isEmpty) {
      _showError("Email and password are required");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError("Enter a valid email address");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": pass,
          "role": selectedRole.value,
        }),
      ).timeout(const Duration(seconds: 30));

      final body = jsonDecode(response.body);
      final status = body['status'];

      if (status != 1 && status != "1" && status != true) {
        _showError(body['message'] ?? "Login failed");
        return;
      }

      final data = body['data'];
      if (data == null) {
        _showError("Invalid server response");
        return;
      }

      // Verify role matches
      final serverRole = data['role'];
      if (serverRole != selectedRole.value) {
        _showError("Invalid credentials for selected role");
        return;
      }

      // Save auth data
      await _saveAuthData(data);

      // Navigate automatically based on role
      _navigateToHome(data['role']);

      _showSuccess(body['message'] ?? "Login successful");

    } catch (e) {
      debugPrint("Login error: $e");
      _showError("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    final token =
        data['auth_token'] ??
            data['token'] ??
            data['access_token'];

    await box.write("auth_token", token);
    await box.write("role", data['role']);
    await box.write("user_data", data);
    await box.write("is_logged_in", true);
  }

  /// Navigate to the correct home screen based on role
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
    );
  }

  /// Clear all fields
  void clearFields() {
    username.clear();
    password.clear();
    isPasswordVisible.value = false;
    selectedRole.value = 1;
  }
}

/// Role information model
class RoleInfo {
  final int id;
  final String name;
  final IconData icon;
  final String description;
  final Color color;

  RoleInfo({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
  });
}
