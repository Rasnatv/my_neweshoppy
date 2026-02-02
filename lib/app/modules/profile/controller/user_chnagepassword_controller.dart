import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../view/profile_view.dart';

class ChangePasswordController extends GetxController {
  final box = GetStorage();
  final isLoading = false.obs;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;

      final token = box.read('auth_token'); // 🔑 token stored at login

      final response = await http.post(
        Uri.parse(
          'https://rasma.astradevelops.in/e_shoppyy/public/api/change-password',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'current_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == "1") {
        Get.back();
        Get.snackbar(
          "Success",
          data['message'],
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );

          Get.offAll(() => ProfileView()); // 👈 navigate to profile page
        }
      else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Password change failed",
          backgroundColor: const Color(0xFFE53935),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
