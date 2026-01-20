
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';

class CheckEmailOtpController extends GetxController {
  late final String email;

  final otpControllers =
  List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments as String; // 👈 from route arguments
  }

  String get otp =>
      otpControllers.map((e) => e.text).join();

  void onOtpChanged(String val, int index) {
    if (val.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
  }

  /// 🔐 VERIFY OTP API
  Future<void> verifyOtp() async {
    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter valid OTP");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/verify-otp",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "role": 1,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["status"] == "1") {
        Get.snackbar("Success", "OTP verified");

        Get.toNamed(
          Routes.NewPSWD,
          arguments: {
            "email": email,
            "otp": otp,
          },
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Invalid OTP",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() {
    Get.snackbar("Info", "Resend OTP clicked");
  }

  @override
  void onClose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
