//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../userlogin/controller/userlogin_controller.dart';
//
// class NewPasswordController extends GetxController {
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//
//   final isPasswordHidden = true.obs;
//   final isConfirmPasswordHidden = true.obs;
//   final isLoading = false.obs;
//
//   late final String email;
//   late final String otp;
//
//   @override
//   void onInit() {
//     final args = Get.arguments as Map<String, dynamic>;
//     email = args['email'];
//     otp = args['otp'];
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
//
//   void togglePasswordVisibility() {
//     isPasswordHidden.toggle();
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordHidden.toggle();
//   }
//
//   Future<void> updatePassword() async {
//     if (isLoading.value) return;
//
//     if (passwordController.text != confirmPasswordController.text) {
//       Get.snackbar("Error", "Passwords do not match");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final response = await http.post(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/reset-password",
//         ),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "email": email,
//           "otp": otp,
//           "password": passwordController.text,
//           "password_confirmation":
//           confirmPasswordController.text,
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//
//       /// ✅ SUCCESS — STOP EVERYTHING AFTER THIS
//       if (response.statusCode == 200 && data['status'] == true) {
//         Get.snackbar("Success", "Password updated successfully");
//
//         /// 🔥 CLEAR OLD CONTROLLERS
//         Get.delete<NewPasswordController>(force: true);
//         Get.delete<UserloginController>(force: true);
//
//         Get.offAllNamed('/login');
//         return;
//       }
//       Get.snackbar("Error", data['message'] ?? "Invalid OTP");
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  late final String email;
  late final String otp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    otp = args['otp'];
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.toggle();
  }

  Future<void> updatePassword() async {
    if (isLoading.value) return;

    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/reset-password",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "password": passwordController.text,
          "password_confirmation": confirmPasswordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      final message = (data['message'] ?? '').toString().toLowerCase();

      if (data['status'] == true || message.contains("password")) {
        Get.snackbar("Success", "Password updated successfully");

        /// 🔥 Navigate FIRST
        Get.offAllNamed('/login');
        return;
      }

      Get.snackbar("Error", data['message'] ?? "Invalid OTP");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
