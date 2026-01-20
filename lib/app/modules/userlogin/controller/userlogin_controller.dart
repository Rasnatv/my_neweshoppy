import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../admin_home/view/admin_home.dart';
import '../../merchant_home/views/merchant_home.dart';
import '../../userhome/view/userhome.dart';

class UserloginController extends GetxController {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RxBool isLoading = false.obs;
  final GetStorage box = GetStorage();

  final String loginUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/login";

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    final String email = username.text.trim();
    final String pass = password.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _error("Email and password required");
      return;
    }

    isLoading.value = true;

    try {
      for (int role in [1, 2, 3]) {
        final bool success = await _loginWithRole(
          email: email,
          password: pass,
          role: role,
        );

        if (success) return;
      }

      _error("Invalid email or password");
    } catch (e) {
      _error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _loginWithRole({
    required String email,
    required String password,
    required int role,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "email": email,
        "password": password,
        "role": role.toString(),
      },
    );

    final Map<String, dynamic> body = jsonDecode(response.body);

    final status = body['status'];
    final bool isSuccess =
        status == true || status == 1 || status == "1";

    if (!isSuccess) return false;

    final data = body['data'];

    // Store auth data
    box.write("auth_token", data['auth_token']);
    box.write("role", data['role']);
    box.write("user_data", data);

    // Navigate based on role
    if (data['role'] == 1) {
      Get.offAll(() => Userhome());
    } else if (data['role'] == 2) {
      Get.offAll(() => MerchantDashboardPage());
    } else {
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
