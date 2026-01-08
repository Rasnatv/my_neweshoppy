
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendResetLink() {
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
      );
      return;
    }

    // 🔹 TODO: Integrate your backend / Firebase password reset here
    // Example:
    // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    Get.snackbar(
      "Reset Link Sent",
      "A password reset link has been sent to $email",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
    );

    // Optionally navigate to login screen
    // Get.off(() => const AdminLoginView());
  }
}
