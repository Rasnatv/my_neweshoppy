
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../landingview/view/landing_screen.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../../userhome/controller/district _controller.dart';

import '../../../data/errors/api_error.dart';

class UsersignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  final box = GetStorage();
  final confirmPasswordController = TextEditingController();
  RxBool isConfirmPasswordVisible = false.obs;

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  // ───────── SIGNUP ─────────
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/user/signup",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "full_name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
          "address": addressController.text.trim(),
        }),
      );

      debugPrint("📝 Signup status: ${response.statusCode}");
      debugPrint("📝 Signup body: ${response.body}");

      // ✅ HANDLE NON-200 STATUS
      if (response.statusCode != 200 &&
          response.statusCode != 201) {
        final errorMsg = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMsg);
        return;
      }

      final decodedData = jsonDecode(response.body);

      final data = decodedData["data"];
      if (data == null) {
        AppSnackbar.error("Invalid server response");
        return;
      }

      final token = data["auth_token"] ??
          data["token"] ??
          data["access_token"];

      if (token == null || token.toString().isEmpty) {
        AppSnackbar.error("Authentication token missing");
        return;
      }

      // ✅ SAVE DATA
      await box.write("auth_token", token);
      await box.write("is_logged_in", true);
      await box.write("role", 1);
      await box.write("user_data", data);

      // OPTIONAL LOCATION FETCH
      if (Get.isRegistered<UserLocationController>()) {
        Get.find<UserLocationController>().fetchLocations();
      }

      AppSnackbar.success("Welcome! Your account has been created 🎉");

      Get.offAll(() => LandingView());

    } catch (e) {
      debugPrint("❌ SIGNUP ERROR: $e");

      // ✅ HANDLE EXCEPTION
      final errorMsg = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}