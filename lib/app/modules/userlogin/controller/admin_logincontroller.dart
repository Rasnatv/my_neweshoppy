import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_home/areaadmin/view/area_adminhome.dart';
import '../../admin_home/districtadmin/view/districtadmin_home.dart';
import '../../admin_home/view/admin_home.dart';                     // role 3 – AdminDashboard


class AdminLoginController extends GetxController {
  // ── Text Controllers ─────────────────────────────────────────────────────
  final TextEditingController emailCtrl    = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // ── Reactive state ───────────────────────────────────────────────────────
  final RxInt  selectedRole      = 3.obs; // default: Admin
  final RxBool isLoading         = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // ── Storage & API ────────────────────────────────────────────────────────
  final GetStorage box      = GetStorage();
  final String     loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void setRole(int role) => selectedRole.value = role;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  // ─── Submit ──────────────────────────────────────────────────────────────
  Future<void> submit() async {
    final email = emailCtrl.text.trim();
    final pass  = passwordCtrl.text.trim();

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
      final response = await http
          .post(
        Uri.parse(loginUrl),
        headers: {
          "Accept":       "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email":    email,
          "password": pass,
          "role":     selectedRole.value, // ← uses reactive selected role
        }),
      )
          .timeout(const Duration(seconds: 30));

      final body   = jsonDecode(response.body);
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

      // Verify server role matches selected role
      final serverRole = data['role'] is String
          ? int.tryParse(data['role'].toString())
          : data['role'] as int?;

      if (serverRole != selectedRole.value) {
        _showError("Invalid credentials for this admin type");
        return;
      }

      await _saveAuthData(data);
      _navigateToHome(serverRole!);
      _showSuccess(body['message'] ?? "Login successful");
    } catch (e) {
      debugPrint("Admin login error [role=${selectedRole.value}]: $e");
      _showError("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    final token =
        data['auth_token'] ?? data['token'] ?? data['access_token'];
    await box.write("auth_token",   token);
    await box.write("role",         selectedRole.value);
    await box.write("user_data",    data);
    await box.write("is_logged_in", true);
  }

  // ─── Navigate to role-specific home ──────────────────────────────────────
  void _navigateToHome(int role) {
    switch (role) {
      case 3: // Admin
        Get.offAll(
              () => AdminDashboard(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case 4: // District Admin
        Get.offAll(
              () => Districtadminhomepage(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      case 5: // Area Admin
        Get.offAll(
              () => AreaAdminhomepage(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 400),
        );
        break;
      default:
        _showError("Unknown admin role");
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Login Failed", message,
      backgroundColor: Colors.red.shade600,
      colorText:       Colors.white,
      icon:            const Icon(Icons.error_outline, color: Colors.white),
      snackPosition:   SnackPosition.TOP,
      borderRadius:    12,
      margin:          const EdgeInsets.all(16),
      duration:        const Duration(seconds: 4),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Success", message,
      icon:          const Icon(Icons.check_circle_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      borderRadius:  12,
      margin:        const EdgeInsets.all(16),
      duration:      const Duration(seconds: 3),
    );
  }

  void clearFields() {
    emailCtrl.clear();
    passwordCtrl.clear();
    isPasswordVisible.value = false;
    selectedRole.value      = 3;
  }
}