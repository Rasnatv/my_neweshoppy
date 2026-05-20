
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../landingview/view/landing_screen.dart';
import '../../merchant_home/views/merchant_home.dart';
import '../../merchantlogin/widget/successwidget.dart';


class UserloginController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxInt selectedRole = 1.obs;

  final GetStorage box = GetStorage();

  // final String loginUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/login";
  final String loginUrl = "https://eshoppy.co.in/api/login";


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
  };

  @override
  void onClose() {
    // username.dispose();
    // password.dispose();
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

    if (email.isEmpty || pass.isEmpty) {
      AppSnackbar.warning("Email and password are required");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbar.warning("Enter a valid email address");
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () =>
        throw Exception("Connection timed out. Please try again."),
      );

      final body = jsonDecode(response.body);
      final status = body['status'];

      if (status != 1 && status != "1" && status != true) {
        AppSnackbar.error(body['message'] ?? "Login failed");
        return;
      }

      final data = body['data'];
      if (data == null) {
        AppSnackbar.error("Invalid server response");
        return;
      }

      final int serverRole = int.tryParse(data['role'].toString()) ?? 0;

      if (serverRole != selectedRole.value) {
        AppSnackbar.error("Invalid credentials for selected role");
        return;
      }

      // ✅ Save session data first — token must be written before any controller reads it
      final bool saved = await _saveAuthData(data);
      if (!saved) return;

      // ✅ Register auth-dependent controllers AFTER token is confirmed saved
      // _registerAuthControllers();

      AppSnackbar.success(body['message'] ?? "Login successful");
      _navigateToHome(serverRole);
    } catch (e) {
      debugPrint("Login error: $e");
      AppSnackbar.error(e.toString().contains("timed out")
          ? "Connection timed out. Please try again."
          : "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _saveAuthData(Map<String, dynamic> data) async {
    final token =
        data['auth_token'] ?? data['token'] ?? data['access_token'];

    if (token == null || token.toString().trim().isEmpty) {
      AppSnackbar.error("Authentication token missing");
      return false;
    }

    final String cleanToken = token.toString().trim();

    await box.write("auth_token", cleanToken);
    await box.write("role", int.tryParse(data['role'].toString()) ?? 0);
    await box.write("user_data", data);
    await box.write("is_logged_in", true);

    // ✅ Shield flag — prevents handleUnauthorized() from
    // redirecting to login right after a fresh login
    await box.write("just_logged_in", true);

    final String? saved = box.read<String?>('auth_token');
    debugPrint("✅ Token saved: $saved");

    if (saved == null || saved.isEmpty) {
      AppSnackbar.error("Failed to save session. Please try again.");
      return false;
    }

    return true;
  }


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
      default:
        AppSnackbar.error("Invalid user role");
    }
  }

  void clearFields() {
    username.clear();
    password.clear();
    isPasswordVisible.value = false;
    selectedRole.value = 1;
  }
}

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