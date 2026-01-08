import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckEmailOtpController  extends GetxController {
  // List of 6 controllers for OTP fields
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());

  // Combine entered OTP digits into one string
  String get enteredOtp => otpControllers.map((c) => c.text).join();

  // Called when a digit changes
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp() {
    final otp = enteredOtp;
    if (otp.length == 6) {
      Get.snackbar(
        "OTP Verification",
        "Entered OTP: $otp",
        backgroundColor: Colors.green.shade50,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Invalid OTP",
        "Please enter all 6 digits",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resendOtp() {
    Get.snackbar(
      "OTP Sent",
      "A new OTP has been sent to your phone number",
      backgroundColor: Colors.blue.shade50,
      colorText: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
    );
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
