
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// pages


import '../../admin_home/view/admin_home.dart';
import '../../merchant_home/views/merchant_home.dart';
import '../../userhome/view/userhome.dart';

class UserloginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();

  final isLoading = false.obs;
  final box = GetStorage();

  final String loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }

  /// 🔹 Called from UI button (UNCHANGED)
  Future<void> submit() async {
    final email = username.text.trim();
    final pass = password.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _error("Email and password required");
      return;
    }

    isLoading.value = true;

    try {
      /// TRY ROLES: USER → MERCHANT → ADMIN
      for (int role in [1, 2, 3]) {
        final success = await _loginWithRole(
          email: email,
          password: pass,
          role: role,
        );

        if (success) return;
      }

      /// IF ALL FAIL
      _error("Invalid email or password");
    } catch (e) {
      _error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 API CALL
  Future<bool> _loginWithRole({
    required String email,
    required String password,
    required int role,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {"Accept": "application/json"},
      body: {
        "email": email,
        "password": password,
        "role": role.toString(),
      },
    );

    final body = jsonDecode(response.body);

    final status = body['status'];
    final isSuccess =
        status == true || status == 1 || status == "1";

    if (!isSuccess) return false;

    final data = body['data'];

    /// SAVE DATA
    box.write("auth_token", data['auth_token']);
    box.write("role", data['role']);
    box.write("user_data", data);

    /// NAVIGATION
    if (data['role'] == 1) {
      Get.offAll(() => Userhome());
    } else if (data['role'] == 2) {
      Get.offAll(() => MerchantDashboardPage());
    } else if (data['role'] == 3) {
      Get.offAll(() => AdminDashboard());
    }

    Get.snackbar(
      "Success",
      body['message'] ?? "Login successful",
    );

    return true;
  }

  void _error(String msg) {
    Get.snackbar(
      "Login Failed",
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

