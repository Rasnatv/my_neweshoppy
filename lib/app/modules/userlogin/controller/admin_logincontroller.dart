
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/areaadminsuccesswidget.dart';
import '../../admin_home/districtadmin/view/districtadmin_home.dart';
import '../../admin_home/view/admin_home.dart';
import '../../areaadmin/view/area_adminhome.dart';
import '../../../data/errors/api_error.dart';

class AdminLoginController extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  var selectedRole = 3.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final GetStorage box = GetStorage();

  final String loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  void setRole(int role) => selectedRole.value = role;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ───────── LOGIN ─────────
  Future<void> submit() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackbarss.warning("Email and password are required");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackbarss.warning("Enter valid email");
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
          "password": password,
          "role": selectedRole.value,
        }),
      );

      debugPrint("🔐 Login status: ${response.statusCode}");
      debugPrint("🔐 Login body: ${response.body}");

      // ✅ HANDLE NON-200 RESPONSES
      if (response.statusCode != 200) {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbarss.error(errorMsg);
        return;
      }

      final body = jsonDecode(response.body);

      final status = body['status'];
      bool isSuccess = status == 1 || status == "1" || status == true;

      if (!isSuccess) {
        AppSnackbarss.error(body['message'] ?? "Login failed");
        return;
      }

      final data = body['data'];
      if (data == null) {
        AppSnackbarss.error("Invalid response from server");
        return;
      }

      final int serverRole =
          int.tryParse(data['role'].toString()) ?? 0;

      if (serverRole != selectedRole.value) {
        AppSnackbarss.error("Invalid role selected");
        return;
      }

      final bool saved = await _saveAuthData(data);
      if (!saved) return;


      _navigateToHome(serverRole);

    } catch (e) {
      debugPrint("❌ LOGIN ERROR: $e");

      // ✅ HANDLE EXCEPTION (NO INTERNET, ETC)
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbarss.error(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  // ───────── SAVE AUTH DATA ─────────
  Future<bool> _saveAuthData(Map<String, dynamic> data) async {
    final token = data['auth_token'] ??
        data['token'] ??
        data['access_token'];

    if (token == null || token.toString().trim().isEmpty) {
      AppSnackbarss.error("Authentication token missing in response");
      return false;
    }

    final String cleanToken = token.toString().trim();

    await box.write("auth_token", cleanToken);
    await box.write(
        "role", int.tryParse(data['role'].toString()) ?? 0);
    await box.write("user_data", data);
    await box.write("is_logged_in", true);

    final String? savedToken = box.read('auth_token');
    debugPrint("✅ Token saved: '$savedToken'");

    if (savedToken == null || savedToken.isEmpty) {
      AppSnackbarss.error("Failed to save session. Please try again.");
      return false;
    }

    return true;
  }

  // ───────── NAVIGATION ─────────
  void _navigateToHome(int role) {
    switch (role) {
      case 3:
        Get.offAll(() => AdminDashboard());
        break;
      case 4:
        Get.offAll(() => Districtadminhomepage());
        break;
      case 5:
        Get.offAll(() => AreaAdminhomepage());
        break;
      default:
        AppSnackbarss.error("Invalid role");
    }
  }

  void clearFields() {
    emailCtrl.clear();
    passwordCtrl.clear();
    selectedRole.value = 3;
  }
}
