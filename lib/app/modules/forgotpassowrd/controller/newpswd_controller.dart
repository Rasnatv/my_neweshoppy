import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void updatePassword() {
    if (passwordController.text == confirmPasswordController.text &&
        passwordController.text.isNotEmpty) {
      Get.snackbar("Success", "Password updated successfully!");
    } else {
      Get.snackbar("Error", "Passwords do not match!");
    }
  }
}
